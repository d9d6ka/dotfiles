---------------
--- Imports ---
---------------
import XMonad hiding ( (|||) )
import Data.Monoid
import System.Exit

import XMonad.Util.Run
import XMonad.Util.SpawnOnce

import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.WindowNavigation

import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.WorkspaceHistory

import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))

--------------------
--- Basic values ---
--------------------
myTerminal      = "$TERMINAL"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 1
myGapWidth      = 2

myNormalBorderColor  = "#111111"
myFocusedBorderColor = "#dddddd"

myModMask       = mod4Mask

------------------
--- Workspaces ---
------------------
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
    where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myClickableWorkspaces :: [String]
myClickableWorkspaces = clickable . (map xmobarEscape) $ myWorkspaces 
    where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

-------------------------
--- Number of windows ---
-------------------------
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-------------------
--- Keybindings ---
-------------------
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
    -- launch dmenu
    , ((modm .|. shiftMask, xK_Return), spawn "rofi -show drun -show-icons")
    -- launch gmrun
    , ((modm .|. shiftMask .|. controlMask, xK_Return), spawn "rofi -show run")
    -- powermenu
    , ((0,    xF86XK_PowerOff        ), spawn "powermenu")
    -- volume control
    , ((0,    xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0,    xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ((0,    xF86XK_AudioMute),        spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    -- clipmenu
    , ((modm,               xK_c     ), spawn "clipmenu -p \"Clip:\"")
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
    -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    -- Jump to specific layout (we should use FINAL name)
    , ((modm,               xK_t     ), sendMessage $ JumpToLayout "[]=")
    , ((modm,               xK_r     ), sendMessage $ JumpToLayout "[@]")
    , ((modm,               xK_g     ), sendMessage $ JumpToLayout "###")
    , ((modm,               xK_u     ), sendMessage $ JumpToLayout "[M]")
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_m     ), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modm .|. shiftMask, xK_t     ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    -- Window navigation
    , ((modm                , xK_Right), sendMessage $ Go R)
    , ((modm                , xK_Left ), sendMessage $ Go L)
    , ((modm                , xK_Up   ), sendMessage $ Go U)
    , ((modm                , xK_Down ), sendMessage $ Go D)
    , ((modm .|. controlMask, xK_Right), sendMessage $ Swap R)
    , ((modm .|. controlMask, xK_Left ), sendMessage $ Swap L)
    , ((modm .|. controlMask, xK_Up   ), sendMessage $ Swap U)
    , ((modm .|. controlMask, xK_Down ), sendMessage $ Swap D) 
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm .|. shiftMask .|. controlMask, xK_q), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    --
    -- mod-{F1,F2,F3}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{F1,F2,F3}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_F1, xK_F2, xK_F3] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

---------------------
--- Mousebindings ---
---------------------
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

---------------
--- Layouts ---
---------------
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- default tiling algorithm partitions the screen into two panes
tiled   = renamed [Replace "[]="]
          $ windowNavigation
          $ mySpacing myGapWidth
          $ Tall nmaster delta ratio
-- Bottom stack
bottomstack = renamed [Replace "[]T"]
              $ windowNavigation
              $ mySpacing myGapWidth
              $ Mirror 
              $ Tall nmaster delta ratio
-- Monocle
monocle = renamed [Replace "[M]"]
          $ Full
-- Fibonacci
fibonacci  = renamed [Replace "[@]"]
             $ windowNavigation
             $ mySpacing myGapWidth
             $ spiral (6/7)
-- Grid
grid    = renamed [Replace "###"]
          $ windowNavigation
          $ mySpacing myGapWidth
          $ Grid (16/10)
-- The default number of windows in the master pane
nmaster = 1
-- Default proportion of screen occupied by master pane
ratio   = 1/2
-- Percent of screen to increment by when resizing panes
delta   = 3/100

-- Layouts list
myLayout = avoidStruts $ smartBorders
           $ tiled ||| bottomstack ||| fibonacci ||| grid ||| monocle

--------------------
--- Window rules ---
--------------------
myManageHook = manageDocks <+> composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Firefox"        --> doShift ( myClickableWorkspaces !! 8 )
    , className =? "Chromium"       --> doShift ( myClickableWorkspaces !! 8 )
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

--------------------
--- Events rules ---
--------------------
myEventHook = mempty <+> docksEventHook

----------------------------
--- Autostart script etc ---
----------------------------
myStartupHook = do
    spawn "$HOME/.xmonad/autostart"

-----------------------------------
--- Main function, start xmonad ---
-----------------------------------
main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar $HOME/.xmonad/xmobarrc"
    xmonad $ ewmh def {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myClickableWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        -- layouts
        layoutHook         = myLayout,
        -- windows and events hooks
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        -- log hook, allowing for xmobar
        logHook            = workspaceHistoryHook <+> dynamicLogWithPP xmobarPP
            { ppOutput  = \x -> hPutStrLn xmproc x
            , ppCurrent = xmobarColor "#dddddd" "#666666" . wrap " " " "  -- Current workspace in xmobar
            , ppVisible = xmobarColor "#dddddd" "" . wrap " " " "         -- Visible but not current workspace
            , ppHidden  = xmobarColor "#dddddd" "" . wrap " " " "         -- Hidden workspaces in xmobar
            , ppHiddenNoWindows = xmobarColor "#666666" "" . wrap " " " " -- Hidden workspaces (no windows)
            , ppUrgent  = xmobarColor "#dddddd" "#C45500" . wrap " " " "  -- Urgent workspace
            , ppTitle   = xmobarColor "#666666" "" . shorten 60           -- Title of active window in xmobar
            , ppWsSep   = ""
            , ppSep     = "<fc=#666666> <fn=1>|</fn> </fc>"               -- Separators in xmobar
            , ppExtras  = [windowCount]                                   -- # of windows current workspace
            , ppOrder   = \(ws:l:t:ex) -> [ws,l]++ex++[t]
            },
        -- autostart hook
        startupHook        = myStartupHook
    }
