package Sitemap::DB::Reader::Base;

=head1 NAME

Sitemap::DB::Reader::Base

=head1 DESCRIPTION

Base class for xml database objects.

=cut

use Moose;

use Method::Signatures;

has 'Kids' => (
	is => 'ro',
	isa => 'ArrayRef|Undef',
);

has 'Text' => (
	is => 'ro',
	isa => 'Str|Undef',
);

=head1 METHODS

=head2 get_children_of_class

=cut

method get_children_of_class(:$class!) {
	[ grep { UNIVERSAL::isa($_,$class) } @{$self->Kids} ];
}

=head2 text

=cut

method text() {
	my ($item) = (grep { UNIVERSAL::isa($_,'Sitemap::DB::Reader::Characters') } @{$self->Kids});
	$item->Text;
}

=head2 get_first_child_of_class

=cut

method get_first_child_of_class(:$class!) {
	my ($item) = @{$self->get_children_of_class(class => $class)};
	$item;
}

1;
