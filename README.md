
# Perl-Changes

**Note**: this is currently a proof of concept -- I just hacked up the idea,
following a discussion on how aware people are of the "new" features in their Perl.
It's very much a work in progress, with all aspects likely to change.

This distribution contains the module `Perl::Changes` and a script `perl-changes`.
Previously they were called `Perl::FeatureList` and `feature-list`,
but Perl already defines "features" and they're a subset of all changes.

I wondered if there was a single place where I could find all the recent features,
and whether they required a feature guard, or are experimental.
I couldn't find one,
so I wondered if something analogous to [`Module::CoreList`](https://metacpan.org/pod/Module::CoreList)
(which provides a list of the core modules that are shipped with Perl)
might be useful.
`Perl::Changes` provides a list of the language features
that have been introduced post-5.8.

When you run the script, it gets a list of the main features that have been introduced up to
and including the version that you're running, and presents them in a table:

    % perl-changes

    ---- changes available in perl 5.016003 ----
    F  say               just like print, but adds a newline
       defined-or        // is like || but on definedness rather than truthiness
    F  state             lexically scoped variables with persistent values
    X  switch            perlish switch statement
    F  unicode_strings   tells compiler to use Unicode rules for all string ops
    F  current_sub       enables __SUB__ token that refers to current subroutine
    F  array_base        controls whether the legacy $[ variable is available
    F  unicode_eval      makes string eval work more consistently with Unicode
    F  evalbytes         adds an evalbytes keyword that operates on a byte stream
    F  fc                enables fc(), which implements Unicode casefolding

If the first column is a **F**, then you must `use feature`.
If it's an **X**, the the feature is experimental,
and unless you suppress it, you'll get a warning when you use the feature.
If the first column is blank, then the feature is built in to your version of Perl.

You can get a brief summary of the feature:

    % perl-changes current_sub

        This provides the "__SUB__" token that returns a reference to the
        current subroutine or "undef" outside of a subroutine.

        This feature is available starting with Perl 5.16.

If you include the `--future` switch, then you'll also get a list of
features that have been introduced since your version of Perl was released:

    % perl-changes --future

    ---- new features available in perl 5.016003 ----
    F  say               just like print, but adds a newline
       defined-or        // is like || but on definedness rather than truthiness
    F  state             lexically scoped variables with persistent values
    X  switch            perlish switch statement
    F  unicode_strings   tells compiler to use Unicode rules for all string ops
    F  current_sub       enables __SUB__ token that refers to current subroutine
    F  array_base        controls whether the legacy $[ variable is available
    F  unicode_eval      makes string eval work more consistently with Unicode
    F  evalbytes         adds an evalbytes keyword that operates on a byte stream
    F  fc                enables fc(), which implements Unicode casefolding


    ---- features available in later versions of perl ----
    X  lexical_subs       controls whether the legacy $[ variable is available
    X  signatures         unpacking of subroutine arguments into lexical variables
    X  postderef          enables postfix dereference syntax
    X  postderef_qq       enables postderef in double-quotish interpolations
    X  refaliasing        enables aliasing via assignment to references
    X  bitwise            introduces bitwise string operators
    X  declared_refs      allows a reference to a variable to be declared
       indented_heredoc   lets you indent heredoc, including delimiter
    F  isa                infix "isa" operator to test if $object isa $class
    F  indirect           pragma to disable indirect method calling syntax

At the moment this mainly lists features and experiments;
I need to go through the perl deltas for all releases since 5.10.0
and add appropriate changes.

The **`-a`** (or **`--all`**) switch will display all changes, not just the minor ones.
The **`-w`** (or **`--wide`**) switch will include the version where the change was
introduced.

You can also give a Perl version on the command-line, to list all changes in that release:

    % perl-changes 5.10.0

    F  say             just like print, but adds a newline
       defined-or      // is like || but on definedness rather than truthiness
    F  state           lexically scoped variables with persistent values
       named-capture   ability to name capture parens in a regex
       UNITCHECK       code block run after enclosing unit has been compiled

The **`-a`** switch is implied when you give a version of Perl.
