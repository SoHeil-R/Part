local SUDO = 311231963
local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
     return
    end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
return "سوپرگروه["..msg.to.title.."]اضافه شد\nتوسط:["..msg.from.id.."]"..part
  end
        -- create data array in moderation.json
      data[tostring(msg.to.id)] = {
              owners = {},
      mods ={},
      banned ={},
      is_silent_users ={},
      filterlist ={},
      settings = {
          set_name = msg.to.title,
          lock_link = 'no',
          lock_tag = 'no',
          lock_spam = 'yes',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
		  lock_cmd = 'no',
          lock_sticker = 'no',
          lock_bots = 'yes',
          lock_pin = 'no',
		  lock_tgser = 'no',
		  lock_fwd = 'no',
          welcome = 'no',
          },
   mutes = {
                  mute_fwd = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photos = 'no',
                  mute_gif = 'no',
                  mute_loc = 'no',
                  mute_doc = 'no',
                  mute_voice = 'no',
                   mute_all = 'no',
				   mute_keyboard = 'no'
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
  return "سوپرگروه["..msg.to.title.."]اضافه شد\nتوسط:["..msg.from.id.."]"..part
end

local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
        return
    end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
    return 'سوپرگروه به لیست گروه ها اضافه نشد'..part
   end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
  return "سوپرگروه["..msg.to.title.."]ازلیست گروه ها حذف شد\nتوسط:["..msg.from.id.."]"..part
end
 local function config_cb(arg, data)
  print(serpent.block(data))
   for k,v in pairs(data.members_) do
   local function config_mods(arg, data)
       local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = v.user_id_
  }, config_mods, {chat_id=arg.chat_id,user_id=v.user_id_})
 
if data.members_[k].status_.ID == "ChatMemberStatusCreator" then
owner_id = v.user_id_
   local function config_owner(arg, data)
  print(serpent.block(data))
       local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = owner_id
  }, config_owner, {chat_id=arg.chat_id,user_id=owner_id})
   end
end
    return tdcli.sendMessage(arg.chat_id, "", 0, "تمام ادمین های گروه ترفیع پیدا کردند"..part, 0, "md")
     end

local function filter_word(msg, word)
local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)]['filterlist'] then
    data[tostring(msg.to.id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
if data[tostring(msg.to.id)]['filterlist'][(word)] then
         return "کلمه ["..word.."] ازقبل فیلتر بوده"..part
    end
   data[tostring(msg.to.id)]['filterlist'][(word)] = true
     save_data(_config.moderation.data, data)
         return "کلمه ["..word.."] از به لیست فیلترینگ اضافه شد"..part
    end

local function unfilter_word(msg, word)
 local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)]['filterlist'] then
    data[tostring(msg.to.id)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
      if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
       save_data(_config.moderation.data, data)
         return "کلمه ["..word.."] از لیست فیلترینگ حذف شد"..part
      else
         return "کلمه ["..word.."] در لیست فیلترینگ وجود ندارد"..part
      end
   end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
    return "سوپرگروه به لیست گروه های مدیریتی بات اضافه نشده"..part
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
   return "هیچ مدیری برای این سوپرگروه انتخاب نشده است"..part
  end

   message = 'لیست مدیران گروه :\n---------------------\n'
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n---------------------\n'..part
   i = i + 1
end
  return message
end

local function ownerlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
return "سوپرگروه به لیست گروه های مدیریتی بات اضافه نشده"..part
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
    return "هیچ مالکی برای این گروه انتخاب نشده است"..part
  end
   message = 'لیست مالکین گروه :\n---------------------\n'
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n---------------------\n'..part
   i = i + 1
end
  return message
end
function exi_files(cpath)
    local files = {}
    local pth = cpath
    for k, v in pairs(scandir(pth)) do
		table.insert(files, v)
    end
    return files
end

local function file_exi(name, cpath)
    for k,v in pairs(exi_files(cpath)) do
        if name == v then
            return true
        end
    end
    return false
end

local function index_function(user_id)
  for k,v in pairs(_config.admins) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end

local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 

local function already_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end

local function exi_file()
    local files = {}
    local pth = tcpath..'/data/document'
    for k, v in pairs(scandir(pth)) do
        if (v:match('.lua$')) then
            table.insert(files, v)
        end
    end
    return files
end

local function pl_exi(name)
    for k,v in pairs(exi_file()) do
        if name == v then
            return true
        end
    end
    return false
end
local function botrem(msg)
	local data = load_data(_config.moderation.data)
	data[tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = nil
		save_data(_config.moderation.data, data)
	end
	data[tostring(groups)][tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	if redis:get('CheckExpire::'..msg.to.id) then
		redis:del('CheckExpire::'..msg.to.id)
	end
	if redis:get('ExpireDate:'..msg.to.id) then
		redis:del('ExpireDate:'..msg.to.id)
	end
	tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
end

local function warning(msg)
	local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
	if expiretime == -1 then
		return
	else
	local d = math.floor(expiretime / 86400) + 1
        if tonumber(d) == 1 and not is_sudo(msg) and is_mod(msg) then
				tdcli.sendMessage(msg.to.id, 0, 1, 'از شارژ گروه 1 روز باقی مانده، برای شارژ مجدد با سودو ربات تماس بگیرید وگرنه با اتمام زمان شارژ، گروه از لیست ربات حذف وربات گروه را ترک خواهد کرد.'..part, 1, 'md')
		end
	end
end

local function sudolist(msg)
local sudo_users = _config.sudo_users
 text = "لیست سودو های ربات :\n---------------------\n"
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n---------------------\n"..part
end
return text
end
local function adminlist(msg)
local sudo_users = _config.sudo_users
 text = "لیست ادمین های ربات :\n---------------------\n"
		  	local compare = text
		  	local i = 1
		  	for v,user in pairs(_config.admins) do
			    text = text..i..'- '..(user[2] or '')..' - ('..user[1]..')\n---------------------\n'..part
		  	i = i +1
		  	end
		  	if compare == text then
		  		text = 'ادمینی برای ربات تعیین نشده'..part
		  	end
		  	return text
    end
local function action_by_reply(arg, data)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
    if data.sender_user_id_ then
  if not administration[tostring(data.chat_id_)] then
    return tdcli.sendMessage(data.chat_id_, "", 0, "سوپرگروه به لیست گروه های مدیریتی بات اضافه نشده"..part, 0, "md")
     end

if cmd == "visudo" then
local function visudo_cb(arg, data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = data.id_
end
if already_sudo(tonumber(data.id_)) then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل سودو ربات بود ["..user_name.."]"..part, 0, "md")
      end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nبه مقام سودو ربات منتصب شد ["..user_name.."]"..part, 0, "md")
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, visudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  
if cmd == "desudo" then
local function desudo_cb(arg, data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = data.id_
end
     if not already_sudo(data.id_) then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل سودو ربات نبود ["..user_name.."]"..part, 0, "md")
      end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز مقام سودو ربات برکنار شد ["..user_name.."]"..part, 0, "md")
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, desudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end

    if cmd == "adminprom" then
local function adminprom_cb(arg, data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = data.id_
end
if is_admin1(tonumber(data.id_)) then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل ادمین ربات بود ["..user_name.."]"..part, 0, "md")
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nبه مقام ادمین ربات منتصب شد ["..user_name.."]"..part, 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, adminprom_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
  
    if cmd == "admindem" then
local function admindem_cb(arg, data)
	local nameid = index_function(tonumber(data.id_))
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = data.id_
end
if not is_admin1(data.id_) then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل ادمین ربات نبود ["..user_name.."]"..part, 0, "md")
      end
		table.remove(_config.admins, nameid)
		save_config()
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز مقام ادمین ربات برکنار شد ["..user_name.."]"..part, 0, "md")
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, admindem_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end

if cmd == "setowner" then
local function owner_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = data.id_
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0,"کاربر:\nاز قبل صاحب گروه بود ["..user_name.."]"..part, 0, "md")
      end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nبه مقام صاحب گروه منتصب شد ["..user_name.."]"..part, 0, "md")
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "promote" then
local function promote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.id_)
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل مدیر گروه بود ["..user_name.."]"..part, 0, "md")
      end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nبه مقام مدیر گروه منتصب شد ["..user_name.."]"..part, 0, "md")
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
     if cmd == "remowner" then
local function rem_owner_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = data.id_
end
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل صاحب گروه نبود ["..user_name.."]"..part, 0, "md")
      end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز مقام صاحب گروه برکنار شد ["..user_name.."]"..part, 0, "md")
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "demote" then
local function demote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.id_)
end
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل مدیر گروه نبود ["..user_name.."]"..part, 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز مقام مدیر گروه برکنار شد ["..user_name.."]"..part, 0, "md")
   end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "ids" then
local function id_cb(arg, data)
    return tdcli.sendMessage(arg.chat_id, "", 0, "شناسه کاربری: *"..data.id_.."*"..part, 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
  return tdcli.sendMessage(data.chat_id_, "", 0, "مشکلی پیش اومد\nدوباره امتحان کن:)"..part, 0, "md")
      end
   end

local function action_by_username(arg, data)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
    return tdcli.sendMessage(data.chat_id_, "", 0, "سوپرگروه به لیست گروه های مدیریتی بات اضافه نشده"..part, 0, "md")
     end
if not arg.username then return false end
   if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = data.id_
end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل صاحب گروه بود ["..user_name.."]"..part, 0, "md")
      end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nبه مقام صاحب گروه منتصب شد ["..user_name.."]"..part, 0, "md")
   end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل مدیر گروه بود ["..user_name.."]"..part, 0, "md")
      end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nبه مقام مدیر گروه منتصب شد ["..user_name.."]"..part, 0, "md")
   end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل صاحب گروه نبود ["..user_name.."]"..part, 0, "md")
      end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز مقام صاحب گروه برکنار شد ["..user_name.."]"..part, 0, "md")
   end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل مدیر گروه نبود ["..user_name.."]"..part, 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز مقام مدیر گروه برکنار شد ["..user_name.."]"..part, 0, "md")
   end
   if cmd == "id" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "شناسه کاربری: *"..data.id_.."*"..part, 0, "md")
end
    if cmd == "res" then
       return tdcli.sendMessage(arg.chat_id, 0, "شناسه کاربری: *"..data.id_.."*"..part, 0, 'md')
   end
else
  return ":("
   end
end

local function action_by_id(arg, data)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
    return tdcli.sendMessage(data.chat_id_, "", 0, "سوپرگروه به لیست گروه های مدیریتی بات اضافه نشده"..part, 0, "md")
     end
if not tonumber(arg.user_id) then return false end
   if data.id_ then
if data.first_name_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if cmd == "setowner" then
  if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل صاحب گروه بود ["..user_name.."]"..part, 0, "md")
      end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
  return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nبه مقام صاحب گروه منتصب شد ["..user_name.."]"..part, 0, "md")
   end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل مدیر گروه بود ["..user_name.."]"..part, 0, "md")
      end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nبه مقام مدیر گروه منتصب شد ["..user_name.."]"..part, 0, "md")
   end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل صاحب گروه نبود ["..user_name.."]"..part, 0, "md")
      end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز مقام صاحب گروه برکنار شد ["..user_name.."]"..part, 0, "md")
   end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز قبل مدیر گروه نبود ["..user_name.."]"..part, 0, "md")
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر:\nاز مقام مدیر گروه برکنار شد ["..user_name.."]"..part, 0, "md")
   end
    if cmd == "whois" then
if data.username_ then
username = '@'..check_markdown(data.username_)
else
username = 'ندارد'
  end
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'اطلاعات کاربری['..data.first_name_..']:\nیوزرنیم : '..username..''..part, 1)
 else
  return ":("..part
  end
end
end
end
---------------Lock Link-------------------
local function lock_link(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
 return "ارسال لینک از قبل ممنوع میباشد"..part
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
 return "ارسال لینک ممنوع شد"..part
end
end

local function ban_link(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_link_ban = data[tostring(target)]["settings"]["lock_link"] 
if lock_link_ban == "ban" then
 return "قفل پاک کردن لینک و حذف کاربر از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_link"] = "ban"
save_data(_config.moderation.data, data) 
 return "قفل پاک کردن لینک و حذف کاربر فعال شد"..part
end
end

local function warn_link(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_link_warn = data[tostring(target)]["settings"]["lock_link"] 
if lock_link_warn == "warn" then
 return "اخطار ارسال لینک از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_link"] = "warn"
save_data(_config.moderation.data, data) 
 return "اخطار ارسال لینک فعال شد"..part
end
end

local function unlock_link(msg, data, target)
 if not is_mod(msg) then
return
end

local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
return "هشدار:\nارسال لینک ممنوع نشده"..part
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 

return "ارسال لینک ازاد شد"..part
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
 return "ارسال تگ از قبل قفل میباشد"..part
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
 return "ارسال تگ قفل شد"..part
end
end

local function ban_tag(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_tag_ban = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag_ban == "ban" then
 return "قفل پاک کردن ت و حذف کاربر از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_tag"] = "ban"
save_data(_config.moderation.data, data) 
 return "قفل پاک کردن تگ و حذف کاربر فعال شد"..part
end
end

local function warn_tag(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_tag_warn = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag_warn == "warn" then
 return "اخطار ارسال تگ از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_tag"] = "warn"
save_data(_config.moderation.data, data) 
 return "اخطار ارسال تگ فعال شد"..part
end
end
local function unlock_tag(msg, data, target)
 if not is_mod(msg) then
 return
end 

local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
return "هشدار:\nارسال تگ ممنوع نشده"..part
else 
data[tostring(target)]["settings"]["lock_tag"] = "no"
save_data(_config.moderation.data, data) 
return "ارسال تگ ازاد شد"..part
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
 return "ارسال فراخوانی از قبل ممنوع میباشد"..part
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
 return "ارسال فراخوانی افراد ممنوع شد"..part
end
end

local function ban_mention(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_mention_ban = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention_ban == "ban" then
 return "قفل پاک کردن فراخوانی و حذف کاربر از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_mention"] = "ban"
save_data(_config.moderation.data, data) 
 return "قفل پاک کردن فراخوانی و حذف کاربر فعال شد"..part
end
end

local function warn_mention(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_mention_warn = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention_warn == "warn" then
 return "اخطار ارسال فراخوانی از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_mention"] = "warn"
save_data(_config.moderation.data, data) 
 return "اخطار ارسال فراخوانی فعال شد"..part
end
end
local function unlock_mention(msg, data, target)
 if not is_mod(msg) then
return
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
return "هشدار:\n ارسال فراخوانی ممنوع نبوده"..part
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
return "ارسال فراخوانی افراد ازاد شد"..part
end
end
---------------Lock Sticker-------------------
local function lock_sticker(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_sticker = data[tostring(target)]["settings"]["lock_sticker"] 
if lock_sticker == "yes" then
 return "ارسال استیکر از قبل ممنوع می باشد"..part
else
 data[tostring(target)]["settings"]["lock_sticker"] = "yes"
save_data(_config.moderation.data, data) 
 return "ارسال استیکر قفل شد"..part
end
end

local function ban_sticker(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_sticker_ban = data[tostring(target)]["settings"]["lock_sticker"] 
if lock_sticker_ban == "ban" then
 return "قفل پاک کردن استیکر و حذف کاربر از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_sticker"] = "ban"
save_data(_config.moderation.data, data) 
 return "قفل پاک کردن استیکر و حذف کاربر فعال شد"..part
end
end

local function warn_sticker(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_sticker_warn = data[tostring(target)]["settings"]["lock_sticker"] 
if lock_sticker_warn == "warn" then
 return "اخطار ارسال استیکر از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_sticker"] = "warn"
save_data(_config.moderation.data, data) 
 return "اخطار ارسال استیکر فعال شد"..part
end
end
local function unlock_sticker(msg, data, target)
 if not is_mod(msg) then
 return
end 

local lock_sticker = data[tostring(target)]["settings"]["lock_sticker"]
 if lock_sticker == "no" then
return "هشدار:\nارسال استیکر ممنوع نمی باشد"..part
else 
data[tostring(target)]["settings"]["lock_sticker"] = "no"
save_data(_config.moderation.data, data) 
return "ارسال استیکر ازاد شد"..part
end
end
---------------Lock Forward-------------------
local function lock_fwd(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_fwd = data[tostring(target)]["settings"]["lock_fwd"] 
if lock_fwd == "yes" then
 return "فروارد پیام در گروه از قبل ممنوع میباشد"..part
else
 data[tostring(target)]["settings"]["lock_fwd"] = "yes"
save_data(_config.moderation.data, data) 
 return "فروارد پیام ممنوع شد"..part
end
end

local function ban_fwd(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_fwd_ban = data[tostring(target)]["settings"]["lock_fwd"] 
if lock_fwd_ban == "ban" then
 return "قفل پاک کردن فروارد و حذف کاربر از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_fwd"] = "ban"
save_data(_config.moderation.data, data) 
 return "قفل پاک کردن فروارد و حذف کاربر فعال شد"..part
end
end

local function warn_fwd(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_fwd_warn = data[tostring(target)]["settings"]["lock_fwd"] 
if lock_fwd_warn == "warn" then
 return "اخطار ارسال فروارد از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_fwd"] = "warn"
save_data(_config.moderation.data, data) 
 return "اخطار ارسال فروارد فعال شد"..part
end
end
local function unlock_fwd(msg, data, target)
 if not is_mod(msg) then
 return
end 

local lock_fwd = data[tostring(target)]["settings"]["lock_fwd"]
 if lock_fwd == "no" then
return "هشدار:\nفروارد پیام ممنوع نمیباشد"..part
else 
data[tostring(target)]["settings"]["lock_fwd"] = "no"
save_data(_config.moderation.data, data) 
return "فروارد پیام ازاد شد"..part
end
end
---------------Lock CMD-------------------
local function lock_cmd(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_cmd = data[tostring(target)]["settings"]["lock_cmd"] 
if lock_cmd == "yes" then
 return "قفل دستورات ربات از قبل فعال میباشد"..part
else
 data[tostring(target)]["settings"]["lock_cmd"] = "yes"
save_data(_config.moderation.data, data) 
 return "قفل دستورات ربات فعال شد"..part
end
end

local function ban_cmd(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_cmd_ban = data[tostring(target)]["settings"]["lock_cmd"] 
if lock_cmd_ban == "ban" then
 return "قفل پاک کردن دستورات و حذف کاربر از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_cmd"] = "ban"
save_data(_config.moderation.data, data) 
 return "قفل پاک کردن دستورات و حذف کاربر فعال شد"..part
end
end

local function warn_cmd(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_cmd_warn = data[tostring(target)]["settings"]["lock_cmd"] 
if lock_cmd_warn == "warn" then
 return "اخطار ارسال دستورات از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_cmd"] = "warn"
save_data(_config.moderation.data, data) 
 return "اخطار ارسال دستورات فعال شد"..part
end
end
local function unlock_cmd(msg, data, target)
 if not is_mod(msg) then
 return
end 

local lock_cmd = data[tostring(target)]["settings"]["lock_cmd"]
 if lock_cmd == "no" then
return "هشدار:\nدستورات ربات قفل نمیباشند"..part
else 
data[tostring(target)]["settings"]["lock_cmd"] = "no"
save_data(_config.moderation.data, data) 
return "دستورات بات ازاد شدند"..part
end
end
---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
 return "ارسال کلمات عربی-فارسی از قبل ممنوع میباشد"..part
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
 return "ارسال کلمات عربی-فارسی در گروه ممنوع شد"..part
end
end

local function ban_arabic(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_arabic_ban = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic_ban == "ban" then
 return "قفل پاک کردن ارسال کلمات عربی-فارسی و حذف کاربر از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_arabic"] = "ban"
save_data(_config.moderation.data, data) 
 return "قفل پاک کردن ارسال کلمات عربی-فارسی و حذف کاربر فعال شد"..part
end
end

local function warn_arabic(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_arabic_warn = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic_warn == "warn" then
 return "اخطار ارسال کلمات عربی-فارسی از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_arabic"] = "warn"
save_data(_config.moderation.data, data) 
 return "اخطار ارسال کلمات عربی-فارسی فعال شد"..part
end
end 
local function unlock_arabic(msg, data, target)
 if not is_mod(msg) then
return
end

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
return "هشدار:\nارسال کلمات عربی-فارسی در گروه ممنوع نمی باشد"..part
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" 
save_data(_config.moderation.data, data) 
return "ارسال کلمات عربی-فارسی آزاد شد"..part
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
 return "ویرایش پیام از قبل ممنوع میباشد"..part
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
 return "ویرایش پیام ممنوع شد"..part
end
end

local function unlock_edit(msg, data, target)
 if not is_mod(msg) then
return
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
return "هشدار:\nویرایش پیام در گروه ممنوع نمیباشد"..part
else 
data[tostring(target)]["settings"]["lock_edit"] = "no"
 save_data(_config.moderation.data, data) 
return "ویرایش پیام ازاد شد"..part
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
 return "ارسال هرزنامه از قبل ممنوع میباشد"..part
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
 return "ارسال هرزنامه ممنوع شد"..part
end
end

local function unlock_spam(msg, data, target)
 if not is_mod(msg) then
return
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
 return "هشدار:\nارسال هرزنامه ممنوع نمیباشد"..part
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" 
save_data(_config.moderation.data, data)
 return "ارسال هرزنامه در گروه آزاد شد"..part
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
 return "ارسال پیام مکرر از قبل ممنوع میباشد"..part
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
 return "ارسال پیام مکرر ممنوع شد"..part
end
end

local function unlock_flood(msg, data, target)
 if not is_mod(msg) then
return
end

local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
return "هشدار:\nپیام مکرر ممنوع نمیباشد"..part
else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 
return "ارسال پیام مکرر ازاد شد"..part
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
 return "ورود ربات ها به گروه از قبل ممنوع میباشد"..part
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
 return "ورود ربات ها به گروه ممنوع شد"..part
end
end

local function unlock_bots(msg, data, target)
 if not is_mod(msg) then
return
end 

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
return "هشدار:\nورود ربات ها به گروه ممنوع نمی باشد"..part
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
return "ورود ربات ها به گروه ازاد شد"..part
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
 return "ارسال پیام های دارای فونت از قبل ممنوع میباشد"..part
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
 return "ارسال پیام های دارای فونت ممنوع شد"..part
end
end

local function ban_markdown(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_markdown_ban = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown_ban == "ban" then
 return "قفل پاک کردن کلمات دارای فونت و حذف کاربر از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_markdown"] = "ban"
save_data(_config.moderation.data, data) 
 return "قفل پاک کردن کلمات داری فونت و حذف کاربر فعال شد"..part
end
end

local function warn_markdown(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_markdown_warn = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown_warn == "warn" then
 return "اخطار ارسال کلمات داری فونت از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_markdown"] = "warn"
save_data(_config.moderation.data, data) 
 return "اخطار ارسال کلمات داری فونت فعال شد"..part
end
end
local function unlock_markdown(msg, data, target)
 if not is_mod(msg) then
return
end 

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
return "هشدار:\nارسال پیام های فونت در گروه ممنوع نمیباشد"..part
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no"
 save_data(_config.moderation.data, data) 
return "ارسال پیام های دارای فونت در گروه آزاد شد"..part
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
 return "ارسال صفحات وب از قبل ممنوع میباشد"..part
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
 return "ارسال صفحات وب ممنوع شد"..part
end
end

local function ban_webpage(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_webpage_ban = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage_ban == "ban" then
 return "قفل پاک کردن ارسال صفحات وب و حذف کاربر از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_webpage"] = "ban"
save_data(_config.moderation.data, data) 
 return "قفل پاک کردن ارسال صفحات وب و حذف کاربر فعال شد"..part
end
end

local function warn_webpage(msg, data, target)
if not is_mod(msg) then
 return
end

local lock_webpage_warn = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage_warn == "warn" then
 return "اخطار ارسال صفحات وب از قبل فعال بود"..part
else
data[tostring(target)]["settings"]["lock_webpage"] = "warn"
save_data(_config.moderation.data, data) 
 return "اخطار ارسال صفحات وب فعال شد"..part
end
end 
local function unlock_webpage(msg, data, target)
 if not is_mod(msg) then
return
end 

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
return "هشدار:\nارسال صفحات وب درگروه ممنوع نمیباشد"..part
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
return "ارسال صفحات وب ازاد شد"..part
end
end
---------------Lock tgser-------------------
local function lock_tgser(msg, data, target)
if not is_mod(msg) then
return
end

local lock_tgser = data[tostring(target)]["settings"]["lock_tgser"] 
if lock_tgser == "yes" then
 return "سرویس تلگرام ازقبل قفل بود"..part
else
data[tostring(target)]["settings"]["lock_tgser"] = "yes"
save_data(_config.moderation.data, data) 
 return "سرویس تلگرام قفل شد"..part
end
end

local function unlock_tgser(msg, data, target)
 if not is_mod(msg) then
return
end 
local lock_tgser = data[tostring(target)]["settings"]["lock_tgser"]
 if lock_tgser == "no" then
return "هشدار:\nسرویس تلگرام قفل نیست"..part
else
data[tostring(target)]["settings"]["lock_tgser"] = "no"
 save_data(_config.moderation.data, data) 
return "قفل سرویس تلگرام ازادشد"..part
end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 
if not is_mod(msg) then
 return
end

local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then
 return "سنجاق کردن پیام درگروه ممنوع میباشد"..part
else
 data[tostring(target)]["settings"]["lock_pin"] = "yes"
save_data(_config.moderation.data, data) 
 return "سنجاق کردن پیام در گروه ممنوع شد"..part
end
end

local function unlock_pin(msg, data, target)
 if not is_mod(msg) then
return
end 

local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "no" then
return "هشدار:\nسنجاق کردن پیام در گروه ممنوع نمیباشد"..part
else 
data[tostring(target)]["settings"]["lock_pin"] = "no"
save_data(_config.moderation.data, data) 
return "سنجاق کردن پیام در گروه آزاد شد"..part
end
end

function group_settings(msg, target) 	
if not is_mod(msg) then
  return
end
local data = load_data(_config.moderation.data)
local target = msg.to.id 
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
	print('custom'..NUM_MSG_MAX) 	
else 	
NUM_MSG_MAX = 5
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_link"] then			
data[tostring(target)]["settings"]["lock_link"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tag"] then			
data[tostring(target)]["settings"]["lock_tag"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_mention"] then			
data[tostring(target)]["settings"]["lock_mention"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_arabic"] then			
data[tostring(target)]["settings"]["lock_arabic"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_edit"] then			
data[tostring(target)]["settings"]["lock_edit"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_spam"] then			
data[tostring(target)]["settings"]["lock_spam"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_flood"] then			
data[tostring(target)]["settings"]["lock_flood"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_bots"] then			
data[tostring(target)]["settings"]["lock_bots"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_markdown"] then			
data[tostring(target)]["settings"]["lock_markdown"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_webpage"] then			
data[tostring(target)]["settings"]["lock_webpage"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_sticker"] then			
data[tostring(target)]["settings"]["lock_sticker"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["welcome"] then			
data[tostring(target)]["settings"]["welcome"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_cmd"] then			
data[tostring(target)]["settings"]["lock_cmd"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tgser"] then			
data[tostring(target)]["settings"]["lock_tgser"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_fwd"] then			
data[tostring(target)]["settings"]["lock_fwd"] = "no"		
end
end

 if data[tostring(target)]["settings"] then		
 if not data[tostring(target)]["settings"]["lock_pin"] then			
 data[tostring(target)]["settings"]["lock_pin"] = "no"		
 end
 end
 local expire_date = ''
local expi = redis:ttl('ExpireDate:'..msg.to.id)
if expi == -1 then
	expire_date = 'نامحدود!'
else
	local day = math.floor(expi / 86400) + 1
	expire_date = day..' روز'
end

local settings = data[tostring(target)]["settings"] 
 text = "تنظیمات گروه:\nقفل لینک : "..settings.lock_link.."\nقفل ویرایش پیام : "..settings.lock_edit.."\nقفل استیکر: "..settings.lock_sticker.."\nقفل تگ : "..settings.lock_tag.."\nقفل سرویس تلگرام: "..settings.lock_tgser.."\nقفل فلود: "..settings.flood.."\nقفل اسپم: "..settings.lock_spam.."\nقفل فروارد: "..settings.lock_fwd.."\nقفل فراخوانی : "..settings.lock_mention.."\nقفل عربی : "..settings.lock_arabic.."\nقفل صفحات وب : "..settings.lock_webpage.."\nقفل فونت : "..settings.lock_markdown.."\nپیام خوشآمد گویی : "..settings.welcome.."\nقفل سنجاق کردن : "..settings.lock_pin.."\nمحافظت در برابر ربات ها : "..settings.lock_bots.."\nحداکثر پیام مکرر : "..NUM_MSG_MAX.."\nقفل دستورات: "..settings.lock_cmd.."\nتاریخ انقضا : "..expire_date.."\nکانال تیم: @PartTeam"
 text = string.gsub(text, 'no', 'غیرفعال')
 text = string.gsub(text, 'yes', 'فعال')
 text = string.gsub(text, 'ban', 'حذف')
 text = string.gsub(text, 'warn', 'اخطار')

return text
end
--------Mutes---------
--------Mute all--------------------------
local function mute_all(msg, data, target) 
if not is_mod(msg) then 
return
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
return "بیصدا کردن همه فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن همه فعال شد"..part
end
end

local function unmute_all(msg, data, target) 
if not is_mod(msg) then 
return
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
return "بیصدا کردن همه غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن همه غیر فعال شد"..part
end 
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
 return "بیصدا کردن تصاویر متحرک فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
 return "بیصدا کردن تصاویر متحرک فعال شد"..part
end
end

local function unmute_gif(msg, data, target)
 if not is_mod(msg) then
return
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
return "بیصدا کردن تصاویر متحرک غیر فعال بود"..part
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن تصاویر متحرک غیر فعال شد"..part
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"] 
if mute_game == "yes" then
 return "بیصدا کردن بازی های تحت وب فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_game"] = "yes" 
save_data(_config.moderation.data, data) 
 return "بیصدا کردن بازی های تحت وب فعال شد"..part
end
end

local function unmute_game(msg, data, target)
 if not is_mod(msg) then
return
end 

local mute_game = data[tostring(target)]["mutes"]["mute_game"]
 if mute_game == "no" then
return "بیصدا کردن بازی های تحت وب غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_game"] = "no"
 save_data(_config.moderation.data, data)
return "بیصدا کردن بازی های تحت وب غیر فعال شد"..part
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"] 
if mute_inline == "yes" then
 return "بیصدا کردن کیبورد شیشه ای فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_inline"] = "yes" 
save_data(_config.moderation.data, data) 
 return "بیصدا کردن کیبورد شیشه ای فعال شد"..part
end
end

local function unmute_inline(msg, data, target)
 if not is_mod(msg) then
return
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
 if mute_inline == "no" then
return "بیصدا کردن کیبورد شیشه ای غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_inline"] = "no"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن کیبورد شیشه ای غیر فعال شد"..part
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
 return "بیصدا کردن متن فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
 return "بیصدا کردن متن فعال شد"..part
end
end

local function unmute_text(msg, data, target)
 if not is_mod(msg) then
return
end 

local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
return "بیصدا کردن متن غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن متن غیر فعال شد"
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
 return "بیصدا کردن عکس فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
 return "بیصدا کردن عکس فعال شد"..part
end
end

local function unmute_photo(msg, data, target)
 if not is_mod(msg) then
return
end
 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
return "بیصدا کردن عکس غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن عکس غیر فعال شد"..part
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
 return "بیصدا کردن فیلم فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
 return "بیصدا کردن فیلم فعال شد"..part
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return
end 

local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
return "بیصدا کردن فیلم غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن فیلم غیر فعال شد"..part
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
 return "بیصدا کردن آهنگ فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
return "بیصدا کردن آهنگ فعال شد"..part
end
end

local function unmute_audio(msg, data, target)
 if not is_mod(msg) then
return
end 

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
return "بیصدا کردن آهنک غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
return "بیصدا کردن آهنگ غیر فعال شد"..part 
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
 return "بیصدا کردن صدا فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "بیصدا کردن صدا فعال شد"..part
end
end

local function unmute_voice(msg, data, target)
 if not is_mod(msg) then
return
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
return "بیصدا کردن صدا غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
return "بیصدا کردن صدا غیر فعال شد"..part
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
 return "بیصدا کردن مخاطب فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
 return "بیصدا کردن مخاطب فعال شد"..part
end
end

local function unmute_contact(msg, data, target)
 if not is_mod(msg) then
return
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
return "بیصدا کردن مخاطب غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن مخاطب غیر فعال شد"..part
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
 return "بیصدا کردن موقعیت فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
 return "بیصدا کردن موقعیت فعال شد"..part
end
end

local function unmute_location(msg, data, target)
 if not is_mod(msg) then
return
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
return "بیصدا کردن موقعیت غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن موقعیت غیر فعال شد"..part
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
if not is_mod(msg) then
return
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
 return "بیصدا کردن اسناد فعال لست"..part
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
 return "بیصدا کردن اسناد فعال شد"..part
end
end

local function unmute_document(msg, data, target)
 if not is_mod(msg) then
return
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
return "بیصدا کردن اسناد غیر فعال است"..part
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن اسناد غیر فعال شد"..part
end
end
---------------Mute Keyboard-------------------
local function mute_keyboard(msg, data, target) 
if not is_mod(msg) then
 return
end

local mute_keyboard = data[tostring(target)]["mutes"]["mute_keyboard"] 
if mute_keyboard == "yes" then
 return "بیصدا کردن صفحه کلید فعال است"..part
else
 data[tostring(target)]["mutes"]["mute_keyboard"] = "yes" 
save_data(_config.moderation.data, data) 
return "بیصدا کردن صفحه کلید فعال شد"..part
end
end

local function unmute_keyboard(msg, data, target)
 if not is_mod(msg) then
return
end 

local mute_keyboard = data[tostring(target)]["mutes"]["mute_keyboard"]
 if mute_keyboard == "no" then
return "بیصدا کردن صفحه کلید غیرفعال است"..part
else 
data[tostring(target)]["mutes"]["mute_keyboard"] = "no"
 save_data(_config.moderation.data, data) 
return "بیصدا کردن صفحه کلید غیرفعال شد"..part
end 
end
----------MuteList---------
local function mutes(msg, target) 	
if not is_mod(msg) then
 return
end
local data = load_data(_config.moderation.data)
local target = msg.to.id 
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_all"] then			
data[tostring(target)]["mutes"]["mute_all"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_gif"] then			
data[tostring(target)]["mutes"]["mute_gif"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_text"] then			
data[tostring(target)]["mutes"]["mute_text"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_photo"] then			
data[tostring(target)]["mutes"]["mute_photo"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_video"] then			
data[tostring(target)]["mutes"]["mute_video"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_audio"] then			
data[tostring(target)]["mutes"]["mute_audio"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_voice"] then			
data[tostring(target)]["mutes"]["mute_voice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_contact"] then			
data[tostring(target)]["mutes"]["mute_contact"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_location"] then			
data[tostring(target)]["mutes"]["mute_location"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_document"] then			
data[tostring(target)]["mutes"]["mute_document"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_inline"] then			
data[tostring(target)]["mutes"]["mute_inline"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_game"] then			
data[tostring(target)]["mutes"]["mute_game"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_keyboard"] then			
data[tostring(target)]["mutes"]["mute_keyboard"] = "no"		
end
end
local mutes = data[tostring(target)]["mutes"] 
 text = "لیست بیصدا ها : \n_بیصدا همه : "..mutes.mute_all.."\nبیصدا تصاویر متحرک : "..mutes.mute_gif.."\nبیصدا متن : "..mutes.mute_text.."\nبیصدا کیبورد شیشه ای : "..mutes.mute_inline.."\nبیصدا بازی های تحت وب : "..mutes.mute_game.."\nبیصدا عکس : "..mutes.mute_photo.."\nبیصدا فیلم : "..mutes.mute_video.."\nبیصدا آهنگ : "..mutes.mute_audio.."\nبیصدا صدا : "..mutes.mute_voice.."\nبیصدا مخاطب : "..mutes.mute_contact.."\nبیصدا موقعیت : "..mutes.mute_location.."\nبیصدا اسناد : "..mutes.mute_document.."\nبیصدا صفحه کلید : "..mutes.mute_keyboard.."\nکانال تیم: @PartTeam"
  text = string.gsub(text, 'no', 'غیرفعال')
 text = string.gsub(text, 'yes', 'فعال')
return text
end
local function run(msg, matches)
local data = load_data(_config.moderation.data)
local user_info = {} 
local uhash = 'user:'..msg.from.id
local user = redis:hgetall(uhash)
local um_hash = 'msgs:'..msg.from.id..':'..msg.to.id
user_info_msgs = tonumber(redis:get(um_hash) or 0)
local chat = msg.to.id
local user = msg.from.id
if msg.to.type ~= 'pv' then
if matches[1] == 'ایدی' then
if not matches[2] and not msg.reply_id then
return "شناسه گروه: `"..msg.to.id.."`"..part
end
if msg.reply_id and not matches[2] then
tdcli.getMessage(msg.to.id, msg.reply_id, action_by_reply, {chat_id=msg.to.id,cmd="ids"})
  end
  end
if matches[2] and #matches[2] > 3 and not matches[3] then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="id"})
      end
if matches[1] == "پین" and is_mod(msg) and msg.reply_id then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(chat)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
return "پیام سجاق شد"..part
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(chat)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
return "پیام سجاق شد"..part
end
end
if matches[1] == 'حذف پین' and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
tdcli.unpinChannelMessage(msg.to.id)
return "پیام سنجاق شده پاک شد"..part
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
tdcli.unpinChannelMessage(msg.to.id)
return "پیام سنجاق شده پاک شد"..part
end
end
if matches[1] == "فعال" then
return modadd(msg)
end
if matches[1] == "سیک" then
return modrem(msg)
end
if matches[1] == "صاحب" and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="setowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="setowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="setowner"})
      end
   end
if matches[1] == "تنزل صاحب" and is_admin(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="remowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="remowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="remowner"})
      end
   end
if matches[1] == "ترفیع" and is_owner(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="promote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="promote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="promote"})
      end
   end
if matches[1] == "تنزل" and is_owner(msg) then
if not matches[2] and msg.reply_id then
 tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="demote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="demote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="demote"})
      end
   end
    if matches[1] == 'لفت' and is_admin(msg) then
				tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
	end
if matches[1] == "بن" and is_mod(msg) then
local target = msg.to.id
if matches[2] == "لینک" then
return ban_link(msg, data, target)
end
if matches[2] == "تگ" then
return ban_tag(msg, data, target)
end
if matches[2] == "اشاره" then
return ban_mention(msg, data, target)
end
if matches[2] == "عربی" then
return ban_arabic(msg, data, target)
end
if matches[2] == "استیکر" then
return ban_sticker(msg, data, target)
end
if matches[2] == "نشانه گذاری" then
return ban_markdown(msg, data, target)
end
if matches[2] == "صفحه وب" then
return ban_webpage(msg, data, target)
end
if matches[2] == "فروارد" then
return ban_fwd(msg, data, target)
end
if matches[2] == "دستورات" then
return ban_cmd(msg, data, target)
end
end

if matches[1] == "اخطار" and is_mod(msg) then
local target = msg.to.id
if matches[2] == "لینک" then
return warn_link(msg, data, target)
end
if matches[2] == "تگ" then
return warn_tag(msg, data, target)
end
if matches[2] == "اشاره" then
return warn_mention(msg, data, target)
end
if matches[2] == "عربی" then
return warn_arabic(msg, data, target)
end
if matches[2] == "استیکر" then
return warn_sticker(msg, data, target)
end
if matches[2] == "نشانه گذاری" then
return warn_markdown(msg, data, target)
end
if matches[2] == "صفحه وب" then
return warn_webpage(msg, data, target)
end
if matches[2] == "فروارد" then
return warn_fwd(msg, data, target)
end
if matches[2] == "دستورات" then
return warn_cmd(msg, data, target)
end
end

if matches[1] == "قفل" and is_mod(msg) then
local target = msg.to.id
if matches[2] == "لینک" then
return lock_link(msg, data, target)
end
if matches[2] == "تگ" then
return lock_tag(msg, data, target)
end
if matches[2] == "اشاره" then
return lock_mention(msg, data, target)
end
if matches[2] == "عربی" then
return lock_arabic(msg, data, target)
end
if matches[2] == "ادیت" then
return lock_edit(msg, data, target)
end
if matches[2] == "استیکر" then
return lock_sticker(msg, data, target)
end
if matches[2] == "اسپم" then
return lock_spam(msg, data, target)
end
if matches[2] == "فلود" then
return lock_flood(msg, data, target)
end
if matches[2] == "ربات" then
return lock_bots(msg, data, target)
end
if matches[2] == "نشانه گذاری" then
return lock_markdown(msg, data, target)
end
if matches[2] == "صفحه وب" then
return lock_webpage(msg, data, target)
end
if matches[2] == "سرویس تلگرام" then
return lock_tgser(msg, data, target)
end
if matches[2] == "فروارد" then
return lock_fwd(msg, data, target)
end
if matches[2] == "دستورات" then
return lock_cmd(msg, data, target)
end
if matches[2] == "پین" and is_owner(msg) then
return lock_pin(msg, data, target)
end
end

if matches[1] == "بازکردن" and is_mod(msg) then
local target = msg.to.id
if matches[2] == "لینک" then
return unlock_link(msg, data, target)
end
if matches[2] == "تگ" then
return unlock_tag(msg, data, target)
end
if matches[2] == "اشاره" then
return unlock_mention(msg, data, target)
end
if matches[2] == "عربی" then
return unlock_arabic(msg, data, target)
end
if matches[2] == "ادیت" then
return unlock_edit(msg, data, target)
end
if matches[2] == "استیکر" then
return unlock_sticker(msg, data, target)
end
if matches[2] == "اسپم" then
return unlock_spam(msg, data, target)
end
if matches[2] == "فلود" then
return unlock_flood(msg, data, target)
end
if matches[2] == "ربات" then
return unlock_bots(msg, data, target)
end
if matches[2] == "نشانه گذاری" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "سرویس تلگرام" then
return lock_tgser(msg, data, target)
end
if matches[2] == "فروارد" then
return unlock_fwd(msg, data, target)
end
if matches[2] == "صفحه وب" then
return unlock_webpage(msg, data, target)
end
if matches[2] == "دستورات" then
return unlock_cmd(msg, data, target)
end
if matches[2] == "پین" and is_owner(msg) then
return unlock_pin(msg, data, target)
end
end
if matches[1] == "سکوت" and is_mod(msg) then
local target = msg.to.id
if matches[2] == "همه" then
return mute_all(msg, data, target)
end
if matches[2] == "گیف" then
return mute_gif(msg, data, target)
end
if matches[2] == "متن" then
return mute_text(msg ,data, target)
end
if matches[2] == "عکس" then
return mute_photo(msg ,data, target)
end
if matches[2] == "فیلم" then
return mute_video(msg ,data, target)
end
if matches[2] == "صدا" then
return mute_audio(msg ,data, target)
end
if matches[2] == "ویس" then
return mute_voice(msg ,data, target)
end
if matches[2] == "شماره" then
return mute_contact(msg ,data, target)
end
if matches[2] == "مکان" then
return mute_location(msg ,data, target)
end
if matches[2] == "استیکر" then
return mute_document(msg ,data, target)
end
if matches[2] == "اینلاین" then
return mute_inline(msg ,data, target)
end
if matches[2] == "بازی" then
return mute_game(msg ,data, target)
end
if matches[2] == "کیبورد" then
return mute_keyboard(msg ,data, target)
end
end

if matches[1] == "حذف سکوت" and is_mod(msg) then
local target = msg.to.id
if matches[2] == "همه" then
return unmute_all(msg, data, target)
end
if matches[2] == "گیف" then
return unmute_gif(msg, data, target)
end
if matches[2] == "متن" then
return unmute_text(msg ,data, target)
end
if matches[2] == "عکس" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "فیلم" then
return unmute_video(msg ,data, target)
end
if matches[2] == "صدا" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "ویس" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "شماره" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "مکان" then
return unmute_location(msg ,data, target)
end
if matches[2] == "استیکر" then
return unmute_document(msg ,data, target)
end
if matches[2] == "اینلاین" then
return unmute_inline(msg ,data, target)
end
if matches[2] == "بازی" then
return unmute_game(msg ,data, target)
end
if matches[2] == "کیبورد" then
return unmute_keyboard(msg ,data, target)
end
end
if matches[1] == "اطلاعات گروه" and is_mod(msg) and msg.to.type == "channel" then
local function group_info(arg, data)
ginfo = "*اطلاعات گروه :*\n_تعداد مدیران :_ *"..data.administrator_count_.."*\n_تعداد اعضا :_ *"..data.member_count_.."*\n_تعداد اعضای حذف شده :_ *"..data.kicked_count_.."*\n_شناسه گروه :_ *"..data.channel_.id_.."*"..part
print(serpent.block(data))
        tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
end
 tdcli.getChannelFull(msg.to.id, group_info, {chat_id=msg.to.id,msg_id=msg.id})
end
if matches[1] == 'لینک جدید' and is_mod(msg) then
			local function callback_link (arg, data)
    local administration = load_data(_config.moderation.data) 
				if not data.invite_link_ then
					administration[tostring(msg.to.id)]['settings']['linkgp'] = nil
					save_data(_config.moderation.data, administration)
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "ربات سازنده گروه نیست\nلطفا برای تنظیم لینک گروه خود از دستور[ست لینک] استفاده کنید"..part, 1, 'md')
				else
					administration[tostring(msg.to.id)]['settings']['linkgp'] = data.invite_link_
					save_data(_config.moderation.data, administration)
       return tdcli.sendMessage(msg.to.id, msg.id, 1, "_لینک جدید ساخته شد_", 1, 'md')
				end
			end
 tdcli.exportChatInviteLink(msg.to.id, callback_link, nil)
		end
		if matches[1] == 'ست لینک' and is_owner(msg) then
			data[tostring(chat)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
         return 'لطفا لینک گروه خود را ارسال کنید'..part
		end

		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(chat)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
           return "لینک جدید ذخیره شد"..part
       end
		end
    if matches[1] == 'لینک' and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
        return "برای ساخت لینک جدید از دستور [لینک جدید] وبرای ست کردن لینک گروه خود از دستور [ست لینک] استفاده کنید"..part
      end
      local text = "لینک گروه:\n\n[برای ورود به گروه "..msg.to.title.." کیک کنید]("..linkgp..")"..part
    function viabold(arg,data)
          tdcli_function({
        ID = "SendInlineQueryResultMessage",
        chat_id_ = msg.chat_id_,
        reply_to_message_id_ = msg.id_,
        disable_notification_ = 0,
        from_background_ = 1,
        query_id_ = data.inline_query_id_,
        result_id_ = data.results_[0].id_
      }, dl_cb, nil)
            end
          tdcli_function({
      ID = "GetInlineQueryResults",
      bot_user_id_ = 107705060,
      chat_id_ = msg.chat_id_,
      user_location_ = {
        ID = "Location",
        latitude_ = 0,
        longitude_ = 0
      },
      query_ = text,
      offset_ = 0
    }, viabold, nil)
       end
    if matches[1] == 'لینک پیوی' and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
        return "ابتدا با دستور newlink/ لینک جدیدی برای گروه بسازید\nو اگر ربات سازنده گروه نیس با دستور setlink/ لینک جدیدی برای گروه ثبت کنید"..part
      end
      tdcli.sendMessage(msg.from.id, "", 1, "<b>لینک گروه "..msg.to.title.." :</b>\n"..linkgp..""..part, 1, 'html')
        return
        end
		end
  if matches[1] == "تنظیم قوانین" and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
  return "قوانین گروه ثبت شد"
   end
  if matches[1] == "قوانین" then
 if not data[tostring(chat)]['rules'] then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n"..part
        else
     rules = "قوانین گروه:\n"..data[tostring(chat)]['rules']..""..part
      end
    return rules
  end
    if matches[1] == "اطلاعات" and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="res"})
  end
if matches[1] == "اطلاعات" and matches[2] and is_mod(msg) then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="whois"})
  end
  if matches[1] == 'حساسیت' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 20 then
				return "انتخاب کنید[1-20]لطفا حساسیت گروه از بین"..part
      end
			local flood_max = matches[2]
			data[tostring(chat)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "حساسیت گروه شما به[ "..matches[2].." ]تعییر کرد"..part
       end
		if matches[1]:lower() == 'حذف' and is_owner(msg) then
			if matches[2] == 'مدیران' then
				if next(data[tostring(chat)]['mods']) == nil then
                return "هیچ مدیری برای گروه انتخاب نشده است"..part
				end
				for k,v in pairs(data[tostring(chat)]['mods']) do
					data[tostring(chat)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            return "تمام مدیران گروه تنزیل مقام شدند"..part
			end
			if matches[2] == 'کلمات فلیتر شده' then
				if next(data[tostring(chat)]['filterlist']) == nil then
					return "لیست کلمات فیلتر شده خالی است"..part
             end
				for k,v in pairs(data[tostring(chat)]['filterlist']) do
					data[tostring(chat)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "لیست کلمات فیلتر شده پاک شد"..part
           end
			if matches[2] == 'قوانین' then
				if not data[tostring(chat)]['rules'] then
               return "قوانین برای گروه ثبت نشده است"..part
             end
					data[tostring(chat)]['rules'] = nil
					save_data(_config.moderation.data, data)
            return "قوانین گروه پاک شد"..part
			end
			if matches[2] == 'خوشامد گویی' then
				if not data[tostring(chat)]['setwelcome'] then
               return "پیام خوشآمد گویی ثبت نشده است"..part
             end
					data[tostring(chat)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
            return "پیام خوشآمد گویی پاک شد"..part
			end
			if matches[2] == 'درباره' then
        if msg.to.type == "chat" then
				if not data[tostring(chat)]['about'] then
              return "پیامی مبنی بر درباره گروه ثبت نشده است"..part
				end
					data[tostring(chat)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "channel" then
   tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
              return "پیام مبنی بر درباره گروه پاک شد"..part
		   	end
        end
			if matches[2] == 'مالکان' then
				if next(data[tostring(chat)]['owners']) == nil then
                return "مالکی برای گروه انتخاب نشده است"..part
            end
				for k,v in pairs(data[tostring(chat)]['owners']) do
					data[tostring(chat)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            return "تمامی مالکان گروه تنزیل مقام شدند"..part
			end
			
if matches[1] == "پنل" and is_mod(msg) then
local function inline_query_cb(arg, data)
      if data.results_ and data.results_[0] then
tdcli.sendInlineQueryResultMessage(msg.to.id, 0, 0, 1, data.inline_query_id_, data.results_[0].id_, dl_cb, nil)
    else
    text = "ربات هلپر خاموش است"
  return tdcli.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
   end
end
tdcli.getInlineQueryResults(25000002, msg.to.id, 0, 0, msg.to.id, 0, inline_query_cb, nil)
end

if matches[1] == "تنظیم نام" and matches[2] and is_mod(msg) then
local gp_name = matches[2]
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
  if matches[1] == "تنظیم درباره" and matches[2] and is_mod(msg) then
     if msg.to.type == "channel" then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif msg.to.type == "chat" then
    data[tostring(chat)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
     return "پیام مبنی بر درباره گروه ثبت شد"..part
      end
  if matches[1] == "درباره" and msg.to.type == "chat" then
 if not data[tostring(chat)]['about'] then
      about = "پیامی مبنی بر درباره گروه ثبت نشده است"..part
        else
     about = "*درباره گروه :*\n"..data[tostring(chat)]['about']..""..part
      end
    return about
  end
  if matches[1] == 'فیلتر' and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if matches[1] == 'حذف فیلتر' and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
  if matches[1] == 'لیست فیلتر' and is_mod(msg) then
    return filter_list(msg)
  end
  if matches[1] == 'لایک' then
  local text = matches[2]
          function like(arg,data)
          tdcli_function({
        ID = "SendInlineQueryResultMessage",
        chat_id_ = msg.chat_id_,
        reply_to_message_id_ = msg.id_,
        disable_notification_ = 0,
        from_background_ = 0,
        query_id_ = data.inline_query_id_,
        result_id_ = data.results_[0].id_
      }, dl_cb, nil)
           end
          tdcli_function({
      ID = "GetInlineQueryResults",
      bot_user_id_ = 190601014,
      chat_id_ = msg.chat_id_,
      user_location_ = {
        ID = "Location",
        latitude_ = 0,
        longitude_ = 0
      },
      query_ = text,
      offset_ = 0
    }, like, nil)
       end
if matches[1]:lower() == 'پیکربندی' and is_admin(msg) then
tdcli.getChannelMembers(msg.to.id, 0, 'Administrators', 200, config_cb, {chat_id=msg.to.id})
end
 if matches[1] == "پروفایل" then
 local function dl_photo(arg,data)
 tdcli.sendPhoto(msg.chat_id_, msg.id_,1,3, nil, data.photos_[0].sizes_[1].photo_.persistent_id_,"\nعکس پروفایل شما : "..matches[2].."\nشما میتوانید با دستور [پروفایل(1-"..data.total_count_..")] پروفایلتان را ببینید"..part)
 end
  tdcli_function ({ID = 
"GetUserProfilePhotos",user_id_ = 
msg.sender_user_id_,offset_ = 
matches[2],limit_ = 10}, dl_photo, nil) 
end 
if matches[1] == "تنظیم سودو" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="visudo"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="visudo"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="visudo"})
      end
   end
 if matches[1] == "حذف سودو" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="desudo"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="desudo"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="desudo"})
      end
   end
   if matches[1] == "تنظیم ادمین" and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="adminprom"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="adminprom"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="adminprom"})
      end
   end
if matches[1] == "حذف ادمین" and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.to.id,cmd="admindem"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="admindem"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="admindem"})
      end
   end
   
if matches[1] == 'لیست سودوها' and is_sudo(msg) then
return sudolist(msg)
    end

if matches[1] == 'لیست ادمین ها' and is_admin(msg) then
return adminlist(msg)
    end
	
if matches[1] == "تنظیمات" then
return group_settings(msg, target)
end
if matches[1] == "لیست سکوت" then
return mutes(msg, target)
end
if matches[1] == "لیست مدیران" then
return modlist(msg)
end
if matches[1] == "لیست مالکان" and is_owner(msg) then
return ownerlist(msg)
end

if matches[1] == "راهنما" then
return ":|"
end
---
		if matches[1] == 'لفت' and matches[2] then
				tdcli.sendMessage(matches[2], 0, 1, 'ربات با دستور سودو از گروه خارج شد به یکی از دلایل زیر:\n1- به دلیل استفاده مکرر(اسپم ربات) از دستورات ربات \n2- تمام شدن تاریخ انقضای گروه\n3- ارسال مطالب غیر اسلامی\n برای کسب اطلاعات بیشتر درکانال تیم عضو شوید\n@PartTeam', 1, 'md')
				tdcli.changeChatMemberStatus(matches[2], our_id, 'Left', dl_cb, nil)
				tdcli.sendMessage(SUDO, msg.id_, 1, 'ربات با موفقیت از گروه '..matches[2]..' خارج شد.'..part, 1,'md')
		end
		if matches[1]:lower() == 'انقضا' and is_mod(msg) and not matches[2] then
			local expi = redis:ttl('ExpireDate:'..msg.to.id)
			if expi == -1 then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'گروه به صورت نامحدود شارژ میباشد!'..part, 1, 'md')
			else
				local day = math.floor(expi / 86400) + 1
					tdcli.sendMessage(msg.to.id, msg.id_, 1, day..' روز تا اتما شارژ گروه باقی مانده است.'..part, 1, 'md')
			end
		end
		if matches[1] == 'انقضا' and is_mod(msg) and matches[2] then
		if string.match(matches[2], '^-%d+$') then
			local expi = redis:ttl('ExpireDate:'..matches[2])
			if expi == -1 then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'گروه به صورت نامحدود شارژ میباشد!'..part, 1, 'md')
			else
				local day = math.floor(expi / 86400 ) + 1
					tdcli.sendMessage(msg.to.id, msg.id_, 1, day..' روز تا اتما شارژ گروه باقی مانده است.'..part, 1, 'md')
			end
		end
	end
if matches[1] == 'ساخت گروه' and is_admin(msg) then
local text = matches[2]
tdcli.createNewGroupChat({[0] = msg.from.id}, text, dl_cb, nil)
return 'گروه باموفقیت ساخته شد با نام['..matches[2]..']'..part
end

if matches[1] == 'ساخت سوپرگروه' and is_admin(msg) then
local text = matches[2]
tdcli.createNewChannelChat(text, 1, 'به گروه ['..matches[2]..']\nخوش امدید شما میتوانید با دستور [تنطیم درباره] این متن را تعویض کنید\n@PartTeam', (function(b, d) tdcli.addChatMember(d.id_, msg.from.id, 0, dl_cb, nil) end), nil)
return 'سوپرگروه با موفقیت ساخته شد بانامه ['..matches[2]..']'..part
end

if matches[1] == 'سوپرگروه' and is_admin(msg) then
local id = msg.to.id
tdcli.migrateGroupChatToChannelChat(id, dl_cb, nil)
return 'گروه به سوپر گروه تبدیل شد!'..part
end
	if matches[1] == 'پلن' then
	  if not is_sudo(msg) then
       return
      end
	    if matches[2] == 'نامحدود' then
		local extime = (tonumber(99999) * 86400)
		redis:setex('ExpireDate:'..msg.to.id, extime, true)
		if not redis:get('CheckExpire::'..msg.to.id) then
		redis:set('CheckExpire::'..msg.to.id)
          data[tostring(msg.to.id)]['settings']['date'] = 'نامحدود'
          save_data(_config.moderation.data, data)
        end
        return 'شارژ گروه شما به صورت نامحدود ثبت شد'..part
      end
	end
	if msg.to.type == 'channel' or msg.to.type == 'chat' then
		if matches[1] == 'شارژ' and matches[2] and not matches[3] and is_sudo(msg) then
			if tonumber(matches[2]) > 0 and tonumber(matches[2]) < 9000 then
			    local name = msg.to.title
				local extime = (tonumber(matches[2]) * 86400)
				local linkgp = data[tostring(chat)]['settings']['linkgp']
				redis:setex('ExpireDate:'..msg.to.id, extime, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id)
				end
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'ربات در گروه['..name..']:\nبه مدت ['..matches[2]..'] روز در گروه شما شارژ شد'..part, 1, 'md')
					tdcli.sendMessage(SUDO, 0, 1, 'ربات در گروه ['..name..'] به مدت ['..matches[2]..'] روز تمدید گردید.\nتوسط:['..('@'..msg.from.username or '404')..']\nلینک:['..(linkgp or '404')..']'..part, 1, 'md')
			else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_تعداد روزها باید عددی از 1 تا 1000 باشد._'..part, 1, 'md')
			end
		end
--------------------- Welcome -----------------------
	if matches[1] == "خوشامدگویی" and is_mod(msg) then
		if matches[2] == "فعال" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "yes" then
				return "_خوشآمد گویی از قبل فعال بود_"..part
			else
		data[tostring(chat)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
				return "_خوشآمد گویی فعال شد_"..part
			end
		end
		
		if matches[2] == "خاموش" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "no" then
				return "_خوشآمد گویی از قبل فعال نبود_"..part
			else
		data[tostring(chat)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
				return "_خوشآمد گویی غیرفعال شد_"..part
          end
		end
	end
	if matches[1] == "تنظیم خوشامد گویی" and matches[2] and is_mod(msg) then
		data[tostring(chat)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
		return "_پیام خوشآمد گویی تنظیم شد به :_\n*"..matches[2].."*\n\n*شما میتوانید از*\n_{gpname} نام گروه_\n_{rules} ➣ نمایش قوانین گروه_\n_{name} ➣ نام کاربر جدید_\n_{username} ➣ نام کاربری کاربر جدید_\n_استفاده کنید_"..part
     end
	end
local function expire(msg)
	if msg.to.type ~= 'pv' then
		local hash = "gp_lang:"..msg.to.id
		local lang = redis:get(hash)
		local data = load_data(_config.moderation.data)
		local gpst = data[tostring(msg.to.id)]
		local chex = redis:get('CheckExpire::'..msg.to.id)
		local exd = redis:get('ExpireDate:'..msg.to.id)
		if gpst and not chex and msg.from.id ~= SUDO and not is_sudo(msg) then
			redis:set('CheckExpire::'..msg.to.id,true)
			redis:set('ExpireDate:'..msg.to.id,true)
			redis:setex('ExpireDate:'..msg.to.id, 86400, true)
				tdcli.sendMessage(msg.to.id, msg.id_, 1, '_گروه به مدت 1 روز شارژ شد. لطفا با سودو برای شارژ بیشتر تماس بگیرید. در غیر اینصورت گروه شما از لیست ربات حذف و ربات گروه را ترک خواهد کرد._'..part, 1, 'md')
		end
		if chex and not exd and msg.from.id ~= SUDO and not is_sudo(msg) then
			local text1 = 'شارژ این گروه به اتمام رسید \n\nID:  <code>'..msg.to.id..'</code>\n\nدر صورتی که میخواهید ربات این گروه را ترک کند از دستور زیر استفاده کنید\n\n/leave '..msg.to.id..'\nبرای جوین دادن توی این گروه میتونی از دستور زیر استفاده کنی:\n/jointo '..msg.to.id..'\n_________________\nدر صورتی که میخواهید گروه رو دوباره شارژ کنید میتوانید از کد های زیر استفاده کنید...\n\n<b>برای شارژ 1 ماهه:</b>\n/plan 1 '..msg.to.id..'\n\n<b>برای شارژ 3 ماهه:</b>\n/plan 2 '..msg.to.id..'\n\n<b>برای شارژ نامحدود:</b>\n/plan 3 '..msg.to.id..''..part
			local text2 = '_شارژ این گروه به پایان رسید. به دلیل عدم شارژ مجدد، گروه از لیست ربات حذف و ربات از گروه خارج میشود._'..part
				tdcli.sendMessage(SUDO, 0, 1, text3, 1, 'md')
				tdcli.sendMessage(msg.to.id, 0, 1, text4, 1, 'md')
			botrem(msg)
		else
			local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
			local day = (expiretime / 86400)
			if tonumber(day) > 0.208 and not is_sudo(msg) and is_mod(msg) then
				warning(msg)
			end
		end
	end
	return msg
end
-----------------------------------------
local function pre_process(msg)
	if msg.to.type ~= 'pv' then
   local chat = msg.to.id
   local user = msg.from.id
 local data = load_data(_config.moderation.data)
	local function welcome_cb(arg, data)
		administration = load_data(_config.moderation.data)
    if administration[arg.chat_id]['setwelcome'] then
     welcome = administration[arg.chat_id]['setwelcome']
      else
     welcome = "_خوش آمدید_"
        end
 if administration[tostring(arg.chat_id)]['rules'] then
rules = administration[arg.chat_id]['rules']
else
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n"..part
end
if data.username_ then
user_name = "@"..check_markdown(data.username_)
else
user_name = ""
end
		local welcome = welcome:gsub("{rules}", rules)
		local welcome = welcome:gsub("{name}", check_markdown(data.first_name_))
		local welcome = welcome:gsub("{username}", user_name)
		local welcome = welcome:gsub("{gpname}", arg.gp_name)
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, welcome, 0, "md")
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
	if msg.adduser then
		welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.adduser
    	}, welcome_cb, {chat_id=chat,msg_id=msg.id,gp_name=msg.to.title})
		else
			return false
		end
	end
	if msg.joinuser then
		welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.joinuser
    	}, welcome_cb, {chat_id=chat,msg_id=msg.id,gp_name=msg.to.title})
		else
			return false
        end
		end
	end
	-- return msg
 end
end
return {
patterns ={
"^(ایدی)$",
"^(ایدی) (.*)$",
"^(بن) (.*)$",
"^(اخطار) (.*)$",
"^(پین)$",
"^(پنل)$",
"^(تنظیم سودو)$",
"^(حذف سودو)$",
"^(تنظیم ادمین)$",
"^(حذف ادمین)$",
"^(لیست سودوها)$",
"^(لیست ادمین ها)$",
"^(پروفایل) (.*)$",
"^(پیکربندی)$",
"^(حذف پین)$",
"^(اطلاعات گروه)$",
"^(فعال)$",
"^(سیک)$",
"^(لفت)$",
"^(صاحب)$",
"^(صاحب) (.*)$",
"^(تنزل صاحب)$",
"^(تنزل صاحب) (.*)$",
"^(ترفیع)$",
"^(ترفیع) (.*)$",
"^(تنزل)$",
"^(تنزل) (.*)$",
"^(لیست مدیران)$",
"^(لیست مالکان)$",
"^(قفل) (.*)$",
"^(بازکردن) (.*)$",
"^(تنظیمات)$",
"^(لیست سکوت)$",
"^(سکوت) (.*)$",
"^(حذف سکوت) (.*)$",
"^(لینک)$",
"^(لینک پیوی)$",
"^(ست لینک)$",
"^(لینک جدید)$",
"^(قوانین)$",
"^(تنظیم قوانین) (.*)$",
"^(ساخت گروه) (.*)$",
"^(ساخت سوپرگروه) (.*)$",
"^(سوپرگروه)$",
"^(درباره)$",
"^(تنظیم درباره) (.*)$",
"^(تنظیم نام) (.*)$",
"^(حذف) (.*)$",
"^(حساسیت) (%d+)$",
"^(اطلاعات) (.*)$",
"^(راهنما)$",
"^(لایک) (.*)$",
"^(فیلتر) (.*)$",
"^(حذف فیلتر) (.*)$",
"^(لیست فیلتر)$",
"^(انقضا)$",
"^(انقضا) (.*)$",
"^(شارژ) (%d+)$",
"^(لفت) (.*)$",
"^(پلن) (.*)$",
"^([https?://w]*.?t.me/joinchat/%S+)$",
"^([https?://w]*.?telegram.me/joinchat/%S+)$",
"^(تنظیم خوشامد گویی) (.*)",
"^(خوشامدگویی) (.*)$"
},
run=run,
pre_process = pre_process,
expire = expire
}
--BY: @So8eil
