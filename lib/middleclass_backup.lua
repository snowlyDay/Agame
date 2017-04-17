local middleclass ={

}

local function _createIndexWrapper(aClass , f)
 if f ==nil then
   return aClass.__instanceDict
 else
   return function(self,name)
     local value = aClass.__instanceDict[name]
     if value ~= nil then
       return value
    elseif type(f)=="function" then
      return (f(self,name))
    else
      return f[name]
    end
  end
end
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
  _propagateInstanceMethod(aClass,name,f)
end

local function _tostring(self) return "class"..self.name end
local function _call(self,...) return  self:name(...) end

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

local function _createClass(name, super)
  local dict ={}
  dict.__index = dict

  local aClass = {name = name, super = super ,static = {} ,__instanceDict=dict ,__declaredMethods={},
                   subclasses =setmetatable({},{_mode= "k"}) }

if super then
  setmetatable(aClass.static,{__index =function(_,k) return rawget(dict,k) or super.static[k] end })
else
  setmetatable(aClass.static,{__index = function(_,k) return rawget(dict, k ) end })
end
  setmetatable(aClass.static,{__index = aClass.staic ,__tostring= _tostring,
                            __call= _call ,__newindex=__declareInstancedMethod})
  return aClass
end

function middleclass.class(name, super ,...)
  super = super or Object
  return super:subclass(name,...)
end

middleclass.Object = Object
setmetatable(middleclass,{__call = function  (_,...) return middleclass.class(...) end })



local function _includeMixin(aClass , mixin)
  assert(type(mixin) =='table' ,"mixin must be a table")
  for name ,method in pairs(mixin) do
    if name ~="include" and name ~="static" then aClass[name] = method end
  end
  for name ,method in pairs(mixin.static or {}) do
    aClass.static[name] = method
  end
  if type(mixin.include) =="function" then mixin:included(aClass) end
  return aClass
end

local function _createLookupMetamethod(aClass, name)
   return function(...)
     local method = aClass.super[name]
     assert(type(method)=='function',tostring(aClass).."doesn't implement metamethod '".. name .."'")
    return method(...)
  end
end

return middleclass
