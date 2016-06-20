module VirtFS::NTFS
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
    end

    def dir_mkdir(p, permissions)
    end

    def dir_new(fs_rel_path, hash_args, _open_path, _cwd)
    end

    private

    def get_dir(p)
      p = unnormalize_path(p).downcase

      # Get an array of directory names, kill off the first (it's always empty).
      names = p.split(/[\\\/]/)
      names.shift

      # Get the index for this directory
      get_index(names)
    end

    def get_index(names)
      return boot_sector.root_dir if names.empty?

      fname = names.join('/')
      if index_cache.key?(fname)
        cache_hits += 1
        return index_cache[fname]
      end

      name = names.pop
      index = get_index(names)
      return nil if index.nil?

      din = index.find(name)
      return nil if din.nil?

      index = din.resolve(boot_sector).index_root
      return nil if index.nil?

      index_cache[fname] = index
    end
  end
end
