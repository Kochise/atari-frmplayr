# frmplayr

Atari Falcon030 program to play direct-to-disk movies

![frmplayr](https://raw.githubusercontent.com/Kochise/frmplayr/master/FRM00001.png)

* Hardware and software needed

You need the following to get this program working :

\- Atari Falcon030 (original or upgraded)<br>

* List of programs

\- FRMPLAY1.PRG : play FRM files in 384x288 pixels<br>
\- \\FRMUTILS : various programes to merge TGA files into FRM file<br>

* How to use it

First set the 384x288 pixels in 64K colors format (using Videl Inside 2 for instance), then drag a FRM file on the 'FRMPLAY1.PRG' program.

"Commands are :"<br>
"[Esc]     == Escape (return to DeskTop)"<br>
"[Space]   == Pause/Unpause"<br>
"[ClrHome] == Restart the movie"<br>
"[<-]      == Previous Frame"<br>
"[->]      == Next     Frame"<br>
"[UpArrow] == Jump backward 10 Images"<br>
"[DwArrow] == Jump forward  10 Images"<br>
"[S]       == Save Current SCREEN Into Targa Format"<br>
"WARNING : TOS is very slow in Negative File Offset. So when you're far in the Movie,"<br>
"          when you ask watching the previous Image, it could take at least 1 second..."<br>

"More Commands are :"<br>
"[F1]      == No Filter"<br>
"[F2]      == Y Filter (Luminance)"<br>
"[F3]      == U Filter (Chrominance)"<br>
"[F4]      == V Filter (Saturation)"<br>
"[F5]      == R Filter (Red)            \"<br>
"[F6]      == G Filter (Green)           > Additive     Chroma Synthesis"<br>
"[F7]      == B Filter (Blue)           /"<br>
"[F8]      == C Filter (Cyan Filter)    \"<br>
"[F9]      == J Filter (Yellow Filter)   > Substractive Chroma Synthesis"<br>
"[F10]     == M Filter (Magenta Filter) /"<br>

"Toggle BlackPaper/WhiterPaper by selecting twice any RGBCJM Filter"<br>

"Sequence Control Commands are :"<br>
"0 NumPad  == Toggle Sequence ON/OFF"<br>
". NumPad  == Save Sequence File"<br>
"1 NumPad  == Start SEQ 1"<br>
"2 NumPad  == End   SEQ 1"<br>
"3 NumPad  == Start SEQ 2"<br>
"4 NumPad  == End   SEQ 2"<br>
"5 NumPad  == Start SEQ 3"<br>
"6 NumPad  == End   SEQ 3"<br>
"7 NumPad  == Start SEQ 4"<br>
"8 NumPad  == End   SEQ 4"<br>
"* NumPad  == Kill All Sequences"<br>

"When SEQ toggled ON, then jump from Start to End"<br>
"Set any Start SEQ or End   SEQ by holding down [Control] with a Number between 1'n 8"<br>

"Last Commands are :"<br>
"( NumPad  == Software Displayer"<br>
") NumPad  == HardWare Displayer"<br>
"- NumPad  == Reduce   Display Quality"<br>
"+ NumPad  == Increase Display Quality"<br>

* Some infos

Some old software developped for my school. The files 'SCAPEFLY.FRM' and 'ARTE.FRM' were done using NeoN Grafix.
