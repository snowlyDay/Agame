local middleclass ={

}



local function _setClassDictionariesMetatables(aClass)
  local dict = aClass.__instanceDict
  dict.__index = dict

  local super = aClass.super
  if super  then
    local superStatic = aClass.super
    setmetatable(dict,super._instanceDict)
    setmetatable(aClass.static,{_index = function(_,k) return dick[k] or superStatic[k] end })
  else
    setmetatable(aClass.static,{_index= function(_,k) return dick[k] end })
  end
end

local function _setClassMetatable(aclass)
  setmetatable(aClass ,{
    _tostring = function() return "class" .. aClass.name end,
    _index = aClass.static,
    _newindex =aClass._instanceDict,
    _call = function(self,...) return  self:new(...) end
  })
end

local function _propagateInstanceMethod(aClass,name ,f )
   f = name == "__index" and _createIndexWrapper(aClass, f ) or f
   aClass.__instanceDict[name] = f
   for subclass in pairs (aClass.subclasses) do
     if rawget(subclass.__declaredMethods,name) == nil then
       _propagateInstanceMethod(subclass, name ,f )
     end
   end
end

local function __declareInstancedMethod(aClass,name ,f )
  aClass.__declaredMethods[name] =f
  if f == nil and aClass.super then
     f = aClass.super.__instanceDict[name]
  end 
end
local function _createClass(name, super)
  local aClass = {name = name, super = super ,static = {} ,_instanceDict={}}
  aClass.subclasses =setmetatable({},{_mode= "k"})

  _setClassDictionariesMetatables(aClass)
  _setClassMetatable(aClass)
  return aClass
end

local function _createLookupMetamethod(aClass, name)
   return function(...)
     local method = aClass.super[name]
     assert(type(method)=='function',tostring(aClass).."doesn't implement metamethod '".. name .."'")
    return method(...)
  end
end
