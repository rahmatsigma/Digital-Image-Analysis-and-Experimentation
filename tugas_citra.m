% --- TUGAS PENGOLAHAN CITRA DIGITAL ---
clc; clear; close all;

pkg load image;

% nama file
image_files = {'img_kamera.jpeg', 'img_screenshot.jpeg', 'img_internet.jpg'};

% folder
if ~exist('hasil_eksperimen', 'dir')
    mkdir('hasil_eksperimen');
end

fprintf('MULAI EKSPERIMEN...\n=====================\n');

for k = 1:length(image_files)
    filename = image_files{k};
    [~, name, ext] = fileparts(filename);

    try
        % Baca Citra
        img = imread(filename);
        fprintf('\nMemproses: %s\n', filename);

        % Cek info file asli
        info_asli = stat(filename);
        fprintf('  Ukuran Asli: %.2f KB\n', info_asli.size / 1024);


        % RESIZE (SAMPLING) 50% dan 25%
        scales = [0.5, 0.25];
        for s = scales
            % Resize gambar
            img_resized = imresize(img, s);

            % Simpan file
            new_name = sprintf('hasil_eksperimen/%s_resize_%d%s', name, s*100, '.jpg');
            imwrite(img_resized, new_name);

            % Cek ukuran file baru
            info_baru = stat(new_name);
            fprintf('  Resize %d%% : %.2f KB\n', s*100, info_baru.size / 1024);
        end


        % KONVERSI WARNA & KUANTISASI
        % a. Grayscale
        if size(img, 3) == 3
            img_gray = rgb2gray(img);
        else
            img_gray = img;
        end
        imwrite(img_gray, sprintf('hasil_eksperimen/%s_gray.jpg', name));

        % b. Biner (Hitam Putih Murni)
        level = graythresh(img_gray);
        img_bin = im2bw(img_gray, level);
        imwrite(img_bin, sprintf('hasil_eksperimen/%s_binary.jpg', name));

        % c. 16 Graylevel (Kuantisasi manual)
        img_16 = uint8(floor(double(img_gray) / 16) * 16);
        imwrite(img_16, sprintf('hasil_eksperimen/%s_16level.jpg', name));
        fprintf('  Sukses konversi Grayscale, Biner, dan 16 Level.\n');


        % INTERPOLASI (Nearest, Bilinear, Bicubic)
        % dimensi asli
        [rows, cols, ~] = size(img);

        % Kecilkan dulu
        img_small = imresize(img, 0.1);

        % a. Nearest Neighbor
        img_near = imresize(img_small, [rows, cols], 'nearest');
        imwrite(img_near, sprintf('hasil_eksperimen/%s_interp_nearest.jpg', name));

        % b. Bilinear
        img_bil = imresize(img_small, [rows, cols], 'bilinear');
        imwrite(img_bil, sprintf('hasil_eksperimen/%s_interp_bilinear.jpg', name));

        % c. Bicubic
        img_bic = imresize(img_small, [rows, cols], 'bicubic');
        imwrite(img_bic, sprintf('hasil_eksperimen/%s_interp_bicubic.jpg', name));

        fprintf('  Sukses interpolasi Nearest, Bilinear, Bicubic.\n');

    catch
        fprintf('  ERROR: Gagal memproses %s. Pastikan file ada.\n', filename);
    end
end

fprintf('\nSELESAI! Cek folder "hasil_eksperimen" untuk melihat hasilnya.\n');
