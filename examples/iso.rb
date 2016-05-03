require 'virtfs'
require 'virtfs/block_io'
require 'virtfs/block_file'
require 'virtfs/nativefs/thin'
require 'virtfs/iso9660/iso9660'

PATH        = '/var/lib/oz/isos/Fedora22x86_64-url.iso'
MOUNT_POINT = '/mnt/virtfs'

blk = VirtFS::BlockIO.new(VirtFS::BlockFile.new(PATH))

exit 1 unless ISO9660.match?(blk)
fs = ISO9660.new(blk)

VirtFS.mount fs, '/'
puts fs.dir_entries('/')
