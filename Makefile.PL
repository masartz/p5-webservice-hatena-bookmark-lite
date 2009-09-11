use inc::Module::Install;
name 'WebService-Hatena-Bookmark-Lite';
all_from 'lib/WebService/Hatena/Bookmark/Lite.pm';

requires (
    'XML::Atom'             => '0.35',
    'Class::Accessor::Fast' => '0.33',
    'Config::Pit'           => '0.03',
);

tests 't/*.t';
#author_tests 'xt';

build_requires 'Test::More';
auto_include;
WriteAll;
