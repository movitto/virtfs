require_relative 'file_data'
require_relative 'directory_entry'

module VirtFS::Ext3
  class Directory
    ROOT_DIRECTORY = 2

    def initialize(sb, inode_num = ROOT_DIRECTORY)
      raise "nil superblock"   if sb.nil?
      raise "nil inode number" if inode_num.nil?
      @sb        = sb
      @inode_num = inode_num
      @inode_obj = sb.get_inode(inode_num)
      @data      = sb.ext4? ? @inode_obj.read : FileData.new(@inode_obj, @sb).read
    end

    def glob_names
      @ent_names ||= glob_entries.keys.compact.sort
    end

    def find_entry(name, type = nil)
      return nil unless glob_entries.key?(name)

      new_entry = @sb.new_dir_entry?
      glob_entries[name].each do |ent|
        ent.file_type = @sb.get_inode(ent.inode).file_mode_file_type unless new_entry
        return ent if ent.file_type == type || type.nil?
      end
      nil
    end

    private

    def glob_entries
      return @ents_by_name unless @ents_by_name.nil?

      @ents_by_name = {}; p = 0
      return @ents_by_name if @data.nil?
      new_entry = @sb.new_dir_entry?
      loop do
        break if p > @data.length - 4
        break if @data[p, 4].nil?
        de = DirectoryEntry.new(@data[p..-1], new_entry)
        raise "DirectoryEntry length cannot be 0" if de.len == 0
        @ents_by_name[de.name] ||= []
        @ents_by_name[de.name] << de
        p += de.len
      end
      @ents_by_name
    end

    # If the inode has the IF_HASH_INDEX bit set,
    # then the first directory block is to be interpreted as the root of an HTree index.
    def glob_entries_by_hash_tree
      ents_by_name = {}
      offset = 0
      # Chomp fake '.' and '..' directories first
      2.times do
        de = DirectoryEntry.new(@data[offset..-1], @sb.new_dir_entry?)
        ents_by_name[de.name] ||= []
        ents_by_name[de.name] << de
        offset += 12
      end

      header = HashTreeHeader.new(@data[offset..-1])
      offset += header.length
      root = HashTreeEntry.new(@data[offset..-1], true)
      ents_by_name
    end
  end # class Directory
end # module VirtFS::Ext3
