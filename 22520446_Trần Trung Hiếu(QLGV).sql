create database QuanLyGiaoVu
use QuanLyGiaoVu

create table KHOA
(
	MAKHOA  varchar(4) primary key,
	TENKHOA varchar(40),
	NGTLAP smalldatetime,
	TRGKHOA char(4)
)

create table MONHOC
(
	MAMH varchar(10) primary key,
	TENMH varchar(40),
	TCLT tinyint,
	TCTH tinyint,
	MAKHOA varchar(4)
)

create table DIEUKIEN
(
	MAMH varchar(10),
	MAMH_TRUOC varchar(10),
	constraint PK_DIEUKIEN primary key (MAMH, MAMH_TRUOC)
)

create table GIAOVIEN
(
	MAGV char(4) primary key,
	HOTEN varchar(40),
	HOCVI varchar(10),
	HOCHAM varchar(10),
	GIOITINH varchar(3),
	NGSINH smalldatetime,
	NGVL smalldatetime,
	HESO numeric(4,2),
	MUCLUONG money,
	MAKHOA varchar(4)
)

create table LOP
(
	MALOP char(3) primary key,
	TENLOP varchar(40),
	TRGLOP char(5),
	SISO tinyint,
	MAGVCN char(4)
)

create table HOCVIEN
(
	MAHV char(5) primary key,
	HO varchar(40),
	TEN varchar(10),
	NGSINH smalldatetime,
	GIOITINH varchar(3),
	NOISINH varchar(40),
	MALOP char(3)
)

create table GIANGDAY
(
	MALOP char(3),
	MAMH varchar(10),
	MAGV char(4),
	HOCKY tinyint,
	NAM smallint,
	TUNGAY smalldatetime,
	DENNGAY smalldatetime,
	constraint GIANGDAY_PK primary key (MALOP, MAMH)
)

create table KETQUATHI
(
	MAHV char(5),
	MAMH varchar(10),
	LANTHI tinyint,
	NGTHI smalldatetime,
	DIEM numeric(4,2),
	KQUA varchar(10),
	constraint KETQUATHI_PK primary key (MAHV, MAMH, LANTHI)
)


--Tao khoa ngoai:
ALTER TABLE LOP ADD CONSTRAINT FK_TRGLOP FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV)
ALTER TABLE LOP ADD CONSTRAINT FK_MAGVCN FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV)
ALTER TABLE KHOA ADD CONSTRAINT FK_TRGKHOA FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV)
ALTER TABLE GIAOVIEN ADD CONSTRAINT FK_GIAOVIEN_KHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
ALTER TABLE HOCVIEN ADD CONSTRAINT FK_HOCVIEN_LOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)
ALTER TABLE GIANGDAY ADD CONSTRAINT FK_GIANGDAY_GIAOVIEN FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV)

--Cau 1:
alter table HOCVIEN
add GHICHU varchar(50), DIEMTB numeric(4,2), XEPLOAI varchar(10);

--Cau 2:
alter table HOCVIEN
add constraint CHECK_MAHV check
(
	(substring (MAHV, 1, 3) = MALOP)
	and (cast(substring (MAHV, 4, 5) as tinyint) between 1 and 99)
);

--Cau 3:
alter table HOCVIEN
add constraint KT_GTHV check (GIOITINH in ('Nam', 'Nu'));
alter table GIAOVIEN
add constraint KT_GTGV check (GIOITINH in ('Nam', 'Nu'));

--Cau 4:
alter table KETQUATHI
add constraint CHECK_DIEM check
(
	DIEM between 0 and 10
	and right(cast(DIEM as varchar), 3) like '.__'
);

--Cau 5:
alter table KETQUATHI
add constraint PL_KQUA check
(
	(KQUA = 'Dat' and DIEM between 5 and 10)
	or (KQUA = 'Khong dat' and DIEM < 5)
);

--Cau 6:
alter table KETQUATHI
add constraint CHECK_LANTHI check(LANTHI <= 3);

--Cau 7:
alter table GIANGDAY
add constraint CHECK_HK check(HOCKY between 1 and 3);

--Cau 8:
alter table GIAOVIEN
add constraint CHECK_HV check(HOCVI in ('CN', 'KS', 'Ths', 'TS', 'PTS'));