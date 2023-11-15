% FourierFilteringDemo.m
% 作者: Seaton 杨旭彤
% 日期: 2023-11-14
% 描述: 该脚本演示了使用加窗傅里叶变换对Zernike图像进行处理。

% 清除环境变量，关闭所有图形窗口
clear; clc; close all;

% 加载Zernike图像数据
load('zernikeResult.mat');

% 在进行傅里叶变换前，将NaN值替换为0
zernikeResult(isnan(zernikeResult)) = 0;

% 应用汉宁窗
[M, N] = size(zernikeResult);
window = hanning(M) * hanning(N)';
windowedZernike = zernikeResult .* window;

% 进行傅里叶变换
fftResult = fftshift(fft2(windowedZernike));

% 设定频域滤波的圆形区域
[a, b] = size(fftResult);
a0 = round(a / 2);
b0 = round(b / 2);
% 带通滤波，d0和d1分别是低高频阈值
d0 = 0;
d1 = 8;

% 对频域进行滤波
for i = 1:a
    for j = 1:b
        distance = sqrt((i - a0)^2 + (j - b0)^2);
        if (distance >= d0 && distance <= d1)
            h = 1;
        else
            h = 0;
        end
        fftResult(i, j) = h * fftResult(i, j);
    end
end

% 进行逆傅里叶变换，得到滤波后的图像
filteredImage = real(ifft2(ifftshift(fftResult)));

% 绘制原图、Hanning窗和滤波后的图像
figure;

subplot(2, 2, 1);
mesh(zernikeResult);
title('原图');

subplot(2, 2, 2);
mesh(windowedZernike);
title('Hanning窗');

subplot(2, 2, 3);
mesh(filteredImage);
title('滤波后图像');
