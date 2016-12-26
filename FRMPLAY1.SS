; /// FRAME PLAYER V1.48 - KOSS 1999 ///
; Based on the original idea of Tord Jansson's SHOWER...
; Comments are in the source you're just reading
; This little piece of code is ARTE-Ware : To fell yourself free of charge, just
;                                          support ARTE by watching them...
;
; E-Mail KOSS : Kochise@CaraMail.Com
; E-Mail ARTE : Communication@ARTE-TV.Com
;
; Set TAB to 24 (great on 768*576 ;) )

; This Software ISN'T optimized for a better comprehension. It's first plot is
; not to be FAST, but GREAT !

; HardWare needed : ATARI Falcon030 (MCU68030+FPU68882)
;                   VIDEL Video Processor

; TEST.FRM     :  25 Frames, just a 1-to-25-Counter...
; ARTE.FRM     :  50 Frames, for Color Filter Testing...
; SCAPEFLY.FRM : 250 Frames, for NeoN (Stereo Patched) Testing... 

; Commands are :
; [Esc]     == Escape (return to DeskTop)
; [Space]   == Pause/Unpause
; [ClrHome] == Restart the movie
; [<-]      == Previous Frame
; [->]      == Next     Frame
; [UpArrow] == Jump backward 10 Images
; [DwArrow] == Jump forward  10 Images
; [S]       == Save Current SCREEN Into Targa Format
; WARNING : TOS is very slow in Negative File Offset. So when you're far in the Movie,
;           when you ask watching the previous Image, it could take at least 1 second...

; More Commands are :
; [F1]      == No Filter
; [F2]      == Y Filter (Luminance)
; [F3]      == U Filter (Chrominance)
; [F4]      == V Filter (Saturation)
; [F5]      == R Filter (Red)            \
; [F6]      == G Filter (Green)           > Additive     Chroma Synthesis
; [F7]      == B Filter (Blue)           /
; [F8]      == C Filter (Cyan Filter)    \
; [F9]      == J Filter (Yellow Filter)   > Substractive Chroma Synthesis
; [F10]     == M Filter (Magenta Filter) /
;
; Toggle BlackPaper/WhiterPaper by selecting twice any RGBCJM Filter

; Sequence Control Commands are :
; 0 NumPad  == Toggle Sequence ON/OFF
; . NumPad  == Save Sequence File
; 1 NumPad  == Start SEQ 1
; 2 NumPad  == End   SEQ 1
; 3 NumPad  == Start SEQ 2
; 4 NumPad  == End   SEQ 2
; 5 NumPad  == Start SEQ 3
; 6 NumPad  == End   SEQ 3
; 7 NumPad  == Start SEQ 4
; 8 NumPad  == End   SEQ 4
; * NumPad  == Kill All Sequences
;
; When SEQ toggled ON, then jump from Start to End
; Set any Start SEQ or End   SEQ by holding down [Control] with a Number between 1'n 8

; Last Commands are :
; ( NumPad  == Software Displayer
; ) NumPad  == HardWare Displayer
; - NumPad  == Reduce   Display Quality
; + NumPad  == Increase Display Quality
;
; SoftDisp       | HardDisp       | ScreenSize | Soft FPS@16MHz RGB/VGA (RGB%VGA) | Hard FPS@16MHz RGB/VGA (RGB%VGA) | [Hard%Soft] RGB/[Hard%Soft] VGA
; ---------------+----------------+------------+------------------------------------------------------------------------------------------------------
; MiniD2D_CPU    | MiniD2D_BLITTER| 176*120    | 25.9/23.8 ( 8.2%)                | 27.4/25.3 ( 8.2%)                | [ 0.0%]        / [ 0.0%]
; ---------------+----------------+------------+------------------------------------------------------------------------------------------------------
; WindowCPU      | WindowBLITTER  | 352*240    | 24.4/14.9 (38.0%)                | 24.7/14.8 (40.1%)                | [ 1.2%]        / [-0.7%]
; ---------------+----------------+------------+------------------------------------------------------------------------------------------------------
; ZoomCPU        | ZoomBLITTER    | 352*240    | 10.9/ 6.9 (36.5%)                | 11.1/ 6.5 (41.0%)                | [ 1.6%]        / [-5.8%]
; ---------------+----------------+------------+------------------------------------------------------------------------------------------------------
; Interpolate000 | Interpolate030 | 352*240    |  1.3/ 1.0 (22.1%)                |  1.9/ 1.8 ( 7.4%)                | [34.2%]        / [44.6%]
;
; E.g. : (16.2%) gives RGB 16.2% faster than VGA, [ 5.5%] gives Hard 5.5% faster than Soft

; - First, it's easy to see that RGB is really faster than VGA (caused by the ScanFrame)
; - We can also see that in RGB HardVersion are faster than SoftVersion face to VGA where HardVersion
;   are slower (1.2%/RGB instead of -0.7%/VGA for Window, 1.6%/RGB instead of -5.8%/VGA for Zoom)
; - For Interpolate, the difference between HardVersion and SoftVersion is higher in VGA than
;   in RGB (44.6%/VGA instead of "only" 34.2%/RGB)
;
; So, we can say that | in RGB, Hardware is a little bit faster (BLITTER)
;                     | in VGA, Software is a little bit faster (CPU)
;                     | RGB is REALLY faster than in VGA (about 39%=[38.0+40.1+36.5+41.0]/4),
;                         that mean for 50Hz in RGB, you've ONLY 36Hz in VGA
; WARNING : Nothing to sean with the VSync Rate (about 50Hz in RGB, and 70Hz in VGA)
;           It mean that in VGA, the HardWare RAM Access (CPU, BLITTER, ...) is slowed by too many 
;             Video RAM Access (70Hz in VGA, instead of ONLY 50Hz in RGB, that is to say
;             that in VGA, the Screen Refresh Rate - VSync - is about 40% more than in RGB !!!)
;           Now you know why RGB is 39% faster than VGA (40% if you want) !
;
; NOTE    : WindowCPU is the default choice (at start...)
;
; P.S.    : Go see what I say about the HardWare (incredible) Speed face to
;           the Software in ZOOM_BLITTER (BLITTER is given 63.8% faster than CPU !!!)
;           THIS IS NOT A TRICK, IT'S REAL (the BLITTER have to do very much work
;           than the CPU to Zoom an Image. 'Same' Speed, much work, give it the
;           advantage of the PoweR)
; >>>>>>>>> BliTTeR STILL Mr Universe of the ATARI Falcon030 for Bit-Block Moves...

; Quick OverView on the Program
;
; *** SECTION TEXT ***
; --- Mise en Place du Programme ---
; --- Initialisation du Programme ---
; --- Routine Principale ---
; ResetLoop		Start of the Movie
; ReadLoop		Read an Image
; DisplayLoop		Filter Test
; ViewFilter		Apply Filter
; ViewLoopNext		Display Image
; ScanKeys		Look if a Key was pressed
; ReadKeys		Read last Key pressed
; NextFrame		Pause Test
; Next		Read Next Frame
; --- Sortie du Programme ---
; ScreenExit		Restore GEM Screens
; Exit		Close Movie and Free Mouse
; P_Term		Return to DeskTop
; --- La gestion des Touches ---
; SaveTarga		Save Current Screen in Targa Format
; SetFilter		Set Filter
; Pause		Pause/Unpause
; TenBefore		Fast Backward of 10 Images
; Smaller		Decrease Display Quality
; Previous		Look for the Previous Frame
; Taller		Increase Display Quality
; TenAfter		Fast Forward of 10 Images
; FirstFrame		If Current Frame was the First of the Movie
; LastFrame		If current Frame was one of the Movie
; ErrorFrame		If Error
; SoftVersion		Set Software Display Rout
; HardVersion		Set Hardware Display Rout
; --- Les Filtres ---
; Y_FILTER
; U_FILTER
; V_FILTER
; RED_FILTER
; GREEN_FILTER
; BLUE_FILTER
; CYAN_FILTER
; YELLOW_FILTER
; MAGENTA_FILTER
; --- Les Routines d'Affichage ---
; Clear_Screen
; MINID2D_CPU
; MINID2D_BLITTER
; WINDOW_CPU
; WINDOW_BLITTER
; ZOOM_CPU
; ZOOM_BLITTER
; INTER_000
; INTER_030
; --- Le Driver Videl ---
; VidelDriver
; *** SECTION DATA ***
; -> PointersBank
; *** SECTION BSS ***
; -> Registers

	OPT	p=68030/68882	; ...
	
	comment	HEAD=7	; FastLoad in TTRam
	
; *****************************************************************************	
	SECTION	TEXT
; *****************************************************************************	

; --- Mise en Place du Programme ---

	move.l	(4,SP),A6	; Adresse de la BASEPAGE
	lea	(128,A6),A6	; Adresse de la COMMAND-TAIL
	lea	MovieName,A5
	move.b	(A6)+,D6	; Taille de la COMMAND-TAIL (ATTENTION : Format PASCAL)
	
	BEQ	P_Term	; Pas de COMMAND-TAIL, on n'a plus rien … faire

	; Pour Info, lors d'un Drag'n Drop, vous avez :
	; - Dans la CommandLine  : Le Nom du Fichier
	; - En Chemin par d‚faut : Le Chemin du Fichier
	; Il sagit donc de reconstruire le Chemin complet
	; dans un Buffer
	; For Info, during a Drag'n Drop, you have :
	; - Into the CommandLine : the File's Name
	; - As DefaultPath       : the File's Path
	; Then you must build the complete Path into a Buffer
	;
	; For D:\LIB'ZONE.III\FRMPLAYR\ARTE.FRM, you've :
	; CommandLine : 8,"ARTE.FRM"
	; DefaultUnit : 3 (D)
	; DefaultPath : "\LIB'ZONE.III\FRMPLAYR"

	; On cr‚er le Chemin du Fichier
	; Creating File's Path
	
	move.w	#$19,-(SP)	; - D_GETDRV -
 	trap	#1	; *** GEMDOS ***
 	addq.l	#2,SP

	; BigDos v0.8 Compatibity (c) KOSS 1999
	;  0..25 : A..Z
	; 26..31 : 1..6
 	
 	cmpi.w	#26,D0
 	BGE	BigDos_Compatibility
 	
 	add.w	#65,D0	; A..Z
 	
 	BRA	Drive_Name
 	
BigDos_Compatibility	add.w	#48-26,D0	; 1..6
 	
Drive_Name 	move.b	D0,(A5)+
 	move.b	#":",(A5)+
 	
 	clr.w	-(SP)
 	move.l	A5,-(SP)
 	move.w	#$47,-(SP)	; - D_GETPATH -
 	trap	#1	; *** GEMDOS ***
 	addq.l	#8,SP

	; On cherche la fin du Chemin
	; Looking for the End of the Path

Look_EndPath	move.b	(A5)+,D0
	BNE	Look_EndPath

	move.b	#"\",(-1,A5)

	subq.w	#1,D6

	; On copie le Nom du Fichier
	; Copying File's Name

Copy_FRM_Name	move.b	(A6)+,(A5)+	; Copie de la COMMAND-TAIL
	
	DBF	D6,Copy_FRM_Name
	
	clr.b	(A5)	; Mets un OCTET nul … la fin de la chaine (ATTENTION : Transformation au format C)
	move.l	-(A5),D0	; Les derniŠres lettres (.FRM en principe)
	cmpi.l	#".FRM",D0	; On v‚rifie … tout hasard
	BEQ	ProgStart
	cmpi.l	#".FSF",D0
	BEQ	ProgStart
	
	BRA	P_Term	; A la prochaine...

	; Initialisation de la M‚moire
	; Memory Init

ProgStart	movea.l	(4,SP),A6	; Adresse de la BASEPAGE
	move.l	($C,A6),D0	; Taille du SEGMENT TEXT
	add.l	($14,A6),D0	; Additionne la taille du SEGMENT DATA … D0
	add.l	($1C,A6),D0	; Additionne la taille du SEGMENT BSS … D0
	addi.l	#$100,D0	; Additionne la taille de la BASEPAGE … D0
	addi.l	#$400,D0	; Additionne la taille de la future PILE (Ici, 256 positions longues (1024 OCTETS))
	move.l	D0,D1	; Copie D0 dans D1 (Taille … r‚server)
	move.l	D0,D7	; Pour un hypoth‚tique P_TERMRES
	add.l	A6,D1	; Additionne l'adresse du d‚but du programme avec D1 (La taille … r‚server)
	andi.l	#-2,D1	; Rend D1 pair (Au cas o— il ne l'‚tait pas)
	subq.l	#8,D1	; Garde de la place pour l'adresse de la BASEPAGE
	move.l	(4,SP),D2	; Sauvegarde l'adresse de la BASEPAGE
	movea.l	D1,SP	; Installe l'adresse de fin du programme+place nouvelle PILE dans la PILE
	move.l	D2,(4,SP)	; R‚installe l'adresse de la BASEPAGE
	move.l	D0,-(SP)	; EmPILE la taille … r‚server
	move.l	A6,-(SP)	; EmPILE l'adresse du programme
	clr.w	-(SP)	; R‚serv‚
	move.w	#$4A,-(SP)	; - M_SHRINK -
	trap	#1	; *** GEMDOS ***
	lea	(12,SP),SP

	tst.w	D0
	BMI	P_Term

; *****************************************************************************	

; --- Initialisation du Programme ---

	; On coupe la souris
	; ATTENTION : Sous Ecran Virtuel, plus de posibilit‚s de 
	;             bouger la Fenˆtre d'Affichage
	; Cuting the Mouse
	; WARNING : Under Virtual Screen, you cannot move
	;           the Display Window anymore
	; You can also use the - INITMOUSE - function (XBIOS 0)
	
	move.w	#18,-(SP)
	move.w	#4,-(SP)
	move.w	#3,-(SP)	; - BCONOUT -
	trap	#13	; *** BIOS ***
	addq.l	#6,SP

	; On ouvre le Fichier d'Animation
	; Opening the Movie File

	clr.w	-(SP)
	pea	MovieName
	move.w	#$3D,-(SP)	; - F_OPEN -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	move.w	D0,MovieHandle
	
	; On se place … la fin pour en connaitre la Taille
	; Going to its end in order to know its Size
	
	move.w	#2,-(SP)
	move.w	D0,-(SP)
	clr.l	-(SP)
	move.w	#$42,-(SP)	; - F_SEEK -
	trap	#1	; *** GEMDOS ***
	lea	(10,SP),SP
	
	; divu.l works like this :
	; D0 is the Quotient
	; D1 is the Rest
	;
	; D0.l <- Int [(D0+D1)/Value] (here Value == #Immediate)
	; D1.l <- Int [(Frac [(D0+D1)/Value])*Value ]
	
	clr.l	D1	; No Rest
	divu.l	#42240,D1:D0
	
	tst.l	D1
	BNE	Exit
	
	move.w	D0,MovieLenght

	; Ecran Physique du GEM
	; Physical Screen of GEM

	move.w	#2,-(SP)	; - PHYSBASE -
	trap	#14	; *** XBIOS ***
	addq.l	#2,SP
	
	move.l	D0,GEMPhysic

	; Ecran Logique du GEM
	; Logical Screen of GEM

	move.w	#3,-(SP)	; - LOGBASE -
	trap	#14	; *** XBIOS ***
	addq.l	#2,SP
	
	move.l	D0,GEMLogic
	
	; On r‚serve l'Ecran Logique
	; Allocating the Logical Screen
	
	clr.w	-(SP)
	move.l	#168960,-(SP)
	move.w	#$44,-(SP)	; - M_XALLOC -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	move.l	D0,ScreenBank

	; On r‚serve l'Ecran Physique
	; Allocating the Physical Screen

	clr.w	-(SP)
	move.l	#168960,-(SP)
	move.w	#$44,-(SP)	; - M_XALLOC -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	move.l	D0,ScreenBank+4
		
	; On efface les Ecrans
	; Clearing the Screens
		
	BSR	Clear_Screen

	; On initialise quelques Variables
	; Init. some 

	move.w	#1,DisplayMachine
	move.w	#1,DisplayVersion
	clr.w	DisplayFilter
	clr.w	DisplayPaper
	
; *****************************************************************************	

; --- Routine Principale ---
	
	; Remise … Z‚ro
	; Reset
	
ResetLoop	move.w	MovieLenght,D7
	subq.w	#1,D7
	
	clr.w	-(SP)
	move.w	MovieHandle,-(SP)
	clr.l	-(SP)
	move.w	#$42,-(SP)	; - F_SEEK -
	trap	#1	; *** GEMDOS ***
	lea	(10,SP),SP

	; Chargement de l'Image
	; Loading the Image

ReadLoop	pea	ScreenBuffer
	move.l	#42240,-(SP)
	move.w	MovieHandle,-(SP)
	move.w	#$3F,-(SP)	; - F_READ -
	trap	#1	; *** GEMDOS ***
	lea	(12,SP),SP
	
	; Application du Filtre
	; Filtering
	
DisplayLoop	; DisplayFilter==0, pas de Filtre
	;                   no Filter

	move.w	DisplayFilter,D0
	BNE	ViewFilter
	
	; On repique les Donn‚es directement depuis ScreenBuffer
	; Using the datas from ScreenBuffer
	
	move.l	#ScreenBuffer,ScreenData
			
	BRA	ViewLoopNext
	
	; Faudra prendre les Donn‚es trait‚es dans ScreenFilter
	; Using the datas from ScreenFilter
	
ViewFilter	move.l	#ScreenFilter,ScreenData

	; On force le bon Filtre
	; Force the right Filter

	lea	FilterBank,A0
	move.l	(A0,D0.w*4),A0
	
	; On s'en va appliquer le Filtre
	; Going Filter
	
	JSR	(A0)
	
	; Affichage de l'Image. On force la Routine d'Affichage
	; Displaying. Force the right Display Routine
	
ViewLoopNext	move.w	DisplayMachine,D0
	move.w	DisplayVersion,D1
	
	mulu.w	#8,D0
	mulu.w	#4,D1
	add.w	D1,D0
	
	lea	DisplayBank,A0
	
	move.l	(A0,D0.w),DisplayRoutine

	; On s'en va Afficher l'Image
	; Going Display

	JSR	([DisplayRoutine])
	
	; Swapping
	; ...
	
	move.w	#$25,-(SP)	; - VSYNC -
	trap	#1	; *** XBIOS ***
	addq.l	#2,SP
	
	move.w	#-1,-(SP)
	move.w	#-1,-(SP)
	move.l	ScreenBank,-(SP)	; Logical  -> Physical
	move.l	ScreenBank+4,-(SP)	; Physical -> Logical
	move.w	#5,-(SP)	; - VSETSCREEN -
	trap	#14	; *** XBIOS ***
	lea	(14,SP),SP

	; On ‚change les deux Ecrans
	; Swap both Screens

	move.l	ScreenBank,D0
	move.l	ScreenBank+4,ScreenBank
	move.l	D0,ScreenBank+4
	
	; Lecture du Clavier. Y'a t-il un caractŠre qui nous attend ?
	; Read the KeyBoard. Is there a character waiting for us ?
	
ScanKeys	move.w	#2,-(SP)
	move.w	#1,-(SP)	; - BCONSTAT -
	trap	#13	; *** BIOS ***
	addq.l	#4,SP
	
	tst.w	D0
	BEQ	NextFrame
	
	; On vide le Buffer et on garde la derniŠre Entr‚e
	; Clearing the Buffer and keeping the last Entry
	
ReadKeys	move.w	#2,-(SP)
	move.w	#2,-(SP)	; - BCONIN -
	trap	#13	; *** BIOS ***
	addq.l	#4,SP

	move.l	D0,D2
	swap	D2
	
	move.w	#2,-(SP)
	move.w	#1,-(SP)	; - BCONSTAT -
	trap	#13	; *** BIOS ***
	addq.l	#4,SP
	
	tst.w	D0
	BNE	ReadKeys

	; On s‚lectionne le Choix
	; Setting the Choice

	cmpi.b	#1,D2	; Escape
	BEQ	ScreenExit
	
	cmpi.b	#$1F,D2	; S
	BEQ	SaveTarga
	
	cmpi.b	#$3B,D2	; F1
	BLT	LookKeysNext
	
	cmpi.b	#$44,D2	; F10
	BLE	SetFilter
	
LookKeysNext	cmpi.b	#$39,D2	; Space
	BEQ	Pause
	
	cmpi.b	#$47,D2	; ClrHome
	BEQ	ResetLoop

	cmpi.b	#$48,D2	; UpArrow
	BEQ	TenBefore
	
	cmpi.b	#$4A,D2	; - (Num)
	BEQ	Smaller
	
	cmpi.b	#$4B,D2	; <-
	BEQ	Previous
	
	cmpi.b	#$4E,D2	; + (Num)
	BEQ	Taller
	
	cmpi.b	#$4D,D2	; ->
	BEQ	Next
	
	cmpi.b	#$50,D2	; DownArrow
	BEQ	TenAfter
	
	cmpi.b	#$63,D2	; ( (Num)
	BEQ	SoftVersion
	
	cmpi.b	#$64,D2	; ) (Num)
	BEQ	HardVersion	
	
	; V‚rification de la Pause
	; Checking Pause
		
NextFrame	tst.w	PauseFlag
	BNE	ScanKeys

	; Prochaine Image. Diminution du nombre d'Image restant
	; Next Image. Decreasing Image-To-Read Counter

Next	DBF	D7,ReadLoop
			
	; On r‚initialise l'Animation
	; Reseting the Movie
			
	BRA	ResetLoop
		
; *****************************************************************************	

; --- Sortie du Programme ---
		
	; Restauration de l'Ecran pour le GEM
	; ATTENTION : Sous Ecran Virtuel, la position
	;             du coin HG du Bureau sera celle du
	;             coin HG de l'Ecran lors de l'execution
	;             du Programme 
	; Restoring of the Screen for GEM
	; WARNING : Under Virtual Screen, the location
	;           of the UL DeskTop corner will be those 
	;           of the UL Screen during the Program start
		
ScreenExit	move.w	#-1,-(SP)
	move.w	#-1,-(SP)
	move.l	GEMPhysic,-(SP)
	move.l	GEMLogic,-(SP)
	move.w	#5,-(SP)	; - VSETSCREEN -
	trap	#14	; *** XBIOS ***
	lea	(14,SP),SP

	; Fermeture de l'Animation
	; Closing the Movie

Exit	move.w	MovieHandle,-(SP)
	move.w	#$3E,-(SP)	; - F_CLOSE -
	trap	#1	; *** GEMDOS ***
	addq.l	#4,SP

	; Lib‚ration de la Souris
	; Freeing the Mouse

	move.w	#8,-(SP)
	move.w	#4,-(SP)
	move.w	#3,-(SP)	; - BCONOUT -
	trap	#13	; *** BIOS ***
	addq.l	#6,SP

	; Kassoss...
	; Let's warp...

P_Term	move.w	D0,-(SP)
	move.w	#$4C,-(SP)	; - P_TERM -
	trap	#1	; *** GEMDOS ***

; *****************************************************************************	

; --- La gestion des Touches ---

; /// Targa File Format - KOSS (c) 1999 ///
; 
; Targa from TrueVision are built like this :
;  - Header   : 18 Bytes
;  - ID Field : optional
;  - Palette  : optional
;  - Data
;
; Mode Intel      mean Word or Long are in little Endian (Bits 76543210 FEDCBA98) fool 
; Mode Motor(ola) mean Word or Long are in BIG    Endian (Bits FEDCBA98 76543210) normal
;
; > Header :
; OffSet Size  Mode Meaning
;      0 BYTE    .  Lenght Image ID Field
;                      0 : No    ID Field
;                   <> 0 : Then  ID Field Size
;      1 BYTE    .  Color Map Type
;                      0 : No Color Map - True Color Image 
;                      1 :    Color Map
;      2 BYTE    .  Image Type
;                      0 : No Data in File
;                      1 :    Color Map Image - Unpacked
;                          WARNING : Image Descriptor Flag to 0 !
;                      2 : True Color   Image - Unpacked - 24 Bits
;                      3 : Monochrome   Image - Unpacked
;
;                      9 :    Color Map Image - RLE Pack
;                     10 : True Color   Image - RLE Pack - 24 Bits
;                     11 : Monochrome   Image - RLE Pack
;
;                     32 :    Color Map Image - HuffMan+Delta+RLE Pack
;                     33 :    Color Map Image - HuffMan+Delta+RLE Pack (4 Pass Quad Tree)
;                          These 2 Last Packing Systems aren't documented...
;
;      3 WORD Intel Color Map Origin
;      5 WORD Intel Color Map Lenght
;      7 BYTE    .  Color Map Entry Size
;                     16 : 16 Bits
;                     24 : 24 Bits
;                     32 : 32 Bits
;      8 WORD Intel X-Coordinate
;     10 WORD Intel Y-Coordinate
;     12 WORD Intel Width  (Largeur)
;     14 WORD Intel Height (Hauteur)
;     16 BYTE    .  Bits per Pixel
;                      1 : Monochrome
;                      8 : Color Map  Image
;                     24 : True Color Image
;     17 BYTE    .  Image Descriptor Flag
;                   Bit 76543210
;                       ||||'+++-> Attribute Bits per Pixel
;                       ||||0000 Targa 16 Bits or Targa 24 Bits
;                       ||||0001 Targa 16 Bits
;                       ||||1000 Targa 32 Bits
;                       ||++-----> Screen Origin
;                       ||00     Lower Left  Corner
;                       ||01     Lower Right Corner
;                       ||10     Upper Left  Corner
;                       ||11     Upper Right Corner
;                       ++-------> Data Storage Interleave
;                       00       No Interleave
;                       01       2-Way Interleave
;                       10       4-Way Interleave
;                       11       Reserved
;
; > ID Field
;   If there is an ID Field, it start at OffSet 18 !
;
; > Palette
;   If there isn't an ID Field, Palette start at OffSet 18 !
;
; > Data
;
; Typical Targa Header for a TC Image :
; OffSet :  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 16 16 17
; Data   : 00 00 02 00 00 00 00 00 00 00 00 00 xx xx yy yy 18 20
; Then TC Datas (for 24 Bits Colors, Values are BGR, in this stupid order) ...

; - Sauve l'Ecran Courant en Targa -

	; On cherche la fin du Chemin actuel
	; Looking for the end of the current Path
	
SaveTarga	lea	MovieName,A0
	move.l	#255,D0
	
SavePath_LookFor	move.b	(A0,D0.w),D1
	cmpi.b	#"\",D1
	BEQ	SavePath_Found
	
	DBF	D0,SavePath_LookFor

	; Pas trouv‚e...
	; Not found...

	BRA	NextFrame	

	; On regarde s'il reste assez de place pour le Nom du Fichier
	; Looking for enough place for the File Name

SavePath_Found	cmpi.w	#242,D0
	BLE	SavePath_Name
	
	BRA	NextFrame

	; On cr‚e le Nom du Fichier
	; Creating File Name

SavePath_Name	move.l	#"\FRM",(A0,D0.w)
	adda.l	D0,A0
	addq.l	#4,A0
	
	move.w	MovieLenght,D0
	sub.w	D7,D0
	move.w	#4,D2
	
SavePath_Number	clr.l	D1
	divu.l	#10,D1:D0
	add.b	#$30,D1
	move.b	D1,(A0,D2.w)
	
	DBF	D2,SavePath_Number
	
	move.l	#".TGA",(5,A0)
	clr.b	(9,A0)
	
	; Cr‚ation du Fichier
	; Creating File
	
	clr.w	-(SP)
	pea	MovieName
	move.w	#$3C,-(SP)	; - F_CREATE -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	tst.l	D0
	BMI	NextFrame
	
	move.w	D0,D5
	
	lea	TargaHeader,A0
	
	move.w	DisplayMachine,D0
	BNE	SaveBigScreen
	
	move.w	#$B000,(12,A0)	; 176
	move.w	#$7800,(14,A0)	; 120
	
	clr.w	-(SP)
	move.l	#63360,-(SP)
	move.w	#$44,-(SP)	; - M_XALLOC -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	move.l	D0,D4	
	move.w	#10559,D3
	
	BRA	SaveFile_Header
	
SaveBigScreen	move.w	#$6001,(12,A0)	; 352
	move.w	#$F000,(14,A0)	; 240

	clr.w	-(SP)
	move.l	#253440,-(SP)
	move.w	#$44,-(SP)	; - M_XALLOC -
	trap	#1	; *** GEMDOS ***
	addq.l	#8,SP
	
	move.l	D0,D4	
	move.l	#42239,D3

SaveFile_Header	pea	TargaHeader
	move.l	#18,-(SP)
	move.w	D5,-(SP)
	move.w	#$40,-(SP)	; - F_WRITE -
	trap	#1	; *** GEMDOS ***
	lea	(12,SP),SP
	
	; Converti l'Image NTC en TC
	; Converting NTC Image into TC format
	
	move.l	ScreenBank+4,A0
	move.l	D4,A1
	
SaveData_Convert	bfextu	(A0){11:5},D1	; BlueA
	lsl.w	#3,D1
	move.b	D1,(A1)
	
	bfextu	(A0){5:6},D1	; GreenA
	lsl.w	#2,D1
	move.b	D1,(1,A1)
	
	bfextu	(A0){0:5},D1	; RedA
	lsl.w	#3,D1
	move.b	D1,(2,A1)

	bfextu	(A0){27:5},D1	; BlueB
	lsl.w	#3,D1
	move.b	D1,(3,A1)
	
	bfextu	(A0){21:6},D1	; GreenB
	lsl.w	#2,D1
	move.b	D1,(4,A1)
	
	bfextu	(A0){16:5},D1	; RedB
	lsl.w	#3,D1
	move.b	D1,(5,A1)

	addq.l	#4,A0
	addq.l	#6,A1
	
	DBF	D3,SaveData_Convert
		
	; On sauve l'Image
	; Saving Image
		
	move.l	D4,-(SP)

	move.w	DisplayMachine,D0
	BNE	SaveFile_BigScreen
	
	move.l	#63360,-(SP)
	
	BRA	SaveFile_Data
	
SaveFile_BigScreen	move.l	#253440,-(SP)
		
SaveFile_Data	move.w	D5,-(SP)
	move.w	#$40,-(SP)	; - F_WRITE -
	trap	#1	; *** GEMDOS ***
	lea	(12,SP),SP

	move.w	D5,-(SP)
	move.w	#$3E,-(SP)	; - F_CLOSE -
	trap	#1	; *** GEMDOS ***
	addq.l	#4,SP

	move.l	D4,-(SP)
	move.w	#$49,-(SP)	; - M_FREE -
	trap	#1	; *** GEMDOS ***
	addq.l	#6,SP

	BRA	NextFrame
		
	; Choix du Filtre
	; Choice of the Filter
		
; - Selectionne le Filtre -
		
SetFilter	sub.w	#$3B,D2
	
	; Si pas Filtre Chromatique, on s'en fout...
	; If not Chroma Filter, then give up...
	
	cmpi.w	#4,D2
	BLT	UseFilter
	
	move.w	DisplayFilter,D0
	
	; Si ce n'‚tait pas d‚j… le Filtre, on le change
	; If it was the same Filter, then change
	
	cmp.w	D2,D0
	BNE	UseFilter
	
	; On change la Couleur du Papier (Black/White)
	; Swapping Paper Color (...)
	
	move.w	DisplayPaper,D0
	not.w	D0
	move.w	D0,DisplayPaper

	; On s‚lectionne le Filtre demand‚
	; Set Chosen Filter

UseFilter	move.w	D2,DisplayFilter
	
	BRA	DisplayLoop
		
; - Pause/Play -

	; Pause. Si Pause active, on d‚sactive
	; ... If Pause active, then switch OFF
		
Pause	tst.w	PauseFlag
	BNE	Unpause
	
	; Sinon on active
	; Else switch ON
	
	move.w	#-1,PauseFlag
	
	BRA	NextFrame
	
Unpause	clr.w	PauseFlag

	BRA	NextFrame
		
	; Diminution de la qualit‚ de l'Affichage
	; Si d‚j… minimum (0), on ne change rien
	; Decrease Display Quality
	; If already Min (0), give up
	

; - Remonte de 10 Images -

TenBefore	move.w	MovieLenght,D5
	
	move.w	D7,D6
	add.w	#10+1,D6
	
	cmp.w	D5,D6
	BLE	AfterStart
	
	; On se retrouve avant le d‚but de l'Animation
	
	sub.w	D5,D6
	move.w	D6,D7
	subq.w	#1,D7
			
	; D‚but des 10 Images pr‚c‚dentes
	; Start of the 10 previous Images
		
	clr.l	D0
	move.w	D6,D0
	mulu.l	#-42240,D0
		
	move.w	#2,-(SP)
	move.w	MovieHandle,-(SP)
	move.l	D0,-(SP)
	move.w	#$42,-(SP)	; - F_SEEK -
	trap	#1	; *** GEMDOS ***
	lea	(10,SP),SP
		
	BRA	ReadLoop

	; On peut remonter de 10 Images sans se trouver
	; avant le d‚but de l'Animation

AfterStart	move.w	#1,-(SP)
	move.w	MovieHandle,-(SP)
	move.l	#-464640,-(SP)
	move.w	#$42,-(SP)	; - F_SEEK -
	trap	#1	; *** GEMDOS ***
	lea	(10,SP),SP
	
	add.w	#10,D7
	
	BRA	ReadLoop

; - Baisse en Qualit‚ -
		
Smaller	move.w	DisplayMachine,D0
	BEQ	NextFrame
	
	pea	DisplayLoop
	
	; On baisse en qualit‚
	; Decreasing Quality
	
	subq.w	#1,D0
	move.w	D0,DisplayMachine
	
	; Si MINID2D ou WINDOW, on efface les Ecrans pour une Bordure noire
	; If ...              , clearing Screens to get a Black border
	
	cmpi.w	#1,D0
	BLE	Clear_Screen	; -> Clear_Screen -> DisplayLoop
	
	RTS

; - Image Pr‚c‚dente -
		
	; Image pr‚c‚dente
	; Previous Image
		
Previous	move.w	MovieLenght,D0
	subq.w	#1,D0
	
	cmp.w	D0,D7
	BEQ	FirstFrame	; 0 -> DerniŠre
	BLT	LastFrame	; Image pr‚c‚dente
	BGT	ErrorFrame	; ???
	
	BRA	NextFrame
	
; - Augmente en Qualit‚ -
	
	; Augmentation de la qualit‚ de l'Affichage
	; Si maximum (3), on ne change rien
	; Increase Display Quality
	; If Max (3), give up
	
Taller	move.w	DisplayMachine,D0
	cmpi.w	#3,D0
	BGE	NextFrame
	
	pea	DisplayLoop
	
	; On augmente en qualit‚
	; Increasing Quality
	
	addq.w	#1,D0
	move.w	D0,DisplayMachine
	
	; Si MINID2D ou WINDOW, on efface les Ecrans pour une Bordure noire
	; If ...              , clearing Screens to get a Black border
	
	cmpi.w	#1,D0
	BLE	Clear_Screen	; -> Clear_Screen -> DisplayLoop
	
	RTS
	
; - Descend de 10 Images -

TenAfter	cmpi.w	#9,D7
	BLE	FromStart
	
	move.w	#1,-(SP)
	move.w	MovieHandle,-(SP)
	move.l	#380160,-(SP)
	move.w	#$42,-(SP)	; - F_SEEK -
	trap	#1	; *** GEMDOS ***
	lea	(10,SP),SP
	
	sub.w	#10,D7
		
	BRA	ReadLoop
	
	; S'il reste 10 Images ou moins … lire
	; If there still 10 Images or less to read
	
FromStart	move.w	MovieLenght,D1
	subq.w	#1,D1

	move.l	#9,D0
	sub.w	D7,D0
	sub.w	D0,D1
	move.w	D1,D7
	mulu.l	#42240,D0
		
	clr.w	-(SP)
	move.w	MovieHandle,-(SP)
	move.l	D0,-(SP)
	move.w	#$42,-(SP)	; - F_SEEK -
	trap	#1	; *** GEMDOS ***
	lea	(10,SP),SP

	BRA	ReadLoop
	
; - Positionne sur la derniŠre Image -
	
	; DerniŠre Image de l'Animation
	; Last Image of the Movie
	
FirstFrame	clr.w	D7

	; D‚but de la derniŠre Image
	; Start of the last Image
		
	move.w	#2,-(SP)
	move.w	MovieHandle,-(SP)
	move.l	#-42240,-(SP)
	move.w	#$42,-(SP)	; - F_SEEK -
	trap	#1	; *** GEMDOS ***
	lea	(10,SP),SP
	
	BRA	ReadLoop

; - Positionne sur l'Image Pr‚c‚dente -

	; Image pr‚c‚dente. Modification du Compteur
	; Previous Image. Updating counter

LastFrame	addq.w	#1,D7

	; L'Image actuelle a ‚t‚ lue, il faut revenir de 2 Images
	; Previous Image was read, must return back of 2 Images

	move.w	#1,-(SP)
	move.w	MovieHandle,-(SP)
	move.l	#-42240*2,-(SP)
	move.w	#$42,-(SP)	; - F_SEEK -
	trap	#1	; *** GEMDOS ***
	lea	(10,SP),SP
	
	BRA	ReadLoop
	
; - Si Erreur ... -

	; Au cas o—...
	; In case of...
	
ErrorFrame	move.w	D0,D7

	BRA	NextFrame
	
; - Utilisation de la Version Software -

	; Version Software ou 68000.
	; Software Version or 68000.
	
SoftVersion	move.w	DisplayVersion,D0
	BEQ	NextFrame
	
	; Version Software
	; Software Version
	
	clr.w	DisplayVersion
	
	BRA	DisplayLoop

; - Utilisation de la Version Hardware -

	; Version Hardware ou 68030.
	; Hardware Version or 68030.

HardVersion	move.w	DisplayVersion,D0
	BNE	NextFrame
	
	; Version Hardware
	; Hardware Version
	
	move.w	#1,DisplayVersion
	
	BRA	DisplayLoop
 
; *****************************************************************************	

; You'll see that for Additive     Chroma Synthesis, when WhitePaper selected, the
;   Image seams to be reversed. White is the Maximum Addition,     you can't Add more
;   colors...
; You'll see that for Substractive Chroma Synthesis, when BlackPaper selected, the
;   Image seams to be reversed. Black is the Maximum Substraction, you can't Sub more
;   colors...
; Let see why :
;
; Additive Chroma Synthesis                         Substractive Chroma Synthesis
;
;         .------.                                               .------.
; Black  /        \                                     White   /        \
; here  /   Blue   \                                    Stuff  /  Yellow  \
;     .-+----..----+-.                                       .-+----..----+-.
;    /  \ C /  \ M /  \  Black                              /M \ R /  \ G /  \
;   /    \ / Wh \ /    \  there                            / a  \ / Bk \ /    \
;   |Green|------|  Red|                                   | g   |------| Cyan|
;   \      \ Y  /      /                                   \  e   \ B  /      /
;    \      \  /      /                                     \  nta \  /      /
;     '------''------'                                       '------''------'
; There C mean Cyan                                 There R mean Red
;       Y      Yellow                                     G      Green
;       M      Magenta                                    B      Blue
;   and Wh     White                                  and Bk     Black
;
; Here, you must Add all the                        Here you must Sub all the
;   colors (RGB) to GET White                         colors (CYM) to KEEP White
; No  color -> BLACK                                No  color -> WHITE
; All color -> WHITE                                All color -> BLACK
; 
; You can Note that :                               You can Note that :
;   Cyan    is /Red                                   Red   is /Cyan
;   Yellow  is /Blue                                  Green is /Magenta
;   Magenta is /Green                                 Blue  is /Yellow
;
; Now what is BlackPaper & WhitePaper Technology :
;
; It was done for WYSIWYG Interface. Imagine you want to Filter a Picture onto
;   your Screen in order to watch only the R,B,G,C,Y or M value.
;
;   + BlackPaper +
;
; - For RGB, just keep the Chroma Value you want (for G, erase R and B)
; - For CYM, reverse your Chroma Value you want, copy the Chroma Value get in 
;   the two other, then erase the value you want to watch (for C, reverse R, 
;   copy /R=C in G and B, then erase R. Dont forget that your Screen is based 
;   onto the Additive Chroma Synthesis System. So C on your Screen is G+B)
;
; > RGB : JUST ERASE the Chroma Values you want not to keep
; > CYM : See just above how to do (use NOT, NEVER NEG)
;         Note that CYM BlackPaper Filter is used for printer. The Chroma Value get
;         allows you to print the right color level on the paper.
;
;   + WhitePaper +
;
; Now you want to see what it could show if you put your colors onto a White Paper
; - For e.g. when R is | Max, you want to get Red
;                        Min                  White
;   So reverse R, copy /R in G and B, then FORCE R to the Max...
;   If R was | Min, /R is Max, then G and B too. R forced to Max, it gives White
;            | Max,       Min,                                             Red
; - Easier : For e.g. when C is | Max, you want to get Cyan
;                               | Min                  White
;   Or C is /R,  then when C is | Min, R is Max. Just FORCE G and B to Max, it gives White
;                               | Max       Min                                      Cyan
;
; > RGB : - Reverse the Chroma Value you want (JUST NOT IT, not NEG...)
;         - Copy the reversed Chroma Value in the two others
;         - Force the Chroma Value you want to Max
; > CYM : - Put the others Chroma Value to Max
;         Note that face to the BlackPaper mode, here you can see what you'll get
;         on the paper once printed.

; --- Les Filtres ---
	
; - Filtre Luminance -
; Low Value     -      Middle Value     -      High Value
; 0             63          127        191            255 <- Value Given
; Black                  Dark Color            Pure Color <- Source Color
;

Y_FILTER	lea	ScreenBuffer,A0
	lea	ScreenFilter,A1
		
	move.w	#10560-1,D3
	
	; Pour une utilisation en Virgule Fixe
	; For a Fixed Point use
	;    0.299  =  %0000000000000000.0100110010001011
	;    0.5786 =  %0000000000000000.1001010000111110
	;    0.114  =  %0000000000000000.0001110100101111
	
	fmove.x	#0.299,FP3
	fmove.x	#0.5786,FP4
	fmove.x	#0.114,FP5
	fmove.x	#0,FP6	; !
	
	BRA	ChromaFilter
	
; - Filtre Chrominance -
; Low Value     -      Middle Value     -      High Value
; 0             63          127        191            255 <- Value Given
; Red  Orange Yellow Green Cyan  Blue Purple Magenta  Red <- Source Color
;

U_FILTER	lea	ScreenBuffer,A0
	lea	ScreenFilter,A1
		
	move.w	#10560-1,D3
	
	; Idem
	;    0.5    =  %0000000000000000.1000000000000000
	; -  0.4187 = /%1111111111111111.1001010011010000
	; -  0.0813 = /%1111111111111111.1110101100101111
	;  128      =  %0000000010000000.0000000000000000
	
	fmove.x	#0.5,FP3
	fmove.x	#-0.4187,FP4
	fmove.x	#-0.0813,FP5
	fmove.x	#128,FP6
	
	BRA	ChromaFilter

; - Filtre Saturation -
; Low Value     -      Middle Value     -      High Value
; 0             63          127        191            255 <- Value Given
; White        Light Color    Pastel Color     Pure Color <- Source Color

V_FILTER	lea	ScreenBuffer,A0
	lea	ScreenFilter,A1
		
	move.w	#10560-1,D3
	
	; Idem
	; -  0.1687 = /%1111111111111111.1101010011010000
	; -  0.3313 = /%1111111111111111.1010101100101111
	;    0.5    =  %0000000000000000.1000000000000000
	;  128      =  %0000000010000000.0000000000000000

	fmove.x	#-0.1687,FP3
	fmove.x	#-0.3313,FP4
	fmove.x	#0.5,FP5
	fmove.x	#128,FP6

; - Filtre Chromatique -

	; Les Instructions bfextu ne travaillent que sur des LONGs
	; bfextu Instructions works only on LONGs

ChromaFilter	bfextu	(A0){0:5},D0	; RedA
	bfextu	(A0){5:6},D1	; GreenA
	bfextu	(A0){11:5},D2	; BlueA

	BSR	ReduceFilter
	
	move.w	D0,(A1)+
	
	bfextu	(A0){16:5},D0	; RedB
	bfextu	(A0){21:6},D1	; GreenB
	bfextu	(A0){27:5},D2	; BlueB
	
	BSR	ReduceFilter
	
	move.w	D0,(A1)+
	
	addq.l	#4,A0
	
	DBF	D3,ChromaFilter

	RTS

	; Utilisation du FPU pour les Virgules Flottantes, mais
	; le CPU en Virgules Fixes suffit amplement...
	; Using the FPU for Floatting Point, but
	; the CPU with Fixed Point is enough...

ReduceFilter	lsl.w	#3,D0
	lsl.w	#2,D1
	lsl.w	#3,D2
	
	fmove.w	D0,FP0
	fmove.w	D1,FP1
	fmove.w	D2,FP2
	
	fmul.x	FP3,FP0
	fmul.x	FP4,FP1
	fmul.x	FP5,FP2
	
	fadd.x	FP0,FP1
	fadd.x	FP2,FP1
	fadd.x	FP6,FP1
	
	fmove.w	FP1,D1
	lsr.w	#3,D1
	andi.w	#%111111,D1
	
	; Niveau de Gris
	; Grey Level
	
	clr.w	D0
	or.w	D1,D0
	lsl.w	#1,D1
	lsl.w	#6,D0
	or.w	D1,D0
	lsr.w	#1,D1
	lsl.w	#5,D0
	or.w	D1,D0
	
	RTS

; - Filtre Rouge -

RED_FILTER	lea	ScreenBuffer,A0
	lea	ScreenFilter,A1
		
	move.w	#21120-1,D3
	move.w	#%1111100000000000,D2	; On ne garde que R
	
	move.w	DisplayPaper,D0
	BNE	ReduceWhiteRed

	BRA	BlackRGB_Filter
	
ReduceWhiteRed	move.w	(A0)+,D1

	not.w	D1	; On inverse R
	andi.w	#%1111100000000000,D1
	rol.w	#5,D1
	clr.w	D0
	or.w	D1,D0	; On place /R en V
	lsl.w	#6,D0
	or.w	D1,D0	; On place /R en B
	ori.w	#%1111100000000000,D0	; On force R au Max

	move.w	D0,(A1)+
	
	DBF	D3,ReduceWhiteRed
	
	RTS
	
; - Filtre Vert -

GREEN_FILTER	lea	ScreenBuffer,A0
	lea	ScreenFilter,A1
		
	move.w	#21120-1,D3
	move.w	#%11111100000,D2	; On ne garde que V

	move.w	DisplayPaper,D0
	BNE	ReduceWhiteGreen
	
	BRA	BlackRGB_Filter

ReduceWhiteGreen	move.w	(A0)+,D1

	not.w	D1	; On inverse V
	andi.w	#%11111000000,D1
	lsr.w	#6,D1
	clr.w	D0
	or.w	D1,D0	; On place /V en R
	ror.w	#5,D0
	or.w	D1,D0	; On place /V en B
	ori.w	#%11111000000,D0	; On force V au Max

	move.w	D0,(A1)+
	
	DBF	D3,ReduceWhiteGreen
	
	RTS

; - Filtre Bleu -

BLUE_FILTER	lea	ScreenBuffer,A0
	lea	ScreenFilter,A1
		
	move.w	#21120-1,D3
	move.w	#%11111,D2	; On ne garde que B
	
	move.w	DisplayPaper,D0
	BNE	ReduceWhiteBlue
	
	BRA	BlackRGB_Filter

ReduceWhiteBlue	move.w	(A0)+,D1

	not.w	D1	; On inverse B
	andi.w	#%11111,D1
	clr.w	D0
	or.w	D1,D0	; On place /B en R
	lsl.w	#5,D0
	or.w	D1,D0	; On place /B en V
	lsl.w	#6,D0
	ori.w	#%11111,D0	; On force B au Max

	move.w	D0,(A1)+
	
	DBF	D3,ReduceWhiteBlue
	
	RTS

; - Filtre RGB -

BlackRGB_Filter	move.w	(A0)+,D0
	and.w	D2,D0
	move.w	D0,(A1)+
	
	DBF	D3,BlackRGB_Filter
	
	RTS

; - Filtre Cyan -

CYAN_FILTER	lea	ScreenBuffer,A0
	lea	ScreenFilter,A1
		
	move.w	#21120-1,D3

	move.w	DisplayPaper,D0
	BNE	ReduceWhiteCyan

ReduceBlackCyan	move.w	(A0)+,D0

	not.w	D0	; On cr‚e C par /R
	andi.w	#%1111100000000000,D0
	rol.w	#5,D0
	clr.w	D1
	or.w	D0,D1	; On place C en V
	lsl.w	#6,D1
	or.w	D0,D1	; On place C en B

	move.w	D1,(A1)+
	
	DBF	D3,ReduceBlackCyan

	RTS

ReduceWhiteCyan	move.w	(A0)+,D0
	
	ori.w	#%11111111111,D0	; On force V et B au Max
	
	move.w	D0,(A1)+
	
	DBF	D3,ReduceWhiteCyan
	
	RTS

; - Filtre Jaune -

YELLOW_FILTER	lea	ScreenBuffer,A0
	lea	ScreenFilter,A1
		
	move.w	#21120-1,D3

	move.w	DisplayPaper,D0
	BNE	ReduceWhiteYellow

ReduceBlackYellow	move.w	(A0)+,D0

	not.w	D0	; On cr‚e J par /B
	andi.w	#%11111,D0
	clr.w	D1
	or.w	D0,D1	; On place J en R
	lsl.w	#5,D1
	or.w	D0,D1	; On place J en V
	lsl.w	#6,D1

	move.w	D1,(A1)+
	
	DBF	D3,ReduceBlackYellow

	RTS

ReduceWhiteYellow	move.w	(A0)+,D0

	ori.w	#%1111111111100000,D0	; On force R et V au Max

	move.w	D0,(A1)+
	
	DBF	D3,ReduceWhiteYellow
	
	RTS
	
; - Filtre Magenta -

MAGENTA_FILTER	lea	ScreenBuffer,A0
	lea	ScreenFilter,A1
		
	move.w	#21120-1,D3
	
	move.w	DisplayPaper,D0
	BNE	ReduceWhiteMagenta

ReduceBlackMagenta	move.w	(A0)+,D0

	not.w	D0	; On cr‚e M par /V
	andi.w	#%11111000000,D0
	lsr.w	#6,D0
	clr.w	D1
	or.w	D0,D1	; On place M en R
	ror.w	#5,D1
	or.w	D0,D1	; On place M en B

	move.w	D1,(A1)+
	
	DBF	D3,ReduceBlackMagenta

	RTS
	
ReduceWhiteMagenta	move.w	(A0)+,D0
	ori.w	#%1111100000011111,D0	; On force R et B au Max
	move.w	D0,(A1)+
	
	DBF	D3,ReduceWhiteMagenta
	
	RTS

; *****************************************************************************	
	
; --- Les Routines d'Affichage ---

; - Effacement des Ecrans - ---------------------------------------------------

	; Ecran Logique
	; Logical Screen

Clear_Screen	move.l	ScreenBank,A0

	move.w	#42239,D0
BlackLoop1	clr.l	(A0)+
	DBF	D0,BlackLoop1

	; Ecran Physique
	; Physical Screen

	move.l	ScreenBank+4,A0
	
	move.w	#42239,D0
BlackLoop2	clr.l	(A0)+
	DBF	D0,BlackLoop2

	RTS
	
; - Mini D2D CPU (176*120) -> (176*120) - -------------------------------------

MINID2D_CPU	move.l	ScreenData,A0
	move.l	ScreenBank,A1
	
	move.w	#10559,D6

MINID2DCPU_ScanLoop	move.l	(A0)+,(A1)+
	
	DBF	D6,MINID2DCPU_ScanLoop

	RTS

; - Mini D2D BLITTER (176*120) -> (176*120) - ---------------------------------

MINID2D_BLITTER	pea	MINID2D_BlitterCopy
	move.w	#$26,-(SP)	; - SUPEXEC -
	trap	#14	; *** XBIOS ***
	addq.l	#6,SP

	RTS

; /// BLITTER Control Registers - Dan Hollis (c) 1994 & KOSS 1999 ///
;
;
; HTRAM 0-1          2*	w $FFFF8A00.w	HalfTone-RAM 0-1
; 16 Bits register
; HTRAM 2-3          2*	w $FFFF8A04.w	HalfTone-RAM 2-3
; 16 Bits register
; HTRAM 4-5          2*	w $FFFF8A08.w	HalfTone-RAM 4-5
; 16 Bits register
; HTRAM 6-7          2*	w $FFFF8A0C.w	HalfTone-RAM 6-7
; 16 Bits register
; HTRAM 8-9          2*	w $FFFF8A10.w	HalfTone-RAM 8-9
; 16 Bits register
; HTRAM A-B          2*	w $FFFF8A14.w	HalfTone-RAM A-B
; 16 Bits register
; HTRAM C-D          2*	w $FFFF8A18.w	HalfTone-RAM C-D
; 16 Bits register
; HTRAM E-F          2*	w $FFFF8A1C.w	HalfTone-RAM E-F
; 16 Bits register
;		HalfTone-RAM is a 16*16 Bits RAM used
;		generaly for Sprite Masking.
;		16*16 Pixels in Monochrome
;		 8*16 Pixels in   4 Colors
;		 4*16 Pixels in  16 Colors
;		 2*16 Pixels in 256 Colors
;		 1*16 Pixels in NTC
; 
; SXI	w $FFFF8A20.w	Source X Increment
; 16 Bits register		Size IN BYTE between 2 WORDs
; Signed & Even                                 For Continuous Copy (NTC), put 2 here
;		else the OffSet to the other Plane Word :
;		 2 : Monochrome (1 Bit  per Pixel)
;		 4 :   4 Colors (2 Bits per Pixel)
;		 8 :  16 Colors (4 Bits per Pixel)
;		16 : 256 Colors (1 Byte per Pixel)
;		Why these value ? ScreenMap on Atari
;		is done with 16 Pixels per Plane Word.
;		In 256 Colors, there is 16 * 1   Byte
;		In  16 Colors, there is 16 * 0.5 Byte
;		Etc...
;   For example : 16 Color, 4 Planes
;                 WORD 0 : Bits FEDCBA9876543210
;                               |||||||||||||||'-> Bit 0 of Pixel F
;                               ||||||||||||||'--> Bit 0 of Pixel E 
;                               |||||||||||||'---> Bit 0 of Pixel D
;                               ||||||||||||'----> Bit 0 of Pixel C
;                               |||||||||||'-----> Bit 0 of Pixel B
;                               ||||||||||'------> Bit 0 of Pixel A
;                               |||||||||'-------> Bit 0 of Pixel 9
;                               ||||||||'--------> Bit 0 of Pixel 8
;                               |||||||'---------> Bit 0 of Pixel 7
;                               ||||||'----------> Bit 0 of Pixel 6
;                               |||||'-----------> Bit 0 of Pixel 5
;                               ||||'------------> Bit 0 of Pixel 4
;                               |||'-------------> Bit 0 of Pixel 3
;                               ||'--------------> Bit 0 of Pixel 2
;                               |'---------------> Bit 0 of Pixel 1
;                               '----------------> Bit 0 of Pixel 0
;
;                 WORD 1 : Bits FEDCBA9876543210
;                               |||||||||||||||'-> Bit 1 of Pixel F
;                               ||||||||||||||'--> Bit 1 of Pixel E 
;                               |||||||||||||'---> Bit 1 of Pixel D
;                               ||||||||||||'----> Bit 1 of Pixel C
;                               |||||||||||'-----> Bit 1 of Pixel B
;                               ||||||||||'------> Bit 1 of Pixel A
;                               |||||||||'-------> Bit 1 of Pixel 9
;                               ||||||||'--------> Bit 1 of Pixel 8
;                               |||||||'---------> Bit 1 of Pixel 7
;                               ||||||'----------> Bit 1 of Pixel 6
;                               |||||'-----------> Bit 1 of Pixel 5
;                               ||||'------------> Bit 1 of Pixel 4
;                               |||'-------------> Bit 1 of Pixel 3
;                               ||'--------------> Bit 1 of Pixel 2
;                               |'---------------> Bit 1 of Pixel 1
;                               '----------------> Bit 1 of Pixel 0
;
;                 WORD 2 : Bits FEDCBA9876543210
;                               |||||||||||||||'-> Bit 2 of Pixel F
;                               ||||||||||||||'--> Bit 2 of Pixel E 
;                               |||||||||||||'---> Bit 2 of Pixel D
;                               ||||||||||||'----> Bit 2 of Pixel C
;                               |||||||||||'-----> Bit 2 of Pixel B
;                               ||||||||||'------> Bit 2 of Pixel A
;                               |||||||||'-------> Bit 2 of Pixel 9
;                               ||||||||'--------> Bit 2 of Pixel 8
;                               |||||||'---------> Bit 2 of Pixel 7
;                               ||||||'----------> Bit 2 of Pixel 6
;                               |||||'-----------> Bit 2 of Pixel 5
;                               ||||'------------> Bit 2 of Pixel 4
;                               |||'-------------> Bit 2 of Pixel 3
;                               ||'--------------> Bit 2 of Pixel 2
;                               |'---------------> Bit 2 of Pixel 1
;                               '----------------> Bit 2 of Pixel 0
;
;                 WORD 3 : Bits FEDCBA9876543210
;                               |||||||||||||||'-> Bit 3 of Pixel F
;                               ||||||||||||||'--> Bit 3 of Pixel E 
;                               |||||||||||||'---> Bit 3 of Pixel D
;                               ||||||||||||'----> Bit 3 of Pixel C
;                               |||||||||||'-----> Bit 3 of Pixel B
;                               ||||||||||'------> Bit 3 of Pixel A
;                               |||||||||'-------> Bit 3 of Pixel 9
;                               ||||||||'--------> Bit 3 of Pixel 8
;                               |||||||'---------> Bit 3 of Pixel 7
;                               ||||||'----------> Bit 3 of Pixel 6
;                               |||||'-----------> Bit 3 of Pixel 5
;                               ||||'------------> Bit 3 of Pixel 4
;                               |||'-------------> Bit 3 of Pixel 3
;                               ||'--------------> Bit 3 of Pixel 2
;                               |'---------------> Bit 3 of Pixel 1
;                               '----------------> Bit 3 of Pixel 0
;
;   Silly, isn't it ? Imagine in 256 Colors, 8 Planes, AArrrrgggg...
;
; SYI	w $FFFF8A22.w	Source Y Increment
; 16 Bits register
; Signed & Even
;
; SADDR	l $FFFF8A24.w	Source Address Register
; 24 Bits register		Address of the Source Block IN STRam ONLY
;
; ENDM1	w $FFFF8A28.w	EndMask 1
; 16 Bits register
; ENDM2	w $FFFF8A2A.w	EndMask 2
; 16 Bits register
; ENDM3	w $FFFF8A2C.w	EndMask 3
; 16 Bits register
;
; DXI	w $FFFF8A2E.w	Destination X Increment
; 16 Bits register		Same as SXI, but for the Destination
; Signed & Even
;
; DYI	w $FFFF8A30.w	Destination Y Increment
; 16 Bits register		Same as SYI, but for the Destination
; Signed & Even
;
;   NOTE : You can convert Blocks type because you can specify the Source
;          type and the Destination type !!!
;
; DADDR	l $FFFF8A32.w	Destination Address Register
; 24 Bits register		Address of the Destination Block IN STRam ONLY
;
; WPL	w $FFFF8A36.w	Words Per Line IN WORD !
; 16 Bits register		0 -> 65536
;
; LPB	w $FFFF8A38.w	Lines Per Block
; 16 Bits register		0 -> 65536
;
; HOR-LOR            2*	b $FFFF8A3A.w	HalfTone Operation Register - Logical Operation Register
;                                               Bit ......98 ....3210
;		          ||     '+++-> LOR
;		          '+----------> HOR
;  2 Bits register	HOR	Bit 98
;		    00 All Ones
;		    01 HalfTone
;		    10 Source
;		    11 Source AND HalfTone
;
;  4 Bits register	LOR	Bit 3210
;		    0000 0000000000000000
;		    0001  Source AND  Destination
;		    0010  Source AND /Destination
;		    0011  Source
;		    0100 /Source AND  Destination
;		    0101              Destination
;		    0110  Source XOR  Destination
;		    0111  Source  OR  Destination
;		    1000 /Source AND /Destination
;		    1001 /Source XOR  Destination
;		    1010             /Destination
;		    1011  Source  OR /Destination
;		    1100 /Source
;		    1101 /Source  OR  Destination
;		    1110 /Source  OR /Destination
;		    1111 1111111111111111
;
; LNR-SKEW           2*	b $FFFF8A3C.w	Line Number Register        - SKEW Register
;                                               Bit FED.BA98 76..3210
;		    ||| |||| '+--++++-> SKEW
;		    '++-++++----------> LNR
;  8 Bits register	LNR	Bit FED.BA98
;		        '+++-> Dynamic HalfTone Line Number
;		      1      SMUDGE Mode
;		     0       Share Bus
;		     1       Hog Bus
;		    1        Busy/Start
;
;   NOTE : When SMUDGE selected, the Dynamic HalfTone Line Number is NOT the
;          HalfTone Line Number used in HalfTone Operations, but the 4 LSBits from
;          the Datas just moved. According to ATARI, it COULD gives Special Effects.
;
;  8 Bits register	SKEW	Bit 76..3210
;		        '+++-> Source SKEW
;		     1       No Final    Source Read
;		    1        Force eXtra Source Read
;

MINID2D_BlitterCopy	move.b	$FFFF8007.w,D0
	ori.b	#5,D0	; Force to 16MHz
	move.b	D0,$FFFF8007.w

	clr.l	$FFFF8A00.w	; HTRAM 0-1
	clr.l	$FFFF8A04.w	; HTRAM 2-3
	clr.l	$FFFF8A08.w	; HTRAM 4-5
	clr.l	$FFFF8A0C.w	; HTRAM 6-7
	clr.l	$FFFF8A10.w	; HTRAM 8-9
	clr.l	$FFFF8A14.w	; HTRAM A-B
	clr.l	$FFFF8A18.w	; HTRAM C-D
	clr.l	$FFFF8A1C.w	; HTRAM E-F
	move.w	#2,$FFFF8A20.w	; SXI
	clr.w	$FFFF8A22.w	; SYI
	move.l	ScreenData,$FFFF8A24.w	; SADDR
	move.w	#-1,$FFFF8A28.w	; ENDM1
	move.w	#-1,$FFFF8A2A.w	; ENDM2
	move.w	#-1,$FFFF8A2C.w	; ENDM3
	move.w	#2,$FFFF8A2E.w	; DXI
	clr.w	$FFFF8A30.w	; DYI
	move.l	ScreenBank,$FFFF8A32.w	; DADDR
	move.w	#21120,$FFFF8A36.w	; WPL
	move.w	#1,$FFFF8A38.w	; LPB
	move.w	#$0203,$FFFF8A3A.w	; HOR-LOR
	move.w	#$C040,$FFFF8A3C.w	; LNR-SKEW
	
MINID2D_Blitter_Wait	btst.b	#7,$FFFF8A3C.w
	BNE	MINID2D_Blitter_Wait

	RTS

; - Window CPU (176*120) -WINDOW_CPU-> (352*240) - ----------------------------

WINDOW_CPU	move.l	ScreenData,A0
	move.l	ScreenBank,A1
	
	adda.l	#42416,A1
	
	move.w	#120-1,D6

WINDCPU_ScanYLoop	swap	D6
	move.w	#88-1,D6

WINDCPU_ScanXLoop	move.l	(A0)+,(A1)+
	
	DBF	D6,WINDCPU_ScanXLoop

	adda.l	#352,A1
	
	swap	D6
	DBF	D6,WINDCPU_ScanYLoop

	RTS
	
; - Window BLITTER (176*120) -WINDOW_BLITTER-> (352*240) - --------------------

WINDOW_BLITTER	pea	WINDBLIT_BlitterCopy
	move.w	#$26,-(SP)	; - SUPEXEC -
	trap	#14	; *** XBIOS ***
	addq.l	#6,SP

	RTS
 
WINDBLIT_BlitterCopy	move.b	$FFFF8007.w,D0
	ori.b	#5,D0	; Force to 16MHz
	move.b	D0,$FFFF8007.w

	clr.l	$FFFF8A00.w	; HTRAM 0-1
	clr.l	$FFFF8A04.w	; HTRAM 2-3
	clr.l	$FFFF8A08.w	; HTRAM 4-5
	clr.l	$FFFF8A0C.w	; HTRAM 6-7
	clr.l	$FFFF8A10.w	; HTRAM 8-9
	clr.l	$FFFF8A14.w	; HTRAM A-B
	clr.l	$FFFF8A18.w	; HTRAM C-D
	clr.l	$FFFF8A1C.w	; HTRAM E-F
	move.w	#2,$FFFF8A20.w	; SXI
	move.w	#2+2,$FFFF8A22.w	; SYI (+2 because "No eXtra Source Read" /SKEW)
	move.l	ScreenData,$FFFF8A24.w	; SADDR
	move.w	#-1,$FFFF8A28.w	; ENDM1
	move.w	#-1,$FFFF8A2A.w	; ENDM2
	move.w	#-1,$FFFF8A2C.w	; ENDM3
	move.w	#2,$FFFF8A2E.w	; DXI
	move.w	#354,$FFFF8A30.w	; DYI
	move.l	ScreenBank,D0
	add.l	#42416,D0
	move.l	D0,$FFFF8A32.w	; DADDR
	move.w	#176,$FFFF8A36.w	; WPL
	move.w	#120,$FFFF8A38.w	; LPB
	move.w	#$0203,$FFFF8A3A.w	; HOR-LOR
	move.w	#$C040,$FFFF8A3C.w	; LNR-SKEW
	
WINDBLIT_Blitter_Wait	btst.b	#7,$FFFF8A3C.w
	BNE	WINDBLIT_Blitter_Wait

	RTS

; - Zoom CPU (176*120) -ZOOM_CPU-> (352*240) - --------------------------------

ZOOM_CPU	move.l	ScreenData,A0
	move.l	ScreenBank,A1
	
	move.w	#120-1,D6

ZOOMCPU_ScanYLoop	swap	D6
	move.w	#176-1,D6
	
	move.l	A1,A2

ZOOMCPU_ScanXLoop	move.w	(A0)+,D1
	move.w	D1,D0
	swap	D0
	move.w	D1,D0
	move.l	D0,(A1)+

	DBF	D6,ZOOMCPU_ScanXLoop
	
	move.w	#176-1,D6
	
ZOOMCPU_ScanZLoop	move.l	(A2)+,(A1)+

	DBF	D6,ZOOMCPU_ScanZLoop
	
	swap	D6
	DBF	D6,ZOOMCPU_ScanYLoop

	RTS
	
; - Zoom BLITTER (176*120) -ZOOM_BLITTER-> (352*240) - ------------------------
	
ZOOM_BLITTER	pea	ZOOMBLIT_BlitterZoom
	move.w	#$26,-(SP)	; - SUPEXEC -
	trap	#14	; *** XBIOS ***
	addq.l	#6,SP

	RTS

; /// BLITTER Zoom Systems - KOSS (c) 1999 ///
;
; Zooming a Picture using the ATARI Blitter... - KOSS (c) 1999
;
; Solution 1 : The slowest, but the easiest - 3 scan
;              Imagine a 2*2 Image for a 4*4 Screen (Exact 2 Zoom Method)
;              WARNING : The Image is 1 WORD PER PIXEL (NTC)
;
;                        C0 C1           C0 C1 C2 C3
;                       ,--+--,         ,--+--+--+--,
;                    L0 | A| B|      L0 |  |  |  |  |
;                       +--+--+         +--+--+--+--+
;                    L1 | C| D|      L1 |  |  |  |  |
;                       '--+--'         +--+--+--+--+
;                                    L2 |  |  |  |  |
;                                       +--+--+--+--+
;                                    L3 |  |  |  |  |
;                                       '--+--+--+--'
;
;   Scan 1 : Copying Pixels as a Grid
;
; SXI = 2                C0 C1           C0 C1 C2 C3
; SYI = 2 (*)           ,--+--,         ,--+--+--+--,
; Src = Image        L0 | A| B|      L0 |*A|  |*B|  |
; DXI = 4               +--+--+         +--+--+--+--+
; DYI = 8+(2*2)      L1 | C| D|      L1 |  |  |  |  |
; Dst = Screen          '--+--'         +--+--+--+--+
; WPL = 2                            L2 |*C|  |*D|  |
; LPB = 2                               +--+--+--+--+
;                                    L3 |  |  |  |  |
;                                       '--+--+--+--'
; (*)   : +2 if No eXtra Source Read /SKEW
; (2*2) : Like SYI, but 2 times for the 2 lines jumped
; DXI = 4  , 4 for C0L0 to C2L0 (*A to *B) for example
; DYI = 8+4, 8 for C2L0 to C2L1 (*B to   )
;            4 for C2L1 to C0L2 (   to *C)
;
;   Scan 2 : Copying Pixels as a Grid JUST SIDE to the Previous
;
; SXI = 2                C0 C1           C0 C1 C2 C3
; SYI = 2 (*)           ,--+--,         ,--+--+--+--,
; Src = Image        L0 | A| B|      L0 | A|*A| B|*B|
; DXI = 4               +--+--+         +--+--+--+--+
; DYI = 8+(2*2)      L1 | C| D|      L1 |  |  |  |  |
; Dst = Screen+2        '--+--'         +--+--+--+--+
; WPL = 2                            L2 | C|*C| D|*D|
; LPB = 2                               +--+--+--+--+
;                                    L3 |  |  |  |  |
;                                       '--+--+--+--'
; (*)   : +2 if No eXtra Source Read /SKEW
; (2*2) : Like SYI, but 2 times for the 2 lines jumped
; DXI = 4  , 4 for C1L0 to C3L0 (*A to *B) for example
; DYI = 8+4, 8 for C3L0 to C3L1 (*B to   )
;            4 for C3L1 to C1L2 (   to *C)
;
;   Scan 3 : Copying Lines to Fill Blanks Ones
;
; SXI = 2                C0 C1           C0 C1 C2 C3
; SYI = 8+2 (*)         ,--+--,         ,--+--+--+--,
; Src = Screen       L0 | A| B|      L0 | A| A| B| B|--,
; DXI = 2               +--+--+         +--+--+--+--+  |
; DYI = 8+2 (#)      L1 | C| D|      L1 |*A|*A|*B|*B|<-'
; Dst = Screen+8        '--+--'         +--+--+--+--+
; WPL = 4                            L2 | C| C| D| D|--,
; LPB = 2                               +--+--+--+--+  |
;                                    L3 |*C|*C|*D|*D|<-'
;                                       '--+--+--+--'
; (*)   : +2 if No eXtra Source Read /SKEW
; (#)   : Strange, isn't it ? No, read what is just following...
; DXI = 2  , 2 for C0L1 to C1L1 (*A to *A) for example
; DYI = 8+2, 8 for C3L1 to C3L2 (*B to  D)
;            2 for C3L2 to C0L3 ( D to *C)
;
; Note for RGB : ZoomCPU     is given @ 10.9 FPS
;                ZoomBLITTER            11.1 FPS
; That is to say : CPU     Read         1 *  42240 =   42240 bytes
;                          Write        1 * 168960 =  168960 bytes
;                          Scan     42240 + 168960 =  211200 bytes
;                       -> Average 211200 *   10.9 = 2302080 bytes per second (2.19Mb/s)
;
;                  BLITTER Read         2 *  42240 =   84480 bytes (Scan 1 & 2)
;                                     + 1 *  84480 =   84480 bytes (Scan 3)
;                                     --------------> 168960 bytes
;                          Write        2 *  42240 =   84480 bytes (Scan 1 & 2)
;                                     + 1 *  84480 =   84480 bytes (Scan 3)
;                                     --------------> 168960 bytes
;                          Scan    168960 + 168960 =  337920 bytes
;                       -> Average 337920 *   11.1 = 3750912 bytes per second (3.57Mb/s) !!!
;
; So, BLITTER is 'just' 61.4% faster than CPU ;) in RGB (66.3% in VGA !!)
;

ZOOMBLIT_BlitterZoom	move.b	$FFFF8007.w,D0
	ori.b	#5,D0	; Force to 16MHz
	move.b	D0,$FFFF8007.w
	
	clr.l	$FFFF8A00.w	; HTRAM 0-1
	clr.l	$FFFF8A04.w	; HTRAM 2-3
	clr.l	$FFFF8A08.w	; HTRAM 4-5
	clr.l	$FFFF8A0C.w	; HTRAM 6-7
	clr.l	$FFFF8A10.w	; HTRAM 8-9
	clr.l	$FFFF8A14.w	; HTRAM A-B
	clr.l	$FFFF8A18.w	; HTRAM C-D
	clr.l	$FFFF8A1C.w	; HTRAM E-F
	move.w	#2,$FFFF8A20.w	; SXI
	move.w	#2+2,$FFFF8A22.w	; SYI (+2 because "No eXtra Source Read" /SKEW)
	move.l	ScreenData,$FFFF8A24.w	; SADDR
	move.w	#-1,$FFFF8A28.w	; ENDM1
	move.w	#-1,$FFFF8A2A.w	; ENDM2
	move.w	#-1,$FFFF8A2C.w	; ENDM3
	move.w	#4,$FFFF8A2E.w	; DXI
	move.w	#704+4,$FFFF8A30.w	; DYI
	move.l	ScreenBank,$FFFF8A32.w	; DADDR
	move.w	#176,$FFFF8A36.w	; WPL
	move.w	#120,$FFFF8A38.w	; LPB
	move.w	#$0203,$FFFF8A3A.w	; HOR-LOR
	move.w	#$C040,$FFFF8A3C.w	; LNR-SKEW
	
ZOOMBLIT_Blitter1Wait	btst.b	#7,$FFFF8A3C.w
	BNE	ZOOMBLIT_Blitter1Wait
	
	; HalfTone RAM already to 0
	
;	clr.l	$FFFF8A00.w	; HTRAM 0-1
;	clr.l	$FFFF8A04.w	; HTRAM 2-3
;	clr.l	$FFFF8A08.w	; HTRAM 4-5
;	clr.l	$FFFF8A0C.w	; HTRAM 6-7
;	clr.l	$FFFF8A10.w	; HTRAM 8-9
;	clr.l	$FFFF8A14.w	; HTRAM A-B
;	clr.l	$FFFF8A18.w	; HTRAM C-D
;	clr.l	$FFFF8A1C.w	; HTRAM E-F
	move.w	#2,$FFFF8A20.w	; SXI
	move.w	#2+2,$FFFF8A22.w	; SYI (+2 because "No eXtra Source Read" /SKEW)
	move.l	ScreenData,$FFFF8A24.w	; SADDR
	move.w	#-1,$FFFF8A28.w	; ENDM1
	move.w	#-1,$FFFF8A2A.w	; ENDM2
	move.w	#-1,$FFFF8A2C.w	; ENDM3
	move.w	#4,$FFFF8A2E.w	; DXI
	move.w	#704+4,$FFFF8A30.w	; DYI
	move.l	ScreenBank,D0
	addq.l	#2,D0
	move.l	D0,$FFFF8A32.w	; DADDR
	move.w	#176,$FFFF8A36.w	; WPL
	move.w	#120,$FFFF8A38.w	; LPB
	move.w	#$0203,$FFFF8A3A.w	; HOR-LOR
	move.w	#$C040,$FFFF8A3C.w	; LNR-SKEW
	
ZOOMBLIT_Blitter2Wait	btst.b	#7,$FFFF8A3C.w
	BNE	ZOOMBLIT_Blitter2Wait

	; HalfTone RAM already to 0
	
;	clr.l	$FFFF8A00.w	; HTRAM 0-1
;	clr.l	$FFFF8A04.w	; HTRAM 2-3
;	clr.l	$FFFF8A08.w	; HTRAM 4-5
;	clr.l	$FFFF8A0C.w	; HTRAM 6-7
;	clr.l	$FFFF8A10.w	; HTRAM 8-9
;	clr.l	$FFFF8A14.w	; HTRAM A-B
;	clr.l	$FFFF8A18.w	; HTRAM C-D
;	clr.l	$FFFF8A1C.w	; HTRAM E-F
	move.w	#2,$FFFF8A20.w	; SXI
	move.w	#704+2+2,$FFFF8A22.w	; SYI (+2 because "No eXtra Source Read" /SKEW)
	move.l	ScreenBank,$FFFF8A24.w	; SADDR
	move.w	#-1,$FFFF8A28.w	; ENDM1
	move.w	#-1,$FFFF8A2A.w	; ENDM2
	move.w	#-1,$FFFF8A2C.w	; ENDM3
	move.w	#2,$FFFF8A2E.w	; DXI
	move.w	#704+2,$FFFF8A30.w	; DYI
	move.l	ScreenBank,D0
	add.l	#704,D0
	move.l	D0,$FFFF8A32.w	; DADDR
	move.w	#352,$FFFF8A36.w	; WPL
	move.w	#120,$FFFF8A38.w	; LPB
	move.w	#$0203,$FFFF8A3A.w	; HOR-LOR
	move.w	#$C040,$FFFF8A3C.w	; LNR-SKEW
	
ZOOMBLIT_Blitter3Wait	btst.b	#7,$FFFF8A3C.w
	BNE	ZOOMBLIT_Blitter3Wait

	RTS

; - Interpolate 68000 (176*120) -INTER_000-> (352*240) - ----------------------
; Linear Interpolate System for 68000 by KOSS (c) 1999
; Data Registers are used for accessing the less possible the Memory

INTER_000	move.l	ScreenData,A0
	move.l	ScreenBank,A1
	
	move.w	#120-2,D6	; -1

INTER000_ScanYLoop	swap	D6
	move.w	#176-2,D6	; -1
	
INTER000_ScanXLoop	move.w	(A0),D2	; BlueA
	move.w	D2,D1	; GreenA
	move.w	D2,D0	; RedA
	andi.w	#%11111,D2
	andi.w	#%11111100000,D1
	ror.w	#5,D1
	andi.w	#%1111100000000000,D0
	rol.w	#5,D0
			; D0 = R1  ''      r
			; D1 = R2  ''      g
			; D2 = R3''''      b
			; D3 = G1  '' B1  ''
			; D4 = G2  '' B2  ''
			; D5 = G3'''' B3''''

			; Blue
	move.w	D2,D5	; D5 = G3'''' B3'''"
	move.w	D2,D4	; D4 = G2  '' B2  '"
	move.w	D2,D3	; D3 = G1  '' B1  '"
	swap	D5	; D5 = B3'''" G3''''
	swap	D4	; D4 = B2  '" G2  ''
	swap	D3	; D3 = B1  '" G1  ''
	
			; Green
	move.w	D1,D5	; D5 = B3'''" G3'''"
	move.w	D1,D4	; D4 = B2  '" G2  '"
	move.w	D1,D3	; D3 = B1  '" G1  '"
	swap	D5	; D5 = G3'''" B3'''"
	swap	D4	; D4 = G2  '" B2  '"
	swap	D3	; D3 = G1  '" B1  '"
	
			; Red
	swap	D1	; D1 =      g R2  ''
	swap	D2	; D2 =      b R3''''
	move.w	D0,D1	; D1 =      g R2  '"
	move.w	D0,D2	; D2 =      b R3'''"
	swap	D0	; D0 =      r R1  ''
	move.w	D1,D0	; D0 =      r R1  '"
	swap	D0	; D0 = R1  '"      r
	swap	D1	; D1 = R2  '"      g
	swap	D2	; D2 = R3'''"      b
	
	move.w	(2,A0),D2	; BlueB
	move.w	D2,D1	; GreenB
	move.w	D2,D0	; RedB
	andi.w	#%11111,D2
	andi.w	#%11111100000,D1
	ror.w	#5,D1
	andi.w	#%1111100000000000,D0
	rol.w	#5,D0

			; D0 = R1  '"      r
			; D1 = R2  '"      g
			; D2 = R3'''"      b
			; D3 = G1  '" B1  '"
			; D4 = G2  '" B2  '"
			; D5 = G3'''" B3'''"
	
			; Blue
	add.w	D2,D5	; D5 = G3'''" B3''""
	add.w	D2,D3	; D3 = G1  '" B1  ""
	swap	D5	; D5 = B3''"" G3'''"
	swap	D3	; D3 = B1  "" G1  '"
	
			; Green
	add.w	D1,D5	; D5 = B3''"" G3''""
	add.w	D1,D3	; D3 = B1  "" G1  ""
	swap	D5	; D5 = G3''"" B3''""
	
			; Red
	move.w	D0,D1	; D1 = R2  '"      r
	swap	D2	; D2 =      b R3'''"
	add.w	D1,D2	; D2 =      b R3''""
	swap	D2	; D2 = R3''""      b
	swap	D0	; D0 =      r R1  '"
	add.w	D1,D0	; D0 =      r R1  ""
	
	clr.w	D1	; D1 = R2  '"    ...
	lsr.w	#1,D0	; D0 =      r      R
	or.w	D0,D1	; D1 = R2  '"    ..R
	swap	D0	; D0 =      R      r
	lsl.w	#6,D1	; D1 = R2  '"    .R.
	lsr.w	#1,D3	; D3 = B1  ""      G
	or.w	D3,D1	; D1 = R2  '"    .RG
	lsl.w	#5,D1	; D1 = R2  '"    RG.
	swap	D3	; D3 =      G B1  ""
	lsr.w	#1,D3	; D3 =      G      B
	or.w	D3,D1	; D1 = R2  '"    RGB
	
	move.w	(A0),(A1)	; A
	move.w	D1,(2,A1)	; 1
	
	move.w	(352,A0),D2	; BlueC
	move.w	D2,D1	; GreenC
	move.w	D2,D0	; RedC
	andi.w	#%11111,D2
	andi.w	#%11111100000,D1
	ror.w	#5,D1
	andi.w	#%1111100000000000,D0
	rol.w	#5,D0

			; D0 =      .      r
			; D1 = R2  '"      g
			; D2 = R3''""      b
			; D3 =      .      .
			; D4 = G2  '" B2  '"
			; D5 = G3''"" B3''""
	
			; Blue
	add.w	D2,D5	; D5 = G3''"" B3'"""
	add.w	D2,D4	; D4 = G2  '" B2  ""
	swap	D5	; D5 = B3'""" G3''""
	swap	D4	; D4 = B2  "" G2  '"
	
			; Green
	add.w	D1,D5	; D5 = B3'""" G3'"""
	add.w	D1,D4	; D4 = B2  "" G2  ""
	swap	D5	; D5 = G3'""" B3'"""
	
			; Red
	swap	D2	; D2 =      b R3''""
	add.w	D0,D2	; D2 =      b R3'"""
	swap	D2	; D2 = R3'"""      b
	swap	D1	; D1 =      g R2  '"
	add.w	D0,D1	; D1 =      g R2  ""
	
	clr.w	D0	; D0 =      .    ...
	lsr.w	#1,D1	; D1 =      g    ..R
	or.w	D1,D0	; D0 =      .    ..R
	lsl.w	#6,D0	; D0 =      .    .R.
	lsr.w	#1,D4	; D4 = B2  ""      G
	or.w	D4,D0	; D0 =      .    .RG
	lsl.w	#5,D0	; D0 =      .    RG.
	swap	D4	; D4 =      G B2  ""
	lsr.w	#1,D4	; D4 =      G      B
	or.w	D4,D0	; D0 =      .    RGB
	
	move.w	D0,(704,A1)	; 2

	move.w	(354,A0),D2	; BlueD
	move.w	D2,D1	; GreenD
	move.w	D2,D0	; RedD
	andi.w	#%11111,D2
	andi.w	#%11111100000,D1
	ror.w	#5,D1
	andi.w	#%1111100000000000,D0
	rol.w	#5,D0

			; D0 =      .      r
			; D1 =      .      g
			; D2 = R3'"""      b
			; D3 =      .      .
			; D4 =      .      .
			; D5 = G3'""" B3'"""
	
			; Blue
	add.w	D2,D5	; D5 = G3'""" B3""""
	swap	D5	; D5 = B3"""" G3'"""
	
			; Green
	add.w	D1,D5	; D5 = B3"""" G3""""
	
			; Red
	swap	D2	; D2 =      b R3'"""
	add.w	D0,D2	; D2 =      b R3""""
	
	clr.w	D0	; D0 =      .    ...
	lsr.w	#2,D2	; D2 =      b    ..R
	or.w	D2,D0	; D0 =      .    ..R
	lsl.w	#6,D0	; D0 =      .    .R.
	lsr.w	#2,D5	; D5 = B3""""      G
	or.w	D5,D0	; D0 =      .    .RG
	lsl.w	#5,D0	; D0 =      .    RG.
	swap	D5	; D5 =      G B3""""
	lsr.w	#2,D5	; D5 =      G      B
	or.w	D5,D0	; D0 =      .    RGB
	
	move.w	D0,(706,A1)	; 3

	addq.l	#2,A0
	addq.l	#4,A1

	DBF	D6,INTER000_ScanXLoop
	
	move.w	(A0),D2	; BlueA
	move.w	D2,D1	; GreenA
	move.w	D2,D0	; RedA
	andi.w	#%11111,D2
	andi.w	#%11111100000,D1
	ror.w	#5,D1
	andi.w	#%1111100000000000,D0
	rol.w	#5,D0

	move.w	(352,A0),D5	; BlueC
	move.w	D5,D4	; GreenC
	move.w	D5,D3	; RedC
	andi.w	#%11111,D5
	andi.w	#%11111100000,D4
	ror.w	#5,D4
	andi.w	#%1111100000000000,D3
	rol.w	#5,D3

	add.w	D3,D0
	add.w	D4,D1
	add.w	D5,D2
	
	lsr.w	#1,D0
	lsr.w	#1,D1
	lsr.w	#1,D2
	
	lsl.w	#6,D0
	or.w	D1,D0
	lsl.w	#5,D0
	or.w	D2,D0
	
	move.w	(A0)+,(A1)
	clr.w	(2,A1)
	move.w	D0,(704,A1)
	clr.w	(706,A1)
	
	adda.l	#708,A1
	
	swap	D6
	DBF	D6,INTER000_ScanYLoop
	
	move.w	#176-2,D6	; -1
	
INTER000_ScanLastLine	move.w	(A0),D2	; BlueA
	move.w	D2,D1	; GreenA
	move.w	D2,D0	; RedA
	andi.w	#%11111,D2
	andi.w	#%11111100000,D1
	ror.w	#5,D1
	andi.w	#%1111100000000000,D0
	rol.w	#5,D0

	move.w	(2,A0),D5	; BlueB
	move.w	D5,D4	; GreenB
	move.w	D5,D3	; RedB
	andi.w	#%11111,D5
	andi.w	#%11111100000,D4
	ror.w	#5,D4
	andi.w	#%1111100000000000,D3
	rol.w	#5,D3

	add.w	D3,D0
	add.w	D4,D1
	add.w	D5,D2
	
	lsr.w	#1,D0
	lsr.w	#1,D1
	lsr.w	#1,D2
	
	lsl.w	#6,D0
	or.w	D1,D0
	lsl.w	#5,D0
	or.w	D2,D0
	
	move.w	(A0)+,(A1)
	move.w	D0,(2,A1)
	clr.w	(704,A1)
	clr.w	(706,A1)

	addq.l	#4,A1

	DBF	D6,INTER000_ScanLastLine
		
	move.w	(A0),(A1)
	clr.w	(2,A1)
	clr.w	(704,A1)
	clr.w	(706,A1)

	RTS
	
; - Interpolate 68030 (176*120) -INTER_030-> (352*240) - ----------------------
; Fast Linear Interpolate System by KOSS (c) 1999
; Fast EVEN IF the bfextu Instruction is quite slow...
;
; WARNING : befxtu Instruction is quite strange...
;
; BitMap of a LONG  : 33222222222211111111110000000000
;                     10987654321098765432109876543210
;
; For bfextu, BM is : 00000000001111111111222222222233
;                     01234567890123456789012345678901
;
; So, when you want Bits 10 to 19, you should give to the
; bfextu Instruction the following arguments : Start  12 (Bits 19)
;                                              Lenght 10
; Then it'll read Bits 19, 18, 17... ,10 and put them in
; the appropriate Data Register in Bits 9 to 0, clearing the others
; Bits.
;
; Why bfextu Instruction works like this ? Easy to say, it's quite
; faster...
;
; Let's see why :
;
; bfextu works ONLY on LONG. LONG is 32 Bits long.
; In Assembly Language, it could give this (Ix is given as
; Internal Register x) : bfextu (A0){16:5},D2
;	
;         	move.w	#5,I0	; Lenght
;	subq.w	#1,I0	; Correct for DBF
;
;	move.l	(A0),I1	; Data Code
;	rol.l	#16,I1	; Start Bit in BM 31
;
;	clr.l	D2	; Clean
;
; BM_CopyLoop	roxl.l	#1,I1	; Bit BM 31 in eXtend
;	roxl.l	#1,D2	; Load eXtend in D2
;	
;	DBF	I0,BM_CopyLoop	
;         

INTER_030	move.l	ScreenData,A0
	move.l	ScreenBank,A1
	
	move.w	#120-2,D6	; -1

INTER030_ScanYLoop	swap	D6
	move.w	#176-2,D6	; -1
	
INTER030_ScanXLoop	; Interpolation 
	; A 1 B
	; 2 3
	; C   D
	;

	; A 1 B

	clr.w	D0
	
	bfextu	(A0){0:5},D1	; RedA
	bfextu	(A0){16:5},D2	; RedB
	add.w	D2,D1
	move.l	D1,D3	; Final Red
	lsr.w	#1,D1
	or.w	D1,D0
	lsl.w	#6,D0

	bfextu	(A0){5:6},D1	; GreenA
	bfextu	(A0){21:6},D2	; GreenB
	add.w	D2,D1
	move.l	D1,D4	; Final Green
	lsr.w	#1,D1
	or.w	D1,D0
	lsl.w	#5,D0
	
	bfextu	(A0){11:5},D1	; BlueA
	bfextu	(A0){27:5},D2	; BlueB
	add.w	D2,D1
	move.l	D1,D5	; Final Blue
	lsr.w	#1,D1
	or.w	D1,D0
	
	move.w	(A0),(A1)	; A
	move.w	D0,(2,A1)	; 1
	
	; A 
	; 2
	; C
	
	clr.w	D0
	
	bfextu	(A0){0:5},D1	; RedA
	bfextu	(352,A0){0:5},D2	; RedC
	add.w	D2,D1
	add.w	D2,D3	; Final Red
	lsr.w	#1,D1
	or.w	D1,D0
	lsl.w	#6,D0

	bfextu	(A0){5:6},D1	; GreenA
	bfextu	(352,A0){5:6},D2	; GreenC
	add.w	D2,D1
	add.w	D2,D4	; Final Green
	lsr.w	#1,D1
	or.w	D1,D0
	lsl.w	#5,D0
	
	bfextu	(A0){11:5},D1	; BlueA
	bfextu	(352,A0){11:5},D2	; BlueC
	add.w	D2,D1
	add.w	D2,D5	; Final Blue
	lsr.w	#1,D1
	or.w	D1,D0
	
	move.w	D0,(704,A1)	; 2

	; A  B
	;  3
	; C  D

	clr.w	D0
	
	bfextu	(352,A0){16:5},D2	; RedD
	add.w	D2,D3	; Final Red
	lsr.w	#2,D3
	or.w	D3,D0
	lsl.w	#6,D0

	bfextu	(352,A0){21:6},D2	; GreenD
	add.w	D2,D4	; Final Green
	lsr.w	#2,D4
	or.w	D4,D0
	lsl.w	#5,D0
	
	bfextu	(352,A0){27:5},D2	; BlueD
	add.w	D2,D5	; Final Blue
	lsr.w	#2,D5
	or.w	D5,D0

	move.w	D0,(706,A1)	; 3

	addq.l	#2,A0
	addq.l	#4,A1

	DBF	D6,INTER030_ScanXLoop
	
	; Interpolation
	; A 0
	; 2 0
	; C
	
	clr.w	D0
	
	bfextu	(A0){0:5},D1	; RedA
	bfextu	(352,A0){0:5},D2	; RedC
	add.w	D2,D1
	lsr.w	#1,D1
	or.w	D1,D0
	lsl.w	#6,D0

	bfextu	(A0){5:6},D1	; GreenA
	bfextu	(352,A0){5:6},D2	; GreenC
	add.w	D2,D1
	lsr.w	#1,D1
	or.w	D1,D0
	lsl.w	#5,D0
	
	bfextu	(A0){11:5},D1	; BlueA
	bfextu	(A0+352){11:5},D2	; BlueC
	add.w	D2,D1
	lsr.w	#1,D1
	or.w	D1,D0
			
	move.w	(A0)+,(A1)
	clr.w	(2,A1)
	move.w	D0,(704,A1)	; 2
	clr.w	(706,A1)	
	
	adda.l	#708,A1
	
	swap	D6
	DBF	D6,INTER030_ScanYLoop
	
	move.w	#176-2,D6	; -1
	
INTER030_ScanLastLine	; Interpolation
	; A 1 B
	; 0 0
	;
	
	clr.w	D0
	
	bfextu	(A0){0:5},D1	; RedA
	bfextu	(A0){16:5},D2	; RedB
	add.w	D2,D1
	lsr.w	#1,D1
	or.w	D1,D0
	lsl.w	#6,D0

	bfextu	(A0){5:6},D1	; GreenA
	bfextu	(A0){21:6},D2	; GreenB
	add.w	D2,D1
	lsr.w	#1,D1
	or.w	D1,D0
	lsl.w	#5,D0
	
	bfextu	(A0){11:5},D1	; BlueA
	bfextu	(A0){27:5},D2	; BlueB
	add.w	D2,D1
	lsr.w	#1,D1
	or.w	D1,D0
	
	move.w	(A0)+,(A1)
	move.w	D0,(2,A1)
	clr.w	(704,A1)
	clr.w	(706,A1)

	addq.l	#4,A1

	DBF	D6,INTER030_ScanLastLine
	
	; Copie
	; A 0
	; 0 0
	;
	
	move.w	(A0),(A1)
	clr.w	(2,A1)
	clr.w	(704,A1)
	clr.w	(706,A1)

	RTS

; *****************************************************************************	
	
; *****************************************************************************	
	SECTION	DATA
; *****************************************************************************	
			
	; Les Routines d'Affichage
	; Display Routines

DisplayBank	dc.l	MINID2D_CPU,MINID2D_BLITTER
	dc.l	WINDOW_CPU,WINDOW_BLITTER
	dc.l	ZOOM_CPU,ZOOM_BLITTER
	dc.l	INTER_000,INTER_030

	; Les Filtres
	; Filters

FilterBank	dc.l	0
	dc.l	Y_FILTER
	dc.l	U_FILTER
	dc.l	V_FILTER
	dc.l	RED_FILTER
	dc.l	GREEN_FILTER
	dc.l	BLUE_FILTER
	dc.l	CYAN_FILTER
	dc.l	YELLOW_FILTER
	dc.l	MAGENTA_FILTER

TargaHeader	dc.w	0
	dc.w	$200
	dc.l	0,0
	dc.w	"xx"
	dc.w	"yy"
	dc.w	$1820
		
; *****************************************************************************	
	SECTION	BSS
; *****************************************************************************	

MovieName	ds.b	256
DisplayRoutine	ds.l	1	; Adresse de la Routine d'Affichage (MINID2D, WINDOW, ...)
DisplayMachine	ds.w	1	; Num‚ro  de la Routine d'Affichage … utiliser
			;  0 : MiniD2D
			;  1 : Window
			;  2 : Zoom
			;  3 : Interpolate
DisplayVersion	ds.w	1	; Version du Filtre … utiliser
			;  0 : Version CPU     (68000 pour Interpolate)
			;  1 : Version BLITTER (68030 pour Interpolate)
DisplayFilter	ds.w	1	; Num‚ro  du Filtre … utiliser
			;  0 : Affichage Direct
			;  1 : Filtre Y
			;  2 : Filtre U
			;  3 : Filtre V
			;  4 : Filtre Rouge
			;  5 : Filtre Vert
			;  6 : Filtre Bleu
			;  7 : Filtre Cyan
			;  8 : Filtre Jaune
			;  9 : Filtre Magenta
DisplayPaper	ds.w	1	; Couleur de la Feuille de Fond
			;  0 : Noir
			; -1 : Blanc
GEMLogic	ds.l	1
GEMPhysic	ds.l	1
PauseFlag	ds.w	1	; Flag de Pause
			;  0 : Lecture
			; -1 : Pause
SequenceFlag	ds.w	1	; Flag de S‚quence
			;  0 : Lecture
			; -1 : Utilisation des Cl‚s
SequenceKeys	ds.w	8	; Les Cl‚s des S‚quences
MovieHandle	ds.w	1
MovieLenght	ds.w	1	; Longueur en Nb d'Image
ScreenData	ds.l	1	; Adresse du Buffer … utiliser
			;  #ScreenBuffer si Affichage Direct (DisplayFilter==0)
			;  #ScreenFilter si application d'un Filtre
ScreenBuffer	ds.b	42240
ScreenFilter	ds.b	42240
ScreenBank	ds.l	2	; Adresse des deux Ecrans
			; ScreenBank   = #LogScreen
			; ScreenBank+4 = #PhyScreen

