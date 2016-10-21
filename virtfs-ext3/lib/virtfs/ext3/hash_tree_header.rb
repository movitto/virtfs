module VirtFS::Ext3
  # ////////////////////////////////////////////////////////////////////////////
  # // Data definitions.

  HASH_TREE_HEADER = [
    'L',  'unused1',    # Unused.
    'C',  'hash_ver',   # Hash version.
    'C',  'length',     # Length of this structure.
    'C',  'leaf_level', # Levels of leaves.
    'C',  'unused2',    # Unused.
  ]

  class HashTreeHeader
    attr_reader :hash_version, :length, :leaf_level

    def initialize(buf)
      raise "nil buffer" if buf.nil?
      @hth = HASH_TREE_HEADER.decode(buf)

      @hash_version = @hth['hash_ver']
      @length       = @hth['length']
      @leaf_level   = @hth['leaf_level']
    end
  end # class HashTreeHeader
end # module VirtFS::Ext3
