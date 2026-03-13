% fppv_dual_noise_stretch.m
% [Feature Preservation Phase Vocoder]
% Ted Apel 2006-2007
%
% This program does a phase vocoder time-stretch with a noise preservation
% method that separates the noise spectrum from the pitched spectrum.
% The pitched spectrum is processed as normal phase vocoder.
% The noise spectrum is multiplied by noise in the spectral domain.
% The two spectra are added together in the spectral domain and converted
% back to the time-domain.

% Written in GNU Octave.

addpath('sinusoidality_measures');
clear;clf
%zenity_file_selection ("Sound File");
disp("FPPV Dual Noise Stretch");
disp("Ted Apel");
amount_stretch  = 8;  % 8
n1				= 16; %  8 or 16 for noise.   for trad 512  if getting modulation make smaller.	% analysis step size in samples. DID samples at 16
n2				= n1 * amount_stretch; %2048; %n1;  % synthesis step size in samples.
WLen			= 512 * 2	;					% window length.  512  8192   *4 for motorcycle
w1				= hanningz(WLen); 				% the analysis window.
w2				= w1;							% the synthesis window.
grain			= zeros(WLen,1);				% define grain.
f1				= zeros(WLen,1);				% define empty past phases1.
f2				= zeros(WLen,1);				% define empty past phases2.
SM_phase1		= zeros(WLen,1);
SM_phase2		= zeros(WLen,1);
SM_phase_ave1	= zeros(WLen,1);
SM_phase_ave2	= zeros(WLen,1);
f_noise_part_smooth1 = zeros(WLen,1);
f_noise_part_smooth2 = zeros(WLen,1);
f_noise_part_smooth3 = zeros(WLen,1);
f_noise_part_smooth4 = zeros(WLen,1);
delta_phi		= zeros(WLen,1);
tstretch_ratio 	= n2/n1;						% ratio of stretching.
omega    = 2*pi*n1*[0:WLen-1]'/WLen;			% expected phase increment per hop.
phi0     = zeros(WLen,1);
psi      = zeros(WLen,1);

% analysisframesize = (n1 * 1.5) / 44100

%______ Load in audio
% sine-noise-VS.wav
% motorcycle.wav


%  noisetone  breathing    sine-noise-VS   sine-noise-short.wav
% sineandnoiseend.wav	noisetone.wav	2930clicks.wav moto.wav noise.wav sine-noise-VS   seashore.aif


[x_in, FS] = auload("snore.wav");	
x_out = zeros(WLen+ceil(length(x_in)*tstretch_ratio),1); % init output.
L            = length(x_in);
%______ Window segment
tic											% timing.
pin  = 0;									% input point.
pout = 0;									% output point. 
pend = length(x_in)- WLen;					% end point. 


while pin < pend												% loop over each window.
	grain		= x_in(pin+1:pin+WLen).* w1;					% select grain a window.
	f			= fft(fftshift(grain));							% fft of grain.
	spec_flat = fppv_spectral_flatness(f);
    sine_amount = 	1.2 - spec_flat; %.5;											% 1 = sine , 0 = noise.  .2 is good.
        noise_amount = spec_flat -.3 ; %	spec_flat;% .0;	
	%%%%%%%%%%%%%% SINUSOIDALITY %%%%%%%%%%%%%%%%%%%%%%%
	SM_pow				= fppv_powersinusoidality(f,2);
  	SM_pow_diff		= fppv_power_difference_sinusoidality(f,f1,f2,2);  
	SM_irr_time		= fppv_time_irregularity_sinusoidality(f,f1,f2);
  	%SM_pow_teager		= fppv_power_teager_sinusoidality(f,f1,f2);
%	SM_teager 			= fppv_teager_energy_sinusoidality(f,w2);
    SM				= SM_pow_diff .* (1-SM_irr_time);
    


%	cutoff = SM >.70;
%	SM_cutoff = SM .* cutoff;
 %	f_sin_part		= sine_amount .* (abs(f) .* SM);			
 	f_sin_part		=  (abs(f) .* SM);% amount of spectra that is sin. 
% 	 	f_sin_part		= sine_amount .* ( SM);
%	f_noise_part	= (noise_amount) .* (abs(f) - (1 .* abs(f_sin_part) )); % amount of spectra that is noise.
	f_noise_part	=  (abs(f) - (1 .* abs(f_sin_part) ));   
	avesize = 8;
	f_noise_part_smooth		= filter(ones(1,avesize)/avesize,1,f_noise_part);
	f_noise_part_smooth_ave = (f_noise_part_smooth + f_noise_part_smooth1 + f_noise_part_smooth2 + f_noise_part_smooth3 + f_noise_part_smooth4) / 5;
		%%%%%%%%%%

			
%	 	plot ([1:WLen/2], ((abs(f)) ([1:WLen/2])),'b');
%			hold on;
 %		plot ([1:WLen/2], (f_noise_part_smooth_ave([1:WLen/2])), 'r');
 %		hold on;
 %		plot ([1:WLen/2], (f_sin_part([1:WLen/2])), 'y');
%   		pause(.000001);  
 % 		hold off;
 


	f_noisy 		= fppv_add_fft_noise(f_noise_part_smooth_ave, w1);		% add noise to noise spec.  fppv_add_complex_noise
	% make sure this is complex.
%	plot(abs(f_noisy));
%	pause(.0001);
%	r 				= abs(f); 	%THIS IS TEMP TO MAKE A TRADITIONAL PV.
	r     			= abs(f_sin_part);

%	phi   			= angle(f);      % THIS IS TEMP!
	phi   			= angle(f_sin_part);
	
	delta_phi		= omega + princarg(phi-phi0-omega);	
	phi0  			= phi;										% store old phase.
	psi   			= princarg(psi+delta_phi*tstretch_ratio);		% 
	f_stretch		= (r.* exp(i*psi));							% calculate new time point.
% 	f_combined 		= f_stretch;    						% TEMP ONLY!
%	f_combined 		= f_noisy ;									% TEMP ONLY!
 	f_combined 		= f_noisy + (10 .* f_stretch);						% combine the two spectra together.
 	outgrain  		= fftshift(real(ifft(f_combined))).*w2;		% ifft grain. 
 	x_out(pout+1:pout+WLen) = x_out(pout+1:pout+WLen) + outgrain; % put grain in out.
	f2				= f1;										% store second past complex spectrum.
	f1				= f;										% store first past complex spectrum.
	f_noise_part_smooth4 = f_noise_part_smooth3;
	f_noise_part_smooth3 = f_noise_part_smooth2;
	f_noise_part_smooth2 = f_noise_part_smooth1;
	f_noise_part_smooth1 = f_noise_part_smooth;
    pin  			= pin  + n1;								% advance the input point by stepsize. 
    pout			= pout + n2;								% advance the output point by stepsize. 
   end
toc
time = toc
%______ Save sound.
ausave('OUTSOUND.wav', x_out, FS);			% save sound.


