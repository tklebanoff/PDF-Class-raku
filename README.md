# perl6-PDF

This Perl 6 module is under construction as a general purpose PDF manipulation library.

### Page Layout & Viewer Preferences
```
    use PDF;
    my $pdf = PDF.new;

    my $doc = $pdf.Root;
    $doc.PageLayout = 'TwoColumnLeft';
    $doc.PageMode   = 'UseThumbs';

    my $viewer-prefs = $doc.ViewerPreferences //= {};
    $viewer-prefs.Duplex = 'DuplexFlipShortEdge';
    $viewer-prefs.NonFullScreenPageMode = 'UseOutlines';
    # ...etc, see PDF::Struct::ViewerPreferences
```

### AcroForm Fields

```
use PDF;
my $doc = PDF.open: "t/pdf/samples/OoPdfFormExample.pdf";
if my $acroform = $doc.Root.AcroForm {
    my @fields = $acroform.fields;
    # display field names and values
    for @fields -> $field {
        say "{$field.T // '??'}: {$field.V // ''}";
    }
}

```

See also:
- PDF::Struct::AcroForm
- PDF::Struct::Field
- PDF::FDF (under construction), which handles import/export from FDF files.

## Raw Data Access

In general, PDF provides accessors for safe access and update of PDF objects.

However you may choose to bypass these accessors and dereference hashes and arrays directly, giving raw untyped access to internal data structures:

This will also bypass type coercements, so you may need to be more explicit. In
the following example we cast the PageMode to a name, so it appears as a name
in the out put stream `/UseToes`, rather than a string `(UseToes)`.

```
    use PDF;
    my $pdf = PDF.new;

    my $doc = $pdf.Root;
    try {
        $doc.PageMode   = 'UseToes';
        CATCH { default { say "err, that didn't work: $_" } }
    }

    # same again, bypassing type checking
    $doc<PageMode>  = :name<UseToes>;
```

## Development Status

The PDF module is under construction and not yet functionally complete.

- master: Latest tested: Rakudo version 2015.12-199-g5ed58f6 built on MoarVM version 2015.12-29-g8079ca5
implementing Perl 6.c.

# Bugs and Restrictions
At this stage:
- Only core fonts are supported. There are a total of 14
font variations available. Please see the Font::AFM module for details.
- The classes in the PDF::Struct::* name-space represent a common subset of
the objects that can appear in a PDF. It is envisioned that the range of classes
with expand over time to cover most or all types described in the PDF specification.
- Many of the classes are skeletal at the moment and do little more that declare
fields for validation purposes; for example, the classes in the PDF::Struct::Font::* name-space.
