module CH2 where
{-# LANGUAGE CPP, ForeignFunctionInterface #-}
{-# LANGUAGE UnboxedTuples #-}
{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnliftedFFITypes #-}

#define PCRE2_CODE_UNIT_WIDTH 16

#include <pcre.h>
#include <pcre2.h>

module Text.Regex.PCRE2.Demo.Base (
  PCREOption,
  PCRE,
  PCRE2_Code,
  PCRE2_Compile_Context,
  caseless,
  dollar_endonly,
  dotall,
  c_pcre_compile,
  c_pcre2_compile,
) where

import Data.Bits        ((.|.))
import Foreign.C.Types  (CInt(CInt), CSize(CSize))
import Foreign.C.String (CString)
import Foreign.Ptr      (Ptr)
import Data.Word        (Word8)
import GHC.Base         (Word32##)

newtype PCREOption = PCREOption CInt

instance Semigroup PCREOption where
  (PCREOption a) <> (PCREOption b) = PCREOption (a .|. b)

instance Monoid PCREOption where
  mempty = PCREOption 0

#{enum PCREOption, PCREOption
, caseless       = PCRE_CASELESS
, dollar_endonly = PCRE_DOLLAR_ENDONLY
, dotall         = PCRE_DOTALL
}

data PCRE

foreign import ccall unsafe "pcre.h pcre_compile"
  c_pcre_compile :: CString
                 -> PCREOption
                 -> Ptr CString
                 -> Ptr CInt
                 -> Ptr Word8
                 -> IO (Ptr PCRE)

data PCRE2_Code
data PCRE2_Compile_Context

-- pcre2_code *
-- pcre2_compile(PCRE2_SPTR pattern,
--              PCRE2_SIZE length,,
--              uint32_t options,,
--              int *errorcode,
--              PCRE2_SIZE *erroroffset,
--              pcre2_compile_context *ccontext); 
foreign import ccall unsafe "pcre2.h pcre2_compile"
  c_pcre2_compile :: CString
                  -> CSize
                  -> Word32##
                  -> Ptr CInt
                  -> Ptr CSize
                  -> Ptr PCRE2_Compile_Context
                  -> Ptr PCRE2_Code
