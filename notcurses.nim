#notcurses2
import terminal, strutils

type
  Box= object
    x,y,w,h: int
  Entity= object of RootObj
    x,y: int
  Window= ref object of Entity
    w,h: int
    dat: seq[string]

template `[]`(win: Window; i: int): untyped= win.dat[i]
template `[]=`(win: Window; i: int; v: untyped): untyped= win.dat[i]=v

func newWindow(x,y,w,h: int; fill: char= ' '): Window=
  new result
  result.x= x
  result.y= y
  result.w= w
  result.h= h
  result.dat = newSeqOfCap[string](h)
  for i in 0..<y:
    result[i]= repeat(fill, w)

iterator xy(win: Window): (int, int)=
  for y in 0..<win.h:
    for x in 0..<win.w:
      yield (x,y)

var root: Window
proc beginNotCurses()=
  eraseScreen()
  setCursorPos(0,0)
  writestyled(" ")
  root= newWindow(0,0, terminalWidth(), terminalHeight())

proc clear(win: Window; with: char= '\0')=
  for y in 0..<win.h:
    win[y]= repeat(with, win.w)

func minmax(x,y: int): (int, int)=
  if x < y: (x, y) else: (y, x)

func collide(src, dst: Window): bool=
  ((src.x - dst.x)*2 < src.w + dst.w) and
  ((src.y - dst.y)*2 < src.h + dst.h)
proc paste(src, dst: Window)=
  if collide(src, dst):
    
