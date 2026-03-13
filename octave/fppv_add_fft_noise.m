% fppv_add_fft_noise(f)
% Add gaussian complex noise to each spectral bin.
% Here takes the magnitude spectrum of input spectrum. 


function [f_noise] = fppv_add_fft_noise(f, w1)
l = length(f);
noise = (rand(l,1)*2)-1;								% generate time domain noise that is lenght l.
win_noise = noise .* w1;								% Window it 
noise_spec			= fft(fftshift(win_noise));			% take fft
f_noise 		= (abs(f)) .* noise_spec; 				% mult by abs of f.
%f_noise 		= noise_spec; 				% mult by abs of f.
