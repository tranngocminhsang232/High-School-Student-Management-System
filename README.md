# High School Student Management System

Hệ thống Quản lý Học sinh THPT hỗ trợ quản lý hồ sơ, phân lớp, phân công giáo viên, điểm, chuyên cần, hạnh kiểm, báo cáo và thông báo cho phụ huynh.

Repository được tổ chức theo cấu trúc Bài 1 của Lab07. Tài liệu thiết kế được chia theo kiến trúc, cơ sở dữ liệu và giao diện để các thành viên sử dụng khi xây dựng mã nguồn.

## Cấu trúc thư mục

```text
High-School-Student-Management-System/
├── README.md
├── .gitignore
├── docs/
│   ├── architecture.md
│   ├── database-design.md
│   ├── ui-design.md
│   ├── assets/                  # Sơ đồ, wireframe và ERD dạng SVG
│   ├── database/
│   │   ├── schema.sql
│   │   └── constraints-and-rules.md
│   └── reference/
│       ├── Lab06.docx
│       ├── Lab06.pdf
│       └── ERD_14_bang_A4.pdf
├── backend/
│   └── .gitkeep
└── frontend/
    └── .gitkeep
```

## Tài liệu thiết kế

| Tài liệu | Nội dung |
| --- | --- |
| [Thiết kế kiến trúc](docs/architecture.md) | Kiến trúc 3 lớp, trách nhiệm thành phần, luồng tiếp nhận và nhập điểm. |
| [Thiết kế cơ sở dữ liệu](docs/database-design.md) | ERD 14 bảng, mô tả trường, Data Dictionary và quan hệ dữ liệu. |
| [Thiết kế giao diện](docs/ui-design.md) | Vai trò, màn hình, wireframe, đầu vào và phản hồi của hệ thống. |
| [Schema PostgreSQL](docs/database/schema.sql) | Câu lệnh tạo 14 bảng, khóa, ràng buộc và chỉ mục. |
| [Ràng buộc và tham số](docs/database/constraints-and-rules.md) | Kiểm tra nghiệp vụ, cấu trúc quy định, giao dịch và cách tính kết quả. |
| [Lab06 PDF](docs/reference/Lab06.pdf) · [Lab06 Word](docs/reference/Lab06.docx) | Hai định dạng của bản thiết kế gốc. |
| [ERD A4](docs/reference/ERD_14_bang_A4.pdf) | Sơ đồ 14 bảng dùng ký hiệu số, trên một trang A4. |

## Phạm vi triển khai

Năm nhóm người dùng gồm Ban giám hiệu, Giáo viên chủ nhiệm, Giáo viên bộ môn, Phụ huynh và Quản trị viên. Một giáo viên có thể đồng thời giữ nhiệm vụ chủ nhiệm và giảng dạy bộ môn; quyền được kiểm tra theo phân công.

Thiết kế dữ liệu sử dụng PostgreSQL với 14 bảng. Các quy định tuổi, sĩ số, hệ số điểm và chuẩn đánh giá được quản lý bằng tham số.

`backend/` dành cho mã nguồn máy chủ; `frontend/` dành cho mã nguồn giao diện. Hai tệp `.gitkeep` giúp Git lưu các thư mục khi chưa có mã nguồn. Khung ứng dụng và hướng dẫn cài đặt, chạy chương trình sẽ được bổ sung khi thực hiện Bài 3.
