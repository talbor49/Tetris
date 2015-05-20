 
 
 
		.486                                                                    ; create 32 bit code
		.model flat, stdcall                                    ; 32 bit memory model
option casemap :none                                      ; case sensitive
		;includes

		include \masm32\include\windows.inc
		include \masm32\include\kernel32.inc
		include \masm32\include\user32.inc
		include \masm32\include\gdi32.inc
		include \masm32\include\Advapi32.inc
		;include \masm32\include\masm32rt.inc
		include \masm32\include\winmm.inc
		include \masm32\include\msvcrt.inc
		includelib \masm32\lib\winmm.lib
		include \masm32\include\msimg32.inc
		includelib \masm32\lib\msimg32.lib
 
 
		include \masm32\include\dialogs.inc      ; macro file for dialogs
		include \masm32\macros\macros.asm              ; masm32 macro file
		includelib \masm32\lib\gdi32.lib
		includelib \masm32\lib\user32.lib
		includelib \masm32\lib\kernel32.lib
		includelib \masm32\lib\Comctl32.lib
		includelib \masm32\lib\comdlg32.lib
		includelib \masm32\lib\shell32.lib
		includelib \masm32\lib\oleaut32.lib
		includelib \masm32\lib\ole32.lib
		includelib \masm32\lib\msvcrt.lib
 
 
		COMMENT @
		
Todo list:
		//1.Change window width and height
		2.Make different game modes
		3.More sound effects
		4.Hurray on clear line
		5.Add online fights
		6.Add difficultys
		7.Fix score
		8.Add leaderboards
		9.Make better design
		//10. Make fullscreen
		11. Add an option to store a block for later
		12. Let you flip block even if you are near a wall
		13. Fix resolution of blocks - maybe implement images instead of rectangles
		14. Add multiplayer on same computer
		15. Fix youlose
		16. Add an option to change music
		@
 
 
		.const
		SCORE_BONUS equ 500
		BUTTONS_MARGIN equ 75
		BLOCK_SIZE equ 40
		MAIN_TIMER_ID equ 0
		ACM_OPEN equ 0400h + 100
		BLACK_THEME equ 1
		WHITE_THEME equ 0
		TM_PAINT equ 1338
		TM_UPDATE equ 1337
		TM_GET_INPUT_FROM_KEYBOARD equ 1336
		INITIAL_UPDATE_TIMER equ 750
		INPUT_FROM_KEYBOARD_DELAY_IN_MENUS equ 20
		INPUT_FROM_KEYBOARD_DELAY_IN_GAME equ 90
		INPUT_FROM_KEYBOARD_DELAY_IN_OPTIONS equ 20
		PAINT_TIME equ 20
		.data
		clickedescapelasttime DWORD 0
		clickedenterlasttime DWORD 0
		clickeddownlasttime DWORD 0
		clickeduplasttime DWORD 0
		clickedrightlasttime DWORD 0
		clickedleftlasttime DWORD 0
		difficulty_factor DWORD 100
		minimumUpdateTimer DWORD 150
		level DWORD 0
		nextBlockType DWORD ?
		nextBlockColor BYTE ?
		upwasclickedlasttime DWORD 0
		changedthemelasttime DWORD 0
		timeLastPutDown DWORD 0
		instructions0 db "Game Controls", 0
		instructions1 db "Right or Left buttons   - move block.",0
		instructions2 db "Up button   - rotate block.", 0
		instructions3 db "Down button  - move the block down faster.", 0 
		instructions4 db "Spacebar - instantly place block.",0
scoretext db "Score: ",0
		hWnd HWND ?
		BitmapsBodyGuard1 db 10000 dup(0)
		randomColor db 0
		timesDidntCheckUp DWORD 0
		marginBetweenButtons DWORD ?
		WindowWidth DWORD 400
		RealWindowWidth DWORD 700
		WindowHeight DWORD 800
		eaxbackup DWORD ?
		ANIMATE_CLASSA  db "SysAnimate32",0
		TimesNewRoman db "Times New Roman", 0
		HPauseScreen HBITMAP ?
		HAboutPage HBITMAP ?
		HStartScreen HBITMAP ?
		HNewGame HBITMAP ?
		HNewGameMask HBITMAP ?
		HHighScores HBITMAP ?
		HHighScoresMask HBITMAP ?
		HOptions HBITMAP ?
		HOptionsMask HBITMAP ?
		HAbout HBITMAP ?
		HAboutMask HBITMAP ?
		HExit HBITMAP ?
		HExitMask HBITMAP ?
		HHighLightBox HBITMAP ?
		HHighLightMask HBITMAP ?
		HResume HBITMAP ?
		HResumeMask HBITMAP ?
		HRestart HBITMAP ?
		HRestartMask HBITMAP ?
		HMainMenu HBITMAP ?
		HMainMenuMask HBITMAP ?
		HTryAgain HBITMAP ?
		HTryAgainMask HBITMAP ?
		HBlackMainMenu HBITMAP ?
		HBlackMainMenuMask HBITMAP ?
		HGameOver HBITMAP ?
		HScore HBITMAP ?
		HScoreMask HBITMAP ?
		HOptionsScreen HBITMAP ?
		HVolumeBar HBITMAP ?
		HVolumeBarMask HBITMAP ?
		HCircle HBITMAP ?
		HCircleMask HBITMAP ?
		HBlackTheme HBITMAP ?
		HWhiteTheme HBITMAP ?
		HBlueRect HBITMAP ?
		HBlueRectMask HBITMAP ?
		HChangeVolume HBITMAP ?
		HChangeVolumeMask HBITMAP ?
		HChangeTheme HBITMAP ?
		HChangeThemeMask HBITMAP ?
 
		HBlackThemeBackground HBITMAP ?
		HWhiteThemeBackground HBITMAP ?
		HScoreBrickBackground HBITMAP ?


		HBlock0 HBITMAP ?
		HBlock1 HBITMAP ?
		HBlock2 HBITMAP ?
		HBlock3 HBITMAP ?
		HBlock4 HBITMAP ?
		HBlock5 HBITMAP ?
		HBlock6 HBITMAP ?
		HBlock255 HBITMAP ?

		BitmapsBodyGuard2 db 10000 dup(0)
		scoreFont HFONT ?
		titleFont HFONT ?
		scoreTitleFont HFONT ?
		theme DWORD BLACK_THEME
		AnimateHWnd HWND ?
		offsetinstring DWORD 0
		created DWORD 0
		score DWORD 0
		scorestring db "000000"
		volume DWORD 00ff00ffh
		CircleX DWORD 200
		playGameOverMusic db "play GameOver.mp3", 0
		playBackgroundMusic db "play tetrissound.wav",0
		freezeBackgroundMusic db "pause tetrissound.wav",0
		resumeBackgroundMusic db "resume tetrissound.wav", 0
		restartBackgroundMusic db "seek tetrissound.wav to start", 0
		playlevelup db "play levelup.wav",0
		playblop db "play blop.mp3", 0
		playwoosh db "play woosh.mp3",0
		FramesPassedSinceLastArrowClick DWORD 30
		highlighted db 0
		highlightedoptionsscreen db 0
		aboutpage db 0
		optionscreenstate db 0
		startscreen db 1
		PauseState BYTE 0
		randombuffer DWORD ?
		BlockType DWORD 3
		BlockMode DWORD 0
		highlightedgameover db 0
		edxbackup DWORD ?
		albackup db ?
		anotherecxbackup DWORD ?
		FullLine db ?
		CurrentColor db 1
		youlosestate db 0
		backupecx DWORD ?
		next2blocks db 1000 dup(0ffh)
		grid DB 10000 dup(00FFh)
		sidebargrid DB 10000 dup (00FFh)
		BlockX DWORD   0
		BlockY DWORD   0
		ClassName          DB     "Tetris",0
		windowTitle      DB       "Tetris",0
 
		startTime DWORD ?
		clickedspacelasttime DWORD 0
 
		.code
 
GetRandomNumber PROC,   blen:BYTE,PointToBuffer:PLONG
local hprovide:HANDLE
		invoke CryptAcquireContext, addr hprovide,0,0,PROV_RSA_FULL,CRYPT_VERIFYCONTEXT or CRYPT_SILENT
		invoke CryptGenRandom, hprovide, blen, PointToBuffer
		invoke CryptReleaseContext,hprovide,0
		ret
GetRandomNumber ENDP
 
TalDiv PROC, divided:DWORD, divisor:DWORD, amountToAdd:DWORD
		pusha
		mov eax, divided
		mov ebx, divisor
		xor edx, edx
		idiv ebx
		add eax, amountToAdd
		mov eaxbackup, eax
		popa
		mov eax, eaxbackup
		ret
TalDiv ENDP
 

 
GetColor PROC, index:BYTE
		;Get color by index
startgetcolor:
		cmp index, 0
		je returnblock0
		cmp index, 1
		je returnblock1
		cmp index, 2
		je returnblock2
		cmp index, 3
		je returnblock3
		cmp index, 4
		je returnblock4
		cmp index, 5
		je returnblock5
		cmp index, 6
		je returnblock6
		int 1Bh ;ERROR
returnblock0:
		mov eax, HBlock0
		ret
returnblock1:
		mov eax, HBlock1
		ret
returnblock2:
		mov eax, HBlock2
		ret
returnblock3:
		mov eax, HBlock3
		ret
returnblock4:
		mov eax, HBlock4
		ret
returnblock5:
		mov eax, HBlock5
		ret
returnblock6:
		mov eax, HBlock6
		ret
GetColor ENDP
 
 
 
 
BUILDRECT          PROC,   x:DWORD,             y:DWORD, h:DWORD,          w:DWORD,             hdc:HDC,                brush:HBRUSH
		;Draw a rectangle
LOCAL rectangle:RECT
		mov eax, x
		mov rectangle.left, eax
		add eax, w
		mov rectangle.right, eax
 
		mov eax, y
		mov rectangle.top, eax
		add eax, h
		mov rectangle.bottom, eax
 
		invoke FillRect, hdc, addr rectangle, brush
		ret
BUILDRECT ENDP
 
 
 
 
 
DrawImage PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD
local hdcMem:HDC
local HOld:HDC
		invoke CreateCompatibleDC, hdc
		mov hdcMem, eax
		invoke SelectObject, hdcMem, img
		mov HOld, eax
		invoke BitBlt,hdc,x,y,RealWindowWidth,WindowHeight,hdcMem,0,0,SRCCOPY
		invoke DeleteDC, HOld
		invoke DeleteDC,hdcMem
		ret
DrawImage ENDP
 
DrawImage_WithStretch PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD,x2:DWORD,y2:DWORD,w:DWORD,h:DWORD,wstrech:DWORD,hstrech:DWORD
		;--------------------------------------------------------------------------------
local hdcMem:HDC
local HOld:HBITMAP
		invoke CreateCompatibleDC, hdc
		mov hdcMem, eax
		invoke SelectObject, hdcMem, img
		mov HOld, eax
		invoke SetStretchBltMode,hdc,COLORONCOLOR
		invoke StretchBlt ,hdc,x,y,wstrech,hstrech,hdcMem,x2,y2,w,h,SRCCOPY
		invoke SelectObject,hdcMem,HOld
		invoke DeleteDC,hdcMem 
		invoke DeleteDC, HOld
		;================================================================================
		ret
DrawImage_WithStretch ENDP
 
DrawImage_WithMask PROC, hdc:HDC, img:HBITMAP, maskedimg:HBITMAP,  x:DWORD, y:DWORD
local hdcMem:HDC
local HOld:HDC
		invoke CreateCompatibleDC, hdc
		mov hdcMem, eax
		invoke SelectObject, hdcMem, maskedimg
		mov HOld, eax
		invoke BitBlt,hdc,x,y,RealWindowWidth,WindowHeight,hdcMem,0,0,SRCAND
               
		invoke SelectObject, hdcMem, img
		invoke BitBlt,hdc,x,y,RealWindowWidth,WindowHeight,hdcMem,0,0,SRCPAINT
		invoke DeleteDC, HOld
		invoke DeleteDC,hdcMem
		ret
DrawImage_WithMask ENDP
 
DrawImage_WithMask_WithResize PROC, hdc:HDC, img:HBITMAP, maskedimg:HBITMAP,  x:DWORD, y:DWORD,w:DWORD,h:DWORD,x2:DWORD,y2:DWORD,wstrech:DWORD,hstrech:DWORD
		;--------------------------------------------------------------------------------
local hdcMem:HDC
local HOld:HDC
		invoke CreateCompatibleDC, hdc
		mov hdcMem, eax
		invoke SelectObject, hdcMem, maskedimg
		invoke SetStretchBltMode,hdc,COLORONCOLOR
		invoke StretchBlt ,hdc,x,y,wstrech,hstrech,hdcMem,x2,y2,w,h,SRCAND
		
		invoke SelectObject, hdcMem, img
		invoke StretchBlt ,hdc,x,y,wstrech,hstrech,hdcMem,x2,y2,w,h,SRCPAINT
		invoke DeleteDC, HOld
		invoke DeleteDC,hdcMem 
		;================================================================================
		ret
DrawImage_WithMask_WithResize ENDP
 
ReadGrid PROC, XIndex:DWORD, YIndex:DWORD
		;Returns grid[XIndex][YIndex]
		mov ebx, offset grid
 
		invoke TalDiv, WindowWidth, BLOCK_SIZE,0
		mov edx, eax
 
		mov eax, YIndex
                 
		imul edx
		add ebx, eax
		add ebx, XIndex
		xor eax, eax
		mov al, BYTE ptr [ebx]

		cmp al, 7
		jl donotbreakpoint

		mov al, al
donotbreakpoint:

		ret
ReadGrid ENDP
 
 
 
 
 
 
 
 
 
 
 
 
myOwnClearScreen PROC, hdc:HDC
local brush:HBRUSH
 
 
		invoke GetStockObject, WHITE_BRUSH
		mov brush, eax
		invoke SelectObject, hdc, brush
		mov ebx, 0
		mov edx, 0
		invoke TalDiv, WindowHeight, BLOCK_SIZE, 0
		mov ecx, eax
loop00:
		mov backupecx, ecx
 
		invoke TalDiv, WindowWidth, BLOCK_SIZE, 0
		mov ecx, eax
 
		mov ebx, 0
loop01:
		pusha                            
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne skipdraw
		popa                                             
		imul ebx, BLOCK_SIZE
		imul edx, BLOCK_SIZE
 
		invoke BUILDRECT, ebx, edx, BLOCK_SIZE-1, BLOCK_SIZE-1, hdc, brush
                                                                           
                           
skipdraw:
		popa
		inc ebx
		loop loop01
		mov ecx, backupecx
		inc edx
		loop loop00
		ret
myOwnClearScreen ENDP
 
 
ReadSideBarGrid PROC, XIndex:DWORD, YIndex:DWORD
		;Returns grid[XIndex][YIndex]
		mov ebx, offset sidebargrid
		mov eax, YIndex
		mov edx, 300/BLOCK_SIZE
		imul edx
		add ebx, eax
		add ebx, XIndex
		xor eax, eax
		mov al, BYTE ptr [ebx]
		ret
ReadSideBarGrid ENDP
 
 
 
 
 
 
myOwnClearSideBarGrid PROC, hdc:HDC
local brush:HBRUSH
 		invoke GetStockObject, WHITE_BRUSH
		mov brush, eax
		invoke SelectObject, hdc, brush
		invoke BUILDRECT, 400, 0, WindowHeight, 300, hdc, brush  ;Draw a rectangle the size of the side bar.
		ret
myOwnClearSideBarGrid ENDP
 
 
 
 
Close PROC 
;Release resources before closing

		invoke DeleteObject, HPauseScreen
		invoke DeleteObject, HAboutPage
		invoke DeleteObject, HStartScreen
		invoke DeleteObject, HNewGame
		invoke DeleteObject, HNewGameMask
		invoke DeleteObject, HHighScores
		invoke DeleteObject, HHighScoresMask
		invoke DeleteObject, HOptions
		invoke DeleteObject, HOptionsMask
		invoke DeleteObject, HAbout
		invoke DeleteObject, HAboutMask
		invoke DeleteObject, HExit
		invoke DeleteObject, HExitMask
		invoke DeleteObject, HHighLightBox
		invoke DeleteObject, HHighLightMask
		invoke DeleteObject, HResume
		invoke DeleteObject, HResumeMask
		invoke DeleteObject, HRestart
		invoke DeleteObject, HRestartMask
		invoke DeleteObject, HMainMenu
		invoke DeleteObject, HMainMenuMask
		invoke DeleteObject, HTryAgain
		invoke DeleteObject, HTryAgainMask
		invoke DeleteObject, HBlackMainMenu
		invoke DeleteObject, HBlackMainMenuMask
		invoke DeleteObject, HGameOver
		invoke DeleteObject, HScore
		invoke DeleteObject, HScoreMask
		invoke DeleteObject, HOptionsScreen
		invoke DeleteObject, HVolumeBar
		invoke DeleteObject, HVolumeBarMask
		invoke DeleteObject, HCircle
		invoke DeleteObject, HCircleMask
		invoke DeleteObject, HBlackTheme
		invoke DeleteObject, HWhiteTheme
		invoke DeleteObject, HBlueRect
		invoke DeleteObject, HBlueRectMask
		invoke DeleteObject, HChangeVolume
		invoke DeleteObject, HChangeVolumeMask
		invoke DeleteObject, HChangeTheme
		invoke DeleteObject, HChangeThemeMask
		invoke DeleteObject, HBlock0
		invoke DeleteObject, HBlock1
		invoke DeleteObject, HBlock2
		invoke DeleteObject, HBlock3
		invoke DeleteObject, HBlock4
		invoke DeleteObject, HBlock5
		invoke DeleteObject, HBlock6
 
		invoke ExitProcess, 0
		ret
Close ENDP
 
 
DrawGrid PROC, hdc:HDC
local Hbmp:HBITMAP
 
		;Draws all the blocks on the grid
 
		mov ebx, 0
		mov edx, 0
		invoke TalDiv, WindowHeight, BLOCK_SIZE,0
		mov ecx, eax
loop00:
		mov backupecx, ecx
		invoke TalDiv, WindowWidth, BLOCK_SIZE,0
		mov ecx, eax
		mov ebx, 0
loop01:
		pusha
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 00FFh
		je skipdrawpopa
		invoke GetColor, al
		mov Hbmp, eax
 
		popa
		imul ebx, BLOCK_SIZE
		imul edx, BLOCK_SIZE
		;invoke BUILDRECT, ebx, edx, BLOCK_SIZE-1, BLOCK_SIZE-1, hdc, brush
		invoke DrawImage, hdc, Hbmp, ebx, edx
		jmp skipdraw
skipdrawpopa:
		popa
                           
skipdraw:
		popa
		inc ebx
		loop loop01
		mov ecx, backupecx
		inc edx
		loop loop00
		ret
DrawGrid ENDP
 
 
DrawSideBarGrid PROC, hdc:HDC, x:DWORD, w:DWORD
local Hbmp:HDC
		;Draws all the blocks on the grid
 
		mov ebx, 0
		mov edx, 0
		mov ecx, BLOCK_SIZE
		mov eax, WindowHeight
		idiv ecx
		mov ecx, eax
loop00:
		mov backupecx,ecx
		invoke TalDiv, w, BLOCK_SIZE, 0
		mov ecx, eax
		mov ebx, 0
loop01:
		pusha
		pusha
		invoke ReadSideBarGrid, ebx, edx
		cmp al, 00FFh
		je skipdraw
		invoke GetColor, al
		mov Hbmp, eax    
 
		popa
		imul ebx, BLOCK_SIZE
		imul edx, BLOCK_SIZE
		add ebx, x
		invoke DrawImage, hdc, Hbmp, ebx, edx

                           
skipdraw:
		popa
		inc ebx
		loop loop01
		mov ecx, backupecx
		inc edx
		loop loop00
		ret
DrawSideBarGrid ENDP
 
 
 
SetSideBarGrid PROC, XIndex:DWORD, YIndex:DWORD, data:BYTE
		;Puts data into sidebargrid[XIndex][YIndex]
		mov ebx, offset sidebargrid
		mov eax, YIndex
		mov edx, 300/BLOCK_SIZE
		imul edx
		add ebx, eax
		add ebx, XIndex
		mov al, data
		mov BYTE ptr [ebx], al
		ret
SetSideBarGrid ENDP
 
 
SetGrid PROC, XIndex:DWORD, YIndex:DWORD, data:BYTE
		;Puts data into grid[XIndex][YIndex]
		cmp data, 7
		jl skipnobreakpoint

		mov al, data

skipnobreakpoint:
		mov ebx, offset grid
		xor edx, edx
		mov eax, WindowWidth
		mov ecx, BLOCK_SIZE
		idiv ecx
		mov edx, eax
		mov eax, YIndex
		imul edx
		add ebx, eax
		add ebx, XIndex
		mov al, data
		mov BYTE ptr [ebx], al
		ret
SetGrid ENDP
 
 
 
 
Get_Handle_To_Mask_Bitmap          PROC,   hbmColour:HBITMAP,     crTransparent:COLORREF
		;--------------------------------------------------------------------------------
local hdcMem:HDC
local hdcMem2:HDC
local hbmMask:HBITMAP
local bm:BITMAP
 
 
		invoke GetObject,hbmColour,SIZEOF(BITMAP),addr bm
		invoke CreateBitmap,bm.bmWidth,bm.bmHeight,1,1,NULL
		mov hbmMask,eax
 
 
		invoke CreateCompatibleDC,NULL
		mov hdcMem,eax
		invoke CreateCompatibleDC,NULL
		mov hdcMem2,eax
 
		invoke SelectObject,hdcMem,hbmColour
		invoke SelectObject,hdcMem2,hbmMask
 
 
		invoke SetBkColor,hdcMem, crTransparent
		invoke BitBlt,hdcMem2, 0, 0, bm.bmWidth, bm.bmHeight, hdcMem, 0, 0, SRCCOPY
		invoke BitBlt,hdcMem, 0, 0, bm.bmWidth, bm.bmHeight, hdcMem2, 0, 0, SRCINVERT
 
		invoke DeleteDC,hdcMem
		invoke DeleteDC,hdcMem2
 
		mov eax,hbmMask
 
		;================================================================================
		ret
Get_Handle_To_Mask_Bitmap ENDP
 
 
 
 
BuildBlock         PROC,   x:DWORD,             y:DWORD, blocktype:DWORD,       blockmode:DWORD, color:BYTE; blockmode ->   0 - down, 1- right, 2-up, 3 - left
		;Puts the block into the grid
		cmp blocktype, 0
		je block0
		cmp blocktype, 1
		je block1
		cmp blocktype, 2
		je block2
		cmp blocktype, 3
		je block3
		cmp blocktype, 4
		je block4
		cmp blocktype, 5
		je block5
		cmp blocktype, 6
		je block6
block0:
		cmp blockmode, 0
		je block00
		cmp blockmode, 1
		je block01
		cmp blockmode, 2
		je block02
		cmp blockmode, 3
		je block03
 
 
block00:
		mov ebx, x
		mov edx, y
		mov ecx, 4
block00loop:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc edx
		loop block00loop
		ret
 
block01:
		mov ebx, x
		mov edx, y
		mov ecx, 4
 
block01loop:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc ebx
		loop block01loop
		ret
 
 
block02:
		mov ebx, x
		mov edx, y
		mov ecx, 4
block02loop:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		dec edx
		loop block02loop
		ret
 
block03:
 
		mov ebx, x
		mov edx, y
		mov ecx, 4
 
block03loop:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		dec ebx
		loop block03loop
		ret
 
block04:
 
 
 
 
block1:
		cmp blockmode, 0
		je block10
		cmp blockmode, 1
		je block11
		cmp blockmode, 2
		je block12
		cmp blockmode, 3
		je block13
block10:
		mov ebx, x
		mov edx, y
		inc edx
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		dec edx
		dec ebx
		mov ecx, 3
loop10:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc ebx
		loop loop10
		ret
 
 
block11:
		mov ebx, x
		mov edx, y
		inc ebx
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		dec ebx
		dec edx
		mov ecx, 3
loop11:
		pusha
		invoke SetGrid, ebx,edx,color
		popa
		inc edx
		loop loop11
		ret
 
block12:
		mov ebx, x
		mov edx, y
		dec edx
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc edx
		dec ebx
		mov ecx, 3
loop12:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc ebx
		loop loop12
		ret
block13:
		mov ebx, x
		mov edx, y
		dec ebx
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc ebx
		dec edx
		mov ecx, 3
loop13:
		pusha
		invoke SetGrid, ebx,edx,color
		popa
		inc edx
		loop loop13
		ret
 
block2:
		cmp blockmode, 0
		je block20
		cmp blockmode, 1
		je block21
		cmp blockmode, 2
		je block22
		cmp blockmode, 3
		je block23
 
block20:
           
		mov ebx, x
		mov edx, y
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc ebx
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc edx
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		dec ebx
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		ret
 
block21:
		jmp block20
           
block22:
		jmp block20
   
block23:
		jmp block20
 
 
 
block3:
		cmp blockmode, 0
		je block30
		cmp blockmode, 1
		je block31
		cmp blockmode, 2
		je block32
		cmp blockmode, 3
		je block33
 
block30:
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
		mov ebx, x
		mov edx, y
		inc edx
		mov ecx, 3
loop30:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc ebx
		loop loop30
		ret
 
block31:
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
		mov ebx, x
		inc ebx
		mov edx, y
		mov ecx, 3
loop31:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		dec edx
		loop loop31
		ret
 
block32:
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
		mov ebx, x
		mov edx, y
		dec edx
		mov ecx, 3
loop32:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		dec ebx
		loop loop32
		ret
 
block33:
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
		mov ebx, x
		dec ebx
		mov edx, y
		mov ecx, 3
loop33:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc edx
		loop loop33
		ret
 
block4:
		cmp blockmode, 0
		je block40
		cmp blockmode, 1
		je block41
		cmp blockmode, 2
		je block42
		cmp blockmode, 3
		je block43
 
block40:
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
		mov ebx, x
		mov edx, y
		inc edx
		mov ecx, 3
loop40:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		dec ebx
		loop loop40
		ret
 
 
block41:
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
		mov ebx, x
		dec ebx
		mov edx, y
		mov ecx, 3
loop41:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		dec edx
		loop loop41
		ret
 
block42:
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
		mov ebx, x
		mov edx, y
		dec edx
		mov ecx, 3
loop42:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc ebx
		loop loop42
		ret
 
block43:
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
		mov ebx, x
		inc ebx
		mov edx, y
		mov ecx, 3
loop43:
		pusha
		invoke SetGrid, ebx, edx, color
		popa
		inc edx
		loop loop43
		ret
block5:
		cmp blockmode, 0
		je block50
		cmp blockmode, 1
		je block51
		cmp blockmode, 2
		je block52
		cmp blockmode, 3
		je block53
 
 
block50:
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		inc ebx
		mov edx, y
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		mov edx, y
		dec edx
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		dec edx
		invoke SetGrid, ebx, edx, color
 
		ret
block51:
 
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		mov edx, y
		dec edx
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		inc edx
		invoke SetGrid, ebx, edx, color
		ret
block52:
		jmp block50
block53:
		jmp block51
block6:
		cmp blockmode, 0
		je block60
		cmp blockmode, 1
		je block61
		cmp blockmode, 2
		je block62
		cmp blockmode, 3
		je block63
 
block60:
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		mov edx, y
		dec edx
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		inc ebx
		mov edx, y
		dec edx
		invoke SetGrid, ebx, edx, color
		ret
 
block61:
 
		mov ebx, x
		mov edx, y
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		mov edx, y
		inc edx
		invoke SetGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		dec edx
		invoke SetGrid, ebx, edx, color
		ret
 
block62:
		jmp block60
 
block63:
		jmp block61
		ret
BuildBlock ENDP
 
 
BuildSideBarBlock          PROC,   x:DWORD,             y:DWORD, blocktype:DWORD,       blockmode:DWORD, color:BYTE; blockmode ->   0 - down, 1- right, 2-up, 3 - left
		;Puts the block into the grid
		cmp blocktype, 0
		je block0
		cmp blocktype, 1
		je block1
		cmp blocktype, 2
		je block2
		cmp blocktype, 3
		je block3
		cmp blocktype, 4
		je block4
		cmp blocktype, 5
		je block5
		cmp blocktype, 6
		je block6
 
block0:
		cmp blockmode, 0
		je block00
		cmp blockmode, 1
		je block01
		cmp blockmode, 2
		je block02
		cmp blockmode, 3
		je block03
 
 
block00:
		mov ebx, x
		mov edx, y
		mov ecx, 4
block00loop:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc edx
		loop block00loop
		ret
 
block01:
		mov ebx, x
		mov edx, y
		mov ecx, 4
 
block01loop:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc ebx
		loop block01loop
		ret
 
 
block02:
		mov ebx, x
		mov edx, y
		mov ecx, 4
block02loop:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec edx
		loop block02loop
		ret
 
block03:
 
		mov ebx, x
		mov edx, y
		mov ecx, 4
 
block03loop:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec ebx
		loop block03loop
		ret
 
block04:
 
 
 
 
block1:
		cmp blockmode, 0
		je block10
		cmp blockmode, 1
		je block11
		cmp blockmode, 2
		je block12
		cmp blockmode, 3
		je block13
block10:
		mov ebx, x
		mov edx, y
		inc edx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec edx
		dec ebx
		mov ecx, 3
loop10:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc ebx
		loop loop10
		ret
 
 
block11:
		mov ebx, x
		mov edx, y
		inc ebx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec ebx
		dec edx
		mov ecx, 3
loop11:
		pusha
		invoke SetSideBarGrid, ebx,edx,color
		popa
		inc edx
		loop loop11
		ret
 
block12:
		mov ebx, x
		mov edx, y
		dec edx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc edx
		dec ebx
		mov ecx, 3
loop12:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc ebx
		loop loop12
		ret
block13:
		mov ebx, x
		mov edx, y
		dec ebx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc ebx
		dec edx
		mov ecx, 3
loop13:
		pusha
		invoke SetSideBarGrid, ebx,edx,color
		popa
		inc edx
		loop loop13
		ret
 
block2:
		cmp blockmode, 0
		je block20
		cmp blockmode, 1
		je block21
		cmp blockmode, 2
		je block22
		cmp blockmode, 3
		je block23
 
block20:
           
		mov ebx, x
		mov edx, y
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc ebx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc edx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec ebx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		ret
 
block21:
		mov ebx, x
		mov edx, y
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc ebx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec edx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec ebx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		ret
 
block22:
		mov ebx, x
		mov edx, y
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec edx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec ebx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc edx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		ret
 
block23:
		mov ebx, x
		mov edx, y
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec ebx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc edx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc ebx
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		ret
 
 
 
block3:
		cmp blockmode, 0
		je block30
		cmp blockmode, 1
		je block31
		cmp blockmode, 2
		je block32
		cmp blockmode, 3
		je block33
 
block30:
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
		mov ebx, x
		mov edx, y
		inc edx
		mov ecx, 3
loop30:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc ebx
		loop loop30
		ret
 
block31:
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
		mov ebx, x
		inc ebx
		mov edx, y
		mov ecx, 3
loop31:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec edx
		loop loop31
		ret
 
block32:
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
		mov ebx, x
		mov edx, y
		dec edx
		mov ecx, 3
loop32:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec ebx
		loop loop32
		ret
 
block33:
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
		mov ebx, x
		dec ebx
		mov edx, y
		mov ecx, 3
loop33:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc edx
		loop loop33
		ret
 
block4:
		cmp blockmode, 0
		je block40
		cmp blockmode, 1
		je block41
		cmp blockmode, 2
		je block42
		cmp blockmode, 3
		je block43
 
block40:
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
		mov ebx, x
		mov edx, y
		inc edx
		mov ecx, 3
loop40:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec ebx
		loop loop40
		ret
 
 
block41:
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
		mov ebx, x
		dec ebx
		mov edx, y
		mov ecx, 3
loop41:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		dec edx
		loop loop41
		ret
 
block42:
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
		mov ebx, x
		mov edx, y
		dec edx
		mov ecx, 3
loop42:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc ebx
		loop loop42
		ret
 
block43:
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
		mov ebx, x
		inc ebx
		mov edx, y
		mov ecx, 3
loop43:
		pusha
		invoke SetSideBarGrid, ebx, edx, color
		popa
		inc edx
		loop loop43
		ret
block5:
		cmp blockmode, 0
		je block50
		cmp blockmode, 1
		je block51
		cmp blockmode, 2
		je block52
		cmp blockmode, 3
		je block53
 
 
block50:
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		inc ebx
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		mov edx, y
		dec edx
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		dec edx
		invoke SetSideBarGrid, ebx, edx, color
 
		ret
block51:
 
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		mov edx, y
		dec edx
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		inc edx
		invoke SetSideBarGrid, ebx, edx, color
		ret
block52:
		jmp block50
block53:
		jmp block51
block6:
		cmp blockmode, 0
		je block60
		cmp blockmode, 1
		je block61
		cmp blockmode, 2
		je block62
		cmp blockmode, 3
		je block63
 
block60:
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		mov edx, y
		dec edx
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		inc ebx
		mov edx, y
		dec edx
		invoke SetSideBarGrid, ebx, edx, color
		ret
 
block61:
 
		mov ebx, x
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		mov edx, y
		inc edx
		invoke SetSideBarGrid, ebx, edx, color
 
		mov ebx, x
		dec ebx
		mov edx, y
		dec edx
		invoke SetSideBarGrid, ebx, edx, color
		ret
 
block62:
		jmp block60
 
block63:
		jmp block61
		ret
BuildSideBarBlock ENDP
 
 
ClearFullLines PROC
		mov FullLine, 1
		mov ebx, 0
		mov edx, 0
		xor eax, eax
		mov eax, WindowHeight
		mov ecx, BLOCK_SIZE
		idiv ecx
		mov ecx, eax
outerloop:
		mov backupecx, ecx
		mov ebx, 0
		invoke TalDiv, WindowWidth,BLOCK_SIZE,0
		mov ecx, eax
		mov edxbackup, edx
innerloop:
		pusha
		invoke ReadGrid, ebx, edx
		mov albackup, al
		popa
		mov al, albackup
		cmp al, 0ffh
		je dontclearline                         
		inc ebx
		loop innerloop
yesclearline:
		add score, SCORE_BONUS
		mov ebx, 0
		invoke TalDiv, WindowWidth, BLOCK_SIZE, 0
		mov ecx, eax
clearblocks:
		mov anotherecxbackup, ecx
		cmp edx, 0
		je checkifcanclearnextblock
		dec edx
		pusha
		invoke ReadGrid, ebx, edx
		mov albackup, al
		popa
		inc edx
		mov al, albackup
		pusha
		invoke SetGrid, ebx, edx, al
		popa
		dec edx
		jmp clearblocks
checkifcanclearnextblock:
                           
clearnextblock:
		inc ebx
		mov edx, edxbackup
		mov ecx, anotherecxbackup
		loop clearblocks
                           
                                           
dontclearline:
		mov ecx, backupecx
		inc edx
		dec ecx
		jnz outerloop
		ret
ClearFullLines ENDP
 
CheckIfCanGo PROC, x:DWORD, y:DWORD, blocktype:DWORD, blockmode:DWORD
		;Checks if the block fits there
		cmp blocktype, 0
		je block0
		cmp blocktype, 1
		je block1
		cmp blocktype, 2
		je block2
		cmp blocktype, 3
		je block3
		cmp blocktype, 4
		je block4
		cmp blocktype, 5
		je block5
		cmp blocktype, 6
		je block6
block0:
		cmp blockmode, 0
		je block00
		cmp blockmode, 1
		je block01
		cmp blockmode, 2
		je block02
		cmp blockmode, 3
		je block03
 
block00:
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -4
		cmp y, eax
		jge returnfalse
		cmp x, 0
		jl returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, 0
		cmp x, eax
		jge returnfalse
		mov ebx, x
		mov edx, y
		mov ecx, 4
loop00:
		pusha
		invoke ReadGrid, ebx, edx        
		cmp al, 0ffh
		jne returnfalse
		popa
		inc edx
		loop loop00
		jmp returntrue
 
 
block01:
		cmp x, 0
		jl returnfalse
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -1
		cmp y, eax
		jge returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -4
		cmp x, eax
		jg returnfalse
		mov ebx, x
		mov edx, y
		mov ecx, 4
loop01:
		pusha
		invoke ReadGrid, ebx, edx        
		cmp al, 0ffh
		jne returnfalse
		popa
		inc ebx
		loop loop01
		jmp returntrue  
 
 
block02:
		cmp x, 0
		jl returnfalse
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -1
		cmp y, eax
		jge returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE,0
		cmp x, eax
		jge returnfalse
		mov ebx, x
		mov edx, y
		mov ecx, 4
loop02:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		dec edx
		loop loop02
		jmp returntrue
 
 
block03:
		cmp x, 3
		jl returnfalse
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -1
		cmp y, eax
		jge returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -1
		cmp x, eax
		jg returnfalse
		mov ebx, x
		mov edx, y
		mov ecx, 4
loop03:
		pusha
		invoke ReadGrid, ebx, edx        
		cmp al, 0ffh
		jne returnfalse
		popa
		dec ebx
		loop loop03
		jmp returntrue  
 
           
 
block1:
		cmp blockmode, 0
		je block10
		cmp blockmode, 1
		je block11
		cmp blockmode, 2
		je block12
		cmp blockmode, 3
		je block13
 
block10:
		cmp x, 1
		jl returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -2
		cmp x, eax
		jg returnfalse
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -2
		cmp y, eax
		jge returnfalse
 
		mov ebx, x
		mov edx, y
		inc edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		mov ebx, x
		dec ebx
		mov edx, y
		mov ecx, 3
loop10:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		inc ebx
		loop loop10
		jmp returntrue
 
 
 
block11:
		cmp x, 0
		jl returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -2
		cmp x, eax
		jg returnfalse
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -2
		cmp y, eax
		jge returnfalse
 
		mov ebx, x
		mov edx, y
		inc ebx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		mov ebx, x
		mov edx, y
		dec edx
		mov ecx, 3
loop11:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		inc edx
		loop loop11
		jmp returntrue
 
 
block12:
		cmp x, 1
		jl returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -2
		cmp x, eax
		jg returnfalse
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -1
		cmp y, eax
		jge returnfalse
 
		mov ebx, x
		mov edx, y
		dec edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		mov ebx, x
		dec ebx
		mov edx, y
		mov ecx, 3
loop12:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		inc ebx
		loop loop12
		jmp returntrue
 
 
block13:
		cmp x, 1
		jl returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -1
		cmp x, eax
		jg returnfalse
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -2
		cmp y, eax
		jge returnfalse
 
		mov ebx, x
		mov edx, y
		dec ebx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		mov ebx, x
		mov edx, y
		dec edx
		mov ecx, 3
loop13:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		inc edx
		loop loop13
		jmp returntrue
 
 
 
 
block2:
		cmp blockmode, 0
		je block20
		cmp blockmode, 1
		je block21
		cmp blockmode, 2
		je block22
		cmp blockmode, 3
		je block23
 
block20:
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -2
		cmp x, eax
		jg returnfalse
 
		cmp x, 0
		jl returnfalse
 
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -2
		cmp y, eax
		jge returnfalse
 
 
		mov ebx, x
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		inc ebx
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		mov edx, y
		inc edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		inc ebx
		mov edx, y
		inc edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		jmp returntrue
 
block21:
		jmp block20
           
block22:
		jmp block20
 
block23:
		jmp block20
 
block3:
		cmp blockmode, 0
		je block30
		cmp blockmode, 1
		je block31
		cmp blockmode, 2
		je block32
		cmp blockmode, 3
		je block33
                           
block30:
		cmp x, 0
		jl returnfalse
                               
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -3
		cmp y, eax
		jg returnfalse
 
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -3
		cmp x, eax
		jg returnfalse
 
		mov ebx, x
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		mov edx, y
		inc edx
		mov ecx, 3
loop30:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		inc ebx
		loop loop30
		jmp returntrue
 
 
block31:
 
		cmp x, 0
		jl returnfalse
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -2
		cmp y, eax
		jg returnfalse
 
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -2
		cmp x, eax
		jg returnfalse
 
 
		mov ebx, x
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		inc ebx
		mov edx, y
		mov ecx, 3
loop31:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		dec edx
		loop loop31
		jmp returntrue
 
 
block32:
		cmp x, 2
		jl returnfalse
               
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -1
 
		cmp y, eax
		jge returnfalse
 
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -1
 
		cmp x, eax
		jg returnfalse
 
 
		mov ebx, x
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		mov edx, y
		dec edx
		mov ecx, 3
loop32:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		dec ebx
		loop loop32
		jmp returntrue
 
 
 
 
block33:
		cmp x, 1
		jl returnfalse
 
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -4
		cmp y,  eax
		jg returnfalse
       
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -1
		cmp x, eax
		jg returnfalse
 
 
		mov ebx, x
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		dec ebx
		mov edx, y
		mov ecx, 3
loop33:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		inc edx
		loop loop33
		jmp returntrue
 
 
block4:
		cmp blockmode, 0
		je block40
		cmp blockmode, 1
		je block41
		cmp blockmode, 2
		je block42
		cmp blockmode, 3
		je block43
 
block40:
		cmp x, 2
		jl returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -1
		cmp x, eax
		jg returnfalse
 
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -3
		cmp y, eax
		jg returnfalse
 
		mov ebx, x
		mov edx, y
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		mov ecx, 3
		inc edx
loop40:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		dec ebx
		loop loop40
		jmp returntrue
 
 
block41:
		cmp x, 1
		jl returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -1
		cmp x, eax
		jg returnfalse
 
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -2
		cmp y, eax
		jg returnfalse
 
		mov ebx, x
		mov edx, y
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		mov ecx, 3
		dec ebx
loop41:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		dec edx
		loop loop41
		jmp returntrue
 
 
block42:
		cmp x, 0
		jl returnfalse
 
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -3
		cmp x, eax
		jg returnfalse
 
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -2
		cmp y, eax
		jg returnfalse
 
		mov ebx, x
		mov edx, y
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		mov ecx, 3
		dec edx
loop42:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		inc ebx
		loop loop42
		jmp returntrue
 
block43:
		cmp x, 0
		jl returnfalse
 
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -2
		cmp x, eax
		jg returnfalse
 
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -4
		cmp y, eax
		jg returnfalse
 
		mov ebx, x
		mov edx, y
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		mov ecx, 3
		inc ebx
loop43:
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
		popa
		inc edx
		loop loop43
		jmp returntrue
 
 
block5:
		cmp blockmode, 0
		je block50
		cmp blockmode, 1
		je block51
		cmp blockmode, 2
		je block52
		cmp blockmode, 3
		je block53
 
block50:
		cmp x, 1
		jl returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -2
		cmp x, eax
		jg returnfalse
 
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -2
		cmp y, eax
		jg returnfalse
 
		mov ebx, x
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		inc ebx
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		mov edx, y
		dec edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		dec ebx
		mov edx, y
		dec edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		jmp returntrue
 
 
block51:
		cmp x, 1
		jl returnfalse
                           
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -1
		cmp x, eax
		jg returnfalse
 
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -3
		cmp y, eax
		jg returnfalse
 
		mov ebx, x
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		dec ebx
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		mov edx, y
		dec edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		dec ebx
		mov edx, y
		inc edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		jmp returntrue
block52:
		jmp block50
block53:
		jmp block51
block6:
		cmp blockmode, 0
		je block60
		cmp blockmode, 1
		je block61
		cmp blockmode, 2
		je block62
		cmp blockmode, 3
		je block63
 
block60:
		cmp x, 1
		jl returnfalse
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -2
		cmp x, eax
		jg returnfalse
 
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -2
		cmp y, eax
		jg returnfalse
 
		mov ebx, x
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		dec ebx
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		mov edx, y
		dec edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		inc ebx
		mov edx, y
		dec edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		jmp returntrue
 
 
block61:
		cmp x, 1
		jl returnfalse
 
		invoke TalDiv, WindowWidth, BLOCK_SIZE, -1
		cmp x, eax
		jg returnfalse
 
		invoke TalDiv, WindowHeight, BLOCK_SIZE, -3
		cmp y, eax
		jg returnfalse
 
		mov ebx, x
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		dec ebx
		mov edx, y
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		mov edx, y
		inc edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		mov ebx, x
		dec ebx
		mov edx, y
		dec edx
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		jne returnfalse
 
		jmp returntrue
 
block62:
		jmp block60
 
block63:
		jmp block61
returntrue:
		mov eax, 1
		ret
 
returnfalse:
		mov eax, 0
		ret
 
		ret
CheckIfCanGo ENDP
 
 
GetRandomBlock PROC
		xor edx, edx
		mov eax, WindowWidth
		mov edi, BLOCK_SIZE
		idiv edi
		xor edx, edx
		mov edi, 2
		idiv edi
		mov BlockX, eax
		mov BlockY, -1
		mov BlockMode, 0
		invoke GetRandomNumber, 4, offset randombuffer
		mov eax, randombuffer
		xor edx, edx
		mov bx, 7
		div bx
		mov BlockType, edx
		cmp randomColor, 0
		je getcolorfromblock
		invoke GetRandomNumber, 4, offset randombuffer
		mov eax, randombuffer
		xor dx, dx
		mov bx, 7
		div bx
		mov CurrentColor, dl
		ret
getcolorfromblock:

		mov eax, BlockType
		mov CurrentColor, al
		

		ret
GetRandomBlock ENDP
 
ClearSideBarGrid PROC
 
		mov ebx, 0
		mov edx, 0
		invoke TalDiv, WindowHeight, BLOCK_SIZE, 0
		mov ecx, eax
outerloop:
		mov backupecx, ecx
		mov ecx, 300/BLOCK_SIZE
innerloop:
		pusha
		invoke SetSideBarGrid, ebx, edx, 0ffh
		popa
		inc ebx
		loop innerloop
		mov ecx, backupecx
		loop outerloop
		ret
ClearSideBarGrid ENDP
 
 
ChangeBlock PROC
		invoke mciSendString, offset playblop, NULL, 0, NULL

		invoke ClearSideBarGrid
		invoke BuildBlock, BlockX,BlockY,BlockType,BlockMode,CurrentColor
		COMMENT @
		mov esi, offset next2blocks
		mov eax, DWORD ptr [esi]
		mov BlockType, eax
		add esi, 4
		mov al, BYTE ptr [esi]
		mov CurrentColor, al
 
		push BlockType
		xor eax, eax
		mov al, CurrentColor
		push eax
 
		mov edi, offset next2blocks
		mov esi, offset next2blocks
		add esi, 5
		mov ecx, 10
		rep movsb
 
                           
 
		invoke GetRandomBlock
		mov edi, offset next2blocks
		add edi, 10
		mov eax, BlockType
		mov DWORD ptr [edi], eax
		add edi, 4
		mov al, CurrentColor
		mov BYTE ptr [edi], al
 
		pop eax
		mov CurrentColor, al
		pop BlockType @

		push nextBlockType
		xor eax, eax
		mov al, nextBlockColor
		push eax
		invoke GetRandomBlock
		mov eax, BlockType
		mov nextBlockType, eax
		mov al, CurrentColor
		mov nextBlockColor, al
		pop eax
		mov CurrentColor, al
		pop BlockType
 

		invoke TalDiv, WindowWidth, BLOCK_SIZE, 0
		invoke TalDiv, eax, 2, 0
		mov ebx, eax
		mov edx, 0
		invoke ReadGrid, ebx, edx
		cmp al, 0ffh
		je endfunc
		mov youlosestate, 1    		          
		invoke SetTimer, hWnd, TM_GET_INPUT_FROM_KEYBOARD, INPUT_FROM_KEYBOARD_DELAY_IN_MENUS, NULL
		invoke mciSendString, offset playGameOverMusic, NULL, 0, NULL
		invoke GetAsyncKeyState, VK_DOWN
		invoke GetAsyncKeyState, VK_RETURN
		invoke GetAsyncKeyState, VK_LEFT
		invoke GetAsyncKeyState, VK_RIGHT
endfunc:

		invoke ClearFullLines

		ret
ChangeBlock ENDP
 
 
GenerateRandomBlocksToArray PROC
		mov ecx, 3
		mov ebx, offset next2blocks
generate:
		pusha
		invoke GetRandomNumber, 4, offset randombuffer
		mov eax, randombuffer
		xor edx, edx
		mov bx, 7
		div bx
		mov nextBlockType, edx
		cmp randomColor, 0
		je skipgetrandomcolor
		invoke GetRandomNumber, 4, offset randombuffer
		mov eax, randombuffer
		xor dx, dx
		mov bx, 7
		div bx
		mov CurrentColor, dl
		jmp skipskipgetrandomcolor
skipgetrandomcolor:
		mov eax, BlockType
		mov CurrentColor, al

skipskipgetrandomcolor:
		popa
 
		mov eax, BlockType
		mov [ebx], eax
		add ebx, 4
		mov al, CurrentColor
		mov [ebx], al
		inc ebx
		loop generate
		ret
 
 
GenerateRandomBlocksToArray ENDP
 
 

 
 
 
DrawMainMenuButtons PROC, hdc:HDC, highlightedbutton:BYTE
 

		mov eax, WindowHeight
		mov bx, 10
		idiv bx
		mov marginBetweenButtons, eax



		xor edx, edx
		mov eax, WindowWidth
		mov edi, 2
		idiv edi
		mov esi, eax
		sub esi, BUTTONS_MARGIN
		add esi, 100
 
		invoke TalDiv, WindowHeight, 2, -30
		mov edx, eax
		xor eax, eax
		mov al, highlightedbutton
		imul eax, marginBetweenButtons
		add edx, eax
 
		push esi
		invoke DrawImage_WithMask_WithResize, hdc, HHighLightBox, HHighLightMask, esi, edx, 240,60,0,0, 240,60 ;;;
		pop esi
 
		invoke TalDiv, WindowHeight, 2, -30
		mov edx, eax
		pusha
		invoke DrawImage_WithMask_WithResize, hdc, HNewGame, HNewGameMask, esi, edx, 240,60,0,0, 240,60
		popa
		add edx, marginBetweenButtons
 
 
		pusha
		invoke DrawImage_WithMask_WithResize, hdc, HOptions, HOptionsMask, esi, edx, 240,60,0,0, 240,60
		popa
		add edx, marginBetweenButtons
 
		pusha
		invoke DrawImage_WithMask_WithResize, hdc, HAbout, HAboutMask, esi, edx, 240,60,0,0, 240,60
		popa
		add edx, marginBetweenButtons
 
 
		invoke DrawImage_WithMask_WithResize, hdc, HExit, HExitMask, esi, edx, 240,60,0,0, 240,60
 
 
 
 
 
		ret
DrawMainMenuButtons ENDP
 
 
 
DrawOptionsButtons PROC, hdc:HDC, highlightedbutton:BYTE, circlex:DWORD, selectedTheme:DWORD
 
		;invoke DrawImage, hdc, HVolumeBar, 50, 400
 
		mov edx, 315
		xor eax, eax
		mov al, highlightedbutton
		imul eax,190
		add edx, eax
		invoke DrawImage_WithMask, hdc, HHighLightBox, HHighLightMask, 50, edx
 
		invoke DrawImage_WithMask, hdc, HVolumeBar,HVolumeBarMask, 50, 400
		invoke DrawImage_WithMask, hdc, HCircle,HCircleMask, circlex, 395
 
   
		invoke DrawImage_WithMask, hdc, HChangeVolume, HChangeVolumeMask, 50, 315
		invoke DrawImage_WithMask, hdc, HChangeTheme, HChangeThemeMask, 50, 505
 
 
		cmp selectedTheme, BLACK_THEME
		je drawblacktheme
		invoke DrawImage, hdc, HWhiteTheme,75, 580
		ret
drawblacktheme:
		invoke DrawImage, hdc,  HBlackTheme,75, 580
 
 
 
		ret
DrawOptionsButtons ENDP
 
 
DrawGameOverButtons PROC, hdc:HDC, highlightedbutton:BYTE
 
		mov ebx, 50
		xor eax, eax
		mov al, highlightedbutton
		imul eax, 340
		add ebx, eax
 
		invoke DrawImage_WithMask, hdc, HHighLightBox, HHighLightMask, ebx, 600
 
		invoke DrawImage_WithMask, hdc, HTryAgain,HTryAgainMask, 50, 600
		invoke DrawImage_WithMask, hdc, HBlackMainMenu, HBlackMainMenuMask, 50+240+100, 600
		ret
DrawGameOverButtons ENDP
 
 
 
 
 
 
 
 
DrawPauseButtons PROC, hdc:HDC, highlightedbutton:BYTE
 
		xor edx, edx
		mov eax, WindowWidth
		mov edi, 2
		idiv edi
		mov esi, eax
		sub esi, BUTTONS_MARGIN
		add esi, 90
 
		invoke TalDiv, WindowHeight, 2, 0
		mov edx, eax
		xor eax, eax
		mov al, highlightedbutton
		imul eax, 70
		add edx, eax
		push esi
		invoke DrawImage_WithMask, hdc, HHighLightBox, HHighLightMask, esi, edx
		pop esi
 
		invoke TalDiv, WindowHeight, 2, 0
		mov edx, eax
		pusha
		invoke DrawImage_WithMask, hdc, HResume, HResumeMask, esi, edx
		popa
		add edx, 70
 
		pusha
		invoke DrawImage_WithMask, hdc, HRestart, HRestartMask, esi, edx
		popa
		add edx, 70
 
		pusha
		invoke DrawImage_WithMask, hdc, HOptions, HOptionsMask, esi, edx
		popa
		add edx, 70
 
 
 
		invoke DrawImage_WithMask, hdc, HMainMenu, HMainMenuMask, esi, edx
 
		ret
DrawPauseButtons ENDP
 
 
 
 
 
 
 
ClearGrid PROC
 
		mov ebx, 0
		mov edx, 0
		invoke TalDiv, WindowHeight, BLOCK_SIZE, 0
		mov ecx, eax
outerloop:
		mov backupecx, ecx
		invoke TalDiv, WindowWidth, BLOCK_SIZE, 0
		mov ecx, eax
innerloop:
		pusha
		invoke SetGrid, ebx, edx, 0ffh
		popa
		inc ebx
		loop innerloop
		mov ecx, backupecx
		loop outerloop
		ret
ClearGrid ENDP






 
DrawEmptyBlackBlocks PROC, hdc:HDC

		;Draws all the blocks on the grid
 
		mov ebx, 0
		mov edx, 0
		invoke TalDiv, WindowHeight, BLOCK_SIZE,0
		mov ecx, eax
loop00:
		mov backupecx, ecx
		invoke TalDiv, WindowWidth, BLOCK_SIZE,0
		mov ecx, eax
		mov ebx, 0
loop01:
		pusha
		pusha
		invoke ReadGrid, ebx, edx
		cmp al, 0FFh
		jne skipdrawpopa		
 
		popa
		imul ebx, BLOCK_SIZE
		imul edx, BLOCK_SIZE
		invoke DrawImage, hdc, HBlock255, ebx, edx
		jmp skipdraw
skipdrawpopa:
		popa
                           
skipdraw:
		popa
		inc ebx
		loop loop01

		mov ecx, backupecx
		inc edx
		loop loop00
		ret


		ret
DrawEmptyBlackBlocks ENDP
 




DrawGridLines PROC, hdc:HDC
local pen:HPEN
 
		;invoke CreatePen, PS_SOLID, 1, 0ffffffh
		invoke GetStockObject, WHITE_PEN
		mov pen, eax
		invoke SelectObject, hdc, pen
 
 
		mov edx, BLOCK_SIZE
		invoke TalDiv, WindowHeight, BLOCK_SIZE, 0
		mov ecx, eax
horizontallines:
		pusha
		invoke MoveToEx, hdc, 0, edx, NULL
		invoke LineTo, hdc, WindowWidth, edx
		popa
		add edx, BLOCK_SIZE
		loop horizontallines
 
		mov ebx,40
		invoke TalDiv, WindowWidth, BLOCK_SIZE, 0
		mov ecx, eax
verticallines:
		pusha
		invoke MoveToEx, hdc, ebx, 0, NULL
		invoke LineTo, hdc, ebx, WindowHeight
		popa
		add ebx, BLOCK_SIZE
		loop verticallines
		ret
DrawGridLines ENDP
 
 
 
itoa PROC, num:DWORD, string:DWORD
local count:DWORD
 
		mov count, 0
 
 
		mov ecx, 10
itoa_loop:
		xor edx, edx
		xor eax, eax
		mov eax, num
		idiv ecx
		mov num, eax
		add edx, 48 ;ascii value of 0
		push edx
		inc count
		cmp num, 0
		jne itoa_loop
 
		mov ecx, count
		mov ebx, string
putnuminstring:
		pop edx
		mov [ebx], dl
		inc ebx
		loop putnuminstring
		mov byte ptr [ebx], 0
 
		mov eax, count
		ret
itoa ENDP
 
 
 
DrawNumber PROC, hdc:HDC, num:DWORD, x:DWORD, y:DWORD
		invoke itoa, num, offset scorestring
		push eax		
		invoke SelectObject, hdc, scoreFont
		pop eax
		invoke TextOut, hdc, x,y, offset scorestring, eax
 
 
		ret
DrawNumber ENDP
 
 
About PROC
		invoke SetTimer, hWnd, TM_GET_INPUT_FROM_KEYBOARD, INPUT_FROM_KEYBOARD_DELAY_IN_MENUS, NULL		
		mov startscreen, 0
		cmp aboutpage, 1
		je checkbuttons
		mov aboutpage, 1
		ret
                           
checkbuttons:
		invoke GetAsyncKeyState, VK_ESCAPE		
		cmp eax, 0
		je didntclickescapeabout
		mov eax, clickedescapelasttime
		mov clickedescapelasttime, 1
		cmp eax, 1
		je checkenter
		jmp endabout
 
didntclickescapeabout:
		mov clickedescapelasttime, 0
		

checkenter:
		invoke GetAsyncKeyState, VK_RETURN
		cmp eax, 0
		je didntclickenteronabout
		mov eax, clickedenterlasttime
		mov clickedenterlasttime, 1
		cmp eax, 1
		je endaboutcheck
		jmp endabout
didntclickenteronabout:
		mov clickedenterlasttime, 0
endaboutcheck:
		ret
 
 
endabout:
		mov aboutpage, 0
		mov startscreen, 1
		ret

About ENDP


Options PROC
		invoke SetTimer, hWnd, TM_GET_INPUT_FROM_KEYBOARD, INPUT_FROM_KEYBOARD_DELAY_IN_OPTIONS, NULL

		mov optionscreenstate, 1



		invoke GetAsyncKeyState, VK_UP
		cmp eax, 0
		je checkdown4andnoclick
		mov eax, clickeduplasttime
		mov clickeduplasttime, 1
		cmp eax, 1
		je checkdown4
		xor highlightedoptionsscreen, 1
		jmp checkdown4
checkdown4andnoclick:
		mov clickeduplasttime, 0
checkdown4:
		invoke GetAsyncKeyState, VK_DOWN
		cmp eax, 0
		je dooperationandnoclick
		mov eax, clickeddownlasttime
		mov clickeddownlasttime, 1
		cmp eax, 1
		je dooperation
		xor highlightedoptionsscreen, 1
		jmp dooperation
dooperationandnoclick:
		mov clickeddownlasttime, 0
dooperation:
		cmp highlightedoptionsscreen , 0
		je volumechangeoperation


		;theme change operation	
		invoke GetAsyncKeyState, VK_RIGHT
		cmp eax, 0
		jne changetheme
		invoke GetAsyncKeyState, VK_LEFT
		cmp eax, 0
		jne changetheme
		mov changedthemelasttime, 0
		jmp endoperations
changetheme:
		mov eax, changedthemelasttime
		mov changedthemelasttime, 1
		cmp eax, 1
		je endoperations
		xor theme, 1
		jmp endoperations
 
 
 
 
volumechangeoperation:
		invoke GetAsyncKeyState, VK_RIGHT
		cmp eax, 0
		je skipright
		cmp CircleX, 600
		jnl skipleft
		add CircleX, 10
		jmp skipleft
skipright:
		invoke GetAsyncKeyState, VK_LEFT
		cmp eax, 0
		je skipleft
		cmp CircleX, 50
		jng skipleft
		sub CircleX, 10
skipleft:
		mov eax, CircleX
		sub eax, 32h
		imul eax, 118
		push ax
		rol eax, 16
		pop ax
		rol eax, 16
		mov volume, eax
		invoke waveOutSetVolume, NULL, volume
 
endoperations:
		invoke GetAsyncKeyState, VK_ESCAPE		
		cmp eax, 0
		je endcheckanddidntclickescape
		mov eax, clickedescapelasttime
		mov clickedescapelasttime, 1
		cmp eax, 1
		je endcheck
		mov optionscreenstate, 0
		invoke SetTimer, hWnd, TM_GET_INPUT_FROM_KEYBOARD, INPUT_FROM_KEYBOARD_DELAY_IN_MENUS, NULL
		invoke GetAsyncKeyState, VK_UP
		invoke GetAsyncKeyState, VK_DOWN
		invoke GetAsyncKeyState, VK_RETURN
		invoke GetAsyncKeyState, VK_ESCAPE

		invoke Sleep, 10
		ret
endcheckanddidntclickescape:
		mov clickedescapelasttime, 0
endcheck:
		ret

Options ENDP


NewGame PROC

		mov eax, CircleX
		sub eax, 43
		imul eax, 118
		push ax
		rol eax, 16
		pop ax
		rol eax, 16
		mov volume, eax
		invoke waveOutSetVolume, NULL, volume

		invoke SetTimer, hWnd, TM_GET_INPUT_FROM_KEYBOARD, INPUT_FROM_KEYBOARD_DELAY_IN_GAME, NULL

		invoke ClearGrid
		invoke ClearSideBarGrid
		invoke mciSendString, offset restartBackgroundMusic, NULL, 0, NULL
		invoke mciSendString, offset playBackgroundMusic, NULL, 0, NULL


		invoke GetRandomBlock
		mov eax, BlockType
		mov nextBlockType, eax
		mov al, CurrentColor
		mov nextBlockColor, al
		mov startscreen, 0
		mov youlosestate, 0
		mov optionscreenstate, 0
		mov score, 0
		mov highlighted, 0
		mov PauseState ,0
 
		invoke GetRandomBlock
		
		ret

skipgetrandomcolor:
		mov eax, BlockType
		mov CurrentColor, al

		ret
NewGame ENDP


MainMenu PROC
		invoke SetTimer, hWnd, TM_GET_INPUT_FROM_KEYBOARD, INPUT_FROM_KEYBOARD_DELAY_IN_MENUS, NULL

		invoke GetAsyncKeyState, VK_DOWN
		invoke GetAsyncKeyState, VK_UP
		invoke GetAsyncKeyState, VK_RETURN
		mov youlosestate, 0
		mov startscreen, 1
		mov highlighted, 0
		mov PauseState, 0
		ret
MainMenu ENDP

 
GetInputFromKeyboard PROC
		cmp optionscreenstate, 1
		je options
		cmp startscreen, 1
		je startscreenprocedure		
		cmp youlosestate, 1
		je youloseprocedure		
		cmp PauseState, 1
		je pauseprocedure
		cmp aboutpage, 1
		je about

		;~~~~~~~~~~~ pause procedure
		invoke GetAsyncKeyState, VK_ESCAPE
		
		cmp eax, 0
		je skippause1anddidntclickescape
		mov eax, clickedescapelasttime
		mov clickedescapelasttime, 1
		cmp eax, 1
		je skippause1
		mov PauseState, 1
		invoke SetTimer, hWnd, TM_GET_INPUT_FROM_KEYBOARD, INPUT_FROM_KEYBOARD_DELAY_IN_MENUS, NULL
		;invoke PlaySound, NULL, NULL, NULL       
		invoke mciSendString, offset freezeBackgroundMusic, NULL, 0, NULL

		ret
		;~~~~~~~~~~~ end pause procedure
skippause1anddidntclickescape:
		mov clickedescapelasttime, 0
skippause1:
		invoke BuildBlock, BlockX,BlockY,BlockType,BlockMode,0ffh

		invoke GetAsyncKeyState, VK_RIGHT
		cmp eax, 0
		je checkleftbutton		 
		inc BlockX
		invoke CheckIfCanGo, BlockX, BlockY, BlockType, BlockMode
		cmp eax, 1
		je checkleftbutton
		dec BlockX
		jmp checkupbutton
checkleftbutton:
		invoke GetAsyncKeyState, VK_LEFT
		cmp eax, 0
		je checkupbutton	
		dec BlockX
		invoke CheckIfCanGo, BlockX, BlockY, BlockType, BlockMode
		cmp eax, 1
		je checkupbutton
		inc BlockX
checkupbutton:
		invoke GetAsyncKeyState, VK_UP
		cmp eax, 0
		je checkdownbuttonandupwasntclicked
		mov eax, upwasclickedlasttime
		mov upwasclickedlasttime, 1
		cmp eax, 1
		je checkdownbutton		
		cmp BlockMode, 3
		je resetblockmode
		inc BlockMode
		jmp checkifcanflip
 
resetblockmode:
		mov BlockMode, 0
checkifcanflip:
		invoke CheckIfCanGo, BlockX, BlockY, BlockType, BlockMode
		cmp eax, 0
		jne checkdownbutton
		cmp BlockMode, 0
		je put3blockmode
		dec BlockMode
		jmp checkdownbutton
put3blockmode:
		mov BlockMode, 3
		jmp checkdownbutton
checkdownbuttonandupwasntclicked:
		mov upwasclickedlasttime, 0
checkdownbutton:
		invoke GetAsyncKeyState, VK_DOWN
		cmp eax, 0
		je checkspace
		inc BlockY
		inc score
		invoke CheckIfCanGo, BlockX, BlockY, BlockType, BlockMode
		cmp eax, 1
		je checkspace
		dec BlockY		
		invoke ChangeBlock
checkspace:
		invoke GetAsyncKeyState, VK_SPACE
		cmp eax, 0
		je skipmovingandputclicspacelasttime0
		mov eax, clickedspacelasttime
		mov clickedspacelasttime, 1
		cmp eax, 1
		je skipmoving
		
		
		;Check if 1 second passed since last space click
		invoke GetTickCount
		
		sub eax, timeLastPutDown
		cmp eax, 1000
		jl skipmoving

		invoke GetTickCount
		mov timeLastPutDown, eax
		invoke mciSendString, offset playwoosh, NULL, 0, NULL

putblockdown:
		inc BlockY
		add score, 3
		invoke CheckIfCanGo, BlockX, BlockY, BlockType, BlockMode
		cmp eax, 0
		je stopputdown
		jmp putblockdown

stopputdown:
		dec BlockY
		jmp skipmoving

skipmovingandputclicspacelasttime0:
		mov clickedspacelasttime, 0
skipmoving:
		invoke BuildBlock, BlockX,BlockY,BlockType,BlockMode,CurrentColor
		ret

;~~~~~~~~~~~ START OF STARTSCREEN PROCEDURE
startscreenprocedure:
		invoke GetAsyncKeyState, VK_DOWN
		cmp eax, 0
		je checkupandnoclick
		mov eax, clickeddownlasttime
		mov clickeddownlasttime, 1
		cmp eax, 1
		je checkup
		cmp highlighted, 3
		je resethighlighted
		inc highlighted
		jmp aftercheckup
resethighlighted:
		mov highlighted, 0
		jmp aftercheckup
checkupandnoclick:
		mov clickeddownlasttime, 0
checkup:
		invoke GetAsyncKeyState, VK_UP
		cmp eax, 0
		je aftercheckupandnoclickup
		mov eax, clickeduplasttime
		mov clickeduplasttime, 1
		cmp eax, 1
		je aftercheckup
		cmp highlighted, 0
		je resetuphighlighted
		dec highlighted
		jmp aftercheckup
resetuphighlighted:
		mov highlighted, 3
		jmp aftercheckup
aftercheckupandnoclickup:
		mov clickeduplasttime, 0
aftercheckup:
 
                    
 
		invoke GetAsyncKeyState, VK_RETURN
		cmp eax, 0
		je didntclickenter
		mov eax, clickedenterlasttime
		mov clickedenterlasttime, 1
		cmp eax, 1
		je endoffunc

		cmp highlighted, 0
		je newgame
		cmp highlighted, 1
		je options
		cmp highlighted, 2
		je about              
		invoke Close

;~~~~~~~~~~~ END OF STARTSCREEN PROCEDURE
didntclickenter:
		mov clickedenterlasttime, 0
		ret

newgame:
		invoke NewGame
		ret

options:
		invoke Options
		ret

about:
		invoke About
		ret

mainmenu:
		invoke MainMenu
		ret


;~~~~~~~~~~~~~~~~~~~~~~~~ START YOULOSE PROCEDURE

youloseprocedure:

		invoke GetAsyncKeyState, VK_RIGHT
		cmp eax, 0
		je checkleftandandnotclickright
		mov eax, clickedrightlasttime
		mov clickedrightlasttime, 1
		cmp eax, 1
		je checkleft
		xor highlightedgameover, 1  ;if highlighted is 0 - make it 1. if highlighted is 1 - make it 0.
		jmp skipchangehighlighted3

checkleftandandnotclickright:
		mov clickedrightlasttime, 0

checkleft:
		invoke GetAsyncKeyState, VK_LEFT
		cmp eax, 0
		je skipchangehighlighted3anddidntclickleft
		mov eax, clickedleftlasttime
		mov clickedleftlasttime, 1
		cmp eax, 1
		je skipchangehighlighted3
		xor highlightedgameover, 1  ;if highlighted is 0 - make it 1. if highlighted is 1 - make it 0.
		jmp skipchangehighlighted3
 
skipchangehighlighted3anddidntclickleft:
		mov clickedleftlasttime, 0
 
skipchangehighlighted3:
		invoke GetAsyncKeyState, VK_RETURN
		cmp eax, 0
		je endoffunc
		mov bl, highlightedgameover
		mov highlightedgameover, 0
		cmp bl, 0
		je newgame
		jmp mainmenu
;~~~~~~~~~~~~~~~~~~~~~~~~ END YOULOSE PROCEDURE

		 
resume:
		invoke mciSendString, offset resumeBackgroundMusic, NULL, 0, NULL

		mov highlighted, 0
		mov PauseState, 0
		invoke SetTimer, hWnd, TM_GET_INPUT_FROM_KEYBOARD, INPUT_FROM_KEYBOARD_DELAY_IN_GAME, NULL
		ret

;~~~~~~~~~~~~~~~~~~~~~~~ PAUSE PROCEDURE



pauseprocedure:
		invoke GetAsyncKeyState, VK_ESCAPE		
		cmp eax, 0
		je pausescreenprocedureandnoclickescape
		mov eax, clickedescapelasttime
		mov clickedescapelasttime, 1
		cmp eax, 1
		je pausescreenprocedure
		jmp resume
		 
pausescreenprocedureandnoclickescape:
		mov clickedescapelasttime, 0
pausescreenprocedure:
		;invoke PlaySound, NULL, NULL, NULL       
		invoke mciSendString, offset freezeBackgroundMusic, NULL, 0, NULL


		invoke GetAsyncKeyState, VK_DOWN
		cmp eax, 0
		je checkup1andnoclickdown
		mov eax, clickeddownlasttime
		mov clickeddownlasttime, 1
		cmp eax, 1
		je checkup1
		cmp highlighted, 3
		je resethighlighted1
		inc highlighted
		jmp aftercheckup1
resethighlighted1:
		mov highlighted, 0
		jmp aftercheckup1
checkup1andnoclickdown:
		mov clickeddownlasttime, 0		
checkup1:
		invoke GetAsyncKeyState, VK_UP
		cmp eax, 0
		je aftercheckup1andnoclickup		
		mov eax, clickeduplasttime
		mov clickeduplasttime, 1
		cmp eax, 1
		je aftercheckup1
		cmp highlighted, 0
		je resetuphighlighted1
		dec highlighted
		jmp aftercheckup1
resetuphighlighted1:
		mov highlighted, 3
		jmp aftercheckup1
aftercheckup1andnoclickup:
		mov clickeduplasttime, 0
aftercheckup1:
 
		invoke GetAsyncKeyState, VK_RETURN
		shr eax, 15
		cmp eax, 0
		je endoffunc
 
		cmp highlighted, 0
		je resume
		cmp highlighted, 1
		je newgame
		cmp highlighted, 2
		je options
		jmp mainmenu


;~~~~~~~~~~~~~~~~~~~~~~~ END PAUSE PROCEDURE


endoffunc:
		ret
GetInputFromKeyboard ENDP



Update PROC
		cmp CurrentColor, 7
		jl skipbreakpoint

		mov al, al
skipbreakpoint:
		
		cmp youlosestate, 1
		je endupdate
 
		cmp optionscreenstate, 1
		je endupdate
 
		cmp startscreen, 1
		je endupdate
 
		cmp aboutpage, 1
		je endupdate
                               
		cmp PauseState, 1
		je endupdate


		mov eax, score
		mov ebx, 2500
		xor edx, edx
		idiv ebx
		cmp level, eax
		jge skiplevelup
		mov level, eax
		invoke mciSendString, offset playlevelup, NULL, 0, NULL

		
		invoke TalDiv, 2500, difficulty_factor, 0
		mov ebx, eax
		mov eax, score
		xor edx, edx
		idiv ebx
		mov edx, INITIAL_UPDATE_TIMER
		sub edx, eax
		cmp edx, minimumUpdateTimer
		jge gosettimer
		mov edx, minimumUpdateTimer
gosettimer:
		invoke SetTimer, hWnd, TM_UPDATE, edx , NULL
skiplevelup:


		invoke BuildBlock, BlockX,BlockY,BlockType,BlockMode,0ffh
		;
		;~~~ Move Block Down
		inc BlockY
		invoke CheckIfCanGo, BlockX, BlockY, BlockType, BlockMode
		cmp eax, 1
		je redrawblock
		dec BlockY
		invoke ChangeBlock
		ret

redrawblock:
		invoke BuildBlock, BlockX,BlockY,BlockType,BlockMode,CurrentColor
endupdate:
                            
		ret                          
 
Update ENDP
 
Create PROC
 
		mov created, 1
		mov startscreen, 1
		mov ebx, offset next2blocks
		mov ecx, 2
createblocks:
		pusha
		invoke GetRandomBlock
		popa
		mov eax, BlockType
		mov DWORD ptr [ebx], eax
		add ebx, 4
		mov al, CurrentColor
		mov BYTE ptr [ebx], al
		inc ebx
		loop createblocks
 
		
		invoke waveOutSetVolume, NULL, volume

 
		;invoke CreateFont,80,23,0,0,FW_DONTCARE,FALSE,FALSE,FALSE,ANSI_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,ANTIALIASED_QUALITY,DEFAULT_PITCH,NULL
		invoke CreateFont, 80, 23, 0, 0, FW_BOLD, 0, 0, 0, DEFAULT_CHARSET, OUT_OUTLINE_PRECIS, CLIP_DEFAULT_PRECIS, ANTIALIASED_QUALITY, FF_MODERN, offset TimesNewRoman
		mov scoreFont, eax
 

		invoke CreateFont, 35,15, 0,0, FW_BOLD, TRUE,TRUE,FALSE,ANSI_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH OR FF_DONTCARE, NULL
		mov titleFont, eax

		invoke CreateFont, 75,25, 0,0, FW_BOLD, TRUE,TRUE,FALSE,ANSI_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH OR FF_DONTCARE, NULL
		mov scoreTitleFont, eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,101
		mov HPauseScreen,eax
 
 
 
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,105
		mov HStartScreen,eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,106
		mov HNewGame,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HNewGame, 00ffffffh
		mov HNewGameMask, eax
 
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,107
		mov HHighScores,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HHighScores, 00ffffffh
		mov HHighScoresMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,108
		mov HOptions,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HOptions, 00ffffffh
		mov HOptionsMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,109
		mov HAbout,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HAbout, 00ffffffh
		mov HAboutMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,110
		mov HExit,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HExit, 00ffffffh
		mov HExitMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,111
		mov HHighLightBox,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HHighLightBox, 00ffffffh
		mov HHighLightMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,112
		mov HResume,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HResume, 00ffffffh
		mov HResumeMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,113
		mov HRestart,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HRestart, 00ffffffh
		mov HRestartMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,114
		mov HMainMenu,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HMainMenu, 00ffffffh
		mov HMainMenuMask, eax
 
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,115
		mov HAboutPage,eax
 
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,116
		mov HTryAgain,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HTryAgain, 0
		mov HTryAgainMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,117
		mov HBlackMainMenu,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HBlackMainMenu, 0
		mov HBlackMainMenuMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,118
		mov HGameOver,eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,119
		mov HScore,eax
 
 
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,120
		mov HOptionsScreen,eax
 
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,121
		mov HVolumeBar,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HVolumeBar, 00ffffffh
		mov HVolumeBarMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,122
		mov HCircle,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HCircle, 00ffffffh
		mov HCircleMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,123
		mov HWhiteTheme,eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,124
		mov HBlackTheme,eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,125
		mov HBlueRect,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HBlueRect, 00ffffffh
		mov HBlueRectMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,126
		mov HChangeVolume,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HChangeVolume, 00ffffffh
		mov HChangeVolumeMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,127
		mov HChangeTheme,eax
 
		invoke Get_Handle_To_Mask_Bitmap, HChangeTheme, 00ffffffh
		mov HChangeThemeMask, eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1337
		mov HBlock0,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1338
		mov HBlock1,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1339
		mov HBlock2,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1340
		mov HBlock3,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1341
		mov HBlock4,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1342
		mov HBlock5,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1343
		mov HBlock6,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1336
		mov HBlock255,eax
 
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1344
		mov HBlackThemeBackground,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1345
		mov HScoreBrickBackground,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,1346
		mov HWhiteThemeBackground,eax

 
 
		mov BlockMode, 0

		invoke GetRandomNumber, 4, offset randombuffer
		mov eax, randombuffer
		xor edx, edx
		mov bx, 7
		div bx
		mov BlockType, edx
		cmp randomColor, 0
		je skipgetrandomcolor

		invoke GetRandomNumber, 4, offset randombuffer
		mov eax, randombuffer
		xor dx, dx
		mov bx, 10
		div bx
		mov CurrentColor, dl
		jmp endcreate

skipgetrandomcolor:
		mov eax, BlockType
		mov CurrentColor, al

 
endcreate:
 
		ret
Create ENDP
 
 
Paint PROC
local paint:PAINTSTRUCT
local hdc:HDC
local hdcMem:HDC
local hOld:HBITMAP
local hbmMem:HBITMAP
		cmp youlosestate, 1
		je youlosescreen
 
		cmp optionscreenstate, 1
		je options
 
		cmp startscreen, 1
		je startscreenprocedure
 
		cmp aboutpage, 1
		je about
 
		cmp PauseState, 1
		jne drawgame
 
		jmp paintpausepicture
           
startscreenprocedure:
 
		invoke BeginPaint, hWnd, addr paint
		mov hdc, eax
 
		invoke DrawImage, hdc, HStartScreen,0,0
 
		invoke DrawMainMenuButtons, hdc, highlighted
 
		invoke EndPaint, hWnd, addr paint
		ret
options:
		invoke BeginPaint, hWnd, addr paint
		mov hdc, eax
 
 
		invoke DrawImage, hdc, HOptionsScreen, 0,0
		invoke DrawOptionsButtons, hdc, highlightedoptionsscreen, CircleX, theme
 
		invoke EndPaint, hWnd, addr paint
		ret
about:
		mov aboutpage, 1
		mov startscreen, 0
		mov FramesPassedSinceLastArrowClick, 0
		invoke BeginPaint, hWnd, addr paint
		mov hdc, eax
		invoke DrawImage, hdc, HAboutPage, 0,0
		invoke EndPaint, hWnd, addr paint
		ret
 
 
 
 
youlosescreen:
 
		invoke  BeginPaint,      hWnd,   addr paint
		mov hdc, eax
 
 
                           
		invoke DrawImage, hdc, HGameOver,0,0
		;invoke PlaySound, NULL, NULL, NULL       
		invoke mciSendString, offset freezeBackgroundMusic, NULL, 0, NULL
 
		invoke DrawGameOverButtons, hdc, highlightedgameover
		invoke EndPaint, hWnd, addr paint
		ret
 
paintpausepicture:

		invoke BeginPaint, hWnd, addr paint
		mov hdc, eax
		invoke DrawImage_WithStretch, hdc, HPauseScreen, 0,0,0,0,700,800,RealWindowWidth,WindowHeight
		invoke DrawPauseButtons, hdc, highlighted
		invoke EndPaint, hWnd, addr paint
		ret
 
 
 
 
 
drawgame:
                                                           
		invoke  BeginPaint,      hWnd,   addr paint
		mov hdc, eax
 
		invoke CreateCompatibleDC, hdc
		mov hdcMem, eax
		invoke SetBkMode, hdcMem, TRANSPARENT
		invoke CreateCompatibleBitmap, hdc, RealWindowWidth, WindowHeight
		mov hbmMem, eax
 
		invoke SelectObject,hdcMem, hbmMem
		mov hOld, eax
 

                                                                                                                           
		cmp theme, BLACK_THEME
		je blacktheme
;white theme
		invoke myOwnClearScreen, hdcMem
		invoke myOwnClearSideBarGrid, hdcMem
		invoke DrawGrid, hdcMem
		invoke BuildSideBarBlock, 2,10,nextBlockType,0,nextBlockColor		
		invoke DrawSideBarGrid, hdcMem, 400, 300
		


		invoke DrawImage, hdcMem, HWhiteThemeBackground, 400, 0
		invoke DrawGrid, hdcMem
		invoke BuildSideBarBlock, 3,10,nextBlockType,0,nextBlockColor		
		invoke DrawSideBarGrid, hdcMem, 400, 300
		


		invoke SetTextColor, hdcMem, 0ffffffh	


		invoke crt_strlen, offset instructions1
		invoke TextOut, hdcMem, 410, 650, offset instructions1, eax
		invoke crt_strlen, offset instructions2
		invoke TextOut, hdcMem, 410, 670, offset instructions2, eax
		invoke crt_strlen, offset instructions3
		invoke TextOut, hdcMem, 410, 690, offset instructions3, eax
		invoke crt_strlen, offset instructions4
		invoke TextOut, hdcMem, 410, 710, offset instructions4, eax

		

		invoke SelectObject, hdcMem, titleFont
		invoke crt_strlen, offset instructions0
		invoke TextOut, hdcMem, 410, 600, offset instructions0, eax

		invoke SelectObject, hdcMem, scoreTitleFont
		invoke SetTextColor, hdcMem, 00a5efh ; ;ffa500
		invoke crt_strlen, offset scoretext
		invoke TextOut, hdcMem, 435, 0+20, offset scoretext, eax

		invoke SetTextColor, hdcMem, 0ffffffh	

		invoke DrawImage, hdcMem, HScoreBrickBackground, 407, 56+50
		invoke DrawNumber, hdcMem, score, 450,67+50

		
		jmp afterthemes
                                                                                                                           
 
blacktheme:
		invoke DrawImage, hdcMem, HBlackThemeBackground, 400, 0
		invoke DrawGrid, hdcMem
		invoke BuildSideBarBlock, 3,10,nextBlockType,0,nextBlockColor		
		invoke DrawSideBarGrid, hdcMem, 400, 300
		


		invoke SetTextColor, hdcMem, 0ffffffh	


		invoke crt_strlen, offset instructions1
		invoke TextOut, hdcMem, 410, 650, offset instructions1, eax
		invoke crt_strlen, offset instructions2
		invoke TextOut, hdcMem, 410, 670, offset instructions2, eax
		invoke crt_strlen, offset instructions3
		invoke TextOut, hdcMem, 410, 690, offset instructions3, eax
		invoke crt_strlen, offset instructions4
		invoke TextOut, hdcMem, 410, 710, offset instructions4, eax

		

		invoke SelectObject, hdcMem, titleFont
		invoke crt_strlen, offset instructions0
		invoke TextOut, hdcMem, 410, 600, offset instructions0, eax

		invoke SelectObject, hdcMem, scoreTitleFont
		invoke SetTextColor, hdcMem, 00a5efh ; ;ffa500
		invoke crt_strlen, offset scoretext
		invoke TextOut, hdcMem, 435, 0+20, offset scoretext, eax

		invoke SetTextColor, hdcMem, 0ffffffh	

		invoke DrawImage, hdcMem, HScoreBrickBackground, 407, 56+50
		invoke DrawNumber, hdcMem, score, 450,67+50

		
		invoke DrawEmptyBlackBlocks, hdcMem
                                                           
afterthemes:
		

		invoke BitBlt,hdc, 0, 0, RealWindowWidth, WindowHeight, hdcMem, 0, 0, SRCCOPY
                                                           
		invoke SelectObject,hdcMem, hOld
		invoke DeleteObject,hbmMem
		invoke DeleteDC,hdcMem

		invoke GetLastError

		invoke EndPaint, hWnd,  addr paint     
		ret
 
Paint ENDP
 
 
 
 
 
ProjectWndProc  PROC,   hWnd1:HWND, message:UINT, wParam:WPARAM, lParam:LPARAM
		mov eax, hWnd1
		mov hWnd, eax


		cmp      message,               WM_PAINT
		je        painting
		cmp message,    WM_TIMER
		je        timing
		cmp message, WM_ERASEBKGND
		je		  returnnonzero
		cmp message,    WM_CLOSE
		je        closing
		cmp message, WM_CREATE
		je create
		jmp OtherInstances
           
create:
		invoke Create
		ret

pausewndproc:
		mov PauseState, 1
		ret
           
closing:
		invoke Close
returnnonzero:
		mov eax, 1
		ret
 
painting:
		invoke GetTickCount
		mov ebx, eax
		pusha
		invoke Paint
		popa
		invoke GetTickCount
		sub eax, ebx

		ret
 
update:
		invoke Update
		ret
 
getinputfromkeyboard:
		invoke GetFocus
		cmp eax, hWnd
		jne dontgetinputfromkeyboard
		invoke GetInputFromKeyboard
dontgetinputfromkeyboard:
		ret
 
 
timing:
		cmp wParam, TM_UPDATE
		je update
		cmp wParam, TM_GET_INPUT_FROM_KEYBOARD
		je getinputfromkeyboard
		invoke InvalidateRect, hWnd, NULL, FALSE
		ret
OtherInstances:
		invoke DefWindowProc, hWnd, message, wParam, lParam
		ret
 
ProjectWndProc  ENDP
 
 
 
main PROC
 
LOCAL wndcls:WNDCLASSA ; Class struct for the window
LOCAL msg:MSG
 
		invoke RtlZeroMemory, addr wndcls, SIZEOF wndcls ;Empty the window class
		mov eax, offset ClassName
		mov wndcls.lpszClassName, eax ;Set the class name
		invoke GetStockObject, WHITE_BRUSH
		mov wndcls.hbrBackground, eax ;Set the background color as white
		mov eax, ProjectWndProc
		mov wndcls.lpfnWndProc, eax ;Set the procedure that handles the window messages
		invoke RegisterClassA, addr wndcls ;Register the class
		invoke SetCursor, NULL
 


	
		invoke CreateWindowExA, WS_EX_COMPOSITED, addr ClassName, addr windowTitle, WS_SYSMENU, 0, 0, RealWindowWidth, WindowHeight, 0, 0, 0, 0 ;Create the window
		mov hWnd, eax ;Save the handle
		invoke ShowWindow, eax, SW_SHOW ;Show it
		invoke SetTimer, hWnd, TM_PAINT, PAINT_TIME, NULL ;Set the repaint timer
		invoke SetTimer, hWnd, TM_UPDATE, INITIAL_UPDATE_TIMER , NULL
		invoke SetTimer, hWnd, TM_GET_INPUT_FROM_KEYBOARD, INPUT_FROM_KEYBOARD_DELAY_IN_MENUS, NULL

                           
 
 
msgLoop:
 
		; PeekMessage
		invoke GetMessage, addr msg, hWnd, 0, 0 ;Retrieve the messages from the window
 
		invoke DispatchMessage, addr msg ;Dispatches a message to the window procedure
 
		jmp msgLoop
 
		invoke ExitProcess, 1
		ret
main ENDP
 
 
		end main