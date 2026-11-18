# DỰ ÁN MỚI: MM ILSUNGTECH

## Cam kết độc lập
- Không sửa repository cũ `manpower-management-system`.
- Không dùng Supabase URL, key, database hoặc tài khoản của dự án cũ.
- Tạo Supabase project mới và GitHub repository mới.
- Gói này có mã nguồn khởi tạo độc lập, không import dữ liệu cũ.

## Cấu hình ca
- Ca A và Ca C: luân phiên ngày/đêm theo kế hoạch sản xuất/phân ca của công ty.
- Chưa thiết lập chu kỳ cố định; hệ thống KHÔNG tự suy đoán 2-2, 4-4 hoặc 7-7.
- Khi chấm công, người phụ trách chọn ca riêng cho từng nhân viên theo lịch đã được công ty công bố. Có thể thay đổi theo từng ngày.
- Ca ngày: 08:00–20:00.
- Ca đêm: 20:00–08:00 ngày hôm sau. Ngày công là ngày bắt đầu ca.
- Hành Chính: 08:00–17:00.
- MBO: đánh giá theo quý.

## Triển khai
1. Tạo một Supabase project MỚI, đặt tên `MM-ILSUNGTECH-HR`. Không chọn dự án Supabase cũ.
2. Trong Supabase mới, vào SQL Editor > New query, chạy toàn bộ `supabase/schema.sql`.
3. Vào Project Settings > API, lấy Project URL và Publishable key (hoặc anon key).
4. Mở `index.html`, thay hai giá trị `PASTE_NEW_SUPABASE...` bằng URL và key của project mới.
5. Tạo GitHub repository mới tên `mm-ilsungtech-hr` (không dùng repository cũ).
6. Upload `index.html` và thư mục `supabase` vào repository mới.
7. Trong GitHub repository mới: Settings > Pages > Deploy from a branch > chọn `main` và `/ (root)` > Save.
8. Mở URL GitHub Pages mới, tạo tài khoản đầu tiên bằng email công ty.

## Các module có trong bản khởi tạo
Nhân viên, chấm công theo ngày/ca, OT, nghỉ phép và duyệt nghỉ, nhập dữ liệu lương, MBO theo quý, xuất Excel.

## Cảnh báo trước khi dùng chính thức
- Đây là bản khởi tạo chạy trên web và Supabase. Chưa có cơ chế phân quyền chi tiết theo vai trò; schema hiện cho mọi tài khoản authenticated quyền CRUD. Cần thiết kế role Admin/HR/Manager/Employee và RLS chặt hơn trước khi đưa dữ liệu lương, thông tin cá nhân vào vận hành.
- Công thức lương hiện mới lưu lương cơ bản, phụ cấp, thưởng, khấu trừ và tính thực nhận dự kiến. Chưa tự tính bảo hiểm, thuế TNCN, công chuẩn, hệ số OT hoặc quy tắc làm tròn. Cần xác nhận quy chế lương công ty trước khi áp dụng.
- Lịch A/C được xử lý theo kế hoạch phân ca thực tế của công ty: không tự sinh chu kỳ. Tại màn Chấm công, chọn ca ngày/ca đêm cho từng nhân viên theo ngày làm việc. Điều này tránh gán sai ca khi kế hoạch sản xuất thay đổi.
- Tài khoản đầu tiên đăng ký qua giao diện; nếu Supabase yêu cầu xác nhận email, cần xác nhận email trước khi đăng nhập.
