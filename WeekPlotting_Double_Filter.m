function [ s,m,d,T_s,T_m,T_d ] = WeekPlotting_Double_Filter( bednumber, datenum ,birthtime, starttime, endtime)

% This is the function responsable for gathering the whole week's data for
% one baby. This function calls on two other functions: FillingGaps, which
% fills in a gaps throughout the day where no data is recorded, and
% outlier, which filters accordingly.

% Adjust the path accordingly. This hard-coded path most likely will not
% work on other computers. 

% This script will only work on Matlab versions percisely or later than R2016b.

load(strcat('F:\GUI_09_01_2017\New_Data\Bed', bednumber, '\NoECGs_Bed',bednumber,'_Day',datenum,'.mat'));
try
    
% a,b,c are n*2 matrices which contain BP information. The first column of
% these matrices are timestamps, and the second column is the actual BP
% data.

[a,b,c] = FillingGaps_Double_Filter(sig12,sig13,sig14,T_sig12,T_sig13,T_sig14, starttime,endtime);


T_s = a(:,1);
s = a(:,2);
T_d = b(:,1);
d = b(:,2);
T_m = c(:,1);
m = c(:,2);


% Calling the filter function.
%[s,m,d,T_s,T_m,T_d,pulsepressure] = outlier(sig12,sig13,sig14,T_sig12, T_sig13, T_sig14);



T_s = (double(T_s)+str2num(datenum)*86400-birthtime)./86400;
T_m = (double(T_m)+str2num(datenum)*86400-birthtime)./86400;
T_d = (double(T_d)+str2num(datenum)*86400-birthtime)./86400;
% T_O2 = (double(T_O2)*2+str2num(datenum)*86400-birthtime)./3600;
% T_HR = (double(T_HR)*2+str2num(datenum)*86400-birthtime)./3600;
% 

% Catching anomolies and account for the fact that sometimes sig57,58 and
% 59 are recorded rather than sig12, 13 and 14 as blood pressure signal.
catch
    try
    [a,b,c] = FillingGaps_Double_Filter(sig57,sig58,sig59,T_sig57,T_sig58,T_sig59, starttime, endtime);

    T_s = a(:,1);
    s = a(:,2);
    T_m = b(:,1);
    m = b(:,2);
    T_d = c(:,1);
    d = c(:,2);
    %
    %[s,m,d,T_s,T_m,T_d,pulsepressure] = outlier(sig12,sig13,sig14,T_sig12, T_sig13, T_sig14);



    T_s = (double(T_s)+str2num(datenum)*86400-birthtime)./86400;
    T_m = (double(T_m)+str2num(datenum)*86400-birthtime)./86400;
    T_d = (double(T_d)+str2num(datenum)*86400-birthtime)./86400;
%     T_O2 = (double(T_O2)*2+str2num(datenum)*86400-birthtime)./3600;
%     T_HR = (double(T_HR)*2+str2num(datenum)*86400-birthtime)./3600;
     catch
    end
end
%hold on
%axis([0,inf,-100,inf]);
%plot(T_s, s-100, T_m, m-100, T_d,d-100);

end