require 'virtfs'
require 'virtfs/block_io'
require 'virtfs/core_ext'
require 'virtfs/nativefs/thin'

require 'virtfs/block_file'
require 'virtfs/fat32/fat32'

PATH = 'fat.fs'

blk = VirtFS::BlockIO.new(VirtFS::BlockFile.new(PATH))

exit 1 unless Fat32.match?(blk)
fs = Fat32.new(blk)

VirtFS.mount fs, '/'
puts fs.dir_entries('/')
