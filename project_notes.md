# Final Project Notes

## February 11th, 2019
### Some Referents
* [Sonic Arcade](https://madmuseum.org/sonic-arcade-shaping-space-with-sound): an exhibition at MAD madmuseum
* [FOO/SKOU](http://fooskou.tumblr.com/)
* [Coloop](https://www.nodesign.net/portfolio/coloop/) by Ircam and nodesign
* [COMO](https://como.ircam.fr/about) by Ircam
* [The Johnny Cash Project](https://vimeo.com/15416762)

* [Convocatoria Medialab-Prado](https://www.medialab-prado.es/convocatorias/residencia-sonora-11)

## Alternative ways of experience music
* [Bosque Sonoro](https://es.wikipedia.org/wiki/Archivo:Museo_Violeta_Parra_-bosque_sonoro_-arboles_musicales.jpg) at Museo Violeta Parra
* [Magic Leap](https://duckduckgo.com/?q=maic+leap&atb=v156-1b_&ia=news)
* Sigur Ros & Magic Leap
  * [Teaser](https://www.youtube.com/watch?v=LLmT0tH3LKM)
  * https://www.youtube.com/watch?v=5_A-qdfx1iw
  * https://www.youtube.com/watch?v=OLtDeonCAYE
  * [Cymatics](https://www.youtube.com/watch?v=Q3oItpVa9fs)
* [See The Light: Anthony McCall's](https://pioneerworks.org/exhibitions/anthony-mccall-solid-light-works/)
* Sound Visualization
  * [Visualization 1](https://www.youtube.com/watch?v=dqnMoWHon40)
  * [Laser + mirror + sound](https://www.youtube.com/watch?v=C-V1uXeyGmg)
  * [Spectrogram](https://www.youtube.com/watch?v=2MUZWFEEzSg)
  * [Helicoid Spectrogram](https://www.youtube.com/watch?v=rqSEaF0rC60)
  * [Bubbles](https://www.youtube.com/watch?v=mEp_CtJHF0c)
  * [Abstract](https://www.youtube.com/watch?v=sMHtMaym-2k)
  * [Lorenz Attractor](https://www.youtube.com/watch?v=5VDiTliLqLw)
  * [Myles de Bastion - Deaf musician](https://myles.debastion.com/deafness-music)
  * [Seeing Music](https://experiments.withgoogle.com/seeing-music)
  * [Sonic Plasticity, An Introduction - Wolfgang Gil](https://medium.com/@wolfganggil_35573/sonic-plasticity-an-introduction-343ae7e22de5)
  * [Resonant Bodies - Wolfgang Gil](https://wolfganggil.com/#/resonant-bodies-i/)
  * [More data Vis](https://99designs.com/blog/design-other/sound-visualization-design-inspiration/)
  * [Visualization on Unity](https://www.youtube.com/watch?v=4Av788P9stk)
  * [Oskar Fischinger - An Optical Poem](https://www.youtube.com/watch?v=6Xc4g00FFLk)
  * [John Whitney - Catalog](https://www.youtube.com/watch?v=TbV7loKp69s&t=2s)
* [How deaf people experience music](https://medium.com/@rachelelainemonica/how-deaf-people-experience-music-a313c3fa4bfd)
* [Michael Simpson's Thesis](https://itp.nyu.edu/thesis2018/#/student/michael-simpson)
* AR Sound Visualization:
  * [AR Sound Vis + 3d Printing](https://www.3ders.org/articles/20131230-visualizing-active-sound-waves-with-3d-printing-augmented-reality.html)
  * [Visualization techniques in AR](https://data.icg.tugraz.at/~dieter/publications/Schmalstieg_217.pdf)
  * [Visualizing high dimensional data in AR](https://medium.com/inside-machine-learning/visualizing-high-dimensional-data-in-augmented-reality-2150a7e62d5b)
  * [Zach Lieberman's Sound AR](https://www.wired.com/story/an-artist-uses-an-iphone-to-visualize-sounds-in-ar/?mbid=social_fb). [Instagram](https://www.instagram.com/p/Bdh_ljNAerB/)
  * [Wearable AR Sound Visualization](https://www.youtube.com/watch?v=sWoE7uVImD4)

## Feedback March 6th
* [Russian Suprematism](https://duckduckgo.com/?q=russian+suprematism&atb=v156-1b_&iax=images&ia=images)
* [Utopian Loops](https://danaelkis.com/Utopian-Loops)
* [Junkopia - Chris Marker](https://www.youtube.com/watch?v=9ymKAhoXyPA)
* [Simian Mobile Disco](https://www.youtube.com/watch?v=MOEGf7WGwIc)
* [Rivers and Tides- Andy Goldsworthy](https://www.youtube.com/watch?v=f7sZv4_0Fxg)
* [Michel Gondry - Visualizations for Noam Chomsky](https://www.youtube.com/watch?v=zex7yxN4GW0)

* [Sound Visualization in Unity](https://forum.unity.com/threads/audio-visualization-tutorial-unity-c-q-a.432461/)

## Midterm Feedback - March 12nd & Office Hour
* transcient analysis
* explore specific cases
* particular before generalize
* compose cases to put my composing concepts
* not to discard FFT that fast
* en qué situación podría usar una app como esta
* en qué lugar? (niño en un viaje)

* Sound determinants (John Cage)
  * Frequency or pitch
  * Amplitude or loudness
  * Overtone structure or timbre
  * Duration
  * Morphology (how the sound begins, goes on, and dies away)

## openFrameworks
* [ofxFilterbank](https://github.com/leozimmerman/ofxFilterbank): openFrameworks addon for polyphonic pitch detection in an audio signal. It implements a bank of resonant audio filters centered at each frequency of the musical temperament.
* [ofxAubio](https://aubio.org/ofxAubio/): *ofxAubioBeat* Estimate the musical tempo and track beat positions. *ofxAubioOnset* estimate note onset times. *ofxAubioPitch* track estimated note pitches. *ofxAubioMelBands* computes Energy in each Mel-Frequency Bands.
* [ofxAudioAnalyzer](https://github.com/leozimmerman/ofxAudioAnalyzer): RMS, Instant power, Energy, Pitch frequency, Pitch Confidence, Pitch Salience, HFC, Centroid, Inharmonicity, Spectral Complexity, Dissonance, Roll Off, Odd To Even Harmonic Energy Ratio, Strong Peak, Strong Decay, Onsets, Spectrum, Mel Bands, MFCC, Harmonic Pitch Class Profile, Tristimulus
* [ofxBeat](https://github.com/darrenmothersele/ofxBeat): A simple beat detection routine for openFrameworks that gives 32 fft bands plus separate output for kick, snare, and hihat.
* [ofxBTrack](https://github.com/naotokui/ofxBTrack): beat tracking, not for onset detection.
* [ofxFFT](https://github.com/kylemcdonald/ofxFft)

## AVAudioSession errors in iOS 12
* [stackoberflow](https://stackoverflow.com/questions/52626252/unknown-selected-data-source-for-port-speaker-type-speaker)
* [apple forum](https://forums.developer.apple.com/thread/108785)
* [my post in oF forum](https://forum.openframeworks.cc/t/sound-fft-problems-on-ios-12/32289)
* [Maximilian](https://github.com/micknoise/Maximilian)
* [Audiokit - Swift](https://github.com/audiokit/audiokit/)
* [Audiokit.io](https://audiokit.io/)
* [Apple vDSP - Swift](https://developer.apple.com/documentation/accelerate/vdsp)


## User testing
* Inspire visuals in [Sol Lewitt](http://1.bp.blogspot.com/_DGJZjoSxy4E/THr80oVa9hI/AAAAAAAAFAY/oX-h1z7KXS4/s1600/LeWitt-wall-drawings_l.jpg)