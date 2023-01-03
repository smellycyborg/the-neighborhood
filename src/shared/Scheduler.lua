-- Run functions on an interval allowing for clean shutdown as well

local Scheduler = {}
Scheduler.__index = Scheduler

function Scheduler.new()
	local scheduler = setmetatable({}, Scheduler)

	scheduler._shutdown = false
	scheduler._canShutDownSafely = true

	return scheduler
end

function Scheduler:interval(intervalSec, callback, startImmediately)
	if self._shutdown then
		error("Cannot run on a scheduler that has been shut down")
	end

	if not startImmediately then
		task.wait(intervalSec)
	end

	task.spawn(function()
		while not self._shutdown do
			callback()

			task.wait(intervalSec)
		end
	end)
end

function Scheduler:shutdown()
	self._shutdown = true
end

return Scheduler