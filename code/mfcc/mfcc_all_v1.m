function mfcc_all_v1(indir,outdir,out_ext)

if  indir(end) == filesep
    indir=indir(1:(end-1));
end

if  strcmp(outdir(end),'\') || strcmp(outdir(end),'/')
    outdir=outdir(1:(end-1));
end

if exist(outdir) ~=7
    mkdir(outdir);
end

filelist=dir(indir);
filelist_len=length(filelist);

file_count=0;

for k=3:filelist_len
    [pathstr,filenamek,ext] = fileparts(filelist(k).name);
    if filelist(k).isdir
        mfcc_all_v1([indir filesep filenamek],[outdir filesep filenamek],out_ext);
    else

        infilename=fullfile(indir, filelist(k).name);
        outfilename=[outdir filesep filenamek out_ext];
        
        %%% baseline method here %%%
        
        file_count=file_count+1;
        if mod(file_count,8000)==0;
            file_count
        end;
        
%         mfcc_v1(infilename,outfilename);
        mfcc_v2(infilename,outfilename,3,2);
%         fbank(infilename,outfilename,3,2)
%         HTK2normal_mfcc(infilename,outfilename);
    end
end

fclose all;