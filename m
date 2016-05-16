Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbcEPOOv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 10:14:51 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs for 4.7
Date: Mon, 16 May 2016 16:14:23 +0200
Message-Id: <cover.1463406792.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please queue the following branch to 4.7.

New features or user-visible changes:
* device delete by id, a v2 ioctl for device deletion (this was held back from
  4.6 pull due to possibly related crashes that haven't appeared for a long
  time)
* DUP allowed on multiple-device filesystem (help in case we want to go to
  SINGLE from RAID1/.. but do not want to lose all redundancy while converting)
* GETFLAGS/SETFLAGS/GETVERSION ioctls work on 32bit

Developer-visible changes:
* definitions that are shared with userspace are moved to the uapi directory

Other:
* assorted bugfixes and cleanups

The branch is merged from several topic branches, grouped by functionality
or purpose. The patches have been in for-next, most of them for a few weeks at
least, tested together with Filipe's branch.

Thanks.

----------------------------------------------------------------
The following changes since commit 02da2d72174c61988eb4456b53f405e3ebdebce4:

  Linux 4.6-rc5 (2016-04-24 16:17:05 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.7

for you to fetch changes up to 680834ca0ad4e9827048d4bda1e38db69c3dd1e4:

  Merge branch 'foreign/jeffm/uapi' into for-chris-4.7-20160516 (2016-05-16 15:46:29 +0200)

----------------------------------------------------------------
Adam Borowski (1):
      btrfs: fix int32 overflow in shrink_delalloc().

Anand Jain (20):
      btrfs: rename btrfs_std_error to btrfs_handle_fs_error
      btrfs: remove unused function btrfs_assert()
      btrfs: move error handling code together in ctree.h
      btrfs: remove save_error_info()
      btrfs: create a helper function to read the disk super
      btrfs: create helper function __check_raid_min_devices()
      btrfs: clean up and optimize __check_raid_min_device()
      btrfs: create helper btrfs_find_device_by_user_input()
      btrfs: make use of btrfs_find_device_by_user_input()
      btrfs: enhance btrfs_find_device_by_user_input() to check device path
      btrfs: make use of btrfs_scratch_superblocks() in btrfs_rm_device()
      btrfs: introduce device delete by devid
      btrfs: optimize check for stale device
      btrfs: use fs_info directly
      btrfs: refactor btrfs_dev_replace_start for reuse
      btrfs: pass the right error code to the btrfs_std_error
      btrfs: s_bdev is not null after missing replace
      btrfs: cleanup assigning next active device with a check
      btrfs: fix lock dep warning, move scratch dev out of device_list_mutex and uuid_mutex
      btrfs: fix lock dep warning move scratch super outside of chunk_mutex

Ashish Samant (1):
      btrfs: Fix BUG_ON condition in scrub_setup_recheck_block()

Austin S. Hemmelgarn (1):
      btrfs: allow balancing to dup with multi-device

Chandan Rajendra (1):
      Btrfs: __btrfs_buffered_write: Pass valid file offset when releasing delalloc space

Dan Carpenter (1):
      btrfs: send: silence an integer overflow warning

David Sterba (32):
      btrfs: rename __check_raid_min_devices
      btrfs: pass number of devices to btrfs_check_raid_min_devices
      btrfs: introduce raid-type to error-code table, for minimum device constraint
      btrfs: use existing device constraints table btrfs_raid_array
      btrfs: rename btrfs_find_device_by_user_input
      btrfs: rename flags for vol args v2
      btrfs: kill unused writepage_io_hook callback
      btrfs: ioctl: reorder exclusive op check in RM_DEV
      btrfs: send: use vmalloc only as fallback for send_buf
      btrfs: send: use vmalloc only as fallback for read_buf
      btrfs: send: use temporary variable to store allocation size
      btrfs: send: use vmalloc only as fallback for clone_roots
      btrfs: send: use vmalloc only as fallback for clone_sources_tmp
      btrfs: clone: use vmalloc only as fallback for nodesize bufer
      btrfs: use dynamic allocation for root item in create_subvol
      btrfs: reuse existing variable in scrub_stripe, reduce stack usage
      btrfs: add read-only check to sysfs handler of features
      btrfs: add check to sysfs handler of label
      btrfs: sysfs: protect reading label by lock
      btrfs: add write protection to SET_FEATURES ioctl
      btrfs: ioctl: reorder exclusive op check in RM_DEV
      btrfs: switch to common message helpers in open_ctree, adjust messages
      btrfs: GFP_NOFS does not GFP_HIGHMEM
      btrfs: rename and document compression workspace members
      btrfs: preallocate compression workspaces
      btrfs: make find_workspace always succeed
      btrfs: make find_workspace warn if there are no workspaces
      btrfs: build fixup for qgroup_account_snapshot
      Merge branch 'misc-4.7' into for-chris-4.7-20160516
      Merge branch 'cleanups-4.7' into for-chris-4.7-20160516
      Merge branch 'foreign/anand/dev-del-by-id-ext' into for-chris-4.7-20160516
      Merge branch 'foreign/jeffm/uapi' into for-chris-4.7-20160516

Geert Uytterhoeven (1):
      Btrfs: Refactor btrfs_lock_cluster() to kill compiler warning

Jeff Mahoney (8):
      btrfs: uapi/linux/btrfs.h migration, move BTRFS_LABEL_SIZE
      btrfs: uapi/linux/btrfs.h migration, qgroup limit flags
      btrfs: uapi/linux/btrfs.h migration, document subvol flags
      btrfs: uapi/linux/btrfs.h migration, move feature flags
      btrfs: uapi/linux/btrfs.h migration, move balance flags
      btrfs: uapi/linux/btrfs.h migration, move struct btrfs_ioctl_defrag_range_args
      btrfs: uapi/linux/btrfs_tree.h migration, item types and defines
      btrfs: uapi/linux/btrfs_tree.h, use __u8 and __u64

Josef Bacik (1):
      Btrfs: remove BUG_ON()'s in btrfs_map_block

Liu Bo (4):
      Btrfs: make mapping->writeback_index point to the last written page
      Btrfs: cleanup error handling in extent_write_cached_pages
      Btrfs: do not create empty block group if we have allocated data
      Btrfs: fix divide error upon chunk's stripe_len

Luis de Bethencourt (3):
      btrfs: fix typos in comments
      btrfs: fix mixed block count of available space
      btrfs: avoid overflowing f_bfree

Luke Dashjr (1):
      btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl

Qu Wenruo (1):
      btrfs: qgroup: Fix qgroup accounting when creating snapshot

Satoru Takeuchi (1):
      btrfs: Simplify conditions about compress while mapping btrfs flags to inode flags

Scott Talbert (1):
      btrfs: fix memory leak during RAID 5/6 device replacement

Vincent Stehlé (1):
      Btrfs: fix fspath error deallocation

Zygo Blaxell (1):
      btrfs: don't force mounts to wait for cleaner_kthread to delete one or more subvolumes

 fs/btrfs/backref.c              |    2 +-
 fs/btrfs/compression.c          |   85 ++-
 fs/btrfs/ctree.c                |    6 +-
 fs/btrfs/ctree.h                | 1096 ++-------------------------------------
 fs/btrfs/delayed-inode.c        |    2 +-
 fs/btrfs/dev-replace.c          |   99 ++--
 fs/btrfs/dev-replace.h          |    4 +-
 fs/btrfs/disk-io.c              |  130 ++---
 fs/btrfs/extent-tree.c          |   45 +-
 fs/btrfs/extent_io.c            |   82 +--
 fs/btrfs/extent_io.h            |    1 -
 fs/btrfs/file.c                 |    6 +-
 fs/btrfs/inode-item.c           |    2 +-
 fs/btrfs/inode.c                |    2 +-
 fs/btrfs/ioctl.c                |  196 +++++--
 fs/btrfs/relocation.c           |    2 +-
 fs/btrfs/root-tree.c            |    4 +-
 fs/btrfs/scrub.c                |   25 +-
 fs/btrfs/send.c                 |   62 ++-
 fs/btrfs/super.c                |   58 ++-
 fs/btrfs/sysfs.c                |   14 +-
 fs/btrfs/transaction.c          |  136 ++++-
 fs/btrfs/tree-log.c             |    8 +-
 fs/btrfs/volumes.c              |  454 ++++++++--------
 fs/btrfs/volumes.h              |   57 +-
 include/uapi/linux/btrfs.h      |  188 ++++++-
 include/uapi/linux/btrfs_tree.h |  966 ++++++++++++++++++++++++++++++++++
 27 files changed, 2071 insertions(+), 1661 deletions(-)
 create mode 100644 include/uapi/linux/btrfs_tree.h
