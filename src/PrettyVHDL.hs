{-# LANGUAGE OverloadedStrings #-}
module PrettyVHDL (
    ptyEntity, ptyComponent, tabulate
) where

import qualified Data.Text.Lazy as T hiding (Text)
import Data.Text.Lazy (Text)
import Data.Text.Prettyprint.Doc.Symbols.Ascii (colon, semi, space)

import VHDLpSyntax

import Data.Text.Prettyprint.Doc



-- | generic block 
-- first line + middle signals + last line
ptyPortContainer 
  :: (Text, Text) -- ^ first line enclosing
  -> (Text, Text) -- ^ last line enclosing
  -> Bool         -- need EoL descriptions / comments
  -> Int          -- fill type space #
  -> (Text, [Signal]) -- ^ container's name and signals
  -> Doc ann

ptyPortContainer (fstL, fstR) (lstL, lstR) flagDesc fsType (nm, ps) = parag 2 dfst dlast $ ptyEntPort  flagDesc fsType ps -- showPorts p
  where dnm   = toPretty nm
        dfst  = enclose (pretty fstL <> space) (space <> pretty fstR) dnm
        dlast = enclose (pretty lstL <> space) (space <> pretty lstR) dnm

-- | VHDL Entity declaration
ptyEntity
  :: Bool         -- need EoL descriptions / comments
  -> Int          -- fill type space #
  -> Entity       -- entity
  -> Doc ann
ptyEntity flagDesc fsType Entity {ent_name = nm, ent_port = ps} = 
  ptyPortContainer ("entity","is") ("end", ";") flagDesc fsType (nm, ps)

-- | VHDL Component declaration
ptyComponent
  :: Bool         -- need EoL descriptions / comments
  -> Int          -- fill type space #
  -> Entity       -- entity
  -> Doc ann
ptyComponent flagDesc fsType Entity {ent_name = nm, ent_port = ps} = 
  ptyPortContainer ("component","") ("end component", ";") flagDesc fsType (nm, ps)

-- | VHDL Component instantiation
ptyComponentI
  ::  Bool         -- need EoL descriptions / comments
  -> Entity        -- entity
  -> Doc ann
ptyComponentI flagDesc Entity {ent_name = nm, ent_port = ps} = undefined


ptyEntPort :: Bool -> Int -> [Signal] -> Doc ann
ptyEntPort flagDesc fsType ps = parag 2 dfst dlst $ vsep $ ptySigList2 flagDesc ps
  where dfst = pretty ("port(" :: Text) 
        dlst = pretty (");" :: Text) 

-- | 
ptySigList2 
  :: Bool 
  -> [Signal] 
  -> [Doc ann]
ptySigList2 _  []       = []
ptySigList2 flagDesc ps = tabulate xss []
   where xss = [signms, take (length signms) $ repeat ":" , appendButLast ";" $ map (toVHDLTy . sig_type) ps ]
               ++ if flagDesc then [prepend "-- " $  map sig_desc ps] else []
         signms = map sig_name ps


-- misc docs
toPretty :: Text -> Doc ann
toPretty = pretty

-- | tabulate docs
-- ... with overflow
tabulate
   :: [[Text]]
   -> [Int]
   -> [Doc ann]
tabulate xss spcs = foldl1 (zipWith (<+>)) tabs 
  where maxs = map (fromIntegral . (maximum . (map T.length))) xss :: [Int]
        tabs = zipWith fll maxs xss
        fll i xs = map ((fill i) . pretty) xs  -- here try \ i x -> if x  == "" then emptyDoc  else fill i $ pretty
        

-- | append text to all but last text in a list
-- similar to punctuate for docs
appendButLast
  :: Text       -- punctuation
  -> [Text]     -- texts
  -> [Text]
appendButLast _ [] = []
appendButLast p xs = map (flip T.append p) (init xs) ++ [last xs] 

-- | add prefix  
prepend 
  :: Text       -- prefix
  -> [Text]     -- texts
  -> [Text]
prepend t = map (\tr -> if T.null tr then "" else T.append t tr)


parag :: Int -> Doc ann -> Doc ann -> Doc ann -> Doc ann
parag inest dfst dlast dmid = vsep [nest inest (vsep [dfst, dmid]), dlast]







