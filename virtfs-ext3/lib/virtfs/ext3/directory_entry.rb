require 'binary_struct'

module VirtFS::Ext3
  # ////////////////////////////////////////////////////////////////////////////
  # // Data definitions.

  DIR_ENTRY_ORIGINAL = BinaryStruct.new([
    'L',  'inode_val',  # Inode address of metadata.
    'S',  'entry_len',  # Length of entry.
    'S',  'name_len',   # Length of name.
  ])
  # Here follows the name in ASCII.
  SIZEOF_DIR_ENTRY_ORIGINAL = DIR_ENTRY_ORIGINAL.size

  DIR_ENTRY_NEW = BinaryStruct.new([
    'L',  'inode_val',  # Inode address of metadata.
    'S',  'entry_len',  # Length of entry.
    'C',  'name_len',   # Length of name.
    'C',  'file_type',  # Type of file (see FT_ below).
  ])
  # Here follows the name in ASCII.
  SIZEOF_DIR_ENTRY_NEW = DIR_ENTRY_NEW.size

  class DirectoryEntry
    FT_UNKNOWN    = 0
    FT_FILE       = 1
    FT_DIRECTORY  = 2
    FT_CHAR       = 3
    FT_BLOCK      = 4
    FT_FIFO       = 5
    FT_SOCKET     = 6
    FT_SYM_LNK    = 7

    attr_reader :fs, :len, :name

    alias :size :len

    attr_accessor :inode, :file_type

    def initialize(fs, data, new_entry = true)
      raise "nil directory entry data" if data.nil?
      @is_new = new_entry

      @fs = fs

      # Both entries are same size.
      size = SIZEOF_DIR_ENTRY_NEW
      @de  = @is_new ? DIR_ENTRY_NEW.decode(data[0..size]) : DIR_ENTRY_ORIGINAL.decode(data[0..size])

      # If there's a name get it.
      @name      = data[size, @de['name_len']] if @de['name_len'] != 0
      @inode     = @de['inode_val']
      @len       = @de['entry_len']
      @file_type = @de['file_type'] if @is_new
    end

    def close
    end

    def dir?
      @file_type == FT_DIRECTORY
    end

    def file?
      @file_type == FT_FILE
    end

    def symlink?
      @file_type == FT_SYM_LNK
    end

    def atime
      @atime ||= Time.now
    end

    def ctime
      Time.now
    end

    def mtime
      Time.now
    end

    def fileTypeString
      return "UNKNOWN"   if @file_type == FT_UNKNOWN
      return "FILE"      if @file_type == FT_FILE
      return "DIRECTORY" if @file_type == FT_DIRECTORY
      return "CHAR"      if @file_type == FT_CHAR
      return "BLOCK"     if @file_type == FT_BLOCK
      return "FIFO"      if @file_type == FT_FIFO
      return "SOCKET"    if @file_type == FT_SOCKET
      return "SYMLINK"   if @file_type == FT_SYM_LNK
    end
  end # class DirectoryEntry
end # module VirtFS::Ext3
