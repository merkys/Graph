package Graph::AdjacencyMap::Vertex;

# THIS IS INTERNAL IMPLEMENTATION ONLY, NOT TO BE USED DIRECTLY.
# THE INTERFACE IS HARD TO USE AND GOING TO STAY THAT WAY AND
# ALMOST GUARANTEED TO CHANGE OR GO AWAY IN FUTURE RELEASES.

use strict;
use warnings;

# $SIG{__DIE__ } = \&Graph::__carp_confess;
# $SIG{__WARN__} = \&Graph::__carp_confess;

use Graph::AdjacencyMap qw(:flags :fields);
use base 'Graph::AdjacencyMap';

sub stringify {
    require Graph::AdjacencyMap::Heavy;
    goto &Graph::AdjacencyMap::Heavy::stringify;
}

require overload; # for de-overloading

sub __strval {
  my ($k, $f) = @_;
  return $k unless ref $k && ($f & _REF);
  (($f & _STR) xor overload::Method($k, '""')) ? overload::StrVal($k) : $k;
}

sub __set_path {
    my $f = $_[0]->[ _f ];
    Graph::__carp_confess(sprintf "arguments %d expected %d for\n".$_[0]->stringify, @_ - 1, $_[0]->[ _arity ] + (($f & _MULTI) ? 1 : 0))
	if @_ - 1 != $_[0]->[ _arity ] + (($f & _MULTI) ? 1 : 0);
    [ $_[0]->[ _s ] ||= { } ], [ __strval($_[1], $f) ];
}

sub __set_path_node {
    my ($m, $p, $l, @args) = @_;
    my $f = $m->[ _f ];
    my $id = $_[-1] if ($f & _MULTI);
    my $arity = $m->[ _arity ];
    return $m->_inc_node( \$p->[-1]->{ $l }, $id ) if exists $p->[-1]->{ $l };
    my $i = $m->_new_node( \$p->[-1]->{ $l }, $id );
    die "undefined index" if !defined $i;
    $m->[ _i ][ $i ] = [ @args[0..$arity-1] ];
}

sub __has_path {
    my $f = $_[0]->[ _f ];
    Graph::__carp_confess(sprintf "arguments %d expected %d for\n".$_[0]->stringify, @_ - 1, $_[0]->[ _arity ])
	if @_ - 1 != $_[0]->[ _arity ];
    return unless defined(my $p = $_[0]->[ _s ]);
    return ([$p], [ __strval($_[1], $f) ]);
}

sub get_ids_by_paths {
    my ($m, $list) = @_;
    my @n;
    map !(@n = $m->__get_path_node(@$_)) ? () : ref $n[0] ? $n[0]->[ _ni ] : $n[0], @$list;
}

sub _get_path_count {
    my ($m) = @_;
    my $f = $m->[ _f ];
    return 0 unless my ($n) = &{ $m->can('__get_path_node') };
    return
	($f & _COUNT) ? $n->[ _nc ] :
	($f & _MULTI) ? scalar keys %{ $n->[ _nm ] } : 1;
}

sub rename_path {
    my ($m, $from, $to) = @_;
    return unless my ($n, $p, $k, $l) = $m->__get_path_node( $from );
    $m->[ _i ][ ref $n ? $n->[ _ni ] : $n ] = [ $to ];
    $p->[ -1 ]{ $to } = delete $p->[ -1 ]{ $l };
    return 1;
}

1;
