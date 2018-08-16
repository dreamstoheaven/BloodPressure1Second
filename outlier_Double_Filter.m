% Outlier/filtering Script
% Written by Tianrui Zhu, Final Update: 2018-07-11

function [ cleansignal_s, cleansignal_m, cleansignal_d, T_cleansignal_s,T_cleansignal_m,T_cleansignal_d pulse_pressure ] = outlier_Double_Filter( signal_s, signal_d, signal_m, T_signal_s, T_signal_d,T_signal_m )

% This is the function which actually removes outliers/filters the dataset.
% The criteria defaulted to (and was used in all figures we generated) is
% that if the difference between S_BP, M_BP and D_BP is smaller than a
% value, or if any of the signals are negative, then all three signals of that time are
% removed. Datapoints directly next to the removed point are also removed. For example, if 
% time i is removed, time i-1 and time i+1 will also be removed if they are
% in the dataset. The removal proccess is dome in two steps to avoid
% dynamic indexing. The first step involves assining a value to all points
% that need to be removed (flagging all bad datapoints), and the second
% step is to actually remove the datapoints. Any negative number can serve
% as the flag.

signal_s = double(signal_s);
signal_d = double(signal_d);
signal_m = double(signal_m);
T_signal_s = double(T_signal_s);
T_signal_d = double(T_signal_d);
T_signal_m = double(T_signal_m);

cleansignal_s(1,:) = signal_s;
cleansignal_m(1,:) = signal_m;
cleansignal_d(1,:) = signal_d;
T_cleansignal_s(1,:) = T_signal_s;
T_cleansignal_d(1,:) = T_signal_d;
T_cleansignal_m(1,:) = T_signal_m;


% Flagging
for i = 1:length(signal_s)
    sigma = 3;
    if (signal_s(i) - signal_m(i) < sigma) || (signal_m(i) - signal_d(i) < sigma) || signal_s(i) < 0 || signal_d(i) < 0|| signal_m(i) < 0 
        cleansignal_s(1,i) = -10;
        cleansignal_s(2,i) = 1;
        cleansignal_m(1,i) = -10;
        cleansignal_m(2,i) = 1;
        cleansignal_d(1,i) = -10;
        cleansignal_d(2,i) = 1;
        %T_cleansignal_s(i) = -10;
        %T_cleansignal_d(i) = -10;
        %T_cleansignal_m(i) = -10;
        
%         try
%         cleansignal_s(1,i-1) = -10;
%         cleansignal_s(2,i-1) = 1;
%         cleansignal_m(1,i-1) = -10;
%         cleansignal_m(2,i-1) = 1;
%         cleansignal_d(1,i-1) = -10;
%         cleansignal_d(2,i-1) = 1;
%         %T_cleansignal_s(i-1) = -10;
%         %T_cleansignal_d(i-1) = -10;
%         %T_cleansignal_m(i-1) = -10;
%         
%         if i ~= length(signal_s)
%             cleansignal_s(1,i+1) = -10;
%             cleansignal_s(2,i+1) = 1;
%             cleansignal_m(1,i+1) = -10;
%             cleansignal_m(2,i+1) = 1;
%             cleansignal_d(1,i+1) = -10;
%             cleansignal_d(2,i+1) = 1;
%         %T_cleansignal_s(i+1) = -10;
%         %T_cleansignal_d(i+1) = -10;
%         %T_cleansignal_m(i+1) = -10;
%         end
%         catch
%         end
    end
end




current_s = cleansignal_s(i);
current_d = cleansignal_d(i);
current_m = cleansignal_m(i);

% Double Filtering the data
for i = length(singal_s) - 1
    tao = 40;
    if cleansignal_s(1,i+1) ~= -10
        next_s = cleansignal_s(1,i+1);
        if next_s - current_s > tao
            cleansignal_s(1,i+1) = -10;
            cleansignal_d(1,i+1) = -10;
            cleansignal_m(1,i+1) = -10;
            cleansignal_s(2,i+1) = 1;
            cleansignal_d(2,i+1) = 1;
            cleansignal_m(2,i+1) = 1;
    end
    if cleansignal_m(1,i) ~= -10
        next_m = cleansignal_m(1,i);
    end 
    if cleansignal_d(1,i) ~= -10
        next_d = cleansignal_d(1,i);
    end
end

% Actually cleaning the data. 
cleansignal_s(cleansignal_s == -10) = NaN; 
cleansignal_d(cleansignal_d == -10) = NaN;
cleansignal_m(cleansignal_m == -10) = NaN;
% T_cleansignal_s = T_cleansignal_s(T_cleansignal_s ~= -10);
% T_cleansignal_d = T_cleansignal_d(T_cleansignal_d ~= -10);
% T_cleansignal_m = T_cleansignal_m(T_cleansignal_m ~= -10);
pulse_pressure = cleansignal_s - cleansignal_m(1:length(cleansignal_s));

%plot(T_signal_s,signal_s + 50, T_signal_d,signal_d +50,T_signal_m, signal_m + 50,  T_cleansignal_s,cleansignal_s-250, T_cleansignal_d, cleansignal_d-250, T_cleansignal_m, cleansignal_m-250,T_cleansignal_s,pulse_pressure)
end
