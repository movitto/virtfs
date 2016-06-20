require 'virtfs'
require 'virt_disk'
require 'virtfs/block_io'
require 'virtfs/ntfs'

PATH = 'virtfs-ntfs/ntfs.fs'

blk = VirtFS::BlockIO.new(VirtDisk::BlockFile.new(PATH))

exit 1 unless VirtFS::NTFS::FS.match?(blk)
fs = VirtFS::NTFS::FS.new(blk)

VirtFS.mount fs, '/'
puts VirtFS::VDir.entries('/')
#puts VirtFS::VFile.symlink?("/f1")
