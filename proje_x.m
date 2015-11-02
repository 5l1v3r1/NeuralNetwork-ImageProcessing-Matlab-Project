I = imread('benn.jpg');
%okunan resmin boyutu g�ncellenir
I = imresize(I,[640 480]);

%g�z ve burun tespitinde hassasiyet ayar� (Visual Computer Toolbox)
sensitivity_nose = 30;
sensitivity_lib = 200;

%g�z tespiti
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
EyePosition = step(EyeDetect,I); % Eye Position => [x,y,Height,Width]
figure , imshow(I);
title('g�z belirlendi');
rectangle('Position',EyePosition,'LineWidth',1,'LineStyle','-','EdgeColor','g');

%burun tespiti
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',sensitivity_nose);
NosePosition=step(NoseDetect,I);
figure,
imshow(I); hold on
for i = 1:size(NosePosition,1)
    rectangle('Position',NosePosition(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','b');
end
title('Nose Detection');
hold off;

%dudak tespiti
LibDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',sensitivity_lib);
LipPosition=step(LibDetect,I);
figure,imshow(I); hold on
for i = 1:size(LipPosition,1)
    rectangle('Position',LipPosition(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','r');
end
title('Mouth Detection');
hold off;

% EyePosition(1)=x, EyePosition(2)=y, EyePosition(3)=Height, EyePosition(4)=Width
L_eye_to_R_eye_distance = EyePosition(3);
eye_to_nose_distance = (NosePosition(2) + NosePosition(4)/2)-(EyePosition(2) + EyePosition(4)/2);

Ratio1 = L_eye_to_R_eye_distance / eye_to_nose_distance;

eye_to_lip_distance = (LipPosition(2) + LipPosition(4)/2)-(EyePosition(2) + EyePosition(4)/2);

Ratio2 = L_eye_to_R_eye_distance / eye_to_lip_distance;

eye_to_chin_distance = 640 - (EyePosition(2) + EyePosition(4)/2); 
%y�z olarak gelen resmin yani dikeydeki son pixel �eneyi ifade edece�i
%i�in(480x640)px olarak gelen resim olcu�undan 640 ' dan ��kar�lm��t�r.

Ratio3 = eye_to_nose_distance / eye_to_chin_distance;

Ratio4 = eye_to_nose_distance / eye_to_lip_distance;

% E�itim i�in neural network giri� ve hedef verileri
%nn_input = [ giris_11 giris_12 giris_13 giris_14 giris_15 giris_21 giris_22 giris_23 giris_24 giris_25 giris_31 giris_32 giris_33 giris_34 giris_35 ]
%nn_target = [ 001 001 001 010 010 010 011 011 011 100 100 100 101 101 101 ]

%test edinlen bireyin y�z hatt�ndaki oranlar�n vekt�r�
test = [Ratio1; Ratio2 ;Ratio3; Ratio4];

%kullan�lancak olan network a��n�n test ��k��
%burada network4 a�� �nceden haz�rlanm�� bir pakettir. ve bu kodun
%�al��mas� i�in workspace'e import edilmelidir.
outputs = network4(test)

%sonu�
if outputs > 0 && outputs < 10
    disp('test 18 ile 25 ya� aras�ndad�r')
end
if outputs > 10 && outputs < 80
    disp('test 26 ile 35 ya� aras�ndad�r')
end
if outputs > 80 && outputs < 105
    disp('test 36 ile 45 ya� aras�ndad�r')
end


