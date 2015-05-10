{-# LANGUAGE RecordWildCards #-}
module PH.API.Test.Export.Pandoc
  (
    build
  , export
  ) where

import           Common
import qualified PH.DB                 as DB
import           PH.Types

import           Data.ByteString.Lazy (ByteString)
import qualified Data.TCache.ID          as ID
import qualified Data.Text               as Text
import qualified Text.Pandoc             as P
import qualified Text.Pandoc.Builder     as P


export:: P.Pandoc -> IO (Either ByteString ByteString)
export = return . Right . utf8ByteString . P.writeNative P.def

build :: ExportMode -> Test -> IO P.Pandoc
build mode test = do
  qs <- DB.run $ mapM ID.deref (questions test)
  return $ renderTest mode (name test) qs

renderTest :: ExportMode -> Text -> [Question] -> P.Pandoc
renderTest mode name qs = P.setTitle (textP name) . P.doc $
  P.orderedList (map renderQuestion qs)
 where
  renderQuestion q = P.para (textP $ question q) <> case answer q of
    Open a                -> case mode of
      OnlyQuestions -> mempty
      WithAnswers   -> P.para $ textP "Antwoord: " <> P.strong (textP a)
    MultipleChoice { .. } -> mconcat $ map renderChoice answers where
      answers = ((True,correct) : map ((,) False) incorrect) `orderBy` order
      renderChoice (corr,t) = P.para $ case mode of
        OnlyQuestions -> textP "☐ "                         <> textP t
        WithAnswers   -> textP (if corr then "☑ " else "☐ ") <> textP t

orderBy :: [a] -> [Int] -> [a]
orderBy = map . (!!)

textP :: Text -> P.Inlines
textP = P.str . Text.unpack
