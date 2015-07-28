use v6;
use PDF::DOM::Type::Font;

class PDF::DOM::Type::Font::Type1
    is PDF::DOM::Type::Font {

    use PDF::Object::Tie;
    use PDF::Object::Name;
    use PDF::Object::Stream;

    # see [PDF 1.7 TABLE 5.8 Entries in a Type 1 font dictionary]
    has PDF::Object::Name $!Name is entry;                 #| (Required in PDF 1.0; optional otherwise) The name by which this font is referenced in the Font subdictionary of the current resource dictionary.
                                                           #| Note: This entry is obsolescent and its use is no longer recommended.
    has PDF::Object::Name $!BaseFont is entry(:required);  #| (Required) The PostScript name of the font. For Type 1 fonts, this is usually the value of the FontName entry in the font program

    has Int $!FirstChar is entry;                          #| (Required except for the standard 14 fonts) The first character code defined in the font’s Widths array

    has Int $!LastChar is entry;                           #| (Required except for the standard 14 fonts) The last character code defined in the font’s Widths array

    has Array $!Widths is entry;                           #| (Required except for the standard 14 fonts; indirect reference preferred) An array of (LastChar − FirstChar + 1) widths, each element being the glyph width for the character code that equals FirstChar plus the array index.

    has Hash $!FontDescriptor is entry(:indirect);         #| (Required except for the standard 14 fonts; must be an indirect reference) A font descriptor describing the font’s metrics other than its glyph widths

## causes precomp issues
##    use PDF::DOM::Type::Encoding;
##    subset NameOrEncoding of Any where PDF::Object::Name | PDF::DOM::Type::Encoding;
    has $!Encoding is entry;                #| (Optional) A specification of the font’s character encoding if different from its built-in encoding. The value of Encoding is either the name of a predefined encoding (MacRomanEncoding, MacExpertEncoding, or WinAnsiEncoding, as described in Appendix D) or an encoding dictionary that specifies differences from the font’s built-in encoding or from a specified predefined encoding

    has PDF::Object::Stream $!ToUnicode is entry;          #| (Optional; PDF 1.2) A stream containing a CMap file that maps character codes to Unicode values

}
