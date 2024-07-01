clc
clear all
%loading images to matrix
imageDir='C:\Users\RAGHURAM BB\OneDrive\Desktop\Research\POD\run 5_C001H001S0001-20240531T050900Z-001\clear';
imageFiles=dir(fullfile(imageDir,"*.tif"));

if isempty(imageFiles)
    error('No images found in this directory.');
end

firstImage=imread(fullfile(imageDir,imageFiles(1).name));
[rows,cols]=size(firstImage);
dims=size(firstImage);

numImages=length(imageFiles);
imagematrix=zeros(rows*cols,numImages);

for i=1:numImages
    img=imread(fullfile(imageDir,imageFiles(i).name));
    img=double(img)-double(repmat(mean(img,1),[dims(1) ones(1,length(dims)-1)]));
    %img=double(img)-double(mean(img(:))*ones(rows,cols));
    imagematrix(:,i)=img(:);
end

[total_rows,total_cols]=size(imagematrix);
%%

[U,S,V]=svd(imagematrix,0);

[row_S,col_S]=size(S);%S-square matrix

%no of dominant modes, setting the criteria as 95% of total energy
sum_eig=0;
for i=1:row_S
    sum_eig=S(i,i)+sum_eig;
end
sum_eig_i=0;
i=1;
dom=0;
while dom<0.95
    sum_eig_i=S(i,i)+sum_eig_i;
    dom=sum_eig_i/sum_eig;
    i=1+i;
end
no_of_dominant_modes=i;
no_of_dominant_modes
%printing number of dominant modes so that we can reconstruct it back again


%QR
Q=U*S(:,1:10);
%size(Q);
R=V(1:10,:);
%size(R);
%imagematrix_dom=Q.*transpose(R);
%size(imagematrix_dom)
dominant_1=Q(:,1);
dominant_2=Q(:,2);
dominant_3=Q(:,3);
dominant_4=Q(:,4);
dominant_5=Q(:,5);
dominant_6=Q(:,7);
%size(dominant_1)
%%
% Reconstruction with dominant modes
for j=no_of_dominant_modes:row_S
    S(j,j)=0;  
end
%multiplying again to get reconstructed flow dynamics
A_reconstruct=U*S*V;
[rows_reconstruct,cols_reconstruct]=size(A_reconstruct);

for i=1:cols_reconstruct
first_row_reconstructed(:,:,i)=reshape1(A_reconstruct(:,i),rows,cols);
min_value=min(first_row_reconstructed(rows,cols,i));
max_value=max(first_row_reconstructed(rows,cols,i));
I1(:,:,i)=mat2gray(first_row_reconstructed(:,:,i));
end
%%
size(I1)
figure()
imshow(I1(:,:,5))
%%
%figure()
%ax2=nexttile;
%imshow(reshape1(dominant_1,rows,cols))
%colormap(ax2,othercolor('Cat_12'))
%colorbar(ax2)


function [trans]=reshape1(x,rows,cols)
trans=reshape(x,[rows,cols]);
end
