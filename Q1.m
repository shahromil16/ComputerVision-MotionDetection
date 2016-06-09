clear all
clc

%% (1) Generate 10 images and estimate noise:
for i=1:10
    I(:,:,i) =  128*ones(256,256);
    J(:,:,i) = imnoise(I(:,:,i),'gaussian',0,sqrt(2));
end

[E1,sig1] = EST_NOISE(J);
figure;
imshow(uint8(E1*255));
title('Q1: Gaussian Noise');

%% (2) 3x3 box filter and noise estimation:
box3 = 1/9*ones(3,3);
for i=1:10
    C(:,:,i) = conv2(J(:,:,i),box3,'same');
end
[E2,sig2] = EST_NOISE(C);
figure;
imshow(E2);
title('Q2: 3x3 box filter');

%% (3) 2D Gaussian filter mask:
h = fspecial('gaussian', [7 7], 1.4);
h1 = fspecial('gaussian', [1 7], 1.4);
h2 = fspecial('gaussian', [7 1], 1.4);
Img = E1;
Img_filt_1 = conv2(Img, h);
Img_filt_2 = conv2(conv2(Img,h1),h2);
figure;
imshow(Img_filt_1);
title('Q(3) Filtered directly using Gaussian Mask');
figure;
imshow(Img_filt_2);
title('Q(3) Filtered using equivalent 1D vectors');

%% (4) Averaging filter
%(a) Making of filters
Ibar = [10*ones(1,5), 40*ones(1,5)];
avgfilt_a = 1/5*ones(1,5);
Ibar_filter_a = imfilter(Ibar, avgfilt_a);
avgfilt_b = 1/10*[1, 2, 4, 2, 1];
Ibar_filter_b = imfilter(Ibar, avgfilt_b);
%(b) Computing the filters
Ibar_noise = imnoise(E1,'gaussian',0,1);
tic;
Ibar_noisefilt_a = imfilter(Ibar_noise, avgfilt_a);
time(1) = toc;
tic;
Ibar_noisefilt_b = imfilter(Ibar_noise, avgfilt_b);
time(2) = toc;
sig1 = (Ibar_noisefilt_a - E1).^2;
variance(1) = sqrt(mean(mean(sig1)));
sig2 = (Ibar_noisefilt_b - E1).^2;
variance(2) = sqrt(mean(mean(sig2)));

%% (5) 
clear I
P = randperm(256*256);
P = reshape(P,256,256);
for i=1:256
    for j=1:256
        if P(i,j)<256*256*0.3
            I(i,j) = 0;
        else
            I(i,j) = 100;
        end
    end
end
I(:,128) = 50;
figure;
imshow(I);
title('Q5: Original Image');
h = [-1,2,-1];
Iout = imfilter(I,h);
figure;
imshow(Iout);
title('Q5: Filtered image using the operator [-1,2,-1]');
a1 = double(Iout(:,127));
a2 = double(Iout(:,128));
figure;
hist(a1);
title('Q5: Line to the left of gray line');
figure;
hist(a2);
title('Q5: Middle line');

%% (6) 8x8 image
Iin = zeros(8,8);
for i=1:8
    for j=1:8
        Iin(i,j) = (abs(i-j));
    end
end
I_medfilt = medianfilter(Iin);
Iin = uint8(Iin);
figure;
imshow(Iin);
title('Q6: 8x8 Image');
figure;
imshow(I_medfilt);
title('Q6: Median filtered Image');

%% (7) 1D step profile
f = [4*ones(1,4),8*ones(1,4)];
fout1 = medianfilter(f);
h = 1/4*[1, 2, 1];
fout2 = imfilter(f,h);