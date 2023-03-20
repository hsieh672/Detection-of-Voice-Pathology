path = 'C:\Users\謝佳彤\Desktop\DSP專題二\mfcc\mfcc_nor_train\';% 輸入mfc檔路徑資料夾
 cd(path)                                 % 進入選取的資料夾
 file=dir([path '\*.mfc']);
 Data= [];
for i = 1:length(file)
     cep_data = load(file(i).name);            % 讀入每個mfc檔
     number_person1(i,:) = length(cep_data(:,1));  % 每個mfc檔的長度
 	Data= [Data;cep_data];                 % 與上個mfc檔進行串聯
 end
 lable=zeros(length(Data),1)
 Data_normal_train=[lable Data]
 
 
 path = 'C:\Users\謝佳彤\Desktop\DSP專題二\mfcc\mfcc_im_train\';% 輸入mfc檔路徑資料夾
 cd(path)                                 % 進入選取的資料夾
 file=dir([path '\*.mfc']);
 Data= [];
 for i = 1:length(file)
     cep_data = load(file(i).name);            % 讀入每個mfc檔
     number_person2(i,:) = length(cep_data(:,1));  % 每個mfc檔的長度
 	Data= [Data;cep_data];                 % 與上個mfc檔進行串聯
 end
 lable=ones(length(Data),1)
 Data_im_train=[lable Data]
 
 Data_train=[Data_normal_train;Data_im_train]
  
 path = 'C:\Users\謝佳彤\Desktop\DSP專題二\mfcc\mfcc_nor_test\';% 輸入mfc檔路徑資料夾
 cd(path)                                 % 進入選取的資料夾
 file=dir([path '\*.mfc']);
 Data= [];
 for i = 1:length(file)
     cep_data = load(file(i).name);            % 讀入每個mfc檔
     number_person3(i,:) = length(cep_data(:,1));  % 每個mfc檔的長度
 	Data= [Data;cep_data];                 % 與上個mfc檔進行串聯
 end
 lable=zeros(length(Data),1)
 Data_normal_test=[lable Data]
 
 
 path = 'C:\Users\謝佳彤\Desktop\DSP專題二\mfcc\mfcc_im_test\';% 輸入mfc檔路徑資料夾
 cd(path)                                 % 進入選取的資料夾
 file=dir([path '\*.mfc']);
 Data= [];
 for i = 1:length(file)
     cep_data = load(file(i).name);            % 讀入每個mfc檔
     number_person4(i,:) = length(cep_data(:,1));  % 每個mfc檔的長度
 	Data= [Data;cep_data];                 % 與上個mfc檔進行串聯
 end
 lable=ones(length(Data),1)
 Data_im_test=[lable Data]
 
 Data_test=[Data_normal_test;Data_im_test]


