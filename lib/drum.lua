local Drum={}
local script_name="zeitgeist"
local path_to_audio=_path.audio..script_name.."/"
local default_sample=path_to_audio.."_default/wa_tanzbar_kick_01.wav"

function Drum:new(o)
  -- boilerplate
  o=o or {}
  setmetatable(o,self)
  self.__index=self
  -- defaults
  o.sample = o.sample or default_sample -- TODO: a default sample?
  o.swing = o.swing or 50
  o.velocity = o.velocity or 80
  o.velocity_ramp = o.velocity_ramp or 0
  o.probabilty = o.probabilty or 100 
  o.frozen = o.frozen or false
  o.riddim = o.riddim or "x---"
  o.accent = o.accent or "----"
  -- TODO: https://sumire-io.gitlab.io/midi-velocity-curve-generator/
  o.velocity_curve={}
  o.velocity_curve[1]={}
  for i=1,128 do 
    o.velocity_curve[1][i]={0.5}
  end
  -- TODO: paste in a curve
  -- o.velocity_curve[2]={0.1,0.2}
  return o
end

function Drum:play()
  -- print(self.sample)
  local path = self.sample
  -- local amp = self.velocity_curve[1][self.velocity+1]
  -- if self.velocity_ramp > 0 then 
  --   amp = (self.beat % self.velocity_ramp)/self.velocity_ramp
  -- end
  local amp = 1
  local amp_lag = 0
  local sample_start = 0
  local sample_end = 1
  local loop = 0
  local rate = 1
  local trig = 1
  engine.play(path, amp, amp_lag, sample_start, sample_end, loop, rate, trig)
end

function Drum:emit(beat)
  self.beat=beat
  -- TODO: check if sample is defined
  if self.sample==nil then 
    print("no sample")
    do return end
  end
  -- TODO: check probabilty
  -- hold TODO: check swing, and change swing if needed
  if self:xox(beat) then 
    -- self:play(self.sample)
    return true -- not what was intended, but I'm going with it for right now for the sake of progress
  end
end

function Drum:xox(beat)
  beat=((beat-1)%#self.riddim)+1
  return self.riddim:sub(beat,beat)~='-'
end

return Drum