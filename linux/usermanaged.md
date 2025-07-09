 1. Các loại tài khoản người dùng
Linux phân loại người dùng thành ba nhóm chính:
- Root (Superuser): Có toàn quyền truy cập hệ thống.
- System Users: Được tạo để chạy các dịch vụ (như www-data, mysql, daemon).
- Regular Users: Người dùng thông thường, có quyền hạn chế.

📁 2. Các tệp cấu hình chính
Linux lưu thông tin người dùng và nhóm trong các tệp văn bản:
| Tệp | Mục đích | 
| /etc/passwd | Lưu thông tin cơ bản của người dùng (username, UID, GID, shell, home directory) | 
| /etc/shadow | Lưu mật khẩu đã mã hóa và thông tin hết hạn mật khẩu | 
| /etc/group | Lưu thông tin nhóm và thành viên nhóm | 
| /etc/gshadow | Lưu mật khẩu nhóm và quyền quản lý nhóm | 

1/1/1970


simple link : symbolic link -  symlink soft links


🛠️ 3. Các lệnh quản lý người dùng
Một số lệnh phổ biến:
- useradd, adduser: Tạo người dùng mới
- usermod: Sửa thông tin người dùng
- userdel: Xóa người dùng
- passwd: Đặt hoặc thay đổi mật khẩu
- groupadd, groupdel, groupmod: Quản lý nhóm
- chage: Quản lý thời hạn mật khẩu

🧩 4. Mô hình phân quyền
Linux sử dụng UID (User ID) và GID (Group ID) để xác định quyền truy cập:
- Mỗi tệp/tài nguyên có 3 cấp quyền: Chủ sở hữu (owner), nhóm (group), và người khác (others)
- Quyền được biểu diễn bằng r (read), w (write), x (execute)
- Dùng lệnh chmod, chown, chgrp để thay đổi quyền

🔐 5. Cơ chế sudo và su
- su: Chuyển sang người dùng khác (thường là root)
- sudo: Thực thi lệnh với quyền root, nhưng có kiểm soát và ghi log

Nếu bạn muốn mình minh họa bằng sơ đồ kiến trúc hoặc hướng dẫn từng bước tạo người dùng và phân quyền, mình có thể giúp ngay. Bạn muốn đi sâu vào phần nào hơn?

### Permission ref
   resource type 	owner	group	others		symbol	meaning	digit number
        -	rw-	r--	r--		r	reading	4
        7	7	7		w	write	2
        0	0	0		x	execution	1
