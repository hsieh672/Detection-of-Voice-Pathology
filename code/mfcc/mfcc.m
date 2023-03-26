clc;
clear;
tic;
%Normal/FD
% clear
in_path='C:\Users\謝佳彤\Desktop\DSP專題二\im\cancer\';
out_path='C:\Users\謝佳彤\Desktop\DSP專題二\mfcc\mfcc_cancer\';
out_ext='.mfc';
mfcc_all_v1(in_path,out_path,out_ext);
fprintf('complete\n');

in_path2='C:\Users\謝佳彤\Desktop\DSP專題二\im\CYST\';
out_path2='C:\Users\謝佳彤\Desktop\DSP專題二\mfcc\mfcc_CYST\';
out_ext2='.mfc';
mfcc_all_v1(in_path2,out_path2,out_ext2);
fprintf('complete\n');

in_path3='C:\Users\謝佳彤\Desktop\DSP專題二\nor\';
out_path3='C:\Users\謝佳彤\Desktop\DSP專題二\mfcc\mfcc_nor\';
out_ext3='.mfc';
mfcc_all_v1(in_path3,out_path3,out_ext3);
fprintf('complete\n');

in_path4='C:\Users\謝佳彤\Desktop\DSP專題二\other\';
out_path4='C:\Users\謝佳彤\Desktop\DSP專題二\mfcc\mfcc_other\';
out_ext4='.mfc';
mfcc_all_v1(in_path4,out_path4,out_ext4);
fprintf('complete\n');
toc;
