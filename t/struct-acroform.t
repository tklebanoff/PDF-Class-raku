use v6;
use PDF;
use PDF::Grammar::Test :$is-json-equiv;
use Test;
my $doc;

lives-ok {$doc = PDF.open("t/pdf/samples/OoPdfFormExample.pdf")}, "open form example  lives";
warn "getting Root...";
my $cat = $doc.Root;
warn "got Root...";
isa-ok $cat, ::('PDF::Struct::Catalog'), 'document root';

warn "getting acroform...";
my $acroform = $cat.AcroForm;
warn "got acroform...";
does-ok $cat.AcroForm, ::('PDF::Struct::AcroForm');

lives-ok {$cat.OpenAction}, '$cat.OpenAction';
does-ok $cat.OpenAction, ::('PDF::Struct::Action::Destination');

my @fields = $acroform.fields;
isa-ok @fields, Array, '.Fields';
is +@fields, 17, 'fields count';
does-ok @fields[0], ::('PDF::Struct::Field'), '.Fields';
isa-ok @fields[0], ::('PDF::Struct::Annot::Widget'), 'field type';

is @fields[0].Type, 'Annot', 'Type';
is @fields[0].Subtype, 'Widget', 'Subtype';
is @fields[0].F, 4, '.F';
is @fields[0].FT, 'Tx', '.FT';
isa-ok @fields[0]<P>, ::('PDF::Struct::Page'), '<P>';
my $page = @fields[0].P;
isa-ok $page, ::('PDF::Struct::Page'), '.P';
is-json-equiv @fields[0].Rect, [165.7, 453.7, 315.7, 467.9], '.Rect';
is @fields[0].T, 'Given Name Text Box', '.T';
is @fields[0].TU, 'First name', '.TU';
is @fields[0].V, '', '.V';
is @fields[0].DV, '', '.DV';
is @fields[0].MaxLen, 40, '.MaxLen';
isa-ok @fields[0].DR, Hash, '.DR';
ok @fields[0].DR<Font>:exists, '.DR<Font>';
is @fields[0].DA, '0 0 0 rg /F3 11 Tf', '.DA';
my $appearance = @fields[0].AP;
isa-ok $appearance, Hash, '.AP';
does-ok $appearance, ::('PDF::Struct::Appearance'), '.AP';
isa-ok $appearance.N, ::('PDF::Struct::XObject::Form'), '.AP.N';
ok $page.Annots[0] === @fields[0], 'first field via page-1 annots';

my $country = @fields[5];
does-ok $country, ::('PDF::Struct::Field::Choice'), 'choice field';
is +$country.Opt, 28, 'choice options';
is $country.Opt[0], 'Austria', 'choice first option';

my $languages = @fields[8];
does-ok $languages, ::('PDF::Struct::Field::Button'), 'Button field';
$appearance = $languages.AP;
does-ok $appearance, ::('PDF::Struct::Appearance'), '.AP';
isa-ok $appearance.N.Yes, ::('PDF::Struct::XObject::Form'), '.AP.N.Yes';

my %fields = $acroform.fields-hash;
is +%fields, 25, 'fields hash key count';
ok %fields{'Given Name Text Box'} == @fields[0], 'field hash lookup by .T';
ok %fields{'First name'} == @fields[0], 'field hash lookup by .TU';

# check meta-data
use PDF::Reader;
isa-ok $cat.reader, PDF::Reader, '$cat.reader';
isa-ok $cat.AcroForm.reader, PDF::Reader, '$cat.AcroForm.reader';
isa-ok @fields[0].reader, PDF::Reader, '$cat.AcroForm.Fields[0].reader';
is @fields[0].obj-num, 5, '.obj-num';
is @fields[0].gen-num, 0, '.gen-num';
isa-ok @fields[0].P.reader, PDF::Reader, '$cat.AcroForm.Fields[0].P.reader';

done-testing;
