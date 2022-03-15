clear all

vidObj = VideoReader('shuttle.avi');
frames = read(vidObj, [1 115]);
for f = 1:size(frames, 4)
    F(size(frames,4))=struct('cdata',[],'colormap',[]);
    h=figure(1);clf;
    set(h,'position',[0 0 1067 400]);
    imagesc(frames(:,:,:,f));
    pause(0.01);
    F(f)=getframe(gcf);
end
movie2gif(F,'result.gif','DelayTime',0.1,'LoopCount',1000);

