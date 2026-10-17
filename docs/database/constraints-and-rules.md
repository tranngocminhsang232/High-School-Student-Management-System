# Ràng buộc và tham số cơ sở dữ liệu

<a id="constraints"></a>

### A.1. Khóa, ràng buộc và chỉ mục

Các đặc tả sau bổ sung cho [Data Dictionary](../database-design.md#data-dictionary). FK ghép chỉ hợp lệ khi toàn bộ cặp cột khớp; mọi FK dùng ON DELETE RESTRICT. Kiểm tra vai trò, quyền và các quy tắc liên nhiều dòng được thực hiện thêm tại Service.


**NguoiDung (nguoi_dung)**

UQ: (ten_dang_nhap); (ma_so_giao_vien).

CHECK: trang_thai IN ('CHO_CAP','HOAT_DONG','KHOA').

CHECK: la_qtv OR la_bgh OR la_giao_vien OR la_phu_huynh.

CHECK: so_lan_sai >= 0.

CHECK: trang_thai <> 'HOAT_DONG' OR (ten_dang_nhap IS NOT NULL AND mat_khau_bam IS NOT NULL).

CHECK: NOT la_giao_vien OR ma_so_giao_vien IS NOT NULL.

CHECK: NOT la_phu_huynh OR so_dien_thoai IS NOT NULL.

**HocSinh (hoc_sinh)**

UQ: (ma_so_hoc_sinh); (ma_dinh_danh).

FK: (ma_phu_huynh) → nguoi_dung (ma_nguoi_dung); RESTRICT.

FK: (ma_quy_dinh_tuoi) → quy_dinh (ma_quy_dinh); RESTRICT.

FK: (nguoi_tiep_nhan) → nguoi_dung (ma_nguoi_dung); RESTRICT.

CHECK: ngay_sinh <= ngay_tiep_nhan.

CHECK: khoi_tiep_nhan IN (10,11,12).

CHECK: gioi_tinh IN ('NAM','NU','KHAC').

CHECK: trang_thai IN ('DANG_HOC','LUU_TRU').

**LopHoc (lop_hoc)**

UQ: (nam_hoc, ten_lop); (ma_lop, nam_hoc).

FK: (ma_quy_dinh_si_so) → quy_dinh (ma_quy_dinh); RESTRICT.

CHECK: khoi IN (10,11,12).

CHECK: si_so_toi_da > 0.

CHECK: trang_thai IN ('HOAT_DONG','LUU_TRU').

**MonHoc (mon_hoc)**

UQ: (ma_mon).

CHECK: so_tiet > 0.

CHECK: he_so_mac_dinh > 0.

CHECK: trang_thai IN ('HOAT_DONG','NGUNG').

**PhanLop (phan_lop)**

UQ: (ma_phan_lop, ma_hoc_sinh).

FK: (ma_hoc_sinh) → hoc_sinh (ma_hoc_sinh); RESTRICT.

FK: (ma_lop, nam_hoc) → lop_hoc (ma_lop, nam_hoc); RESTRICT.

FK: (nguoi_thuc_hien) → nguoi_dung (ma_nguoi_dung); RESTRICT.

CHECK: den_luc IS NULL OR den_luc > tu_luc.

**PhanCong (phan_cong)**

UQ: (ma_phan_cong, ma_mon_hoc, nam_hoc, hoc_ky).

FK: (ma_giao_vien) → nguoi_dung (ma_nguoi_dung); RESTRICT.

FK: (ma_lop, nam_hoc) → lop_hoc (ma_lop, nam_hoc); RESTRICT.

FK: (ma_mon_hoc) → mon_hoc (ma_mon_hoc); RESTRICT.

CHECK: hoc_ky IN (1,2).

CHECK: (loai='CN' AND ma_mon_hoc IS NULL) OR (loai='BM' AND ma_mon_hoc IS NOT NULL).

CHECK: trang_thai IN ('HOAT_DONG','NGUNG').

**LichDay (lich_day)**

UQ: (ma_phan_cong, thu, tiet_bat_dau).

FK: (ma_phan_cong) → phan_cong (ma_phan_cong); RESTRICT.

CHECK: thu BETWEEN 2 AND 8.

CHECK: tiet_bat_dau > 0.

CHECK: tiet_ket_thuc >= tiet_bat_dau.

**QuyDinh (quy_dinh)**

FK: (ma_mon_hoc) → mon_hoc (ma_mon_hoc); RESTRICT.

FK: (nguoi_tao) → nguoi_dung (ma_nguoi_dung); RESTRICT.

CHECK: loai IN ('TUOI_SI_SO','DIEM_MON','HOC_LUC','HANH_KIEM').

CHECK: khoi IN (10,11,12).

CHECK: phien_ban > 0.

CHECK: trang_thai IN ('NHAP','AP_DUNG','NGUNG').

CHECK: (loai='DIEM_MON' AND ma_mon_hoc IS NOT NULL) OR (loai<>'DIEM_MON' AND ma_mon_hoc IS NULL).

CHECK: jsonb_typeof(tham_so) = 'object'.

**BangDiemMon (bang_diem_mon)**

UQ: (ma_hoc_sinh, ma_mon_hoc, nam_hoc, hoc_ky).

FK: (ma_hoc_sinh) → hoc_sinh (ma_hoc_sinh); RESTRICT.

FK: (ma_phan_cong, ma_mon_hoc, nam_hoc, hoc_ky) → phan_cong (ma_phan_cong, ma_mon_hoc, nam_hoc, hoc_ky); RESTRICT.

FK: (ma_quy_dinh_diem) → quy_dinh (ma_quy_dinh); RESTRICT.

FK: (nguoi_cap_nhat) → nguoi_dung (ma_nguoi_dung); RESTRICT.

CHECK: hoc_ky IN (1,2).

CHECK: phien_ban > 0.

CHECK: (trang_thai='NHAP' AND diem_trung_binh IS NULL) OR (trang_thai='HOAN_TAT' AND ma_quy_dinh_diem IS NOT NULL AND diem_trung_binh IS NOT NULL AND diem_trung_binh BETWEEN 0 AND 10).

**DiemThanhPhan (diem_thanh_phan)**

UQ: (ma_bang_diem, loai_diem, lan).

FK: (ma_bang_diem) → bang_diem_mon (ma_bang_diem); RESTRICT.

FK: (nguoi_nhap) → nguoi_dung (ma_nguoi_dung); RESTRICT.

CHECK: loai_diem IN ('TX','GK','CK').

CHECK: lan > 0.

CHECK: loai_diem='TX' OR lan=1.

CHECK: gia_tri BETWEEN 0 AND 10.

**KetQuaHocKy (ket_qua_hoc_ky)**

UQ: (ma_hoc_sinh, nam_hoc, hoc_ky).

FK: (ma_hoc_sinh) → hoc_sinh (ma_hoc_sinh); RESTRICT.

FK: (ma_quy_dinh_hoc_luc) → quy_dinh (ma_quy_dinh); RESTRICT.

FK: (ma_quy_dinh_hanh_kiem) → quy_dinh (ma_quy_dinh); RESTRICT.

FK: (nguoi_de_xuat) → nguoi_dung (ma_nguoi_dung); RESTRICT.

FK: (nguoi_duyet) → nguoi_dung (ma_nguoi_dung); RESTRICT.

CHECK: hoc_ky IN (1,2).

CHECK: phien_ban > 0.

CHECK: diem_trung_binh IS NULL OR diem_trung_binh BETWEEN 0 AND 10.

CHECK: trang_thai_hoc_luc IN ('NHAP','XAC_NHAN','CAN_CAP_NHAT').

CHECK: trang_thai_hoc_luc <> 'XAC_NHAN' OR (ma_quy_dinh_hoc_luc IS NOT NULL AND diem_trung_binh IS NOT NULL AND hoc_luc IS NOT NULL).

CHECK: trang_thai_hanh_kiem IN ('CHUA_DANH_GIA','DE_XUAT','DA_DUYET').

CHECK: trang_thai_hanh_kiem = 'CHUA_DANH_GIA' OR (ma_quy_dinh_hanh_kiem IS NOT NULL AND hanh_kiem_de_xuat IS NOT NULL AND nguoi_de_xuat IS NOT NULL).

CHECK: (trang_thai_hanh_kiem='DA_DUYET' AND hanh_kiem_duyet IS NOT NULL AND nguoi_duyet IS NOT NULL AND duyet_luc IS NOT NULL) OR (trang_thai_hanh_kiem<>'DA_DUYET' AND hanh_kiem_duyet IS NULL AND nguoi_duyet IS NULL AND duyet_luc IS NULL).

**TheoDoiHocSinh (theo_doi_hoc_sinh)**

FK: (ma_hoc_sinh) → hoc_sinh (ma_hoc_sinh); RESTRICT.

FK: (ma_phan_lop, ma_hoc_sinh) → phan_lop (ma_phan_lop, ma_hoc_sinh); RESTRICT.

FK: (nguoi_ghi) → nguoi_dung (ma_nguoi_dung); RESTRICT.

CHECK: loai IN ('DIEM_DANH','VI_PHAM').

CHECK: (loai='DIEM_DANH' AND buoi IS NOT NULL AND buoi IN ('SANG','CHIEU') AND trang_thai IS NOT NULL AND trang_thai IN ('CO_MAT','VANG_CP','VANG_KP')) OR (loai='VI_PHAM' AND buoi IS NULL AND trang_thai IS NULL AND noi_dung IS NOT NULL AND length(trim(noi_dung)) > 0).

**ThongBao (thong_bao)**

FK: (ma_lop, nam_hoc) → lop_hoc (ma_lop, nam_hoc); RESTRICT.

FK: (nguoi_tao) → nguoi_dung (ma_nguoi_dung); RESTRICT.

CHECK: loai IN ('KET_QUA','THONG_BAO_LOP').

CHECK: hoc_ky IS NULL OR hoc_ky IN (1,2).

CHECK: loai <> 'KET_QUA' OR hoc_ky IS NOT NULL.

CHECK: loai <> 'THONG_BAO_LOP' OR ma_lop IS NOT NULL.

**LichSuGuiTin (lich_su_gui_tin)**

UQ: (ma_thong_bao, ma_phu_huynh, ma_hoc_sinh, lan); (khoa_yeu_cau); (nha_cung_cap, ma_tham_chieu).

FK: (ma_thong_bao) → thong_bao (ma_thong_bao); RESTRICT.

FK: (ma_phu_huynh) → nguoi_dung (ma_nguoi_dung); RESTRICT.

FK: (ma_hoc_sinh) → hoc_sinh (ma_hoc_sinh); RESTRICT.

CHECK: lan > 0.

CHECK: trang_thai IN ('CHO_GUI','DA_GUI','THAT_BAI','CHUA_XAC_NHAN','HUY').

CHECK: phan_hoi_luc IS NULL OR phan_hoi_luc >= yeu_cau_luc.

| Loại | Chỉ mục | Bảng / cột | Điều kiện |
| --- | --- | --- | --- |
| UNIQUE | uq_phan_lop_hien_tai | phan_lop (ma_hoc_sinh, nam_hoc) | den_luc IS NULL |
| UNIQUE | uq_chu_nhiem | phan_cong (ma_lop, hoc_ky) | loai='CN' AND trang_thai='HOAT_DONG' |
| UNIQUE | uq_bo_mon | phan_cong (ma_lop, hoc_ky, ma_mon_hoc) | loai='BM' AND trang_thai='HOAT_DONG' |
| UNIQUE | uq_quy_dinh_chung_version | quy_dinh (loai, nam_hoc, khoi, phien_ban) | ma_mon_hoc IS NULL |
| UNIQUE | uq_quy_dinh_mon_version | quy_dinh (loai, nam_hoc, khoi, ma_mon_hoc, phien_ban) | ma_mon_hoc IS NOT NULL |
| UNIQUE | uq_quy_dinh_chung_ap_dung | quy_dinh (loai, nam_hoc, khoi) | ma_mon_hoc IS NULL AND trang_thai='AP_DUNG' |
| UNIQUE | uq_quy_dinh_mon_ap_dung | quy_dinh (loai, nam_hoc, khoi, ma_mon_hoc) | ma_mon_hoc IS NOT NULL AND trang_thai='AP_DUNG' |
| UNIQUE | uq_diem_danh | theo_doi_hoc_sinh (ma_hoc_sinh, ngay, buoi) | loai='DIEM_DANH' |
| Thường | ix_phan_lop_lop | phan_lop (ma_lop, den_luc) | Không lọc |
| Thường | ix_bang_diem_ky | bang_diem_mon (nam_hoc, hoc_ky, ma_mon_hoc) | Không lọc |
| Thường | ix_gui_tin_trang_thai | lich_su_gui_tin (trang_thai, yeu_cau_luc) | Không lọc |

<a id="parameters"></a>

### A.2. Cấu trúc tham số của QuyDinh

tham_so phải là một đối tượng JSONB. Service kiểm tra tên trường, kiểu, miền giá trị và tính đầy đủ trước khi chuyển AP_DUNG. Chỉ có một phiên bản áp dụng cho cùng loại/năm/khối/môn; những phiên bản đã được dùng được giữ nguyên nội dung.


| Loại | Tham số chính | Kiểm tra trước khi áp dụng |
| --- | --- | --- |
| TUOI_SI_SO | tuoi_min, tuoi_max, si_so_max | Số nguyên; 0 ≤ tuoi_min ≤ tuoi_max; si_so_max > 0. |
| DIEM_MON | so_tx_min, he_so_tx, he_so_gk, he_so_ck, he_so_mon, lam_tron, diem_dat | Số TX nguyên dương; hệ số dương; làm tròn 0–2 chữ số; điểm đạt 0–10. Có môn và đúng năm/khối. |
| HOC_LUC | muc[]: ten, thu_tu, diem_tb_min, diem_mon_min, so_mon_dat_min, duoc_tinh_dat | Thứ tự xét duy nhất; ngưỡng 0–10; số môn không âm; các mức phải bao phủ dữ liệu hợp lệ. |
| HANH_KIEM | muc[]: ten, thu_tu, mo_ta | Tên và thứ tự không trùng; mức đề xuất/duyệt phải thuộc danh mục của phiên bản. |

Các tham số cụ thể do BGH/QTV xác nhận. Hồ sơ chỉ dùng TUOI_SI_SO đúng khối/năm; lớp áp dụng giới hạn phù hợp; bảng điểm chỉ dùng DIEM_MON đúng môn/năm/khối; kết quả học kỳ dùng HOC_LUC/HANH_KIEM đúng phạm vi. CHECK tại CSDL chỉ xác nhận JSONB là đối tượng; việc kiểm tra đầy đủ cấu trúc và nội dung thuộc Service, không được bỏ qua khi nhập dữ liệu quản trị.

<a id="transactions"></a>

### A.3. Giao dịch và cách tính kết quả

Chuyển lớp khóa dòng học sinh và các lớp liên quan theo thứ tự mã, kiểm tra khoảng hiệu lực/sĩ số, kết thúc phân lớp cũ và thêm phân lớp mới trong một giao dịch. Sĩ số tính từ PhanLop còn hiệu lực của năm tương ứng. Bản ghi theo dõi phải thuộc đúng học sinh và ngày nằm trong giai đoạn lớp; không thay lại lớp của sự kiện đã phát sinh. Khi chuyển trách nhiệm nhập điểm, kiểm tra phân công BM đích đúng môn/năm/học kỳ và giữ nguyên người nhập các đầu điểm.

Khi cập nhật bảng điểm, Service kiểm tra phien_ban đã đọc; ghi điểm gốc, trung bình và trạng thái trong cùng giao dịch, rồi tăng phiên bản. NHAP có trung bình NULL. HOAN_TAT cần đủ TX theo QuyDinh, một GK và một CK; cấu hình phải hợp lệ. Tất cả điểm TX hợp lệ đều tham gia tính, không chỉ lấy số tối thiểu.

ĐTB môn = ROUND[(tổng TX × hệ số TX + GK × hệ số GK + CK × hệ số CK) / (số TX thực có × hệ số TX + hệ số GK + hệ số CK), số chữ số làm tròn]. ĐTB học kỳ = tổng (ĐTB môn hoàn tất × hệ số môn đã áp dụng) / tổng hệ số các môn thuộc khối. Dùng NUMERIC và quy tắc làm tròn thống nhất. Thiếu môn hoặc tham số thì chưa xác nhận; học lực xét các mức theo thứ tự/điều kiện của HOC_LUC.

Sửa điểm đã hoàn tất phải tính lại hoặc đưa bảng điểm về NHAP trong cùng giao dịch; kết quả học kỳ liên quan chuyển CAN_CAP_NHAT. Khi người dùng chọn áp dụng chính sách mới cho dữ liệu hiện có, hệ thống phải nêu phạm vi ảnh hưởng và tính lại có kiểm soát. Hạnh kiểm chỉ chính thức khi DA_DUYET; việc sửa điểm không tự đổi kết quả hạnh kiểm đã duyệt.

LichSuGuiTin được tạo CHO_GUI trước khi gọi SMS. Một yêu cầu lặp dùng cùng khoa_yeu_cau; một lần gửi lại được xác nhận tạo dòng mới với lan tăng. Timeout/mất phản hồi là CHUA_XAC_NHAN, cần đối soát trước khi thử lại. Gửi thất bại không hủy kết quả học tập. Nếu liên kết phụ huynh đã đổi, hủy yêu cầu chưa gửi không còn hợp lệ; các dòng gửi trong quá khứ giữ số nhận đã chốt.

Phiên/OTP được adapter xác thực lưu trong cache có hạn; OTP được lưu băm và chỉ dùng một lần. Nhật ký vận hành ghi người thao tác, thời điểm, đối tượng và kết quả trong kho log được bảo vệ; không ghi mật khẩu/OTP/token. Bản sao lưu và bản xuất báo cáo được giữ trong kho tệp. Không có bảng phiên, OTP, nhật ký, sao lưu hay báo cáo ẩn ngoài danh sách 14 bảng.
