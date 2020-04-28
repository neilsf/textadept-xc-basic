-- XC=BASIC LPeg lexer.

local lexer = require('lexer')
local token, word_match = lexer.token, lexer.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local lex = lexer.new('xcbasic', {case_insensitive_fold_points = true})

-- Whitespace.
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match([[
    const let print if then endif goto  input  gosub  return  call
    end  poke  for  to  next  dim  data  charat  textat
    incbin  inc  dec  proc  endproc  sys  usr  and  origin
    or  load  save  doke atn  asm  strcpy  strncpy  curpos
    strpos  wait  watch  pragma  memset  memcpy  memshift
    while  endwhile  repeat  until  disableirq  enableirq  fun endfun step
    fast include else on
]], true)))

-- Functions.
lex:add_rule('function', token(lexer.FUNCTION, word_match([[
    peek! peek peek# inkey! inkey inkey# rnd rnd! rnd# rnd% usr usr! usr# usr%
    ferr! ferr ferr# doke doke# doke! abs abs# abs% cast cast! cast# cast%
    sin% cos% tan% atn% strlen! strcmp strcmp# curpos strpos!
    val! val val# val% sqr sqr# sqr% sgn sgn# lshift! lshift lshift#
    rshift! rshift rshift#
]], true)))

-- Folding
local function rtrim(s)
  local n = #s
  while n > 0 and s:find("^%s", n) do n = n - 1 end
  return s:sub(1, n)
end

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

local function fold_if(text, pos, line, s, symbol)
  line = rtrim(line)
  if ends_with(line, "then") or ends_with(line, "THEN") then
    return 1
  end
  
  return 0
end

local function fold_endif(text, pos, line, s, symbol)
  return -1
end

lex:add_fold_point(lexer.KEYWORD, 'then', fold_if)
lex:add_fold_point(lexer.KEYWORD, 'endif', fold_endif)
lex:add_fold_point(lexer.KEYWORD, 'proc', 'endproc')
lex:add_fold_point(lexer.KEYWORD, 'fun', 'endfun')
lex:add_fold_point(lexer.KEYWORD, 'repeat', 'until')
lex:add_fold_point(lexer.KEYWORD, 'while', 'endwhile')
lex:add_fold_point(lexer.KEYWORD, 'for', 'next')

-- Strings.
lex:add_rule('string', token(lexer.STRING,
                             lexer.delimited_range("\"", true, true)))

                                                           
lex:add_rule('comment', token(lexer.COMMENT,
                              (S("';") + word_match([[rem]], true)) *
                              lexer.nonnewline^0))
                             
-- Labels.
lex:add_rule('label', token(lexer.LABEL, lexer.word * P(":")))

-- Numbers.
local hex_num = '$' * (lexer.xdigit)^1
local bin_num = '%' * (lpeg.S("01"))^1
lex:add_rule('number', token(lexer.NUMBER, (lexer.float + lexer.integer + hex_num + bin_num)))

-- Operators.
lex:add_rule('operator', token(lexer.OPERATOR, S(',@=<>+-/*()[]~|&')))


-- Variables.
lex:add_rule('variable', token(lexer.VARIABLE, S("\\")^0 * lexer.word * S("!#%")^0))

return lex
