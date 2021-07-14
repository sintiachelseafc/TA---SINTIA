clc; clear; close all;
tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%
% Read Image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%
[fname,pname] = uigetfile('data.png','Open Image');
citraAsli = imread([pname fname]);
figure (1);
imshow(citraAsli);
title('Gambar Asli');
citraResize = imresize(citraAsli, [1066 800]);
figure(2), imshow(citraResize);
 
 %% Preprocessing
 I_gray = rgb2gray(citraResize);
 figure(3), imshow(I_gray);
 I_noise = imnoise(I_gray, 'salt & pepper', 0.05);
 I_filter = medfilt2(I_noise);
 I_pro=imresize(I_filter,0.5);
 figure(4), imshow(I_pro);
 
  %% Segmentasi Citra
 % Threshold
 level = graythresh(I_pro);
 I_seg = im2bw(I_pro,level);
 % Masking & Cropping
 I_binary = activecontour(I_pro, I_seg);%%Segmen gambar kelatar depan dan belakang menggunakan kontur aktif (ular)
 rows = numel(I_pro(:,1,1));
 columns = numel(I_pro(1,:,1));
 for i = 1:rows
 for j = 1:columns
 if (I_binary(i, j, 1) == 0)
 I_pro(i, j, :) = 0;
 end
 end
 end
 figure(5),imshow(I_pro);
 
  %% Fuzzy C-Means (FCM)
 img_F = double(I_pro);
 clusterNum = 4;
 [row, col] = size(img_F);
 %Fuzzification
 expoNum = 2;
 epsilon = 0.001;
 max_Iteration = 100;
 Upre = rand(row, col, clusterNum);
 
 dep_sum = sum(Upre, 3);
 dep_sum = repmat(dep_sum, [1, 1, clusterNum]);
 Upre = Upre./dep_sum;
 center = zeros(clusterNum, 1);
 for i = 1:clusterNum
 center(i, 1) = sum(sum(Upre(:,:,i).*img_F)) /sum(sum(Upre(:,:,i)));
 end
 pre_obj_fcn = 0;
 for i = 1:clusterNum
 pre_obj_fcn = pre_obj_fcn + sum(sum((Upre(:,:,i) .* img_F- center(i)).^3 ));
 end
 fprintf('Initial objective fcn = %f\n', pre_obj_fcn);
 
 %wait bar
 hw = waitbar(0, 'Clustering...');
 for iteration = 1:max_Iteration
 Unow = zeros(size(Upre));
 for i = 1:row
 for j = 1:col
 for uII = 1:clusterNum
 tmp = 0;
for uJJ = 1:clusterNum
 disUp = abs(img_F(i,j) - center(uII));
 disDn = abs(img_F(i,j) - center(uJJ));
 tmp = tmp + (disUp/disDn).^(2 / (expoNum -1));
 end
Unow(i,j,uII) = 1/(tmp);
 end
 end
 end
 now_obj_fcn = 0;
 for i = 1:clusterNum
 now_obj_fcn = now_obj_fcn + sum(sum((Unow(:,:,i) .*img_F - center(i)).^2));
 end
 fprintf('Iteration = %f, Objective = %f\n', iteration,now_obj_fcn);
 if max(max(max(abs(Unow - Upre)))) < epsilon ||abs(now_obj_fcn - pre_obj_fcn) < epsilon
 break;
 else
 Upre = Unow.^expoNum;
 for i = 1:clusterNum
 center(i, 1) = sum(sum(Upre(:,:,i).*img_F)) /sum(sum(Upre(:,:,i)));
 end
 pre_obj_fcn = now_obj_fcn;
 end
 %Update Waitbar
 waitbar(iteration / max_Iteration, hw);
 
 waktu = toc;
fprintf('lama perhitungan %f detik\n', waktu);
 end
 RGB_Image = Unow(:,:,1:3);
rgbImage = Unow(:,:,1);
rgbImage1 = Unow(:,:,2);
rgbImage2= Unow(:,:,3);
rgbImage3 = Unow(:,:,4);
close(hw);
figure(6),imshow (RGB_Image);
figure(7),imshow(rgbImage);
figure(8),imshow(rgbImage1);
figure(9),imshow(rgbImage2);
figure(10),imshow(rgbImage3);
%end
imwrite(rgbImage, '1.png');
imwrite(rgbImage1,'2.png');
imwrite(rgbImage2,'3.png');
imwrite(rgbImage3,'4.png');
