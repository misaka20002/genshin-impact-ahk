#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
I_Icon = klee.ico
IfExist, %I_Icon%
  Menu, Tray, Icon, %I_Icon%
v_isReloadByStartGameFromHere=0
ReloadByStartGameFromHere:
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;	^	〔Ctrl〕鍵
  ;	!	〔Alt〕鍵
  ;	+	〔Shift〕鍵
  ;	#	〔Win〕鍵
  ;	&	用&符號把兩個按鍵或按鈕組合成為一個鍵，例如：LButton& a表示按左鈕不放，同時再按〔a〕鍵
  ;	~	加~符號表示不抑制該按鍵，使用在當我們想要把某個按鍵做額外輸出的場合
  ;	$	抑制该按键
  ;	::	字符串, 如::ch::china
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;
  ;用户设定config：
  ;游戏路径
  game_Name=YuanShen.exe ;国际服请修改此处为genshin.exe
  ; run_exe_local=F:\Program Files\miHoYo Launcher\ ;自动启动exe的路径
  run_exe_local=F:\XXMI-Launcher-Portable\Resources\Bin\ ;自动启动exe的路径
  ; run_exe_name=launcher.exe ;自动启动exe 米哈游启动器
  run_exe_name="XXMI Launcher.exe" ;自动启动exe
  run_exe_para= --nogui --xxmi GIMI ;自动启动exe 启动参数
  ;3DMigoto
  ; 3DMigotoLocal=F:\3dm\ ;3DMigoto的"3DMigoto Loader.exe",的路径，如果不需要可不填写或注释掉。
  ;FanHeXie
  ; FanHeXieLocal=F:\desktop\打ち止め\反和谐\ ;反和谐"loader.exe"的路径，如果不需要可不填写，若已运行3DMigoto则不会运行。
  ;游戏内设置
  b_UseFindText=1  ;启用智能判断是否触发按键功能，使用findtext函数，遇到bug自行关闭
  ChangAnX=0    ;启动长按X键为触发一次x，0禁用/1启用，用于下落；建议在游戏内把下落键改为n，（其他时候下落使用S+Space跳的更高）
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  yuanshenName:="ahk_exe "+(game_Name)
  ;读取游戏窗口分辨率
  if WinExist(yuanshenName)
  {
    helpyouxiyiqidong=已
    WinGet, zuidahuazuixiaohua,MinMax , %yuanshenName%
    ;msgbox, %zuidahuazuixiaohua%
    if (zuidahuazuixiaohua==-1)  ;如果最小化了
    {
      WinActivate , %yuanshenName%
      ;sleep 100
      WinGetPos , OutX, OutY, OutWidth, OutHeight, %yuanshenName%
      ;OutWidth:=A_ScreenWidth
    }
    else
    {
      WinGetPos , OutX, OutY, OutWidth, OutHeight, %yuanshenName%
    }
  }
  else
  {
    OutWidth:=A_ScreenWidth
    OutHeight:=A_ScreenHeight
    helpyouxiyiqidong=未
  }
  ;msgbox, %OutWidth%  %zuidahuazuixiaohua%

  help2001=原神AHK帮助`n`n    键盘功能：`n    Home——启动/暂停本软件`n    F3——媒体播放/暂停`n    长按F键——F键连击`n    双击F键——开启持续鼠标左键连点`n    x键/~键——持续按w前进`n    双击w键——持续按w前进`n    Tab键——原神游戏内的○确定键`n    ESC键——点击对话时最下选项`n    ctrl+F9——5个探索派遣`n    请在原神设置将落下键改为n，或启动本软件双击x下落`n`n    鼠标功能：`n    鼠标中键——开启持续鼠标左键连点`n    鼠标侧键1——按w键`n    双击鼠标侧键1——持续按w前进`n    鼠标侧键2——按F键`n    长按鼠标侧键2——连击F键`n    双击并长按鼠标侧键2——ALT键（显示鼠标/快捷元素爆发）

  ;内置参数:
  bSwitch=0
  xh=1
  kalepaimon=0  ;是否禁用esc键，禁用派蒙菜单 用于卡bug卡出派蒙后不要让派蒙消失

  ;if(A_ScreenWidth==3840)
  if(OutWidth>3800) and (OutWidth<3900)
  {
    youshangjiaodetouxiang="|<右上角的主角头像图标4k>*227$66.00000000100000000000U0000000000k0000000000E0000000000E0080000000E00Q0000000M00Q0000000M00w0000000M00w0000000Q00y0000000Q00zU300000Q00tk3U0000C00kw3k0000600kTzk0000701kDzk00003U1k3zs00003k1k0zs00001sXk07w00070yXk03w000Dzzbk00w000Dzzzk00w000Dzzzk00Q000Dzwzk00Q000TzsU"
    zuoxiajiaoEnter="|<Enter4k>*153$71.000000Ds000000CTs1zzk0zU0Dzzw7zzUDzs0Tzzw7zy0zzzUTyTs3y03w7z0TkDs3w07sDy0zUTk7s0TUDw1z0TUDk0z0Q03y0z0TU1y0M07w1y0z07w0k0Ds3w1y0DzzU0Tk7s3w0Tzz00zUDk7s0zzy01z0TUDk1zzw03y0z0TU3y0007w1y0z07w000Ds3w1y0Ds00MTk7s3w0Ds0zUzUDk7s0Ts1z1z0TUDwsTwDy3y0z0TzkTzzw7w1y0Tz0TzzsDk3s0Ts0Dz00000000001UU|<左下角的enter在有对话框时4k>*154$71.0100007s0000000000Dk0000000000TU0000000000z00000000001y0000000wzkDzw1zU00DzzkTzkDzk00Tzzkzz0zDnzkTsTUTU1w7rzUTUz0z07kDzz0z0z1y0DUTU01y1y3w0z0T003w3w7s1y0y007s7sDk3zzw00DkDkTU7zzs00TUTUz0Dzzk00z0z1y0TU0001y1y3w0z00003w3w7s1y00067s7sDk1y03zwDkDkTU3y0zzsTUTUzz3zzjzUz0y0zy3zyTz1w1w0zk3zs001k300000y1"
    quedingQuanQuan="|<4.3圈圈4k>*115$42.z03zs0Ty0Tzy0Dw0zzz0Ds1zzzk7s3zzzk3k7zzzs3kDzzzw3kDzzzw1UDzzzy1UTzzzy0UTzzzz0Uzzzzz0Uzzzzz00zzzzz00zzzzz0Uzzzzz0Uzzzzz0UTzzzz0UTzzzy0UDzzzy1kDzzzw1kDzzzw3k7zzzs3s3zzzk3s1zzzk7U|<4.3副本内圈圈4k>*116$41.k7zzzk7UTzzzk60zzzzkA3zzzzUE7zzzz00Tzzzz00zzzzy01zzzzw03zzzzs07zzzzk0DzzzzU0Tzzzz00zzzzy01zzzzw01zzzzs43zzzzU87zzzz0k7zzzw1k7zzzs7U7zzzUDUDzzy0zU7zzk1z07zz07z03zs0Tz00y01z"
    youxiajiaoditutubiao="|<右下地图的图标4k>*121$38.U0zzk0M0Tzw0607zzU103zzw0E0zzz000Dzzk003zzw000zzz000Dzzk1U3zzw0M0Tzy0707zzU1k0zzk0w07zs0DU0zw07s03w01z00000zs0000Tz0000Dzk0003zy0001zzk000zzw000DzzU007zzw003zs"
    duihuatubiao="|<对话图标最下一个4k>*200$71.zzU0000000zzzy00000000Tzzk00000000TzzU00000000Tzy000000000Tzs000000000TzU000000000Ty0000000000zw0000000000zk0000000000z00000000001y00000000001s00000000003k00000000003U0000000000700000000000A00000000000M00000000000U01s01s03s01007s0Ds0Ds0200Ts0Ts0zs0400zs1zk1zk0803zk3zk3zU0E03zU7z07z00U07z07y0Dy01"
    fubendetiaoguowenzi="|<副本中右上角的跳过文字4k>*200$71.zy0Dzzzzzwzzzy0zzzzzzszzzw1zzzzzzkzzzs3zzzzzzUzzzk7zzzzzz0TjzUDzzzzzz0TTz0Tzzzzzz0STy0zzzzzzzUATw1zzzzzzXU8Ts3zzzzzy3U0zk7zzzzzs3k0zUDzzzzz01k0z0Tzzzzs0000y0zzzzzk0031w1zzzzzU0073s3zzzzzk0QDjk7zzzzzk1kTzUDzzzzzsD0zz0Tzzzzzss3zy0zzzzzzzUDzw1zzzzzzy1zzk3zzzzzzk7s007zzzzzz0Tk00Dzzzzzy3zk00zzzzzzwDz"
    dianjirenyiweizhiguanbi="|<文字：点击任意位置关闭4k>*86$71.000000zUC000000001z0Tzzw000003w0zzzzzzzzzzs1y7zjzzzzzzU3kDzE00007z07UTyU0000Dw0DUzt00000Ts0T0zm1zzz0zU0y1zY3zzy1y21y3z800003wA3w3wE00007ws7w7sU0000DzkDsDl0zzzUTzUTsT21zzz0zz0zkS400003zy1zkw800007zw3zVsE0001zzs7zVUUzkTyDzkDzX001UTkDzUTz6403UTUTz0zzM887UTUTy1zzkkkDVzUTw3zzVVUTvnUzs400070zz7Uzk8001"
  }
  else if(OutWidth>1900) and (OutWidth<1950)
  {
    youshangjiaodetouxiang="|<右上角的主角头像图标1080p>*232$25.0002000100000000800050002U001g800Fy008T0003U0M0k0D080DU407k203s103g0Y3m0y1k0z1kE"
    zuoxiajiaoEnter="|<Enter1080p>*163$55.zy0000000Tz003U00070003k0003U000s0001k0LVzVs2Ms1zszlz7STwSSD1lnzjyD73Usttr07XVkwSw3U3lksTzS1k1ssQDzD0s0wQC7U7UTySC71kHkDzD73wztk7zbXVw7sk4|<左下角的enter在有对话框时1080p>*163$48.zs000000w001k000w001k000w001s000w1zXyDnbzttlkQvzzstlkMtnw0stkwtkw0stkztkw0stkw1kw0stks1kzsstsQNkzsskyDlUU"
    quedingQuanQuan="|<按钮圈圈O1080p>*114$21.z0DzU0Ts00y3y7lzsQDzVXzy8Tzk7zz0zzs7zz0zzs7zy4TzlVzwCDz3kTkT007w03zs1zU|<按钮圈圈2O1080p>*114$21.zUDzk0Ts01y3w7kzsQDzXXzy8zzl7zy8zzs7zz0zzs7zy8TzlXzwADz3kzkT0s7w01zs0zzszw|<之前的失效了这个是新的右下1080p>*116$29.zzzzzzzzzzzw7zzz03zzw01zzkS1zz3z1zwDzXzszz3zVzz7z7zyDyDzyDwTzwTszzszlzzXzXzz7zXzyDz3zszz3zVzz1w7zz00Tzz03zzzUTzzzzzzzzzzz"
    youxiajiaoditutubiao="|<右下地图的图标1080p>*121$19.w07w01w00Q0061w31z11zk0zs0Tw0Dy23y31z1UC0s00y00zU0zk0Tw0Tz0TzUTzsDzyDzzjz"
    duihuatubiao="|<对话图标最下一个1080p>*200$36.zU001zy0000Tw0000Ds00007k00007k00003U00001U00001U000010A1UA10S3kS00S7ky00S3ky00S3kQ0U00001U00001U00001k00003s00007s0000Dw0000Dy0000zz0001zzk003zzy003zU"
    fubendetiaoguowenzi=0
    dianjirenyiweizhiguanbi="|<>*80$71.zzzzzzzzzzzzzzzzzzzzzzzzzzzXzyD7zzzzUT007wS7y0000w007syDwMX0Tz3VzW01s00szy73z401k01lz000QCzDzlzXzzzzsMyT0077z007UlszU000S00D1Xly0000w00Q3bXw00szs00v77Ds01lzlzlyDATk03XzU03wSMzU077z037syHz00CDw2D7lw7y00QTs6CDXyTw0001WDmD401U0003C0CS003003zzy0zwzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
  }
  else
  {
    b_UseFindText=0
  }

  if !WinExist(yuanshenName)
  {
    b_UseFindText=0
  }

  if (v_isReloadByStartGameFromHere==0)
  {
    if(A_IsAdmin)
    {
      ; MsgBox, 4, , %help2001%`n`n%helpyouxiyiqidong%启动原神游戏, 分辨率:(%OutWidth%,%OutHeight%), Pos:(%OutX%,%OutY%),%b_UseFindText%`n(游戏启动后或窗口位置发生变化请重启本软件)`n    Ctrl+Home——重启本软件`n    问：是否不开启"屏蔽ESC键"：卡出了派蒙跟随后点'否'
      MsgBox, 4, , %help2001%`n`n%helpyouxiyiqidong%启动原神游戏, 分辨率:(%OutWidth%,%OutHeight%), Pos:(%OutX%,%OutY%),%b_UseFindText%`n(游戏启动后或窗口位置发生变化请重启本软件)`n    Ctrl+Home——重启本软件
      IfMsgBox yes
      {
        kalepaimon=0
      }
      else IfMsgBox no
      {
        ; kalepaimon=1
        kalepaimon=0
      }

      if !WinExist(yuanshenName)
      {
        MsgBox, 4, ,原神未启动，是否启动原神？`n  （编辑本ahk文件设置原神路径）
        IfMsgBox, yes
        {
          Run, 3DMigoto Loader.exe, %3DMigotoLocal%, UseErrorLevel
          if (ErrorLevel = "ERROR")
          {
            run, loader.exe, %FanHeXieLocal%, UseErrorLevel
            if !(ErrorLevel = "ERROR")
            {
              goto, WaitForYuanShenStart
            }
          }
          else
          {
            sleep 2000
          }
          ; 启动原神（防3dm导致的错误）
          run, %run_exe_name% %run_exe_para%, %run_exe_local%, UseErrorLevel
          if (ErrorLevel = "ERROR")
          {
            MsgBox, 请编辑本ahk文件设置原神.exe的路径
            exitapp
          }
          WaitForYuanShenStart:
          v_isReloadByStartGameFromHere=1
          loop, 40  ;等待120s YuanShen.exe启动
          {
            if WinActive(yuanshenName)
            {
              break
            }
            sleep 3000
          }
          if !WinExist(yuanshenName)
          {
            msgbox, 原神启动等待超时（2min）
            exitapp
          }
          goto ReloadByStartGameFromHere
        }
      }
    }
    else if not (A_IsAdmin)
    {
      MsgBox, 4, , %help2001%`n`n目前不处于管理员权限运行！`n是：继续   否：退出
      IfMsgBox yes
      {

      }
      else IfMsgBox no
      {
        Exitapp
      }
    }

    ;获取管理员权限
    full_command_line := DllCall("GetCommandLine", "str")
    if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
    {
      try ; leads to having the script re-launching itself as administrator
      {
        MsgBox, 4, , 大侠，你原神是用管理员权限启动的，`n本软件需要用管理员权限才可以在你原神内执行模拟键鼠功能。`n`n是否授予管理员权限？`n（建议以后使用快捷方式-高级-勾选以管理员运行）`n`n是：重启本软件   否：退出
        IfMsgBox yes
        {

        }
        else IfMsgBox no
        {
          Exitapp
        }

        if A_IsCompiled
          Run *RunAs "%A_ScriptFullPath%" /restart
        else
          Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
      }
      ExitApp
    }
  }

  ;激活游戏
  WinActivate , %yuanshenName%

;重启
^home::
  suspend permit
  reload
return

^+home::
  Goto findtext91
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;设置需要添加的游戏
#if WinActive(yuanshenName) or WinActive("幻塔2077") or WinActive("ahk_exe StarRail.exe") or WinActive("ahk_exe Client-Win64-Shipping.exe")
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  home::	;暂停
    suspend permit
    SetTimer, loopLbutton, Off
    bSwitch=0
    send {w up}
    xh:=1
    suspend toggle
  return

  ;禁用派蒙菜单 用于卡bug卡出派蒙后不要让派蒙消失
  esc::
    t1:=A_TickCount, Text:=X:=Y:=""
    Text:=duihuatubiao
    if (b_UseFindText) and (ok:=FindText(X, Y, OutWidth/8*5+OutX, OutHeight/2+OutY, OutWidth/4*3+OutX, OutHeight+OutY, 0, 0, Text,,,,,,9))
    {
      MouseGetPos, xpos, ypos, winid
      FindText().Click(X, Y, "L")
      sleep 200
      FindText().Click(X, Y-OutHeight/14, "L",0)
      ;  sleep 400
      ;  click, %xpos%, %ypos%, 1
    }
    else
    {
      if(kalepaimon==1)
      {
        t1:=A_TickCount, Text:=X:=Y:=""
        Text:=zuoxiajiaoEnter
        if !(b_UseFindText) or (ok:=FindText(X, Y, 0+OutX, OutHeight-200+OutY, 350+OutX, OutHeight+OutY, 0, 0, Text))
        {
          ; FindText().Click(X, Y, "L")
          return
        }
        else
        {
          send {esc down}
          sleep 10
          send {esc up}
          ;Msgbox, The cursor is at X%xpos% Y%ypos% and is true.12
          return
        }
      }
      else if(kalepaimon==0)
      {
        send {esc down}
        sleep 10
        send {esc up}
      }
    }
  return

  ;禁用抽卡界面
  F3::Media_Play_Pause
  return
  ;功能同键盘上的Fn+F5,F6,F7分别为上一个、下一个、暂停
  ;（如果小窗不是最前面重启游戏并进入世界后再试）
  ;（如果小窗不是最前面重启游戏并进入世界后再试）
  ;（如果小窗不是最前面重启游戏并进入世界后再试）

  ;按着下面那个键不停输入f；双击F则开启/关闭连点鼠标，连点鼠标后也可以按鼠标左键或空格键取消
  ~f::
    ;if WinActive("原神") or WinActive("幻塔")
    {
      if(bSwitch==1)
      {
        SetTimer, loopLbutton, Off
        bSwitch=0
      }
      KeyWait, f, T0.2
      If Not ErrorLevel
      {
        KeyWait, f, D T0.1
        If Not ErrorLevel
        {
          ;KeyWait, f
          {
            if(bSwitch==0)
            {
              send {Lbutton}
              SetTimer, loopLbutton, 500
              bSwitch=1
            }
            else if(bSwitch==1)
            {
              SetTimer, loopLbutton, Off
              bSwitch=0
            }
          }
        }
      }

      Loop
      {
        If Not GetKeyState("f", "P")
          Break
        if WinActive("崩坏：星穹铁道")
        {
          Send {f down}
          send {lbutton down}
          Sleep 10 ; try various milliseconds
          Send {f up}
          send {lbutton up}
          Sleep 100
        }
        else
        {
          Send {f down}
          Sleep 10 ; try various milliseconds
          Send {f up}
          Sleep 100
        }
      }
    }
  Return

  ;按一下鼠标中间键（元素视野alt点左上角的图标激活）开启/关闭连点鼠标，连点鼠标后也可以按鼠标左键或空格键取消--------------------
  ;~h::
  MButton::
    ;if WinActive("原神") or WinActive("幻塔")
    {
      {
        ; FindText().Click(X, Y, "L")

        if(bSwitch==0)
        {
          send {Lbutton}
          SetTimer, loopLbutton, 500
          bSwitch=1
        }
        else if(bSwitch==1)
        {
          SetTimer, loopLbutton, Off
          bSwitch=0
        }
      }
    }
  return

  loopLbutton:
    ;if WinActive("原神") or WinActive("幻塔")
    {
      Random, vloopPeriod, 100, 200
      SetTimer, loopLbutton, %vloopPeriod% ;引入随机数反作弊（聊胜于无
      Send {lbutton down}
      Random, vAnXiaShiChang, 5, 7
      Sleep %vAnXiaShiChang% ;按下时长
      Send {lbutton up}
    }
  return

  ;连点鼠标后也可以按鼠标左键或空格键取消
  ~Lbutton::
  ~Space::
    ;if WinActive("原神") or WinActive("幻塔")
    {
      if(bSwitch==1)
      {
        SetTimer, loopLbutton, Off
        bSwitch=0
      }
    }
  return
  ;END--------------

  ;按一下x键持续按w前进，再按一次x键停止----------------------
  ~x::
    ; ;长按x则激活x，用于x键下落，但是受不了200毫秒延迟
    if(ChangAnX==1)
    {
      KeyWait, x
      If (A_TimeSinceThisHotkey > 300)
      {
        SetTimer, ChangAnXsendx, -1
        return
      }
    }

    ; ; x为一直按着w，需要在原神设置里把原来的x落下键改为n
    ; if WinActive("原神") or WinActive("幻塔")
    ; {
    ; t1:=A_TickCount, Text:=X:=Y:=""
    ; Text:=zuoxiajiaoEnter
    ; if !(b_UseFindText) or (WinActive("ahk_exe StarRail.exe")) or (ok:=FindText(X, Y, 0+OutX, OutHeight-200+OutY, 350+OutX, OutHeight+OutY, 0, 0, Text))
    ; {
    ;   ; FindText().Click(X, Y, "L")
    ; ;msgbox, b_UseFindText=%b_UseFindText%
    ; if (xh==1)
    ; {
    ; send {w down}
    ; xh:=-1
    ; }
    ; else
    ; {
    ; xh:=1
    ; send {w up}
    ; }
    ; }
    ; }

    ; 如果是 火神头像 则 按 x 为 space space space
    t1:=A_TickCount, Text:=X:=Y:=""
    Text:="|<火神 头像>*153$48.3zzzzzzz1zzzzzzz1zzzzzzz0zzzzzzz0zzzzzzz0Tzzzzzz0Dzzzzzz0Dzzzzzz07zzzzzz0Tzzzzzz1rzzzzzz7lzzzzzzS1zzzzzzQ0zzzzzz0Dzzzzzz0zzzzzzz0zzzzzzz0zzzzzzz0nzzzzzz0Xjzzzzz01Dzzzzz007zzzzz00DTzztz004Dzzlz000DzzV0U"
    if (WinActive("原神") And ok:=FindText(X, Y, 3057, 386, 3838, 1152, 0, 0, Text))
    {
      ; FindText().Click(X, Y, "L")
      send {space down}
      sleep 100
      send {space up}
      sleep 100

      send {space down}
      sleep 100
      send {space up}
      sleep 100

      send {space down}
      sleep 100
      send {space up}

    }
  Return

  ~`::
    {
      if (xh==1)
      {
        send {w down}
        xh:=-1
      }
      else
      {
        xh:=1
        send {w up}
      }
    }
  Return

  ChangAnXsendx:
    Send {x down}
    sleep 50
    Send {x up}
  return

  ; 点两下 w 按住 w
  ~w::
    ;if WinActive("原神") or WinActive("幻塔")
    {
      xh:=1
      KeyWait, w, T0.1
      If Not ErrorLevel
      {
        KeyWait, w, D T0.1
        If Not ErrorLevel
        {
          KeyWait, w, T0.1
          Send {w down}
          xh:=-1
        }
      }
    }
  Return

  ~s::
    ;if WinActive("原神") or WinActive("幻塔")
    {
      if(xh==-1)
      {
        send {w up}
        xh:=1
      }
    }
  return
  ;按一下X键持续按w前进，再按一次X键停止 END-----------------------

  ;宏 爬山2段跳
  ;~ctrl::
  if WinActive("幻塔")
  {
    send {alt up}
    if(xh==-1)
    {
      xh:=1
      send {w up}
      sleep 20
    }

    sleep 200
    send {space}
    sleep 200
    send {space}
    sleep 300

    send {2 down}
    sleep 50
    send {2 up}

    sleep 20
    send {w down}
    xh:=-1

  }
  return

  ;tab键按一下圈圈
  tab::
    MouseGetPos, xpos, ypos, winid
    if WinActive("崩坏：星穹铁道"){
      FindText().Click(3389, 1949, "L")
      sleep 100
      click, %xpos%, %ypos%, 0
      sleep 500

      t1:=A_TickCount, Text:=X:=Y:=""
      Text:="|<确定的√>*108$31.zzzztzzzzsTzzzs7zzzs7zzzs7zzzs7zzzs7zzzs7zzzs7zTzs7z7zs7z1zs7z0Ts7zk7s7zw1s7zz0M7zzk07zzw07zzz07zzzk7zzzw7zzzz7zzzzrzzz"
      if (ok:=FindText(X, Y, 2275-150, 1345-1500, 2275+1500, 1345+1500, 0, 0, Text))
      {
        FindText().Click(X, Y, "L")
      }
      return
    }
    if(bSwitch==1)
    {
      SetTimer, loopLbutton, Off
      bSwitch=0
    }
    ; if(xh==-1)
    ; {
    ; send {w up}
    ; xh:=1
    ; }
    ;if WinActive("原神") or WinActive("幻塔")
    {
      t1:=A_TickCount, Text:=X:=Y:=""
      Text:=quedingQuanQuan
      if (b_UseFindText) and (ok:=FindText(X, Y, OutWidth*1/3+OutX, OutHeight/2+OutY, OutWidth+OutX, OutHeight+OutY, 0, 0, Text))
      {
        FindText().Click(X, Y, "L")
        ;Msgbox, The cursor is at X%xpos% Y%ypos% and is true.
        sleep 100
        click, %xpos%, %ypos%, 0
      }
      else
      {
        t1:=A_TickCount, Text:=X:=Y:=""
        Text:=youxiajiaoditutubiao
        ;X, Y, 0+OutX, OutHeight-200+OutY, 350+OutX, OutHeight+OutY, 0, 0, Text
        if (b_UseFindText) and (ok:=FindText(X, Y, OutWidth-980+OutX, OutHeight-260+OutY, OutWidth+OutX, OutHeight+OutY, 0, 0, Text))
        {
          MouseGetPos, xpos, ypos, winid
          FindText().Click(X, Y, "L")
          sleep 100
          click, %xpos%, %ypos%, 0
        }
        else
        {
          t1:=A_TickCount, Text:=X:=Y:=""
          Text:=dianjirenyiweizhiguanbi
          if (b_UseFindText) and (ok:=FindText(X, Y, OutWidth/8*3+OutX, OutHeight/2+OutY, OutWidth/8*5+OutX, OutHeight+OutY, 0, 0, Text))
          {
            MouseGetPos, xpos, ypos, winid
            FindText().Click(X, Y, "L")
            sleep 100
            click, %xpos%, %ypos%, 0
          }
          else
          {  ;累了,仅在4k下做了适配
            t1:=A_TickCount, Text:=X:=Y:=""
            Text:="|<使用1个浓缩，需要先开启op圣遗物副本左上角的自动跳过领奖动画>*163$71.k1zU0007sTUD01zU060Dkz0Q01zU0S0T3z0s01zk1y0y7y1ly1zk7y1sDw03y0zk7z00zs07w0zs3z01zs6Ds0Ts3z07zkQTk0Ts3y0DzVszU0Dk1w0zzblz007U0E3yzzXy0000007tzz7w000000TlzwDs000001zXzUTk0000s7z3y0zU0001sTy7s1z00007lzw7s3y0000DbzsDs7w0000TzzkDkDs0001zwzUDkTk0003zlz0TkzU000Du3y0Tlz0000TU7w0TXy0000z0DssT7w0003y0TzkT"
            if (ok:=FindText(X, Y, 1095, 1106, 2738, 1367, 0, 0, Text))
            {
              FindText().Click(X+967, Y-5, "L")
            }
            else
            {  ;累了,仅在4k下做了适配
              t1:=A_TickCount, Text:=X:=Y:=""
              Text:="|<替换按钮（右下角4k>*211$71.z00zk0DzzTwDy01zU0TzzzkTzzzzzkzzzz1zzzzzzVzzzw7zzzzzz3zzzzzzzzzzy0Tvzzzzzzzzw0zzzzzz07zk01zjzzzzUDzk03zTzzzzUzzk07yDzzzzXzzk0Dzztzzzzzzs0Tzznznzzlzs0zzzbz1zz1zw3zzzDzzzzzzyzzzyTzzzzzzvzzDwzzzzzzzrzwTtzzzzzzXjzzzzzzzzzz0Dzzzzzs007y0Tzzzzzk00Dw0vzzzzzU00Ts07zzzzzzzzzk0Dw03zzzzzzU0Ts0Dzzzzzz00zk0Tz"
              if (b_UseFindText) and (ok:=FindText(X, Y, OutWidth/2+OutX, OutHeight/4*3+OutY, OutWidth+OutX, OutHeight+OutY, 0, 0, Text))
              {
                MouseGetPos, xpos, ypos, winid
                FindText().Click(X, Y, "L")
                sleep 100
                click, %xpos%, %ypos%, 0
              }
              else
              {
                click
              }
            }
          }
        }
      }
    }
  return

  ~a::  ;累了,仅在4k下做了适配
    ; t1:=A_TickCount, Text:=X:=Y:=""
    ; Text:="|<队伍选择界面左箭头4k璃月>*173$4.BzxnU|<蒙德>*228$12.1z3z7zDzzzzzzzzzDzDz3z1zU"
    ; if (ok:=FindText(X, Y, 142-25, 1080-25, 142+25, 1080+25, 0, 0, Text))
    ; {
    ; FindText().Click(X, Y, "L")
    ; }

    ; 改为判断右上角的 x
    t1:=A_TickCount, Text:=X:=Y:=""
    Text:="|<右上角的x>*222$71.0DzzzyDzzzy00Tzzzzzzzzw00zDzzzzzzbk00s7zzzzzw3U000Dzzzzzs000007zzzzz000000Dzzzzy0000007zzzzk000000DzzzzU0000007zzzw0000000Dzzzs00000007zzz00000000Dzzy00000001zzzz00000003zzzy0000000Tzzzz0000000zzzzy0000007zzzzy000000Dzzzzy000001zzzzzz0000Q3zzzzzy1k01zzzzzzzzDU03zzzzzzzzzU07zzzz7zzzz00Dzzzw7zzzy1"
    if (ok:=FindText(X, Y, 3685-50, 96-50, 3685+50, 96+50, 0, 0, Text))
    {
      click 140,1080,1
    }
  return

  ~d::  ;累了,仅在4k下做了适配
    ; t1:=A_TickCount, Text:=X:=Y:=""
    ; Text:="|<队伍选择界面右箭头4k璃月>*177$4.XCzym8|<4k枫丹>*212$8.UA3UwDnyzzzyzD3Uk800U|<蒙德>*203$9.k70w7kzbyzzzzrwy7Us60U"
    ; if (ok:=FindText(X, Y, 3715-25, 1080-25, 3715+25, 1080+25, 0, 0, Text))
    ; {
    ; FindText().Click(X, Y, "L")
    ; }

    ; 改为判断右上角的 x
    t1:=A_TickCount, Text:=X:=Y:=""
    Text:="|<右上角的x>*222$71.0DzzzyDzzzy00Tzzzzzzzzw00zDzzzzzzbk00s7zzzzzw3U000Dzzzzzs000007zzzzz000000Dzzzzy0000007zzzzk000000DzzzzU0000007zzzw0000000Dzzzs00000007zzz00000000Dzzy00000001zzzz00000003zzzy0000000Tzzzz0000000zzzzy0000007zzzzy000000Dzzzzy000001zzzzzz0000Q3zzzzzy1k01zzzzzzzzDU03zzzzzzzzzU07zzzz7zzzz00Dzzzw7zzzy1"
    if (ok:=FindText(X, Y, 3685-50, 96-50, 3685+50, 96+50, 0, 0, Text))
    {
      click 3700,1080,1
    }
  return

  ~e::  ;累了,仅在4k下做了适配
    t1:=A_TickCount, Text:=X:=Y:=""
    Text:="|<被冰住按space解封4k>*174$71.00003zs000zy00003zU003zw00003y000Dzs00003s000zzk000000003zzU30000000Dzz0TU000000zzy1zU000003zzw7zU00000DzzsTzU00000zzzlzzU00003zzzbzzU0000DzzzTzzU0000zzzzzzzU0003zzzzzzz0000Dzzzzzzz0000Tzzzzzzz0000zzzzTzzy0001zzzyzzzs0003zzzlzzzU0003zzzXzzy00003zzw7zzs00003zzsDzzU00003zz0Tzy000003zy0zzs000003zk1"
    sleep 300
    ; 延迟主要是因为行秋的e弱水附着导致被冰冻
    if (ok:=FindText(X, Y, 2830-100, 1076-100, 2830+100, 1076+100, 0, 0, Text))
    {
      ; FindText().Click(X, Y, "L")
      loop, 8
      {
        send {space down}
        sleep 5
        send {space up}
        sleep 50
      }
    }
    else
    {
      sleep 700
      if (ok:=FindText(X, Y, 2830-100, 1076-100, 2830+100, 1076+100, 0, 0, Text))
      {
        ; FindText().Click(X, Y, "L")
        loop, 8
        {
          send {space down}
          sleep 5
          send {space up}
          sleep 50
        }
      }
    }
  return

  ; 胡桃 aaz space
  1::
    t1:=A_TickCount, Text:=X:=Y:=""
    Text:="|<胡桃头像>*147$46.rzzzzzzzbzzzzzzyDzzzzzzwzzzzzzzzzzzzzznzszzzzz7zlzzzzwHzbzzzzkDzDzzzz0vyzzzzw3bHzzzzk6Q7zzzz08kTzzzw0X1zzzzk087zzzz000Tzzzw003zzzzE00Dzzzx000zzzzk003zzzz0007zzzw000Tzzzy"
    ; 仅搜索 1 号位置
    if (ok:=FindText(X, Y, 3225, 414, 3838, 582, 0, 0, Text))
    {
      ; 我写的
      send {LButton down}
      sleep 5
      send {LButton up}
      sleep 180

      send {LButton down}
      sleep 5
      send {LButton up}
      sleep 150

      send {LButton down}
      sleep 300
      send {LButton up}
      sleep 20

      send {space down}
      sleep 5
      send {space up}

      return
    }
    else{
      ; 胡桃头像没找到
      send {1 down}
      sleep 5
      send {1 up}
      return
    }

  ; 鼠标侧键 1 等于前进，连按两下等于按住 w
  XButton1::
    Send {w down}
    KeyWait, XButton1, T0.2
    If Not ErrorLevel
    {
      Send {w up}
      xh:=1
      KeyWait, XButton1, D T0.1
      If Not ErrorLevel
      {
        Send {w down}
        xh:=-1
      }
    }
    Else
    {
      KeyWait, XButton1
      Send {w up}
      xh:=1
    }
  Return

  ; 鼠标侧键 2 等于 F 键，按住等于连点F键，双击并按住等于 Alt 键显示鼠标
  XButton2::
    send {f}
    KeyWait, XButton2, T0.3
    If Not ErrorLevel
    {
      KeyWait, XButton2, D T0.1
      If Not ErrorLevel
      {
        {
          Send, {LAlt down}
          KeyWait, XButton2
          Send, {LAlt up}
        }
      }
    }
    Loop
    {
      If Not GetKeyState("XButton2", "P")
        Break
      Send {f down}
      Sleep 10 ; try various milliseconds
      Send {f up}

      Sleep 100
    }
  Return

  ;鼠标侧键 2 等于 F 键，按住等于 Alt 键显示鼠标，双击并按住等于连点F键（已禁用）
  ;XButton2::
  send {f}
  KeyWait, XButton2, T0.2
  If ErrorLevel
  {
    Send, {LAlt down}
    KeyWait, XButton2
    Send, {LAlt up}
  }
  else If Not ErrorLevel
  {
    KeyWait, XButton2, D T0.1
    If Not ErrorLevel
    {
      Loop
      {
        If Not GetKeyState("XButton2", "P")
          Break
        Send {f down}
        Sleep 10 ; try various milliseconds
        Send {f up}

        Sleep 100
      }
    }
  }
  Return

  ; 探索派遣函数  ;findtext默认是相对屏幕位置查找的,而AHK默认(CoordMode)是相对活动窗口执行命令的,两相互独立
  TansuoPaiqian(diqux, diquy, didianx, didiany, fenpeijuesex, fenpeijuesey, tanxianshichang20hours) {
    if WinExist(yuanshenName)
    {
      WinGet, zuidahuazuixiaohua,MinMax , %yuanshenName%
      ;msgbox, %zuidahuazuixiaohua%
      if (zuidahuazuixiaohua==-1)  ;如果最小化了先最大化
      {
        WinActivate , %yuanshenName%
        ;sleep 100
        WinGetPos , OutX, OutY, OutWidth, OutHeight, %yuanshenName%
        ;OutWidth:=A_ScreenWidth
      }
      else
      {
        WinGetPos , OutX, OutY, OutWidth, OutHeight, %yuanshenName%
      }
    }
    v_fenbianlvbeilv:=OutWidth/1920  ;分辨率缩放,注意赋值要用:=而不是=
    ;msgbox, v_fenbianlvbeilv=%v_fenbianlvbeilv%  OutWidth=%OutWidth%  OutX=%OutX%

    BlockInput, MouseMove
    MouseMove, diqux*v_fenbianlvbeilv, diquy*v_fenbianlvbeilv ;移动到地区
    Sleep 150
    Click
    sleep 150 ;第一个人总是卡一下

    MouseMove, didianx*v_fenbianlvbeilv, didiany*v_fenbianlvbeilv ;移动到地点
    Sleep 150
    Click
    sleep 50

    MouseMove, 1610*v_fenbianlvbeilv, 1040*v_fenbianlvbeilv ;移动到右下角点2次
    Sleep 150
    Click
    ;sleep 50
    Sleep 250  ;等待点击屏幕
    Click
    sleep 50

    if(tanxianshichang20hours==1)
    {
      ;msgbox, tanxianshichang20hours=%tanxianshichang20hours%
      MouseMove, 1770*v_fenbianlvbeilv, 700*v_fenbianlvbeilv ;鼠标将探险时长调到20小时
      Sleep 150
      Click
      sleep 50
    }

    MouseMove, 1610*v_fenbianlvbeilv, 1040*v_fenbianlvbeilv ;移动到右下角点1次
    Sleep 150
    Click
    sleep 50

    ;msgbox , fenpeijuese
    MouseMove, fenpeijuesex*v_fenbianlvbeilv, fenpeijuesey*v_fenbianlvbeilv ;分配角色
    Sleep 150
    Click

    sleep 200
    BlockInput, MouseMoveOff
  }

  ; 执行5个探索派遣函数
  ^F9::   ;根据分辨率自适应倍数→v_fenbianlvbeilv
    tanxianshichang20hours=0
    MsgBox, 3, , 执行5个探索派遣，根据分辨率自适应倍数，遇到bug请全屏，支持16:9屏幕。`n  (YES-执行/NO-终止/Cancel-执行并把探险时长调到20小时)
    IfMsgBox No
    {
      WinActivate , %yuanshenName%
      return
    }
    IfMsgBox Yes
    {
      WinActivate , %yuanshenName%
      sleep 100
    }
    IfMsgBox, Cancel
    {
      tanxianshichang20hours=1
      WinActivate , %yuanshenName%
      sleep 100
    }
    ; 蒙德(1080p下地区选择x,y,探索点x,y,派遣人物x,y,是否重置探险时长调到20小时)
    TansuoPaiqian(150, 181, 1037, 339, 300, 160, tanxianshichang20hours)
    TansuoPaiqian(150, 181, 1156, 663, 300, 310, tanxianshichang20hours)
    ; 璃月
    TansuoPaiqian(150, 252, 724, 333, 300, 160, tanxianshichang20hours)
    TansuoPaiqian(150, 252, 961, 454, 300, 310, tanxianshichang20hours)
    ;TansuoPaiqian(150, 252, 706, 826, 300, 310, tanxianshichang20hours)  ;莲蓬松茸
    ; 稻妻
    TansuoPaiqian(150, 324, 919, 354, 300, 160, tanxianshichang20hours)  ;稻妻堇瓜
  ; 须弥
  ;TansuoPaiqian(150, 397, 878, 565, 300, 160, tanxianshichang20hours)  ;墩墩桃松果
  ; 枫丹
  ;TansuoPaiqian(150, 468, 876, 467, 300, 160, tanxianshichang20hours)  ;汐藻
  return

  findtext91:
    ;/*
    ;===========================================
    ;  FindText - Capture screen image into text and then find it
    ;  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=17834
    ;
    ;  Author  : FeiYue
    ;  Version : 9.1
    ;  Date    : 2023-07-30
    ;
    ;  Usage:  (required AHK v1.1.34+)
    ;  1. Capture the image to text string.
    ;  2. Test find the text string on full Screen.
    ;  3. When test is successful, you may copy the code
    ;     and paste it into your own script.
    ;     Note: Copy the "FindText()" function and the following
    ;     functions and paste it into your own script Just once.
    ;  4. The more recommended way is to save the script as
    ;     "FindText.ahk" and copy it to the "Lib" subdirectory
    ;     of AHK program, instead of copying the "FindText()"
    ;     function and the following functions, add a line to
    ;     the beginning of your script: #Include <FindText>
    ;  5. If you want to call a method in the "FindTextClass" class,
    ;     use the parameterless FindText() to get the default object
    ;
    ;===========================================
    ;*/
    ;/*
    ;===========================================
    ;  FindText - 屏幕抓字生成字库工具与找字函数
    ;  https://autohotkey.com/boards/viewtopic.php?f=6&t=17834
    ;
    ;  脚本作者 : FeiYue
    ;  最新版本 : 8.9
    ;  更新时间 : 2022-05-28
    ;
    ;  用法:  (需要最新版本 AHK v1.1.31+)
    ;  1. 将本脚本保存为“FindText.ahk”并复制到AHK程序的Lib子目录中
    ;  2. 抓图并生成调用FindText()的代码
    ;     2.1 方式一：直接点击“抓图”按钮
    ;     2.2 方式二：先设定截屏热键，使用热键截屏，再点击“截屏抓图”按钮
    ;  3. 测试一下调用的代码是否成功:直接点击“测试”按钮
    ;  4. 复制调用的代码到自己的脚本中
    ;     4.1 方式一：直接点击“复制”按钮，然后粘贴到自己的脚本中（不推荐）
    ;     4.2 方式二：取消“附加FindText()函数”的选框，然后点击“复制”按钮，
    ;         然后粘贴到自己的脚本中，然后在自己的脚本开头加上一行:
    ;         #Include <FindText>  ; Lib目录中必须有FindText.ahk
    ;  5. 多色查找模式可以一定程度上适应图像的放大缩小，也可以找图
    ;  6. 这个库还可以用于快速截屏、获取颜色、写入颜色、编辑后另存图片
    ;  7. 如果要调用FindTextClass类中的函数，请用无参数的FindText()获取默认对象
    ;
    ;===========================================
    ;*/

    ;--------------------------------
    ;  FindText - 屏幕找字函数
    ;--------------------------------
    ;  返回变量 := FindText(
    ;      OutputX --> 保存返回的X坐标的变量名称
    ;    , OutputY --> 保存返回的Y坐标的变量名称
    ;    , X1 --> 查找范围的左上角X坐标
    ;    , Y1 --> 查找范围的左上角Y坐标
    ;    , X2 --> 查找范围的右下角X坐标
    ;    , Y2 --> 查找范围的右下角Y坐标
    ;    , err1 --> 文字的黑点容错百分率（0.1=10%）
    ;    , err0 --> 背景的白点容错百分率（0.1=10%）
    ;    , Text --> 由工具生成的查找图像的数据，可以一次查找多个，用“|”分隔
    ;    , ScreenShot --> 是否截屏，为0则使用上一次的截屏数据
    ;    , FindAll --> 是否搜索所有位置，为0则找到一个位置就返回
    ;    , JoinText --> 如果想组合查找，可以为1，或者是要查找单词的数组
    ;    , offsetX --> 组合图像的每个字和前一个字的最大横向间隔
    ;    , offsetY --> 组合图像的每个字和前一个字的最大高低间隔
    ;    , dir --> 查找的方向，有上、下、左、右、中心9种
    ;    , zoomW --> 图像宽度的缩放百分率（1.0=100%）
    ;    , zoomH --> 图像高度的缩放百分率（1.0=100%）
    ;  )
    ;
    ;  返回变量 --> 如果没找到结果会返回0。否则返回一个二级数组，
    ;      第一级是每个结果对象，第二级是结果对象的具体信息数组:
    ;      { 1:左上角X, 2:左上角Y, 3:图像宽度W, 4:图像高度H
    ;        , x:中心点X, y:中心点Y, id:图像识别文本 }
    ;  坐标都是相对于屏幕，颜色使用RGB格式
    ;
    ;  如果 OutputX 等于 "wait" 或 "wait1" 意味着等待图像出现，
    ;  如果 OutputX 等于 "wait0" 意味着等待图像消失
    ;  此时 OutputY 设置等待时间的秒数，如果小于0则无限等待
    ;  如果超时则返回0，意味着失败，如果等待图像出现成功，则返回位置数组
    ;  如果等待图像消失成功，则返回 1
    ;  例1: FindText(X:="wait", Y:=3, 0,0,0,0,0,0,Text)   ; 等待3秒等图像出现
    ;  例2: FindText(X:="wait0", Y:=-1, 0,0,0,0,0,0,Text) ; 无限等待等图像消失
    ;--------------------------------

    if (!A_IsCompiled && A_LineFile=A_ScriptFullPath)
      FindText().Gui("Show")

    ;===== Copy The Following Functions To Your Own Code Just once =====

    FindText(ByRef x:="FindTextClass", ByRef y:="", args*)
    {
      static obj:=new FindTextClass()
      return (x=="FindTextClass" && !args.Length()) ? obj : obj.FindText(x, y, args*)
    }

    Class FindTextClass
    {  ;// Class Begin

      __New()
      {
        this.bits:={ Scan0: 0, hBM: 0, oldzw: 0, oldzh: 0 }
        this.bind:={ id: 0, mode: 0, oldStyle: 0 }
        this.Lib:=[]
        this.Cursor:=0
      }

      __Delete()
      {
        if (this.bits.hBM)
          DllCall("DeleteObject", "Ptr",this.bits.hBM)
      }

      help()
      {
        return "
(
;--------------------------------
;  FindText - Capture screen image into text and then find it
;  Version : 9.1  (2023-07-30)
;--------------------------------
;  returnArray:=FindText(
;      OutputX --> The name of the variable used to store the returned X coordinate
;    , OutputY --> The name of the variable used to store the returned Y coordinate
;    , X1 --> the search scope's upper left corner X coordinates
;    , Y1 --> the search scope's upper left corner Y coordinates
;    , X2 --> the search scope's lower right corner X coordinates
;    , Y2 --> the search scope's lower right corner Y coordinates
;    , err1 --> Fault tolerance percentage of text       (0.1=10%)
;    , err0 --> Fault tolerance percentage of background (0.1=10%)
;    , Text --> can be a lot of text parsed into images, separated by '|'
;    , ScreenShot --> if the value is 0, the last screenshot will be used
;    , FindAll --> if the value is 0, Just find one result and return
;    , JoinText --> if you want to combine find, it can be 1, or an array of words to find
;    , offsetX --> Set the max text offset (X) for combination lookup
;    , offsetY --> Set the max text offset (Y) for combination lookup
;    , dir --> Nine directions for searching: up, down, left, right and center
;    , zoomW --> Zoom percentage of image width  (1.0=100%)
;    , zoomH --> Zoom percentage of image height (1.0=100%)
;  )
;
;  The function returns an Array containing all lookup results,
;  any result is a object with the following values:
;  {1:X, 2:Y, 3:W, 4:H, x:X+W//2, y:Y+H//2, id:Comment}
;  If no image is found, the function returns 0.
;  All coordinates are relative to Screen, colors are in RGB format
;
;  If the return variable is set to 'ok', ok[1] is the first result found.
;  ok[1].1, ok[1].2 is the X, Y coordinate of the upper left corner of the found image,
;  ok[1].3 is the width of the found image, and ok[1].4 is the height of the found image,
;  ok[1].x <==> ok[1].1+ok[1].3//2 ( is the Center X coordinate of the found image ),
;  ok[1].y <==> ok[1].2+ok[1].4//2 ( is the Center Y coordinate of the found image ),
;  ok[1].id is the comment text, which is included in the <> of its parameter.
;
;  If OutputX is equal to 'wait' or 'wait1'(appear), or 'wait0'(disappear)
;  it means using a loop to wait for the image to appear or disappear.
;  the OutputY is the wait time in seconds, time less than 0 means infinite waiting
;  Timeout means failure, return 0, and return other values means success
;  If you want to appear and the image is found, return the found array object
;  If you want to disappear and the image cannot be found, return 1
;  Example 1: FindText(X:='wait', Y:=3, 0,0,0,0,0,0,Text)   ; Wait 3 seconds for appear
;  Example 2: FindText(X:='wait0', Y:=-1, 0,0,0,0,0,0,Text) ; Wait indefinitely for disappear
;--------------------------------
)"
      }

      FindText(ByRef OutputX:="", ByRef OutputY:=""
        , x1:=0, y1:=0, x2:=0, y2:=0, err1:=0, err0:=0, text:=""
        , ScreenShot:=1, FindAll:=1, JoinText:=0, offsetX:=20, offsetY:=10
        , dir:=1, zoomW:=1, zoomH:=1)
      {
        local
        if (OutputX ~= "i)^\s*wait[10]?\s*$")
        {
          found:=!InStr(OutputX,"0"), time:=Round(OutputY,3)
            , timeout:=A_TickCount+Round(time*1000)
          Loop
          {
            ; Wait for the image to remain stable
            While (ok:=this.FindText(,, x1, y1, x2, y2
              , err1, err0, text, ScreenShot, FindAll
              , JoinText, offsetX, offsetY, dir, zoomW, zoomH))
              && (found)
            {
              x:=ok[1].1, y:=ok[1].2, w:=ok[1].3, h:=ok[1].4
              Sleep 10
              if this.FindText(,, x, y, x+w-1, y+h-1
                , err1, err0, text, ScreenShot, FindAll
                , JoinText, offsetX, offsetY, dir, zoomW, zoomH)
              {
                OutputX:=ok[1].x, OutputY:=ok[1].y, this.ok:=ok
                return ok
              }
            }
            if (!found && !ok)
              return 1
            if (time>=0 && A_TickCount>=timeout)
              Break
            Sleep 50
          }
          return 0
        }
        SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
        x1:=Floor(x1), y1:=Floor(y1), x2:=Floor(x2), y2:=Floor(y2)
        if (x1=0 && y1=0 && x2=0 && y2=0)
          n:=150000, x:=y:=-n, w:=h:=2*n
        else
          x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
        bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy)
          , x-=zx, y-=zy, info:=[], this.ok:=0
        Loop Parse, text, |
          if IsObject(j:=this.PicInfo(A_LoopField))
            info.Push(j)
        if (w<1 || h<1 || !(num:=info.Length()) || !bits.Scan0)
        {
          SetBatchLines, %bch%
          return 0
        }
        arr:=[], info2:=[], k:=0, s:=""
          , mode:=(IsObject(JoinText) ? 2 : JoinText ? 1 : 0)
        For i,j in info
        {
          k:=Max(k, j[2]*j[3]), v:=(mode=1 ? i : j[10]) . ""
          if (mode && v!="")
            s.="|" v, (!info2.HasKey(v) && info2[v]:=[]), info2[v].Push(j)
        }
        sx:=x, sy:=y, sw:=w, sh:=h
          , JoinText:=(mode=1 ? [s] : JoinText)
          , VarSetCapacity(s1, k*4), VarSetCapacity(s0, k*4)
          , VarSetCapacity(ss, sw*(sh+2))
          , FindAll:=(dir=9 ? 1 : FindAll)
          , allpos_max:=(FindAll || JoinText ? 10240 : 1)
          , ini:={ sx:sx, sy:sy, sw:sw, sh:sh, zx:zx, zy:zy
            , mode:mode, bits:bits, ss:&ss, s1:&s1, s0:&s0
            , err1:err1, err0:err0, allpos_max:allpos_max
            , zoomW:zoomW, zoomH:zoomH }
        Loop 2
        {
          if (err1=0 && err0=0) && (num>1 || A_Index>1)
            ini.err1:=err1:=0.05, ini.err0:=err0:=0.05
          if (!JoinText)
          {
            VarSetCapacity(allpos, allpos_max*4), allpos_ptr:=&allpos
            For i,j in info
              Loop % this.PicFind(ini, j, dir, sx, sy, sw, sh, allpos_ptr)
              {
                pos:=NumGet(allpos, 4*A_Index-4, "uint")
                  , x:=Mod(pos,sw)+sx+zx, y:=pos//sw+sy+zy
                  , w:=Floor(j[2]*zoomW), h:=Floor(j[3]*zoomH), comment:=j[10]
                  , arr.Push({1:x, 2:y, 3:w, 4:h, x:x+w//2, y:y+h//2, id:comment})
                if (!FindAll)
                  Break 3
              }
          }
          else
            For k,v in JoinText
            {
              v:=RegExReplace(v, "\s*\|[|\s]*", "|")
                , v:=StrSplit(Trim(v,"|"), (InStr(v,"|")?"|":""), " `t")
              if (v.Length()<1)
                Continue
              this.JoinText(ini, arr, info2, v, offsetX, offsetY, FindAll
                , 1, v.Length(), dir, 0, 0, sx, sy, sw, sh)
              if (!FindAll && arr.Length())
                Break 2
            }
          if (err1!=0 || err0!=0 || arr.Length() || info[1][4] || info[1][7]=5)
            Break
        }
        if (dir=9 && arr.Length())
          arr:=this.Sort2(arr, (x1+x2)//2, (y1+y2)//2)
        SetBatchLines, %bch%
        if (arr.Length())
        {
          OutputX:=arr[1].x, OutputY:=arr[1].y, this.ok:=arr
          return arr
        }
        return 0
      }

      ; the join text object <==> [ "abc", "xyz", "a1|a2|a3" ]

      JoinText(ini, arr, info2, text, offsetX, offsetY, FindAll
        , index, Len, dir, minY, maxY, sx, sy, sw, sh)
      {
        local
        VarSetCapacity(allpos, ini.allpos_max*4), allpos_ptr:=&allpos
          , zoomW:=ini.zoomW, zoomH:=ini.zoomH
        For i,j in info2[text[index]]
          if (ini.mode=1 || text[index]==j[10])
            Loop % this.PicFind(ini, j, dir, sx, sy, sw1:=(index=1 ? sw
              : Min(sx+offsetX+Floor(j[2]*zoomW),ini.sx+ini.sw)-sx), sh, allpos_ptr)
            {
              pos:=NumGet(allpos, 4*A_Index-4, "uint")
                , x:=Mod(pos,sw1)+sx, y:=pos//sw1+sy
                , w:=Floor(j[2]*zoomW), h:=Floor(j[3]*zoomH)
                , (index=1) && (ini.x:=x, minY:=y, maxY:=y+h)
              if (index<Len)
              {
                minY1:=Min(y, minY), maxY1:=Max(y+h, maxY)
                  , sy1:=Max(minY1-offsetY, ini.sy)
                  , sh1:=Min(maxY1+offsetY, ini.sy+ini.sh)-sy1
                if this.JoinText(ini, arr, info2, text, offsetX, offsetY, FindAll
                  , index+1, Len, 5, minY1, maxY1, x+w, sy1, 0, sh1)
                  && (index>1 || !FindAll)
                  return 1
              }
              else
              {
                comment:=""
                For k,v in text
                  comment.=(ini.mode=1 ? info2[v][1][10] : v)
                w:=x+w-ini.x, x:=ini.x+ini.zx
                  , h:=Max(y+h,maxY)-Min(y,minY), y:=Min(y,minY)+ini.zy
                  , arr.Push({1:x, 2:y, 3:w, 4:h, x:x+w//2, y:y+h//2, id:comment})
                if (index>1 || !FindAll)
                  return 1
              }
            }
      }

      PicFind(ini, j, dir, sx, sy, sw, sh, allpos_ptr)
      {
        local
        static MyFunc:=""
        if (!MyFunc)
        {
          x32:=""
            . "5557565383EC7483BC2488000000058BBC24C00000000F84DA0900008B8424C4"
            . "00000085C00F8EBE0F0000C744240800000000C74424100000000031EDC70424"
            . "00000000C7442414000000008D7426008B8424BC0000008B4C241431F631DB01"
            . "C885FF8944240C7F3DE98F00000066900FAF8424A800000089C189F099F7FF01"
            . "C18B44240C803C1831744D8B8424B800000083C30103B424D8000000890CA883"
            . "C50139DF74538B44240899F7BC24C400000083BC24880000000375B40FAF8424"
            . "9C00000089C189F099F7FF8D0C818B44240C803C183175B38B04248B9424B400"
            . "000083C30103B424D8000000890C8283C00139DF89042475AD017C2414834424"
            . "10018B9C24DC0000008B442410015C2408398424C40000000F8532FFFFFF8B04"
            . "24BBAD8BDB68896C24080FAF8424C800000089C1F7EB89C88B4C24080FAF8C24"
            . "CC000000C1F81F89C589D6C1FE0C29EE8974244889C8C1F91FF7EBC1FA0C29CA"
            . "8954245083BC2488000000030F84770A00008B84249C0000008BB424A0000000"
            . "0FAF8424A40000008BBC24880000008D2CB08B8424A80000008BB4249C000000"
            . "F7D885FF8D04868944241C0F856D0300008B84248C0000008BB424AC000000C7"
            . "44241800000000C7442420000000008B7C2404C1E8100FB6C08944240C8B8424"
            . "8C0000000FB6C4894424100FB684248C000000894424148B8424A8000000C1E0"
            . "0285F68944242889E80F8EBA0000008B9C24A800000085DB0F8E8D0000008BB4"
            . "24980000008B6C242003AC24B000000001C60344242889442424038424980000"
            . "00894424040FB67E028B4C240C0FB646010FB6162B4424102B54241489FB01CF"
            . "29CB8D8F000400000FAFC00FAFCBC1E00B0FAFCB01C1B8FE05000029F80FAFC2"
            . "0FAFD001CA399424900000000F93450083C60483C5013B74240475A98B9C24A8"
            . "000000015C24208B44242483442418010344241C8B74241839B424AC0000000F"
            . "854AFFFFFF897C24048B34248B5C2448B80000000039DE89C30F4FDE8B742450"
            . "39742408891C240F8EDC0800008B34248B44240839C60F4DC6894424648B8424"
            . "8800000083E80383E0FD0F84AF0600008B8424A80000002B8424D8000000C784"
            . "24A400000000000000C78424A0000000000000008944245C8B8424AC0000002B"
            . "8424DC0000008944243C8B84249400000083E80183F8070F87100600008BB424"
            . "A000000083F80389442444897424588BB424A4000000897424680F8EF5050000"
            . "8B74245C397424580F8F7F0C00008B44245C8B3424C744242C00000000894424"
            . "608B8424B40000008D04B08B7424448944245489F083E0018944244C89F08BB4"
            . "249800000083E0038944246C8B4424688B5C243C39D80F8F1C010000837C246C"
            . "018B7C24580F4F7C2460895C243089442420897C24408B7C24648DB600000000"
            . "8B4C244C8B44243085C90F44442420837C244403894424240F8F7702000083BC"
            . "2488000000058B442440894424288B4424280F847F02000083BC248800000003"
            . "0F84BA0300000FAF8424A80000000344242485FF89C2894424180F8464030000"
            . "8B6C24508B5C244831C0039424B00000008B0C2489742414896C2410895C240C"
            . "8B6C2408EB158D76008DBC270000000083C00139C70F842503000039C873188B"
            . "9C24B40000008B348301D6803E007507836C240C01781C39C576D58B9C24B800"
            . "00008B348301D6803E0175C4836C24100179BD8B74241489F68DBC2700000000"
            . "8344242001836C2430018B4424203944243C0F8D08FFFFFF8344245801836C24"
            . "60018B4424583944245C0F8DBCFEFFFF8B44242C83C4745B5E5F5DC2580083BC"
            . "2488000000010F84E409000083BC2488000000020F84AD0700008B84248C0000"
            . "000FB6BC248C000000C744241800000000C744242800000000C1E8100FB6D08B"
            . "84248C0000008954240C0FB69424900000000FB6DC8B842490000000C1E8100F"
            . "B6C88B8424900000000FB6F48B44240C29C8034C240C8944242C89D829F001DE"
            . "8944241089D089FA29C201F889742414894424248BB424AC0000008B8424A800"
            . "0000894C240C89E9895424208B6C242CC1E00285F6894424300F8EEAFCFFFF8B"
            . "9C24A800000085DB0F8E880000008B8424980000008B542428039424B0000000"
            . "01C8034C243089CF894C242C03BC2498000000EB34395C240C7C3D394C24107F"
            . "37394C24147C3189F30FB6F3397424200F9EC3397424240F9DC183C00483C201"
            . "21D9884AFF39F8741E0FB658020FB648010FB63039DD7EBD31C983C00483C201"
            . "884AFF39F875E28BB424A8000000017424288B4C242C8344241801034C241C8B"
            . "442418398424AC0000000F854FFFFFFFE934FCFFFF8B44242483BC2488000000"
            . "05894424288B442440894424248B4424280F8581FDFFFF0FAF84249C0000008B"
            . "5C242485FF8D0498894424100F848B0000008B6C244831C9897C240C8D742600"
            . "8B8424B40000008B5C2410031C888B8424B80000008B3C880FB6441E0289FAC1"
            . "EA100FB6D229D00FB6541E010FB61C1E0FAFC03B4424047F2789F80FB6C429C2"
            . "0FAFD23B5424047F1789F80FB6C029C30FAFDB3B5C24047E108DB42600000000"
            . "83ED010F880702000083C101394C240C758E89BC248C0000008B7C240C8B8424"
            . "D00000008344242C018B5C242C85C00F846BFDFFFF8B5424282B9424A4000000"
            . "0FAF9424A80000008B4424242B8424A00000008B8C24D000000001D03B9C24D4"
            . "000000894499FC0F8C33FDFFFF8B44242C83C4745B5E5F5DC25800908D742600"
            . "8B7424148B142485D274928B9C24B00000008B4C24188B8424B400000001D98B"
            . "5C24548B1083C00401CA39D8C6020075F2E967FFFFFF8D76008DBC2700000000"
            . "0FAF84249C0000008B5C24248D0498894424100384248C00000085FF0FB65C06"
            . "02895C24140FB65C06010FB60406895C24188944241C0F8421FFFFFF8B442450"
            . "31DB897C240C894424388B442448894424348B4424048D76008DBC2700000000"
            . "3B1C2473658B8424B40000008B4C24108B7C2414030C980FB6440E020FB6540E"
            . "010FB60C0E2B5424182B4C241C89C501F829FD8DB8000400000FAFD20FAFFDC1"
            . "E20B0FAFFDBDFE05000029C50FAFE901FA0FAFCD01D13B8C2490000000760B83"
            . "6C2434010F8896000000395C240876618B8424B80000008B4C24108B7C241403"
            . "0C980FB6440E020FB6540E010FB60C0E2B5424182B4C241C89C501F829FD8DB8"
            . "000400000FAFD20FAFFDC1E20B0FAFFDBDFE05000029C50FAFE901FA0FAFCD01"
            . "D13B8C24900000007707836C243801782F83C301395C240C0F8522FFFFFF8944"
            . "24048B7C240CE912FEFFFF908D74260089BC248C0000008B7C240CE980FBFFFF"
            . "894424048B7C240CE973FBFFFFC7442444000000008B44243C8B74245C894424"
            . "5C8B8424A40000008974243C894424588B8424A000000089442468E9E0F9FFFF"
            . "C744246400000000C744245000000000C744240800000000C70424000000008B"
            . "8424A8000000038424A00000002B8424D80000008944245C8B8424A400000003"
            . "8424AC0000002B8424DC0000008944243CE954F9FFFF8B84248C0000000FAFC0"
            . "894424048B84249000000085C00F841C0200008B842490000000C1E8100FB6C0"
            . "894424188B8424900000000FB6C4894424200FB684249000000081AC24900000"
            . "0000000001894424288B8424C400000085C00F8EC20500008D04BD0000000031"
            . "F689BC24C0000000C744241400000000C744241C0000000089F78944242C31C0"
            . "8B9424C000000085D20F8EE20000008BAC24BC000000C704240000000001C503"
            . "44242C89442424038424BC000000894424100FB645000FB64D020FB65D0189C6"
            . "894424088B84249000000085C0743189C82B4424188B5424040FAFC039C27C20"
            . "89D82B4424200FAFC039C27C1389F02B4424280FAFC039C27D5C8DB600000000"
            . "8B442414C1E1108D34BD0000000099F7BC24C40000000FAF84249C0000008944"
            . "240C8B042499F7BC24C00000008B54240C8D04828B9424B40000008904BA89D8"
            . "83C701C1E00809C10B4C24088B8424B8000000890C3083C5048BB424D8000000"
            . "0134243B6C24100F8545FFFFFF8B4424248344241C018B8C24DC0000008B7424"
            . "1C014C241439B424C40000000F85EEFEFFFF893C248B34248B8C24C8000000BA"
            . "AD8BDB680FAFCE89C8C1F91FF7EAC1FA0C89D029C839C6894424480F8EDFFDFF"
            . "FFC7442450000000008B3424B800000000C74424080000000089C385F60F49DE"
            . "895C2464E914F7FFFF8B84248C000000C1E8100FAF8424DC00000099F7BC24C4"
            . "0000000FAF84249C00000089C10FB784248C0000000FAF8424D800000099F7FF"
            . "8D04818984248C000000E99AF6FFFF8BAC24BC00000031DB31F6C70424000000"
            . "00EB19B80A0000006BF60AF7E331DB01F289DE89CB01C311D683C5010FB64500"
            . "85C00F842DFFFFFF8D48D083F90976D383F82F75E48B04248D14850000000089"
            . "54240889DA0FACF2100FB7C20FAF8424DC00000099F7BC24C40000008B94249C"
            . "0000000FAFD00FB7C331DB0FAF8424D800000089D199F7FF8B9424B40000008D"
            . "04818B0C2489048A89C88B54240883C00189042489F08BB424B8000000890416"
            . "31F6E972FFFFFF8BB424A80000008B8424B0000000C744240C00000000C74424"
            . "10000000008D04708944242489F0C1E002894424148B8424AC00000085C00F8E"
            . "A5F5FFFF8B8424A800000085C07E598B8C24980000008B5C24248BBC24980000"
            . "00035C241001E9036C241401EF8D76000FB651020FB6410183C1040FB671FC83"
            . "C3016BC04B6BD22601C289F0C1E00429F001D0C1F8078843FF39CF75D38BB424"
            . "A8000000017424108344240C01036C241C8B44240C398424AC00000075868B84"
            . "24A8000000C74424140000000031FF83E8018944241C8B8424AC00000083E801"
            . "894424208B8424A800000085C00F8E220100008B6C241489FB8B4424248BB424"
            . "A80000008D4F0185ED8BAC24B00000008D14380F944424182B9C24A800000001"
            . "FE01C601EF897C241001C331C0895C240C85C00F84B4000000807C2418000F85"
            . "A90000003944241C0F849F0000008B7C2414397C24200F84910000000FB63A0F"
            . "B66AFF03BC248C00000089BC249000000039AC2490000000BF0100000072600F"
            . "B66A0139AC249000000072538B5C240C0FB62B39AC249000000072430FB62E39"
            . "AC249000000072370FB66BFF39AC2490000000722A0FB66B0139AC2490000000"
            . "721D0FB66EFF39AC249000000072100FB67E0139BC24900000000F92C389DF8B"
            . "6C241089FB89CF885C0500EB0A8B5C241089CFC604030283C00183C10183C201"
            . "83C6018344240C01398424A80000000F851CFFFFFF83442414018B4424143984"
            . "24AC0000000F85B9FEFFFFE9B9F3FFFF8B84248C0000008B8C24AC000000C744"
            . "240C00000000C74424100000000083C001C1E0078984248C0000008B8424A800"
            . "0000C1E00285C98944241489E88BAC248C0000000F8E6FF3FFFF8B9424A80000"
            . "0085D27E658B8C24980000008B5C2410039C24B000000001C103442414894424"
            . "180384249800000089C78DB6000000000FB651020FB641010FB6316BC04B6BD2"
            . "2601C289F0C1E00429F001D039C50F970383C10483C30139F975D58B9C24A800"
            . "0000015C24108B4424188344240C010344241C8B74240C39B424AC0000000F85"
            . "76FFFFFFE9E0F2FFFFC744245000000000C744244800000000C7442408000000"
            . "00C7042400000000E957F1FFFFC744242C00000000E9F6F4FFFFC74424480000"
            . "0000C7042400000000C744245000000000E993FBFFFF90909090909090909090"
          x64:=""
            . "4157415641554154555756534881EC88000000488BBC24F00000004C8BA42420"
            . "01000083F905898C24D000000089542468448944240C44898C24E80000004C8B"
            . "AC2428010000488B9C24300100004C8B942438010000448BBC24400100000F84"
            . "DA090000448B8424480100004585C00F8EB60F000044897424144889BC24F000"
            . "00004531DB4C89AC24280100008BBC244801000031F6448BAC24D0000000448B"
            . "B4247001000031EDC7442410000000004531C04C89A424200100000F1F440000"
            . "4531C94585FF478D24077F36EB7C66900FAF84241001000089C14489C89941F7"
            . "FF01C143803C0231418D4001743F4863D64501F183C6014439E0890C934189C0"
            . "74484489D899F7FF4183FD0375C20FAF8424F800000089C14489C89941F7FF43"
            . "803C02318D0C81418D400175C14C8B8424280100004863D54501F183C5014439"
            . "E041890C904189C075B8834424100144039C24780100008B44241039C70F855D"
            . "FFFFFF8B8C245001000041B8AD8BDB68448B742414488BBC24F00000004C8BA4"
            . "24200100004C8BAC24280100000FAFCD89C8C1F91F4189CA8B8C245801000041"
            . "F7E80FAFCEC1FA0C4189D14529D189C8C1F91F44894C243C41F7E8C1FA0C29CA"
            . "8954244483BC24D0000000030F84320A00008B8424F80000008B8C2400010000"
            . "0FAF8424080100008D04888B8C24F8000000894424108B842410010000F7D88D"
            . "0481894424188B8424D000000085C00F856C0300008B4C24684889C84189CB0F"
            . "B6C441C1EB1089C20FB6C1450FB6DB89C18B84241801000085C00F8EFB000000"
            . "8B842410010000448B7C240C4531D2896C24204C89AC242801000089D5C74424"
            . "1400000000897424244189CDC1E00248899C24300100008944241C8BB4241001"
            . "00008B842410010000448B4C24104401D685C07E70418D41024489CA4489D10F"
            . "B61417440FB63407418D41010FB6040789D34589F04501DE4429EB418D960004"
            . "00004529D829E8410FAFD00FAFC0410FAFD0C1E00B8D0402BAFE0500004429F2"
            . "0FAFD30FAFD301D04139C7410F93040C4183C2014183C1044139F275988B5C24"
            . "1C015C241083442414018B7424188B44241401742410398424180100000F8558"
            . "FFFFFF8B6C24208B7424244C8BAC2428010000488B9C24300100003B6C243CB8"
            . "000000000F4EE83B7424440F8E9F08000039F54189F3440F4DDD8B8424D00000"
            . "0083E80383E0FD0F849A0600008B8424100100002B842470010000C784240801"
            . "000000000000C784240001000000000000894424708B8424180100002B842478"
            . "010000894424308B8424E800000083E80183F8070F870B0600008B8C24000100"
            . "0083F80389442438894C246C8B8C2408010000894C24780F8EF00500008B4C24"
            . "70394C246C0F8F590C00008B4424708B4C24384C89A424200100004C89AC2428"
            . "0100004589DC4C8B9C2420010000C744242000000000894424748D45FF498D44"
            . "85044189ED89F5488BB42428010000488944244889C883E0018944244089C883"
            . "E0038944247C8B4424788B4C243039C80F8FFB000000837C247C018B54246C0F"
            . "4F54247448899C24300100004889F3488BB42430010000894C24248944241489"
            . "5424348B44244085C08B4424240F44442414837C243803894424180F8F6F0200"
            . "0083BC24D0000000058B4424348944241C0F847702000083BC24D0000000030F"
            . "847B0300008B4C241C0FAF8C2410010000034C24184585E40F8437030000448B"
            . "542444448B4C243C31C0EB110F1F40004883C0014139C40F86180300004439E8"
            . "89C273144189C84403048343803C030075064183E901781839D576D489CA0314"
            . "8641803C130175C84183EA0179C266908344241401836C2424018B4424143944"
            . "24300F8D3BFFFFFF4889F04889DE4889C38344246C01836C2474018B44246C39"
            . "4424700F8DDDFEFFFF8B4424204881C4880000005B5E5F5D415C415D415E415F"
            . "C383BC24D0000000010F84D709000083BC24D0000000020F84D70600008B5424"
            . "68448B4C240C89D0440FB6DA450FB6C1C1E810440FB6D04889D00FB6CC4489C8"
            . "4589D7C1E8100FB6D04C89C84189C90FB6C44129D74401D289C14489C84189D2"
            . "29C831D24401C9894424244489C04589D84129C04401D84531C9448944241489"
            . "44241C448B8424180100008B842410010000C1E0024585C0894424200F8E19FD"
            . "FFFF896C242C4C89AC24280100008B6C2424448B6C2410448974242889742430"
            . "4189CE48899C24300100004489D64489CB448B9C24100100008B8C2410010000"
            . "4489E84101D385C97F38EB6D0F1F40004439CE7C4E4439C57F494539C67C4444"
            . "39542414410F9EC1443954241C410F9DC083C20183C0044521C84139D3448801"
            . "74328D4802440FB60C0F8D4801440FB6040F89C1440FB6140F89D14C01E14539"
            . "CF7EAD83C2014531C083C0044139D344880175CE44036C242083C30144036C24"
            . "18399C24180100000F8563FFFFFF448B7424288B6C242C8B7424304C8BAC2428"
            . "010000488B9C2430010000E92BFCFFFF8B44241883BC24D0000000058944241C"
            . "8B442434894424180F8589FDFFFF8B44241C8B4C24180FAF8424F80000004585"
            . "E4448D14887473448B4C243C4531C04989DF4489D243031487428B1C8689D98D"
            . "4202C1E9100FB6C90FB6040729C88D4A010FB614170FAFC00FB60C0F4439F07F"
            . "1F0FB6C729C10FAFC94439F17F120FB6C329C20FAFD24439F27E0F0F1F440000"
            . "4183E9010F88FB0100004983C0014539C4779F895C24684C89FB834424200148"
            . "83BC246001000000448B5424200F845DFDFFFF8B54241C2B9424080100004963"
            . "C20FAF9424100100008B4C24182B8C240001000001CA443B942468010000488B"
            . "8C2460010000895481FC0F8C20FDFFFFE954FDFFFF4585ED74A04C8B44244848"
            . "89D889CA03104883C0044C39C041C604130075EEEB84662E0F1F840000000000"
            . "8B44241C8B4C24180FAF8424F80000008D04884189C7034424684585E48D5002"
            . "0FB60C178D50010FB604070FB61417895424100F8441FFFFFF8B5424444989D9"
            . "4C895C245048895C24584989F24531C04589FB89C348897424608954242C8B54"
            . "243C89542428662E0F1F8400000000004539E873634489DA4103118D4202440F"
            . "B634078D42010FB614170FB604072B4424104589F74101CE29DA418DB6000400"
            . "004129CF410FAFF70FAFC0410FAFF741BFFE050000C1E00B4529F7440FAFFA01"
            . "F0410FAFD701C23B54240C760B836C2428010F88990000004439C5765F4489DA"
            . "4103128D4202440FB634078D42010FB614170FB604072B4424104589F74101CE"
            . "29DA418DB6000400004129CF410FAFF70FAFC0410FAFF741BFFE050000C1E00B"
            . "4529F7440FAFFA01F0410FAFD701C23B54240C7707836C242C0178354183C001"
            . "4983C2044983C1044539C40F851FFFFFFF4C8B5C2450488B5C2458488B742460"
            . "E915FEFFFF895C24684C89FBE97FFBFFFF4C8B5C2450488B5C2458488B742460"
            . "E96BFBFFFFC7442438000000008B4424308B4C2470894424708B842408010000"
            . "894C24308944246C8B84240001000089442478E9E5F9FFFF4531DBC744244400"
            . "00000031F631ED8B842410010000038424000100002B84247001000089442470"
            . "8B842408010000038424180100002B84247801000089442430E969F9FFFF8B44"
            . "24688B4C240C4189C6440FAFF085C90F84F00100008B74240C8B942448010000"
            . "89F0C1E8100FB6C0894424184889F00FB6C48944242089F0400FB6F62D000000"
            . "0185D2897424288944240C0F8EC0050000428D04BD00000000C7442410000000"
            . "00C744241C0000000031EDC74424240000000044897424148944242C4889BC24"
            . "F00000004C89A4242001000031F64531E44585FF448B5C24240F8EAC00000090"
            . "418D4302450FB60402418D4301410FB60C024489D8450FB60C028B44240C85C0"
            . "742E4489C02B4424188B7C24140FAFC039C77C1C89C82B4424200FAFC039C77C"
            . "0F4489C82B4424280FAFC039C77D3C908B44241041C1E010C1E1084409C14C63"
            . "F583C5014409C999F7BC24480100000FAF8424F800000089C789F09941F7FF8D"
            . "0487438944B50042890CB34183C4014183C30403B424700100004539E70F855D"
            . "FFFFFF8B7C242C017C24248344241C018BB424780100008B44241C0174241039"
            . "8424480100000F8520FFFFFF448B742414488BBC24F00000004C8BA424200100"
            . "008B8C2450010000BAAD8BDB680FAFCD89C8C1F91FF7EAC1FA0C29CA39D58954"
            . "243C0F8E10FEFFFFC74424440000000085EDB8000000000F49C531F64189C3E9"
            . "56F7FFFF448B5424684489D0C1E8100FAF84247801000099F7BC24480100000F"
            . "AF8424F800000089C1410FB7C20FAF8424700100009941F7FF8D048189442468"
            . "E9F6F6FFFF4531DB31ED31C08D4801410FB6040285C00F8465FFFFFF8D50D083"
            . "FA090F879F0200004B8D049B4C8D1C4289C8EBD88B842410010000448B942418"
            . "0100004531C0C74424140000000001C048984D8D1C048B842410010000C1E002"
            . "4585D28944241C0F8E8EF6FFFF448BBC2410010000448B8C24100100008B4C24"
            . "104501C74585C97E510F1F80000000008D41024489C24183C001440FB60C078D"
            . "41010FB60407456BC9266BC04B4101C189C883C104440FB614074489D0C1E004"
            . "4429D04401C8C1F8074539F84188041375BE8B4C241C014C241083442414018B"
            . "5424188B44241401542410398424180100000F8575FFFFFF8B8424100100008B"
            . "4C240C4531D2448B8C24100100004889BC24F00000004531FF48899C24300100"
            . "0044897424204489D383E801896C24248974242889C28B8424180100004C89AC"
            . "242801000089D783E801894424108B842410010000F7D08944241C4585C90F8E"
            . "0701000085DB4489FE478D2C0F400F94C54429CE458D77FF8974240C8B74241C"
            . "41B80100000031C04401FE89742414428D343F89742418660F1F840000000000"
            . "85C0418D14070F84040100004084ED0F85FB00000039C70F84F3000000395C24"
            . "100F84E9000000458D1406410FB60C134C01E2034C2468430FB6341341BA0100"
            . "000039F1726F438D3407410FB6343339F172628B74240C01C6410FB6343339F1"
            . "7253428D3428410FB6343339F172468B74241401C6410FB6343339F172378B74"
            . "240C4401C6410FB6343339F172278B742418448D1406430FB6341341BA010000"
            . "0039F17210478D1428470FB614134439D1410F92C283C0014183C00144881241"
            . "39C10F8538FFFFFF4589EF83C301399C24180100000F85E0FEFFFF448B742420"
            . "8B6C24248B742428894C240C488BBC24F00000004C8BAC2428010000488B9C24"
            . "30010000E952F4FFFF0F1F800000000083C0014183C00141C60414024139C10F"
            . "85DBFEFFFFEBA183F82F0F8560FDFFFF4C89D84C63CD83C50148C1E8100FB7C0"
            . "0FAF84247801000099F7BC24480100000FAF8424F80000004189C0410FB7C349"
            . "C1EB200FAF8424700100009941F7FF418D04804389448D0046891C8B89C84531"
            . "DBE9E6FCFFFF8B4424684531FF4531C083C001C1E007894424688B8424100100"
            . "00C1E002894424148B84241801000085C00F8EA4F3FFFF448974241C448B7424"
            . "68448B9C24100100008B8424100100008B4C24104501C385C07E500F1F440000"
            . "8D41024489C2440FB60C078D41010FB60407456BC9266BC04B4101C189C8440F"
            . "B614074489D0C1E0044429D04401C84139C6410F9704144183C00183C1044539"
            . "C375BD8B4C2414014C24104183C7018B4C2418014C24104439BC241801000075"
            . "80448B74241CE910F3FFFFC744244400000000C744243C0000000031F631EDE9"
            . "80F1FFFFC744242000000000E918F5FFFFC744243C0000000031EDC744244400"
            . "000000E988FBFFFF9090909090909090"
          this.MCode(MyFunc, A_PtrSize=8 ? x64:x32)
        }
        text:=j[1], w:=j[2], h:=j[3]
          , err1:=(j[4] ? j[5] : ini.err1)
          , err0:=(j[4] ? j[6] : ini.err0)
          , mode:=j[7], color:=j[8], n:=j[9]
        return (!ini.bits.Scan0) ? 0 : DllCall(&MyFunc
          , "int",mode, "uint",color, "uint",n, "int",dir
          , "Ptr",ini.bits.Scan0, "int",ini.bits.Stride
          , "int",sx, "int",sy, "int",sw, "int",sh
          , "Ptr",ini.ss, "Ptr",ini.s1, "Ptr",ini.s0
          , (mode=5 && n>0 ? "Ptr":"AStr"),text, "int",w, "int",h
          , "int",Floor(err1*10000), "int",Floor(err0*10000)
          , "Ptr",allpos_ptr, "int",ini.allpos_max
          , "int",Floor(w*ini.zoomW), "int",Floor(h*ini.zoomH))
      }

      code()
      {
        return "
(

//***** C source code of machine code *****

int __attribute__((__stdcall__)) PicFind(
  int mode, unsigned int c, unsigned int n, int dir
  , unsigned char * Bmp, int Stride
  , int sx, int sy, int sw, int sh
  , unsigned char * ss, unsigned int * s1, unsigned int * s0
  , unsigned char * text, int w, int h, int err1, int err0
  , unsigned int * allpos, int allpos_max
  , int new_w, int new_h )
{
  unsigned int o, i, j;
  int ok, v, e1, e0, len1, len0, max;
  int x, y, x1, y1, x2, y2, x3, y3, r, g, b, rr, gg, bb;
  int r_min, r_max, g_min, g_max, b_min, b_max;
  unsigned char * gs;
  unsigned long long sum;
  ok=0; o=0; len1=0; len0=0;
  //----------------------
  // MultiColor or PixelSearch or ImageSearch Mode
  if (mode==5)
  {
    v=c*c;
    if (n>0)
    {
      rr=(n>>16)&0xFF; gg=(n>>8)&0xFF; bb=n&0xFF; n-=0x1000000;
      for (y=0; y<h; y++)
      {
        for (x=0; x<w; x++, o+=4)
        {
          r=text[2+o]; g=text[1+o]; b=text[o];
          if (n==0 || (r-rr)*(r-rr)>v
          || (g-gg)*(g-gg)>v || (b-bb)*(b-bb)>v)
          {
            s1[len1]=(y*new_h/h)*Stride+(x*new_w/w)*4;
            s0[len1++]=(r<<16)|(g<<8)|b;
          }
        }
      }
    }
    else
    {
      for (sum=0; (j=text[o++])!='\0';)
      {
        if (j>='0' && j<='9')
          sum = sum*10 + (j-'0');
        else if (j=='/')
        {
          y=(sum>>16)&0xFFFF; x=sum&0xFFFF;
          s1[len1]=(y*new_h/h)*Stride+(x*new_w/w)*4;
          s0[len1++]=sum>>32; sum=0;
        }
      }
    }
    goto StartLookUp;
  }
  //----------------------
  // Generate Lookup Table
  for (y=0; y<h; y++)
  {
    for (x=0; x<w; x++)
    {
      if (mode==3)
        i=(y*new_h/h)*Stride+(x*new_w/w)*4;
      else
        i=(y*new_h/h)*sw+(x*new_w/w);
      if (text[o++]=='1')
        s1[len1++]=i;
      else
        s0[len0++]=i;
    }
  }
  //----------------------
  // Color Position Mode
  // only used to recognize multicolored Verification Code
  if (mode==3)
  {
    y=c>>16; x=c&0xFFFF;
    c=(y*new_h/h)*Stride+(x*new_w/w)*4;
    goto StartLookUp;
  }
  //----------------------
  // Generate Two Value Image
  o=sy*Stride+sx*4; j=Stride-sw*4; i=0;
  if (mode==0)  // Color Mode
  {
    rr=(c>>16)&0xFF; gg=(c>>8)&0xFF; bb=c&0xFF;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
      {
        r=Bmp[2+o]-rr; g=Bmp[1+o]-gg; b=Bmp[o]-bb; v=r+rr+rr;
        ss[i]=((1024+v)*r*r+2048*g*g+(1534-v)*b*b<=n) ? 1:0;
      }
  }
  else if (mode==1)  // Gray Threshold Mode
  {
    c=(c+1)<<7;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
        ss[i]=(Bmp[2+o]*38+Bmp[1+o]*75+Bmp[o]*15<c) ? 1:0;
  }
  else if (mode==2)  // Gray Difference Mode
  {
    gs=ss+sw*2;
    for (y=0; y<sh; y++, o+=j)
    {
      for (x=0; x<sw; x++, o+=4, i++)
        gs[i]=(Bmp[2+o]*38+Bmp[1+o]*75+Bmp[o]*15)>>7;
    }
    for (i=0, y=0; y<sh; y++)
      for (x=0; x<sw; x++, i++)
      {
        if (x==0 || y==0 || x==sw-1 || y==sh-1)
          ss[i]=2;
        else
        {
          n=gs[i]+c;
          ss[i]=(gs[i-1]>n || gs[i+1]>n
          || gs[i-sw]>n   || gs[i+sw]>n
          || gs[i-sw-1]>n || gs[i-sw+1]>n
          || gs[i+sw-1]>n || gs[i+sw+1]>n) ? 1:0;
        }
      }
  }
  else  // (mode==4) Color Difference Mode
  {
    r=(c>>16)&0xFF; g=(c>>8)&0xFF; b=c&0xFF;
    rr=(n>>16)&0xFF; gg=(n>>8)&0xFF; bb=n&0xFF;
    r_min=r-rr; g_min=g-gg; b_min=b-bb;
    r_max=r+rr; g_max=g+gg; b_max=b+bb;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
      {
        r=Bmp[2+o]; g=Bmp[1+o]; b=Bmp[o];
        ss[i]=(r>=r_min && r<=r_max
            && g>=g_min && g<=g_max
            && b>=b_min && b<=b_max) ? 1:0;
      }
  }
  //----------------------
  StartLookUp:
  err1=len1*err1/10000;
  err0=len0*err0/10000;
  if (err1>=len1) len1=0;
  if (err0>=len0) len0=0;
  max=(len1>len0) ? len1 : len0;
  if (mode==5 || mode==3)
  {
    x1=sx; y1=sy; x2=sx+sw-new_w; y2=sy+sh-new_h;
  }
  else
  {
    x1=0; y1=0; x2=sw-new_w; y2=sh-new_h; sx=0; sy=0;
  }
  // 1 ==> ( Left to Right ) Top to Bottom
  // 2 ==> ( Right to Left ) Top to Bottom
  // 3 ==> ( Left to Right ) Bottom to Top
  // 4 ==> ( Right to Left ) Bottom to Top
  // 5 ==> ( Top to Bottom ) Left to Right
  // 6 ==> ( Bottom to Top ) Left to Right
  // 7 ==> ( Top to Bottom ) Right to Left
  // 8 ==> ( Bottom to Top ) Right to Left
  if (dir<1 || dir>8) dir=1;
  if (--dir>3) { r=y1; y1=x1; x1=r; r=y2; y2=x2; x2=r; }
  for (y3=y1; y3<=y2; y3++)
  {
    for (x3=x1; x3<=x2; x3++)
    {
      y=((dir&3)>1) ? y1+y2-y3 : y3;
      x=(dir&1) ? x1+x2-x3 : x3;
      if (dir>3) { r=y; y=x; x=r; }
      //----------------------
      e1=err1; e0=err0;
      if (mode==5)
      {
        o=y*Stride+x*4;
        for (i=0; i<max; i++)
        {
          j=o+s1[i]; c=s0[i]; r=Bmp[2+j]-((c>>16)&0xFF);
          g=Bmp[1+j]-((c>>8)&0xFF); b=Bmp[j]-(c&0xFF);
          if ((r*r>v || g*g>v || b*b>v) && (--e1)<0)
            goto NoMatch;
        }
      }
      else if (mode==3)
      {
        o=y*Stride+x*4;
        j=o+c; rr=Bmp[2+j]; gg=Bmp[1+j]; bb=Bmp[j];
        for (i=0; i<max; i++)
        {
          if (i<len1)
          {
            j=o+s1[i]; r=Bmp[2+j]-rr; g=Bmp[1+j]-gg; b=Bmp[j]-bb; v=r+rr+rr;
            if ((1024+v)*r*r+2048*g*g+(1534-v)*b*b>n && (--e1)<0)
              goto NoMatch;
          }
          if (i<len0)
          {
            j=o+s0[i]; r=Bmp[2+j]-rr; g=Bmp[1+j]-gg; b=Bmp[j]-bb; v=r+rr+rr;
            if ((1024+v)*r*r+2048*g*g+(1534-v)*b*b<=n && (--e0)<0)
              goto NoMatch;
          }
        }
      }
      else
      {
        o=y*sw+x;
        for (i=0; i<max; i++)
        {
          if (i<len1 && ss[o+s1[i]]==0 && (--e1)<0) goto NoMatch;
          if (i<len0 && ss[o+s0[i]]==1 && (--e0)<0) goto NoMatch;
        }
        // Clear the image that has been found
        for (i=0; i<len1; i++)
          ss[o+s1[i]]=0;
      }
      ok++;
      if (allpos!=0)
      {
        allpos[ok-1]=(y-sy)*sw+(x-sx);
        if (ok>=allpos_max) goto Return1;
      }
      NoMatch:;
    }
  }
  //----------------------
  Return1:
  return ok;
}

)"
      }

      PicInfo(text)
      {
        local
        static info:=[], bmp:=[]
        if !InStr(text, "$")
          return
        key:=(r:=StrLen(text))<10000 ? text
          : DllCall("ntdll\RtlComputeCrc32", "uint",0
          , "Ptr",&text, "uint",r*(1+!!A_IsUnicode), "uint")
        if info.HasKey(key)
          return info[key]
        v:=text, comment:="", seterr:=err1:=err0:=0
        ; You Can Add Comment Text within The <>
        if RegExMatch(v, "O)<([^>\n]*)>", r)
          v:=StrReplace(v,r[0]), comment:=Trim(r[1])
        ; You can Add two fault-tolerant in the [], separated by commas
        if RegExMatch(v, "O)\[([^\]\n]*)]", r)
        {
          v:=StrReplace(v,r[0]), r:=StrSplit(r[1] ",", ",")
            , seterr:=1, err1:=r[1], err0:=r[2]
        }
        color:=StrSplit(v,"$")[1], v:=Trim(SubStr(v,InStr(v,"$")+1))
        mode:=InStr(color,"##") ? 5
          : InStr(color,"-") ? 4 : InStr(color,"#") ? 3
          : InStr(color,"**") ? 2 : InStr(color,"*") ? 1 : 0
        color:=RegExReplace(color, "[*#\s]")
        if (mode=5)
        {
          ; You can use Text:="##10-RRGGBB $ d:\a.bmp"
          ; then the 0xRRGGBB(+/-10) as transparent color
          if (v~="[^\s\w\-/,]")  ; ImageSearch
          {
            if !(hBM:=LoadPicture(v))
              return
            this.GetBitmapWH(hBM, w, h)
            if (w<1 || h<1)
              return
            hBM2:=this.CreateDIBSection(w, h, 32, Scan0)
            this.CopyHBM(hBM2, 0, 0, hBM, 0, 0, w, h)
            DllCall("DeleteObject", "Ptr",hBM)
            if (!Scan0)
              return
            ; All images used for ImageSearch are cached
            bmp.Push(r:=this.Buffer(w*h*4)), v:=r.Ptr
            DllCall("RtlMoveMemory", "Ptr",v, "Ptr",Scan0, "Ptr",w*h*4)
            DllCall("DeleteObject", "Ptr",hBM2)
            r:=RegExReplace(Trim(color,"-"), "i)-(?!0x)", "-0x")
            n:=InStr(r,"-") ? Floor(StrSplit(r,"-")[2]) + 0x2000000 : 0x1000000
          }
          else
          {
            v:=RegExReplace(RegExReplace(v,"\s"), "i)/-?\w+/(?!0x)", "$00x")
            v:=Trim(StrReplace(v, ",", "/"), "/")
            r:=StrSplit(v, "/"), n:=r.Length()//3
            if (!n)
              return
            VarSetCapacity(v, n*18*(1+!!A_IsUnicode))
            x1:=x2:=Floor(r[1]), y1:=y2:=Floor(r[2])
            SetFormat, IntegerFast, d
            Loop % n + 0*(i:=-2)
              x:=Floor(r[i+=3]), y:=Floor(r[i+1])
                , (x<x1 && x1:=x), (x>x2 && x2:=x)
                , (y<y1 && y1:=y), (y>y2 && y2:=y)
            Loop % n + 0*(i:=-2)
              x:=Floor(r[i+=3]), y:=Floor(r[i+1])
                , v.=(x-x1)|(y-y1)<<16|(Floor(r[i+2])&0xFFFFFF)<<32 . "/"
            w:=x2-x1+1, h:=y2-y1+1, n:=0
          }
          color:=Floor(StrSplit(color "-","-")[1])
        }
        else
        {
          r:=StrSplit(v ".", "."), w:=Floor(r[1])
            , v:=this.base64tobit(r[2]), h:=StrLen(v)//w
          if (w<1 || h<1 || StrLen(v)!=w*h)
            return
          if (mode=4)
          {
            r:=StrSplit(StrReplace(color, "0x"), "-")
              , color:=Floor("0x" r[1]), n:=Floor("0x" r[2])
          }
          else
          {
            r:=StrSplit(color "@", "@")
              , color:=Floor(r[1]), n:=r[2]
              , n:=Round(n,2)+(!n), n:=Floor(512*9*255*255*(1-n)*(1-n))
            if (mode=3)
              color:=(((color-1)//w)<<16)|Mod(color-1,w)
          }
        }
        return info[key]:=[v, w, h, seterr, err1, err0, mode, color, n, comment]
      }

      Buffer(size, FillByte:="")
      {
        buf:={}, buf.SetCapacity("a", size), p:=buf.GetAddress("a")
          , (FillByte!="" && DllCall("RtlFillMemory","Ptr",p,"Ptr",size,"uchar",FillByte))
          , buf.Ptr:=p, buf.Size:=size
        return buf
      }

      GetBitsFromScreen(ByRef x:=0, ByRef y:=0, ByRef w:=0, ByRef h:=0
        , ScreenShot:=1, ByRef zx:=0, ByRef zy:=0, ByRef zw:=0, ByRef zh:=0)
      {
        local
        static CAPTUREBLT:=""
  (!IsObject(this.bits) && this.bits:={}), bits:=this.bits
  if (!ScreenShot && bits.Scan0)
  {
    zx:=bits.zx, zy:=bits.zy, zw:=bits.zw, zh:=bits.zh
    , w:=Min(x+w,zx+zw), x:=Max(x,zx), w-=x
    , h:=Min(y+h,zy+zh), y:=Max(y,zy), h-=y
    return bits
  }
  bch:=A_BatchLines, cri:=A_IsCritical
  Critical
  if (id:=this.BindWindow(0,0,1))
  {
    WinGet, id, ID, ahk_id %id%
    WinGetPos, zx, zy, zw, zh, ahk_id %id%
  }
  if (!id)
  {
    SysGet, zx, 76
    SysGet, zy, 77
    SysGet, zw, 78
    SysGet, zh, 79
  }
  bits.zx:=zx, bits.zy:=zy, bits.zw:=zw, bits.zh:=zh
  , w:=Min(x+w,zx+zw), x:=Max(x,zx), w-=x
  , h:=Min(y+h,zy+zh), y:=Max(y,zy), h-=y
  if (zw>bits.oldzw || zh>bits.oldzh || !bits.hBM)
  {
    DllCall("DeleteObject", "Ptr",bits.hBM)
    , bits.hBM:=this.CreateDIBSection(zw, zh, bpp:=32, ppvBits)
    , bits.Scan0:=(!bits.hBM ? 0:ppvBits)
    , bits.Stride:=((zw*bpp+31)//32)*4
    , bits.oldzw:=zw, bits.oldzh:=zh
  }
  if (!ScreenShot || w<1 || h<1 || !bits.hBM)
  {
    Critical, %cri%
    SetBatchLines, %bch%
    return bits
  }
  if IsFunc(k:="GetBitsFromScreen2")
    && %k%(bits, x-zx, y-zy, w, h)
  {
    zx:=bits.zx, zy:=bits.zy, zw:=bits.zw, zh:=bits.zh
    Critical, %cri%
    SetBatchLines, %bch%
    return bits
  }
  if (CAPTUREBLT="")  ; thanks Descolada
  {
    DllCall("Dwmapi\DwmIsCompositionEnabled", "Int*",i:=0)
    CAPTUREBLT:=i ? 0 : 0x40000000
  }
  mDC:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM:=DllCall("SelectObject", "Ptr",mDC, "Ptr",bits.hBM, "Ptr")
  if (id)
  {
    if (mode:=this.BindWindow(0,0,0,1))<2
    {
      hDC2:=DllCall("GetDCEx", "Ptr",id, "Ptr",0, "int",3, "Ptr")
      DllCall("BitBlt","Ptr",mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
        , "Ptr",hDC2, "int",x-zx, "int",y-zy, "uint",0xCC0020|CAPTUREBLT)
      DllCall("ReleaseDC", "Ptr",id, "Ptr",hDC2)
    }
    else
    {
      hBM2:=this.CreateDIBSection(zw, zh)
      mDC2:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
      oBM2:=DllCall("SelectObject", "Ptr",mDC2, "Ptr",hBM2, "Ptr")
      DllCall("PrintWindow", "Ptr",id, "Ptr",mDC2, "uint",(mode>3)*3)
      DllCall("BitBlt","Ptr",mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
        , "Ptr",mDC2, "int",x-zx, "int",y-zy, "uint",0xCC0020)
      DllCall("SelectObject", "Ptr",mDC2, "Ptr",oBM2)
      DllCall("DeleteDC", "Ptr",mDC2)
      DllCall("DeleteObject", "Ptr",hBM2)
    }
  }
  else
  {
    win:=DllCall("GetDesktopWindow", "Ptr")
    , hDC:=DllCall("GetWindowDC", "Ptr",win, "Ptr")
    , DllCall("BitBlt","Ptr",mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
      , "Ptr",hDC, "int",x, "int",y, "uint",0xCC0020|CAPTUREBLT)
    , DllCall("ReleaseDC", "Ptr",win, "Ptr",hDC)
  }
  if this.CaptureCursor(0,0,0,0,0,1)
    this.CaptureCursor(mDC, zx, zy, zw, zh)
  DllCall("SelectObject", "Ptr",mDC, "Ptr",oBM)
  , DllCall("DeleteDC", "Ptr",mDC)
  Critical, %cri%
  SetBatchLines, %bch%
  return bits
}

CreateDIBSection(w, h, bpp:=32, ByRef ppvBits:=0, ByRef bi:="")
{
  VarSetCapacity(bi, 40, 0), NumPut(40, bi, 0, "int")
  , NumPut(w, bi, 4, "int"), NumPut(-h, bi, 8, "int")
  , NumPut(1, bi, 12, "short"), NumPut(bpp, bi, 14, "short")
  return DllCall("CreateDIBSection", "Ptr",0, "Ptr",&bi
    , "int",0, "Ptr*",ppvBits:=0, "Ptr",0, "int",0, "Ptr")
}

GetBitmapWH(hBM, ByRef w, ByRef h)
{
  local
  VarSetCapacity(bm, size:=(A_PtrSize=8 ? 32:24), 0)
  r:=DllCall("GetObject", "Ptr",hBM, "int",size, "Ptr",&bm)
  w:=NumGet(bm,4,"int"), h:=Abs(NumGet(bm,8,"int"))
  return r
}

CopyHBM(hBM1, x1, y1, hBM2, x2, y2, w2, h2)
{
  local
  if (w2<1 || h2<1 || !hBM1 || !hBM2)
    return
  mDC1:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM1:=DllCall("SelectObject", "Ptr",mDC1, "Ptr",hBM1, "Ptr")
  mDC2:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM2:=DllCall("SelectObject", "Ptr",mDC2, "Ptr",hBM2, "Ptr")
  DllCall("BitBlt", "Ptr",mDC1
    , "int",x1, "int",y1, "int",w2, "int",h2, "Ptr",mDC2
    , "int",x2, "int",y2, "uint",0xCC0020)
  DllCall("SelectObject", "Ptr",mDC2, "Ptr",oBM2)
  DllCall("DeleteDC", "Ptr",mDC2)
  DllCall("SelectObject", "Ptr",mDC1, "Ptr",oBM1)
  DllCall("DeleteDC", "Ptr",mDC1)
}

CopyBits(Scan01,Stride1,x1,y1,Scan02,Stride2,x2,y2,w2,h2,Reverse:=0)
{
  local
  if (w2<1 || h2<1 || !Scan01 || !Scan02)
    return
  p1:=Scan01+(y1-1)*Stride1+x1*4
  , p2:=Scan02+(y2-1)*Stride2+x2*4, w2*=4
  if (Reverse)
    p2+=(h2+1)*Stride2, Stride2:=-Stride2
  ListLines % (lls:=A_ListLines)?0:0
  Loop % h2
    DllCall("RtlMoveMemory","Ptr",p1+=Stride1,"Ptr",p2+=Stride2,"Ptr",w2)
  ListLines %lls%
}

; Bind the window so that it can find images when obscured
; by other windows, it's equivalent to always being
; at the front desk. Unbind Window using FindText().BindWindow(0)

BindWindow(bind_id:=0, bind_mode:=0, get_id:=0, get_mode:=0)
{
  local
  (!IsObject(this.bind) && this.bind:={}), bind:=this.bind
  if (get_id)
    return bind.id
  if (get_mode)
    return bind.mode
  if (bind_id)
  {
    bind.id:=bind_id, bind.mode:=bind_mode, bind.oldStyle:=0
    if (bind_mode & 1)
    {
      WinGet, i, ExStyle, ahk_id %bind_id%
      bind.oldStyle:=i
      WinSet, Transparent, 255, ahk_id %bind_id%
      Loop 30
      {
        Sleep 100
        WinGet, i, Transparent, ahk_id %bind_id%
      }
      Until (i=255)
    }
  }
  else
  {
    bind_id:=bind.id
    if (bind.mode & 1)
      WinSet, ExStyle, % bind.oldStyle, ahk_id %bind_id%
    bind.id:=0, bind.mode:=0, bind.oldStyle:=0
  }
}

; Use FindText().CaptureCursor(1) to Capture Cursor
; Use FindText().CaptureCursor(0) to Cancel Capture Cursor

CaptureCursor(hDC:=0, zx:=0, zy:=0, zw:=0, zh:=0, get_cursor:=0)
{
  local
  if (get_cursor)
    return this.Cursor
  if (hDC=1 || hDC=0) && (zw=0)
  {
    this.Cursor:=hDC
    return
  }
  VarSetCapacity(mi, 40, 0), NumPut(16+A_PtrSize, mi, "int")
  DllCall("GetCursorInfo", "Ptr",&mi)
  bShow:=NumGet(mi, 4, "int")
  hCursor:=NumGet(mi, 8, "Ptr")
  x:=NumGet(mi, 8+A_PtrSize, "int")
  y:=NumGet(mi, 12+A_PtrSize, "int")
  if (!bShow) || (x<zx || y<zy || x>=zx+zw || y>=zy+zh)
    return
  VarSetCapacity(ni, 40, 0)
  DllCall("GetIconInfo", "Ptr",hCursor, "Ptr",&ni)
  xCenter:=NumGet(ni, 4, "int")
  yCenter:=NumGet(ni, 8, "int")
  hBMMask:=NumGet(ni, (A_PtrSize=8?16:12), "Ptr")
  hBMColor:=NumGet(ni, (A_PtrSize=8?24:16), "Ptr")
  DllCall("DrawIconEx", "Ptr",hDC
    , "int",x-xCenter-zx, "int",y-yCenter-zy, "Ptr",hCursor
    , "int",0, "int",0, "int",0, "int",0, "int",3)
  DllCall("DeleteObject", "Ptr",hBMMask)
  DllCall("DeleteObject", "Ptr",hBMColor)
}

MCode(ByRef code, hex)
{
  local
  VarSetCapacity(code, len:=StrLen(hex)//2)
  DllCall("crypt32\CryptStringToBinary", "Str",hex, "uint",0
    , "uint",4 , "Ptr",&code, "uint*",len, "Ptr",0, "Ptr",0)
  DllCall("VirtualProtect", "Ptr",&code, "Ptr",len, "uint",0x40, "Ptr*",0)
}

base64tobit(s)
{
  local
  static Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  ListLines % (lls:=A_ListLines)?0:0
  SetFormat, IntegerFast, d
  Loop Parse, Chars
    if InStr(s, A_LoopField, 1)
      s:=RegExReplace(s, "[" A_LoopField "]", ((i:=A_Index-1)>>5&1)
      . (i>>4&1) . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1))
  s:=RegExReplace(RegExReplace(s,"[^01]+"),"10*$")
  ListLines %lls%
  return s
}

bit2base64(s)
{
  local
  ListLines % (lls:=A_ListLines)?0:0
  s:=RegExReplace(s,"[^01]+")
  s.=SubStr("100000",1,6-Mod(StrLen(s),6))
  s:=RegExReplace(s,".{6}","|$0")
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  SetFormat, IntegerFast, d
  Loop Parse, Chars
    s:=StrReplace(s, "|" . ((i:=A_Index-1)>>5&1)
    . (i>>4&1) . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1), A_LoopField)
  ListLines %lls%
  return s
}

ASCII(s)
{
  local
  if RegExMatch(s, "O)\$(\d+)\.([\w+/]+)", r)
  {
    s:=RegExReplace(this.base64tobit(r[2]),".{" r[1] "}","$0`n")
    s:=StrReplace(StrReplace(s,"0","_"),"1","0")
  }
  else s:=""
  return s
}

; You can put the text library at the beginning of the script,
; and Use FindText().PicLib(Text,1) to add the text library to PicLib()'s Lib,
; Use FindText().PicLib("comment1|comment2|...") to get text images from Lib

PicLib(comments, add_to_Lib:=0, index:=1)
{
  local
  (!IsObject(this.Lib) && this.Lib:=[]), Lib:=this.Lib
  , (!Lib.HasKey(index) && Lib[index]:=[]), Lib:=Lib[index]
  if (add_to_Lib)
  {
    re:="O)<([^>\n]*)>[^$\n]+\$[^""\r\n]+"
    Loop Parse, comments, |
      if RegExMatch(A_LoopField, re, r)
      {
        s1:=Trim(r[1]), s2:=""
        Loop Parse, s1
          s2.="_" . Format("{:d}",Ord(A_LoopField))
        Lib[s2]:=r[0]
      }
    Lib[""]:=""
  }
  else
  {
    Text:=""
    Loop Parse, comments, |
    {
      s1:=Trim(A_LoopField), s2:=""
      Loop Parse, s1
        s2.="_" . Format("{:d}",Ord(A_LoopField))
      if Lib.HasKey(s2)
        Text.="|" . Lib[s2]
    }
    return Text
  }
}

; Decompose a string into individual characters and get their data

PicN(Number, index:=1)
{
  return this.PicLib(RegExReplace(Number,".","|$0"), 0, index)
}

; Use FindText().PicX(Text) to automatically cut into multiple characters
; Can't be used in ColorPos mode, because it can cause position errors

PicX(Text)
{
  local
  if !RegExMatch(Text, "O)(<[^$\n]+)\$(\d+)\.([\w+/]+)", r)
    return Text
  v:=this.base64tobit(r[3]), Text:=""
  c:=StrLen(StrReplace(v,"0"))<=StrLen(v)//2 ? "1":"0"
  txt:=RegExReplace(v,".{" r[2] "}","$0`n")
  While InStr(txt,c)
  {
    While !(txt~="m`n)^" c)
      txt:=RegExReplace(txt,"m`n)^.")
    i:=0
    While (txt~="m`n)^.{" i "}" c)
      i:=Format("{:d}",i+1)
    v:=RegExReplace(txt,"m`n)^(.{" i "}).*","$1")
    txt:=RegExReplace(txt,"m`n)^.{" i "}")
    if (v!="")
      Text.="|" r[1] "$" i "." this.bit2base64(v)
  }
  return Text
}

; Screenshot and retained as the last screenshot.

ScreenShot(x1:=0, y1:=0, x2:=0, y2:=0)
{
  this.FindText(,, x1, y1, x2, y2)
}

; Get the RGB color of a point from the last screenshot.
; If the point to get the color is beyond the range of
; Screen, it will return White color (0xFFFFFF).

GetColor(x, y, fmt:=1)
{
  local
  bits:=this.GetBitsFromScreen(,,,,0,zx,zy,zw,zh)
  , c:=(x<zx || x>=zx+zw || y<zy || y>=zy+zh || !bits.Scan0)
  ? 0xFFFFFF : NumGet(bits.Scan0+(y-zy)*bits.Stride+(x-zx)*4,"uint")
  return (fmt ? Format("0x{:06X}",c&0xFFFFFF) : c)
}

; Set the RGB color of a point in the last screenshot

SetColor(x, y, color:=0x000000)
{
  local
  bits:=this.GetBitsFromScreen(,,,,0,zx,zy,zw,zh)
  if !(x<zx || x>=zx+zw || y<zy || y>=zy+zh || !bits.Scan0)
    NumPut(color,bits.Scan0+(y-zy)*bits.Stride+(x-zx)*4,"uint")
}

; Identify a line of text or verification code
; based on the result returned by FindText().
; offsetX is the maximum interval between two texts,
; if it exceeds, a "*" sign will be inserted.
; offsetY is the maximum height difference between two texts.
; overlapW is used to set the width of the overlap.
; Return Association array {text:Text, x:X, y:Y, w:W, h:H}

Ocr(ok, offsetX:=20, offsetY:=20, overlapW:=0)
{
  local
  ocr_Text:=ocr_X:=ocr_Y:=min_X:=dx:=""
  For k,v in ok
    x:=v.1
    , min_X:=(A_Index=1 || x<min_X ? x : min_X)
    , max_X:=(A_Index=1 || x>max_X ? x : max_X)
  While (min_X!="" && min_X<=max_X)
  {
    LeftX:=""
    For k,v in ok
    {
      x:=v.1, y:=v.2
      if (x<min_X) || (ocr_Y!="" && Abs(y-ocr_Y)>offsetY)
        Continue
      ; Get the leftmost X coordinates
      if (LeftX="" || x<LeftX)
        LeftX:=x, LeftY:=y, LeftW:=v.3, LeftH:=v.4, LeftOCR:=v.id
    }
    if (LeftX="")
      Break
    if (ocr_X="")
      ocr_X:=LeftX, min_Y:=LeftY, max_Y:=LeftY+LeftH
    ; If the interval exceeds the set value, add "*" to the result
    ocr_Text.=(ocr_Text!="" && LeftX>dx ? "*":"") . LeftOCR
    ; Update for next search
    min_X:=LeftX+LeftW-(overlapW>LeftW//2 ? LeftW//2:overlapW)
    , dx:=LeftX+LeftW+offsetX, ocr_Y:=LeftY
    , (LeftY<min_Y && min_Y:=LeftY)
    , (LeftY+LeftH>max_Y && max_Y:=LeftY+LeftH)
  }
  if (ocr_X="")
    ocr_X:=0, min_Y:=0, min_X:=0, max_Y:=0
  return {text:ocr_Text, x:ocr_X, y:min_Y
    , w: min_X-ocr_X, h: max_Y-min_Y}
}

; Sort the results of FindText() from left to right
; and top to bottom, ignore slight height difference

Sort(ok, dy:=10)
{
  local
  if !IsObject(ok)
    return ok
  s:="", n:=150000, ypos:=[]
  For k,v in ok
  {
    x:=v.x, y:=v.y, add:=1
    For k1,v1 in ypos
    if Abs(y-v1)<=dy
    {
      y:=v1, add:=0
      Break
    }
    if (add)
      ypos.Push(y)
    s.=(y*n+x) "." k "|"
  }
  s:=Trim(s,"|")
  Sort, s, N D|
  ok2:=[]
  Loop Parse, s, |
    ok2.Push( ok[StrSplit(A_LoopField,".")[2]] )
  return ok2
}

; Sort the results of FindText() according to the nearest distance

Sort2(ok, px, py)
{
  local
  if !IsObject(ok)
    return ok
  s:=""
  For k,v in ok
    s.=((v.x-px)**2+(v.y-py)**2) "." k "|"
  s:=Trim(s,"|")
  Sort, s, N D|
  ok2:=[]
  Loop Parse, s, |
    ok2.Push( ok[StrSplit(A_LoopField,".")[2]] )
  return ok2
}

; Sort the results of FindText() according to the search direction

Sort3(ok, dir:=1)
{
  local
  if !IsObject(ok)
    return ok
  s:="", n:=150000
  For k,v in ok
    x:=v.1, y:=v.2
    , s.=(dir=1 ? y*n+x
    : dir=2 ? y*n-x
    : dir=3 ? -y*n+x
    : dir=4 ? -y*n-x
    : dir=5 ? x*n+y
    : dir=6 ? x*n-y
    : dir=7 ? -x*n+y
    : dir=8 ? -x*n-y : y*n+x) "." k "|"
  s:=Trim(s,"|")
  Sort, s, N D|
  ok2:=[]
  Loop Parse, s, |
    ok2.Push( ok[StrSplit(A_LoopField,".")[2]] )
  return ok2
}

; Prompt mouse position in remote assistance

MouseTip(x:="", y:="", w:=10, h:=10, d:=4)
{
  local
  if (x="")
  {
    VarSetCapacity(pt,16,0), DllCall("GetCursorPos","Ptr",&pt)
    x:=NumGet(pt,0,"uint"), y:=NumGet(pt,4,"uint")
  }
  Loop 4
  {
    this.RangeTip(x-w, y-h, 2*w+1, 2*h+1, (A_Index & 1 ? "Red":"Blue"), d)
    Sleep 500
  }
  this.RangeTip()
}

; Shows a range of the borders, similar to the ToolTip

RangeTip(x:="", y:="", w:="", h:="", color:="Red", d:=2)
{
  local
  static id:=0
  if (x="")
  {
    id:=0
    Loop 4
      Gui, Range_%A_Index%: Destroy
    return
  }
  if (!id)
  {
    Loop 4
      Gui, Range_%A_Index%: +Hwndid +AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08000000
  }
  x:=Floor(x), y:=Floor(y), w:=Floor(w), h:=Floor(h), d:=Floor(d)
  Loop 4
  {
    i:=A_Index
    , x1:=(i=2 ? x+w : x-d)
    , y1:=(i=3 ? y+h : y-d)
    , w1:=(i=1 || i=3 ? w+2*d : d)
    , h1:=(i=2 || i=4 ? h+2*d : d)
    Gui, Range_%i%: Color, %color%
    Gui, Range_%i%: Show, NA x%x1% y%y1% w%w1% h%h1%
  }
}

; Get selection screen use RButton or LButton, FindText().GetRange("RButton")

GetRange(key:="RButton", tip:="", mode:=0, ww:=20, hh:=8)
{
  local
  static Gui_Off:=0, hk
  if (!Gui_Off)
    Gui_Off:=this.GetRange.Bind(this, "Off")
  if (key="Off")
    return hk:=StrSplit(A_ThisHotkey," ","*")[1]
  ;---------------------
  if (mode=1)
  {
    SysGet, x, 76
    SysGet, y, 77
    SysGet, w, 78
    SysGet, h, 79
    Gui, FindText_GetRange: New  ; WS_EX_NOACTIVATE:=0x08000000
    Gui, +LastFound +AlWaysOnTop +ToolWindow -Caption -DPIScale +E0x08000000
    Gui, Color, White
    WinSet, Transparent, 10
    Try Gui, Show, NA x%x% y%y% w%w% h%h%, GetRange
  }
  ;---------------------
  Gui, FindText_HotkeyIf: New
  Gui, -Caption +ToolWindow +E0x80000
  Gui, Show, NA x0 y0 w0 h0, FindText_HotkeyIf
  Hotkey, IfWinExist, FindText_HotkeyIf
  ;---------------------
  if GetKeyState("Ctrl")
    Send {Ctrl Up}
  if (mode=0)
    keys:=[key, "Up", "Down", "Left", "Right"]
  else if (mode=1)
    keys:=[key, key " Up"]
  For k,v in keys
  {
    if !InStr(v," Up") && GetKeyState(v)
      Send {%v% Up}
    Hotkey, *%v%, %Gui_Off%, On UseErrorLevel
  }
  ;---------------------
  Critical % (cri:=A_IsCritical)?"Off":"Off"
  CoordMode, Mouse
  r:=StrSplit(tip "|", "|")
  hk:="", State:=this.State(key), oldx:=oldy:=""
  Loop
  {
    Sleep 50
    MouseGetPos, x1, y1, Bind_ID
    if (mode=0)
    {
      if GetKeyState("Up","P") || (hk="Up")
        (hh>1 && hh--), hk:=""
      else if GetKeyState("Down","P") || (hk="Down")
        hh++, hk:=""
      else if GetKeyState("Left","P") || (hk="Left")
        (ww>1 && ww--), hk:=""
      else if GetKeyState("Right","P") || (hk="Right")
        ww++, hk:=""
      this.RangeTip(x1-ww,y1-hh,2*ww+1,2*hh+1,(A_MSec<500?"Red":"Blue"))
    }
    if (oldx=x1 && oldy=y1)
      Continue
    oldx:=x1, oldy:=y1
    ToolTip % mode=1 ? r[1] : r[1] " : " x1 "," y1 "`n" r[2]
  }
  Until (hk=key) || (State!=this.State(key))
  if (mode=0)
  {
    timeout:=A_TickCount+3000
    While (A_TickCount<timeout) && (State!=this.State(key))
      Sleep 50
  }
  hk:="", State:=this.State(key), oldx:=oldy:=""
  Loop
  {
    Sleep 50
    MouseGetPos, x2, y2
    if (mode=0)
    {
      if GetKeyState("Up","P") || (hk="Up")
        (hh>1 && hh--), hk:=""
      else if GetKeyState("Down","P") || (hk="Down")
        hh++, hk:=""
      else if GetKeyState("Left","P") || (hk="Left")
        (ww>1 && ww--), hk:=""
      else if GetKeyState("Right","P") || (hk="Right")
        ww++, hk:=""
      x:=x1-ww, y:=y1-hh, w:=2*ww+1, h:=2*hh+1
    }
    else if (mode=1)
      x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x1-x2), h:=Abs(y1-y2)
    this.RangeTip(x, y, w, h, (A_MSec<500 ? "Red":"Blue"))
    if (oldx=x2 && oldy=y2)
      Continue
    oldx:=x2, oldy:=y2
    ToolTip % mode=1 ? r[1] : r[1] " : " x1 "," y1 "`n" r[2]
  }
  Until (hk=key) || (State!=this.State(key))
  timeout:=A_TickCount+3000
  While (A_TickCount<timeout)
  && (mode=1 ? State=this.State(key) : State!=this.State(key))
    Sleep 50
  ToolTip
  this.RangeTip()
  For k,v in keys
    Hotkey, *%v%, %Gui_Off%, Off UseErrorLevel
  Hotkey, IfWinExist
  Gui, FindText_HotkeyIf: Destroy
  if (mode=1)
    Gui, FindText_GetRange: Destroy
  Critical %cri%
  return [x, y, x+w-1, y+h-1, Bind_ID]
}

State(key)
{
  return GetKeyState(key,"P") "|" GetKeyState(key)
    . "|" GetKeyState("Ctrl","P") "|" GetKeyState("Ctrl")
}

; Quickly get the search data of screen image

GetTextFromScreen(x1, y1, x2, y2, Threshold:=""
  , ScreenShot:=1, ByRef rx:="", ByRef ry:="", cut:=1)
{
  local
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  this.GetBitsFromScreen(x,y,w,h,ScreenShot)
  if (w<1 || h<1)
  {
    SetBatchLines, %bch%
    return
  }
  gs:=[], k:=0
  Loop %h%
  {
    j:=y+A_Index-1
    Loop %w%
      i:=x+A_Index-1, c:=this.GetColor(i,j,0)
      , gs[++k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
  }
  if InStr(Threshold,"**")
  {
    Threshold:=StrReplace(Threshold,"*")
    if (Threshold="")
      Threshold:=50
    s:="", sw:=w, w-=2, h-=2, x++, y++
    Loop %h%
    {
      y1:=A_Index
      Loop %w%
        x1:=A_Index, i:=y1*sw+x1+1, j:=gs[i]+Threshold
        , s.=( gs[i-1]>j || gs[i+1]>j
        || gs[i-sw]>j || gs[i+sw]>j
        || gs[i-sw-1]>j || gs[i-sw+1]>j
        || gs[i+sw-1]>j || gs[i+sw+1]>j ) ? "1":"0"
    }
    Threshold:="**" Threshold
  }
  else
  {
    Threshold:=StrReplace(Threshold,"*")
    if (Threshold="")
    {
      pp:=[]
      Loop 256
        pp[A_Index-1]:=0
      Loop % w*h
        pp[gs[A_Index]]++
      IP0:=IS0:=0
      Loop 256
        k:=A_Index-1, IP0+=k*pp[k], IS0+=pp[k]
      Threshold:=Floor(IP0/IS0)
      Loop 20
      {
        LastThreshold:=Threshold
        IP1:=IS1:=0
        Loop % LastThreshold+1
          k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
        IP2:=IP0-IP1, IS2:=IS0-IS1
        if (IS1!=0 && IS2!=0)
          Threshold:=Floor((IP1/IS1+IP2/IS2)/2)
        if (Threshold=LastThreshold)
          Break
      }
    }
    s:=""
    Loop % w*h
      s.=gs[A_Index]<=Threshold ? "1":"0"
    Threshold:="*" Threshold
  }
  ;--------------------
  w:=Format("{:d}",w), CutUp:=CutDown:=0
  if (cut=1)
  {
    re1:="(^0{" w "}|^1{" w "})"
    re2:="(0{" w "}$|1{" w "}$)"
    While (s~=re1)
      s:=RegExReplace(s,re1), CutUp++
    While (s~=re2)
      s:=RegExReplace(s,re2), CutDown++
  }
  rx:=x+w//2, ry:=y+CutUp+(h-CutUp-CutDown)//2
  s:="|<>" Threshold "$" w "." this.bit2base64(s)
  ;--------------------
  SetBatchLines, %bch%
  return s
}

; Quickly save screen image to BMP file for debugging

SavePic(file, x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
{
  local
  x1:=Floor(x1), y1:=Floor(y1), x2:=Floor(x2), y2:=Floor(y2)
  if (x1=0 && y1=0 && x2=0 && y2=0)
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy), x-=zx, y-=zy
  if (w<1 || h<1 || !bits.Scan0)
    return
  hBM:=this.CreateDIBSection(w, -h, bpp:=24, ppvBits, bi)
  hBM2:=this.CreateDIBSection(w, h, 32, Scan0), Stride:=w*4
  this.CopyBits(Scan0,Stride,0,0,bits.Scan0,bits.Stride,x,y,w,h)
  this.CopyHBM(hBM, 0, 0, hBM2, 0, 0, w, h)
  DllCall("DeleteObject", "Ptr",hBM2)
  size:=((w*bpp+31)//32)*4*h, NumPut(size, bi, 20, "uint")
  VarSetCapacity(bf, 14, 0), StrPut("BM", &bf, "CP0")
  NumPut(54+size, bf, 2, "uint"), NumPut(54, bf, 10, "uint")
  f:=FileOpen(file,"w"), f.RawWrite(bf,14), f.RawWrite(bi,40)
  , f.RawWrite(ppvBits+0, size), f.Close()
  DllCall("DeleteObject", "Ptr",hBM)
}

; Show the saved Picture file

ShowPic(file:="", show:=1, ByRef x:="", ByRef y:="", ByRef w:="", ByRef h:="")
{
  local
  if (file="")
  {
    this.ShowScreenShot()
    return
  }
  if !(hBM:=LoadPicture(file))
    return
  this.GetBitmapWH(hBM, w, h)
  bits:=this.GetBitsFromScreen(,,,,0,x,y)
  this.GetBitsFromScreen(x,y,w,h,0)
  if (w<1 || h<1 || !bits.Scan0)
  {
    DllCall("DeleteObject", "Ptr",hBM)
    return
  }
  hBM2:=this.CreateDIBSection(w, h, 32, Scan0), Stride:=w*4
  this.CopyHBM(hBM2, 0, 0, hBM, 0, 0, w, h)
  this.CopyBits(bits.Scan0,bits.Stride,0,0,Scan0,Stride,0,0,w,h)
  DllCall("DeleteObject", "Ptr",hBM2)
  DllCall("DeleteObject", "Ptr",hBM)
  if (show)
    this.ShowScreenShot(x, y, x+w-1, y+h-1, 0)
}

; Show the memory Screenshot for debugging

ShowScreenShot(x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
{
  local
  static hPic, oldw, oldh
  x1:=Floor(x1), y1:=Floor(y1), x2:=Floor(x2), y2:=Floor(y2)
  if (x1=0 && y1=0 && x2=0 && y2=0)
  {
    Gui, FindText_Screen: Destroy
    return
  }
  x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy), x-=zx, y-=zy
  if (w<1 || h<1 || !bits.Scan0)
    return
  hBM:=this.CreateDIBSection(w, h, 32, Scan0), Stride:=w*4
  this.CopyBits(Scan0,Stride,0,0,bits.Scan0,bits.Stride,x,y,w,h)
  ;---------------
  Gui, FindText_Screen: +LastFoundExist
  IfWinNotExist
  {
    Gui, FindText_Screen: New
    Gui, +LastFound +AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08000000
    Gui, Margin, 0, 0
    Gui, Add, Pic, HwndhPic w%w% h%h%
    Gui, Show, NA x%zx% y%zy% w%w% h%h%, Show Pic
    oldw:=w, oldh:=h
  }
  else if (oldw!=w || oldh!=h)
  {
    oldw:=w, oldh:=h
    GuiControl, FindText_Screen: Move, %hPic%, w%w% h%h%
    Gui, FindText_Screen: Show, NA w%w% h%h%
  }
  mDC:=DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
  oBM:=DllCall("SelectObject", "Ptr",mDC, "Ptr",hBM, "Ptr")
  DllCall("BitBlt", "Ptr",mDC, "int",0, "int",0, "int",w, "int",h
    , "Ptr",mDC, "int",0, "int",0, "uint",0xC000CA) ; MERGECOPY
  ;---------------
  hDC:=DllCall("GetDC", "Ptr",hPic, "Ptr")
  DllCall("BitBlt", "Ptr",hDC, "int",0, "int",0, "int",w, "int",h
    , "Ptr",mDC, "int",0, "int",0, "uint",0xCC0020)
  DllCall("ReleaseDC", "Ptr",hPic, "Ptr",hDC)
  ;---------------
  DllCall("SelectObject", "Ptr",mDC, "Ptr",oBM)
  DllCall("DeleteDC", "Ptr",mDC)
  DllCall("DeleteObject", "Ptr",hBM)
}

; Wait for the screen image to change within a few seconds
; Take a Screenshot before using it: FindText().ScreenShot()

WaitChange(time:=-1, x1:=0, y1:=0, x2:=0, y2:=0)
{
  local
  hash:=this.GetPicHash(x1, y1, x2, y2, 0)
  timeout:=A_TickCount+Round(time*1000)
  Loop
  {
    if (hash!=this.GetPicHash(x1, y1, x2, y2, 1))
      return 1
    if (time>=0 && A_TickCount>=timeout)
      Break
    Sleep 10
  }
  return 0
}

; Wait for the screen image to stabilize

WaitNotChange(time:=1, timeout:=30, x1:=0, y1:=0, x2:=0, y2:=0)
{
  local
  oldhash:="", timeout:=A_TickCount+Round(timeout*1000)
  Loop
  {
    hash:=this.GetPicHash(x1, y1, x2, y2, 1), t:=A_TickCount
    if (hash!=oldhash)
      oldhash:=hash, timeout2:=t+Round(time*1000)
    if (t>=timeout2)
      return 1
    if (t>=timeout)
      return 0
    Sleep 10
  }
}

GetPicHash(x1:=0, y1:=0, x2:=0, y2:=0, ScreenShot:=1)
{
  local
  static h:=DllCall("LoadLibrary", "Str","ntdll", "Ptr")
  x1:=Floor(x1), y1:=Floor(y1), x2:=Floor(x2), y2:=Floor(y2)
  if (x1=0 && y1=0 && x2=0 && y2=0)
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy), x-=zx, y-=zy
  if (w<1 || h<1 || !bits.Scan0)
    return 0
  hash:=0, Stride:=bits.Stride, p:=bits.Scan0+(y-1)*Stride+x*4, w*=4
  Loop % h
    hash:=(hash*31+DllCall("ntdll\RtlComputeCrc32", "uint",0
      , "Ptr",p+=Stride, "uint",w, "uint"))&0xFFFFFFFF
  return hash
}

WindowToScreen(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  if (!id)
    WinGet, id, ID, A
  VarSetCapacity(rect, 16, 0)
  , DllCall("GetWindowRect", "Ptr",id, "Ptr",&rect)
  , x:=x1+NumGet(rect,"int"), y:=y1+NumGet(rect,4,"int")
}

ScreenToWindow(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  this.WindowToScreen(dx, dy, 0, 0, id), x:=x1-dx, y:=y1-dy
}

ClientToScreen(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  if (!id)
    WinGet, id, ID, A
  VarSetCapacity(pt, 8, 0), NumPut(0, pt, "int64")
  , DllCall("ClientToScreen", "Ptr",id, "Ptr",&pt)
  , x:=x1+NumGet(pt,"int"), y:=y1+NumGet(pt,4,"int")
}

ScreenToClient(ByRef x, ByRef y, x1, y1, id:="")
{
  local
  this.ClientToScreen(dx, dy, 0, 0, id), x:=x1-dx, y:=y1-dy
}

; It is not like FindText always use Screen Coordinates,
; But like built-in command ImageSearch using CoordMode Settings

ImageSearch(ByRef rx:="", ByRef ry:="", x1:=0, y1:=0, x2:=0, y2:=0
  , ImageFile:="", ScreenShot:=1, FindAll:=0)
{
  local
  dx:=dy:=0
  if (A_CoordModePixel="Window")
    this.WindowToScreen(dx, dy, 0, 0)
  else if (A_CoordModePixel="Client")
    this.ClientToScreen(dx, dy, 0, 0)
  color:= Object( "Black", "000000", "White", "FFFFFF"
    , "Red", "FF0000", "Green", "008000", "Blue", "0000FF"
    , "Yellow", "FFFF00", "Silver", "C0C0C0", "Gray", "808080"
    , "Teal", "008080", "Navy", "000080", "Aqua", "00FFFF"
    , "Olive", "808000", "Lime", "00FF00", "Fuchsia", "FF00FF"
    , "Purple", "800080", "Maroon", "800000" )
  text:=""
  Loop Parse, ImageFile, |
  if (v:=A_LoopField)!=""
  {
    text.="|##" . (!RegExMatch(v, "O)(?<=^|\s)\*(\d+)", r) ? 0 : r[1])
    . "-" . (!RegExMatch(v, "Oi)(?<=^|\s)\*Trans(\w+)", r) ? ""
    : color.HasKey(r[1]) ? color[r[1]] : r[1])
    . "$" . Trim(RegExReplace(v, "(?<=^|\s)\*\S+"))
  }
  x1:=Floor(x1), y1:=Floor(y1), x2:=Floor(x2), y2:=Floor(y2)
  if (x1=0 && y1=0 && x2=0 && y2=0)
    n:=150000, x1:=y1:=-n, x2:=y2:=n
  if (ok:=this.FindText(,, x1+dx, y1+dy, x2+dx, y2+dy
    , 0, 0, text, ScreenShot, FindAll))
  {
    if IsObject(ok)
    {
      For k,v in ok  ; you can use ok:=FindText().ok
        v.1-=dx, v.2-=dy, v.x-=dx, v.y-=dy
      rx:=ok[1].1, ry:=ok[1].2, ErrorLevel:=0
    }
    return ok
  }
  else
  {
    rx:=ry:="", ErrorLevel:=1
    return 0
  }
}

; It is not like FindText always use Screen Coordinates,
; But like built-in command PixelSearch using CoordMode Settings

PixelSearch(ByRef rx:="", ByRef ry:="", x1:=0, y1:=0, x2:=0, y2:=0
  , ColorID:="", Variation:=0, ScreenShot:=1, FindAll:=0)
{
  local
  text:=""
  Loop Parse, ColorID, |
    if (v:=A_LoopField)!=""
      text.=Format("|*{:d} 0/0/{:06X}", Variation, v)
  return this.ImageSearch(rx, ry, x1, y1, x2, y2, text, ScreenShot, FindAll)
}

; Pixel count of certain colors within the range indicated by screen coordinates

PixelCount(x1:=0, y1:=0, x2:=0, y2:=0, ColorID:="", Variation:=0, ScreenShot:=1)
{
  local
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  x1:=Floor(x1), y1:=Floor(y1), x2:=Floor(x2), y2:=Floor(y2)
  if (x1=0 && y1=0 && x2=0 && y2=0)
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=Min(x1,x2), y:=Min(y1,y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy), x-=zx, y-=zy
  sum:=0, VarSetCapacity(s1,4), VarSetCapacity(s0,4)
  , ini:={ bits:bits, ss:0, s1:&s1, s0:&s0
  , err1:0, err0:0, allpos_max:0, zoomW:1, zoomH:1 }
  if (w>0 && h>0 && bits.Scan0)
    Loop Parse, ColorID, |
      if (v:=A_LoopField)!=""
      && IsObject(j:=this.PicInfo(Format("##{:d}$0/0/{:06X}",Variation,v)))
        sum += this.PicFind(ini, j, 1, x, y, w, h, 0)
  SetBatchLines, %bch%
  return sum
}

Click(x:="", y:="", other1:="", other2:="", GoBack:=0)
{
  local
  CoordMode, Mouse, % (bak:=A_CoordModeMouse)?"Screen":"Screen"
  if GoBack
    MouseGetPos, oldx, oldy
  MouseMove, x, y, 0
  Click % x "," y "," other1 "," other2
  if GoBack
    MouseMove, oldx, oldy, 0
  CoordMode, Mouse, %bak%
}

; Using ControlClick instead of Click, Use Screen Coordinates,
; If you want to click on the background window, please provide hwnd

ControlClick(x, y, WhichButton:="", ClickCount:=1, Opt:="", hwnd:="")
{
  local
  if !hwnd
    hwnd:=DllCall("WindowFromPoint", "int64",y<<32|x&0xFFFFFFFF, "Ptr")
  VarSetCapacity(pt,8,0), ScreenX:=x, ScreenY:=y
  Loop
  {
    NumPut(0,pt,"int64"), DllCall("ClientToScreen", "Ptr",hwnd, "Ptr",&pt)
    , x:=ScreenX-NumGet(pt,"int"), y:=ScreenY-NumGet(pt,4,"int")
    , id:=DllCall("ChildWindowFromPoint", "Ptr",hwnd, "int64",y<<32|x, "Ptr")
    if (!id || id=hwnd)
      Break
    else hwnd:=id
  }
  DetectHiddenWindows, % (bak:=A_DetectHiddenWindows)?1:1
  PostMessage, 0x200, 0, y<<16|x,, ahk_id %hwnd%  ; WM_MOUSEMOVE
  SetControlDelay -1
  ControlClick, x%x% y%y%, ahk_id %hwnd%,, %WhichButton%, %ClickCount%, NA Pos %Opt%
  DetectHiddenWindows, % bak
}

; Running AHK code dynamically with new threads

Class Thread
{
  __New(args*)
  {
    this.pid:=this.Exec(args*)
  }
  __Delete()
  {
    Process, Close, % this.pid
  }
  Exec(s, Ahk:="", args:="")    ; required AHK v1.1.34+
  {
    local
    Ahk:=Ahk ? Ahk : A_IsCompiled ? A_ScriptFullPath : A_AhkPath
    add:=A_IsCompiled ? " /script " : ""
    s:="`nDllCall(""SetWindowText"",""Ptr"",A_ScriptHwnd,""Str"",""<AHK>"")`n"
      . "`nSetBatchLines,-1`n" . s, s:=RegExReplace(s, "\R", "`r`n")
    Try
    {
      shell:=ComObjCreate("WScript.Shell")
      oExec:=shell.Exec("""" Ahk """" add " /force /CP0 * " args)
      oExec.StdIn.Write(s)
      oExec.StdIn.Close(), pid:=oExec.ProcessID
    }
    Catch
    {
      f:=A_Temp "\~ahk.tmp"
      s:="`r`nTry FileDelete " f "`r`n" s
      Try FileDelete %f%
      FileAppend %s%, %f%
      r:=this.Clear.Bind(this)
      SetTimer %r%, -3000
      Run "%Ahk%" %add% /force /CP0 "%f%" %args%,, UseErrorLevel, pid
    }
    return pid
  }
  Clear()
  {
    Try FileDelete % A_Temp "\~ahk.tmp"
    SetTimer,, Off
  }
}

; FindText().QPC() Use the same as A_TickCount

QPC()
{
  static f:=0, c:=DllCall("QueryPerformanceFrequency","Int*",f)+(f/=1000)
  return (!DllCall("QueryPerformanceCounter","Int64*",c))*0+(c/f)
}

; FindText().ToolTip() Use the same as ToolTip

ToolTip(s:="", x:="", y:="", num:=1, arg:="")
{
  local
  static ini:=[], timer:=[]
  f:="ToolTip_" . Floor(num)
  if (s="")
  {
    ini[f]:=""
    Gui, %f%: Destroy
    return
  }
  ;-----------------
  r1:=A_CoordModeToolTip
  r2:=A_CoordModeMouse
  CoordMode Mouse, Screen
  MouseGetPos x1, y1
  CoordMode Mouse, %r1%
  MouseGetPos x2, y2
  CoordMode Mouse, %r2%
  (x!="" && x:="x" (Floor(x)+x1-x2))
  , (y!="" && y:="y" (Floor(y)+y1-y2))
  , (x="" && y="" && x:="x" (x1+16) " y" (y1+16))
  ;-----------------
  bgcolor:=arg.bgcolor!="" ? arg.bgcolor : "FAFBFC"
  color:=arg.color!="" ? arg.color : "Black"
  font:=arg.font ? arg.font : "Consolas"
  size:=arg.size ? arg.size : "10"
  bold:=arg.bold ? arg.bold : ""
  trans:=arg.trans!="" ? Round(arg.trans & 255) : 255
  timeout:=arg.timeout!="" ? arg.timeout : ""
  ;-----------------
  r:=bgcolor "|" color "|" font "|" size "|" bold "|" trans "|" s
  if (!ini.HasKey(f) || ini[f]!=r)
  {
    ini[f]:=r
    Gui, %f%: Destroy  ; WS_EX_LAYERED:=0x80000, WS_EX_TRANSPARENT:=0x20
    Gui, %f%: +AlwaysOnTop -Caption +ToolWindow -DPIScale +Hwndid +E0x80020
    Gui, %f%: Margin, 2, 2
    Gui, %f%: Color, %bgcolor%
    Gui, %f%: Font, c%color% s%size% %bold%, %font%
    Gui, %f%: Add, Text,, %s%
    Gui, %f%: Show, Hide, %f%
    ;------------------
    DetectHiddenWindows, % (bak:=A_DetectHiddenWindows)?1:1
    WinSet, Transparent, %trans%, ahk_id %id%
    DetectHiddenWindows, % bak
  }
  Gui, %f%: +AlwaysOnTop
  Gui, %f%: Show, % "NA " x " " y
  if (timeout)
  {
    (!timer.HasKey(f) && timer[f]:=this.ToolTip.Bind(this,"","","",num))
    , r:=timer[f]
    SetTimer, %r%, % -Round(Abs(timeout*1000))-1
  }
}

; FindText().ObjView()  view object values for Debug

ObjView(obj, keyname:="")
{
  local
  if IsObject(obj)  ; thanks lexikos's type(v)
  {
    s:=""
    For k,v in obj
      s.=this.ObjView(v, keyname "[" (StrLen(k)>1000
      || [k].GetCapacity(1) ? """" k """":k) "]")
  }
  else
    s:=keyname ": " (StrLen(obj)>1000
    || [obj].GetCapacity(1) ? """" obj """":obj) "`n"
  if (keyname!="")
    return s
  ;------------------
  Gui, Gui_DeBug_Gui: New
  Gui, +LastFound +AlwaysOnTop
  Gui, Add, Button, y270 w350 gCancel Default, OK
  Gui, Add, Edit, xp y10 w350 h250 -Wrap -WantReturn
  GuiControl,, Edit1, %s%
  Gui, Show,, Debug view object values
  DetectHiddenWindows, 0
  WinWaitClose, % "ahk_id " WinExist()
  Gui, Destroy
}

; Get Script from Compiled programs

GetScript()  ; thanks TAC109
{
  local
  if (!A_IsCompiled)
    return
  For i,ahk in ["#1", ">AUTOHOTKEY SCRIPT<"]
  if (rc:=DllCall("FindResource", "Ptr",0, "Str",ahk, "Ptr",10, "Ptr"))
  && (sz:=DllCall("SizeofResource", "Ptr",0, "Ptr",rc, "Uint"))
  && (pt:=DllCall("LoadResource", "Ptr",0, "Ptr",rc, "Ptr"))
  && (pt:=DllCall("LockResource", "Ptr",pt, "Ptr"))
  && (DllCall("VirtualProtect", "Ptr",pt, "Ptr",sz, "UInt",0x4, "UInt*",0))
  && (InStr(StrGet(pt, 20, "utf-8"), "<COMPILER"))
    return this.FormatScript(StrGet(pt, sz, "utf-8"))
}

FormatScript(s, space:="", tab:="    ")
{
  local
  ListLines % (lls:=A_ListLines)?0:0
  VarSetCapacity(ss, StrLen(s)*2), n:=0, w:=StrLen(tab)
  , space2:=StrReplace(Format("{:020d}",0), "0", tab)
  Loop Parse, s, `n, `r
  {
    v:=Trim(A_LoopField), n2:=n
    if RegExMatch(v, "O)^\s*[{}][\s{}]*|\{\s*$|\{\s+;", r)
      n+=w*(StrLen(RegExReplace(r[0], "[^{]"))
      -StrLen(RegExReplace(r[0], "[^}]"))), n2:=Min(n,n2)
    ss.=Space . SubStr(space2,1,n2) . v . "`r`n"
  }
  ListLines %lls%
  return SubStr(ss,1,-2)
}

; Get Last GuiControl Hwnd from Gui +LastFound

LastCtrl()
{
  WinGet, s, ControlListHwnd
  return SubStr(s, InStr(s,"`n",0,-1)+1)
}

;==== Optional GUI interface ====

Gui(cmd, arg1:="", args*)
{
  local
  static
  local bch, cri, lls
  ListLines, % (lls:=A_ListLines)?0:0
  if !InStr("MouseMove|ToolTipOff",cmd)
    ListLines, %lls%
  static init:=0
  if (!init)
  {
    init:=1
    Gui_ := this.Gui.Bind(this)
    Gui_G := this.Gui.Bind(this, "G")
    Gui_Run := this.Gui.Bind(this, "Run")
    Gui_Off := this.Gui.Bind(this, "Off")
    Gui_Show := this.Gui.Bind(this, "Show")
    Gui_KeyDown := this.Gui.Bind(this, "KeyDown")
    Gui_LButtonDown := this.Gui.Bind(this, "LButtonDown")
    Gui_MouseMove := this.Gui.Bind(this, "MouseMove")
    Gui_ScreenShot := this.Gui.Bind(this, "ScreenShot")
    Gui_ShowPic := this.Gui.Bind(this, "ShowPic")
    Gui_Slider := this.Gui.Bind(this, "Slider")
    Gui_ToolTip := this.Gui.Bind(this, "ToolTip")
    Gui_ToolTipOff := this.Gui.Bind(this, "ToolTipOff")
    Gui_SaveScr := this.Gui.Bind(this, "SaveScr")
    Gui_SetColor := this.Gui.Bind(this, "SetColor")
    bch:=A_BatchLines, cri:=A_IsCritical
    Critical
    #NoEnv
    %Gui_%("Load_Language_Text")
    %Gui_%("MakeCaptureWindow")
    %Gui_%("MakeMainWindow")
    OnMessage(0x100, Gui_KeyDown)
    OnMessage(0x201, Gui_LButtonDown)
    OnMessage(0x200, Gui_MouseMove)
    Menu, Tray, Add
    Menu, Tray, Add, % Lang["s1"], %Gui_Show%
    if (!A_IsCompiled && A_LineFile=A_ScriptFullPath)
    {
      Menu, Tray, Default, % Lang["s1"]
      Menu, Tray, Click, 1
      Menu, Tray, Icon, Shell32.dll, 23
    }
    Critical, %cri%
    SetBatchLines, %bch%
    Gui, New, +LastFound
    Gui, Destroy
  }
  Switch cmd
  {
  Case "Off":
    return hk:=SubStr(A_ThisHotkey,2)
  Case "G":
    id:=this.LastCtrl()
    GuiControl, +g, %id%, %Gui_Run%
    return
  Case "Run":
    Critical
    %Gui_%(A_GuiControl)
    return
  Case "Show":
    Gui, FindText_Main: Show, % arg1 ? "Center" : ""
    GuiControl, Focus, %hscr%
    return
  Case "Cancel", "Cancel2":
    WinHide
    return
  Case "MakeCaptureWindow":
    WindowColor:="0xDDEEFF"
    Gui, FindText_Capture: New
    Gui, +LastFound +AlwaysOnTop -DPIScale
    Gui, Margin, 15, 15
    Gui, Color, %WindowColor%
    Gui, Font, s12, Verdana
    ww:=35, hh:=12, nW:=71, nH:=25, w:=h:=11
    w:=nW*(w+1)-1, h:=(nH+1)*(h+1)-1
    Gui, Add, Text, w%w% h%h%
    Gui, Add, Slider, xm w%w% vMySlider1 Disabled
      +Center Page20 Line10 NoTicks AltSubmit
    %Gui_G%()
    Gui, Add, Slider, ym h%h% vMySlider2 Disabled
      +Center Page20 Line10 NoTicks AltSubmit +Vertical
    %Gui_G%()
    GuiControlGet, p, Pos, % this.LastCtrl()
    k:=pX+pW, MySlider1:=MySlider2:=dx:=dy:=0
    ;--------------
    Gui, Add, Button, xm Hidden Section, % Lang["Auto"]
    GuiControlGet, p, Pos, % this.LastCtrl()
    w:=Round(pW*0.75), i:=Round(w*3+15+pW*0.5-w*1.5)
    Gui, Add, Button, xm+%i% yp w%w% hp -Wrap vRepU, % Lang["RepU"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutU, % Lang["CutU"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutU3, % Lang["CutU3"]
    %Gui_G%()
    Gui, Add, Button, xm wp hp -Wrap vRepL, % Lang["RepL"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutL, % Lang["CutL"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutL3, % Lang["CutL3"]
    %Gui_G%()
    Gui, Add, Button, x+15 w%pW% hp -Wrap vAuto, % Lang["Auto"]
    %Gui_G%()
    Gui, Add, Button, x+15 w%w% hp -Wrap vRepR, % Lang["RepR"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutR, % Lang["CutR"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutR3, % Lang["CutR3"]
    %Gui_G%()
    Gui, Add, Button, xm+%i% wp hp -Wrap vRepD, % Lang["RepD"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutD, % Lang["CutD"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp hp -Wrap vCutD3, % Lang["CutD3"]
    %Gui_G%()
    ;--------------
    Gui, Add, Text, x+60 ys+3 Section, % Lang["SelGray"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelGray ReadOnly
    Gui, Add, Text, x+15 ys, % Lang["SelColor"]
    Gui, Add, Edit, x+3 yp-3 w150 vSelColor ReadOnly
    Gui, Add, Text, x+15 ys, % Lang["SelR"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelR ReadOnly
    Gui, Add, Text, x+5 ys, % Lang["SelG"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelG ReadOnly
    Gui, Add, Text, x+5 ys, % Lang["SelB"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelB ReadOnly
    ;--------------
    x:=w*6+pW+15*4
    Gui, Add, Tab3, x%x% y+15 -Wrap, % Lang["s2"]
    Gui, Tab, 1
    Gui, Add, Text, x+15 y+15, % Lang["Threshold"]
    Gui, Add, Edit, x+15 w100 vThreshold
    Gui, Add, Button, x+15 yp-3 vGray2Two, % Lang["Gray2Two"]
    %Gui_G%()
    Gui, Tab, 2
    Gui, Add, Text, x+15 y+15, % Lang["GrayDiff"]
    Gui, Add, Edit, x+15 w100 vGrayDiff, 50
    Gui, Add, Button, x+15 yp-3 vGrayDiff2Two, % Lang["GrayDiff2Two"]
    %Gui_G%()
    Gui, Tab, 3
    Gui, Add, Text, x+15 y+15, % Lang["Similar1"] " 0"
    Gui, Add, Slider, x+0 w120 vSimilar1 +Center Page1 NoTicks ToolTip, 100
    %Gui_G%()
    Gui, Add, Text, x+0, 100
    Gui, Add, Button, x+15 yp-3 vColor2Two, % Lang["Color2Two"]
    %Gui_G%()
    Gui, Tab, 4
    Gui, Add, Text, x+15 y+15, % Lang["Similar2"] " 0"
    Gui, Add, Slider, x+0 w120 vSimilar2 +Center Page1 NoTicks ToolTip, 100
    %Gui_G%()
    Gui, Add, Text, x+0, 100
    Gui, Add, Button, x+15 yp-3 vColorPos2Two, % Lang["ColorPos2Two"]
    %Gui_G%()
    Gui, Tab, 5
    Gui, Add, Text, x+10 y+15, % Lang["DiffR"]
    Gui, Add, Edit, x+5 w80 vDiffR Limit3
    Gui, Add, UpDown, vdR Range0-255 Wrap
    Gui, Add, Text, x+5, % Lang["DiffG"]
    Gui, Add, Edit, x+5 w80 vDiffG Limit3
    Gui, Add, UpDown, vdG Range0-255 Wrap
    Gui, Add, Text, x+5, % Lang["DiffB"]
    Gui, Add, Edit, x+5 w80 vDiffB Limit3
    Gui, Add, UpDown, vdB Range0-255 Wrap
    Gui, Add, Button, x+15 yp-3 vColorDiff2Two, % Lang["ColorDiff2Two"]
    %Gui_G%()
    Gui, Tab, 6
    Gui, Add, Text, x+10 y+15, % Lang["DiffRGB"]
    Gui, Add, Edit, x+5 w80 vDiffRGB Limit3
    Gui, Add, UpDown, vdRGB Range0-255 Wrap
    Gui, Add, Checkbox, x+15 yp+5 vMultiColor, % Lang["MultiColor"]
    %Gui_G%()
    Gui, Add, Button, x+15 yp-5 vUndo, % Lang["Undo"]
    %Gui_G%()
    Gui, Tab
    ;--------------
    Gui, Add, Button, xm vReset, % Lang["Reset"]
    %Gui_G%()
    Gui, Add, Checkbox, x+15 yp+5 vModify, % Lang["Modify"]
    %Gui_G%()
    Gui, Add, Text, x+30, % Lang["Comment"]
    Gui, Add, Edit, x+5 yp-2 w150 vComment
    Gui, Add, Button, x+10 yp-3 vSplitAdd, % Lang["SplitAdd"]
    %Gui_G%()
    Gui, Add, Button, x+10 vAllAdd, % Lang["AllAdd"]
    %Gui_G%()
    Gui, Add, Button, x+10 wp vOK, % Lang["OK"]
    %Gui_G%()
    Gui, Add, Button, x+10 wp vCancel, % Lang["Cancel"]
    %Gui_G%()
    Gui, Add, Button, xm vBind0, % Lang["Bind0"]
    %Gui_G%()
    Gui, Add, Button, x+10 vBind1, % Lang["Bind1"]
    %Gui_G%()
    Gui, Add, Button, x+10 vBind2, % Lang["Bind2"]
    %Gui_G%()
    Gui, Add, Button, x+10 vBind3, % Lang["Bind3"]
    %Gui_G%()
    Gui, Add, Button, x+10 vBind4, % Lang["Bind4"]
    %Gui_G%()
    Gui, Add, Button, x+30 vSave, % Lang["Save"]
    %Gui_G%()
    Gui, -Theme
    w:=h:=11, C_:=[]
    Loop % nW*(nH+1)
    {
      i:=A_Index, j:=i=1 ? "xm ym" : Mod(i,nW)=1 ? "xm y+1":"x+1"
      Gui, Add, Progress, %j% w%w% h%h% Hwndid -E0x20000 Smooth
      C_[i]:=id
    }
    Gui, +Theme
    Gui, Show, Hide, % Lang["s3"]
    return
  Case "MakeMainWindow":
    Gui, FindText_Main: New
    Gui, +LastFound +AlwaysOnTop -DPIScale
    Gui, Margin, 15, 10
    Gui, Color, %WindowColor%
    Gui, Font, s12, Verdana
    Gui, Add, Text, xm, % Lang["NowHotkey"]
    Gui, Add, Edit, x+5 w200 vNowHotkey ReadOnly
    Gui, Add, Hotkey, x+5 w200 vSetHotkey1
    s:="F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|LWin|MButton"
      . "|ScrollLock|CapsLock|Ins|Esc|BS|Del|Tab|Home|End|PgUp|PgDn"
      . "|NumpadDot|NumpadSub|NumpadAdd|NumpadDiv|NumpadMult"
    Gui, Add, DDL, x+5 w180 vSetHotkey2, % s
    Gui, Add, GroupBox, xm y+0 w280 h55 vMyGroup cBlack
    Gui, Add, Text, xp+15 yp+20 Section, % Lang["Myww"] ": "
    Gui, Add, Text, x+0 w80, %ww%
    Gui, Add, UpDown, vMyww Range1-100, %ww%
    Gui, Add, Text, x+15 ys, % Lang["Myhh"] ": "
    Gui, Add, Text, x+0 w80, %hh%
    Gui, Add, UpDown, vMyhh Range1-100, %hh%
    GuiControlGet, p, Pos, % this.LastCtrl()
    GuiControl, Move, MyGroup, % "w" (pX+pW) " h" (pH+30)
    x:=pX+pW+15*2
    Gui, Add, Button, x%x% ys-5 vApply, % Lang["Apply"]
    %Gui_G%()
    Gui, Add, Checkbox, x+30 ys vAddFunc, % Lang["AddFunc"] " FindText()"
    GuiControlGet, p, Pos, % this.LastCtrl()
    pW:=pX+pW-15, pW:=(pW<720?720:pW), w:=pW//5
    Gui, Add, Button, xm y+18 w%w% vCutL2, % Lang["CutL2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutR2, % Lang["CutR2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutU2, % Lang["CutU2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutD2, % Lang["CutD2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vUpdate, % Lang["Update"]
    %Gui_G%()
    Gui, Font, s6 bold, Verdana
    Gui, Add, Edit, xm y+10 w%pW% h260 vMyPic -Wrap
    Gui, Font, s12 norm, Verdana
    w:=pW//3
    Gui, Add, Button, xm w%w% vCapture, % Lang["Capture"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vTest, % Lang["Test"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCopy, % Lang["Copy"]
    %Gui_G%()
    Gui, Add, Button, xm y+0 wp vCaptureS, % Lang["CaptureS"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vGetRange, % Lang["GetRange"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vGetOffset, % Lang["GetOffset"]
    %Gui_G%()
    Gui, Add, Edit, xm y+10 w130 hp vClipText
    Gui, Add, Button, x+0 vPaste, % Lang["Paste"]
    %Gui_G%()
    Gui, Add, Button, x+0 vTestClip, % Lang["TestClip"]
    %Gui_G%()
    Gui, Add, Button, x+0 vGetClipOffset, % Lang["GetClipOffset"]
    %Gui_G%()
    r:=pW
    GuiControlGet, p, Pos, % this.LastCtrl()
    w:=((r+15)-(pX+pW))//2, pW:=r
    Gui, Add, Edit, x+0 w%w% hp vOffset
    Gui, Add, Button, x+0 wp vCopyOffset, % Lang["CopyOffset"]
    %Gui_G%()
    Gui, Font, cBlue
    Gui, Add, Edit, xm w%pW% h250 vscr Hwndhscr -Wrap HScroll
    Gui, Show, Hide, % Lang["s4"]
    %Gui_%("LoadScr")
    OnExit(Gui_SaveScr)
    return
  Case "LoadScr":
    f:=A_Temp "\~scr1.tmp"
    FileRead, s, %f%
    GuiControl, FindText_Main:, scr, %s%
    return
  Case "SaveScr":
    f:=A_Temp "\~scr1.tmp"
    GuiControlGet, s, FindText_Main:, scr
    FileDelete, %f%
    FileAppend, %s%, %f%
    return
  Case "Capture", "CaptureS":
    Gui, FindText_Main: +Hwndid
    if (show_gui:=(WinExist()=id))
    {
      WinMinimize
      Gui, FindText_Main: Hide
    }
    ShowScreenShot:=InStr(cmd, "CaptureS")
    if (ShowScreenShot)
    {
      this.ScreenShot(), f:=%Gui_%("SelectPic")
      if (f="") || !FileExist(f)
      {
        if (show_gui)
          %Gui_Show%()
        Exit
      }
      this.ShowPic(f)
    }
    ;----------------------
    GuiControlGet, w, FindText_Main:, Myww
    GuiControlGet, h, FindText_Main:, Myhh
    if (!show_gui)
      w:=20, h:=8
    p:=this.GetRange("RButton", Lang["s5"], 0, w, h)
    if (ShowScreenShot)
      this.ShowPic()
    if (!show_gui)
      return p
    px:=(p[1]+p[3])//2, py:=(p[2]+p[4])//2
    , ww:=(p[3]-p[1])//2, hh:=(p[4]-p[2])//2
    , Bind_ID:=p[5], oldx:=oldy:=""
    ;-----------------------
    nW:=71, nH:=25, dx:=dy:=0, c:=WindowColor
    c:=((c&0xFF)<<16)|(c&0xFF00)|((c&0xFF0000)>>16)
    ListLines % (lls:=A_ListLines)?0:0
    Loop % nW*(nH+1)
      SendMessage, 0x2001, 0, (A_Index>nW*nH ? 0xAAFFFF:c),, % "ahk_id " C_[A_Index]
    ListLines % lls
    nW:=2*ww+1, nH:=2*hh+1, i:=nW>71, j:=nH>25
    Gui, FindText_Capture: Default
    GuiControl, Enable%i%, MySlider1
    GuiControl, Enable%j%, MySlider2
    GuiControl,, MySlider1, % MySlider1:=0
    GuiControl,, MySlider2, % MySlider2:=0
    ;------------------------
    %Gui_%("getcors", !ShowScreenShot), %Gui_%("Reset")
    Loop Parse, % "SelGray|SelColor|SelR|SelG|SelB|Threshold|Comment", |
      GuiControl,, % A_LoopField
    GuiControl,, Modify, % Modify:=0
    GuiControl,, MultiColor, % MultiColor:=0
    GuiControl,, GrayDiff, 50
    GuiControl, Focus, Gray2Two
    GuiControl, +Default, Gray2Two
    Gui, +LastFound
    Gui, Show, Center
    Event:=Result:=""
    DetectHiddenWindows, 0
    Critical, Off
    WinWaitClose, % "ahk_id " WinExist()
    Critical
    ToolTip
    Gui, FindText_Main: Default
    ;--------------------------------
    if (cors.bind!="")
    {
      WinGetTitle, tt, ahk_id %Bind_ID%
      WinGetClass, tc, ahk_id %Bind_ID%
      tt:=Trim(SubStr(tt,1,30) (tc ? " ahk_class " tc:""))
      tt:=StrReplace(RegExReplace(tt,"[;``]","``$0"),"""","""""")
      Result:="`nSetTitleMatchMode 2`nid:=WinExist(""" tt """)"
        . "`nFindText().BindWindow(id" (cors.bind=0 ? "":"," cors.bind)
        . ")  `; " Lang["s6"] " FindText().BindWindow(0)`n`n" Result
    }
    if (Event="OK")
    {
      if (!A_IsCompiled)
        FileRead, s, %A_LineFile%
      else
        s:=this.GetScript()
      re:="Oi)\n\s*FindText[^\n]+args\*[\s\S]*?Script_End[(){\s]+}"
      if RegExMatch(s, re, r)
        s:="`n;==========`n" r[0] "`n"
      GuiControl,, scr, % Result "`n" s
      GuiControl,, MyPic, % Trim(this.ASCII(Result),"`n")
      Result:=s:=""
    }
    else if (Event="SplitAdd") || (Event="AllAdd")
    {
      GuiControlGet, s,, scr
      r:=SubStr(s, 1, InStr(s,"=FindText("))
      i:=j:=0, re:="<[^>\n]*>[^$\n]+\$[^""\r\n]+"
      While j:=RegExMatch(r, re,, j+1)
        i:=InStr(r, "`n", 0, j)
      GuiControl,, scr, % SubStr(s,1,i) . Result . SubStr(s,i+1)
      GuiControl,, MyPic, % Trim(this.ASCII(Result),"`n")
      Result:=s:=""
    }
    ;----------------------
    %Gui_Show%()
    return
  Case "SelectPic":
    Gui, FindText_SelectPic: +LastFoundExist
    IfWinExist
      return
    Pics:=[], Names:=[], s:=""
    Loop Files, % A_Temp "\Ahk_ScreenShot\*.bmp"
      Pics.Push(LoadPicture(v:=A_LoopFileFullPath))
      , Names.Push(v), s.="|" RegExReplace(v,"i)^.*\\|\.bmp$")
    Gui, FindText_SelectPic: New
    Gui, +LastFound +AlwaysOnTop -DPIScale
    Gui, Margin, 15, 15
    Gui, Font, s12, Verdana
    Gui, Add, Pic, HwndhPic w800 h500 +Border
    Gui, Add, ListBox, % "x+15 w120 hp vSelectBox"
      . " AltSubmit 0x100 Choose1", % Trim(s,"|")
    %Gui_G%()
    Gui, Add, Button, xm w170 vOK2 Default, % Lang["OK2"]
    %Gui_G%()
    Gui, Add, Button, x+15 wp vCancel2, % Lang["Cancel2"]
    %Gui_G%()
    Gui, Add, Button, x+15 wp vClearAll, % Lang["ClearAll"]
    %Gui_G%()
    Gui, Add, Button, x+15 wp vOpenDir, % Lang["OpenDir"]
    %Gui_G%()
    Gui, Add, Button, x+15 wp vSavePic, % Lang["SavePic"]
    %Gui_G%()
    GuiControl, Focus, SelectBox
    %Gui_%("SelectBox")
    Gui, Show,, Select ScreenShot
    ;-----------------------
    DetectHiddenWindows, 0
    Critical, Off
    SelectFile:=""
    WinWaitClose, % "ahk_id " WinExist()
    Critical
    Gui, FindText_SelectPic: Destroy
    Loop % Pics.Length()
      DllCall("DeleteObject", "Ptr",Pics[A_Index])
    Pics:="", Names:=""
    return SelectFile
  Case "SavePic":
    GuiControlGet, SelectBox
    f:=Names[SelectBox]
    Gui, Hide
    this.ShowPic(f)
    Gui, FindText_Screen: +OwnDialogs
    Loop
    {
      pos:=%Gui_%("GetRange")
      MsgBox, 4100, Tip, % Lang["s15"] " !"
      IfMsgBox, Yes
        Break
    }
    %Gui_%("ScreenShot", pos[1] "|" pos[2] "|" pos[3] "|" pos[4] "|0")
    this.ShowPic()
    return
  Case "SelectBox":
    GuiControlGet, SelectBox
    if (hBM:=Pics[SelectBox])
    {
      this.GetBitmapWH(hBM, w, h)
      GuiControl,, %hPic%, % "*W" (w<800?0:800)
        . " *H" (h<500?0:500) " HBITMAP:*" hBM
    }
    return
  Case "OK2":
    GuiControlGet, SelectBox
    SelectFile:=Names[SelectBox]
    Gui, Hide
    return
  Case "ClearAll":
    FileDelete, % A_Temp "\Ahk_ScreenShot\*.bmp"
    Gui, Hide
    return
  Case "OpenDir":
    Run, % A_Temp "\Ahk_ScreenShot\"
    return
  Case "getcors":
    x:=px-ww, y:=py-hh, w:=2*ww+1, h:=2*hh+1
    this.GetBitsFromScreen(x,y,w,h,arg1)
    if (w<1 || h<1)
      return
    cors:=[], gray:=[], k:=0, j:=py-hh-1
    ListLines % (lls:=A_ListLines)?0:0
    Loop %nH%
    {
      j++, i:=px-ww
      Loop %nW%
        cors[++k]:=c:=this.GetColor(i++,j,0)
        , gray[k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
    }
    ListLines % lls
    cors.CutLeft:=Abs(px-ww-x)
    cors.CutRight:=Abs(px+ww-(x+w-1))
    cors.CutUp:=Abs(py-hh-y)
    cors.CutDown:=Abs(py+hh-(y+h-1))
    return
  Case "GetRange":
    Gui, FindText_Main: +Hwndid
    if (show_gui_range:=(WinExist()=id))
      Gui, FindText_Main: Hide
    ;---------------------
    p:=this.GetRange("LButton", Lang["s7"], 1)
    Clipboard:=v:=p[1] ", " p[2] ", " p[3] ", " p[4]
    if (!show_gui_range)
      return p
    ;---------------------
    Gui, FindText_Main: Default
    GuiControlGet, s,, scr
    re:="i)(=FindText\([^\n]*?)([^(,\n]*,){4}([^,\n]*,[^,\n]*,[^,\n]*Text)"
    if SubStr(s,1,s~="i)\n\s*FindText[^\n]+args\*")~=re
    {
      s:=RegExReplace(s, re, "$1 " v ",$3",, 1)
      GuiControl,, scr, %s%
    }
    %Gui_Show%()
    return
  Case "Test", "TestClip":
    Gui, FindText_Main: Default
    Gui, +LastFound
    WinMinimize
    Gui, Hide
    DetectHiddenWindows, 0
    WinWaitClose, % "ahk_id " WinExist()
    Sleep 100
    ;----------------------
    if (cmd="Test")
      GuiControlGet, s,, scr
    else
      GuiControlGet, s,, ClipText
    if (cmd="Test") && InStr(s, "MCode(")
    {
      s:="`n#NoEnv`nMenu, Tray, Click, 1`n" s "`nExitApp`n"
      Thread1:=new this.Thread(s)
      DetectHiddenWindows, 1
      WinWait, % "ahk_class AutoHotkey ahk_pid " Thread1.pid,, 3
      if (!ErrorLevel)
        WinWaitClose,,, 30
      ; Thread1:=""  ; kill the Thread
    }
    else
    {
      t:=A_TickCount, v:=X:=Y:=""
      if RegExMatch(s, "O)<[^>\n]*>[^$\n]+\$[^""\r\n]+", r)
        v:=this.FindText(X, Y, 0,0,0,0, 0,0, r[0])
      r:=StrSplit(Lang["s8"] "||||", "|")
      MsgBox, 4096, Tip, % r[1] ":`t" (v?v.Length():0) "`n`n"
        . r[2] ":`t" (A_TickCount-t) " " r[3] "`n`n"
        . r[4] ":`t" X ", " Y "`n`n"
        . r[5] ":`t<" (v?v[1].id:"") ">", 3
      Try For i,j in v
        if (i<=2)
          this.MouseTip(j.x, j.y)
      v:="", Clipboard:=X "," Y
    }
    ;----------------------
    %Gui_Show%()
    return
  Case "GetOffset", "GetClipOffset":
    Gui, FindText_Main: Hide
    Gui, FindText_Capture: +LastFound
    p:=%Gui_%("Capture")
    Gui, FindText_Main: Default
    if (cmd="GetOffset")
      GuiControlGet, s,, scr
    else
      GuiControlGet, s,, ClipText
    if RegExMatch(s, "O)<[^>\n]*>[^$\n]+\$[^""\r\n]+", r)
    && this.FindText(X, Y, 0,0,0,0, 0,0, r[0])
    {
      r:=StrReplace("X+" ((p[1]+p[3])//2-X)
        . ", Y+" ((p[2]+p[4])//2-Y), "+-", "-")
      if (cmd="GetOffset")
      {
        re:="i)(\(\)\.\w*Click\w*\()[^,\n]*,[^,)\n]*"
        if SubStr(s,1,s~="i)\n\s*FindText[^\n]+args\*")~=re
          s:=RegExReplace(s, re, "$1" r,, 1)
        GuiControl,, scr, %s%
      }
      else
        GuiControl,, Offset, %r%
    }
    %Gui_Show%()
    s:=""
    return
  Case "Paste":
    if RegExMatch(Clipboard, "O)<[^>\n]*>[^$\n]+\$[^""\r\n]+", r)
    {
      GuiControl,, ClipText, % r[0]
      GuiControl,, MyPic, % Trim(this.ASCII(r[0]),"`n")
    }
    return
  Case "CopyOffset":
    GuiControlGet, s,, Offset
    Clipboard:=s
    return
  Case "Copy":
    Gui, FindText_Main: Default
    ControlGet, s, Selected,,, ahk_id %hscr%
    if (s="")
    {
      GuiControlGet, s,, scr
      GuiControlGet, r,, AddFunc
      if (r != 1)
        s:=RegExReplace(s, "i)\n\s*FindText[^\n]+args\*[\s\S]*")
        , s:=RegExReplace(s, "i)\n; ok:=FindText[\s\S]*")
        , s:=SubStr(s, (s~="i)\n[ \t]*Text"))
    }
    Clipboard:=RegExReplace(s,"\R","`r`n")
    GuiControl, Focus, scr
    return
  Case "Apply":
    Gui, FindText_Main: Default
    GuiControlGet, NowHotkey
    GuiControlGet, SetHotkey1
    GuiControlGet, SetHotkey2
    if (NowHotkey!="")
      Hotkey, *%NowHotkey%,, Off UseErrorLevel
    k:=SetHotkey1!="" ? SetHotkey1 : SetHotkey2
    if (k!="")
      Hotkey, *%k%, %Gui_ScreenShot%, On UseErrorLevel
    GuiControl,, NowHotkey, %k%
    GuiControl,, SetHotkey1
    GuiControl, Choose, SetHotkey2, 0
    return
  Case "ScreenShot":
    Critical
    f:=A_Temp "\Ahk_ScreenShot"
    if !InStr(r:=FileExist(f), "D")
    {
      if (r)
      {
        FileSetAttrib, -R, %f%
        FileDelete, %f%
      }
      FileCreateDir, %f%
    }
    Loop
      f:=A_Temp "\Ahk_ScreenShot\" Format("{:03d}",A_Index) ".bmp"
    Until !FileExist(f)
    this.SavePic(f, StrSplit(arg1,"|")*)
    CoordMode, ToolTip
    this.ToolTip(Lang["s9"],, 0,, { bgcolor:"Yellow", color:"Red"
      , size:48, bold:"bold", trans:200, timeout:0.2 })
    return
  Case "Bind0", "Bind1", "Bind2", "Bind3", "Bind4":
    this.BindWindow(Bind_ID, bind_mode:=SubStr(cmd,5))
    ;-----------------
    Gui, FindText_HotkeyIf: New
    Gui, -Caption +ToolWindow +E0x80000
    Gui, Show, NA x0 y0 w0 h0, FindText_HotkeyIf
    Hotkey, IfWinExist, FindText_HotkeyIf
    if GetKeyState("RButton")
      Send {RButton Up}
    if GetKeyState("Ctrl")
      Send {Ctrl Up}
    Hotkey, *RButton, %Gui_Off%, On UseErrorLevel
    ;-----------------
    Critical, Off
    CoordMode, Mouse
    hk:="", State:=this.State("RButton"), oldx:=oldy:=""
    Loop
    {
      Sleep 50
      MouseGetPos, x, y
      if (oldx=x && oldy=y)
        Continue
      oldx:=x, oldy:=y
      ;---------------
      px:=x, py:=y, %Gui_%("getcors",1), %Gui_%("Reset")
      , r:=StrSplit(Lang["s10"] "|", "|")
      ToolTip % r[1] " : " x "," y "`n" r[2]
    }
    Until (hk!="") || (State!=this.State("RButton"))
    timeout:=A_TickCount+3000
    While (A_TickCount<timeout) && (State!=this.State("RButton"))
      Sleep 50
    ToolTip
    Hotkey, *RButton, %Gui_Off%, Off UseErrorLevel
    Hotkey, IfWinExist
    Gui, FindText_HotkeyIf: Destroy
    Critical
    this.BindWindow(0), cors.bind:=bind_mode
    return
  Case "MySlider1", "MySlider2":
    SetTimer, %Gui_Slider%, -10
    return
  Case "Slider":
    Critical
    dx:=nW>71 ? Round((nW-71)*MySlider1/100) : 0
    dy:=nH>25 ? Round((nH-25)*MySlider2/100) : 0
    if (oldx=dx && oldy=dy)
      return
    oldy:=dy, k:=0
    Loop % nW*nH
      c:=(!show[++k] ? WindowColor : bg="" ? cors[k] : ascii[k]
      ? "Black":"White"), %Gui_SetColor%()
    Loop % nW*(oldx!=dx)
    {
      i:=A_Index-dx
      if (i>=1 && i<=71)
      {
        c:=show[nW*nH+A_Index] ? 0x0000FF : 0xAAFFFF
        SendMessage, 0x2001, 0, c,, % "ahk_id " C_[71*25+i]
      }
    }
    oldx:=dx
    return
  Case "Reset":
    show:=[], ascii:=[], bg:=color:=""
    CutLeft:=CutRight:=CutUp:=CutDown:=k:=0
    Loop % nW*nH
      show[++k]:=1, c:=cors[k], %Gui_SetColor%()
    Loop % cors.CutLeft
      %Gui_%("CutL")
    Loop % cors.CutRight
      %Gui_%("CutR")
    Loop % cors.CutUp
      %Gui_%("CutU")
    Loop % cors.CutDown
      %Gui_%("CutD")
    return
  Case "SetColor":
    if (nW=71 && nH=25)
      tk:=k
    else
    {
      tx:=Mod(k-1,nW)-dx, ty:=(k-1)//nW-dy
      if (tx<0 || tx>=71 || ty<0 || ty>=25)
        return
      tk:=ty*71+tx+1
    }
    c:=c="Black" ? 0x000000 : c="White" ? 0xFFFFFF
      : ((c&0xFF)<<16)|(c&0xFF00)|((c&0xFF0000)>>16)
    SendMessage, 0x2001, 0, c,, % "ahk_id " . C_[tk]
    return
  Case "RepColor":
    show[k]:=1, c:=(bg="" ? cors[k] : ascii[k] ? "Black":"White")
    , %Gui_SetColor%()
    return
  Case "CutColor":
    show[k]:=0, c:=WindowColor, %Gui_SetColor%()
    return
  Case "RepL":
    if (CutLeft<=cors.CutLeft)
    || (bg!="" && InStr(color,"**")
    && CutLeft=cors.CutLeft+1)
      return
    k:=CutLeft-nW, CutLeft--
    Loop %nH%
      k+=nW, (A_Index>CutUp && A_Index<nH+1-CutDown && %Gui_%("RepColor"))
    return
  Case "CutL":
    if (CutLeft+CutRight>=nW)
      return
    CutLeft++, k:=CutLeft-nW
    Loop %nH%
      k+=nW, (A_Index>CutUp && A_Index<nH+1-CutDown && %Gui_%("CutColor"))
    return
  Case "CutL3":
    Loop 3
      %Gui_%("CutL")
    return
  Case "RepR":
    if (CutRight<=cors.CutRight)
    || (bg!="" && InStr(color,"**")
    && CutRight=cors.CutRight+1)
      return
    k:=1-CutRight, CutRight--
    Loop %nH%
      k+=nW, (A_Index>CutUp && A_Index<nH+1-CutDown && %Gui_%("RepColor"))
    return
  Case "CutR":
    if (CutLeft+CutRight>=nW)
      return
    CutRight++, k:=1-CutRight
    Loop %nH%
      k+=nW, (A_Index>CutUp && A_Index<nH+1-CutDown && %Gui_%("CutColor"))
    return
  Case "CutR3":
    Loop 3
      %Gui_%("CutR")
    return
  Case "RepU":
    if (CutUp<=cors.CutUp)
    || (bg!="" && InStr(color,"**")
    && CutUp=cors.CutUp+1)
      return
    k:=(CutUp-1)*nW, CutUp--
    Loop %nW%
      k++, (A_Index>CutLeft && A_Index<nW+1-CutRight && %Gui_%("RepColor"))
    return
  Case "CutU":
    if (CutUp+CutDown>=nH)
      return
    CutUp++, k:=(CutUp-1)*nW
    Loop %nW%
      k++, (A_Index>CutLeft && A_Index<nW+1-CutRight && %Gui_%("CutColor"))
    return
  Case "CutU3":
    Loop 3
      %Gui_%("CutU")
    return
  Case "RepD":
    if (CutDown<=cors.CutDown)
    || (bg!="" && InStr(color,"**")
    && CutDown=cors.CutDown+1)
      return
    k:=(nH-CutDown)*nW, CutDown--
    Loop %nW%
      k++, (A_Index>CutLeft && A_Index<nW+1-CutRight && %Gui_%("RepColor"))
    return
  Case "CutD":
    if (CutUp+CutDown>=nH)
      return
    CutDown++, k:=(nH-CutDown)*nW
    Loop %nW%
      k++, (A_Index>CutLeft && A_Index<nW+1-CutRight && %Gui_%("CutColor"))
    return
  Case "CutD3":
    Loop 3
      %Gui_%("CutD")
    return
  Case "Gray2Two":
    Gui, FindText_Capture: Default
    GuiControl, Focus, Threshold
    GuiControlGet, Threshold
    if (Threshold="")
    {
      pp:=[]
      Loop 256
        pp[A_Index-1]:=0
      Loop % nW*nH
        if (show[A_Index])
          pp[gray[A_Index]]++
      IP0:=IS0:=0
      Loop 256
        k:=A_Index-1, IP0+=k*pp[k], IS0+=pp[k]
      Threshold:=Floor(IP0/IS0)
      Loop 20
      {
        LastThreshold:=Threshold
        IP1:=IS1:=0
        Loop % LastThreshold+1
          k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
        IP2:=IP0-IP1, IS2:=IS0-IS1
        if (IS1!=0 && IS2!=0)
          Threshold:=Floor((IP1/IS1+IP2/IS2)/2)
        if (Threshold=LastThreshold)
          Break
      }
      GuiControl,, Threshold, %Threshold%
    }
    Threshold:=Round(Threshold)
    color:="*" Threshold, k:=i:=0
    Loop % nW*nH
    {
      ascii[++k]:=v:=(gray[k]<=Threshold)
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_SetColor%()
    }
    bg:=i>0 ? "1":"0"
    return
  Case "GrayDiff2Two":
    Gui, FindText_Capture: Default
    GuiControlGet, GrayDiff
    if (GrayDiff="")
    {
      Gui, +OwnDialogs
      MsgBox, 4096, Tip, % Lang["s11"] " !", 1
      return
    }
    if (CutLeft=cors.CutLeft)
      %Gui_%("CutL")
    if (CutRight=cors.CutRight)
      %Gui_%("CutR")
    if (CutUp=cors.CutUp)
      %Gui_%("CutU")
    if (CutDown=cors.CutDown)
      %Gui_%("CutD")
    GrayDiff:=Round(GrayDiff)
    color:="**" GrayDiff, k:=i:=0
    Loop % nW*nH
    {
      j:=gray[++k]+GrayDiff
      , ascii[k]:=v:=( gray[k-1]>j || gray[k+1]>j
      || gray[k-nW]>j || gray[k+nW]>j
      || gray[k-nW-1]>j || gray[k-nW+1]>j
      || gray[k+nW-1]>j || gray[k+nW+1]>j )
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_SetColor%()
    }
    bg:=i>0 ? "1":"0"
    return
  Case "Color2Two", "ColorPos2Two":
    Gui, FindText_Capture: Default
    GuiControlGet, c,, SelColor
    if (c="")
    {
      Gui, +OwnDialogs
      MsgBox, 4096, Tip, % Lang["s12"] " !", 1
      return
    }
    UsePos:=(cmd="ColorPos2Two") ? 1:0
    GuiControlGet, n,, Similar1
    n:=Round(n/100,2), color:=c "@" n
    , n:=Floor(512*9*255*255*(1-n)*(1-n)), k:=i:=0
    , rr:=(c>>16)&0xFF, gg:=(c>>8)&0xFF, bb:=c&0xFF
    Loop % nW*nH
    {
      c:=cors[++k], r:=((c>>16)&0xFF)-rr
      , g:=((c>>8)&0xFF)-gg, b:=(c&0xFF)-bb, j:=r+rr+rr
      , ascii[k]:=v:=((1024+j)*r*r+2048*g*g+(1534-j)*b*b<=n)
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_SetColor%()
    }
    bg:=i>0 ? "1":"0"
    return
  Case "ColorDiff2Two":
    Gui, FindText_Capture: Default
    GuiControlGet, c,, SelColor
    if (c="")
    {
      Gui, +OwnDialogs
      MsgBox, 4096, Tip, % Lang["s12"] " !", 1
      return
    }
    GuiControlGet, dR
    GuiControlGet, dG
    GuiControlGet, dB
    rr:=(c>>16)&0xFF, gg:=(c>>8)&0xFF, bb:=c&0xFF
    , n:=Format("{:06X}",(dR<<16)|(dG<<8)|dB)
    , color:=StrReplace(c "-" n,"0x"), k:=i:=0
    Loop % nW*nH
    {
      c:=cors[++k], r:=(c>>16)&0xFF, g:=(c>>8)&0xFF
      , b:=c&0xFF, ascii[k]:=v:=(Abs(r-rr)<=dR
      && Abs(g-gg)<=dG && Abs(b-bb)<=dB)
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_SetColor%()
    }
    bg:=i>0 ? "1":"0"
    return
  Case "Modify":
    GuiControlGet, Modify
    return
  Case "MultiColor":
    GuiControlGet, MultiColor
    Result:=""
    ToolTip
    return
  Case "Undo":
    Result:=RegExReplace(Result, ",[^/]+/[^/]+/[^/]+$")
    ToolTip % Trim(Result,"/,")
    return
  Case "Similar1":
    GuiControl,, Similar2, %Similar1%
    return
  Case "Similar2":
    GuiControl,, Similar1, %Similar2%
    return
  Case "GetTxt":
    txt:=""
    if (bg="")
      return
    k:=0
    Loop %nH%
    {
      v:=""
      Loop %nW%
        v.=!show[++k] ? "" : ascii[k] ? "1":"0"
      txt.=v="" ? "" : v "`n"
    }
    return
  Case "Auto":
    %Gui_%("GetTxt")
    if (txt="")
    {
      Gui, FindText_Capture: +OwnDialogs
      MsgBox, 4096, Tip, % Lang["s13"] " !", 1
      return
    }
    While InStr(txt,bg)
    {
      if (txt~="^" bg "+\n")
        txt:=RegExReplace(txt, "^" bg "+\n"), %Gui_%("CutU")
      else if !(txt~="m`n)[^\n" bg "]$")
        txt:=RegExReplace(txt, "m`n)" bg "$"), %Gui_%("CutR")
      else if (txt~="\n" bg "+\n$")
        txt:=RegExReplace(txt, "\n\K" bg "+\n$"), %Gui_%("CutD")
      else if !(txt~="m`n)^[^\n" bg "]")
        txt:=RegExReplace(txt, "m`n)^" bg), %Gui_%("CutL")
      else Break
    }
    txt:=""
    return
  Case "OK", "SplitAdd", "AllAdd":
    Gui, FindText_Capture: Default
    Gui, +OwnDialogs
    %Gui_%("GetTxt")
    if (txt="") && (!MultiColor)
    {
      MsgBox, 4096, Tip, % Lang["s13"] " !", 1
      return
    }
    if InStr(color,"@") && (UsePos) && (!MultiColor)
    {
      r:=StrSplit(color,"@")
      k:=i:=j:=0
      Loop % nW*nH
      {
        if (!show[++k])
          Continue
        i++
        if (k=cors.SelPos)
        {
          j:=i
          Break
        }
      }
      if (j=0)
      {
        MsgBox, 4096, Tip, % Lang["s12"] " !", 1
        return
      }
      color:="#" j "@" r[2]
    }
    GuiControlGet, Comment
    if (cmd="SplitAdd") && (!MultiColor)
    {
      if InStr(color,"#")
      {
        MsgBox, 4096, Tip, % Lang["s14"], 3
        return
      }
      bg:=StrLen(StrReplace(txt,"0"))
        > StrLen(StrReplace(txt,"1")) ? "1":"0"
      s:="", i:=0, k:=nW*nH+1+CutLeft
      Loop % w:=nW-CutLeft-CutRight
      {
        i++
        if (!show[k++] && A_Index<w)
          Continue
        i:=Format("{:d}",i)
        v:=RegExReplace(txt,"m`n)^(.{" i "}).*","$1")
        txt:=RegExReplace(txt,"m`n)^.{" i "}"), i:=0
        While InStr(v,bg)
        {
          if (v~="^" bg "+\n")
            v:=RegExReplace(v,"^" bg "+\n")
          else if !(v~="m`n)[^\n" bg "]$")
            v:=RegExReplace(v,"m`n)" bg "$")
          else if (v~="\n" bg "+\n$")
            v:=RegExReplace(v,"\n\K" bg "+\n$")
          else if !(v~="m`n)^[^\n" bg "]")
            v:=RegExReplace(v,"m`n)^" bg)
          else Break
        }
        if (v!="")
        {
          v:=Format("{:d}",InStr(v,"`n")-1) "." this.bit2base64(v)
          s.="`nText.=""|<" SubStr(Comment,1,1) ">" color "$" v """`n"
          Comment:=SubStr(Comment, 2)
        }
      }
      Event:=cmd, Result:=s
      Gui, Hide
      return
    }
    if (!MultiColor)
      txt:=Format("{:d}",InStr(txt,"`n")-1) "." this.bit2base64(txt)
    else
    {
      GuiControlGet, dRGB
      r:=StrSplit(Trim(StrReplace(Result, ",", "/"), "/"), "/")
      , x:=r[1], y:=r[2], s:="", i:=1
      Loop % r.Length()//3
        s.="," (r[i++]-x) "/" (r[i++]-y) "/" r[i++]
      txt:=SubStr(s,2), color:="##" dRGB
    }
    s:="`nText.=""|<" Comment ">" color "$" txt """`n"
    if (cmd="AllAdd")
    {
      Event:=cmd, Result:=s
      Gui, Hide
      return
    }
    x:=px-ww+CutLeft+(nW-CutLeft-CutRight)//2
    y:=py-hh+CutUp+(nH-CutUp-CutDown)//2
    s:=StrReplace(s, "Text.=", "Text:="), r:=StrSplit(Lang["s8"] "|||||||", "|")
    s:="`; #Include <FindText>`n"
    . "`nt1:=A_TickCount, Text:=X:=Y:=""""`n" s
    . "`nif (ok:=FindText(X, Y, " x "-150000, "
    . y "-150000, " x "+150000, " y "+150000, 0, 0, Text))"
    . "`n{"
    . "`n  `; FindText()." . "Click(" . "X, Y, ""L"")"
    . "`n}`n"
    . "`n`; ok:=FindText(X:=""wait"", Y:=3, 0,0,0,0,0,0,Text)    `; " r[7]
    . "`n`; ok:=FindText(X:=""wait0"", Y:=-1, 0,0,0,0,0,0,Text)  `; " r[8]
    . "`n`nMsgBox, 4096, Tip, `% """ r[1] ":``t"" (ok?ok.Length():0)"
    . "`n  . ""``n``n" r[2] ":``t"" (A_TickCount-t1) "" " r[3] """"
    . "`n  . ""``n``n" r[4] ":``t"" X "", "" Y"
    . "`n  . ""``n``n" r[5] ":``t<"" (ok?ok[1].id:"""") "">""`n"
    . "`nTry For i,v in ok  `; ok " r[6] " ok:=FindText().ok"
    . "`n  if (i<=2)"
    . "`n    FindText().MouseTip(ok[i].x, ok[i].y)`n"
    Event:=cmd, Result:=s
    Gui, Hide
    return
  Case "Save":
    x:=px-ww+CutLeft, w:=nW-CutLeft-CutRight
    y:=py-hh+CutUp, h:=nH-CutUp-CutDown
    %Gui_%("ScreenShot", x "|" y "|" (x+w-1) "|" (y+h-1) "|0")
    return
  Case "ShowPic":
    ControlGet, i, CurrentLine,,, ahk_id %hscr%
    ControlGet, s, Line, %i%,, ahk_id %hscr%
    GuiControl, FindText_Main:, MyPic, % Trim(this.ASCII(s),"`n")
    return
  Case "KeyDown":
    Critical
    if (A_Gui!="FindText_Main")
      return
    if (A_GuiControl="scr")
      SetTimer, %Gui_ShowPic%, -150
    else if (A_GuiControl="ClipText")
    {
      GuiControlGet, s, FindText_Main:, ClipText
      GuiControl, FindText_Main:, MyPic, % Trim(this.ASCII(s),"`n")
    }
    return
  Case "LButtonDown":
    Critical
    if (A_Gui!="FindText_Capture")
      return %Gui_%("KeyDown")
    MouseGetPos,,,, k2, 2
    k1:=0
    ListLines % (lls:=A_ListLines)?0:0
    For k_,v_ in C_
      if (v_=k2) && (k1:=k_)
        Break
    ListLines % lls
    if (k1<1)
      return
    if (k1>71*25)
    {
      k3:=nW*nH+(k1-71*25)+dx
      k1:=(show[k3]:=!show[k3]) ? 0x0000FF : 0xAAFFFF
      SendMessage, 0x2001, 0, k1,, % "ahk_id " k2
      return
    }
    k2:=Mod(k1-1,71)+dx, k3:=(k1-1)//71+dy
    if (k2<0 || k2>=nW || k3<0 || k3>=nH)
      return
    k1:=k, k:=k3*nW+k2+1, k2:=c
    if (MultiColor && show[k])
    {
      c:="," Mod(k-1,nW) "/" k3 "/"
      . Format("{:06X}",cors[k]&0xFFFFFF)
      , Result.=InStr(Result,c) ? "":c
      ToolTip % Trim(Result,"/,")
    }
    else if (Modify && bg!="" && show[k])
    {
      c:=((ascii[k]:=!ascii[k]) ? "Black":"White"), %Gui_SetColor%()
    }
    else
    {
      c:=cors[k], cors.SelPos:=k
      Gui, FindText_Capture: Default
      GuiControl,, SelGray, % gray[k]
      GuiControl,, SelColor, % Format("0x{:06X}",c&0xFFFFFF)
      GuiControl,, SelR, % (c>>16)&0xFF
      GuiControl,, SelG, % (c>>8)&0xFF
      GuiControl,, SelB, % c&0xFF
    }
    k:=k1, c:=k2
    return
  Case "MouseMove":
    static PrevControl:=""
    if (PrevControl!=A_GuiControl)
    {
      ToolTip
      PrevControl:=A_GuiControl
      if (Gui_ToolTip)
      {
        SetTimer, %Gui_ToolTip%, % PrevControl ? -500 : "Off"
        SetTimer, %Gui_ToolTipOff%, % PrevControl ? -5500 : "Off"
      }
    }
    return
  Case "ToolTip":
    MouseGetPos,,, _TT
    IfWinExist, ahk_id %_TT% ahk_class AutoHotkeyGUI
      ToolTip % Tip_Text[PrevControl]
    return
  Case "ToolTipOff":
    ToolTip
    return
  Case "CutL2", "CutR2", "CutU2", "CutD2":
    Gui, FindText_Main: Default
    GuiControlGet, s,, MyPic
    s:=Trim(s,"`n") . "`n", v:=SubStr(cmd,4,1)
    if (v="U")
      s:=RegExReplace(s,"^[^\n]+\n")
    else if (v="D")
      s:=RegExReplace(s,"[^\n]+\n$")
    else if (v="L")
      s:=RegExReplace(s,"m`n)^[^\n]")
    else if (v="R")
      s:=RegExReplace(s,"m`n)[^\n]$")
    GuiControl,, MyPic, % Trim(s,"`n")
    return
  Case "Update":
    Gui, FindText_Main: Default
    GuiControl, Focus, scr
    ControlGet, i, CurrentLine,,, ahk_id %hscr%
    ControlGet, s, Line, %i%,, ahk_id %hscr%
    if !RegExMatch(s, "O)(<[^>\n]*>[^$\n]+\$)\d+\.[\w+/]+", r)
      return
    GuiControlGet, v,, MyPic
    v:=Trim(v,"`n") . "`n", w:=Format("{:d}",InStr(v,"`n")-1)
    v:=StrReplace(StrReplace(v,"0","1"),"_","0")
    s:=StrReplace(s, r[0], r[1] . w "." this.bit2base64(v))
    v:="{End}{Shift Down}{Home}{Shift Up}{Del}"
    ControlSend,, %v%, ahk_id %hscr%
    Control, EditPaste, %s%,, ahk_id %hscr%
    ControlSend,, {Home}, ahk_id %hscr%
    return
  Case "Load_Language_Text":
    s:="
    (
Myww       = 宽度 = 调整捕获范围的宽度
Myhh       = 高度 = 调整捕获范围的高度
AddFunc    = 附加 = 将 FindText() 函数代码一起复制
NowHotkey  = 截屏热键 = 当前的截屏热键
SetHotkey1 = = 第一优先级的截屏热键
SetHotkey2 = = 第二优先级的截屏热键
Apply      = 应用 = 应用新的截屏热键
CutU2      = 上删 = 裁剪下面编辑框中文字的上边缘
CutL2      = 左删 = 裁剪下面编辑框中文字的左边缘
CutR2      = 右删 = 裁剪下面编辑框中文字的右边缘
CutD2      = 下删 = 裁剪下面编辑框中文字的下边缘
Update     = 更新 = 更新下面编辑框中文字到代码行中
GetRange   = 获取屏幕范围 = 获取屏幕范围到剪贴板并替换代码中的范围
GetOffset  = 获取相对坐标 = 获取相对图像中心的坐标并替换代码中的坐标
GetClipOffset  = 获取相对坐标2 = 获取相对左边编辑框的坐标
Capture    = 抓图 = 开始屏幕抓图
CaptureS   = 截屏抓图 = 先恢复上一次的截屏到屏幕再开始抓图
Test       = 测试 = 测试生成的代码是否可以找字成功
TestClip   = 测试2 = 测试左边文本框中的文字，结果复制到剪贴板
Paste      = 粘贴 = 粘贴复制到剪贴板的文字数据
CopyOffset = 复制2 = 复制左边的偏移坐标到剪贴板
Copy       = 复制 = 复制代码到剪贴板
Reset      = 重读 = 重新读取原来的彩色图像
SplitAdd   = 分割添加 = 使用黄色的标签来分割图像为单个的图像数据，添加到旧代码中
AllAdd     = 整体添加 = 将文字数据整体添加到旧代码中
OK         = 确定 = 生成全新的代码替换旧代码
Cancel     = 取消 = 关闭窗口不做任何事
Save       = 保存图片 = 保存修剪后的原始图片到默认目录
Gray2Two      = 灰度阈值二值化 = 灰度小于阈值的为黑色其余白色
GrayDiff2Two  = 灰度差值二值化 = 某点与周围灰度之差大于差值的为黑色其余白色
Color2Two     = 颜色相似二值化 = 指定颜色及相似色为黑色其余白色
ColorPos2Two  = 颜色位置二值化 = 指定颜色及相似色为黑色其余白色，但是记录该色的位置
ColorDiff2Two = 颜色分量二值化 = 指定颜色及颜色分量小于允许值的为黑色其余白色
SelGray    = 灰度 = 选定颜色的灰度值 (0-255)
SelColor   = 颜色 = 选定颜色的RGB颜色值
SelR       = 红 = 选定颜色的红色分量
SelG       = 绿 = 选定颜色的绿色分量
SelB       = 蓝 = 选定颜色的蓝色分量
RepU       = -上 = 撤销裁剪上边缘1个像素
CutU       = 上 = 裁剪上边缘1个像素
CutU3      = 上3 = 裁剪上边缘3个像素
RepL       = -左 = 撤销裁剪左边缘1个像素
CutL       = 左 = 裁剪左边缘1个像素
CutL3      = 左3 = 裁剪左边缘3个像素
Auto       = 自动 = 二值化之后自动裁剪空白边缘
RepR       = -右 = 撤销裁剪右边缘1个像素
CutR       = 右 = 裁剪右边缘1个像素
CutR3      = 右3 = 裁剪右边缘3个像素
RepD       = -下 = 撤销裁剪下边缘1个像素
CutD       = 下 = 裁剪下边缘1个像素
CutD3      = 下3 = 裁剪下边缘3个像素
Modify     = 修改 = 二值化后允许修改黑白点
MultiColor = 多色查找 = 鼠标选择多种颜色，之后点击“确定”按钮
Undo       = 撤销 = 撤销上一次选择的颜色
Comment    = 识别文字 = 识别文本 (包含在<>中)，分割添加时也会分解成单个文字
Threshold  = 灰度阈值 = 灰度阈值 (0-255)
GrayDiff   = 灰度差值 = 灰度差值 (0-255)
Similar1   = 相似度 = 与选定颜色的相似度
Similar2   = 相似度 = 与选定颜色的相似度
DiffR      = 红 = 红色分量允许的偏差 (0-255)
DiffG      = 绿 = 绿色分量允许的偏差 (0-255)
DiffB      = 蓝 = 蓝色分量允许的偏差 (0-255)
DiffRGB    = 红/绿/蓝 = 多色查找时各分量允许的偏差 (0-255)
Bind0      = 绑定窗口1 = 绑定窗口使用GetDCEx()获取后台窗口图像
Bind1      = 绑定窗口1+ = 绑定窗口使用GetDCEx()并修改窗口透明度
Bind2      = 绑定窗口2 = 绑定窗口使用PrintWindow()获取后台窗口图像
Bind3      = 绑定窗口2+ = 绑定窗口使用PrintWindow()并修改窗口透明度
Bind4      = 绑定窗口3 = 绑定窗口使用PrintWindow(,,3)获取后台窗口图像
OK2        = 确定 = 生成全新的代码替换旧代码
Cancel2    = 取消 = 关闭窗口不做任何事
ClearAll   = 清空 = 清空所有保存的截图
OpenDir    = 打开目录 = 打开保存屏幕截图的目录
SavePic    = 保存图片 = 选择一个范围保存为图片
ClipText   = = 显示粘贴的文字数据
Offset     = = 显示“获取相对坐标2”获取的结果
s1  = 查找文字工具
s2  = 灰度阈值|灰度差值|颜色相似|颜色位置|颜色分量|多色查找
s3  = 图像二值化及分割
s4  = 抓图生成字库及找字代码
s5  = 位置|先点击右键一次\n把鼠标移开\n再点击右键一次
s6  = 解绑窗口使用
s7  = 请用左键拖动范围\n坐标复制到剪贴板
s8  = 找到|时间|毫秒|位置|结果|值可以这样获取|等待3秒等图像出现|无限等待等图像消失
s9  = 截屏成功
s10 = 鼠标位置|穿透显示绑定窗口\n点击右键完成抓图
s11 = 请先设定灰度差值
s12 = 请先选择核心颜色
s13 = 请先将图像二值化
s14 = 不能用于颜色位置二值化模式, 因为分割后会导致位置错误
s15 = 你确定选择的范围吗？\n\n如果不确定，可以重新选择
    )"
        Lang:=[], Tip_Text:=[]
        Loop Parse, s, `n, `r
          if InStr(v:=A_LoopField, "=")
            r:=StrSplit(StrReplace(v "==","\n","`n"), "=", "`t ")
              , Lang[r[1]]:=r[2], Tip_Text[r[1]]:=r[3]
        return
      }
    }

  }  ;// Class End

  Script_End() {
  }

;================= The End =================

;

