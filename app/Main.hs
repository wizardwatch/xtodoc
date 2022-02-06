module Main where
import Text.Pandoc.App
import Text.Pandoc
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
--import qualified Data.ByteString.Lazy as BL
import System.IO
--import System.FilePath
--import Shelly
myOpts = Opt
    { optInputFiles		= inputFile
    , optOutputFile		= outputFile
    , optTabStop		= 4
    , optPreserveTabs		= False
    , optStandalone            = False
    , optFrom                  = Nothing
    , optTo                    = Nothing
    , optTableOfContents       = False
    , optShiftHeadingLevelBy   = 0
    , optTemplate              = Nothing
    , optVariables             = mempty
    , optMetadata              = mempty
    , optMetadataFiles         = []
    , optNumberSections        = False
    , optNumberOffset          = [0,0,0,0,0,0]
    , optSectionDivs           = False
    , optIncremental           = False
    , optSelfContained         = False
    , optHtmlQTags             = False
    , optHighlightStyle        = Just ( T.pack "pygments")
    , optSyntaxDefinitions     = []
    , optTopLevelDivision      = TopLevelDefault
    , optHTMLMathMethod        = PlainMath
    , optAbbreviations         = Nothing
    , optReferenceDoc          = Nothing
    , optEpubSubdirectory      = "EPUB"
    , optEpubMetadata          = Nothing
    , optEpubFonts             = []
    , optEpubChapterLevel      = 1
    , optEpubCoverImage        = Nothing
    , optTOCDepth              = 3
    , optDumpArgs              = False
    , optIgnoreArgs            = False
    , optVerbosity             = WARNING
    , optTrace                 = False
    , optLogFile               = Nothing
    , optFailIfWarnings        = False
    , optReferenceLinks        = False
    , optReferenceLocation     = EndOfDocument
    , optDpi                   = 96
    , optWrap                  = WrapAuto
    , optColumns               = 72
    , optFilters               = []
    , optEmailObfuscation      = NoObfuscation
    , optIdentifierPrefix      = T.pack "cool"
    , optStripEmptyParagraphs  = False
    , optIndentedCodeClasses   = []
    , optDataDir               = Nothing
    , optCiteMethod            = Citeproc
    , optListings              = False
    , optPdfEngine             = Nothing
    , optPdfEngineOpts         = []
    , optSlideLevel            = Nothing
    , optSetextHeaders         = False
    , optAscii                 = False
    , optDefaultImageExtension = T.pack "svg"
    , optExtractMedia          = Nothing
    , optTrackChanges          = AcceptChanges
    , optFileScope             = False
    , optTitlePrefix           = Nothing
    , optCss                   = []
    --, optIpynbOutput           = IpynbOutputBest
    , optIncludeBeforeBody     = []
    , optIncludeAfterBody      = []
    , optIncludeInHeader       = []
    , optResourcePath          = ["."]
    , optRequestHeaders        = []
    , optNoCheckCertificate    = False
    , optEol                   = Native
    , optStripComments         = False
    , optCSL                   = Nothing
    , optBibliography          = []
    , optCitationAbbreviations = Nothing }
    --, optSandbox               = False }
--inputFile :: [FilePath]
inputFile = Just [("./testFiles/test.md")]
--outputFile :: [FilePath]
outputFile = Just "./testFiles/test.html"

main :: IO ()
main = do
  convertWithOpts(myOpts)
