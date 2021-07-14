function GLCM2(citra)
clc; clear; close;

[namefile,formatfile] = uigetfile({'*.png';'*.bmp';'*.jpg';'*.tif'},'Open Image');
image = imread([formatfile, namefile]);

citra = rgb2gray(image);
H=imhist(citra)';
H=H/sum(H);
I=[0:255];

CiriMEAN = I*H';
CiriENT  = -H*log2(H+eps)';
foo = H.^2;
CiriEN   = sum (foo(:));
CiriVAR  = (I-CiriMEAN).^2*H';
CiriSKEW = (I-CiriMEAN).^3*H'/CiriVAR^1.5;
CiriKURT = (I-CiriMEAN).^4*H'/CiriVAR^2-3;

%ko000.m - MATRIKS KOOKURENSI ARAH 0 DERAJAT [mk000=ko000(citra);]
Original=double(citra);
Temp=zeros(256);
[tinggi,lebar]=size(Original);
for i=1:tinggi
    for j=1:lebar-1
           p=Original(i,j)+1;
           q=Original(i,j+1)+1;
           Temp(p,q) = Temp(p,q)+1 ;
           Temp(q,p) = Temp(q,p)+1 ;
    end
end
Jumlahpixel=sum(sum(Temp));
mk000=Temp/Jumlahpixel;

%ko045.m - MATRIKS KOOKURENSI ARAH 45 DERAJAT [mk045=ko045(citra);]
Original=double(Original);
Temp=zeros(256);
[tinggi,lebar]=size(Original);
for i=2:tinggi
    for j=1:lebar-1
            p=Original(i,j)+1;
            q=Original(i-1,j+1)+1;
            Temp(p,q) = Temp(p,q)+1;
            Temp(q,p) = Temp(q,p)+1;
    end
end
Jumlahpixel=sum(sum(Temp));
mk045=Temp/Jumlahpixel;

%ko090.m - MATRIKS KOOKURENSI ARAH 90 DERAJAT [mk090=ko090(citra);]
Original=double(Original);
Temp=zeros(256);
[tinggi,lebar]=size(Original);
for i=2:tinggi
    for j=1:lebar
        p=Original(i,j)+1;
        q=Original(i-1,j)+1;
        Temp(p,q) = Temp(p,q)+1 ;
        Temp(q,p) = Temp(q,p)+1 ;
    end
end
Jumlahpixel=sum(sum(Temp));
mk090=Temp/Jumlahpixel;

%ko135.m - MATRIKS KOOKURENSI ARAH 135 DERAJAT [mk135=ko135(citra);]
Original=double(Original);
Temp=zeros(256);
[tinggi,lebar]=size(Original);
for i=2:tinggi
    for j=2:lebar
        p=Original(i,j)+1;
        q=Original(i-1,j-1)+1;
        Temp(p,q) = Temp(p,q)+1 ;
        Temp(q,p) = Temp(q,p)+1 ;
    end
end
Jumlahpixel=sum(sum(Temp));
mk135=Temp/Jumlahpixel;

Matkook=(mk000+mk045+mk090+mk135)/4;

I=[1:256];
SumX=sum(Matkook);  
SumY=sum(Matkook');
MeanX=SumX*I';      
MeanY=SumY*I';
StdX=sqrt((I-MeanX).^2*SumX');
StdY=sqrt((I-MeanY).^2*SumY');

CiriCON=0;CiriCOR=0;CiriHOM=0;
for i=1:256
    for j=1:256
        TempCON     =    (i-j)*(i-j)*Matkook(i,j);
        TempCOR     =    (i)*(j)*Matkook(i,j);
        TempHOM     =    (Matkook(i,j))/(1+(i-j)*(i-j));
        foo         =    (Matkook(i,j).^2);
        CiriCON =  CiriCON + TempCON;
        CiriCOR =  CiriCOR + TempCOR;
        CiriHOM =  CiriHOM + TempHOM;  
    end
end
CiriCOR=(CiriCOR-MeanX*MeanY)/(StdX*StdY);

fprintf('\n\tMean       :%10f\n',CiriMEAN);
fprintf('\n\tVariance   :%10f\n',CiriVAR );
fprintf('\n\tSkewness   :%10f\n',CiriSKEW);
fprintf('\n\tKurtosis   :%10f\n',CiriKURT);
fprintf('\n\tEntropy    :%10f\n',CiriENT);
fprintf('\n\tEnergy     :%10f\n',CiriEN );
fprintf('\n\tCONTRAST   :%10f\n',CiriCON);
fprintf('\n\tCORRELATION:%10f\n',CiriCOR);
fprintf('\n\tHOMOGENITY :%10f\n',CiriHOM);

features =[CiriMEAN CiriVAR CiriSKEW CiriKURT CiriENT CiriEN CiriCON CiriCOR CiriHOM];
Pin = ([features])';
save Pin 
        







