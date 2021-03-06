{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE UndecidableInstances #-}
module PH.Types.JSON where

import           Common
import qualified Data.TCache      as T
import qualified Data.TCache.ID   as ID
import qualified Data.Text        as Text
import           Data.Typeable    (typeRep,Proxy(Proxy))
import           PH.Types
import           PH.Types.InOut
import           PH.Types.Storage () -- Needed for instance Indexable (WithID a).

import           Data.Aeson.Types (typeMismatch,Value(String))
import qualified Text.Pandoc      as Pandoc


instance ToJSON Question where
  toJSON = gtoJson
instance FromJSON Question where
  parseJSON = gparseJson
instance JSONSchema Question where
  schema = gSchema

instance ToJSON Title where
  toJSON = gtoJson
instance FromJSON Title where
  parseJSON = gparseJson
instance JSONSchema Title where
  schema = gSchema

instance ToJSON Answer where
  toJSON = gtoJson
instance FromJSON Answer where
  parseJSON = gparseJson
instance JSONSchema Answer where
  schema = gSchema

instance ToJSON Test where
  toJSON = gtoJson
instance FromJSON Test where
  parseJSON = gparseJson
instance JSONSchema Test where
  schema = gSchema

instance ToJSON TestElement where
  toJSON = gtoJson
instance FromJSON TestElement where
  parseJSON = gparseJson
instance JSONSchema TestElement where
  schema = gSchema

instance ToJSON Dates where
  toJSON = gtoJson
instance FromJSON Dates where
  parseJSON = gparseJson
instance JSONSchema Dates where
  schema = gSchema


instance ToJSON RichText where
  toJSON (Pandoc p) = toJSON . Text.pack $ Pandoc.writeHtmlString Pandoc.def (Pandoc.Pandoc Pandoc.nullMeta p)
instance FromJSON RichText where
  parseJSON s = either (fail . show) r . Pandoc.readHtml Pandoc.def . Text.unpack =<< parseJSON s where
    r (Pandoc.Pandoc _ p) = return $ Pandoc p
instance JSONSchema RichText where
  schema _ = schema (Proxy :: Proxy Text)

instance (FromJSON a) => FromJSON (ID.ID a) where
  parseJSON = (ID.ID <$>) . parseJSON
instance (ToJSON a) => ToJSON (ID.ID a) where
  toJSON (ID.ID t) = toJSON t
instance (JSONSchema a) => JSONSchema (ID.ID a) where
  schema _ = schema (Proxy :: Proxy Text)

instance (Typeable a,FromJSON a) => FromJSON (ID.WithID a) where
  parseJSON = gparseJson
instance (Typeable a,ToJSON a) => ToJSON (ID.WithID a) where
  toJSON = gtoJson
instance (JSONSchema a) => JSONSchema (ID.WithID a) where
  schema = gSchema

instance (Typeable a,FromJSON a) => FromJSON (Dated a) where
  parseJSON = gparseJson
instance (Typeable a,ToJSON a) => ToJSON (Dated a) where
  toJSON = gtoJson
instance (JSONSchema a) => JSONSchema (Dated a) where
  schema = gSchema

instance (Typeable a,FromJSON a) => FromJSON (Labelled a) where
  parseJSON = gparseJson
instance (Typeable a,ToJSON a) => ToJSON (Labelled a) where
  toJSON = gtoJson
instance (JSONSchema a) => JSONSchema (Labelled a) where
  schema = gSchema

instance (Typeable a,ToJSON a,ToJSON (ID.ID (Decorated a))) => ToJSON (DecoratedOut a) where
  toJSON = gtoJson
instance (JSONSchema a,JSONSchema (ID.ID (Decorated a))) => JSONSchema (DecoratedOut a) where
  schema = gSchema

instance (Typeable a,FromJSON a) => FromJSON (LabelledIn a) where
  parseJSON = gparseJson
instance (JSONSchema a) => JSONSchema (LabelledIn a) where
  schema = gSchema
