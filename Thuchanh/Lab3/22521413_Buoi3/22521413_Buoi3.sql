

--Phần 2. QUẢN LÝ TRUY XUẤT VÀ PHÂN QUYỀN NGƯỜI DÙNG
--Bài tập 1. Login
CREATE LOGIN thinhdm WITH PASSWORD ='3012004'
CREATE LOGIN thinhdm_master WITH PASSWORD ='3012004', DEFAULT_DATABASE = master 
CREATE LOGIN thinhdm_qldt WITH PASSWORD ='3012004', DEFAULT_DATABASE = Quanlydetai
SELECT * FROM sys.syslogins

--Bài tập 2. User và role
--1. Tạo 2 user SV1 và SV2 lần lượt cho tài khoản login 1 và 2, sau đó chụp lại bảng Sysusers và hộp thoại Database Properties.
CREATE USER SV1 FOR LOGIN thinhdm
CREATE USER SV2 FOR LOGIN thinhdm_master
SELECT * FROM SYS.SYSUSERS

/*2. Tạo 2 role LopTruong và LopPho, sau đó thêm user SV1 vào role LopTruong cho
và user SV2 vào role LopPho. Chụp lại cửa sổ Object Explorer, hộp thoại Database User
và hộp thoại Database Role Properties.*/
CREATE ROLE LopTruong
CREATE ROLE LopPho

EXEC sp_addrolemember LopTruong, SV1
EXEC sp_addrolemember LopPho, SV2

/*3. Tạo user SV3 cho tài khoản login 3, sau đó thêm user SV3 vào role db_Owner và
role db_DataReader của cơ sở dữ liệu Quản lý đề tài. Chụp lại bảng Sysusers, các hộp
thoại Database Properties, Database User và Database Role Properties */
CREATE USER SV3 FOR LOGIN thinhdm_qldt
EXEC sp_addrolemember db_Owner, SV3
EXEC sp_addrolemember db_DataReader, SV3

SELECT * FROM SYS.SYSUSERS
--4. Xóa các user đã tạo ở các câu trên, chụp lại bảng Sysusers và cửa sổ Object Explorer.
USE master
DROP USER SV1
DROP USER SV2
DROP USER SV3

USE Quanlydetai
DROP USER SV3

SELECT * FROM SYS.SYSUSERS

--5. Xóa tài khoản login 2 và 3 đã tạo ở câu a1, sau đó chụp lại bảng Syslogins.

USE master
DROP LOGIN thinhdm_master
SELECT * FROM SYS.Syslogins

use Quanlydetai
DROP LOGIN thinhdm_qldt
SELECT * FROM SYS.Syslogins

--Bài tập 3. Vận dụng 1: Xác thực người dùng
--1. Tạo 6 login từ l1 đến l6 không có mật khẩu, sau đó chụp lại bảng Syslogins.
CREATE LOGIN l1 WITH PASSWORD =''
CREATE LOGIN l2 WITH PASSWORD =''
CREATE LOGIN l3 WITH PASSWORD =''
CREATE LOGIN l4 WITH PASSWORD =''
CREATE LOGIN l5 WITH PASSWORD =''
CREATE LOGIN l6 WITH PASSWORD =''


--2. Tạo 6 user từ u1 đến u6 lần lượt tương ứng với 6 login đã tạo ở trên, sau đó chụp lại hộp thoại Database Properties.
CREATE USER u1 FOR LOGIN l1
CREATE USER u2 FOR LOGIN l2
CREATE USER u3 FOR LOGIN l3
CREATE USER u4 FOR LOGIN l4
CREATE USER u5 FOR LOGIN l5
CREATE USER u6 FOR LOGIN l6
--3. Tạo 3 role từ r1 đến r3, sau đó chụp lại cửa sổ Object Explorer.
CREATE ROLE r1
CREATE ROLE r2
CREATE ROLE r3


/*CAU 4: Tạo nhóm như sau và chụp lại hộp thoại Database User và Database Role Properties:
• u1 thuộc r1.
• u2, u3 thuộc r2.
• u4, u5, u6 thuộc r3.*/

EXEC sp_addrolemember r1,u1

EXEC sp_addrolemember r2,u2
EXEC sp_addrolemember r2,u3

EXEC sp_addrolemember r3,u4
EXEC sp_addrolemember r3,u5
EXEC sp_addrolemember r3,u6

/*5. Thực hiện:
• r1 thành viên của db_DataReader.
• r2 thành viên của db_Owner, db_Accessadmin.
• r3 thành viên của db_SecurityAdmin, db_Owner, db_Accessadmin.*/
EXEC sp_addrolemember db_DataReader, r1

EXEC sp_addrolemember db_Owner, r2
EXEC sp_addrolemember db_Accessadmin, r2

EXEC sp_addrolemember db_SecurityAdmin, r3
EXEC sp_addrolemember db_Owner, r3
EXEC sp_addrolemember db_Accessadmin, r3

--Bài tập 4. Phân quyền người dùng
--1
CREATE TABLE T1(
    C11 INT PRIMARY KEY,
    C12 VARCHAR(10)
)

CREATE TABLE T2(
    C21 INT PRIMARY KEY,
    C22 VARCHAR(10)
)

CREATE TABLE T3(
    C31 INT PRIMARY KEY,
    C32 VARCHAR(10)
)

--2
CREATE LOGIN Lo1 WITH PASSWORD=''
CREATE LOGIN Lo2 WITH PASSWORD=''
CREATE LOGIN Lo3 WITH PASSWORD=''
SELECT * FROM SYS.Syslogins

--3
CREATE USER Us1 FOR LOGIN Lo1 
CREATE USER Us2 FOR LOGIN Lo2 
CREATE USER Us3 FOR LOGIN Lo3 

--4
GRANT SELECT,DELETE ON T1 TO Us1
GRANT SELECT,DELETE ON T3 TO Us1

GRANT UPDATE,DELETE ON T2 TO Us2

GRANT INSERT ON T1 TO Us3
GRANT INSERT ON T2 TO Us3
GRANT INSERT ON T3 TO Us3

DENY INSERT ON T1 TO Us1
DENY INSERT ON T2 TO Us1

DENY DELETE ON T3 TO Us2

--5
REVOKE SELECT, DELETE ON T1 TO Us1
REVOKE SELECT, DELETE ON T3 TO Us1

REVOKE update, DELETE ON T2 TO Us2

REVOKE INSERT ON T1 TO Us3
REVOKE INSERT ON T2 TO Us3
REVOKE INSERT ON T3 TO Us3




