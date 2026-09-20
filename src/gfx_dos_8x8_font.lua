local glyphs = string.gsub([[
 !"#$%&'()*+,-./
0123456789:;<=>?
@ABCDEFGHIJKLMNO
PQRSTUVWXYZ[\]^_
`abcdefghijklmno
pqrstuvwxyz{|}~
]], '\n', '')

return love.graphics.newImageFont('share/congusbongus_dos_8x8_font.png', glyphs, 0)
