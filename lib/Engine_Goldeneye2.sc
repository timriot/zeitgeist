// Engine_Goldeneye2
 
// Inherit methods from CroneEngine
Engine_Goldeneye2 : CroneEngine {

	// <Goldeneye2> 
	var bufGoldeneye2;
	var synGoldeneye2;
	// </Goldeneye2>

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		// <Goldeneye2> 
		bufGoldeneye2=Dictionary.new(128);
		synGoldeneye2=Dictionary.new(128);

		context.server.sync;

		SynthDef("playerGoldeneye2Stereo",{ 
				arg bufnum, amp=0, ampLag=0, t_trig=0,
				sampleStart=0,sampleEnd=1,loop=0,
				rate=1;

				var snd;
				var frames = BufFrames.kr(bufnum);

				// lag the amp for doing fade out
				amp = Lag.kr(amp,ampLag);
				// use envelope for doing fade in
				amp = amp * EnvGen.ar(Env([0,1],[ampLag]));
				
				// playbuf
				snd = PlayBuf.ar(
					numChannels:2, 
					bufnum:bufnum,
					rate:BufRateScale.kr(bufnum)*rate,
					startPos: ((sampleEnd*(rate<0))*(frames-10))+(sampleStart*frames*(rate>0)),
					trigger:t_trig,
					loop:loop,
					doneAction:2,
				);

				// multiple by amp and attenuate
				snd = snd * amp / 20 ;

				// if looping, free up synth if no output
				DetectSilence.ar(snd,doneAction:2);

				Out.ar(0,snd)
		}).add;	

		SynthDef("player2Goldeneye2Stereo",{ 
				arg bufnum, amp=0, ampLag=0, t_trig=0,
				sampleStart=0,sampleEnd=1,loop=0, attack=0.01, decay=1, release=0.1,
				rate=1;

				var snd;
				var frames = BufFrames.kr(bufnum);

				// lag the amp for doing fade out
				amp = Lag.kr(amp,ampLag);
				
				// playbuf
				snd = PlayBuf.ar(
					numChannels:2, 
					bufnum:bufnum,
					rate:BufRateScale.kr(bufnum)*rate,
					startPos: ((sampleEnd*(rate<0))*(frames-10))+(sampleStart*frames*(rate>0)),
					trigger:t_trig,
					loop:loop,
					doneAction:2,
				);
				//snd=PitchShift.ar(snd,<rate 0 - ?>)

				// multiple by amp and attenuate
				snd = snd * amp * EnvGen.ar(Env([0,1,1,0],[attack,decay,release])) / 20 ;

				// if looping, free up synth if no output
				DetectSilence.ar(snd,doneAction:2);

				Out.ar(0,snd)
		}).add;	

		SynthDef("playerGoldeneye2Mono",{ 
				arg bufnum, amp=0, ampLag=0, t_trig=0,
				sampleStart=0,sampleEnd=1,loop=0,
				rate=1;

				var snd;
				var frames = BufFrames.kr(bufnum);

				// lag the amp for doing fade in/out
				amp = Lag.kr(amp,ampLag);
				// use envelope for doing fade in
				amp = amp * EnvGen.ar(Env([0,1],[ampLag]));
				
				// playbuf
				snd = PlayBuf.ar(
					numChannels:1, 
					bufnum:bufnum,
					rate:BufRateScale.kr(bufnum)*rate,
					startPos: ((sampleEnd*(rate<0))*(frames-10))+(sampleStart*frames*(rate>0)),
					trigger:t_trig,
					loop:loop,
					doneAction:2,
				);

				snd = Pan2.ar(snd,0);

				// multiple by amp and attenuate
				snd = snd * amp / 20;

				// if looping, free up synth if no output
				DetectSilence.ar(snd,doneAction:2);

				Out.ar(0,snd)
		}).add;	


		this.addCommand("play2","sffffffffff", { arg msg;
			var filename=msg[1];
			var synName="player2Goldeneye2Mono";
			if (bufGoldeneye2.at(filename)==nil,{
				// load buffer
				Buffer.read(context.server,filename,action:{
					arg bufnum;
					if (bufnum.numChannels>1,{
						synName="player2Goldeneye2Stereo";
					});
					bufGoldeneye2.put(filename,bufnum);
					Synth(synName,[
						\bufnum,bufnum,
						\amp,msg[2],
						\ampLag,msg[3],
						\sampleStart,msg[4],
						\sampleEnd,msg[5],
						\loop,msg[6],
						\rate,msg[7],
						\t_trig,msg[8],
						\attack,msg[9],
						\decay,msg[10],
						\release,msg[11],
					],target:context.server).onFree({
						// ("freed "++filename).postln;
					});
				});
			},{
				// buffer already loaded, just play it
				if (bufGoldeneye2.at(filename).numChannels>1,{
					synName="player2Goldeneye2Stereo";
				});
				Synth(synName,[
					\bufnum,bufGoldeneye2.at(filename),
					\amp,msg[2],
					\ampLag,msg[3],
					\sampleStart,msg[4],
					\sampleEnd,msg[5],
					\loop,msg[6],
					\rate,msg[7],
					\t_trig,msg[8],
					\attack,msg[9],
					\decay,msg[10],
					\release,msg[11],
				],target:context.server).onFree({
					// ("freed "++filename).postln;
				});
			});
		});

		this.addCommand("play","sfffffff", { arg msg;
			var filename=msg[1];
			var synName="playerGoldeneye2Mono";
			if (bufGoldeneye2.at(filename)==nil,{
				// load buffer
				Buffer.read(context.server,filename,action:{
					arg bufnum;
					if (bufnum.numChannels>1,{
						synName="playerGoldeneye2Stereo";
					});
					bufGoldeneye2.put(filename,bufnum);
					synGoldeneye2.put(filename,Synth(synName,[
						\bufnum,bufnum,
						\amp,msg[2],
						\ampLag,msg[3],
						\sampleStart,msg[4],
						\sampleEnd,msg[5],
						\loop,msg[6],
						\rate,msg[7],
						\t_trig,msg[8],
					],target:context.server).onFree({
						// ("freed "++filename).postln;
					}));
					NodeWatcher.register(synGoldeneye2.at(filename));
				});
			},{
				// buffer already loaded, just play it
				if (bufGoldeneye2.at(filename).numChannels>1,{
					synName="playerGoldeneye2Stereo";
				});
				if (synGoldeneye2.at(filename).isRunning==true,{
					synGoldeneye2.at(filename).set(
						\bufnum,bufGoldeneye2.at(filename),
						\amp,msg[2],
						\ampLag,msg[3],
						\sampleStart,msg[4],
						\sampleEnd,msg[5],
						\loop,msg[6],
						\rate,msg[7],
						\t_trig,msg[8],
					);
				},{
					synGoldeneye2.put(filename,Synth(synName,[
						\bufnum,bufGoldeneye2.at(filename),
						\amp,msg[2],
						\ampLag,msg[3],
						\sampleStart,msg[4],
						\sampleEnd,msg[5],
						\loop,msg[6],
						\rate,msg[7],
						\t_trig,msg[8],
					],target:context.server).onFree({
						// ("freed "++filename).postln;
					}));
					NodeWatcher.register(synGoldeneye2.at(filename));
				});
			});
		});
		// </Goldeneye2> 

	}

	free {
		// <Goldeneye2> 
		synGoldeneye2.keysValuesDo({ arg key, value; value.free; });
		bufGoldeneye2.keysValuesDo({ arg key, value; value.free; });
		// </Goldeneye2> 
	}
}
