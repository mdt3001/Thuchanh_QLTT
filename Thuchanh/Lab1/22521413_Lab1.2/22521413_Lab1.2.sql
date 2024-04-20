CREATE DATABASE Quanlydetai
use Quanlydetai

CREATE TABLE SINHVIEN(
    MSSV CHAR(8) PRIMARY KEY,
    TENSV NVARCHAR(30) NOT NULL,
    SODT VARCHAR(10),
    LOP CHAR(10) NOT NULL,
    DIACHI NCHAR(50) NOT NULL,
)

CREATE TABLE DETAI(
    MSDT CHAR(6) PRIMARY KEY,
    TENDT NVARCHAR(30) NOT NULL,
)

CREATE TABLE SV_DETAI(
    MSSV CHAR(8) FOREIGN KEY (MSSV) REFERENCES SINHVIEN (MSSV),
    MSDT CHAR(6) FOREIGN KEY (MSDT) REFERENCES DETAI (MSDT),
)

CREATE TABLE HOCVI(
    MSHV INT PRIMARY KEY,
    TENHV NVARCHAR(20) NOT NULL,
)

CREATE TABLE HOCHAM(
    MSHH INT PRIMARY KEY,
    TENHH NVARCHAR(20) NOT NULL,
)

CREATE TABLE GIAOVIEN(
    MSGV CHAR(5) PRIMARY KEY,
    TENGV NVARCHAR(30) NOT NULL,
    DIACHI NVARCHAR(50) NOT NULL,
    SODT VARCHAR(10) NOT NULL,
    MSHH INT FOREIGN KEY (MSHH) REFERENCES HOCHAM (MSHH),
    NAMHH SMALLDATETIME NOT NULL,
)

SELECT* FROM GIAOVIEN

CREATE TABLE CHUYENNGANH(
    MSCN INT PRIMARY KEY,
    TENCN NVARCHAR(30) NOT NULL,
)

CREATE TABLE GV_HV_CN(
    MSGV CHAR(5),
    MSHV INT,
    MSCN INT,
    PRIMARY KEY (MSGV,MSHV,MSCN),
    NAM SMALLDATETIME NOT NULL,
    
    FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV),
    FOREIGN KEY (MSHV) REFERENCES HOCVI(MSHV),
    FOREIGN KEY (MSCN) REFERENCES CHUYENNGANH(MSCN),
)

CREATE TABLE GV_HDDT(
    MSGV CHAR(5),
    MSDT CHAR(6),
    DIEM FLOAT NOT NULL,
    PRIMARY KEY (MSGV, MSDT),
    FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV),
    FOREIGN KEY (MSDT) REFERENCES DETAI(MSDT),
)

CREATE TABLE GV_PBDT(
    MSGV CHAR(5),
    MSDT CHAR(6),
    DIEM FLOAT NOT NULL,
    PRIMARY KEY (MSGV,MSDT),
    FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV),
    FOREIGN KEY (MSDT) REFERENCES DETAI(MSDT),
)

CREATE TABLE GV_UVDT(
    MSGV CHAR(5),
    MSDT CHAR(6),
    DIEM FLOAT NOT NULL,
    PRIMARY KEY (MSGV,MSDT),
    FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV),
    FOREIGN KEY (MSDT) REFERENCES DETAI(MSDT),
)

CREATE TABLE HOIDONG(
    MSHD INT PRIMARY KEY,
    PHONG CHAR(3),
    TGBD SMALLDATETIME,
    NGAYHD SMALLDATETIME NOT NULL,
    TINHTRANG NVARCHAR(30) NOT NULL,
    MSGV CHAR(5) FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV)
)

CREATE TABLE HOIDONG_GV(
    MSHD INT,
    MSGV CHAR(5),
    PRIMARY KEY (MSHD,MSGV),
    FOREIGN KEY (MSHD) REFERENCES HOIDONG(MSHD),
    FOREIGN KEY (MSGV) REFERENCES GIAOVIEN(MSGV),
)

CREATE TABLE HOIDONG_DT(
    MSHD INT,
    MSDT CHAR(6),
    QUYETDINH NCHAR(10),
    PRIMARY KEY (MSHD,MSDT),
    FOREIGN KEY (MSHD) REFERENCES HOIDONG(MSHD),
    FOREIGN KEY (MSDT) REFERENCES DETAI(MSDT),
)

-- Insert data into SINHVIEN table
INSERT INTO SINHVIEN (MSSV, TENSV, SODT, LOP, DIACHI)
VALUES 
    ('13520001', N'Nguyễn Văn An', '0906762255', 'SE103.U32', N'THỦ ĐỨC'),
    ('13520002', N'Phan Tấn Đạt', '0975672350', 'IE204.T21', N'QUẬN 1'),
    ('13520003', N'Nguyễn Anh Hải', '0947578688', 'IE205.R12', N'QUẬN 9'),
    ('13520004', N'Phạm Tài', '0956757869', 'IE202.A22', N'QUẬN 1'),
    ('13520005', N'Lê Thúy Hằng', '0976668688', 'SE304.E22', N'THỦ ĐỨC'),
    ('13520006', N'Ưng Hồng Ân', '0957475898', 'IE208.F33', N'QUẬN 2');


-- Insert data into DETAI table
INSERT INTO DETAI (MSDT, TENDT)
VALUES 
    ('97001', N'Quản lý thư viện'),
    ('97002', N'Nhận dạng vân tay'),
    ('97003', N'Bán đấu giá trên mạng'),
    ('97004', N'Quản lý siêu thị'),
    ('97005', N'Xử lý ảnh'),
    ('97006', N'Hệ giải toán thông minh');

-- Insert data into SV_DETAI table
INSERT INTO SV_DETAI (MSSV, MSDT)
VALUES 
    ('13520001', '97004'),
    ('13520002', '97005'),
    ('13520003', '97001'),
    ('13520004', '97002'),
    ('13520005', '97003'),
    ('13520006', '97005');


-- Insert data into HOCHAM table
INSERT INTO HOCHAM (MSHH, TENHH)
VALUES 
    ('1', N'Phó giáo sư'),
    ('2', N'Giáo sư');    


-- Insert data into GIAOVIEN table
INSERT INTO GIAOVIEN 
VALUES 
    ('00201', N'Trần Trung', N'Bến Tre', '35353535', '1', '2020'),
    ('00202', N'Nguyễn Văn An', N'Tiền Giang', '67868688', '1', '2016'),
    ('00203', N'Trần Thu Trang', N'Cần Thơ', '74758687', '1', '2019'),
    ('00204', N'Nguyễn Thị Loan', N'TP. HCM', '56575868', '2', '2021'),
    ('00205', N'Chu Tiến', 'Hà Nội', N'46466646', '2', '2022');
-- Insert data into HOCVI table
INSERT INTO HOCVI (MSHV, TENHV)
VALUES 
    ('1', N'Kỹ sư'),
    ('2', N'Cử nhân'),
    ('3', N'Thạc sĩ'),
    ('4', N'Tiến sĩ'),
    ('5', N'Tiến sĩ Khoa học');

-- Insert data into CHUYENNGANH table
INSERT INTO CHUYENNGANH (MSCN, TENCN)
VALUES 
    ('1', N'Công nghệ Web'),
    ('2', N'Mạng xã hội'),
    ('3', N'Quản lý CNTT'),
    ('4', N'GIS');

-- Insert data into GV_HV_CN table
INSERT INTO GV_HV_CN (MSGV, MSHV, MSCN, NAM)
VALUES 
    ('00201', '1', '1', '2013'),
    ('00201', '1', '2', '2013'),
    ('00201', '2', '1', '2014'),
    ('00202', '3', '2', '2013'),
    ('00203', '2', '4', '2014'),
    ('00204', '3', '2', '2014');
-- Insert data into GV_HDDT table
INSERT INTO GV_HDDT (MSGV, MSDT, DIEM)
VALUES 
    ('00201', '97001', '8'),
    ('00202', '97002', '7'),
    ('00205', '97001', '9'),
    ('00204', '97004', '7'),
    ('00203', '97005', '9');
-- Insert data into GV_PBDT table
INSERT INTO GV_PBDT (MSGV, MSDT, DIEM)
VALUES 
    ('00201', '97005', '8'),
    ('00202', '97001', '7'),
    ('00205', '97004', '9'),
    ('00204', '97003', '7'),
    ('00203', '97002', '9');

-- Insert data into GV_UVDT table
INSERT INTO GV_UVDT (MSGV, MSDT, DIEM)
VALUES 
    ('00205', '97005', '8'),
    ('00202', '97005', '7'),
    ('00204', '97005', '9'),
    ('00203', '97001', '7'),
    ('00204', '97001', '9'),
    ('00205', '97001', '8'),
    ('00203', '97003', '7'),
    ('00201', '97003', '9'),
    ('00202', '97003', '7'),
    ('00201', '97004', '9'),
    ('00202', '97004', '8'),
    ('00203', '97004', '7'),
    ('00201', '97002', '9'),
    ('00204', '97002', '7'),
    ('00205', '97002', '9'),
    ('00201', '97006', '9'),
    ('00202', '97006', '7'),
    ('00204', '97006', '9');

-- Insert data into HOIDONG table
INSERT INTO HOIDONG (MSHD, PHONG, TGBD, NGAYHD, TINHTRANG, MSGV)
VALUES 
    ('1', '002', '7:00', '2014-11-29', N'Thật', '00201'),
    ('2', '102', '7:00', '2014-12-05', N'Thật', '00202'),
    ('3', '003', '8:00', '2014-12-06', N'Thật', '00203');

-- Insert data into HOIDONG_GV table
INSERT INTO HOIDONG_GV (MSHD, MSGV)
VALUES 
    ('1', '00201'),
    ('1', '00202'),
    ('1', '00203'),
    ('1', '00204'),
    ('2', '00203'),
    ('2', '00202'),
    ('2', '00205'),
    ('2', '00204'),
    ('3', '00201'),
    ('3', '00202'),
    ('3', '00203'),
    ('3', '00204');

-- Insert data into HOIDONG_DT table
INSERT INTO HOIDONG_DT (MSHD, MSDT, QUYETDINH)
VALUES 
    ('1', '97001', N'Được'),
    ('1', '97002', N'Được'),
    ('2', '97001', N'Không'),
    ('2', '97004', N'Không'),
    ('1', '97005', N'Được'),
    ('3', '97001', N'Không'),
    ('3', '97002', N'Được');



--d. Thực hiện các truy vấn sau bằng ngôn ngữ SQL:
--d1. Với những sinh viên tham gia lớp có mã lớp (LOP) bắt đầu bằng ký hiệu ‘IE’, liệt kê MSSV, TENSV và mã lớp (LOP) mà sinh viên đó tham gia.
SELECT MSSV, TENSV, LOP 
FROM SINHVIEN
WHERE LOP LIKE 'IE%';

--d2. Cho biết số lượng sinh viên sống ở ‘QUẬN 1’ (DIACHI).
SELECT COUNT(MSSV) as Soluongsinhvienq1
FROM SINHVIEN
WHERE DIACHI = 'QUẬN 1'

--d3. Cho biết danh sách giáo viên gồm MSGV, TENGV, DIACHI, SODT, TENHH của từng giáo viên.
SELECT MSGV, TENGV, DIACHI, SODT, TENHH
FROM GIAOVIEN , HOCHAM
WHERE GIAOVIEN.MSHH=HOCHAM.MSHH

--d4. Cho biết danh sách đề tài gồm MSDT, TENDT và số lượng sinh viên thực hiện của mỗi đề tài (nếu có).
SELECT DT.MSDT, TENDT, COUNT (SVDT.MSSV) AS SLUONGSINHVIENTHUCHIEN
FROM DETAI DT LEFT JOIN SV_DETAI SVDT
ON DT.MSDT=SVDT.MSDT
GROUP BY DT.MSDT, TENDT


--d5. Liệt kê danh sách đề tài (MSDT, TENDT) và tên giáo viên hướng dẫn (TENGV) tương ứng, sắp xếp theo mã số đề tài tăng dần.
SELECT DT.MSDT, TENDT, TENGV
FROM DETAI DT JOIN GV_HDDT GVHD
ON DT.MSDT=GVHD.MSDT
JOIN GIAOVIEN GV
ON GVHD.MSGV=GV.MSGV
ORDER BY DT.MSDT ASC

--d6. Cho biết số lượng đề tài (SLDT) đã hướng dẫn ứng với từng giáo viên (TENGV).

SELECT GV.MSGV, TENGV, COUNT(MSDT) AS SLUONGDETAI
FROM GIAOVIEN GV , GV_HDDT HD
WHERE GV.MSGV=HD.MSGV
GROUP BY GV.MSGV, TENGV

--d7. Liệt kê danh sách giáo viên (MSGV, TENGV) chưa hướng dẫn đề tài nào.
SELECT MSGV,TENGV 
FROM GIAOVIEN
EXCEPT
SELECT HD.MSGV,TENGV
FROM GV_HDDT HD, GIAOVIEN GV
WHERE HD.MSGV=GV.MSGV

--d8. Cho biết giáo viên (MSGV, TENGV) nào hướng dẫn nhiều đề tài nhất.
SELECT HD.MSGV,TENGV
FROM GV_HDDT HD, GIAOVIEN GV
WHERE HD.MSGV=GV.MSGV
GROUP BY HD.MSGV,TENGV
HAVING COUNT(MSDT)>=ALL(SELECT COUNT(MSDT)
                    FROM GV_HDDT
                    GROUP BY MSGV)

--d9*. Liệt kê danh sách giáo vên theo định dạng sau: MSGV, <TENHV TENGV>

SELECT DISTINCT CONCAT(GV.MSGV,', ',TENHV,' ',TENGV)
FROM GIAOVIEN GV JOIN GV_HV_CN  
ON GV.MSGV= GV_HV_CN.MSGV
JOIN HOCVI
ON GV_HV_CN.MSHV=HOCVI.MSHV

--d10*. Liệt kê danh sách giáo viên theo định dạng sau: <TENHV TENCN>. TENGV.

SELECT DISTINCT CONCAT(TENHV,' ',TENCN,'. ', TENGV)
FROM GIAOVIEN GV JOIN GV_HV_CN 
ON GV.MSGV= GV_HV_CN.MSGV
JOIN HOCVI HV
ON GV_HV_CN.MSHV=HV.MSHV
JOIN CHUYENNGANH CN
ON GV_HV_CN.MSCN=CN.MSCN





