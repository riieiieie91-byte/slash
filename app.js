let authMode="login", currentCode="";

async function api(url, options={}) {
  const r=await fetch(url, options);
  const data=await r.json().catch(()=>({}));
  if(!r.ok) throw new Error(data.error||"Có lỗi.");
  return data;
}
async function load(){
  const me=await api("/api/me");
  document.getElementById("adminBtn").classList.toggle("hidden",!me.admin);
  document.getElementById("logoutBtn").classList.toggle("hidden",!me.loggedIn);
  const scripts=await api("/api/scripts");
  const grid=document.getElementById("grid");
  grid.innerHTML=scripts.map(s=>`
    <article class="card">
      ${s.image?`<img src="${s.image}" alt="">`:`<div class="noimg">LUA</div>`}
      <div class="cardbody"><h3>${esc(s.name)}</h3>
      <button onclick="viewScript(${s.id})">GET SCRIPT</button></div>
    </article>`).join("");
}
function esc(x){return String(x).replace(/[&<>"']/g,m=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[m]));}
function openAuth(){document.getElementById("auth").classList.remove("hidden")}
function switchAuth(){authMode=authMode==="login"?"register":"login";document.getElementById("authTitle").textContent=authMode==="login"?"Đăng nhập":"Đăng ký";document.querySelector("#auth .mainBtn").textContent=authMode==="login"?"Đăng nhập":"Đăng ký";document.querySelector(".linkBtn").textContent=authMode==="login"?"Chuyển sang đăng ký":"Chuyển sang đăng nhập";}
async function login(){
  const username=document.getElementById("username").value,password=document.getElementById("password").value;
  try{await api(authMode==="login"?"/api/login":"/api/register",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify({username,password})});
    if(authMode==="register"){authMode="login";switchAuth();document.getElementById("msg").textContent="Đăng ký thành công, hãy đăng nhập.";return;}
    closeAll();load();
  }catch(e){document.getElementById("msg").textContent=e.message}
}
async function logout(){await api("/api/logout",{method:"POST"});load()}
async function viewScript(id){const s=await api("/api/scripts/"+id);currentCode=s.code;document.getElementById("viewTitle").textContent=s.name;document.getElementById("code").textContent=s.code;document.getElementById("view").classList.remove("hidden")}
async function copyCode(){await navigator.clipboard.writeText(currentCode);alert("Đã copy mã Lua.");}
async function openAdmin(){document.getElementById("admin").classList.remove("hidden");const scripts=await api("/api/scripts");document.getElementById("adminList").innerHTML=scripts.map(s=>`<div class="adminItem"><span>${esc(s.name)}</span><span><button onclick="editScript(${s.id})">SỬA</button><button onclick="deleteScript(${s.id})">XÓA</button></span></div>`).join("")}
async function saveScript(){
  const fd=new FormData();fd.append("name",document.getElementById("sname").value);fd.append("code",document.getElementById("scode").value);
  if(document.getElementById("simage").files[0])fd.append("image",document.getElementById("simage").files[0]);
  try{await api("/api/scripts",{method:"POST",body:fd});document.getElementById("sname").value="";document.getElementById("scode").value="";document.getElementById("simage").value="";openAdmin();load();}catch(e){alert(e.message)}
}
async function editScript(id){
  const s=await api("/api/scripts/"+id);
  document.getElementById("sname").value=s.name;document.getElementById("scode").value=s.code;
  const old=window.saveScript;
  window.saveScript=async()=>{const fd=new FormData();fd.append("name",document.getElementById("sname").value);fd.append("code",document.getElementById("scode").value);if(document.getElementById("simage").files[0])fd.append("image",document.getElementById("simage").files[0]);try{await api("/api/scripts/"+id,{method:"PUT",body:fd});window.saveScript=old;load();openAdmin();}catch(e){alert(e.message)}};
  document.querySelector("#admin .mainBtn").textContent="LƯU THAY ĐỔI";
}
async function deleteScript(id){if(!confirm("Xóa script này?"))return;await api("/api/scripts/"+id,{method:"DELETE"});load();openAdmin()}
function closeAll(){document.querySelectorAll(".modal").forEach(x=>x.classList.add("hidden"))}
load();