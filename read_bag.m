%%
% Based on Radim Tylecek file to read pcl documents (bags and their messages):
% https://gitlab.inf.ed.ac.uk/Bishop/MultiKinect/blob/master/ros/read_pcl_modified.m
%%
FolderName = '/home/hanz/Documents/Thesis/Bags/Images';
filepath = fullfile('tools_2017-06-02-16-29-49.bag');
bag1 = rosbag(filepath);

n = 4; %number of cameras (kinects)
for ki = 1:n
    % Selecting the topics of bag1
    points = select(bag1,'Topic',sprintf('/kinect_%d/hd/points',ki)); 
    images = select(bag1,'Topic',sprintf('/kinect_%d/hd/image_color_rect',ki)); 
    
    %% We choose the number of messages we want to read in this case: 1
    rpoints = readMessages(points,1);
    rimages = readMessages(images,1);
    
    %% Select the last frame
    ptcloud = rpoints{end};
    img = rimages{end};
    
    %% Getting the pointcloud
    xyz = readXYZ(ptcloud);
    rgb = readRGB(ptcloud);
    pcl = pointCloud(xyz, 'Color', rgb);
 
     
    %% Getting the image
    cam = readImage(img);
    
    %% write (calibs/extrinsic/test)
    pcwrite_modified(pcl,sprintf('K%d_hd_pcl_rgb.ply',ki));
    imwrite(cam,sprintf('Segmentation_K%d.png',ki));
    %imwrite(cam,sprintf('K%d_hd_image_color_rect.png',ki));
    
    %% show
    figure(1); subplot(2,2,ki); imshow(cam);
    figure(2); subplot(2,2,ki); pcshow(pcl);
    

end
