function [SM] = fppv_harmonic_sinusoidality(f)

% Find the highest frequency for which the product can be made.
%  <Description>
%    The harmonic product spectrum consists of the product of compressed
%    copies of the original spectrum. The frequency axis is compressed
%    by integer factors (1 to R), so the harmonics line up and reinforce
%    the fundamental frequency. x is a signal segment
% The inputs are the complex spectra f and the two prior complex spectra
% f1 and f2.
% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


% Product of the spectra compressed by R down to 1.


absF = abs(f);
WLen = length(abs(f)/2);
R = 6;
k = 1:R:WLen;
K = length(k);
HPSs = absF(k);
for (r=R-1:-1:1)  
	HPSs = HPSs.*absF(1:r:r*K);
end
[hpx hpy] = size(HPSs);
[xfe, yfe] = size( ( zeros( (WLen/2 - hpx), 1 ) ) );
HPzeros = (zeros(xfe,1));
HPSxLong = [ HPSs; HPzeros ];

%HPSy = HPSxLong(1:WLen/2);
			
HPSx = HPSxLong;
HPSx = (abs(f(1:WLen/2))) .* (abs(f(1:WLen/2)));
HPSx = HPSx(1:WLen/2);

HPSx = HPSx ./ max(HPSx);
HPSy = HPSx;

kL = 1:1:(WLen/2);
HPSupNorm = HPSy ; %.* 1.* (kL/(WLen/2))' ;   % an attempt at brightening the spectrum.
%HPSupNorm = HPSupNorm ./ max(HPSupNorm);
pow =20;  % 20
%power = 1 + ( (r+0) *.1);
HPSupmat = HPSupNorm;
HPSupmattemp = HPSupNorm';
HPSupAdd = HPSupNorm;
for (r=1:1:30)  % 40
HPSupAdd = (abs(interp(HPSupNorm,r))(1:WLen/2)).^(r*pow)  ;	
%HPSupAdd = (abs(interp(HPSupNorm,r))(1:WLen/2)).^(r*pow)  ;
HPSupAdd = HPSupAdd ./ max(HPSupAdd);


HPSupmattemp = [HPSupmattemp ; HPSupAdd' ];
HPSupmat = HPSupmattemp;
HPSy =  max(HPSupmat);
%HPSy = HPSy + HPSupAdd;

end

SM = HPSy ./ max(HPSy);
				
%plot(SM	(1:WLen/2));
%hold on;
%pause(.0001);
%plot(HPSx(1:WLen/2),'r' );
%hold on;
%pause(.0001);
%hold off;


SM = SM';
conj_SM = conj(flipud(SM));
SM = [SM ; conj_SM];

