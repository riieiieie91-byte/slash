const express = require("express");
const session = require("express-session");
const bcrypt = require("bcryptjs");
const multer = require("multer");
const path = require("path");
const fs = require("fs");

const app = express();
const PORT = process.env.PORT || 3000;
const ADMIN_USER = process.env.ADMIN_USER || "PTJ";
const ADMIN_PASS = process.env.ADMIN_PASS || "CHANGE_THIS_PASSWORD";

const dataDir = path.join(__dirname, "data");
const uploadDir = path.join(__dirname, "public", "uploads");
fs.mkdirSync(dataDir, { recursive: true });
fs.mkdirSync(uploadDir, { recursive: true });

const usersFile = path.join(dataDir, "users.json");
const scriptsFile = path.join(dataDir, "scripts.json");

if (!fs.existsSync(usersFile)) fs.writeFileSync(usersFile, "[]");
if (!fs.existsSync(scriptsFile)) {
  fs.writeFileSync(scriptsFile, JSON.stringify([
    {
      id: 1,
      name: "Demo Lua Script",
      image: "",
      code: "-- Dán mã Lua của bạn vào đây\nprint('PTJSCRIPT')"
    }
  ], null, 2));
}

const readJSON = f => JSON.parse(fs.readFileSync(f, "utf8"));
const writeJSON = (f, x) => fs.writeFileSync(f, JSON.stringify(x, null, 2));

app.use(express.json({limit: "2mb"}));
app.use(express.urlencoded({extended: true}));
app.use(express.static(path.join(__dirname, "public")));
app.use(session({
  secret: process.env.SESSION_SECRET || "change-this-session-secret",
  resave: false,
  saveUninitialized: false,
  cookie: { httpOnly: true, sameSite: "lax" }
}));

const upload = multer({
  storage: multer.diskStorage({
    destination: uploadDir,
    filename: (_, file, cb) => {
      const safe = Date.now() + "-" + file.originalname.replace(/[^a-zA-Z0-9._-]/g, "_");
      cb(null, safe);
    }
  }),
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (_, file, cb) => {
    if (/^image\/(png|jpe?g|webp|gif)$/.test(file.mimetype)) cb(null, true);
    else cb(new Error("Chỉ nhận PNG/JPG/WEBP/GIF."));
  }
});

function isAdmin(req) {
  return req.session.user && req.session.user.username === ADMIN_USER;
}
function requireAdmin(req, res, next) {
  if (!isAdmin(req)) return res.status(403).json({error:"Bạn không có quyền Admin."});
  next();
}

app.get("/api/me", (req,res) => {
  res.json({loggedIn: !!req.session.user, user: req.session.user || null, admin: isAdmin(req)});
});

app.post("/api/register", async (req,res) => {
  const username = String(req.body.username || "").trim();
  const password = String(req.body.password || "");
  if (!/^[A-Za-z0-9_]{3,24}$/.test(username) || password.length < 6)
    return res.status(400).json({error:"Tên đăng nhập 3-24 ký tự và mật khẩu ít nhất 6 ký tự."});
  if (username.toLowerCase() === ADMIN_USER.toLowerCase())
    return res.status(400).json({error:"Tên này dành cho Admin."});
  const users = readJSON(usersFile);
  if (users.some(u => u.username.toLowerCase() === username.toLowerCase()))
    return res.status(409).json({error:"Tên đăng nhập đã tồn tại."});
  users.push({username, password: await bcrypt.hash(password, 12)});
  writeJSON(usersFile, users);
  res.json({ok:true});
});

app.post("/api/login", async (req,res) => {
  const username = String(req.body.username || "").trim();
  const password = String(req.body.password || "");
  if (username === ADMIN_USER) {
    if (ADMIN_PASS === "CHANGE_THIS_PASSWORD")
      return res.status(500).json({error:"Hãy đặt ADMIN_PASS trước khi chạy website."});
    if (password !== ADMIN_PASS) return res.status(401).json({error:"Sai tài khoản hoặc mật khẩu."});
    req.session.user = {username: ADMIN_USER};
    return res.json({ok:true, admin:true});
  }
  const user = readJSON(usersFile).find(u => u.username === username);
  if (!user || !(await bcrypt.compare(password, user.password)))
    return res.status(401).json({error:"Sai tài khoản hoặc mật khẩu."});
  req.session.user = {username};
  res.json({ok:true, admin:false});
});

app.post("/api/logout", (req,res) => req.session.destroy(() => res.json({ok:true})));

app.get("/api/scripts", (req,res) => {
  res.json(readJSON(scriptsFile).map(s => ({id:s.id,name:s.name,image:s.image})));
});

app.get("/api/scripts/:id", (req,res) => {
  const s = readJSON(scriptsFile).find(x => x.id === Number(req.params.id));
  if (!s) return res.status(404).json({error:"Không tìm thấy script."});
  res.json(s);
});

app.post("/api/scripts", requireAdmin, upload.single("image"), (req,res) => {
  const name = String(req.body.name || "").trim();
  const code = String(req.body.code || "");
  if (!name || !code) return res.status(400).json({error:"Thiếu tên hoặc mã Lua."});
  const scripts = readJSON(scriptsFile);
  const item = {
    id: Date.now(),
    name,
    code,
    image: req.file ? "/uploads/" + req.file.filename : ""
  };
  scripts.push(item);
  writeJSON(scriptsFile, scripts);
  res.json({ok:true, script:{id:item.id,name:item.name,image:item.image}});
});

app.put("/api/scripts/:id", requireAdmin, upload.single("image"), (req,res) => {
  const scripts = readJSON(scriptsFile);
  const s = scripts.find(x => x.id === Number(req.params.id));
  if (!s) return res.status(404).json({error:"Không tìm thấy script."});
  if (req.body.name !== undefined) s.name = String(req.body.name).trim();
  if (req.body.code !== undefined) s.code = String(req.body.code);
  if (req.file) s.image = "/uploads/" + req.file.filename;
  writeJSON(scriptsFile, scripts);
  res.json({ok:true});
});

app.delete("/api/scripts/:id", requireAdmin, (req,res) => {
  const scripts = readJSON(scriptsFile);
  const next = scripts.filter(x => x.id !== Number(req.params.id));
  if (next.length === scripts.length) return res.status(404).json({error:"Không tìm thấy script."});
  writeJSON(scriptsFile, next);
  res.json({ok:true});
});

app.get("/api/scripts/:id/code", (req,res) => {
  const s = readJSON(scriptsFile).find(x => x.id === Number(req.params.id));
  if (!s) return res.status(404).send("Not found");
  res.type("text/plain").send(s.code);
});

app.use((err, req, res, next) => res.status(400).json({error: err.message || "Có lỗi xảy ra."}));

app.listen(PORT, "0.0.0.0", () => {
  console.log(`PTJSCRIPT đang chạy tại http://127.0.0.1:${PORT}`);
});