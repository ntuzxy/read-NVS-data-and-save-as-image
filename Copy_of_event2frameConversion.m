
load("visualroad1.mat");
filename = 'visualroad1';
epoch_time = 66e3;
a_maxYSize = 960;
a_maxXSize = 1280;
frame_ctr = 0;
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
   
    if t-tstart>epoch_time

        frame_ctr = frame_ctr + 1;

        %save frame as jpg
       
        tstart=t;
        %imwrite(frame,[framesFolder,'/',num2str(frame_ctr),'.jpg']);
        %imshow(frame);
   
        %can perform median filtering or other operations on the accumlated

        %binary frame
        stride=3;
        x_max=size(frame,1);
        y_max=size(frame,2);
        frames=zeros(x_max,y_max);
       % imshow(double(frame))
        for i_i=1:stride:x_max-stride+1
            for j=1:stride:y_max-stride+1
                temp=frame(i_i:i_i+stride-1,j:j+stride-1);
                temp_sum=sum(sum(temp))>(stride*stride)/2;
                if (temp_sum==1)
                    for l=0:stride-1
                        for k=0:stride-1
                            frames(i_i+l,j+k)=temp_sum;
                        end
                    end
                end
            end
        end
        %figure
        frames(:,a_maxXSize)=0;
        frames(a_maxYSize,:)=0;
        imshow(double(1-frames))
        frame=0;
        %%
        [x_low,x_high]=x_proj(frames);
        y_low=[];
        y_high=[];
        x_index=[];
        for k=1:length(x_low)
            k;
            dummy_frame=zeros(a_maxYSize,a_maxXSize);
            dummy_frame(1:a_maxYSize,x_low(k):x_high(k))=1;
            frame_temp=frames.*dummy_frame;

            %frame_temp=frames(1:a_maxYSize,x_low(k):x_high(k));
            [y_low_temp,y_high_temp]=x_proj(frame_temp');
            y_low=[y_low y_low_temp];
            y_high=[y_high y_high_temp];
            %%%% x_index calculation
            x_index=[x_index (y_high_temp>0)*k];
        end
        %%%%%%
        x_low_search=x_low;
        x_high_search=x_high;
        x_low=[];
        x_high=[];

        for k=1:length(y_low)
            k;

            dummy_frame=zeros(a_maxYSize,a_maxXSize);
            dummy_frame(y_low(k):y_high(k),x_low_search(x_index(k)):x_high_search(x_index(k)))=1;

            frame_temp=frames.*dummy_frame;

            %frame_temp=frames(y_low(k):y_high(k),x_low_search(x_index(k)):x_high_search(x_index(k)));
            [x_low_temp,x_high_temp]=x_proj(frame_temp);
            x_low=[x_low x_low_temp];
            x_high=[x_high x_high_temp];
        end
        number_of_regions=min(size(x_high,2),size(y_high,2))
        %%% area of the regions calculation
        area=[];
        for k=1:number_of_regions
            area(k)=(x_high(k)-x_low(k))*(y_high(k)-y_low(k));
        end

        for k = 1 : number_of_regions
            rectangle('Position', [x_low(k),y_low(k),x_high(k)-x_low(k),y_high(k)-y_low(k)],...
            'EdgeColor','r','LineWidth',2 )
        end
        
        frame_stat(frame_ctr,1)=number_of_regions;
        frame_stat(frame_ctr,2)=sum(area);
        frame_stat(frame_ctr,3)=sum(area)*100/(960*1280);

        k;
    end
    frame(y,x) = 1;

end