% fppv_sinusoidality_test.m
% [Feature Preservation Phase Vocoder]
% Ted Apel 2006-2008
%
% This program tests the sinusoidality measures.
% Written in GNU Octave.

addpath('sinusoidality_measures');
clear;clf
disp("FPPV Dual Noise Stretch");
disp("Ted Apel");
amount_stretch  = 1;  % 8
n1				= 512 * 1; % 128 RESULTS 16, everything is done at 16. %512;  if getting modulation make smaller.	% analysis step size in samples. DID samples at 16
n2				= n1 * amount_stretch; %2048; %n1;  % synthesis step size in samples.
WLen			= 512 * 2	;					% window length.  1024 for tests.
w1				= hanningz(WLen); 				% the analysis window.
w2				= w1;							% the synthesis window.
grain			= zeros(WLen,1);				% define grain.
f1				= zeros(WLen,1);				% define empty past phases1.
f2				= zeros(WLen,1);				% define empty past phases2.
f3				= zeros(WLen,1);				% define empty past phases2.
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
count 	 = 1;
% analysisframesize = (n1 * 1.5) / 44100

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load  audio
%[x_in, FS] = auload("flute.wav");	%  noisetone  breathing    sine-noise-VS   sine-noise-short.wav
% sineandnoiseend.wav	noisetone.wav	2930clicks.wav moto.wav noise.wav sine-noise-VS   seashore.aif


%[x_sin, FS] 	= auload("sine.wav");
%[x_noise, FS]	= auload("noise.wav");
%x_in 			= x_sin([1:44100],1) + ( 2.0 .* x_noise([1:44100],1) );
FS = 44100;

%SINUSOID AMPLITUDE
%10^(-22/20)			% -4db ??? no.
%a = 10^(-18/20);      % - 18dB
% a = 10^(-6/20);     % - 6dB        - you can also try different values
    % - 0-36dB
time = .5;
aa 		= -00  				%-2000
a 		= 10^(aa/20); 		% sine amplitude level
b 		= 10^(-19.0/20);     % - 6dB  -2000  noise amplitude level   -20 is equal energy for one sine.
fund 	= 440;  % 440

x_sin = chirpwave(220, 880*2, 44100, a, .5)';

%x_sin =  sinwave(fund, 44100, a , time);
%	for(h=2:1:24)     % 24 FOR TESTS I THINK.
%		a = 10^((aa-(h*.75))/20); 
%       x_sin = x_sin + sinwave(fund*h, 44100,a , time);   
%	end
	
%		for(h=2:1:31 )     % Random sinusoids
%		a = 10^(aa/20); 
%		rand_freq = rand(1) * 20000;
%		newwave = sinwave(rand_freq, 44100,a , (time*1.2));
%       x_sin = x_sin + newwave(1:(time*44100)) ;   
%	end
	
x_noise = noisewave(44100,b,time);
x_in = x_sin + x_noise;

%[x_in, FS] = auload("violin.aif");
%b = 10^(20/20);
%x_noise = noisewave(44100,b,.5);
%x_sin =  sinwave(2930, 44100,a ,.5);
%x_in = x_sin;
%x_in = x_sin;

%plot(abs(fft( x_in )));
%break;

% The Test Signals.
% 1. Sine with no noise. 440 Hz Change dis from 2930 to 440.




x_out = zeros(WLen+ceil(length(x_in)*tstretch_ratio),1); % init output.
L            = length(x_in);
tic											% timing.
pin  = 0;									% input point.
pout = 0;									% output point. 
pend = length(x_in)- WLen;					% end point. 
while pin < pend												% loop over each window.
	grain		= x_in(pin+1:pin+WLen).* w1;					% select grain a window.
	grain_sin	= x_sin(pin+1:pin+WLen).* w1;
	grain_noise	= x_noise(pin+1:pin+WLen).* w1;	
	f			= fft(fftshift(grain), WLen*1);							% fft of grain.
	f_sin		= fft(fftshift(grain_sin), WLen*1);			
	f_noise		= fft(fftshift(grain_noise), WLen*1);			
	spec_flat 	= fppv_spectral_flatness(f);
%	sine_amount = 	1.2 - spec_flat; %.5;						% 1 = sine , 0 = noise.  .2 is good.
%    noise_amount = spec_flat -.3 ; %	spec_flat;% .0;	
	%%%%%%%%%%%%%% SINUSOIDALITY %%%%%%%%%%%%%%%%%%%%%%%
%	SM 				= 0;
% 	SM 				= 1;
%	SM				= fppv_powersinusoidality(f,2);
%  	SM				= fppv_power_difference_sinusoidality(f,f1,f2,1); 
	SM				= fppv_sigmund_sinusoidality(f);  % Remember to zero pad!!
%	SM	 			= fppv_charpentier_sinusoidality(f,f1, omega);  % 
%	SM				= fppv_phasediffsinusoidality(f,f1,f2);  % phase acceleration Change frame rate????  
%  	SM				= (fppv_phasediffsinusoidality(f,f1,f2)) .* (fppv_power_difference_sinusoidality(f,f1,f2,1));
%	SM				= fppv_correlation_sinusoidality(f,w1);
%	SM				= fppv_variance_sinusoidality(grain,w1);
%	SM 				= fppv_harmonic_sinusoidality(f);  % Remember to turn off zero pad
	
	
% no longer used:
%	SM_mag				= fppv_powersinusoidality(f,1);
	%	SM				= fppv_powersinusoidality(f,4);
	%	SM				= fppv_power_difference_sinusoidality(f,f1,f2,2);
	%	SM				= 1- (fppv_time_irregularity_sinusoidality(f,f1,f2));  % Not really good.
	%	SM 				= ( 1- (fppv_time_irregularity_sinusoidality(f,f1,f2) ) ) .* (fppv_power_difference_sinusoidality(f,f1,f2,1)); 
	%	SM				= fppv_phaseslopesinusoidality(f);	% Phase Slope
	%	SM 				= fppv_IF_irr_sinusoidality(f,f1,f2,f3); % Try with lots of overlap. check normalization.
	
	
	


%SM = SM .^10; 

% changing slope.
%SM_slope = SM;
%SM_slope(1:(511)) = SM(1:(511)) .* ((-.0024.*[1:511]) + 1)';



%hold off;
%plot ([1:WLen/4], SM_mag([1:WLen/4]), 'LineWidth',2, "r");
%hold on;
%plot ([1:WLen/4], SM_slope([1:WLen/4]), 'LineWidth',2, "b");
%pause(.00001);
%hold on;
%xlabel('Bin number');
%ylabel('Normalized magnitude');
%legend("Power sinusoidality", "Harmonic sum sinusoidality");
%legend("Power sinusoidality", "Phase acceleration sinusoidality");












%SM_slope((WLen/2):(WLen)) = SM((WLen/2):(WLen)) .* ((-.0002.*[1:WLen/2]) + 1)';
%SM_slope = SM .* .01 .* (WLen./[1:WLen])';
%hold off;
%plot ([1:WLen/2], SM_slope([1:WLen/2]), 'b');
%hold on;
%plot ([1:WLen/2], SM([1:WLen/2]), 'r');
%pause(.00001);
%hold on;

%hold off;
% SM_mag				= fppv_magsinusoidality(f);

%    SM				= (fppv_phasediffsinusoidality(f,f1,f2)) .* (1- fppv_time_irregularity_sinusoidality(f,f1,f2));
%  	SM				= (fppv_phasediffsinusoidality(f,f1,f2)) .* (1- fppv_time_irregularity_sinusoidality(f,f1,f2)) .* (fppv_power_difference_sinusoidality(f,f1,f2,1));


%	SM		= fppv_complex_irregularity_sinusoidality(f,f1,f2);
 %		SM					= fppv_phase_diff_slopesinusoidality(SM_phase);
 %	SM_phase_ave		= fppv_phase_ave_sinusoidality(SM_phase,SM_phase1,SM_phase2);
 %	SM_phase_ave_again	= fppv_phase_ave_sinusoidality(SM_phase_ave,SM_phase_ave1,SM_phase_ave2);


 %	SM_char 			= fppv_charpentier_sinusoidality(SM_phase);

% 	SM_multphase		= SM_phase .* shift(SM_phase, -1) .* shift(SM_phase, +1);
 %	SM 			= fppv_teager_energy_sinusoidality(f);

%	SM_combined 		= (SM .* SM_mag) .* SM_slope;
  %	SM_irr				= fppv_irregularity_sinusoidality(f);
%  	SM_phaseirr			= fppv_irregularity_sinusoidality(SM_phase);
%   SM				= fppv_2d_irregularity_sinusoidality(f,f1,f2);



  	%SM_pow_teager	= fppv_power_teager_sinusoidality(f,f1,f2);
%	SM 		= fppv_teager_energy_sinusoidality(f,w2);
%    SM_pow_irr				= SM_pow_diff .* (1-SM_irr_time);
 %   SM				=  (1-SM_irr_time);
  %      SM				=  SM_pow_diff;
 %    SM				= SM_pow .* (1-SM_irr_time);
% SM = SM_phase .* SM_pow_irr;


 
% SM = SM_IR_irr;
% SM = 1;
 %   SM	= SM_pow;
%	cutoff = SM >.70;
%	SM_cutoff = SM .* cutoff;

 	sin_original 		= abs(f_sin);   
 	sin_estimate 		= (SM  .*  abs(f)  );
 	
 	false_sin_spectrum 		= ((sin_estimate - sin_original ) > 0) .* (sin_estimate - sin_original ) ;
 %	plot(false_sin_spectrum);
 %	pause(.004);
 	missed_sin_spectrum 	= ((sin_original - sin_estimate ) > 0) .* (sin_original - sin_estimate );
 	error_sin_spectrum 		= false_sin_spectrum + missed_sin_spectrum;
 	
 	sum_sin_false(count) 	= sum(false_sin_spectrum);
 	sum_sin_missed(count) 	= sum(missed_sin_spectrum);
 	sum_sin_error(count)	= sum(error_sin_spectrum);
 	
 	
 	noise_original 		= abs(f_noise);   
 	noise_estimate 		= ((1-SM)  .*  abs(f)  );
 	
 	false_noise_spectrum 		= ((noise_estimate - noise_original ) > 0) .* (noise_estimate - noise_original ) ;
 	missed_noise_spectrum 	= ((noise_original - noise_estimate ) > 0) .* (noise_original - noise_estimate );
 	error_noise_spectrum 		= false_noise_spectrum + missed_noise_spectrum;
 	
 	sum_noise_false(count) 	= sum(false_noise_spectrum);
 	sum_noise_missed(count) 	= sum(missed_noise_spectrum);
 	sum_noise_error(count)	= sum(error_noise_spectrum);
 	
 	sum_noise_original(count) = sum(noise_original);
 	sum_sin_original(count) = sum(sin_original);
 	sum_original(count)	= sum(abs(f));
 	
% 	hold off;
% 	plot ([1:WLen/2], SM([1:WLen/2]), 'b');
% 	hold on;
% 	plot ([1:WLen/2], SM_mag([1:WLen/2]), 'r')
%  	hold on;
%  	pause(.000001);
 
%	hold off;
% 	plot ([1:WLen/2], false_spectrum([1:WLen/2]), 'r');
 % 	hold on;
%  	plot ([1:WLen/2], missed_spectrum([1:WLen/2]), 'b');
%   	pause(.000001);
 	
 	
 %............................................................................	
 	
% 	 f_sin_part		= sine_amount .* (abs(f) .* SM);				% amount of spectra that is sin.
%	f_noise_part	= (noise_amount) .* (abs(f) - abs(f_sin_part));	% amount of spectra that is noise.
	
	avesize = 8;
%	f_noise_part_smooth		= filter(ones(1,avesize)/avesize,1,f_noise_part);
%	f_noise_part_smooth_ave = (f_noise_part_smooth + f_noise_part_smooth1 + f_noise_part_smooth2 + f_noise_part_smooth3 + f_noise_part_smooth4) / 5;
%	f_noisy 		= fppv_add_fft_noise(f_noise_part, w1);		% add noise to noise spec.  fppv_add_complex_noise
%	r     			= abs(f_sin_part);
%	phi   			= angle(f);


 %	f_combined 		= f_noisy + (5 .* f_stretch);						% combine the two spectra together.  WHY .5	
 	f3				= f2;
	f2				= f1;										% store second past complex spectrum.
	f1				= f;										% store first past complex spectrum.
%	f_noise_part_smooth4 = f_noise_part_smooth3;
%	f_noise_part_smooth3 = f_noise_part_smooth2;
%	f_noise_part_smooth2 = f_noise_part_smooth1;
%	f_noise_part_smooth1 = f_noise_part_smooth;
    pin  			= pin  + n1;								% advance the input point by stepsize. 
    pout			= pout + n2;								% advance the output point by stepsize. 
    count = count +1;
   end
   
   % Final Stats
   % sinusoidal for both method:

%  printf ("Total Sine  Energy %.3f & ",sum_sin_original);
%   printf (" \n \n ");
%   printf ("Total Noise Energy %.3f & ",sum_noise_original);
%  printf (" \n \n ");
%   printf ("Total Input Energy %.3f & ",sum_original);
%   printf (" \n \n ");

  sum_sin_error = (sum_sin_false + sum_sin_missed) ./  sum_original  ; % new method, normalized by total energy

  sum_sin_false = sum_sin_false ./ sum_noise_original;
  sum_sin_missed = sum_sin_missed ./ sum_sin_original;
      
%   sum_sin_error = sum_sin_false + sum_sin_missed;  % This was the original method of finding total.
 
   
   mean_sin_false 		= mean(sum_sin_false);
   std_sin_false 		= std(sum_sin_false);
   max_sin_false 		= max(sum_sin_false);
   mean_sin_missed 		= mean(sum_sin_missed);
   std_sin_missed 		= std(sum_sin_missed);
   max_sin_missed 		= max(sum_sin_missed);   
   mean_sin_error  		= mean(sum_sin_error);
   std_sin_error  		= std(sum_sin_error);
   max_sin_error 		= max(sum_sin_error);
	
   mean_noise_false 	= mean(sum_noise_false);
   std_noise_false 		= std(sum_noise_false);
   max_noise_false 		= max(sum_noise_false); 
   mean_noise_missed 	= mean(sum_noise_missed);
   std_noise_missed 	= std(sum_noise_missed);
   max_noise_missed 	= max(sum_noise_missed);   
   mean_noise_error  	= mean(sum_noise_error);
   std_noise_error  	= std(sum_noise_error);
   max_noise_error 		= max(sum_noise_error);
	
   
   
 %   = [mean_false, char(' & '), std_false, char(' & '), max_false,char(' & '), mean_missed, char(' & '),std_missed, char(' & '),max_missed,char(' & '), mean_error,char(' & '), std_error,char(' & '), max_error, std_error,char(' \\ ')]
   printf ("& %.3f & ",mean_sin_false);
   printf (" %.3f & ",std_sin_false);
 %  printf (" %.3f & ",max_sin_false);
   printf (" %.3f & ",mean_sin_missed);
   printf (" %.3f & ",std_sin_missed);
%   printf (" %.3f & ",max_sin_missed);
   printf (" %.3f & ",mean_sin_error);
   printf (" %.3f  ",std_sin_error);
%   printf (" %.3f  ",max_sin_error);
   printf (" \n \n ");
  % Noise stats 
%   printf (" %.2f & ",mean_noise_false);
%   printf (" %.2f & ",std_noise_false);
%   printf (" %.2f & ",mean_noise_missed);
%   printf (" %.2f & ",std_noise_missed);
%   printf (" %.2f & ",mean_noise_error);
%   printf (" %.2f  ",std_noise_error);

%   printf (" \n \n ");
   
   
   
   
   
toc
time = toc

beep();		% beep on end.
%beep();
%beep();
%beep();




	
  
