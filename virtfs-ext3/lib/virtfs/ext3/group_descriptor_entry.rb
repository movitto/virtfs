require 'binary_struct'

module VirtFS::Ext3
  # ////////////////////////////////////////////////////////////////////////////
  # // Data definitions.

  GDE = BinaryStruct.new([
    'L',  'blk_bmp',        # Starting block address of block bitmap.
    'L',  'inode_bmp',      # Starting block address of inode bitmap.
    'L',  'inode_table',    # Starting block address of inode table.
    'S',  'unalloc_blks',   # Number of unallocated blocks in group.
    'S',  'unalloc_inodes', # Number of unallocated inodes in group.
    'S',  'num_dirs',       # Number of directories in group.
    'a14',  'unused1',      # Unused.
  ])
  SIZEOF_GDE = GDE.size

  # ////////////////////////////////////////////////////////////////////////////
  # // Class.

  class GroupDescriptorEntry
    attr_accessor :block_alloc_bitmap, :inode_alloc_bitmap

    def initialize(buf)
      raise "Ext3::GroupDescriptorEntry.initialize: Nil buffer" if buf.nil?

      # Decode the group descriptor table entry.
      @gde = GDE.decode(buf)
    end

    # ////////////////////////////////////////////////////////////////////////////
    # // Class helpers & accessors.

    def block_bmp
      @gde['blk_bmp']
    end

    def inode_bmp
      @gde['inode_bmp']
    end

    def inode_table
      @gde['inode_table']
    end

    def num_dirs
      @gde['num_dirs']
    end
  end # class GroupDescriptorEntry
end # module VirtFS::Ext3
