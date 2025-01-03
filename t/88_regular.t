use strict;
use warnings;

use Graph::Directed;
use Graph::Undirected;

use Test::More;

my $g0 = Graph::Directed->new;
$g0->add_cycle('A', 'B', 'C');
ok($g0->is_regular);

my $g1 = Graph::Undirected->new;
$g1->add_cycle('A', 'B', 'C');
ok($g1->is_regular);

my $g2 = Graph::Directed->new;
$g2->add_path('A', 'B', 'C');
$g2->add_edge('A', 'C');
ok(!$g2->is_regular);

done_testing;
