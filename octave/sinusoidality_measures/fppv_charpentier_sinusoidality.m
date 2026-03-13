% fppv_charpentier_sinusoidality

% The output SM is a number between zero and one. 
% zero = noise. 
% one = sinusoidal.


function [SM] = fppv_charpentier_sinusoidality(f,f1, omega)
phases	= angle(f);							% create phase spectrum 
phases1	= angle(f1);						% create phase spectrum 

phasediff = princarg((phases) - (phases1));

phasediff1 = shift(phasediff, -1);
phasediff2 = shift(phasediff, +1);

%freq_ave 	= ((phasediff + phasediff1 + phasediff2) /3);
freq_ave 	= ((phasediff + phasediff2) /2);
%deltatheta(1:(length(f) - 1)) 	= diff(freq_ave);
%posdelta 	= abs(deltatheta);
%freq_irr	= abs( phasediff - freq_ave) ;		% scaled by amplitude , this might be cheating.
freq_irr	= abs( phasediff1 - freq_ave) ;
%freq_irr = r;
maxirr = max(freq_irr);
SM =  (1 -  (freq_irr ./ maxirr)).^(18)     ;





%maxave = max(posdelta);
%SM =  power(1 - (posdelta ./ maxave),2 );

%phasediff = ((phasediff ./ max(phasediff)) + 1) .* .5;
%WLen = 1024;
%max = abs(f)/ max(abs(f));
%hold off;
%plot ([1:WLen/4], max([1:WLen/4]), 'LineWidth',2, "b");
%hold on;
%plot ([1:WLen/4], phasediff([1:WLen/4]), 'LineWidth',2, "r");
%pause(.00001);
%hold on;
%xlabel('Bin number');
%ylabel('Normalized magnitude');
%legend("Magnitude", "Phase difference");

