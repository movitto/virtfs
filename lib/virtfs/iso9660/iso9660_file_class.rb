require 'active_support/core_ext/object/try' # until we can use the safe nav operator

class ISO9660
  def file_atime(p)
    get_file(p).try(:date)
  end

  def file_blockdev?(p)
  end

  def file_chardev?(p)
  end

  def file_chmod(permission, p)
    raise "writes not supported"
  end

  def file_chown(owner, group, p)
    raise "writes not supported"
  end

  def file_fileCtime(p)
    get_file(p).try(:date)
  end

  def file_delete(p)
    raise "writes not supported"
  end

  def file_directory?(p)
    get_file(p).try(:dir?)
  end

  def file_executable?(p)
  end

  def file_executable_real?(p)
  end

  def file_exist?(p)
    !get_file(p).nil?
  end

  def file_file?(p)
    get_file(p).try(:file?)
  end

  def file_ftype(p)
  end

  def file_grpowned?(p)
  end

  def file_identical?(p1, p2)
  end

  def file_lchmod(permission, p)
    raise "writes not supported"
  end

  def file_lchown(owner, group, p)
    raise "writes not supported"
  end

  def file_link(p1, p2)
    raise "writes not supported"
  end

  def file_lstat(p)
  end

  def file_mtime(p)
    get_file(p).try(:date)
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
    raise "writes not supported"
  end

  def file_setgid?(p)
  end

  def file_setuid?(p)
  end

  def file_size(p)
    get_file(p).try(:file_size)
  end

  def file_socket?(p)
  end

  def file_stat(p)
  end

  def file_sticky?(p)
  end

  def file_symlink(oname, p)
    raise "writes not supported"
  end

  def file_symlink?(p)
    get_file(p).try(:symlink?)
  end

  def file_truncate(p, len)
  end

  def file_utime(atime, mtime, p)
  end

  def file_world_readable?(p, len)
  end

  def file_world_writable?(p, len)
  end

  def file_writable?(p, len)
  end

  def file_writable_real?(p, len)
  end

  def file_new(f, parsed_args={}, _open_path=nil, _cwd=nil)
    get_file(f)
  end

  private

  def get_file(p)
    # Preprocess path.
    p = unnormalize_path(p)
    dir, fil = ::File.split(p)

    # Fix for FB#835: if fil == root then fil needs to be "."
    fil = "." if fil == "/" || fil == "\\"

    # Look for file in dir, but don't fail if it doesn't exist.
    begin
      return get_dir(dir).try(:find_entry, fil)
    rescue RuntimeError
    end

    nil
  end
end
