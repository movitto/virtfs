require 'virtfs'
require 'virt_disk'
require 'virtfs/block_io'
require 'virtfs/ext4'

PATH = 'virtfs-ext4/ext4.fs'

blk = VirtFS::BlockIO.new(VirtDisk::BlockFile.new(PATH))

exit 1 unless VirtFS::Ext4::FS.match?(blk)
fs = VirtFS::Ext4::FS.new(blk)

VirtFS.mount fs, '/'
puts VirtFS::VDir.entries('/')
puts VirtFS::VFile.symlink?("/f1")
