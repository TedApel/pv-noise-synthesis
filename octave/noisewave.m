function y = noisewave(fs,a,T);
% Generates a noise signal of amplitude 'a', sampling frequency 'fs' and
% length 'T' in seconds.

%if nargin<5, T = 1; end
%if nargin<4, a = 10^(-22/20); end
%if nargin<3, fs = 44100; end
%if nargin<2, f0 = 1000; end
    
%T = round(T*f0)/f0;
L = round(T*fs);

y = a*((rand(1,fs*T)*2)-1)';
%wavwrite(y,fs,16,filename)