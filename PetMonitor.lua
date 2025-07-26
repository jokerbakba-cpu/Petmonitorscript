local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function base64decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c=0
        for i=1,8 do c=c + (x:sub(i,i)=='1' and 2^(8 - i) or 0) end
        return string.char(c)
    end))
end

local code = [[
LS0gRXNzZSBjb2RpZ28gY3JpYXRhIG8gUmVtb3RlRXZlbnQsIHRlbidzIHNpc3RlbWEgaW4g
cm9ibG94IGVtIGx1YSBjb21wbGV0YSwgY29tcG9uZW50ZSBjbGllbnRlLgoKbG9jYWwgUmVw
bGljYXRlZFN0b3JhZ2UgPSBnaW1lOkdldFNlcnZpY2UoIlJlcGxpY2F0ZWRTdG9yYWdlIikK
bG9jYWwgUGxheWVycyA9IGd... (muito longo, corta aqui para exemplo)
]]

loadstring(base64decode(code))()
