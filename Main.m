clear all
clc

imgList = dir('C:\Users\rams1\Desktop\Spring2016\CV\Projects\Project_1\EnterExitCrossingPaths2cor\EnterExitCrossingPaths2cor\*.jpg');
imgNos = length(imgList);

for i=1:imgNos
    cd('C:\Users\rams1\Desktop\Spring2016\CV\Projects\Project_1\EnterExitCrossingPaths2cor\EnterExitCrossingPaths2cor\')
    filename = imgList(i).name;
    %OrigI{i} = rgb2gray(imread(filename));
    ipre{i}=imread(filename);
    OrigI{i} = rgb2gray(ipre{i});
end
cd('C:\Users\rams1\Desktop\Spring2016\CV\Projects\Project_1\');

tempoDer = 0.5*[-1,0,1];
tsigma = 1;%input('Enter tsigma: ');
ssigma = 1;%input('Enter ssigma: ');
g1D = fspecial('gaussian',[5*tsigma,1],tsigma);
gau1D = gradient(g1D)';
box3 = 1/9*ones(3,3);
box5 = 1/25*ones(5,5);
gau2D = fspecial('gaussian',[5*ssigma,5*ssigma],ssigma);

%%
% Temporal Derivative and then 1D gaussian
for i=1:imgNos
    filtI{i} = imfilter(imfilter(OrigI{i},gau2D),gau1D);
end

[~,sig] = EST_NOISE(filtI,imgNos);
sig1 = mean2(sig/5);

for i=1:imgNos
    i
    filtIa{i} = im2bw(filtI{i},sig1);
    if i<imgNos
        filtIb{i} = im2bw(filtI{i+1},sig1);
        filtIfin{i}=filtIb{i}-filtIa{i};
    else
        filtIfin{i}=filtI{i-1};
    end
        
end
writerObj = VideoWriter('trial.mp4');
open(writerObj);
figure(1);
for i=1:1:imgNos-1
    i
    filtIfin{i} = medfilt2(uint8(filtIfin{i})*255);
    img=filtIfin{i};
    filtIfin{i}=zeros(size(ipre{i}));
    filtIfin{i}(:,:,2) = img;
    filtIall{i}=(ipre{i+1}+uint8(filtIfin{i}));
    %filtI{i}=adapth(filtI{i},3,0.04,0);
    pause(0.02);
    imshow(filtIall{i});
    writeVideo(writerObj,filtIall{i});
end
close(writerObj);