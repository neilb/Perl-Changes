package Perl::FeatureList;

use parent 'Exporter';
use strict;
use warnings;
use List::Util qw/ max /;
use Clone::PP  qw/ clone /;
use Ref::Util  qw/ is_arrayref /;

our @EXPORT_OK = qw/
                    features_in_your_perl
                    features_in_later_perls
                    get_feature
                   /;

my @features = (

    {
        name    => 'say',
        version => '5.010000',
        short   => 'just like print, but adds a newline',
        type    => 'feature',
    },

    {
        name    => 'defined-or',
        version => '5.010000',
        short   => '// is like || but on definedness rather than truthiness',
        type    => 'built-in',
    },

    {
        name    => 'state',
        version => '5.010000',
        short   => 'lexically scoped variables with persistent values',
        type    => 'feature',
    },

    {
        name    => 'switch',
        version => '5.010001',
        short   => 'perlish switch statement',
        type    => 'experimental',
    },

    {
        name    => 'unicode_strings',
        version => '5.012000',
        short   => 'tells compiler to use Unicode rules for all string ops',
        type    => 'feature',
    },

    {
        name    => 'signatures',
        version => '5.020000',
        short   => 'unpacking of subroutine arguments into lexical variables',
        type    => 'experimental',
    },

    {
        name    => 'isa',
        version => '5.032000',
        short   => 'infix "isa" operator to test if $object isa $class',
        type    => 'feature',
    },

    {
        name    => 'indirect',
        version => '5.032000',
        short   => 'pragma to disable indirect method calling syntax',
        type    => 'feature',
    },

    {
        name    => 'current_sub',
        version => '5.016000',
        short   => 'enables __SUB__ token that refers to current subroutine',
        type    => 'feature',
    },

    {
        name    => 'array_base',
        version => '5.016000',
        short   => 'controls whether the legacy $[ variable is available',
        type    => 'feature',
    },

    {
        name    => 'unicode_eval',
        version => '5.016000',
        short   => 'makes string eval work more consistently with Unicode',
        type    => 'feature',
    },

    {
        name    => 'evalbytes',
        version => '5.016000',
        short   => 'adds an evalbytes keyword that operates on a byte stream',
        type    => 'feature',
    },

    {
        name    => 'lexical_subs',
        version => '5.018000',
        short   => 'controls whether the legacy $[ variable is available',
        type    => [
                       { version => '5.018000', type => 'experimental' },
                       { version => '5.026000', type => 'feature' },
                   ],
    },

    {
        name    => 'fc',
        version => '5.016000',
        short   => 'enables fc(), which implements Unicode casefolding',
        type    => 'feature',
    },

    {
        name    => 'postderef',
        version => '5.020000',
        short   => 'enables postfix dereference syntax',
        type    => [
                       { version => '5.020000', type => 'experimental' },
                       { version => '5.024000', type => 'feature' },
                   ],
    },

    {
        name    => 'postderef_qq',
        version => '5.020000',
        short   => 'enables postderef in double-quotish interpolations',
        type    => [
                       { version => '5.020000', type => 'experimental' },
                       { version => '5.024000', type => 'feature' },
                   ],
    },

    {
        name    => 'refaliasing',
        version => '5.022000',
        short   => 'enables aliasing via assignment to references',
        type    => 'experimental',
    },

    {
        name    => 'bitwise',
        version => '5.022000',
        short   => 'introduces bitwise string operators',
        type    => 'experimental',
    },

    {
        name    => 'declared_refs',
        version => '5.026000',
        short   => 'allows a reference to a variable to be declared',
        type    => 'experimental',
    },

    {
        name    => 'indented_heredoc',
        version => '5.026000',
        short   => 'lets you indent heredoc, including delimiter',
        type    => 'built-in',
    },

);

sub features_in_your_perl
{
    my $perl_version = shift;

    return map { _select_type($_, $perl_version) }
           grep { $_->{version} le $perl_version }
           @features;
}

sub features_in_later_perls
{
    my $perl_version = shift;

    return map { _select_type($_, $perl_version) }
           grep { $_->{version} gt $perl_version }
           @features;
}

sub _select_type
{
    my ($feature, $version) = @_;
    $feature = clone($feature);

    if (is_arrayref($feature->{type})) {
        my $type;
        foreach my $subtype (@{ $feature->{type} }) {
            if (!defined($type) || $subtype->{version} lt $version) {
                $type = $subtype;
            }
        }
        $feature->{type} = $type->{type};
    }

    return $feature;

}


sub get_feature
{
    my $name = shift;
    my ($feature) =  grep { $_->{name} eq $name } @features;
    return $feature;
}

sub add_help_text_from_data
{
    my $topic;
    my $feature;
    local $_;

    while (<DATA>) {
        if (/^(\S+)/) {
            $topic = $1;
            ($feature) = grep { $_->{name} eq $topic } @features;
            $feature->{help} = '';
            next;
        }
        next unless defined $topic;
        $feature->{help} .= $_;
    }
}

add_help_text_from_data();

1;

=head1 NAME

Perl::FeatureList - provides access to a list of features introduced to Perl post 5.8

=cut

# We embed a small help text for each feature,
# as if you've got an old version of Perl you
# won't have the perldoc for some of the features.

__DATA__

say

    say FILEHANDLE LIST
    say FILEHANDLE
    say LIST
    say     Just like "print", but implicitly appends a newline. "say LIST"
            is simply an abbreviation for "{ local $\ = "\n"; print LIST }".
            To use FILEHANDLE without a LIST to print the contents of $_ to
            it, you must use a bareword filehandle like "FH", not an
            indirect one like $fh.

            "say" is available only if the "say" feature is enabled or if it
            is prefixed with "CORE::". The "say" feature is enabled
            automatically with a "use v5.10" (or higher) declaration in the
            current scope.

state

    state VARLIST
    state TYPE VARLIST
    state VARLIST : ATTRS
    state TYPE VARLIST : ATTRS
            "state" declares a lexically scoped variable, just like "my".
            However, those variables will never be reinitialized, contrary
            to lexical variables that are reinitialized each time their
            enclosing block is entered. See "Persistent Private Variables"
            in perlsub for details.

            If more than one variable is listed, the list must be placed in
            parentheses. With a parenthesised list, "undef" can be used as a
            dummy placeholder. However, since initialization of state
            variables in such lists is currently not possible this would
            serve no purpose.

            "state" is available only if the "state" feature is enabled or
            if it is prefixed with "CORE::". The "state" feature is enabled
            automatically with a "use v5.10" (or higher) declaration in the
            current scope.

unicode_strings

    "use feature 'unicode_strings'" tells the compiler to use Unicode rules
    in all string operations executed within its scope (unless they are also
    within the scope of either "use locale" or "use bytes"). The same
    applies to all regular expressions compiled within the scope, even if
    executed outside it. It does not change the internal representation of
    strings, but only how they are interpreted.

    "no feature 'unicode_strings'" tells the compiler to use the traditional
    Perl rules wherein the native character set rules is used unless it is
    clear to Perl that Unicode is desired. This can lead to some surprises
    when the behavior suddenly changes. (See "The "Unicode Bug"" in
    perlunicode for details.) For this reason, if you are potentially using
    Unicode in your program, the "use feature 'unicode_strings'" subpragma
    is strongly recommended.

    This feature is available starting with Perl 5.12; was almost fully
    implemented in Perl 5.14; and extended in Perl 5.16 to cover
    "quotemeta"; was extended further in Perl 5.26 to cover the range
    operator; and was extended again in Perl 5.28 to cover special-cased
    whitespace splitting.

unicode_eval

    "unicode_eval" changes the behavior of plain string "eval" to work more
    consistently, especially in the Unicode world. Certain (mis)behaviors
    couldn't be changed without breaking some things that had come to rely
    on them, so the feature can be enabled and disabled. Details are at
    "Under the "unicode_eval" feature" in perlfunc.

    The "unicode_eval" and "evalbytes" features are intended to replace the
    legacy string "eval" function, which behaves problematically in some
    instances. They are available starting with Perl 5.16, and are enabled
    by default by a "use 5.16" or higher declaration.

evalbytes

    "evalbytes" is like string "eval", but operating on a byte stream that
    is not UTF-8 encoded. Details are at "evalbytes EXPR" in perlfunc.
    Without a "use feature 'evalbytes'" nor a "use v5.16" (or higher)
    declaration in the current scope, you can still access it by instead
    writing "CORE::evalbytes".

    The "unicode_eval" and "evalbytes" features are intended to replace the
    legacy string "eval" function, which behaves problematically in some
    instances. They are available starting with Perl 5.16, and are enabled
    by default by a "use 5.16" or higher declaration.

current_sub

    This provides the "__SUB__" token that returns a reference to the
    current subroutine or "undef" outside of a subroutine.

    This feature is available starting with Perl 5.16.

array_base

    This feature supports the legacy $[ variable. See "$[" in perlvar and
    arybase. It is on by default but disabled under "use v5.16" (see
    "IMPLICIT LOADING", below).

    This feature is available under this name starting with Perl 5.16. In
    previous versions, it was simply on all the time, and this pragma knew
    nothing about it.

fc

    "use feature 'fc'" tells the compiler to enable the "fc" function, which
    implements Unicode casefolding.

    See "fc" in perlfunc for details.

    This feature is available from Perl 5.16 onwards.

lexical_subs

    In Perl versions prior to 5.26, this feature enabled declaration of
    subroutines via "my sub foo", "state sub foo" and "our sub foo" syntax.
    See "Lexical Subroutines" in perlsub for details.

    This feature is available from Perl 5.18 onwards. From Perl 5.18 to
    5.24, it was classed as experimental, and Perl emitted a warning for its
    usage, except when explicitly disabled:

      no warnings "experimental::lexical_subs";

    As of Perl 5.26, use of this feature no longer triggers a warning,
    though the "experimental::lexical_subs" warning category still exists
    (for compatibility with code that disables it). In addition, this syntax
    is not only no longer experimental, but it is enabled for all Perl code,
    regardless of what feature declarations are in scope.

refaliasing

    WARNING: This feature is still experimental and the implementation may
    change in future versions of Perl. For this reason, Perl will warn when
    you use the feature, unless you have explicitly disabled the warning:

        no warnings "experimental::refaliasing";

    This enables aliasing via assignment to references:

        \$a = \$b; # $a and $b now point to the same scalar
        \@a = \@b; #                     to the same array
        \%a = \%b;
        \&a = \&b;
        foreach \%hash (@array_of_hash_refs) {
            ...
        }

    See "Assigning to References" in perlref for details.

    This feature is available from Perl 5.22 onwards.

bitwise

    This makes the four standard bitwise operators ("& | ^ ~") treat their
    operands consistently as numbers, and introduces four new dotted
    operators ("&. |. ^. ~.") that treat their operands consistently as
    strings. The same applies to the assignment variants ("&= |= ^= &.= |.=
    ^.=").

    See "Bitwise String Operators" in perlop for details.

    This feature is available from Perl 5.22 onwards. Starting in Perl 5.28,
    "use v5.28" will enable the feature. Before 5.28, it was still
    experimental and would emit a warning in the "experimental::bitwise"
    category.

declared_refs

    WARNING: This feature is still experimental and the implementation may
    change in future versions of Perl. For this reason, Perl will warn when
    you use the feature, unless you have explicitly disabled the warning:

        no warnings "experimental::declared_refs";

    This allows a reference to a variable to be declared with "my", "state",
    our "our", or localized with "local". It is intended mainly for use in
    conjunction with the "refaliasing" feature. See "Declaring a Reference
    to a Variable" in perlref for examples.

    This feature is available from Perl 5.26 onwards.

indented_heredoc

    The here-doc modifier "~" allows you to indent your
    here-docs to make the code more readable:

        if ($some_var) {
          print <<~EOF;
            This is a here-doc
            EOF
        }

    This will print...

        This is a here-doc

    ...with no leading whitespace.

    The delimiter is used to determine the exact whitespace to
    remove from the beginning of each line. All lines must have
    at least the same starting whitespace (except lines only
    containing a newline) or perl will croak. Tabs and spaces
    can be mixed, but are matched exactly. One tab will not be
    equal to 8 spaces!

    Additional beginning whitespace (beyond what preceded the
    delimiter) will be preserved.

switch

    A perlish switch statement.

        use v5.10.1;
        given ($var) {
            when (/^abc/) { $abc = 1 }
            when (/^def/) { $def = 1 }
            when (/^xyz/) { $xyz = 1 }
            default       { $nothing = 1 }
        }

    As of 5.14, you can also write that was:

        use v5.14;
        given ($var) {
            $abc = 1 when /^abc/;
            $def = 1 when /^def/;
            $xyz = 1 when /^xyz/;
            default { $nothing = 1 }
        }

   This is experimental.

signatures

    This experimental feature enables subroutine signatures,
    a way to specify the parameters for a function.

    The traditional Perl way has been to unroll the @_ array
    into lexical variables:

        sub foo {
            my ($left, $right) = @_;
            return $left + $right;
        }

    Now you can write:

        use experimental 'signatures';
        sub foo ($left, $right) {
            return $left + $right;
        }

    See the section "Signatures" in perlsub for full details.

    This feature was introduced in 5.20, and is still experimental
    as of 5.32.

