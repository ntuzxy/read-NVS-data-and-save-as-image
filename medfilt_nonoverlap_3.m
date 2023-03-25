function [xco,yco]=medfilt_nonoverlap_3(frame)
% load('bin_image.mat')
% frame=bin_image{frameNo}.frame;
x_max=size(frame,1);
y_max=size(frame,2);
frames=zeros(x_max/3,y_max/3);
imshow(double(frame))
for i=1:3:x_max
    for j=1:3:y_max
        temp=frame(i:i+2,j:j+2);
        temp_sum=sum(sum(temp))>4;
        if (temp_sum==1)
            for l=0:2
                for k=0:2
                frames((i+2)/3,(j+2)/3)=temp_sum;
                end
            end
        end
    end
end
figure
imshow(double(frames))
%[yco,xco]=find(frames==1);
%xco=dec2hex(xco,2);
%yco=dec2hex(yco,2);