From: Larry D'Anna <larry@elder-gods.org>
Subject: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Thu, 31 Mar 2011 00:00:11 -0400
Message-ID: <cover.1301542804.git.larry@elder-gods.org>
Cc: larry@elder-gods.org, "Yan Zheng" <zheng.z.yan@intel.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a simple patch to allow reflinks to be made crossing subvolume
boundaries.  The only complication I found in implementing this is that
btrfs_ioctl_clone reuses a btrfs_path.  This is a slight problem because once we
allow the source and destination inodes to come from different btrfs_roots, we
need to know what root to pass into the various calls to btrfs_release_path, and
keeping track of this would further complicate the control flow of
btrfs_ioctl_clone.  Fortunately btrfs_release_path does not use it's first
argument, patch number 1 removes it.

Patch number 2 is then just a simple matter of distinguishing between the source
and destination btrfs_roots in btrfs_ioctl_clone.

If removing the first argument from btrfs_release_path is undesirable, then
btrfs_ioctl_clone could simply pass NULL.  There are a few other places in btrfs
that already do this.

I have tested this by cp -a --reflink=always all the files found in the UML
slackware root_fs, and also by cloning a test file with hundreds of
random extents and holes.  

Larry D'Anna (2):
  btrfs: remove unused argument 'root' from btrfs_release_path
  btrfs: allow cross-subvolume BTRFS_IOC_CLONE

 fs/btrfs/ctree.c            |   28 ++++++------
 fs/btrfs/ctree.h            |    2 +-
 fs/btrfs/dir-item.c         |    2 +-
 fs/btrfs/extent-tree.c      |   74 ++++++++++++++++----------------
 fs/btrfs/file-item.c        |   12 +++---
 fs/btrfs/file.c             |   12 +++---
 fs/btrfs/free-space-cache.c |   14 +++---
 fs/btrfs/inode.c            |   42 +++++++++---------
 fs/btrfs/ioctl.c            |   22 +++++----
 fs/btrfs/relocation.c       |   30 +++++++-------
 fs/btrfs/root-tree.c        |   10 ++--
 fs/btrfs/tree-defrag.c      |    2 +-
 fs/btrfs/tree-log.c         |   98 +++++++++++++++++++++---------------------
 fs/btrfs/volumes.c          |   16 ++++----
 fs/btrfs/xattr.c            |    4 +-
 15 files changed, 185 insertions(+), 183 deletions(-)

