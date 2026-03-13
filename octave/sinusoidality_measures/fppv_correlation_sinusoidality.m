% fppv_correlation_sinusoidality

% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_correlation_sinusoidality(f,w1)
WLen = 1024  * 1;
w1				= hanningz(WLen); 
y_corr_out = zeros(WLen,1);
fund = 44100/1024;
a = 1;

fs = 44100;
for(h=2:1:WLen)     
	x_sin = a*sin(2*pi*fund*h*(0:WLen-1)/fs)';
	x_win = x_sin .* w1;
	y_sin = fft(x_win);
	y_corr = f .* y_sin;
	y_corr_out(h) = sum(y_corr);


%	hold off;
%	plot ([1:WLen/2], abs(y_corr)([1:WLen/2]), 'r');
%	hold on;
%	plot ([1:WLen/2], abs(f)([1:WLen/2]), 'b');
%	hold on;
%	pause(.00001);
end

y_corr_out = abs(y_corr_out);
SM = y_corr_out ./ max(y_corr_out);
y_corr_out = zeros(WLen,1);


