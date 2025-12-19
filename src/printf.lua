local printf_colors = { 
    cep = "#f0a78e", fc = "#ff8547", ce = "#e88f4f",
    o = "#f79337", cs = "#efce8f", d = "#ffd991",
    j = "#babd2f", t = "#a4cf9e", vp = "#2ecf73",
    pt = "#2eba7e", v = "#009d9d", ch = "#98e2eb",
    bv = "#2f7fcc", bl = "#6c77c1", g = "#60608f",
    n = "#c2c2da", n2 = "#9393aa", vi = "#c53dff",
    s = "#caa4cb", ps = "#f1c4f6", ch2 = "#feb1fc",
    rose = "#ed67ea", r = "#cb546b"
}

local branch = "test"

-- Redefines print behavior
if branch == "test" then
    print = print
 else
    print = tfm.exec.chatMessage
 end

 -- Loads the ui (caching)
ui.addTextArea(3232, "<font size = 14px>Debug zone",
                nil, -310, 5, 300, 600,
			    0x000000, 0x00ffaa, 0.9,
			    true)

-- updates ui (should be a proper file)
local function debug_textArea(text, target)
    ui.updateTextArea(3232, text, target)
end

-- It is just here for testing
-- Delete later
function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}

  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

-- proper function
function printf(type, message, target)
    --print("Type:"..type)
	--print("Message:"..message)
	--print(target)

    -- local printf_categories = {
    --     _warning = "print",
    --     _info = "print",
    --     _debug = "debug_textArea",
    --     _sensible = "print" }

    if type == "_debug" then
        debug_textArea(message)
    else
        printf(message)
    end

end

-- garbage area
-- printf("_info", "<n>#Volley Version: <j>2.3.0<n>", name)

message = "<font size = '12x'>"

message = message.."This is a test"

printf("debug", message, name)