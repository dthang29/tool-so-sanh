import cv2
import os

def compare_images(image1_path, image2_path):
    # Đọc hai hình ảnh đầu vào
    image1 = cv2.imread(image1_path, cv2.IMREAD_COLOR)
    image2 = cv2.imread(image2_path, cv2.IMREAD_COLOR)

    # Điều chỉnh kích thước của hai hình ảnh để chúng có cùng kích thước
    image1_resized = cv2.resize(image1, (image2.shape[1], image2.shape[0]))

    # Tính toán sự giống nhau giữa hai hình ảnh
    difference = cv2.subtract(image1_resized, image2)

    # Kiểm tra xem difference có phải là hình ảnh xám hay không
    if len(difference.shape) == 2:
        total_pixels = difference.shape[0] * difference.shape[1]  # Tổng số pixel trên hình ảnh (1 là số kênh màu)
        num_same_pixels = total_pixels - cv2.countNonZero(difference)
        similarity_percentage = (num_same_pixels / total_pixels) * 100
    else:
        b, g, r = cv2.split(difference)
        total_pixels = difference.shape[0] * difference.shape[1] * 3  # Tổng số pixel trên hình ảnh (3 là số kênh màu)
        num_same_pixels = total_pixels - (cv2.countNonZero(b) + cv2.countNonZero(g) + cv2.countNonZero(r))
        similarity_percentage = (num_same_pixels / total_pixels) * 100

    # In ra độ giống nhau theo phần trăm
    print(f"{image1_path} - {image2_path}: {similarity_percentage:.2f}%")

# Thư mục chứa hình ảnh
image_dir = "images"

# Lấy danh sách tất cả các file trong thư mục
image_files = [os.path.join(image_dir, f) for f in os.listdir(image_dir) if os.path.isfile(os.path.join(image_dir, f))]

# So sánh từng cặp hình ảnh
for i in range(len(image_files)):
    for j in range(i+1, len(image_files)):
        compare_images(image_files[i], image_files[j])

