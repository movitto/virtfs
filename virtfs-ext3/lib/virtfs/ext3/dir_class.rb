require 'active_support/core_ext/object/try' # until we can use the safe nav operator

module VirtFS::Ext3
  class FS
    def dir_delete(p)
    end

    def dir_entries(p)
      dir = get_dir(p)
      return nil if dir.nil?
      dir.glob_names
    end

    def dir_exist?(p)
    end

    def dir_foreach(p, &block)
      get_dir(p).try(:glob_names).try(:each, &block)
    end

    def dir_mkdir(p, permissions)
    end

    def dir_new(fs_rel_path, hash_args, _open_path, _cwd)
    end

    private
 
    def get_dir(p)
      p = unnormalize_path(p)

      # Get an array of directory names, kill off the first (it's always empty).
      names = p.split(/[\\\/]/)
      names.shift

      dir = get_dir_r(names)
      raise "Directory '#{p}' not found" if dir.nil?
      dir
    end

    def get_dir_r(names)
      return root_dir if names.empty?

      # Check for this path in the cache.
      fname = names.join('/')
      if dir_cache.key?(fname)
        miqfs.cache_hits += 1
        return dir_cache[fname]
      end

      name = names.pop
      pdir = get_dir_r(names)
      return nil if pdir.nil?

      de = pdir.find_entry(name, DirectoryEntry::FT_DIRECTORY)
      return nil if de.nil?
      entry_cache[fname] = de

      dir = Directory.new(superblock, de.inode)
      return nil if dir.nil?

      dir_cache[fname] = dir
    end
  end
end
