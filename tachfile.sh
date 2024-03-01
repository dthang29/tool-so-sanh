#!/bin/bash

# Tạo giao diện người dùng với Zenity
while true; do
  CHOICE=$(zenity --list --title="Chọn tệp và bắt đầu" --column="Options" "Select zip file" "Tach file" "So sanh")

  case "$CHOICE" in
    "Select zip file")
      # Cho phép người dùng chọn tệp
      zip_file=$(zenity --file-selection --title="Chọn tệp zip")
      ;;
    "Tach file")
      if [ -z "$zip_file" ]; then
        zenity --error --text="Vui lòng chọn tệp zip trước khi bắt đầu."
      else
        # Thực hiện thao tác với tệp zip
        temp_dir=$(mktemp -d)
        unzip "$zip_file" -d "$temp_dir" > /dev/null
        file_list=($(ls "$temp_dir"))
        
        for file in "${file_list[@]}"; do
          # Xác định loại tệp
          file_type=$(file -b --mime-type "$temp_dir/$file")

          # Tách văn bản và hình ảnh ra từ tệp DOCX và PDF
          case "$file_type" in
            application/vnd.openxmlformats-officedocument.wordprocessingml.document)
              # Tệp DOCX
              ./trich/trichtxtd.sh "$temp_dir/$file"
              python3 ./trich/trichhinhdoc.py "$temp_dir/$file"
              ;;
            application/pdf)
              # Tệp PDF
              ./trich/trichtxtp.sh "$temp_dir/$file"
              ./trich/trichhinhpdf.sh "$temp_dir/$file"
              ;;
          esac
        done
      fi
      ;;
    "So sanh")    
        # Kiểm tra xem đã tách tệp chưa
        if [ -z "$temp_dir" ]; then
            zenity --error --text="Vui lòng tách tệp trước khi so sánh."
        else
            # Thêm lệnh chạy file sosanhchu.sh
            resultc=$(./sosanh/sosanhchu.sh "$temp_dir/text")
            resulth=$(python3 ./sosanh/sshinhanh.py "$temp_dir/images" 2>&1)
            # Hiển thị kết quả bằng Zenity
            zenity --info --text="$resultc"
            zenity --info --text="----------------------------------"
            zenity --info --text="$resulth"
        fi
      ;;
    *)
      break
      ;;
  esac
done

