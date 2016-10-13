module VirtFS::Ext3
  class FS
    def file_atime(p)
      get_file(p).try(:inode).try(:atime)
    end

    def file_blockdev?(p)
    end

    def file_chardev?(p)
    end

    def file_chmod(permission, p)
    end

    def file_chown(owner, group, p)
    end

    def file_ctime(p)
      get_file(p).try(:inode).try(:ctime)
    end

    def file_delete(p)
    end

    def file_directory?(p)
      get_file(p).try(:inode).try(:dir?)
    end

    def file_executable?(p)
    end

    def file_executable_real?(p)
    end

    def file_exist?(p)
      !get_file(p).nil?
    end

    def file_file?(p)
      get_file(p).try(:inode).try(:file?)
    end

    def file_ftype(p)
    end

    def file_grpowned?(p)
    end

    def file_identical?(p1, p2)
    end

    def file_lchmod(permission, p)
    end

    def file_lchown(owner, group, p)
    end

    def file_link(p1, p2)
    end

    def file_lstat(p)
      file = get_file(p)
      raise Errno::ENOENT, "No such file or directory" if file.nil?
      VirtFS::Stat.new(VirtFS::Ext3::File.new(file, superblock).to_h)
    end

    def file_mtime(p)
      get_file(p).try(:mtime)
    end

    def file_owned?(p)
    end

    def file_pipe?(p)
    end

    def file_readable?(p)
    end

    def file_readable_real?(p)
    end

    def file_readlink(p)
    end

    def file_rename(p1, p2)
    end

    def file_setgid?(p)
    end

    def file_setuid?(p)
    end

    def file_size(p)
      get_file(p).try(:inode).try(:length)
    end

    def file_socket?(p)
    end

    def file_stat(p)
    end

    def file_sticky?(p)
    end

    def file_symlink(oname, p)
    end

    def file_symlink?(p)
      get_file(p).try(:symlink?)
    end

    def file_truncate(p, len)
    end

    def file_utime(atime, mtime, p)
    end

    def file_world_readable?(p)
    end

    def file_world_writable?(p)
    end

    def file_writable?(p)
    end

    def file_writable_real?(p)
    end

    def file_new(f, parsed_args, _open_path, _cwd)
    end

    private

      def get_file(p)
        p = unnormalize_path(p)

        dir, fname = ::File.split(p)

        # Fix for FB#835: if file == root then file needs to be "."
        fname = "." if fname == "/" || fname == "\\"

        # Check for this file in the cache.
        cache_name = "#{dir == '/' ? '' : dir}/#{fname}"
        if entry_cache.key?(cache_name)
          #cache_hits += 1
          return entry_cache[cache_name]
        end

        begin
          dir_obj = get_dir(dir)
          dir_entry = dir_obj.nil? ? nil : dir_obj.find_entry(fname)
        rescue RuntimeError
          dir_entry = nil
        end

        #dir_entry.inode = superblock.get_inode(dir_entry.inode) unless dir_entry.nil?

        entry_cache[cache_name] = dir_entry
      end
  end
end
