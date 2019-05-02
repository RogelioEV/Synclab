rng = (neg, max)=>
    v = Math.floor(Math.random()*Math.floor(max))
    if neg
      n = Math.floor(Math.random()*Math.floor(1))
      if n != 1
        v*=-1
    v
rndClr = ()=>
  color = "0x"
  for i in [1..3] by 1
    c = rng(false, 255)
    n = Math.round(c/16 - .5)
    if n>9
      color += checkDigit(n)      
    else
      color += n
    n = c%16
    if n>9
      color += checkDigit(n)
    else
      color += n
  color
decToHex=(num)=>
  arr = []
  while num >= 16
    mod = num % 16
    num = (num - mod)/16
    arr.push checkDigit mod
  arr.push checkDigit num
  str = '0x'
  for i in [1..arr.length] by 1
    str += arr[arr.length - i]
  str
hexToRgb = (color)=>
  r = color.substring(2,4)
  g = color.substring(4,6)
  b = color.substring(6,8)
  arr = [
    checkDigit(r.substring(0, 1))* 16 + parseInt(checkDigit(r.substring(1,2))),
    checkDigit(g.substring(0, 1))* 16 + parseInt(checkDigit(g.substring(1,2))),
    checkDigit(b.substring(0, 1))* 16 + parseInt(checkDigit(b.substring(1,2))),
  ]
  return arr
rgbToHex = (color)=>
  str = '0x'
  r = '' + checkDigit(Math.floor((color[0] - color[0]%16)/16)) + checkDigit(Math.floor(color[0]%16))
  g = '' + checkDigit(Math.floor((color[1] - color[1]%16)/16)) + checkDigit(Math.floor(color[1]%16))
  b = '' + checkDigit(Math.floor((color[2] - color[2]%16)/16)) + checkDigit(Math.floor(color[2]%16))
  str += r + g + b
checkDigit = (digit) =>
  switch digit
    when 10
      digit = 'a'
      break
    when 11
      digit = 'b'
      break
    when 12
      digit = 'c'
      break
    when 13
      digit = 'd'
      break
    when 14
      digit = 'e'
      break
    when 15
      digit = 'f'
      break
    when 'a'
      digit = 10
      break
    when 'b'
      digit = 11
      break
    when 'c'
      digit = 12
      break
    when 'd'
      digit = 13
      break
    when 'e'
      digit = 14
      break
    when 'f'
      digit = 15
      break
    when 'A'
      digit = 10
      break
    when 'B'
      digit = 11
      break
    when 'C'
      digit = 12
      break
    when 'D'
      digit = 13
      break
    when 'E'
      digit = 14
      break
    when 'F'
      digit = 15
      break
  digit
module.exports = {rndClr, rng, decToHex, hexToRgb, rgbToHex}