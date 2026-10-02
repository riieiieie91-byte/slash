PTJSCRIPT - CHẠY TRÊN TERMUX

1. Cài Node.js:
pkg update
pkg install nodejs

2. Giải nén file PTJSCRIPT.zip rồi cd vào thư mục:
cd PTJSCRIPT

3. Cài thư viện:
npm install

4. ĐẶT MẬT KHẨU ADMIN:
Không nên để mật khẩu thật trong source.
Ví dụ:
export ADMIN_USER="PTJ"
export ADMIN_PASS="MAT_KHAU_MOI_CUA_BAN"
export SESSION_SECRET="mot-chuoi-bi-mat-dai"

5. Chạy:
npm start

6. Mở trình duyệt:
http://127.0.0.1:3000

Admin có thể:
- Thêm script Lua
- Sửa tên
- Sửa code
- Thêm/thay hình
- Xóa script

Tài khoản đăng ký thường không có quyền Admin.

LƯU Ý:
- Đây là bản nền chạy local trên Termux.
- Nếu muốn đưa lên Internet cần thêm HTTPS, database thật, giới hạn đăng nhập và cấu hình bảo mật server.
