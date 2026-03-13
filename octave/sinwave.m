function y = sinwave(f0,fs,a,T);
% Generates a sinewave of frequency 'f0', amplitude 'a', sampling frequency 'fs' and
% length 'T' in seconds. Writes the wav file to 'filename.wav'.
% Defaults are: f0 = 1kHz, a = +4dBu (Pro Audio Reference Level), fs = 44.1 kHz, T = 1s.

%if nargin<5, T = 1; end
%if nargin<4, a = 10^(-22/20); end
%if nargin<3, fs = 44100; end
%if nargin<2, f0 = 1000; end
    
T = round(T*f0)/f0;
L = round(T*fs);

y = a*sin(2*pi*f0*(0:L-1)/fs)';
%wavwrite(y,fs,16,filename)