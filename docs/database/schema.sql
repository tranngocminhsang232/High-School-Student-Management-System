-- PostgreSQL: 14-table design for the student management system.

-- Run only in an empty schema. Application transactions enforce cross-row rules.

BEGIN;

CREATE SEQUENCE hoc_sinh_code_seq;

CREATE TABLE nguoi_dung (
  ma_nguoi_dung BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ho_ten VARCHAR(100) NOT NULL,
  email VARCHAR(150),
  so_dien_thoai VARCHAR(20),
  ten_dang_nhap VARCHAR(50),
  mat_khau_bam VARCHAR(255),
  la_qtv BOOLEAN NOT NULL,
  la_bgh BOOLEAN NOT NULL,
  la_giao_vien BOOLEAN NOT NULL,
  la_phu_huynh BOOLEAN NOT NULL,
  ma_so_giao_vien VARCHAR(20),
  trang_thai VARCHAR(15) NOT NULL,
  so_lan_sai SMALLINT NOT NULL,
  khoa_den TIMESTAMPTZ,
  PRIMARY KEY (ma_nguoi_dung),
  UNIQUE (ten_dang_nhap),
  UNIQUE (ma_so_giao_vien),
  CHECK (trang_thai IN ('CHO_CAP','HOAT_DONG','KHOA')),
  CHECK (la_qtv OR la_bgh OR la_giao_vien OR la_phu_huynh),
  CHECK (so_lan_sai >= 0),
  CHECK (trang_thai <> 'HOAT_DONG' OR (ten_dang_nhap IS NOT NULL AND mat_khau_bam IS NOT NULL)),
  CHECK (NOT la_giao_vien OR ma_so_giao_vien IS NOT NULL),
  CHECK (NOT la_phu_huynh OR so_dien_thoai IS NOT NULL)
);

CREATE TABLE hoc_sinh (
  ma_hoc_sinh BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ma_so_hoc_sinh VARCHAR(20) NOT NULL,
  ma_dinh_danh VARCHAR(20) NOT NULL,
  ho_ten VARCHAR(100) NOT NULL,
  ngay_sinh DATE NOT NULL,
  gioi_tinh VARCHAR(10) NOT NULL,
  dia_chi VARCHAR(255) NOT NULL,
  ma_phu_huynh BIGINT NOT NULL,
  ngay_tiep_nhan DATE NOT NULL,
  khoi_tiep_nhan SMALLINT NOT NULL,
  ma_quy_dinh_tuoi BIGINT NOT NULL,
  trang_thai VARCHAR(15) NOT NULL,
  nguoi_tiep_nhan BIGINT NOT NULL,
  PRIMARY KEY (ma_hoc_sinh),
  UNIQUE (ma_so_hoc_sinh),
  UNIQUE (ma_dinh_danh),
  CHECK (ngay_sinh <= ngay_tiep_nhan),
  CHECK (khoi_tiep_nhan IN (10,11,12)),
  CHECK (gioi_tinh IN ('NAM','NU','KHAC')),
  CHECK (trang_thai IN ('DANG_HOC','LUU_TRU'))
);

CREATE TABLE lop_hoc (
  ma_lop BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ten_lop VARCHAR(20) NOT NULL,
  nam_hoc VARCHAR(9) NOT NULL,
  khoi SMALLINT NOT NULL,
  si_so_toi_da SMALLINT NOT NULL,
  ma_quy_dinh_si_so BIGINT NOT NULL,
  trang_thai VARCHAR(15) NOT NULL,
  PRIMARY KEY (ma_lop),
  UNIQUE (nam_hoc, ten_lop),
  UNIQUE (ma_lop, nam_hoc),
  CHECK (khoi IN (10,11,12)),
  CHECK (si_so_toi_da > 0),
  CHECK (trang_thai IN ('HOAT_DONG','LUU_TRU'))
);

CREATE TABLE mon_hoc (
  ma_mon_hoc BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ma_mon VARCHAR(20) NOT NULL,
  ten_mon VARCHAR(100) NOT NULL,
  so_tiet SMALLINT NOT NULL,
  he_so_mac_dinh NUMERIC(5,2) NOT NULL,
  trang_thai VARCHAR(15) NOT NULL,
  PRIMARY KEY (ma_mon_hoc),
  UNIQUE (ma_mon),
  CHECK (so_tiet > 0),
  CHECK (he_so_mac_dinh > 0),
  CHECK (trang_thai IN ('HOAT_DONG','NGUNG'))
);

CREATE TABLE phan_lop (
  ma_phan_lop BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ma_hoc_sinh BIGINT NOT NULL,
  ma_lop BIGINT NOT NULL,
  nam_hoc VARCHAR(9) NOT NULL,
  tu_luc TIMESTAMPTZ NOT NULL,
  den_luc TIMESTAMPTZ,
  ly_do VARCHAR(255),
  nguoi_thuc_hien BIGINT NOT NULL,
  PRIMARY KEY (ma_phan_lop),
  UNIQUE (ma_phan_lop, ma_hoc_sinh),
  CHECK (den_luc IS NULL OR den_luc > tu_luc)
);

CREATE TABLE phan_cong (
  ma_phan_cong BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ma_giao_vien BIGINT NOT NULL,
  ma_lop BIGINT NOT NULL,
  nam_hoc VARCHAR(9) NOT NULL,
  hoc_ky SMALLINT NOT NULL,
  loai VARCHAR(2) NOT NULL,
  ma_mon_hoc BIGINT,
  trang_thai VARCHAR(15) NOT NULL,
  PRIMARY KEY (ma_phan_cong),
  UNIQUE (ma_phan_cong, ma_mon_hoc, nam_hoc, hoc_ky),
  CHECK (hoc_ky IN (1,2)),
  CHECK ((loai='CN' AND ma_mon_hoc IS NULL) OR (loai='BM' AND ma_mon_hoc IS NOT NULL)),
  CHECK (trang_thai IN ('HOAT_DONG','NGUNG'))
);

CREATE TABLE lich_day (
  ma_lich_day BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ma_phan_cong BIGINT NOT NULL,
  thu SMALLINT NOT NULL,
  tiet_bat_dau SMALLINT NOT NULL,
  tiet_ket_thuc SMALLINT NOT NULL,
  phong_hoc VARCHAR(30),
  PRIMARY KEY (ma_lich_day),
  UNIQUE (ma_phan_cong, thu, tiet_bat_dau),
  CHECK (thu BETWEEN 2 AND 8),
  CHECK (tiet_bat_dau > 0),
  CHECK (tiet_ket_thuc >= tiet_bat_dau)
);

CREATE TABLE quy_dinh (
  ma_quy_dinh BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  loai VARCHAR(20) NOT NULL,
  nam_hoc VARCHAR(9) NOT NULL,
  khoi SMALLINT NOT NULL,
  ma_mon_hoc BIGINT,
  phien_ban SMALLINT NOT NULL,
  trang_thai VARCHAR(10) NOT NULL,
  tham_so JSONB NOT NULL,
  nguoi_tao BIGINT NOT NULL,
  tao_luc TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (ma_quy_dinh),
  CHECK (loai IN ('TUOI_SI_SO','DIEM_MON','HOC_LUC','HANH_KIEM')),
  CHECK (khoi IN (10,11,12)),
  CHECK (phien_ban > 0),
  CHECK (trang_thai IN ('NHAP','AP_DUNG','NGUNG')),
  CHECK ((loai='DIEM_MON' AND ma_mon_hoc IS NOT NULL) OR (loai<>'DIEM_MON' AND ma_mon_hoc IS NULL)),
  CHECK (jsonb_typeof(tham_so) = 'object')
);

CREATE TABLE bang_diem_mon (
  ma_bang_diem BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ma_hoc_sinh BIGINT NOT NULL,
  ma_mon_hoc BIGINT NOT NULL,
  nam_hoc VARCHAR(9) NOT NULL,
  hoc_ky SMALLINT NOT NULL,
  ma_phan_cong BIGINT NOT NULL,
  ma_quy_dinh_diem BIGINT,
  diem_trung_binh NUMERIC(4,2),
  trang_thai VARCHAR(10) NOT NULL,
  phien_ban INTEGER NOT NULL,
  nhan_xet VARCHAR(255),
  nguoi_cap_nhat BIGINT NOT NULL,
  cap_nhat_luc TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (ma_bang_diem),
  UNIQUE (ma_hoc_sinh, ma_mon_hoc, nam_hoc, hoc_ky),
  CHECK (hoc_ky IN (1,2)),
  CHECK (phien_ban > 0),
  CHECK ((trang_thai='NHAP' AND diem_trung_binh IS NULL) OR (trang_thai='HOAN_TAT' AND ma_quy_dinh_diem IS NOT NULL AND diem_trung_binh IS NOT NULL AND diem_trung_binh BETWEEN 0 AND 10))
);

CREATE TABLE diem_thanh_phan (
  ma_diem BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ma_bang_diem BIGINT NOT NULL,
  loai_diem VARCHAR(2) NOT NULL,
  lan SMALLINT NOT NULL,
  gia_tri NUMERIC(4,2) NOT NULL,
  nguoi_nhap BIGINT NOT NULL,
  cap_nhat_luc TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (ma_diem),
  UNIQUE (ma_bang_diem, loai_diem, lan),
  CHECK (loai_diem IN ('TX','GK','CK')),
  CHECK (lan > 0),
  CHECK (loai_diem='TX' OR lan=1),
  CHECK (gia_tri BETWEEN 0 AND 10)
);

CREATE TABLE ket_qua_hoc_ky (
  ma_ket_qua BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ma_hoc_sinh BIGINT NOT NULL,
  nam_hoc VARCHAR(9) NOT NULL,
  hoc_ky SMALLINT NOT NULL,
  ma_quy_dinh_hoc_luc BIGINT,
  diem_trung_binh NUMERIC(4,2),
  hoc_luc VARCHAR(30),
  trang_thai_hoc_luc VARCHAR(15) NOT NULL,
  ma_quy_dinh_hanh_kiem BIGINT,
  hanh_kiem_de_xuat VARCHAR(30),
  hanh_kiem_duyet VARCHAR(30),
  nhan_xet VARCHAR(500),
  trang_thai_hanh_kiem VARCHAR(15) NOT NULL,
  nguoi_de_xuat BIGINT,
  nguoi_duyet BIGINT,
  duyet_luc TIMESTAMPTZ,
  phien_ban INTEGER NOT NULL,
  PRIMARY KEY (ma_ket_qua),
  UNIQUE (ma_hoc_sinh, nam_hoc, hoc_ky),
  CHECK (hoc_ky IN (1,2)),
  CHECK (phien_ban > 0),
  CHECK (diem_trung_binh IS NULL OR diem_trung_binh BETWEEN 0 AND 10),
  CHECK (trang_thai_hoc_luc IN ('NHAP','XAC_NHAN','CAN_CAP_NHAT')),
  CHECK (trang_thai_hoc_luc <> 'XAC_NHAN' OR (ma_quy_dinh_hoc_luc IS NOT NULL AND diem_trung_binh IS NOT NULL AND hoc_luc IS NOT NULL)),
  CHECK (trang_thai_hanh_kiem IN ('CHUA_DANH_GIA','DE_XUAT','DA_DUYET')),
  CHECK (trang_thai_hanh_kiem = 'CHUA_DANH_GIA' OR (ma_quy_dinh_hanh_kiem IS NOT NULL AND hanh_kiem_de_xuat IS NOT NULL AND nguoi_de_xuat IS NOT NULL)),
  CHECK ((trang_thai_hanh_kiem='DA_DUYET' AND hanh_kiem_duyet IS NOT NULL AND nguoi_duyet IS NOT NULL AND duyet_luc IS NOT NULL) OR (trang_thai_hanh_kiem<>'DA_DUYET' AND hanh_kiem_duyet IS NULL AND nguoi_duyet IS NULL AND duyet_luc IS NULL))
);

CREATE TABLE theo_doi_hoc_sinh (
  ma_theo_doi BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ma_hoc_sinh BIGINT NOT NULL,
  ma_phan_lop BIGINT NOT NULL,
  loai VARCHAR(10) NOT NULL,
  ngay DATE NOT NULL,
  buoi VARCHAR(5),
  trang_thai VARCHAR(15),
  noi_dung TEXT,
  huong_xu_ly VARCHAR(255),
  nguoi_ghi BIGINT NOT NULL,
  cap_nhat_luc TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (ma_theo_doi),
  CHECK (loai IN ('DIEM_DANH','VI_PHAM')),
  CHECK ((loai='DIEM_DANH' AND buoi IS NOT NULL AND buoi IN ('SANG','CHIEU') AND trang_thai IS NOT NULL AND trang_thai IN ('CO_MAT','VANG_CP','VANG_KP')) OR (loai='VI_PHAM' AND buoi IS NULL AND trang_thai IS NULL AND noi_dung IS NOT NULL AND length(trim(noi_dung)) > 0))
);

CREATE TABLE thong_bao (
  ma_thong_bao BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  loai VARCHAR(15) NOT NULL,
  tieu_de VARCHAR(150) NOT NULL,
  noi_dung TEXT NOT NULL,
  nam_hoc VARCHAR(9) NOT NULL,
  hoc_ky SMALLINT,
  ma_lop BIGINT,
  nguoi_tao BIGINT NOT NULL,
  tao_luc TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (ma_thong_bao),
  CHECK (loai IN ('KET_QUA','THONG_BAO_LOP')),
  CHECK (hoc_ky IS NULL OR hoc_ky IN (1,2)),
  CHECK (loai <> 'KET_QUA' OR hoc_ky IS NOT NULL),
  CHECK (loai <> 'THONG_BAO_LOP' OR ma_lop IS NOT NULL)
);

CREATE TABLE lich_su_gui_tin (
  ma_lan_gui BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  ma_thong_bao BIGINT NOT NULL,
  ma_phu_huynh BIGINT NOT NULL,
  ma_hoc_sinh BIGINT NOT NULL,
  so_dien_thoai_chot VARCHAR(20) NOT NULL,
  lan SMALLINT NOT NULL,
  khoa_yeu_cau VARCHAR(64) NOT NULL,
  nha_cung_cap VARCHAR(30) NOT NULL,
  ma_tham_chieu VARCHAR(100),
  trang_thai VARCHAR(15) NOT NULL,
  yeu_cau_luc TIMESTAMPTZ NOT NULL,
  phan_hoi_luc TIMESTAMPTZ,
  ma_loi VARCHAR(100),
  PRIMARY KEY (ma_lan_gui),
  UNIQUE (ma_thong_bao, ma_phu_huynh, ma_hoc_sinh, lan),
  UNIQUE (khoa_yeu_cau),
  UNIQUE (nha_cung_cap, ma_tham_chieu),
  CHECK (lan > 0),
  CHECK (trang_thai IN ('CHO_GUI','DA_GUI','THAT_BAI','CHUA_XAC_NHAN','HUY')),
  CHECK (phan_hoi_luc IS NULL OR phan_hoi_luc >= yeu_cau_luc)
);

ALTER TABLE hoc_sinh ADD CONSTRAINT fk_hoc_sinh_1 FOREIGN KEY (ma_phu_huynh) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE hoc_sinh ADD CONSTRAINT fk_hoc_sinh_2 FOREIGN KEY (ma_quy_dinh_tuoi) REFERENCES quy_dinh (ma_quy_dinh) ON DELETE RESTRICT;

ALTER TABLE hoc_sinh ADD CONSTRAINT fk_hoc_sinh_3 FOREIGN KEY (nguoi_tiep_nhan) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE lop_hoc ADD CONSTRAINT fk_lop_hoc_1 FOREIGN KEY (ma_quy_dinh_si_so) REFERENCES quy_dinh (ma_quy_dinh) ON DELETE RESTRICT;

ALTER TABLE phan_lop ADD CONSTRAINT fk_phan_lop_1 FOREIGN KEY (ma_hoc_sinh) REFERENCES hoc_sinh (ma_hoc_sinh) ON DELETE RESTRICT;

ALTER TABLE phan_lop ADD CONSTRAINT fk_phan_lop_2 FOREIGN KEY (ma_lop, nam_hoc) REFERENCES lop_hoc (ma_lop, nam_hoc) ON DELETE RESTRICT;

ALTER TABLE phan_lop ADD CONSTRAINT fk_phan_lop_3 FOREIGN KEY (nguoi_thuc_hien) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE phan_cong ADD CONSTRAINT fk_phan_cong_1 FOREIGN KEY (ma_giao_vien) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE phan_cong ADD CONSTRAINT fk_phan_cong_2 FOREIGN KEY (ma_lop, nam_hoc) REFERENCES lop_hoc (ma_lop, nam_hoc) ON DELETE RESTRICT;

ALTER TABLE phan_cong ADD CONSTRAINT fk_phan_cong_3 FOREIGN KEY (ma_mon_hoc) REFERENCES mon_hoc (ma_mon_hoc) ON DELETE RESTRICT;

ALTER TABLE lich_day ADD CONSTRAINT fk_lich_day_1 FOREIGN KEY (ma_phan_cong) REFERENCES phan_cong (ma_phan_cong) ON DELETE RESTRICT;

ALTER TABLE quy_dinh ADD CONSTRAINT fk_quy_dinh_1 FOREIGN KEY (ma_mon_hoc) REFERENCES mon_hoc (ma_mon_hoc) ON DELETE RESTRICT;

ALTER TABLE quy_dinh ADD CONSTRAINT fk_quy_dinh_2 FOREIGN KEY (nguoi_tao) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE bang_diem_mon ADD CONSTRAINT fk_bang_diem_mon_1 FOREIGN KEY (ma_hoc_sinh) REFERENCES hoc_sinh (ma_hoc_sinh) ON DELETE RESTRICT;

ALTER TABLE bang_diem_mon ADD CONSTRAINT fk_bang_diem_mon_2 FOREIGN KEY (ma_phan_cong, ma_mon_hoc, nam_hoc, hoc_ky) REFERENCES phan_cong (ma_phan_cong, ma_mon_hoc, nam_hoc, hoc_ky) ON DELETE RESTRICT;

ALTER TABLE bang_diem_mon ADD CONSTRAINT fk_bang_diem_mon_3 FOREIGN KEY (ma_quy_dinh_diem) REFERENCES quy_dinh (ma_quy_dinh) ON DELETE RESTRICT;

ALTER TABLE bang_diem_mon ADD CONSTRAINT fk_bang_diem_mon_4 FOREIGN KEY (nguoi_cap_nhat) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE diem_thanh_phan ADD CONSTRAINT fk_diem_thanh_phan_1 FOREIGN KEY (ma_bang_diem) REFERENCES bang_diem_mon (ma_bang_diem) ON DELETE RESTRICT;

ALTER TABLE diem_thanh_phan ADD CONSTRAINT fk_diem_thanh_phan_2 FOREIGN KEY (nguoi_nhap) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE ket_qua_hoc_ky ADD CONSTRAINT fk_ket_qua_hoc_ky_1 FOREIGN KEY (ma_hoc_sinh) REFERENCES hoc_sinh (ma_hoc_sinh) ON DELETE RESTRICT;

ALTER TABLE ket_qua_hoc_ky ADD CONSTRAINT fk_ket_qua_hoc_ky_2 FOREIGN KEY (ma_quy_dinh_hoc_luc) REFERENCES quy_dinh (ma_quy_dinh) ON DELETE RESTRICT;

ALTER TABLE ket_qua_hoc_ky ADD CONSTRAINT fk_ket_qua_hoc_ky_3 FOREIGN KEY (ma_quy_dinh_hanh_kiem) REFERENCES quy_dinh (ma_quy_dinh) ON DELETE RESTRICT;

ALTER TABLE ket_qua_hoc_ky ADD CONSTRAINT fk_ket_qua_hoc_ky_4 FOREIGN KEY (nguoi_de_xuat) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE ket_qua_hoc_ky ADD CONSTRAINT fk_ket_qua_hoc_ky_5 FOREIGN KEY (nguoi_duyet) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE theo_doi_hoc_sinh ADD CONSTRAINT fk_theo_doi_hoc_sinh_1 FOREIGN KEY (ma_hoc_sinh) REFERENCES hoc_sinh (ma_hoc_sinh) ON DELETE RESTRICT;

ALTER TABLE theo_doi_hoc_sinh ADD CONSTRAINT fk_theo_doi_hoc_sinh_2 FOREIGN KEY (ma_phan_lop, ma_hoc_sinh) REFERENCES phan_lop (ma_phan_lop, ma_hoc_sinh) ON DELETE RESTRICT;

ALTER TABLE theo_doi_hoc_sinh ADD CONSTRAINT fk_theo_doi_hoc_sinh_3 FOREIGN KEY (nguoi_ghi) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE thong_bao ADD CONSTRAINT fk_thong_bao_1 FOREIGN KEY (ma_lop, nam_hoc) REFERENCES lop_hoc (ma_lop, nam_hoc) ON DELETE RESTRICT;

ALTER TABLE thong_bao ADD CONSTRAINT fk_thong_bao_2 FOREIGN KEY (nguoi_tao) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE lich_su_gui_tin ADD CONSTRAINT fk_lich_su_gui_tin_1 FOREIGN KEY (ma_thong_bao) REFERENCES thong_bao (ma_thong_bao) ON DELETE RESTRICT;

ALTER TABLE lich_su_gui_tin ADD CONSTRAINT fk_lich_su_gui_tin_2 FOREIGN KEY (ma_phu_huynh) REFERENCES nguoi_dung (ma_nguoi_dung) ON DELETE RESTRICT;

ALTER TABLE lich_su_gui_tin ADD CONSTRAINT fk_lich_su_gui_tin_3 FOREIGN KEY (ma_hoc_sinh) REFERENCES hoc_sinh (ma_hoc_sinh) ON DELETE RESTRICT;

CREATE UNIQUE INDEX uq_phan_lop_hien_tai ON phan_lop (ma_hoc_sinh, nam_hoc) WHERE den_luc IS NULL;

CREATE UNIQUE INDEX uq_chu_nhiem ON phan_cong (ma_lop, hoc_ky) WHERE loai='CN' AND trang_thai='HOAT_DONG';

CREATE UNIQUE INDEX uq_bo_mon ON phan_cong (ma_lop, hoc_ky, ma_mon_hoc) WHERE loai='BM' AND trang_thai='HOAT_DONG';

CREATE UNIQUE INDEX uq_quy_dinh_chung_version ON quy_dinh (loai, nam_hoc, khoi, phien_ban) WHERE ma_mon_hoc IS NULL;

CREATE UNIQUE INDEX uq_quy_dinh_mon_version ON quy_dinh (loai, nam_hoc, khoi, ma_mon_hoc, phien_ban) WHERE ma_mon_hoc IS NOT NULL;

CREATE UNIQUE INDEX uq_quy_dinh_chung_ap_dung ON quy_dinh (loai, nam_hoc, khoi) WHERE ma_mon_hoc IS NULL AND trang_thai='AP_DUNG';

CREATE UNIQUE INDEX uq_quy_dinh_mon_ap_dung ON quy_dinh (loai, nam_hoc, khoi, ma_mon_hoc) WHERE ma_mon_hoc IS NOT NULL AND trang_thai='AP_DUNG';

CREATE UNIQUE INDEX uq_diem_danh ON theo_doi_hoc_sinh (ma_hoc_sinh, ngay, buoi) WHERE loai='DIEM_DANH';

CREATE INDEX ix_phan_lop_lop ON phan_lop (ma_lop, den_luc);

CREATE INDEX ix_bang_diem_ky ON bang_diem_mon (nam_hoc, hoc_ky, ma_mon_hoc);

CREATE INDEX ix_gui_tin_trang_thai ON lich_su_gui_tin (trang_thai, yeu_cau_luc);

COMMIT;
