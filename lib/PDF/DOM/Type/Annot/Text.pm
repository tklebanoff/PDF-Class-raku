use v6;

use PDF::DOM::Type::Annot;

class PDF::DOM::Type::Annot::Text
    is PDF::DOM::Type::Annot {

    use PDF::Object::Tie;

    # Seet [PDF 1.7 TABLE 8.23 Additional entries specific to a text annotation]
    has Bool $!Open is entry;       #| (Optional) A flag specifying whether the annotation should initially be displayed open. Default value: false (closed).
    has Str $!Name is entry;        #| (Optional) The name of an icon to be used in displaying the annotation. Viewer applications should provide predefined icon appearances for at least the following standard names:
                                    #|  - Comment, Key, Note, Help, NewParagraph, Paragraph, Insert
                                    #| Additional names may be supported as well. Default value: Note.
    has Str $!State is entry;       #| (Optional; PDF 1.5) The state to which the original annotation should be set; see “Annotation States,” above.
                                    #| Default: “Unmarked” if StateModel is “Marked”; “None” if StateModel is “Review
    has Str $!StateModel is entry;  #| (Required if State is present, otherwise optional; PDF 1.5) The state model corresponding to State; see “Annotation States,” above

}
