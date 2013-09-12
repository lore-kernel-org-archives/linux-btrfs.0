Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56545 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3ILPgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 11:36:35 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 286DD7C0685
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Sep 2013 09:36:35 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20130912153629.16487.88969@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Thu, 12 Sep 2013 11:36:29 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is against 3.11-rc7, but was pulled and tested against your tree as
of yesterday.  We do have two small incrementals queued up, but I wanted
to get this bunch out the door before I hop on an airplane.

This is a fairly large batch of fixes, performance improvements, and
cleanups from the usual Btrfs suspects.

We've included Stefan Behren's work to index subvolume UUIDs, which is
targeted at speeding up send/receive with many subvolumes or snapshots
in place.  It closes a long standing performance issue that was built
in to the disk format.

Mark Fasheh's offline dedup work is also here.  In this case offline
means the FS is mounted and active, but the dedup work is not done
inline during file IO.   This is a building block where utilities  are
able to ask the FS to dedup a series of extents.  The kernel takes
care of verifying the data involved really is the same.  Today this
involves reading both extents, but we'll continue to evolve the patches.

Anand Jain (3):
      btrfs: fix get set label blocking against balance
      btrfs: use BTRFS_SUPER_INFO_SIZE macro at btrfs_read_dev_super()
      btrfs: return btrfs error code for dev excl ops err

Andy Shevchenko (1):
      btrfs: reuse kbasename helper

Carey Underwood (1):
      Btrfs: Release uuid_mutex for shrink during device delete

Dan Carpenter (1):
      btrfs/raid56: fix and cleanup some error paths

Dave Jones (1):
      Fix leak in __btrfs_map_block error path

David Sterba (2):
      btrfs: make errors in btrfs_num_copies less noisy
      btrfs: add mount option to set commit interval

Filipe David Borba Manana (18):
      Btrfs: optimize btrfs_lookup_extent_info()
      Btrfs: add missing error checks to add_data_references
      Btrfs: optimize function btrfs_read_chunk_tree
      Btrfs: add missing error check to find_parent_nodes
      Btrfs: add missing error handling to read_tree_block
      Btrfs: fix inode leak on kmalloc failure in tree-log.c
      Btrfs: don't ignore errors from btrfs_run_delayed_items
      Btrfs: return ENOSPC when target space is full
      Btrfs: add missing error code to BTRFS_IOC_INO_LOOKUP handler
      Btrfs: don't miss inode ref items in BTRFS_IOC_INO_LOOKUP
      Btrfs: reset force_compress on btrfs_file_defrag failure
      Btrfs: fix memory leak of orphan block rsv
      Btrfs: fix printing of non NULL terminated string
      Btrfs: fix race between removing a dev and writing sbs
      Btrfs: fix race conditions in BTRFS_IOC_FS_INFO ioctl
      Btrfs: fix memory leak of uuid_root in free_fs_info
      Btrfs: fix deadlock in uuid scan kthread
      Btrfs: optimize key searches in btrfs_search_slot

Geert Uytterhoeven (12):
      Btrfs: Remove superfluous casts from u64 to unsigned long long
      Btrfs: Make BTRFS_DEV_REPLACE_DEVID an unsigned long long constant
      Btrfs: Format PAGE_SIZE as unsigned long
      Btrfs: Format mirror_num as int
      Btrfs: Make btrfs_device_uuid() return unsigned long
      Btrfs: Make btrfs_device_fsid() return unsigned long
      Btrfs: Make btrfs_dev_extent_chunk_tree_uuid() return unsigned long
      Btrfs: Make btrfs_header_fsid() return unsigned long
      Btrfs: Make btrfs_header_chunk_tree_uuid() return unsigned long
      Btrfs: PAGE_CACHE_SIZE is already unsigned long
      Btrfs: Do not truncate sector_t on 32-bit with CONFIG_LBDAF=y
      Btrfs: Use %z to format size_t

Ilya Dryomov (5):
      Btrfs: find_next_devid: root -> fs_info
      Btrfs: add btrfs_alloc_device and switch to it
      Btrfs: add alloc_fs_devices and switch to it
      Btrfs: rollback btrfs_device fields on umount
      Btrfs: stop refusing the relocation of chunk 0

Jeff Mahoney (1):
      btrfs: fall back to global reservation when removing subvolumes

Josef Bacik (30):
      Btrfs: stop using GFP_ATOMIC for the tree mod log allocations
      Btrfs: set lockdep class before locking new extent buffer
      Btrfs: reset ret in record_one_backref
      Btrfs: cleanup reloc roots properly on error
      Btrfs: don't bother autodefragging if our root is going away
      Btrfs: cleanup arguments to extent_clear_unlock_delalloc
      Btrfs: fix what bits we clear when erroring out from delalloc
      Btrfs: check to see if we have an inline item properly
      Btrfs: change how we queue blocks for backref checking
      Btrfs: don't bug_on when we fail when cleaning up transactions
      Btrfs: handle errors when doing slow caching
      Btrfs: check our parent dir when doing a compare send
      Btrfs: deal with enomem in the rewind path
      Btrfs: stop using GFP_ATOMIC when allocating rewind ebs
      Btrfs: skip subvol entries when checking if we've created a dir already
      Btrfs: don't allow a subvol to be deleted if it is the default subovl
      Btrfs: fix the error handling wrt orphan items
      Btrfs: fix heavy delalloc related deadlock
      Btrfs: avoid starting a transaction in the write path
      Btrfs: separate out tests into their own directory
      Btrfs: fix send issues related to inode number reuse
      Btrfs: fix send to deal with sparse files properly
      Btrfs: do not clear our orphan item runtime flag on eexist
      Btrfs: remove ourselves from the cluster list under lock
      Btrfs: adjust the fs_devices->missing count on unmount
      Btrfs: add support for asserts
      Btrfs: convert all bug_ons in free-space-cache.c
      Btrfs: allow partial ordered extent completion
      Btrfs: only update disk_i_size as we remove extents
      Btrfs: don't use an async starter for most of our workers

Liu Bo (3):
      Btrfs: make free space caching faster with many non-inline extent references
      Btrfs/tracepoint: update delayed ref tracepoints
      Btrfs: allow compressed extents to be merged during defragment

Mark Fasheh (4):
      btrfs: abtract out range locking in clone ioctl()
      btrfs_ioctl_clone: Move clone code into it's own function
      btrfs: Introduce extent_read_full_page_nolock()
      btrfs: offline dedupe

Miao Xie (7):
      Btrfs, raid56: fix memory leak when allocating pages for p/q stripes failed
      Btrfs: remove unnecessary argument of bio_readpage_error()
      Btrfs: add branch prediction hints in the read page end IO function
      Btrfs: don't cache the csum value into the extent state tree
      Btrfs: batch the extent state operation in the end io handle of the read page
      Btrfs: batch the extent state operation when reading pages
      Btrfs: cache the extent map struct when reading several pages

Mike Frysinger (1):
      Btrfs: use __u64 in exported user headers

Qu Wenruo (1):
      btrfs: Cleanup for using BTRFS_SETGET_STACK instead of raw convert

Sergei Trofimovich (1):
      btrfs: mark some local function as 'static'

Stefan Agner (1):
      Btrfs: return -1 when lzo compression makes data bigger

Stefan Behrens (14):
      Btrfs: Print key type in decimal everywhere
      Btrfs: get rid of sparse warnings
      Btrfs: introduce a tree for items that map UUIDs to something
      Btrfs: support printing UUID tree elements
      Btrfs: create UUID tree if required
      Btrfs: maintain subvolume items in the UUID tree
      Btrfs: fill UUID tree initially
      Btrfs: introduce uuid-tree-gen field
      Btrfs: check UUID tree during mount if required
      Btrfs: add mount option to force UUID tree checking
      Btrfs: don't allow the replace procedure on read only filesystems
      Btrfs: get rid of one BUG() in write_all_supers()
      Btrfs: fix for patch "cleanup: don't check the same thing twice"
      Btrf: cleanup: don't check for root_refs == 0 twice

Wang Shilong (10):
      Btrfs: set qgroup_ulist to be null after calling ulist_free()
      Btrfs: add sanity checks regarding to parsing mount options
      Btrfs: use u64 for subvolid when parsing mount options
      Btrfs: add missing mounting options in btrfs_show_options()
      Btrfs: fix possible memory leak in find_parent_nodes()
      Btrfs: fix oops when writing dirty qgroups to disk
      Btrfs: move btrfs_free_qgroup_config() out of spin_lock and fix comments
      Btrfs: remove reduplicate check when disabling quota
      Btrfs: pass gfp_t to __add_prelim_ref() to avoid always using GFP_ATOMIC
      Btrfs: allocate prelim_ref with a slab allocater

chandan (1):
      btrfs_read_block_groups: Use enums to index

 fs/btrfs/Kconfig                  |    9 +
 fs/btrfs/Makefile                 |    5 +-
 fs/btrfs/backref.c                |   93 +++--
 fs/btrfs/backref.h                |    2 +
 fs/btrfs/btrfs_inode.h            |   21 ++
 fs/btrfs/check-integrity.c        |  422 ++++++++-------------
 fs/btrfs/compression.c            |   11 +-
 fs/btrfs/ctree.c                  |  289 +++++++-------
 fs/btrfs/ctree.h                  |  161 ++++++--
 fs/btrfs/delayed-inode.c          |   46 +--
 fs/btrfs/delayed-ref.c            |    8 +-
 fs/btrfs/dev-replace.c            |    4 +-
 fs/btrfs/disk-io.c                |  174 ++++++---
 fs/btrfs/extent-tree.c            |  184 ++++++---
 fs/btrfs/extent_io.c              |  664 +++++++++++++++++++--------------
 fs/btrfs/extent_io.h              |   35 +-
 fs/btrfs/file-item.c              |   85 +++--
 fs/btrfs/file.c                   |   11 +-
 fs/btrfs/free-space-cache.c       |  525 ++++----------------------
 fs/btrfs/free-space-cache.h       |   11 +-
 fs/btrfs/inode.c                  |  615 ++++++++++++++----------------
 fs/btrfs/ioctl.c                  |  745 ++++++++++++++++++++++++++++---------
 fs/btrfs/lzo.c                    |    4 +-
 fs/btrfs/ordered-data.c           |   28 +-
 fs/btrfs/ordered-data.h           |    7 +
 fs/btrfs/print-tree.c             |  107 +++---
 fs/btrfs/qgroup.c                 |   69 ++--
 fs/btrfs/raid56.c                 |   14 +-
 fs/btrfs/relocation.c             |   43 ++-
 fs/btrfs/root-tree.c              |   21 +-
 fs/btrfs/scrub.c                  |   42 +--
 fs/btrfs/send.c                   |  240 +++++++++---
 fs/btrfs/super.c                  |  145 ++++++--
 fs/btrfs/tests/btrfs-tests.h      |   34 ++
 fs/btrfs/tests/free-space-tests.c |  395 ++++++++++++++++++++
 fs/btrfs/transaction.c            |   34 +-
 fs/btrfs/transaction.h            |    2 -
 fs/btrfs/tree-log.c               |   19 +-
 fs/btrfs/uuid-tree.c              |  358 ++++++++++++++++++
 fs/btrfs/volumes.c                |  613 ++++++++++++++++++++++--------
 fs/btrfs/volumes.h                |   12 +
 include/trace/events/btrfs.h      |   60 ++-
 include/uapi/linux/btrfs.h        |   30 +-
 43 files changed, 4045 insertions(+), 2352 deletions(-)
