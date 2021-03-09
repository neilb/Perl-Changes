requires "Clone::PP" => "0";
requires "Exporter" => "0";
requires "Getopt::Long" => "0";
requires "List::Util" => "0";
requires "Ref::Util" => "0";
requires "parent" => "0";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Test::More" => "0.88";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};
