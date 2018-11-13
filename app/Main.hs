{-# LANGUAGE OverloadedStrings  #-}
module Main where

import VHDLpSyntax
import PrettyVHDL
import Data.Text.Prettyprint.Doc  ((<+>))
import Data.Text.Prettyprint.Doc.Render.Text(putDoc)
import Data.Text.Prettyprint.Doc.Util (putDocW) 
import qualified Data.Text.Lazy as T hiding (Text)
import Data.Text.Lazy (Text)               



ps= [
     Signal "ib_MAX10_CLK1_50"  IN    U       ""
    ,Signal "ib_SW"             IN    (SLV "2" "0") ""
    ,Signal "ob_VGA_HS"         OUT   U       ""
    ,Signal "ob_VGA_VS"         OUT   U       ""
    ,Signal "ob_VGA_R "         OUT   (SLV "3" "0") "" 
    ,Signal "ob_VGA_G "         OUT   (SLV "3" "0") ""
    ,Signal "ob_VGA_B "         OUT   (SLV "3" "0") ""
    ,Signal "ob_LEDR  "         OUT   (SLV "9" "0") ""
    ,Signal "ov7670_xclk"       OUT   U       "mclk / gpio[20] (pin 23)" 
    ,Signal "ov7670_pclk"       IN    U       "pclk / gpio[21] (pin 24)" 
    ,Signal "ov7670_siod"       INOUT U       "sda  / gpio[22] (pin 25)" 
    ,Signal "ov7670_sioc"       OUT   U       "scl  / gpio[23] (pin 26)"    
    ,Signal "ov7670_href"       IN    U       "hs   / gpio[24] (pin 27)" 
    ,Signal "ov7670_vsync"      IN    U       "vs   / gpio[25] (pin 28)"    
    ,Signal "ov7670_data"       IN    (SLV "7" "0") ""
    ,Signal "ov7670_pwdn"       OUT   U       "pwdn   / gpio[34] (pin 39)" 
    ,Signal "ov7670_reset"      OUT   U       "reset  / gpio[35] (pin 40)" 
    ,Signal "o_Config_finished" OUT   U       "" 
    ]

e  = Entity "MyEntity" ps
 
main :: IO ()
main = do
  putDocW 80 $ ptyEntity True 15 $ Entity "MainEntity" ps3
  putStrLn ""
  putDocW 80 $ ptyEntity True 15 $ Entity "ov7670_controller" ps2
  putStrLn ""
  putDocW 80 $ ptyComponent True 15 $ Entity "ov7670_controller" ps2
  putStrLn ""

ps2= [
   Signal "clk"    IN           U ""
  ,Signal "resend" IN           U ""
  ,Signal "config_finished" OUT U ""
  ,Signal "sioc"   OUT          U ""
  ,Signal "siod"   INOUT        U ""
  ,Signal "reset"  OUT          U ""
  ,Signal "pwdn"   OUT          U ""
  ,Signal "xclk"   OUT          U ""
  ]


data PPP = PPP {pa :: Int, pb :: String} | Comm String
  deriving Show

p1 = PPP 1 "aaa"
p2 = Comm "XXXXXXXX"

{-
pps = [Com "board signals"
      , Sig "ob_VGA" IN U "some vga signal"
      , Sig "ob_VGA" IN U "some vga signal"
      , Com "other signals"
      , Sig "ob_VGA" IN U "some vga signal"
      , Sig "ob_VGA" IN U "some vga signal"
      ]
-}

ps3= [
     cmm "board inputs"
    ,Signal "ib_MAX10_CLK1_50"  IN    U       ""
    ,Signal "ib_SW"             IN    (SLV "2" "0") ""
    ,cmm "board outputs"
    ,cmm "vga port"
    ,Signal "ob_VGA_HS"         OUT   U       ""
    ,Signal "ob_VGA_VS"         OUT   U       ""
    ,Signal "ob_VGA_R "         OUT   (SLV "3" "0") "" 
    ,Signal "ob_VGA_G "         OUT   (SLV "3" "0") ""
    ,Signal "ob_VGA_B "         OUT   (SLV "3" "0") ""
    ,cmm "others"
    ,Signal "ob_LEDR  "         OUT   (SLV "9" "0") ""
    ,cmm "OV7670 camera"
    ,Signal "ov7670_xclk"       OUT   U       "mclk / gpio[20] (pin 23)" 
    ,Signal "ov7670_pclk"       IN    U       "pclk / gpio[21] (pin 24)" 
    ,Signal "ov7670_siod"       INOUT U       "sda  / gpio[22] (pin 25)" 
    ,Signal "ov7670_sioc"       OUT   U       "scl  / gpio[23] (pin 26)"    
    ,Signal "ov7670_href"       IN    U       "hs   / gpio[24] (pin 27)" 
    ,Signal "ov7670_vsync"      IN    U       "vs   / gpio[25] (pin 28)"    
    ,Signal "ov7670_data"       IN    (SLV "7" "0") ""
    ,Signal "ov7670_pwdn"       OUT   U       "pwdn   / gpio[34] (pin 39)" 
    ,Signal "ov7670_reset"      OUT   U       "reset  / gpio[35] (pin 40)" 
    ,Signal "o_Config_finished" OUT   U       "" 
    ]
