module VirtFS::Ext3
  # ////////////////////////////////////////////////////////////////////////////
  # // Data definitions.

  HASH_TREE_ENTRY_FIRST = [
    'S',  'max_descriptors',  # Maximum number of node descriptors.
    'S',  'cur_descriptors',  # Current number of node descriptors.
    'L',  'first_node',       # Block address of first node.
  ]

  HASH_TREE_ENTRY_NEXT = [
    'L',  'min_hash',   # Minimum hash value in node.
    'L',  'next_node',  # Block address of next node.
  ]

  class HashTreeEntry
    attr_reader :first, :max_descriptors, :cur_descriptors, :node, :min_hash

    def initialize(buf, first = false)
      raise "nil buffer" if buf.nil?

      @first = first

      if first
        @hte             = HASH_TREE_ENTRY_FIRST.decode(buf)
        @max_descriptors = @hte['max_descriptors']
        @cur_descriptors = @hte['cur_descriptors']
        @node            = @hte['first_node']
      else
        @hte             = HASH_TREE_ENTRY_NEXT.decode(buf)
        @min_hash        = @hte['min_hash']
        @node            = @hte['next_node']
      end
    end
  end # class HashTreeEntry
end # module VirtFS::Ext3
