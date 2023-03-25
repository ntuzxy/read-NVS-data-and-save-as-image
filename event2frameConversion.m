
load("visualroad1.mat");
filename = 'visualroad1';
%%
epoch_time = 66e3;
a_maxYSize = 960;
a_maxXSize = 1280;
frame_ctr = 0;
save_image = 0;
tstart=TD.ts(1);
frame = zeros(a_maxYSize,a_maxXSize);
framesFolder = ['./',filename,'_frames'];

if ~exist(framesFolder, 'dir')
    mkdir(framesFolder);
end

for i=1:length(TD.ts)
    t = TD.ts(i);
    x = TD.x(i);
    y = TD.y(i);
    frame(y,x) = 1;
   
    if t - tstart > epoch_time
        frame_cnt = frame_cnt + 1;
        tstart=t;
%         frame = flip(frame,1); %upside down
        %can perform median filtering or other operations on the accumlated image if needed
        if save_image
            imwrite(frame,[framesFolder,'/',num2str(frame_cnt),'.jpg']);
        end
        imshow(frame);
%         imshow(double(1-frame))
        frame = zeros(a_maxYSize,a_maxXSize);
    end

end