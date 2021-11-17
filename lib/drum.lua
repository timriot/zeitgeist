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
  o.sample = o.sample or default_sample -- TODO: a default sample? YEP, but could be better! Any ideas?
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
  if self.probabilty~=100 then
    -- do something if probability isn't 100
  end
  -- hold TODO: check swing, and change swing if needed
  if self:xox(beat) then 
    -- self:play(self.sample) – Q: is this suppposed to be enabled?
    return true -- not what was intended, but I'm going with it for right now for the sake of progress
  end
end

function Drum:xox(beat)
  beat=((beat-1)%#self.riddim)+1
  return self.riddim:sub(beat,beat)~='-'
end

return Drum