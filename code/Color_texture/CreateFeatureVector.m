function input = CreateFeatureVector( input )
 
         num_patch = 6;                                                     %6, 14, 75, 341
         numP = [6 14 75 341]; 
         num = size(input.group1,2);
         steps =flipud([4, 4; 8 8; 16 16; 48 21]);                          % set the moving step size of the region.
         BBoxszs =flipud([8,8; 16 16; 32 32; 48 22]);                       % set the region size.

         n8LBP_Mapping = getmapping(8,'u2');
         n16LBP_Mapping = getmapping(16,'u2');
         
        for i = 1:size(input.data,1) 
            for j = 1:num
             %% Color
             img = input.data{i}{j}.img;
             
              one_color_fv = CreateImageFeatureVector( img );

%%  LBP
              I{1}=input.data{i}{j}.img;
              imgsizes = cellfun(@size, I, 'uni',0);
              imgsizes = cell2mat(imgsizes');
              I = cellfun(@(x) imresize(x,[128 48]),I,'uni',0);
              LBP_Feature = HistLBP(I,16,BBoxszs(numP==num_patch,:),...
                  steps(numP==num_patch,:),n8LBP_Mapping,n16LBP_Mapping);
%               LBP_Feature=LBP_Feature(:,j);
            
            
             %% HOG
%              rgbIm2=rgb2gray(img);
%              rgbIm2=imresize(rgbIm2,[128,64]);
%              
%              hhog=hog(rgbIm2);
% %              imshow(hhog)
%              NNu=size(hhog,1)*size(hhog,2);
%              input.hog_h=size(hhog,1);
%              input.hog_w=size(hhog,2);
%              Hog = reshape(hhog,1,NNu);
%              input.hog{i}(j,:)=Hog;
             %% RGB
%              II = rgb2gray(img);
%              II=double(II)./255;
%              II=imresize(II,[128 64]);
%              Numn=128*64;
%              input.Pic{i}(j,:) = reshape(II,1,Numn);
             All_fv=[one_color_fv;LBP_Feature];
             if i==1
                 input.Xview1=[input.Xview1,All_fv];
             else
                 input.Xview2=[input.Xview2,All_fv];
             end
            end
        end
   
     
end


