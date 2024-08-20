declare pf author "SineCoder";
declare pf licence "LGPL";

import("stdfaust.lib");

rel = hgroup("[1]Follower", hslider("rel[style:knob]", 0.05, 0.0, 1, 0.001));

fol = an.amp_follower(rel);

apply_follower(l, r) = l, r: fol * l, fol * r;
 
// original author of the Faust Freeverb version
declare freeverb_demo author "Romain Michon";
declare freeverb_demo licence "LGPL";

// added different gain sliders
wetgain = vgroup("[2]Gain", hslider("wet", 0.5, 0.0, 1, 0.01));
drygain = vgroup("[2]Gain", hslider("dry", 1, 0.0, 1, 0.01));

// changed here {
process = _, _ <: (*(fixedgain), *(fixedgain) : ba.bypass2(hgroup("[1]Follower", checkbox("turn_pf_off")), apply_follower):
    re.stereo_freeverb(combfeed, allpassfeed, damping, spatSpread): *(wetgain), *(wetgain)),
    _*drygain, _*drygain :> _,_
// }
with{
    scaleroom   = 0.28;
    offsetroom  = 0.7;
    allpassfeed = 0.5;
    scaledamp   = 0.4;
    fixedgain   = 0.5;
    origSR = 44100;

    parameters(x) = hgroup("Freeverb",x);
    knobGroup(x) = parameters(hgroup("[0]",x));
    damping = knobGroup(vslider("[0] Damp [style: knob] [tooltip: Somehow control the
        density of the reverb.]",0.5, 0, 1, 0.025)*scaledamp*origSR/ma.SR);
    combfeed = knobGroup(vslider("[1] RoomSize [style: knob] [tooltip: The room size
        between 0 and 1 with 1 for the largest room.]", 0.5, 0, 1, 0.025)*scaleroom*
        origSR/ma.SR + offsetroom);
    spatSpread = knobGroup(vslider("[2] Stereo Spread [style: knob] [tooltip: Spatial
        spread between 0 and 1 with 1 for maximum spread.]",0.5,0,1,0.01)*46*ma.SR/origSR
        : int);
    g = parameters(vslider("[1] Wet [tooltip: The amount of reverb applied to the signal
        between 0 and 1 with 1 for the maximum amount of reverb.]", 0.3333, 0, 1, 0.025));
};
