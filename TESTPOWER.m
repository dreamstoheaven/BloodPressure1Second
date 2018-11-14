testw_m = w_m(2030:2930) - mean(w_m);
pssspect = [];
fftspect = [];

for i = 1:49
[pss,fperio] = periodogram(testw_m(1+(i-1)*15:150+(i-1)*15),hann(150),[],0.5);
pssspect(:,i) = pss;
end


for i = 1:49
    sumpowerperio(1,i) = sum(pssspect(6:11,i));
    sumpowerperio(2,i) = sum(pssspect(12:27,i));
    sumpowerperio(3,i) = sum(pssspect(28:86,i));
end

[ttperio,ffperio] = meshgrid(w_T_m(2030:15:2765) - w_T_m(1),[1,2,3]);

%hold on
%surf(ttperio*24,ffperio,10*log10(sumpowerperio(1:3,:)))


for i = 1:49
windowed = hann(150).*testw_m(1+(i-1)*15:150+(i-1)*15)';
xdft = fft(windowed);
xdft = xdft(1:76);
psdxtemp = (1/(0.5*150))*abs(xdft).^2;
psdxtemp(2:end-1) = 2*psdxtemp(2:end-1);
psdx = psdxtemp';
fftspect(:,i) = psdx;
freqfft = 0:0.5/150:0.5/2;
end

for i = 1:49
    sumpowerfft(1,i) = sum(fftspect(4:7,i));
    sumpowerfft(2,i) = sum(fftspect(8:17,i));
    sumpowerfft(3,i) = sum(fftspect(18:51,i));
end


[ttfft,fffft] = meshgrid(w_T_m(2030:15:2750) - w_T_m(1),[1,2,3]);
hold on
surf(ttfft*24,fffft,10*log10(sumpowerfft(1:3,:)) -10);