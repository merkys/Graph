use strict;
use warnings;

use Graph::Undirected;

use Test::More;

my $g0 = Graph::Undirected->new;
$g0->add_cycle('A'..'C');
ok(!$g0->is_biregular);

my $g1 = Graph::Undirected->new;
$g1->add_cycle('A'..'D');
ok($g1->is_biregular);

my $g2 = Graph::Undirected->new;
for my $v1 ('A'..'D') {
    for my $v2 ('E'..'L') {
        $g2->add_edge($v1, $v2);
    }
}
ok($g2->is_biregular);

$g2->delete_edge('A', 'E');
ok(!$g2->is_biregular);

done_testing;
