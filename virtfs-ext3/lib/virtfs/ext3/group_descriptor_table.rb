require_relative 'group_descriptor_entry'
require_relative 'alloc_bitmap'
require 'binary_struct'

module VirtFS::Ext3
  class GroupDescriptorTable
    def initialize(sb)
      raise "Ext3::GroupDescriptorTable.initialize: Nil Superblock" if sb.nil?

      # Read all the group descriptor entries.
      @gdt = []
      sb.stream.seek(sb.block_to_address(sb.block_size == 1024 ? 2 : 1))
      buf = sb.stream.read(SIZEOF_GDE * sb.num_groups)
      offset = 0
      sb.num_groups.times do
        gde = GroupDescriptorEntry.new(buf[offset, SIZEOF_GDE])

        # Construct allocation bitmaps for blocks & inodes.
        gde.block_alloc_bitmap = alloc_bitmap(sb, gde.block_bmp, sb.block_size)
        gde.inode_alloc_bitmap = alloc_bitmap(sb, gde.inode_bmp, sb.inodes_per_group / 8)

        @gdt << gde
        offset += SIZEOF_GDE
      end
    end

    def each
      @gdt.each { |gde| yield(gde) }
    end

    def [](group)
      @gdt[group]
    end

    private

    def alloc_bitmap(sb, block, size)
      sb.stream.seek(sb.block_to_address(block))
      AllocBitmap.new(sb.stream.read(size))
    end
  end # class GroupDescriptorTable
end # module VirtFS::Ext3
