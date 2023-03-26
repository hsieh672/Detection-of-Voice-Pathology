function mfcc_v2(infilename,outfilename,delta,delta_delta)

% set constants begin %
sample_rate=36000;%16000
% sample_rate=36000;
frame_time=30;                                             %ms
frame_move_time=15;                                         %ms
frame_size=floor(sample_rate*frame_time*10^(-3));          %pts
frame_move=floor(sample_rate*frame_move_time*10^(-3));     %pts
fft_number=2^(ceil(log2(frame_size)));
fft_vec_size=floor(fft_number/2);

mel_filter_number=23;       %一個frame的點要超過mel_filter_number,否則會有-inf和NaN
ceplifter=22;
cep_size=12;  %12表示是取13維
static_feature_size=cep_size+1;%c1-c12 plus c0%
dynamic_feature_size=static_feature_size*1;  %調整維度
feature_kind=8966; %MFCC_0_D_A=8966%
norm_factor=sqrt(2.0/mel_filter_number);
pre_e=0.97;
LZERO=-1e10;
lopass=64.0;
hipass=sample_rate/2;
mlo = 1127.0*log(1.0+lopass/700.0);
mhi = 1127.0*log(1.0+hipass/700.0);
klo=floor(lopass/sample_rate*fft_number+2.5);
khi=floor(hipass/sample_rate*fft_number+0.5);
if khi>fft_vec_size;
    khi=fft_vec_size;
end;


%create linear frequency bin begin%

lin_freq=zeros(1,fft_vec_size);
lin_freq=sample_rate/2.0/fft_vec_size*[0:fft_vec_size-1];

%create mel frequency bin end%

%create mel frequency bin begin%

mel_freq=zeros(1,fft_vec_size);
mel_freq=1127.0*log(1.0+1.0/700.0*lin_freq);

%create mel frequency bin end%

%create mel_center_frequency begin%

mel_center_freq=zeros(1,mel_filter_number+2);
mel_center_freq=mlo+(mhi-mlo)/(mel_filter_number+1)*[0:mel_filter_number+1];

%create mel_center_frequency end%


%create triangular filter bank begin%

tri_filter_bank=zeros(mel_filter_number,fft_vec_size);
spec_bd=zeros(2,mel_filter_number);

for m=1:mel_filter_number;
    for n=1:fft_vec_size;
        if (mel_freq(1,n)>=mel_center_freq(1,m))&(mel_freq(1,n)<=mel_center_freq(1,m+1))
            tri_filter_bank(m,n)=(mel_freq(1,n)-mel_center_freq(1,m))/(mel_center_freq(1,m+1)-mel_center_freq(1,m));
        else if (mel_freq(1,n)>=mel_center_freq(1,m+1))&(mel_freq(1,n)<=mel_center_freq(1,m+2))
                tri_filter_bank(m,n)=(mel_center_freq(1,m+2)-mel_freq(1,n))/(mel_center_freq(1,m+2)-mel_center_freq(1,m+1));
            end;
        end;
    end;
end;

for m=1:mel_filter_number;
    for n=1:fft_vec_size;
        if mel_freq(1,n)>=mel_center_freq(1,m);
            spec_bd(1,m)=n;
            break;
        end;
    end;
end;
for m=1:mel_filter_number;
    for n=1:fft_vec_size;
        if mel_freq(1,n)>mel_center_freq(1,m+2);
            spec_bd(2,m)=n-1;
            break;
        end;
    end;
end;
spec_bd(2,mel_filter_number)=fft_vec_size;

%create triangular filter bank end%



%create hamming_windows begin%

hamming_window=0.54-0.46*cos(2.0*pi/(frame_size-1)*[0:frame_size-1]);

%create hamming_windows end%

%create DCT_matrix begin%

dct_matrix=zeros(cep_size,mel_filter_number);
for m=1:cep_size;
    for n=1:mel_filter_number;
        dct_matrix(m,n)=cos(m*pi/mel_filter_number*(n-0.5));
    end;
end;


%create DCT_matrix end%

% set constants end %


% open source file and target file begin%


source_name=infilename;
target_name=outfilename;

% source_fid=fopen(source_name,'r','b');
% if source_fid==-1;
%     disp('input file does not exist!');
%     disp(source_name);
% else
    
    
    % open source file and target file end%
    
    
    % read source file begin%
    %     source_header=0;                                    %  aurora2  檔頭 0
    %     Tmp=fread(source_fid,source_header,'char');
%     [data,points]=fread(source_fid,[1 inf],'short');
        [data, Fs] = audioread(source_name);
    % [data, Fs, nbits] = audioread(source_name);
     data=data(:,1)';
     %
     points=length(data);
    % apply pre_emphasis begin%
    data_prem=ones(size(data));
    data_prem(1,2:end)=data(1:end-1);
    data_prem=data-pre_e*data_prem;
    % apply pre_emphasis end%
    
    frames=floor(floor((points-frame_size)/frame_move)+1);
    if frames<=0;
        disp('too few data!');
        source_name
%         fclose(source_fid);
    else
%         fclose(source_fid);
        % read source file end%
        
        %set some parameters start
        frame_energy=zeros(1,frames);                      %frame energy array
        abs_spectrum_s=zeros(frames,fft_vec_size);         %spectrum matrix
        power_spectrum_s=zeros(frames,fft_vec_size);       %power spectrum matrix
        log_mel_spectrum_s=zeros(mel_filter_number,frames);%log_mel_spectrum matrix
        cepstrum_s=zeros(cep_size,frames);                 %cepstrum matrix
        c0=zeros(1,frames);                                %c0 array
        cep_data=zeros(static_feature_size,frames);
        final_cep_data=zeros(dynamic_feature_size,frames);
        %set some parameters end
        
        for this_frame=1:frames;
            % read each frame data begin%
            
            begin_point=(this_frame-1)*frame_move+1;
            end_point=begin_point+frame_size-1;
            s=data_prem(1,begin_point:end_point);
            
            % read each frame data end%
            
            %calculate log frame energy begin%        %frame_energy change begin
            
            frame_energy(this_frame)=s*s';
            if frame_energy(this_frame)==0;
                frame_energy(this_frame)=LZERO;
            else
                frame_energy(this_frame)=log(frame_energy(this_frame));
%                 frame_energy(this_frame)=(frame_energy(this_frame));
            end;
            
            %calculate log frame energy end%          %frame_energy change end
            
            % apply Hamming_window begin%
            
            s=s.*hamming_window;
            if s == 0
                s = s+eps;
            end
            
            % apply Hamming_window end%
            
            % apply FFT begin%
            spectrum_s=fft(s,fft_number);         %256 points
            % apply FFT end%
            
            %abs_spectrum_s change begin
            abs_spectrum_s(this_frame,:)=abs(spectrum_s(1:fft_vec_size));
            power_spectrum_s=abs_spectrum_s.*abs_spectrum_s;%prpr-----<
            
        end
        
        % obtain log_mel_spectrum begin%
        
        log_mel_spectrum_s=log(tri_filter_bank*power_spectrum_s');%23*frames
        
        % obtain log_mel_spectrum end%
        
        
        % obtain cepspectrum begin%
        
        cepstrum_s=norm_factor*dct_matrix*log_mel_spectrum_s;
        c0=norm_factor*sum(log_mel_spectrum_s);
        cepstrum_s=cepstrum_s.*repmat((1.0+ceplifter/2.0*sin(pi/ceplifter*[1:cep_size]')),1,frames);
        
        % obtain cepspectrum end%
        
        cep_data=cat(1,cepstrum_s,c0);        
        final_cep_data(1:static_feature_size,:)=cep_data;
        
        temp_data=dynamic_feature(cep_data,delta);        
        final_cep_data(static_feature_size+1:static_feature_size*2,:)=temp_data;
% %         
%         temp_data=dynamic_feature(temp_data,delta_delta);        
%         final_cep_data(static_feature_size*2+1:static_feature_size*3,:)=temp_data; 
%         
%         target_fid=fopen(target_name,'wb');
% %         target_fid=fopen(target_name,'w');
%         if target_fid==-1;
%             disp('cannot write file! ');
%             disp(target_name);
%         else
%             fwrite(target_fid,frames,'long');
%             fwrite(target_fid,frame_move_time,'long');
%             fwrite(target_fid,dynamic_feature_size*4,'short');
%             fwrite(target_fid,feature_kind,'short');
%             fwrite(target_fid,final_cep_data,'float');
% %               fprintf(target_fid,'%f',final_cep_data);
%             fclose(target_fid);
              final_cep_data=final_cep_data';
              save(target_name,'-ascii','final_cep_data');
%               save(target_name,'-ascii','frame_energy');
%         end;
        
    end;
    
    clear data data_prem frame_energy abs_spectrum_s power_spectrum_s log_mel_spectrum_s cepstrum_s c0 cep_data final_cep_data;
    
% end;

function out_feature=dynamic_feature(in_feature,delta_par)

nominator=[delta_par:-1:1 0 -1*(1:1:delta_par)];
denominator=2*[1:1:delta_par]*[1:1:delta_par]';
[cep_vec,frames]=size(in_feature);
out_feature=zeros(cep_vec,frames);

for cep_ind=1:cep_vec
    temp_feature(cep_ind,:)=filter(nominator,denominator,[in_feature(cep_ind,1)*ones(1,delta_par) in_feature(cep_ind,:) in_feature(cep_ind,end)*ones(1,delta_par)]);
end

out_feature=temp_feature(:,2*delta_par+1:end);




