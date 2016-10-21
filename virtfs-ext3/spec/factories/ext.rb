require 'ostruct'
require 'virtfs/block_io'
require 'virt_disk/block_file'

FactoryGirl.define do
  factory :ext, class: OpenStruct do
    path '/home/mmorsi/workspace/cfme/virtfs/virtfs-ext3/ext3.fs'
    fs { VirtFS::Ext3::FS.new(VirtFS::BlockIO.new(VirtDisk::BlockFile.new(path))) }
    root_dir ["d1", "d2", "dA", "f1", "f2", "fA", "fB", "lost+found"]
    glob_dir ['d1/s3', 'd1/sC']
    #boot_size 2048
  end
end
