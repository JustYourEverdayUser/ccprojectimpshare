---@diagnostic disable-next-line: lowercase-global
shell = shell
---@diagnostic disable-next-line: lowercase-global
fs = fs
---@diagnostic disable-next-line: lowercase-global
sleep = sleep
---@diagnostic disable-next-line: lowercase-global
parallel = parallel
os.pullEventRaw = os.pullEventRaw
os.shutdown = os.shutdown
os.reboot = os.reboot
shell.run("cd root/")
CH = {
    ["help"] = "Displays a help page for this terminal.\nOptionally takes a command and provides further insight on it.",
    ["cd"] = "Automatically processes and displays the selected file. If the argument is a directory, enters the directory. Exit a directory with 'cd ..'. When reading a file, enter 'continue' to go to the next page.",
    ["msg"] = "A miniture implementation of the wider comms network our site provides. Use responsibly.",
    ["brief"] =
    "Prints a briefing on the current project. Optionally accepts a file, and if available, prints its internal briefing.",
    ["ls"] = "Lists the files available.",
    ["alarm"] =
    "Sounds the site alarm. Optionally takes a 'reason' field, which will be echoed to the site's broadcast system.\nImproper usage will result in immediate investigation.",
    ["sos"] = [[
Only active during emergencies. Signals to responders that you are in urgent need of help.
After the first input, SOS follows a "dead man's switch" protocol, where it will need to periodically be refreshed. If the user fails to do so, the SOS call will be removed as well as a notice sent out to avoid your location.
If the SOS call becomes inactive, you are still able to renew it by reinputting 'sos' into the terminal.]],
    ["dni"] = "Dedicated Network Interface - Redstone and chat functions are standard with these.",
    ["edit"] = "Writes or edits a file. Requires an argument for the file's name"
}

Commands = {
    {command = "help [command]", desc = CH.help},
    {command = "cd <file>", desc = CH.cd},
    {command = "msg <message> <receiver>", desc = CH.msg},
    {command = "brief [file]", desc = CH.brief},
    {command = "ls", desc = CH.ls},
    {command = "alarm [reason]", desc = CH.alarm},
    {command = "sos", desc = CH.sos},
    {command = "edit <filename.ext>", desc = CH.edit}
}

function Main()
    shell.run("clear")
    SignIn("Mr.Kenngal","P:I2")
    repeat
        Run()
    until false
end

function Split_input(entry)
    local words = {}
    for word in string.gmatch(entry, "%S+") do
        table.insert(words, word)
    end
    return words
end

function SignIn(RUser,RPass)
    while true do
        io.write("Username: ")
        User = io.read("l")
        if User == RUser then
            while true do
                io.write(User .. "'s Password: ")
                local pass = io.read("l")
                if pass == RPass then
                    print("\nWelcome, " .. User .. ".")
                    break
                else print("Incorrect")
                end
            end
            break
        elseif User == "anonymous" then
            print("Welcome, anonymous.")
            break
        --[[
            elseif User == "dev" then
            shell.setDir("root/Projects/Project Imposter [Ongoing]/POV's/Jeremy")
            break--]]
        else print("Unknown username. Enter \"anonymous\" for guest access.")
        end
    end
end

function Help(list)
    shell.run("clear")
    for i, o in pairs(CH) do
        if list == i then print(o); break end
    end
    if list == "cmds" then
    for p, cmd in ipairs(Commands) do print(cmd.command.."\n") end
    elseif list == nil then
        print([[
You are currently accessing a policy-mandated "guest" terminal, designed for a user-friendly experience in the event that site staff are unable to assist you during an emergency.

If you are in distress, please take a few moments away from the terminal to calm yourself.If you are in danger, please enter the following command:

'sos'

For a list of commands, enter 'help cmds'
]])
        else print("Invalid argument")
        
    end
end

function HasExtension(path, ext)
    return path:sub(-#ext) == ext
end

function Cd(file)
    local path
    if file ~= nil then
        path = fs.combine(shell.dir(),file)
        if fs.isDir(path) then
            if shell.dir():sub(-4) == "root" and file == ".." then
                print("Out of bounds!")
            else shell.setDir(path)
            end
        elseif HasExtension(file,"txt") then
            shell.run("clear")
            local files = fs.open(path,"r")
            local line, overflow
            repeat
                local i = 1
                if overflow ~= nil then
                    line = overflow
                    i = i + (math.floor(#line/51)+1); print(line)
                    overflow = nil
                end
                while i <= 18 do
                    line = files.readLine()
                    if line == nil then break
                    elseif line:sub(1,1) == "-" and i ~= 1 then
                        overflow = line; break
                    elseif #line > 51 then
                        if i+math.floor(#line/51)+1 > 18 then
                            overflow = line; break
                        else i = i + (math.floor(#line/51)+1); print(line)
                        end
                    else i = i + 1; print(line)
                    end
                end
                io.write("> ")
                if io.read("l") == "continue" then
                else break
                end
            until false
            files.close()
        else print("Invalid argument")
        end
    else print("cd <file>")
    end
end

function Msg()
    print("This terminal does not support the chat function. Please locate a DNI.")
end

function Brief(file)

end

function Ls()
    shell.run("ls")
end

function Broken()
    shell.run("clear")
    print(
        "Failed to connect to requested system.\nIf this system was urgent, please remain calm and follow procedures.\nIf you are uncertain, please locate someone who is not and follow their directions.")
end

function Edit(filename)
    if filename ~= nil then
        local path = fs.combine(shell.dir(),filename)
        if fs.exists(path) then
            shell.run("clear")
            local newfile = fs.open(path,"a")
            local input
            print("Type (exit) to stop editing!\n")
            repeat
                io.write("> ")
                input = io.read("l")
                if input == "(exit)" then break end
                if newfile then newfile.write(input); newfile.close() end
                shell.run("clear")
                newfile = fs.open(path,"r")
                if newfile then print(newfile.readAll()); newfile:close() end
                newfile = fs.open(path,"a")
                newfile.write("\n")
            until false
        else print("Invalid file extension")
        end
    else print("Invalid argument")
    end
end

function Run()
    io.write(User.."@"..shell.dir().."> ")
    local input = io.read("l")
    local tokens = Split_input(input)
    local command, arg
    if tokens then command = tokens[1] end
    if tokens then arg = tokens[2]
        for i in ipairs(tokens) do
            if i > 2 then arg = arg.." "..tokens[i] end
        end
    end
    if command == "help" then
        Help(arg)
    elseif command == "cd" then
        Cd(arg)
    elseif command == "msg" then
        Msg()
    elseif command == "brief" then
        Brief(arg)
    elseif command == "ls" then
        Ls()
    elseif command == "alarm" then
        Broken()
    elseif command == "sos" then
        Broken()
    elseif command == "reboot" then
        os.reboot()
        shell.run("test")
    elseif command == "shutdown" then
        os.shutdown()
    elseif command == "clear" then
        shell.run("clear")
    elseif command == "edit" then
        Edit(arg)
    else print("Invalid command")
    end
end


local function watchTerminate()
    local event
    repeat
        event = os.pullEventRaw()
    until event == "terminate"
    shell.setDir("/")
end

parallel.waitForAny(watchTerminate,Main)

shell.run("clear")
print("Goodbye!")
sleep(1.25)
os.shutdown()
