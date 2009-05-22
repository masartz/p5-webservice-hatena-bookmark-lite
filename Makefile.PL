use inc::Module::Install;
name 'WebService-Hatena-Bookmark-Lite';
all_from 'lib/WebService/Hatena/Bookmark/Lite.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
