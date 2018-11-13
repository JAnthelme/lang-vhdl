{-# LANGUAGE OverloadedStrings #-}
module VHDLpSyntax (
    Entity(..), Signal(..), SMod(..), VTyp(..), cmm, isCmm
  , toVHDLTy
) where

import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy as T (append)
-- import Data.Char (isSpace)
-- http://insights.sigasi.com/tech/vhdl2008.ebnf.html#name

-- https://surf-vhdl.com/vhdl-syntax-web-course-surf-vhdl/vhdl-entity/
-- entity_declaration ::= entity identifier is
--     entity_header
--     entity_declarative_part 
--   [ begin 
--        entity_statement_part ] 
--     end [ entity_simple_name ] ;
-- 
--  entity_header ::=
--    [ formal_generic_clause ] 
--    [ formal_port_clause ]
-- 
--  generic_clause ::= generic ( generic_list ) ; 
--  generic_list ::= generic_interface_list
--  port_clause ::= port ( port_list ) ;
--  port_list ::= port_interface_list 
--  entity_declarative_part ::= { entity_declarative_item }
-- 

data Entity = Entity {
    ent_name :: Text
  , ent_port :: [Signal]
  } 
  deriving (Eq, Show)

data Signal = Signal {
    sig_name  :: Text
  , sig_mode  :: SMod
  , sig_type  :: VTyp -- Text
  , sig_desc  :: Text
  } 
  deriving (Eq, Show)

data SMod = IN | OUT | INOUT | BUFFER | LINKAGE deriving (Eq, Show)

-- data SL   = U | X | L0 | L1 | Z | W | L | H | DC deriving (Eq, Show)
-- data SLV  = SLV Text Text deriving (Eq, Show)
-- data VINT = I Int | R Text Text deriving (Eq, Show)

data VTyp  = U | X | L0 | L1 | Z | W | L | H | DC
           | SLV Text Text
           | I | R Text Text 
  deriving (Eq, Show)

-- misc
cmm :: Text -> Signal
cmm = Signal "" IN U

isCmm :: Signal -> Bool
isCmm s = (sig_name s) == " "
 
toVHDLTy :: VTyp -> Text
toVHDLTy (SLV efrom eto)  = "std_logic_vector" `T.append` "(" `T.append` efrom `T.append` " downto " `T.append` eto
toVHDLTy (R efrom eto)    = "integer range" `T.append` efrom `T.append` " downto " `T.append` eto
toVHDLTy I                = "integer" 
toVHDLTy _                = "std_logic" 
