require 'spec_helper'

describe "Ext3::Dir class methods" do
  before(:all) do
    reset_context

    @root    = File::SEPARATOR
    @ext     = build(:ext)
    VirtFS.mount(@ext.fs, @root)
  end

  after(:all) do
  end

  describe ".[]" do
    it "should return empty array when in a nonexistent directory" do
      VirtFS.cwd = "/not_a_dir" # bypass existence checks.
      expect(VirtFS::VDir["*"]).to match_array([])
    end

    it "should enumerate the same file names as the standard Dir.glob - simple glob" do
      VirtFS.dir_chdir(@root)
      expect(VirtFS::VDir["*"]).to match_array(@ext.root_dir)
    end

    it "should enumerate the same file names as the standard Dir.glob - relative glob" do
      VirtFS.dir_chdir(@root)
      expect(VirtFS::VDir["*/*"]).to match_array(@ext.glob_dir)
    end
  end

  describe ".chdir" do
    it "should raise Errno::ENOENT when directory doesn't exist" do
      expect do
        VirtFS::VDir.chdir("nonexistent_directory")
      end.to raise_error(
        Errno::ENOENT, "No such file or directory - nonexistent_directory"
      )
    end
  end

  describe ".exist? .exists?" do
  end

  describe ".foreach" do
    it "should return an enum when no block is given" do
      expect(VirtFS::VDir.foreach(@root)).to be_kind_of(Enumerator)
    end

  end

  describe ".glob" do
    it "should return empty array when in a nonexistent directory" do
      VirtFS.cwd = "/not_a_dir" # bypass existence checks.
      expect(VirtFS::VDir.glob("*")).to match_array([])
    end

    it "should enumerate the same file names as the standard Dir.glob - simple glob" do
      VirtFS.dir_chdir(@root)
      expect(VirtFS::VDir.glob("*")).to match_array(@ext.root_dir)
    end

    it "should enumerate the same file names as the standard Dir.glob - relative glob" do
      VirtFS.dir_chdir(@root)
      expect(VirtFS::VDir.glob("*/*")).to match_array(@ext.glob_dir)
    end
  end
end
