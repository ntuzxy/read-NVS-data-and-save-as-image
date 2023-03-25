
%% DVS128 datasets are downloaded from https://sourceforge.net/p/jaer/wiki/AER%20data/

%%%% Moving camera %%%%
% fname_dat = 'Tmpdiff128-2006-02-14T07-45-15-0800-0 walk to kripa.dat'; %Walking
% fname_dat = 'events-2005-12-28T11-14-28-0800 drive SC postoffice.dat'; %Driving on the street

%%%% Static camera %%%%
% fname_dat = 'events20051221T014416 freeway.dat'; %freeway
fname_dat = 'Tmpdiff128-2006-02-10T14-22-35-0800-0 hand for orientation.dat'; %Moving hand
% fname_dat = 'Tmpdiff128-2006-02-23T12-48-34+0100-0 patrick juggling.dat'; %high speed juggling
% fname_dat = 'Tmpdiff128-2006-09-04T08-51-54+0200-0 mouse 3p5d bg filtered.dat'; %mouse activity
% fname_dat = 'Tmpdiff128-2007-02-28T15-08-15-0800-0 3 flies 2m 1f.dat'; %flying flies
% fname_dat = 'Tmpdiff128-2006-06-17T10-48-06+0200-0 vogelsang saturday monring #2.dat'; %Street scene with cars and people walking

data_mat = dat2mat(fname_dat);
data_t = data_mat(:,1);
data_x = data_mat(:,4);
data_y = data_mat(:,5);
data_p = data_mat(:,6);

%%
epoch_time = 100e3;
a_maxYSize = 128;%max(data_x) + 1;
a_maxXSize = 128;%max(data_y) + 1;
frame_cnt = 0;
save_image = 1;  
tstart = data_t(1);
frame = zeros(a_maxYSize,a_maxXSize);

filename = 'dvs';
framesFolder = ['./',filename,'_frames'];
if ~exist(framesFolder, 'dir')
    mkdir(framesFolder);
end

for i=1:length(data_t)
    t = data_t(i);
    x = data_x(i) + 1;
    y = data_y(i) + 1;
    frame(y,x) = 1;

    if t - tstart > epoch_time
        frame_cnt = frame_cnt + 1;
        tstart=t;
        frame = flip(frame,1); %upside down
        %can perform median filtering or other operations on the accumlated image if needed
        if save_image
            imwrite(frame,[framesFolder,'/',num2str(frame_cnt),'.jpg']);
        end
        imshow(frame);
%         imshow(double(1-frame))
        frame = zeros(a_maxYSize,a_maxXSize);
    end
end
