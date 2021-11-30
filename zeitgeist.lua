-- zeitgeist v0.0.3
-- ?
--
-- llllllll.co/t/?
--
--
--
--    ▼ instructions below ▼
--
-- ?

sequins=require("sequins")
local Drum=include("lib/drum")
local Instrument=include("lib/instrument")
local lattice=include("lib/lattice")
local Euclid=require("lib/er")
local MusicUtil=require("musicutil")
engine.name="Goldeneye2"
local shift=false
local script_name="zeitgeist"
local path_to_audio=_path.audio..script_name.."/"

instrument_db={} -- lower case only
instrument_db.bd={"kick","bd","kd","kk","bass drum"}
instrument_db.sd={"snare","sd","sn"}
instrument_db.ch={"closedhat","closed hat","hh","ch","hihat", "hi hat"}
instrument_db.oh={"openhat","open hat","oh", "hi hat", "hihat"}
instrument_db.cp={"clap","cp"}
instrument_db.cb={"cowbell","cb"}
instrument_db.rs={"rimshot","rs"}
instrument_db.rc={"rimshot","rc"}
instrument_db.tm={"tom","tm"}
instrument_db.lead={"ld","lead"}
instrument_db.pad={"pd","pad"}
instrument_db.bass={"bs","bass"}
instrument_db.pluck={"plk","pluck"}
instrument_db.synth={"syn","synth"}
instrument_db.keys={"ky","keys"}
instrument_db.bells={"bell","bells"}
instrument_db.guitar={"gtr","guitar"}
instrument_db.piano={"pno","piano"}
instrument_db.string={"str","strings","string"}
instrument_db.perc={"percussion","perc"}
instrument_db.inst={"instr","inst"}
instrument_db.fx={"effect","fx"}
instrument_db.chord={"chords","chord"}
instrument_db.arp={"arpeggio","arp"}
instrument_db.seq={"sequence","seq"}

function convert_er_to_riddim(t_er)
  local r = ""
  for _,step in ipairs(t_er) do
    if step==true then
      r = r.."x"
    elseif step==false then
      r = r.."-"
    end
  end
  return r
end

function euclid_riddim(pulses, steps, shift)
  local er_seq = Euclid.gen(pulses,steps,shift)
  local riddim_seq = convert_er_to_riddim(er_seq)
  return riddim_seq
end

-- Example data structure
-- music={}
-- music.techno={}
-- music.techno.bpm={120,125,130,135,140,145}
-- music.techno.instruments={
--   bass=Instrument:new({sample=_path.audio.."zeitgeist/"})
--   ac=Instrument:new(kind="accent")?
--   - or -
--   ac=Drum:new(kind="accent")? I don't quite understand the hierarchy / composition.
--   bd=Drum:new({riddim="x---x---x---x-x-",velocity=80}),
--   sd=Drum:new({riddim="----x-------x---",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_snare_01.wav"}),
--   oh=Drum:new({riddim="--x---x---x---x-",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"}),
--   ch=Drum:new({riddim="---------x------",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"})
-- }
-- music.techno.phrases={
--   {pattern=sequins{"i", "III", sequins{"IV", "V"}, sequins{"VI", "V"}},root=48,scale='Minor'},
--   {pattern=sequins{"ii", "III", sequins{"IV", "V"}, sequins{"VI", "V"}},root=48,scale='Minor'},
-- }
-- music.techno.samples={}
-- music.techno.pattern={}
-- table.insert(music.techno.pattern,{
--   bd="x---x---x---x-x-",
--   sd="----x-------x---",
--   ch="---------x------",
--   oh="--x---x---x---x-"
-- })
-- table.insert(music.techno.pattern,{
--   bd="x---x-x-x---x---",
--   sd="----x-------x---",
--   ch="---------x------",
--   oh="--x---x---x---x-"
-- })


drums={}
drums.techno={}
drums.techno.bpm={120,125,130,135,140,145}  -- 120-140BPM
drums.techno.instruments={}
drums.techno.instruments={
  accent=Drum:new({kind="accent",riddim="x--"}),
  -- TODO: think about having riddim for instrument

  bass=Instrument:new({riddim=euclid_riddim(5,16,1),play_style="bass",sample=_path.audio.."zeitgeist/juno_bass_24.wav",division=1/4}),
  -- TODO: try out the eulclidean instead of riddim
  bd=Drum:new({riddim="x---x---x---x-x-",velocity=80}),
  sd=Drum:new({riddim="----x-------x---",velocity=80,sample=_path.audio.."zeitgeist/_default/wa_tanzbar_snare_01.wav"}),
  oh=Drum:new({riddim="--x---x---x---x-",velocity=80,sample=_path.audio.."zeitgeist/_default/wa_tanzbar_hihat_01.wav"}),
  ch=Drum:new({riddim="---------x------",velocity=80,sample=_path.audio.."zeitgeist/_default/wa_tanzbar_hihat_01.wav"})
}
-- FUTURE:
-- riddim={ 
--   Rhythm{er={8,2,4},division=1/4},
--   Rhythm{er={16,3,4},division=1/8}, -- er(16,3,4) converts to "--x---x---x"
--   Rhythm{riddim="x-----x",division=1/8},
-- }
-- riddim=sequins{ -- TODO write the er function total steps, # of steps, shift 
-- https://github.com/monome/norns/blob/main/lua/lib/er.lua
--   Rhythm{er={8,2,4},division=1/4}, -- Rhythm returns sequins
--   Rhythm{er={16,3,4},division=1/8}, -- er(16,3,4) converts to "--x---x---x"
--   Rhythm{riddim="x-----x",division=1/8},
-- }

drums.techno.samples={}
drums.techno.pattern={}
-- table.insert(drums.techno.pattern,{
--   bd="x---x---x---x-x-",
--   sd="----x-------x---",
--   ch="---------x------",
--   oh="--x---x---x---x-"
-- })
-- table.insert(drums.techno.pattern,{
--   bd="x---x-x-x---x---",
--   sd="----x-------x---",
--   ch="---------x------",
--   oh="--x---x---x---x-"
-- })
table.insert(drums.techno.pattern,{
  bd=euclid_riddim(5,16,0),
  sd=euclid_riddim(2,16,1),
  ch=euclid_riddim(1,16,12),
  oh=euclid_riddim(4,16,0)
})
-- -- drums.techno.instruments.ch:set_velocity_function(function(beat)
-- --   -- return ramp based on beat modulo
-- -- end)

-- -- drums.techno.pattern={}
-- -- table.insert(drums.techno.pattern,{
-- --   ac="x---",
-- --   -- bd={riddim="x---x-x-x---x---",velocity=function(beat) return 50 end,swing=50},
-- --   -- bd={riddim="x---x-x-x---x---",velocity=function(beat) return util.linlin(0,9,1,127,beat%10) end,swing=50},
-- --   -- ch={riddim="---------x------"},
-- --   oh="--x---x---x---x-"
-- -- })

-- -- --bd=drumthing("x--")
-- drums.dnb={}
-- drums.dnb.bpm={110,120,130}
-- drums.dnb.instruments={
--   bd=Drum:new({riddim="x--x---x-xx----x",velocity=80}),
--   sd=Drum:new({riddim="----x-------x---",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_snare_01.wav"}),
--   -- oh=Drum:new({riddim="x",velocity=80}),
--   ch=Drum:new({riddim="x-x-x-x-x-x-x-x-",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"})
--   -- cp=Drum:new({riddim="x",velocity=80})
-- }
-- drums.dnb.samples={}
-- drums.dnb.pattern={}
-- table.insert(drums.dnb.pattern,{
--   bd="x--x---x-xx----x",
--   sd="----x-------x---",
--   ch="x-x-x-x-x-x-x-x-"
-- })
-- table.insert(drums.dnb.pattern,{
--   bd="x-x----xxxx-----",
--   sd="----x-------x---",
--   ch="x-x-x-x-x-x-x-x-"
-- })
-- drums.hiphop={}
-- drums.hiphop.bpm={80,90,100,105,110,115}
-- drums.hiphop.instruments={
--   bd=Drum:new({riddim="x------xx-x-----",velocity=80}),
--   sd=Drum:new({riddim="----x-------x-------x-------x--x",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_snare_01.wav"}),
--   oh=Drum:new({riddim="--x---x---x---x-",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"}),
--   ch=Drum:new({riddim="x---x---x---x---",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"})
-- }
-- drums.hiphop.samples={}
-- drums.hiphop.pattern={}
-- table.insert(drums.hiphop.pattern,{
--   bd="x------xx-x-----",
--   sd="----x-------x-------x-------x--x",
--   ch="x---x---x---x---",
--   oh="--x---x---x---x-"
-- })
-- table.insert(drums.hiphop.pattern,{
--     bd="x------xx-x-----",
--     sd="----x-------x---",
--     rc="x---x---x---x---",
--     rs="--x---x---x---x-"
--   })
-- drums.house={}
-- drums.house.bpm={110,120,130} -- 110-130BPM, 4 on the floor
-- drums.house.instruments={
--   bd=Drum:new({riddim="x---x---x---x---",velocity=80}),
--   sd=Drum:new({riddim="----x-------x---",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_snare_01.wav"}),
--   oh=Drum:new({riddim="--x---x---x---x-",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"}),
--   ch=Drum:new({riddim="xxxxxxxxxxxxxxxx",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"}),
--   cp=Drum:new({riddim="----x-------x---",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_clap_01.wav"})
-- }
-- drums.house.samples={}
-- drums.house.pattern={}
-- table.insert(drums.house.pattern,{
--   bd="x---x---x---x---", 
--   sd="----x-------x---",
--   ch="xxxxxxxxxxxxxxxx",
--   oh="--x---x---x---x-",
--   cp="----x-------x---"
-- })
drums.vaporwave={}
drums.vaporwave.bpm={90,95,100,105,110} 
drums.vaporwave.instruments={
  accent=Drum:new({kind="accent",riddim="x--"}),
  lead=Instrument:new({sample=_path.audio.."zeitgeist/prophet5_lead_48.wav",decay=0.25,release=0.25,division=1/4}),
  -- TODO: (future) instead of setting sequins here, define pattern as {"i,"III",{"IV","V"}} and have Instrument class figure out the sequins (:count(??))
  bd=Drum:new({riddim="x---x---x---x---",velocity=80}),
  sd=Drum:new({riddim="----x-------x-------x-------x-x-",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_snare_01.wav"}),
  ch=Drum:new({riddim="--x---x---x---x-",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"}),
  cp=Drum:new({riddim="-------------------------x------",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_clap_01.wav"})
}
drums.vaporwave.samples={}
drums.vaporwave.pattern={} 
table.insert(drums.vaporwave.pattern,{
  --  1---2---3---4---
  bd="x---x---x---x---",
  sd="----x-------x---",
  ch="--x---x---x---x-"
})
table.insert(drums.vaporwave.pattern,{
    --  1---2---3---4---
    bd="x---x---x---x---",
    sd="----x-------x-------x-------x-x-",
    ch="--x---x---x---x-",
    cp="-------------------------x------"
  })
-- drums.current={}

function getTableSize(t)
  local count = 0
  for _, __ in pairs(t) do
      count = count + 1
  end
  return count
end

function getTableKeys(t, e) -- table, exclude
  local exclude = e or nil
  local keys = {}
  for k in pairs(t) do
    if k ~= e then
      table.insert(keys, k)
      -- print("key:",k)
    end
  end
  return keys
end

function notsurewhattocallthis()
  local drum_keys = getTableKeys(drums, "current") 
  local random_genre=drum_keys[math.random(#drum_keys)]
  local random_pattern=math.random(#drums[random_genre]["pattern"])
  local random_bpm=drums[random_genre]["bpm"][math.random(#drums[random_genre]["bpm"])]
  local dp=drums[random_genre]["pattern"][random_pattern]
  local di=drums[random_genre]["instruments"]
  local location = (path_to_audio..random_genre)
  local kits = util.scandir(location)
  local random_kit = kits[math.random(getTableSize(kits))]
  local random_kit_fix=string.gsub(random_kit, "/", "")
  local wavs = util.scandir(location.."/"..random_kit)
  print("genre:",random_genre,"pattern:",random_pattern,"kit:",random_kit,"BPM:",random_bpm)
  tab.print(dp)
  drums.current={}
  params:set("clock_tempo",random_bpm)
    for instrument,_ in pairs(di) do
      -- bug: accenting not firing because check below is too stringent
     if di[instrument] and drums[random_genre]["samples"][random_kit_fix][instrument] then  
          local random_sample = randomInstrumentSample(drums[random_genre]["samples"][random_kit_fix][instrument])
        drums.current[instrument]=di[instrument] --bug: related to above, but causes other problems when moved out of if clause
        for kind,_ in pairs(drums.current) do
          if instrument==kind then
            if di[instrument].kind=="drum" and dp[instrument] then
              drums.current[instrument].sample=random_sample
              drums.current[instrument].riddim=dp[instrument]
              print("sample used:",drums.current[instrument].sample)
              print("pattern:",drums.current[instrument].riddim)
            elseif di[instrument].kind=="instrument" then
                --drums.current[instrument]=drums[random_genre].phrases[1] --TO DO: update this to randomize
                -- tab.print(drums.current[instrument].phrase)
            end
          end
        end
      end
      if di[instrument].kind=="accent" then
        -- drums.current[instrument].riddim=dp[instrument]
        -- tab.print(drums.current[instrument])
      end
    end
end

function matchInstruments(v)
  local genre = v or "_default"
  local to_scan_orig = path_to_audio..genre
  -- local to_scan = path_to_audio..genre.."/808/"
  local dir_orig = util.scandir(to_scan_orig)
  -- local dir = util.scandir(to_scan)
  local aliases = instrument_db
  local kits = {}
  for _,kit in ipairs(dir_orig) do
    local kit_fix=string.gsub(kit, "/", "")
    if not drums[genre]["samples"][kit_fix] then
      drums[genre]["samples"][kit_fix] = {}
    end
    local kit_dir = util.scandir(to_scan_orig.."/"..kit)
    for i,name in ipairs(kit_dir) do
      local lcfile = string.lower(name)
      for type,val in pairs(aliases) do 
        for j,variant in ipairs(aliases[type]) do
          if string.find(lcfile, variant) then
            if not drums[genre]["samples"][kit_fix][type] then
              drums[genre]["samples"][kit_fix][type] = {}
            end
            if util.file_exists(to_scan_orig.."/"..kit..name) then
              table.insert(drums[genre]["samples"][kit_fix][type], to_scan_orig.."/"..kit..name)
              -- print("match:",type,":",variant, "filename:",name)
            end
          end
        end
      end
    end
  end
end

function randomInstrumentSample(inst)
  local inst_size=#inst
  local rando_index=math.random(inst_size)
  local rando_sample=inst[rando_index]
  if not rando_sample then
    rando_sample=inst[1]
  end
  return rando_sample
end



function init()
  start_zeitgeist()

end

function start_zeitgeist()
  for genre,_ in pairs(drums) do
    if genre~="current" then
      matchInstruments(genre)
    end
  end
  notsurewhattocallthis()

  -- new pattern
  local my_lattice=lattice:new()
  notes_in_current_chord={}
  pattern_instrument={}
  local is_accent=false
  -- if drums.current[instrument].kind=="accent" then
  --   is_accent=drums.current[instrument]:emit(beat)
  -- end
  -- drum:play(accent)
  local volume=1.0
  local chords={}
  chords.parts={}
  chords.parts[1]=random_song_chord_generator()
  chords.parts[2]=random_song_chord_generator()
  chords.changes=sequins{sequins{chords.parts[1]}:count(2),sequins{chords.parts[2]}:count(2)}
  chords.root=48
  chords.scale='Minor'
  chords.division=1
  chords.notes={}
  for i=0,10 do
      local beat=0
      local division=1/16
      if i==0 then 
        division=1
      end
      local current_chord=nil
      pattern_instrument[i]=my_lattice:new_pattern{
      action=function(t)
          beat=beat+1
          local pattern_id=-1
          local ordering={}
          for instrument,_ in pairs(drums.current) do -- TODO change instrument to index
            table.insert(ordering,instrument)
          end
          table.sort(ordering)
          for _,instrument in ipairs(ordering) do
            pattern_id=pattern_id+1              
            if i==0 then 
              -- do chord changes
              chords.notes=MusicUtil.generate_chord_roman(chords.root, chords.scale, chords.changes())
            elseif drums.current[instrument].kind=="instrument" and pattern_id==i then 
              if pattern_instrument[i].division~=drums.current[instrument].division then 
                pattern_instrument[i]:set_division(drums.current[instrument].division)
              end
              -- tab.print(drums.current[instrument])
              -- notes_in_current_chord=MusicUtil.generate_chord_roman(drums.current[instrument].root, drums.current[instrument].scale, drums.current[instrument].phrase())
              tab.print(notes_in_current_chord)
              -- TODO: need to send all the notes at the same time to make sure the instrument can figure
              drums.current[instrument]:play(chords.notes)
              
              -- for _,note in pairs(notes_in_current_chord) do
              --   -- local r = drums.current[instrument].root / note
              --   local r=transpose_to_intonation(drums.current[instrument].root,note)
              --   drums.current[instrument]:play(r)
              -- end
              -- print("instrument:",drums.current[instrument].sample)
              -- print(drums.current[instrument].root, drums.current[instrument].scale, drums.current[instrument].phrases[1])
            elseif drums.current[instrument].kind=="drum" and drums.current[instrument]:emit(beat)==true and pattern_id==i then 
            -- (if swing is different) SET swing here:
              if pattern_instrument[i].swing ~= drums.current[instrument].swing then
                -- pattern_instrument[i]:set_swing() - bug: can't use – attempt to call a nil value (method 'set_swing')
                -- tab.print(pattern_instrument[i], drums.current[instrument].swing)
              end
              -- pattern.swing
              
              -- How shall I hook up accent to beat? using Drum:xox or a similar class specific to accent? Drum:```?(joke)
              -- if drums.current[instrument].accent(beat)==true then
             
              -- play(drums.current[instrument].sample, volume)
              -- drums.current
              drums.current[instrument]:play(volume)
              print("drum:",drums.current[instrument].sample)
            elseif drums.current[instrument].kind=="accent" and drums.current[instrument]:emit(beat)==true then
              volume=volume+0.2
              print("accent!")
            end
          end
      end,
      -- division=1/8
      division=division
    }
  end
  my_lattice:start()

  -- initialize metro for updating screen
  timer=metro.init()
  timer.time=1/15
  timer.count=-1
  timer.event=update_screen
  timer:start()
end

function update_screen()
  redraw()
end

function key(k,z)
  if k==1 then
    shift=z==1
  end
  if shift then
    if k==1 then
    elseif k==2 then
    else
    end
  else
    if k==1 then
    elseif k==2 then
      notsurewhattocallthis()
    else
    end
  end
end

function enc(k,d)
  if shift then
    if k==1 then
    elseif k==2 then
    else
    end
  else
    if k==1 then
    elseif k==2 then
    else
    end
  end
end

function redraw()
  screen.clear()
  screen.update()
end

function rerun()
  norns.script.load(norns.state.script)
end

function random_song_chord_generator()
  local chords_database={
    {"I","V","vi","IV"},
    {"I","iii","IV","V"},
    {"vi","iii","V","I"},
  }
  local chosen_chords=chords_database[math.random(1,#chords_database)]
  shuffle(chosen_chords)
  return sequins(chosen_chords)
end

function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

-- TODOs
-- 0) Consider hooking up the grid – Still thinking about this. Would like to brainstorm particulars
--    Discuss further? I'm thinking very broadly, of a paged interface, but this might be overkill
-- 1) add swing to individual instruments -  
--    strategy: make X patterns in a for loop and assign pattern 1, 2, 3, .. to 
--    instrument 1, 2, 3 , ... because patterns have their own swing
-- 2) adjust velocity per instrument, random and pattern?
-- 2b)accents! ``` ``` ``  
-- 2c)adjust probabilty per instrument
-- 3) combine above with a balanced approach to *occasionally* pepper in samples outside of the declared genre
-- 4) Engine merging - pushed off until next time
-- 5) Setup a default sample for each type of drum, so that if the particular pack doesn't include a rimshot,
--    a rimshot is still played. Could be dove-tailed into 5
-- 6) Make a genre -> kit map, so that single kits can be cross polinated to numerous genres
--    Is there a better way to do this?

-- COMPLETED
-- 6) refactor init and place 228-lattice into its own function SORTA
-- 8) Classtime! YEP
-- 3) track BPM range of genre and populate it in genre drum table DONE
-- 4) Make a fuzzy, greedy search that can create tables of sample locations associated
-- with typical instrument types. DONE
-- A) Setup genre as random - DONE. Next, aqueue of random, to avoid repeats
-- B) Random samples - DONE. Next, aqueue of random, to avoid repeats
-- C) Random EVERYTHING! - Almost?
-- D) grab a random drum style, presuming that each element in 'drums' is a genre table
-- E) set drums current to grab a random kit from randomized genre - DONE Seems to work
-- F) consider alternate sample pack form of *genre*/kit1/BD.wav, in addition to *genre*/kick/01.wav - 
-- DONE. I selected to organize this more generally as kits containing all instruments, which is admittedly less helpful for my long term goal,
-- than if I'd have just implemented the original =/
-- Add some more tables of different rhythms – DONE
-- Organize samples into sample pack folders – DONE(ish)
-- Make multiple kicks, snares – In progress, led to problem below 
-- Problem – It's a pain / neverending job to normalize sample names
-- Question - Is it plausible to create a construct that will take the input
-- of a pattern defined using any of the signifiers for a BD (bd, kick, KD, KK...)
-- and match it with a wav with a filename that contains *any* of the typical
-- names of that particular instrument? I'm imagining throwing any kind of directory
-- structure at it and letting it create table of instrument types to be called upon
-- to randomly apply patterns to. 