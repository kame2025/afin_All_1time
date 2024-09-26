clc; close all; imtool close all; clear;

result_Dir = 'C:\Users\SISLa\MATLAB\Projects\afin_All_1time\出力結果\ten';

% 初期設定
xlens = 329;
ylens = 188;
% magnification = 1.01739;

% 画像の読み込みと前処理
I = imread('030A0203.JPG');
J = imrotate(I, 90);

J2 = imcrop(J, [500 100 4319 7680]); %img2
IMG = J2;
IMG(:,:,:) = 0; %色の指定 今だけ入れてる→あとから消すように変更する

% 初期値設定
d = 1.5 * sqrt(2); % 12 * 0.0908  
pix = round((d / 90.80) * 1000); % 白線の線幅を画素数で表現(pix)
pix2 = round(pix / 2);
pix3 = (d / 90.80) * 1000; % 白線の線幅を画素数で表現(pix)
magnification = pix3/pix;

x_axis = 5000; % 横のサイズ184.915675
y_axis = 8000; % 縦のサイズ328.7389

% ten_main関数を呼び出し
ten_main(result_Dir, xlens, ylens, magnification, IMG, pix, pix2, y_axis, x_axis);

% load_photo関数を呼び出し
[imds, ten, plot_statas] = load_video(result_Dir, xlens, ylens, magnification, true); %ten = img1

% 変換行列の導出
% [mp, fp] = cpselect(J2, ten, 'Wait', true);
mp = [298.250000000000	606.250000000000
4125.75000000000	594.749999999999
322.250000000000	7208.75000000000
4114.75000000000	7257.75000000000];

mp_length = length(mp);

% transformation_matrix関数を呼び出し
[registered] = transformation_matrix(result_Dir, J2, imds, plot_statas, mp, true, mp_length);

% [mp2, fp] = cpselect(registered, ten, 'Wait', true);
mp2 = [380	701
4771	700
380	8386
4771	8388
1550.00000000000	3535.00000000000
2060	3539.00000000000
2645.00000000000	3587.00000000000
3157.00000000000	3586.00000000000
1479	4174.00000000000
2166	4163
2538	4162
2923.00000000000	4172
1488.00000000000	4706
2084	4692
2505	4619
3004	4607
1493	5217
2059	5188
2431	5182
2747.00000000000	5193
3074	5216
1537	5547
2161	5597
2631	5570
2957.00000000000	5594
3262	5593];

mp_length = length(mp2);

ten_Multipul(mp2, result_Dir,IMG ,xlens, ylens, magnification,pix, pix2, y_axis, x_axis) %任意のplotした点のten画像を作成

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~再度抽出，５点目以降を修正
% load_photo関数を呼び出し
[imds, ten, plot_statas] = load_video(result_Dir, xlens, ylens, magnification, false); %任意のplotした点のten画像の読み込み

[registered] = transformation_matrix(result_Dir, registered, imds, plot_statas, mp2, false, mp_length); %任意のplotした点のten画像とregisterのafin変換を行う
