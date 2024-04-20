USE Quanlydetai
-->Phần 1. THỦ TỤC LƯU TRỮ<--

--Bài tập 1. Thủ tục lưu trữ không có tham số vào
-- 1. Yêu cầu: In ra danh sách sinh viên (MSSV, TENSV) có trong bảng SINHVIEN.
GO
CREATE PROCEDURE IN_DSSV
AS
BEGIN
SELECT MSSV, TENSV
FROM SINHVIEN
END

EXEC IN_DSSV
--6. Yêu cầu: In ra danh sách đề tài (TENDT) và số lượng sinh viên thực hiện của mỗi đề tài.
GO
CREATE PROC IN_DSDT_SLSVTH
AS 
BEGIN
SELECT DT.TENDT, COUNT(MSSV) AS SOLUONGSINHVIENTHUCHIEN
FROM DETAI DT JOIN SV_DETAI SVDT
ON DT.MSDT=SVDT.MSDT
GROUP BY DT.TENDT
END

EXEC IN_DSDT_SLSVTH
--8*. Yêu cầu: In ra danh sách giáo vên theo định dạng: <TENHV TENGV> (Lưu ý:
--Trường hợp giáo viên có đạt học vị ở nhiều chuyên ngành khác nhau thì chỉ in ra một lần)
/*Ví dụ:
Tiến sĩ Nguyễn Văn A
Thạc sĩ Lê Thị B */
GO
CREATE PROC IN_DSGV_THEODD
AS
BEGIN
SELECT DISTINCT CONCAT(TENHV,' ',TENGV)
FROM HOCVI HV JOIN GV_HV_CN GVHV
ON HV.MSHV= GVHV.MSHV
JOIN GIAOVIEN GV
ON GVHV.MSGV=GV.MSGV
END
EXEC IN_DSGV_THEODD
--9*. Yêu cầu: In ra danh sách giáo viên (TENGV), học vị (TENHV) và chuyên ngành (TENCN) mà giáo viên đó đã đạt được.
GO 
CREATE PROC IN_DSGV_HV_CN
AS 
BEGIN
SELECT GV.TENGV TEN_GV, TENHV TEN_HV, TENCN TEN_CN
FROM GIAOVIEN GV JOIN GV_HV_CN G 
ON GV.MSGV=G.MSGV
JOIN HOCVI HV 
ON G.MSHV=HV.MSHV
JOIN CHUYENNGANH CN 
ON G.MSCN=CN.MSCN
END

EXEC IN_DSGV_HV_CN

--Bài tập 2. Thủ tục lưu trữ có tham số vào
--a. Thủ tục lưu trữ có một tham số vào
/*2. Tham số đưa vào: MSDT.
Yêu cầu: In ra tên các đề tài tương ứng (TENDT).
Thực thi với các trường hợp tham số:
• ‘97004’.
• ‘97006’.
• ‘97090’.*/
GO
CREATE PROCEDURE TimTenDeTai
@msdt char(6)
AS 
BEGIN 
     SELECT TENDT 
     FROM DETAI
     WHERE MSDT=@msdt;
END

EXEC TimTenDeTai '97004'
EXEC TimTenDeTai '97006'
EXEC TimTenDeTai '97090'

/*3. Tham số đưa vào: MSHD.
Yêu cầu: In ra thông tin của hội đồng đó (PHONG, TGBD, NGAYHD, TINHTRANG).
Thực thi với các trường hợp tham số:
• 1.
• 3.
• 10 .*/

GO
CREATE PROCEDURE InThongTinHoiDong
@MSHD INT 
AS
BEGIN
     SELECT PHONG, TGBD, NGAYHD, TINHTRANG
     FROM HOIDONG
     WHERE MSHD=@MSHD
END
 
EXEC InThongTinHoiDong 1
EXEC InThongTinHoiDong 3
EXEC InThongTinHoiDong 10
/*6*. Tham số đưa vào: MSGV.
Yêu cầu: In ra họ tên (TENGV) và tên học vị (TENHV) của giáo viên đó theo định
dạng: <TENHV TENGV> (Lưu ý: Trường hợp giáo viên đạt một học vị ở nhiều chuyên ngành
thì chỉ in ra một lần).
Ví dụ:
Tiến sĩ Nguyễn Văn A
Thạc sĩ Lê Thị B
Thực thi với các trường hợp tham số:
• ‘00201’.
• ‘00204’.
• ‘00206’.*/
GO 
CREATE PROC IN_HOTENGV_TENHV_THEO_MSGV
@MSGV CHAR(5)
AS
BEGIN
     SELECT DISTINCT CONCAT(TENHV,' ',TENGV)
     FROM HOCVI HV JOIN GV_HV_CN GVHV
     ON HV.MSHV= GVHV.MSHV
     JOIN GIAOVIEN GV
     ON GVHV.MSGV=GV.MSGV
     WHERE GV.MSGV=@MSGV
END
EXEC IN_HOTENGV_TENHV_THEO_MSGV '00201'
EXEC IN_HOTENGV_TENHV_THEO_MSGV '00204'
EXEC IN_HOTENGV_TENHV_THEO_MSGV '00206'
--b. Thủ tục lưu trữ có nhiều tham số vào
/*8. Tham số đưa vào: MSGV, TENGV, SODT, DIACHI, MSHH, NAMHH.
Yêu cầu: Thêm dữ liệu mới vào bảng GIAOVIEN với các thông tin được đưa vào.
Trước khi thêm dữ liệu, cần kiểm tra MSHH đã tồn tại trong bảng HOCHAM chưa, nếu
chưa thì thông báo ‘Không tìm thấy mã học hàm’ và trả về giá trị 0, ngược lại thì thêm dữ
liệu mới, thông báo ‘Thêm dữ liệu thành công’ và trả về giá trị 1.
Thực thi với các trường hợp tham số:
• ‘00269’, N‘Trần Thị Bưởi’, ‘123 L.A.’, ‘0969969966’, 7, ‘2069’.
• ‘00269’, N‘Trần Thị Bưởi’, ‘123 L.A.’, ‘0969969966’, 1, ‘2069’.
• ‘00232’, N‘Lê Minh Tấn’, ‘135 C.F.’, ‘0123456789’, 2, ‘1990’.*/
GO
CREATE PROC THEMGV @MSGV CHAR(5) , @TENGV NVARCHAR(30), @SODT VARCHAR(10) , @DIACHI NVARCHAR(50), @MSHH INT, @NAMHH SMALLDATETIME
AS
BEGIN
    IF EXISTS( SELECT *FROM HOCHAM WHERE MSHH=@MSHH)
    BEGIN 
    INSERT INTO GIAOVIEN (MSGV, TENGV, SODT, DIACHI, MSHH, NAMHH) VALUES(@MSGV, @TENGV, @SODT, @DIACHI, @MSHH, @NAMHH)
    PRINT N'THÊM DỮ LIỆU THÀNH CÔNG'
    RETURN 1
    END
    ELSE
    BEGIN
    PRINT N'KHÔNG TÌM THẤY MÃ HỌC HỌC HÀM'
    RETURN 0
    END 
END 

EXEC THEMGV @MSGV='00269',@TENGV=N'Trần Thị Bưởi',@DIACHI='123 L.A.',@SODT='0969969966',@MSHH=7,@NAMHH='2069'
EXEC THEMGV @MSGV='00269',@TENGV=N'Trần Thị Bưởi',@DIACHI='123 L.A.',@SODT='0969969966',@MSHH=1,@NAMHH='2069'
EXEC THEMGV @MSGV='00232',@TENGV=N'Lê Minh Tấn',@DIACHI='135 C.F.',@SODT='0123456789',@MSHH=2,@NAMHH='1990'
/*11. Tham số đưa vào: MSDT cũ, TENDT mới.
Yêu cầu: Cập nhật tên đề tài mới với mã đề tài cũ không đổi. Trước khi cập nhật,
cần kiểm tra xem MSDT đã tồn tại trong bảng DETAI chưa, nếu không tìm thấy thì thông
báo ‘Không tìm thấy mã số đề tài’ và trả về giá trị 0, ngược lại thì cập nhật dữ liệu, thông
báo ‘Cập nhật dữ liệu thành công’ và trả về giá trị 1.
Thực thi với các trường hợp tham số:
• ‘97002’, N‘Nhận dạng khuôn mặt’.
• ‘97005’, N‘Phần mềm xử lý ảnh’.
• ‘97009’, N‘Quản lý trường đại học’.*/

GO
CREATE PROC CAPNHAT_DETAI @MSDT CHAR(6), @TENDT NVARCHAR(30)
AS
BEGIN
     IF EXISTS(SELECT * FROM DETAI WHERE MSDT=@MSDT)
          BEGIN
               UPDATE DETAI
               SET TENDT=@TENDT
               WHERE MSDT=@MSDT
               PRINT N'THÊM DỮ LIỆU THÀNH CÔNG'
               RETURN 1
          END 
     ELSE
         BEGIN 
               PRINT N'KHÔNG TÌM THẤY MÃ SỐ ĐỀ TÀI'
               RETURN 0 
          END
END

EXEC CAPNHAT_DETAI '97002', N'Nhận dạng khuôn mặt'
EXEC CAPNHAT_DETAI '97005', N'Phần mềm xử lý ảnh'
EXEC CAPNHAT_DETAI '97009', N'Quản lý trường đại học'



--Bài tập 3. Thủ tục lưu trữ có tham số vào và tham số ra
/*1. Tham số đưa vào: TENGV.
Tham số trả ra: SDT.
Yêu cầu: Đưa vào họ tên giáo viên (TENGV), trả ra số điện thoại (SDT) của giáo viên
đó, nếu không tìm thấy giáo viên tương ứng thì thông báo ‘Không tìm thấy giáo viên’ và
trả về giá trị 0.
Thực thi với các trường hợp tham số:
• N‘Nguyễn Văn An’.
• N‘Chu Tiến’.
• N‘Lê Quang Danh’.
* Nếu có nhiều giáo viên trùng tên thì có báo lỗi không, tại sao? Làm sao để hiện
thông báo có bao nhiêu giáo viên trùng tên và trả về các SDT?*/

GO
CREATE PROC TIM_SODT @TENGV NVARCHAR(30), @SODT VARCHAR(10) OUT 
AS 
BEGIN 
     IF EXISTS (SELECT * FROM GIAOVIEN 
                    WHERE TENGV=@TENGV)
               SELECT @SODT=SODT FROM GIAOVIEN
               WHERE TENGV=@TENGV
     ELSE 
     BEGIN
          PRINT N'KHÔNG TÌM THẤY GIÁO VIÊN'
          RETURN 0
     END
END

GO 
DECLARE @sodt VARCHAR(10)
EXEC TIM_SODT @TENGV=N'Nguyễn Văn An',@SODT=@sodt OUT
PRINT @sodt
DECLARE @sodt VARCHAR(10)
EXEC TIM_SODT @TENGV= N'Chu Tiến',@SODT=@sodt OUT
PRINT @sodt
DECLARE @sodt VARCHAR(10)
EXEC TIM_SODT @TENGV=N'Lê Quang Danh',@SODT=@sodt OUT
PRINT @sodt

/*3. Tham số đưa vào: TENHV.
Tham số trả ra: SLGV.
Yêu cầu: Đưa vào tên học vị (TENHV), trả ra số lượng giáo viên (SLGV) đạt học vị đó,
nếu không tìm thấy học vị tương ứng thì thông báo ‘Không tìm thấy học vị’ và trả về giá
trị 0.
Thực thi với các trường hợp tham số:
• N‘Kỹ sư’.
• N‘Thạc sĩ’.
• N‘Bác sĩ’.
*/
 GO
 CREATE PROC IN_SLGV @TENHV NVARCHAR(20), @SLGV INT OUT 
 AS
 BEGIN
     IF EXISTS (SELECT * FROM HOCVI 
                    WHERE TENHV=@TENHV)
          SELECT @SLGV=COUNT(MSGV)
          FROM GV_HV_CN G JOIN HOCVI HV
          ON G.MSHV=HV.MSHV
          WHERE TENHV=@TENHV
     ELSE 
          BEGIN
          PRINT N'KHÔNG TÌM THẤY HỌC VỊ'
          RETURN 0
          END 
 END 

GO 
DECLARE @slgv INT 
EXEC IN_SLGV @TENHV=N'Kỹ sư', @SLGV=@slgv OUT 
PRINT @slgv

DECLARE @slgv INT 
EXEC IN_SLGV @TENHV=N'Thạc sĩ', @SLGV=@slgv OUT 
PRINT @slgv

DECLARE @slgv INT 
EXEC IN_SLGV @TENHV=N'Bác sĩ', @SLGV=@slgv OUT 
PRINT @slgv



--> Phần 2: TRIGGER <--
--1. Tạo Trigger cho ràng buộc: Khi xóa một đề tài thì xóa các thông tin liên quan.Thực thi với trường hợp: Xóa đề tài có MSDT = ‘97001’.
GO 
CREATE TRIGGER KT_XOA_DT
ON DETAI INSTEAD OF DELETE
AS
BEGIN
     DECLARE @msdt CHAR(6)
     SELECT @msdt=MSDT FROM DELETED
     DELETE FROM SV_DETAI WHERE MSDT=@msdt
     DELETE FROM GV_HDDT WHERE MSDT=@msdt
     DELETE FROM GV_PBDT WHERE MSDT=@msdt
     DELETE FROM GV_UVDT WHERE MSDT=@msdt
     DELETE FROM HOIDONG_DT WHERE MSDT=@msdt
     DELETE FROM DETAI WHERE MSDT=@msdt
END


DELETE FROM DETAI WHERE MSDT='97001'


/*5. Tạo Trigger cho ràng buộc: Mỗi sinh viên chỉ được tham gia một đề tài.
Thực thi với các trường hợp:
• Thêm dữ liệu mới:
• Thêm thông tin thực hiện đề tài như sau: (MSSV, MSDT) = (‘13520001’,
‘97003’).
• Thêm thông tin thực hiện đề tài như sau: (MSSV, MSDT) = (‘13520004’,
‘97006’).
• Sửa dữ liệu đã có:
• Chuyển đề tài có MSDT = ‘97001’ từ sinh viên có MSSV = ‘13520003’ sang
sinh viên có MSSV = ‘13520001’.
• Chuyển đề tài có MSDT = ‘97004’ từ sinh viên có MSSV = ‘13520001’ sang
sinh viên có MSSV = ‘13520005’.*/

GO
CREATE TRIGGER KT_DETAI
ON SV_DETAI FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @mssv CHAR(8)
	SELECT @mssv = MSSV FROM INSERTED
	IF (SELECT COUNT(MSDT)
		FROM SV_DETAI
		WHERE MSSV = @mssv) >= 1
	BEGIN
		PRINT N'Sinh viên chỉ được tham gia một đề tài'
		ROLLBACK TRANSACTION
	END
END

INSERT INTO SV_DETAI (MSSV,MSDT) VALUES('13520001','97003')
INSERT INTO SV_DETAI (MSSV,MSDT) VALUES('13520004','97006')

UPDATE SV_DETAI
SET MSSV = '13520001'
WHERE MSDT = '97001' AND MSSV = '13520003';

UPDATE SV_DETAI
SET MSSV = '13520005'
WHERE MSDT = '97004' AND MSSV = '13520001';