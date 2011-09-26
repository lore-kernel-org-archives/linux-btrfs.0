From: Josef Bacik <josef@redhat.com>
Subject: [GIT PULL] ENOSPC rework and random fixes for next merge window
Date: Mon, 26 Sep 2011 17:36:32 -0400
Message-ID: <1317072992-28375-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Chris can you pull from

git://github.com/josefbacik/linux.git for-chris

it is based on your btrfs-3.0 branch.  The diffstat and shortlog are below.
This is all of my enospc rework stuff.  It is amazing and will cure all of our
enospc woes and possibly cancer.  We get better chunk allocation behavior with
this, doing fs_mark on a 7gig fs we now only allocate 264mb for metadata instead
of 520mb, which allows for much more data to be used and less metadata waste.
I've fixed how we reserve space for checksumming so we shouldn't be getting
those nasty WARN_ON()'s anymore.  And I've fixed that long standing problem
where super random write workloads _sucked_.  Other notable things are a fix on
how we mount subvolumes and such.  This has all been hammered on pretty well
with the exception of the overcommit stuff which really needs to be banged
around a bit, but it's so awesome I really want to get it out there :).  Thanks,

Josef

 fs/btrfs/btrfs_inode.h      |   11 +-
 fs/btrfs/ctree.h            |   53 ++---
 fs/btrfs/disk-io.c          |    8 +-
 fs/btrfs/extent-tree.c      |  585 +++++++++++++++++++++++--------------------
 fs/btrfs/extent_io.c        |  194 ++++++++++++++-
 fs/btrfs/extent_io.h        |    3 +
 fs/btrfs/file.c             |   25 ++-
 fs/btrfs/free-space-cache.c |   99 +++++---
 fs/btrfs/inode-map.c        |    6 +-
 fs/btrfs/inode.c            |  259 ++++++++-----------
 fs/btrfs/ioctl.c            |    3 +-
 fs/btrfs/relocation.c       |   21 +-
 fs/btrfs/super.c            |  224 ++++++++++-------
 fs/btrfs/transaction.c      |  108 +++------
 fs/btrfs/volumes.c          |   39 +++-
 15 files changed, 955 insertions(+), 683 deletions(-)

Josef Bacik (36):
      Btrfs: kill reserved_bytes in inode
      Btrfs: use d_obtain_alias when mounting subvol/subvolid
      Btrfs: fix how we mount subvol=<whatever>
      Btrfs: use bytes_may_use for all ENOSPC reservations
      Btrfs: skip looking for delalloc if we don't have ->fill_delalloc
      Btrfs: calculate checksum space correctly
      Btrfs: kill the orphan space calculation for snapshots
      Btrfs: kill the durable block rsv stuff
      Btrfs: fix how we reserve space for deleting inodes
      Btrfs: ratelimit the generation printk for the free space cache
      Btrfs: kill unused parts of block_rsv
      Btrfs: don't try to commit in btrfs_block_rsv_check
      Btrfs: optimize how we account for space in truncate
      Btrfs: kill btrfs_truncate_reserve_metadata
      Btrfs: only reserve space in fallocate if we have to do a preallocate
      Btrfs: reduce the amount of space needed for truncates
      Btrfs: allow callers to specify if flushing can occur for btrfs_block_rsv_check
      Btrfs: fix call to btrfs_search_slot in free space cache
      Btrfs: fix space leak when we fail to make an allocation
      Btrfs: don't increase the block_rsv's size when emergency allocating space
      Btrfs: set truncate block rsv's size
      Btrfs: put the block group cache after we commit the super
      Btrfs: handle enospc accounting for free space inodes
      Btrfs: use the transactions block_rsv for the csum root
      Btrfs: don't get the block_rsv in btrfs_free_tree_block
      Btrfs: stop passing a trans handle all around the reservation code
      Btrfs: make sure to unset trans->block_rsv before running delayed refs
      Btrfs: delay iput when deleting a block group
      Btrfs: use the inode's mapping mask for allocating pages
      Btrfs: fix orphan cleanup regression
      Btrfs: check unused against how much space we actually want
      Btrfs: introduce convert_extent_bit
      Btrfs: stop using write_one_page
      Btrfs: use the global reserve as a backup for deleting inodes
      Btrfs: break out of orphan cleanup if we can't make progress
      Btrfs: allow us to overcommit our enospc reservations

