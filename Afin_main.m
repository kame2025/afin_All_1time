clc; close all; imtool close all; clear;

result_Dir = 'C:\Users\SISLa\MATLAB\Projects\afin_All_1time\出力結果\ten';

% 初期設定
xlens = 328;
ylens = 187;
% magnification = 1.01739;

% 画像の読み込みと前処理
I = imread('089A9354.JPG');
J = imrotate(I, 90);

J2 = imcrop(J, [100 0 4319 7680]); %img2
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
[imds, ten, plot_statas] = load_photo(result_Dir, xlens, ylens, magnification, true); %ten = img1

% 変換行列の導出
continueRun = true; % ループを続けるフラグ
while continueRun
    [x, y] = ginput(1); % 1回クリックで座標を取得
    mp = [x, y];
    disp(['Clicked at X: ', num2str(x), ', Y: ', num2str(y)]);
end
% [mp, fp] = cpselect(J2, ten, 'Wait', true);
% mp = [818.250000000000	1028.75000000000
% 4240.75000000000	1032.25000000000
% 830.750000000000	6987.25000000000
% 4257.75000000000	6996.25000000000];

mp_length = length(mp);

% transformation_matrix関数を呼び出し
[registered] = transformation_matrix(result_Dir, J2, imds, plot_statas, mp, true, mp_length);

[mp2, fp] = cpselect(registered, ten, 'Wait', true);
% mp2 = [1068.75000000000	1331.75000000000
% 5465.25000000000	1332.25000000000
% 1068.75000000000	9007.25000000000
% 5466.75000000000	9008.25000000000
% 3010	3725.00000000000
% 3475	3701.00000000000
% 3845.00000000000	3698.00000000000
% 4162	3708.00000000000
% 4500	3700.00000000000
% 2996	4017.00000000000
% 3414	4036.00000000000
% 3671	4037.00000000000
% 3987.00000000000	4026.00000000000
% 4430	3977.00000000000
% 2908	4201.00000000000
% 3369	4203.00000000000
% 3708	4166.00000000000
% 4129	4189.00000000000
% 4513	4176.00000000000
% 2880.00000000000	4509.00000000000
% 3380	4518.00000000000
% 3687.00000000000	4538.00000000000
% 4025	4529.00000000000
% 4477	4515.00000000000
% 2937	4850.00000000000
% 3383	4871.00000000000
% 3815.00000000000	4904.00000000000
% 4255	4903.00000000000
% 4641	4913.00000000000
% 2950	5165.00000000000
% 3486.00000000000	5185.00000000000
% 3790.00000000000	5185.00000000000
% 4395	5184.00000000000
% 4663	5171.00000000000
% 3006	5458.00000000000
% 3545	5477.00000000000
% 3848.00000000000	5570.00000000000
% 4359	5523.00000000000
% 4664	5497
% 2960	5807.00000000000
% 3438.00000000000	5793.00000000000
% 3695	5792.00000000000
% 4102	5826
% 4628	5814.00000000000
% 3006	6250
% 3390	6234.00000000000
% 3799	6249.00000000000
% 4148	6247
% 4592	6223
% ];

mp_length = length(mp2);

ten_Multipul(mp2, result_Dir,IMG ,xlens, ylens, magnification,pix, pix2, y_axis, x_axis) %任意のplotした点のten画像を作成

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~再度抽出，５点目以降を修正
% load_photo関数を呼び出し
[imds, ten, plot_statas] = load_photo(result_Dir, xlens, ylens, magnification, false); %任意のplotした点のten画像の読み込み

[registered] = transformation_matrix(result_Dir, registered, imds, plot_statas, mp2, false, mp_length); %任意のplotした点のten画像とregisterのafin変換を行う
