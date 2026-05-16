import os

def export_flutter_to_txt(project_path, output_file):
    # Các thư mục thường gặp trong Flutter mà mình không cần lấy code
    exclude_dirs = {'.git', '.dart_tool', 'build', '.idea', 'windows', 'linux', 'macos', 'android', 'ios'}
    # Các định dạng file muốn lấy
    valid_extensions = {'.dart', '.yaml'}

    print(f"--- Đang bắt đầu trích xuất từ: {project_path} ---")
    
    with open(output_file, 'w', encoding='utf-8') as f_out:
        for root, dirs, files in os.walk(project_path):
            # Loại bỏ các thư mục không mong muốn
            dirs[:] = [d for d in dirs if d not in exclude_dirs]

            for file in files:
                if any(file.endswith(ext) for ext in valid_extensions):
                    file_path = os.path.join(root, file)
                    relative_path = os.path.relpath(file_path, project_path)
                    
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f_in:
                            content = f_in.read()
                            
                            # Ghi tiêu đề file để dễ phân biệt trong file txt
                            f_out.write(f"\n{'='*80}\n")
                            f_out.write(f" FILE: {relative_path}\n")
                            f_out.write(f"{'='*80}\n\n")
                            
                            f_out.write(content)
                            f_out.write("\n\n")
                            print(f"Đã trích xuất: {relative_path}")
                    except Exception as e:
                        print(f"Lỗi khi đọc file {relative_path}: {e}")

    print(f"\n--- Hoàn tất! Tất cả code đã được lưu vào: {output_file} ---")

# --- Cấu hình đường dẫn ở đây ---
du_an_flutter = r'C:\Users\HP\Desktop\Save\PTUDDDDNT\test_app' # Đường dẫn đến folder dự án của bạn
file_ket_qua = 'source_code_flutter.txt'

export_flutter_to_txt(du_an_flutter, file_ket_qua)