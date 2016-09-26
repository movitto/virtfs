module VirtFS::Ext3
  # ////////////////////////////////////////////////////////////////////////////
  # // Data definitions.

  POSIX_ACL_HEADER = [
    'L',  'version',  # Always 1, or 1 is all that's supported.
  ]

  class PosixAclHeader
  end # class PosixAclHeader
end # module VirtFS::Ext3
