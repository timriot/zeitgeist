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

local Drum=include("lib/drum")
local sequins=require('sequins')
local lattice=require('lattice')
engine.name="Goldeneye2"
local shift=false
local script_name="zeitgeist"
local path_to_audio=_path.audio..script_name.."/"

alias_map={}
alias_map.bd={"kick","bd","kd","kk","bass drum"}
alias_map.sd={"snare","sd","sn"}
alias_map.ch={"closed hat","hh","ch","hihat", "hi hat"}
alias_map.oh={"open hat","oh", "hi hat", "hihat"}
alias_map.cp={"clap","cp"}
alias_map.cb={"cowbell","cb"}
alias_map.rs={"rimshot","rs"}
alias_map.rc={"rimshot","rc"}
alias_map.tm={"tom","tom tom","tm"}

drums={}
drums.techno={}
drums.techno.bpm={120,125,130,135,140,145}  -- 120-140BPM
drums.techno.instruments={}
drums.techno.instruments={
  --bass=Instrument:new({sample=_path.audio.."zeitgeist/"})
  bd=Drum:new({riddim="x---x---x---x-x-",velocity=80}),
  sd=Drum:new({riddim="----x-------x---",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_snare_01.wav"}),
  oh=Drum:new({riddim="--x---x---x---x-",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"}),
  ch=Drum:new({riddim="---------x------",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"})
}
drums.techno.phrases={
  {pattern=sequins{"i", "III", sequins{"IV", "V"}, sequins{"VI", "V"}},root=48,scale='Minor'},
  {pattern=sequins{"ii", "III", sequins{"IV", "V"}, sequins{"VI", "V"}},root=48,scale='Minor'},
}
drums.techno.samples={}
drums.techno.pattern={}
table.insert(drums.techno.pattern,{
  bd="x---x---x---x-x-",
  sd="----x-------x---",
  ch="---------x------",
  oh="--x---x---x---x-"
})
table.insert(drums.techno.pattern,{
  bd="x---x-x-x---x---",
  sd="----x-------x---",
  ch="---------x------",
  oh="--x---x---x---x-"
})
-- drums.techno.instruments.ch:set_velocity_function(function(beat)
--   -- return ramp based on beat modulo
-- end)

-- drums.techno.pattern={}
-- table.insert(drums.techno.pattern,{
--   ac="x---",
--   -- bd={riddim="x---x-x-x---x---",velocity=function(beat) return 50 end,swing=50},
--   -- bd={riddim="x---x-x-x---x---",velocity=function(beat) return util.linlin(0,9,1,127,beat%10) end,swing=50},
--   -- ch={riddim="---------x------"},
--   oh="--x---x---x---x-"
-- })

-- --bd=drumthing("x--")
drums.dnb={}
drums.dnb.bpm={110,120,130}
drums.dnb.instruments={
  bd=Drum:new({riddim="x--x---x-xx----x",velocity=80}),
  sd=Drum:new({riddim="----x-------x---",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_snare_01.wav"}),
  -- oh=Drum:new({riddim="x",velocity=80}),
  ch=Drum:new({riddim="x-x-x-x-x-x-x-x-",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"})
  -- cp=Drum:new({riddim="x",velocity=80})
}
drums.dnb.samples={}
drums.dnb.pattern={}
table.insert(drums.dnb.pattern,{
  bd="x--x---x-xx----x",
  sd="----x-------x---",
  ch="x-x-x-x-x-x-x-x-"
})
table.insert(drums.dnb.pattern,{
  bd="x-x----xxxx-----",
  sd="----x-------x---",
  ch="x-x-x-x-x-x-x-x-"
})
drums.hiphop={}
drums.hiphop.bpm={80,90,100,105,110,115}
drums.hiphop.instruments={
  bd=Drum:new({riddim="x------xx-x-----",velocity=80}),
  sd=Drum:new({riddim="----x-------x-------x-------x--x",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_snare_01.wav"}),
  oh=Drum:new({riddim="--x---x---x---x-",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"}),
  ch=Drum:new({riddim="x---x---x---x---",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"})
}
drums.hiphop.samples={}
drums.hiphop.pattern={}
table.insert(drums.hiphop.pattern,{
  bd="x------xx-x-----",
  sd="----x-------x-------x-------x--x",
  ch="x---x---x---x---",
  oh="--x---x---x---x-"
})
table.insert(drums.hiphop.pattern,{
    bd="x------xx-x-----",
    sd="----x-------x---",
    rc="x---x---x---x---",
    rs="--x---x---x---x-"
  })
drums.house={}
drums.house.bpm={110,120,130} -- 110-130BPM, 4 on the floor
drums.house.instruments={
  bd=Drum:new({riddim="x---x---x---x---",velocity=80}),
  sd=Drum:new({riddim="----x-------x---",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_snare_01.wav"}),
  oh=Drum:new({riddim="--x---x---x---x-",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"}),
  ch=Drum:new({riddim="xxxxxxxxxxxxxxxx",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_hihat_01.wav"}),
  cp=Drum:new({riddim="----x-------x---",velocity=80,sample="/home/we/dust/audio/zeitgeist/_default/wa_tanzbar_clap_01.wav"})
}
drums.house.samples={}
drums.house.pattern={}
table.insert(drums.house.pattern,{
  bd="x---x---x---x---", 
  sd="----x-------x---",
  ch="xxxxxxxxxxxxxxxx",
  oh="--x---x---x---x-",
  cp="----x-------x---"
})
drums.vaporwave={}
drums.vaporwave.bpm={90,95,100,105,110} 
drums.vaporwave.instruments={
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
    for instrument,_ in pairs(dp) do
      if dp[instrument] and drums[random_genre]["samples"][random_kit_fix][instrument] then -- check to make sure the instrument exists, if so push dat riddim
        local random_sample = randomInstrumentSample(drums[random_genre]["samples"][random_kit_fix][instrument])
        drums.current[instrument]=di[instrument]
        for type,_ in pairs(drums.current) do
          if instrument==type then
            drums.current[instrument].sample=random_sample
            drums.current[instrument].riddim=dp[instrument]
            print("sample used:",drums.current[instrument].sample)
            print("pattern:",drums.current[instrument].riddim)
          end
        end
      end
  end
end

function matchInstruments(v)
  local genre = v or "_default"
  local to_scan_orig = path_to_audio..genre
  -- local to_scan = path_to_audio..genre.."/808/"
  local dir_orig = util.scandir(to_scan_orig)
  -- local dir = util.scandir(to_scan)
  local aliases = alias_map
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
  if inst then
    local inst_size=#inst
    local rando_index=math.random(inst_size)
    local rando_sample=inst[rando_index]
    if not rando_sample then
      rando_sample=inst[1]
    end
   return rando_sample
  else
    return "nope"
  end
end

function init()
  local path = _path.audio.."zeitgeist/prophet5_lead_48.wav"
  local amp = 1
  local amp_lag = 0
  local sample_start = 0
  local sample_end = 1
  local loop = 0
  local trig = 1
  local attack=0.1
  local decay=2
  local release=2
  clock.run(function()
    local sample_note=48
    local target_note=48
    while true do 
      target_note=target_note+1
      local rate=transpose_to_intonation(sample_note,target_note)
      engine.play2(path, amp, amp_lag, sample_start, sample_end, loop, rate, trig, attack, decay, release)
      local rate=transpose_to_intonation(sample_note,target_note+3)
      engine.play2(path, amp, amp_lag, sample_start, sample_end, loop, rate, trig, attack, decay, release)
      local rate=transpose_to_intonation(sample_note,target_note+7)
      engine.play2(path, amp, amp_lag, sample_start, sample_end, loop, rate, trig, attack, decay, release)
      clock.sleep(5)
    end
  end)
end

-- transpose_to_rate tranposes note1 to note2 as intonation
function transpose_to_intonation(note1,note2)
  -- transpose note1 into note2 using rates
  local rate=1

  -- https://github.com/monome/norns/blob/main/lua/lib/intonation.lua#L16
  local ints={1/1,16/15,9/8,6/5,5/4,4/3,45/32,3/2,8/5,5/3,16/9,15/8}

  while note2-note1>11 or note1>note2 do
    if note1<note2 then
      rate=rate*2
      note1=note1+12
    elseif note1>note2 then
      rate=rate*0.5
      note1=note1-12
    end
  end
  return rate*ints[note2-note1+1]
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
  for i=0,10 do
      local beat=0
      local division=1/16
      if i==0 then 
        division=1/4
      end
      pattern_instrument[i]=my_lattice:new_pattern{
      action=function(t)
          beat=beat+1
          local pattern_id=-1
          local ordering={}
          for instrument,_ in pairs(drums.current) do
            table.insert(ordering,instrument)
          end
          table.sort(ordering)
          for _,instrument in ipairs(ordering) do
            pattern_id=pattern_id+1              
            if pattern_id==0 then 
              -- this is a chord change pattern
              notes_in_current_chord=MusicUtil.generate_chord_roman(drums.current[instrument].root, drums.current[instrument].scale, drums.current[instrument].phrase() )
            elseif drums.current[instrument].kind=="instrument" and pattern_id==i then 
              -- this is an instrument (bass, pad)
              -- use notes_in_current_chord to activate bass / pad etc
            elseif drums.current[instrument].kind=="drum" and drums.current[instrument]:emit(beat)==true and pattern_id==i then -- I'd like a reminder on what j is doing 
            -- if drums.current[instrument].riddim(beat)==true then 
              -- if drums.current[instrument].riddim(beat)==true then
                -- (if swing is different) SET swing here: drums.current[instrument].swing 
              -- pattern.swing
              -- print(instrument)
              -- local volume=0.
              local volume=1.0
              -- How shall I hook up accent to beat? using Drum:xox or a similar class specific to accent? Drum:```?(joke)
              -- if drums.current[instrument].accent(beat)==true then
              --   volume=volume+0.2
              -- end
              -- play(drums.current[instrument].sample, volume)
              -- drums.current
              drums.current[instrument]:play()
              print("playing:",drums.current[instrument].sample)
              -- drums.techno.instruments.bd:play()
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
      -- another()
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
