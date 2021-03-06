import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.Volume
import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86
import System.IO

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig {
        manageHook = manageDocks <+> manageHook defaultConfig,
        layoutHook = avoidStruts $ layoutHook defaultConfig,
        logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc,
            ppTitle = xmobarColor "Blue" "" . shorten 50
            },
--        workspaces = withScreens 2 ["web", "email", "irc"] ,
        modMask = mod4Mask -- Rebind Mod to the Windows key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock") -- mod + shift + l locks
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s") -- screenshot current image
        , ((0, xK_Print), spawn "scrot") -- screenshot whole window 
        
        -- change keyboard layouts 
        -- From:
        -- askubuntu.com/questions/132616/
        --             how-do-i-configure-keyboard-layouts-using-xmonad-as-my-window-manager
        , ((mod1Mask .|. shiftMask, xK_z), spawn "setxkbmap -layout us")
        , ((mod1Mask .|. shiftMask, xK_x), spawn "setxkbmap -layout latam")
          
        -- volume keys     
        , ((0, xF86XK_AudioLowerVolume) , lowerVolume 3 >> return())
        , ((0, xF86XK_AudioRaiseVolume) , raiseVolume 3 >> return())

        -- pavucontrol gets in the way 
        , ((0, xF86XK_AudioMute), spawn "/home/santiago/.xmonad/togglemute.sh")

        -- closing the lid
        --        , ((0, xF86XK_Sleep), spawn "/home/santiago/.xmonad/sleep.sh")
        --  this will be done kernel-wise by modifying: /etc/acpi/events/lidbtn
        --   change the script from lid.sh to sleep.sh 
        , ((mod4Mask .|. shiftMask, xK_s), spawn "/home/santiago/.xmonad/sleep")

    	-- let's change brightness, check the adjust_brightness script
    	--  to see how this is done... the commands executed are just
    	--  simple setuid wrappers for the script
    	, ((0, xF86XK_MonBrightnessUp), 
            spawn "/home/santiago/.xmonad/raise_brightness")
        , ((0, xF86XK_MonBrightnessDown),
            spawn "/home/santiago/.xmonad/lower_brightness")
        ]
       


