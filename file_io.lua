_io = {}

function _io:init( )
  self._postTable = {}
  print("IO Library has been initialised");
end

function _io:readFile(file)
  	if not self:file_exists(file) then return {} end
	lines = {}
	for line in io.lines(file) do 
		lines[#lines + 1] = line
	end
	return lines
end

function _io:updateFiles( )
  
end

function _io:file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end
