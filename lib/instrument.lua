local Instrument={}
local script_name="zeitgeist"
local path_to_audio=_path.audio..script_name.."/"
local default_sample=path_to_audio.."zeitgeist/prophet5_lead_48.wav"

function Instrument:new(o)
  -- boilerplate
  o=o or {}
  setmetatable(o,self)
  self.__index=self
  -- defaults
  o.sample = o.sample or default_sample -- TODO: a default sample? YEP, but could be better! Any ideas?
  o.swing = o.swing or 50
  o.velocity = o.velocity or 80
  o.velocity_ramp = o.velocity_ramp or 0
  o.probabilty = o.probabilty or 100 
  o.frozen = o.frozen or false
  o.accent = o.accent or "----"
  o.kind = o.kind or "instrument"
  o.root = o.root or 48
  o.scale = o.scale or "Minor"
  o.amp = o.amp or 1
  o.amp_lag = o.amp_lag or 0.01
  o.sample_start = o.sample_start or 0
  -- TODO: fake round robin sampling by changing the sample start time slightly
  o.sample_end = o.sample_end or 1
  o.loop = o.loop or 0
  o.rate = o.rate or 1
  o.trig = o.trig or 1
  o.attack = o.attack or 0.1
  o.decay = o.decay or 2
  o.release = o.release or 2
  o.play_style = o.play_style or "chords"
  if o.play_style=="chords" then 
    o.play_sequence=sequins{{1,2,3}}
    o.play_adj=sequins{0}
  elseif o.play_style=="bass" then
    o.play_sequence=sequins{1}
    o.play_adj=sequins{-12,0}
  elseif o.play_style=="arp" then 
    o.play_sequence=sequins{1,2,3}
    o.play_adj=sequins{0,0,12,0}
  end

  -- TODO: https://sumire-io.gitlab.io/midi-velocity-curve-generator/
  o.velocity_curve={}
  o.velocity_curve[1]={}
  for i=1,128 do 
    o.velocity_curve[1][i]={64}
  end
  -- TODO: paste in a curve
  -- o.velocity_curve[2]={0.1,0.2}
  -- __/
  -- o.velocity_curve[1] = {1, 2, 4, 6, 8, 10, 12, 13, 15, 17, 19, 21, 23, 24, 26, 28, 30, 32, 33, 35, 37, 39, 40, 42, 44, 46, 47, 49, 51, 52, 54, 56, 57, 59, 61, 62, 64, 65, 67, 69, 70, 72, 73, 75, 76, 78, 79, 81, 82, 83, 85, 86, 88, 89, 90, 91, 93, 94, 95, 96, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 112, 113, 114, 115, 115, 116, 117, 117, 118, 118, 119, 120, 120, 121, 121, 121, 122, 122, 123, 123, 123, 123, 124, 124, 124, 124, 125, 125, 125, 125, 125, 126, 126, 126, 126, 126, 126, 126, 126, 126, 126, 126, 126, 127, 127, 127, 127, 127, 127, 127, 127, 127, 127}
  -- /--
  -- o.velocity_curve[2] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 13, 13, 14, 15, 15, 16, 17, 18, 19, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 39, 40, 41, 43, 44, 45, 46, 48, 49, 51, 52, 53, 55, 56, 58, 59, 61, 62, 64, 65, 67, 68, 70, 71, 73, 75, 76, 78, 79, 81, 83, 84, 86, 88, 89, 91, 93, 94, 96, 98, 100, 101, 103, 105, 106, 108, 110, 112, 113, 115, 117, 119, 120, 122, 124, 125, 127}
  -- \_/
  -- o.velocity_curve[3] = {124, 121, 118, 116, 113, 110, 107, 105, 102, 99, 97, 94, 91, 89, 86, 83, 81, 78, 76, 73, 71, 69, 66, 64, 62, 60, 57, 55, 53, 51, 49, 47, 45, 44, 42, 40, 39, 37, 36, 34, 33, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 21, 20, 19, 19, 18, 18, 18, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 24, 25, 26, 27, 28, 29, 31, 32, 33, 35, 36, 38, 40, 41, 43, 45, 47, 49, 50, 53, 55, 57, 59, 61, 63, 66, 68, 71, 73, 76, 78, 81, 83, 86, 89, 91, 94, 97, 99, 102, 105, 108, 111, 113, 116, 119, 122, 125, 127}
  -- /\/
  -- o.velocity_curve[4] = {2, 6, 10, 14, 19, 23, 27, 31, 34, 38, 42, 46, 49, 53, 56, 60, 63, 66, 69, 72, 75, 78, 80, 82, 85, 87, 88, 90, 92, 93, 94, 95, 96, 96, 96, 96, 96, 96, 96, 95, 94, 94, 93, 91, 90, 89, 87, 86, 84, 82, 81, 79, 77, 75, 73, 71, 69, 67, 65, 62, 60, 58, 56, 54, 52, 50, 48, 46, 44, 43, 41, 39, 38, 37, 35, 34, 33, 32, 31, 31, 30, 30, 30, 30, 30, 30, 31, 31, 32, 33, 34, 35, 36, 37, 39, 40, 42, 44, 46, 48, 50, 52, 54, 56, 59, 61, 64, 66, 69, 72, 74, 77, 80, 83, 86, 89, 92, 95, 99, 102, 105, 108, 111, 115, 118, 121, 124, 127}
  return o
end

function Instrument:play(notes)
  -- TODO: in the future, maybe need to have chords generated over several octaves (i.e. more than 3 notes)
  -- right now assume only three notes
  local note_indices_to_play=self.play_sequence()
  -- convert to table if not table
  if type(note_indices_to_play)~="table" then 
    note_indices_to_play={note_indices_to_play}
  end
  for _, note_index in ipairs(note_indices_to_play) do
    local r=self:transpose_to_intonation(self.root,notes[note_index]+self.play_adj())
    self:play_note(r)
  end
  -- if self.play_style=="chords" then
  --   for _,note in ipairs(notes) do
  --     print(self.root,note)
  --     
  --     self:play_note(r)
  --   end
  -- elseif self.play_style=="root" then
  --   table.sort(notes)
  --   local note=notes[1]
  --   print(self.root,note)
  --   local r=self:transpose_to_intonation(self.root,note)
  --   self:play_note(r)
  -- end
end


-- transpose_to_rate tranposes note1 to note2 as intonation
function Instrument:transpose_to_intonation(note1,note2)
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


function Instrument:play_note(r)
  -- print(self.sample)
  local path = self.sample
  -- local amp = self.velocity_curve[1][self.velocity+1]
  -- if self.velocity_ramp > 0 then 
  --   amp = (self.beat % self.velocity_ramp)/self.velocity_ramp
  -- end
  local rate = r or self.rate
  local amp = self.amp
  local amp_lag = self.amp_lag
  local sample_start = self.sample_start
  local sample_end = self.sample_end
  local loop = self.loop
  local rate = r or self.rate
  local trig = self.trig
  local attack = self.attack
  local decay = self.decay
  local release = self.release
  engine.play2(path, amp, amp_lag, sample_start, sample_end, loop, rate, trig, attack, decay, release)
end
-- function Instrument:emit(beat)
--   self.beat=beat
--   -- TODO: check if sample is defined
--   if self.sample==nil then 
--     print("no sample")
--     do return end
--   end
--   -- TODO: check probabilty
--   if self.probabilty~=100 then
--     -- do something if probability isn't 100
--   end
--   -- hold TODO: check swing, and change swing if needed
--   if self:xox(beat) then 
--     -- self:play(self.sample) – Q: is this suppposed to be enabled?
--     return true -- not what was intended, but I'm going with it for right now for the sake of progress
--   end
-- end

-- function Instrument:xox(beat)
--   beat=((beat-1)%#self.riddim)+1
--   return self.riddim:sub(beat,beat)~='-'
-- end

return Instrument