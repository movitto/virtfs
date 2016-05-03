require 'active_support/core_ext/object/try' # until we can use the safe nav operator

class ISO9660
  def dir_delete(p)
    raise "writes not supported"
  end

  def dir_entries(p)
    get_dir(p).try(:glob_names)
  end

  def dir_exist?(p)
    # ?
  end

  def dir_foreach(p, &block)
    get_dir(p).try(:glob_names).try(:each, &block)
  end

  def dir_mkdir(p, permissions)
    raise "writes not supported"
  end

  def dir_new(fs_rel_path, hash_args={}, _open_path=nil, _cwd=nil)
    get_dir(fs_rel_path)
  end

  private

  def get_dir(path)
    path = unnormalize_path(path)

    # Check for this path in the cache.
    if dir_cache.key?(path)
      cache_hits += 1
      cached_entry = DirectoryEntry.new(dir_cache[path], boot_sector.suffix)
      return Directory.new(boot_sector, cached_entry)
    end

    # Return root if lone separator.
    return drive_root if path == "/" || path == "\\"

    # Get an array of directory names, kill off the first (it's always empty).
    names = path.split(/[\\\/]/); names.shift

    # Find target dir.
    de = drive_root.dir_entry
    loop do
      break if names.empty?
      dir = Directory.new(boot_sector, de)
      de = dir.find_entry(names.shift, Directory::FE_DIR)
      raise "Can't find directory: \'#{path}\'" if de.nil?
    end

    # Save dir ent in the cache & return a Directory.
    # NOTE: This stores only the directory entry data string - not the whole object.
    dir_cache[path] = de.entry
    Directory.new(boot_sector, de)
  end
end

