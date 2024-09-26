function ten_Multipul(mp2, imageFolder, IMG, tLenskosuu, yLenskosuu, magnification, pix, pix2, y_axis, x_axis)
    % mp2とfp2をワークスペースに出力
    assignin('base', 'mp2', mp2);

    Allhairetu = numel(mp2);
    INhairetu = Allhairetu / 2;
    Ptate = zeros(1,500); % zeros(1,1000000)これは配列を1～1000000まで事前に作って，処理を高速化させている
    Pyoko = zeros(1,500);
    Tateset = zeros(1,500);
    saitei = 5; % mp2(5,1),mp2(5,1)から下のものを測定する
    Alllenstate = zeros(1,500);
    lenstate = zeros(1,500);
    lensyoko = zeros(1,500);
    plot_statas = {};

    tate = mp2(3,2) - mp2(1,2); % 縦の長さの中にa=333.91=7680
    yoko = mp2(2,1) - mp2(1,1); % 横の長さ ""   b=c=187.83=4320

    for i = 1:INhairetu
        Ptate(i) = mp2(i,2) - mp2(1,2); % pointのy軸
        Pyoko(i) = mp2(i,1) - mp2(1,1); % pointのx軸を抽出
        saitei = saitei + 1;
    end
    
    assignin('base', 'INhairetu', INhairetu);
    ttLenskosuu = tLenskosuu * 2; % 668 / 23して*2したレンズの総数

    for i = 1:INhairetu
        Alllenstate(i) = round((ttLenskosuu * Ptate(i)) / tate); % img1の全体(668)のlensの位置を測定
        if Alllenstate(i) >= 0
            Tateset(i) = rem(Alllenstate(i), 2); % 余りを判定して，奇数or偶数を判断
        else
            Tateset(i) = 1;
        end
    end 

    for i = 1:INhairetu
        if Tateset(i) ~= 0
            if Ptate(i) >= 0
                lenshitotu = tate / tLenskosuu;
                Ptate(i) = Ptate(i) + lenshitotu;
                lenstate(i) = round((tLenskosuu * Ptate(i)) / tate); % img1(334)のlensの位置を測定
                lensyoko(i) = round((yLenskosuu * Pyoko(i)) / yoko); % img1(188)のlensの位置を測定
            else
                Tateset(i) = 1; % 余りを判定して，奇数or偶数を判断
                lenstate(i) = 0;
                lensyoko(i) = round((yLenskosuu * Pyoko(i)) / yoko); % img1(188)のlensの位置を測定
            end
        else
            lenstate(i) = round((tLenskosuu * Ptate(i)) / tate); % img1(334)のlensの位置を測定
            lensyoko(i) = round((yLenskosuu * Pyoko(i)) / yoko); % img1(188)のlensの位置を測定
        end
    end
    assignin('base', 'lenstate', lenstate);
    assignin('base', 'lensyoko', lensyoko);
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~抽出した点にplot
    ee = 0;

    subpixelRedCoordinates = [];
    coordinateIndex = 1; % 座標のインデックス

    for i = 1:INhairetu
        if Tateset(i) == 0 % ~=0は赤点で示した場所
            a = 0;
            b = 0;
            for x = pix2:pix:y_axis % 赤点のほう
                if a == lenstate(i)
                    for y = pix2:pix:x_axis
                        if b == lensyoko(i)                          
                            IMG(x, y, 1) = 255; % (縦,横,1 or 2 or 3)
                            IMG(x+1, y, 1) = 255; % (縦,横,1 or 2 or 3)
                            IMG(x, y+1, 1) = 255; % (縦,横,1 or 2 or 3)
                            IMG(x+1, y+1, 1) = 255; % (縦,横,1 or 2 or 3)
                            % 新しい座標を追加
                            subpixelRedCoordinates = [subpixelRedCoordinates; x, y];
                            fprintf('Red Coordinate Detected %d: (%d, %d)\n', coordinateIndex, x, y); % 座標を表示
                            coordinateIndex = coordinateIndex + 1; % インデックスを更新
                        end  
                        b = b + 1;
                    end
                end
                a = a + 1;
            end
        else
            a = 0;
            b = 0; % なぜ1なの？！  
            for x = pix:pix:y_axis
                if a == lenstate(i)
                    for y = pix:pix:x_axis
                        if b == lensyoko(i)
                            IMG(x, y, 1) = 255; % (縦,横,1 or 2 or 3)
                            IMG(x+1, y, 1) = 255; % (縦,横,1 or 2 or 3)
                            IMG(x, y+1, 1) = 255; % (縦,横,1 or 2 or 3)
                            IMG(x+1, y+1, 1) = 255; % (縦,横,1 or 2 or 3)
                            % 新しい座標を追加
                            subpixelRedCoordinates = [subpixelRedCoordinates; x, y];
                            fprintf('Red Coordinate Detected %d: (%d, %d)\n', coordinateIndex, x, y); % 座標を表示
                            coordinateIndex = coordinateIndex + 1; % インデックスを更新
                        end  
                        b = b + 1;
                    end
                end
                a = a + 1;
            end
        end
    end

    time = 0;

    subpixelRedCoordinates = subpixelRedCoordinates(:, [2, 1]);
        
%     [getsubpixcel] = getSubpixelCoordinates(IMG,false,1);
%     assignin('base', 'getsubpixcel', getsubpixcel);
    assignin('base', 'subpixelRedCoordinates', subpixelRedCoordinates);

    % 検出された赤点の数
%     numPoints = size(subpixelRedCoordinates, 1);

    % 順序を維持したままのサブピクセル精度の座標
    newSubpixelRedCoordinates = subpixelRedCoordinates * magnification;
    assignin('base', 'newSubpixelRedCoordinates', newSubpixelRedCoordinates);

    % 画像を保存
    L = imresize(IMG, magnification);   % 23の時333.91に対し、23.3626の時は328.73のため、23.3626似合わせようとすると、0.984倍する
    L1 = imcrop(L, [0 0 4320 7680]); % ↑1.007は縦がいい感じ(a=333c=187の時) 1.02
    imwrite(L1, fullfile(imageFolder, sprintf('second_afin_%d_%d_%.5f.png', tLenskosuu, yLenskosuu, magnification)));

    plot_statas{end+1} = newSubpixelRedCoordinates;
    disp('Red Subpixel Coordinates:');
    disp(newSubpixelRedCoordinates);

    % 座標を保存して次のスクリプトで使用
    save(fullfile(imageFolder, 'second_coordinates.mat'), 'plot_statas');
end
