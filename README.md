# Sinusoidality Analysis and Noise Synthesis in Phase Vocoder Based Time-Stretching

Ted Apel -- [Project page with sound examples](https://vud.org/projects/noisesynthesis/)

A novel extension to the phase vocoder method of representing sound is presented in which the "sinusoidality" of spectral energy is estimated during analysis and employed to add noise to a time-stretched phase vocoder synthesis. Three methods of sinusoidality analysis are presented as well as a sinusoid and noise synthesis method which extends the phase vocoder method. This method allows for the noise characteristics of the original sound to be better maintained during time-stretching.

## Paper

Apel, T. (2014). Sinusoidality Analysis and Noise Synthesis in Phase Vocoder Based Time-Stretching. *Proceedings of the Australasian Computer Music Conference*, pp. 7-12.

See [paper/ApelACMC2014.pdf](paper/ApelACMC2014.pdf).

## Sound Examples

The `sounds/` directory contains paired audio examples comparing traditional phase vocoder time-stretching with the noise-retaining method. Each sound has three versions:

- **Original** -- the source recording
- **Traditional** (`_trad`) -- lengthened by traditional phase vocoder
- **Noise-retaining** (`_long`) -- lengthened by the noise-retaining phase vocoder

Sounds include brush roll, breathing, wind, rain, snoring, pencil sharpening, apple bite, motorcycle, and various synthetic test signals (sine-to-noise transitions, clicks).

## Code

Written in GNU Octave. The main files are in `octave/`:

- `fppv_dual_noise_stretch.m` -- Main phase vocoder time-stretch with noise preservation
- `fppv_sinusoidality_test.m` -- Evaluation harness for comparing sinusoidality measures
- `fppv_add_fft_noise.m` -- Noise synthesis in the spectral domain
- `fppv_add_complex_noise.m` -- Complex noise synthesis
- `fppv_spectral_flatness.m` -- Spectral flatness measure
- `bar_sinusoidality.m` -- Results plotting

The `octave/sinusoidality_measures/` directory contains 18 implementations of sinusoidality analysis methods, including power spectrum, phase acceleration, spectral irregularity, correlation, harmonic product spectrum, Teager energy, and others.