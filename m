Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbeFDPqN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Jun 2018 11:46:13 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 4.18
Date: Mon,  4 Jun 2018 17:43:21 +0200
Message-Id: <cover.1528125657.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

there are some new features and a usual load of cleanups, more details below.

Specifically, there's a set of new non-privileged ioctls to allow
subvolume listing.  It works but still needs a security review as it's a
new interface and we might need to do some tweaks to the data
structures. The fixes could be considred regressions but may touch the
interfaces too.

Currently there are no merge conflicts but linux-next has reported a few
in the past, originating from other *FS trees.

Please pull, thanks.

---

User visible features:

- added support for the ioctl FS_IOC_FSGETXATTR, per-inode flags, successor
  of GET/SETFLAGS; now supports only existing flags: append, immutable,
  noatime, nodump, sync

- 3 new unprivileged ioctls to allow users to enumerate subvolumes

- dedupe syscall implementation does not restrict the range to 16MiB, though it
  still splits the whole range to 16MiB chunks

- on user demand, rmdir() is able to delete an empty subvolume, export the
  capability in sysfs

- fix inode number types in tracepoints, other cleanups

- send: improved speed when dealing with a large removed directory,
  measurements show decrease from 2000 minutes to 2 minutes on a directory with
  2 million entries

- pre-commit check of superblock to detect a mysterious in-memory corruption

- log message updates


Other changes:

- orphan inode cleanup improved, does no keep long-standing reservations that
  could lead up to early ENOSPC in some cases

- slight improvement of handling snapshotted NOCOW files by avoiding some
  unnecessary tree searches

- avoid OOM when dealing with many unmergeable small extents at flush time

- speedup conversion of free space tree representations from/to bitmap/tree

- code refactoring, deletion, cleanups
  - delayed refs
  - delayed iput
  - redundant argument removals
  - memory barrier cleanups
  - remove a redundant mutex supposedly excluding several ioctls to run in
    parallel

- new tracepoints for blockgroup manipulation

- more sanity checks of compressed headers

----------------------------------------------------------------
The following changes since commit b04e217704b7f879c6b91222b066983a44a7a09f:

  Linux 4.17-rc7 (2018-05-27 13:01:47 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.18-tag

for you to fetch changes up to 23d0b79dfaed2305b500b0215b0421701ada6b1a:

  btrfs: Add unprivileged version of ino_lookup ioctl (2018-05-31 11:35:24 +0200)

----------------------------------------------------------------
Al Viro (1):
      btrfs: take the last remnants of ->d_fsdata use out

Anand Jain (19):
      btrfs: add comment about BTRFS_FS_EXCL_OP
      btrfs: rename struct btrfs_fs_devices::list
      btrfs: cleanup __btrfs_open_devices() drop head pointer
      btrfs: rename __btrfs_close_devices to close_fs_devices
      btrfs: rename __btrfs_open_devices to open_fs_devices
      btrfs: cleanup find_device() drop list_head pointer
      btrfs: cleanup btrfs_rm_device() promote fs_devices pointer
      btrfs: move btrfs_raid_type_names values to btrfs_raid_attr table
      btrfs: move btrfs_raid_group values to btrfs_raid_attr table
      btrfs: move btrfs_raid_mindev_errorvalues to btrfs_raid_attr table
      btrfs: reduce uuid_mutex critical section while scanning devices
      btrfs: use existing cur_devices, cleanup btrfs_rm_device
      btrfs: document uuid_mutex uasge in read_chunk_tree
      btrfs: replace uuid_mutex by device_list_mutex in btrfs_open_devices
      btrfs: drop uuid_mutex in btrfs_dev_replace_finishing
      btrfs: drop uuid_mutex in btrfs_destroy_dev_replace_tgtdev
      btrfs: use common variable for fs_devices in btrfs_destroy_dev_replace_tgtdev
      btrfs: add prefix "balance:" for log messages
      btrfs: fix describe_relocation when printing unknown flags

Chengguang Xu (1):
      btrfs: return original error code when failing from option parsing

Colin Ian King (1):
      btrfs: send: fix spelling mistake: "send_in_progres" -> "send_in_progress"

David Sterba (38):
      btrfs: tracepoints, use correct type for inode number
      btrfs: tracepoints, use %llu instead of %Lu
      btrfs: tracepoints, drop unnecessary ULL casts
      btrfs: tracepoints, fix whitespace in strings
      btrfs: tracepoints, use extended format with UUID where possible
      btrfs: tests: pass fs_info to extent_map tests
      btrfs: use fs_info for btrfs_handle_em_exist tracepoint
      btrfs: squeeze btrfs_dev_replace_continue_on_mount to its caller
      btrfs: make success path out of btrfs_init_dev_replace_tgtdev more clear
      btrfs: export and rename free_device
      btrfs: move btrfs_init_dev_replace_tgtdev to dev-replace.c and make static
      btrfs: move volume_mutex to callers of btrfs_rm_device
      btrfs: move clearing of EXCL_OP out of __cancel_balance
      btrfs: add proper safety check before resuming dev-replace
      btrfs: add sanity check when resuming balance after mount
      btrfs: cleanup helpers that reset balance state
      btrfs: remove wrong use of volume_mutex from btrfs_dev_replace_start
      btrfs: kill btrfs_fs_info::volume_mutex
      btrfs: track running balance in a simpler way
      btrfs: move and comment read-only check in btrfs_cancel_balance
      btrfs: drop lock parameter from update_ioctl_balance_args and rename
      btrfs: use mutex in btrfs_resume_balance_async
      btrfs: open code set_balance_control
      btrfs: remove redundant btrfs_balance_control::fs_info
      btrfs: introduce conditional wakeup helpers
      btrfs: add barriers to btrfs_sync_log before log_commit_wait wakeups
      btrfs: replace waitqueue_actvie with cond_wake_up
      btrfs: rename btrfs_update_iflags to reflect which flags it touches
      btrfs: rename btrfs_mask_flags to reflect which flags it touches
      btrfs: rename check_flags to reflect which flags it touches
      btrfs: rename btrfs_flags_to_ioctl to reflect which flags it touches
      btrfs: add helpers for FS_XFLAG_* conversion
      btrfs: add FS_IOC_FSGETXATTR ioctl
      btrfs: add FS_IOC_FSSETXATTR ioctl
      btrfs: unify naming of flags variables for SETFLAGS and XFLAGS
      btrfs: use kvzalloc for EXTENT_SAME temporary data
      btrfs: tests: add helper for error messages and update them
      btrfs: tests: drop newline from test_msg strings

Ethan Lien (2):
      btrfs: lift some btrfs_cross_ref_exist checks in nocow path
      btrfs: balance dirty metadata pages in btrfs_finish_ordered_io

Gu JinXiang (2):
      btrfs: drop unused parameter qgroup_reserved
      btrfs: drop useless member qgroup_reserved of btrfs_pending_snapshot

Gu Jinxiang (3):
      btrfs: remove unused fs_info parameter
      btrfs: do reverse path readahead in btrfs_shrink_device
      btrfs: propagate failures of __exclude_logged_extent to upper caller

Howard McLauchlan (3):
      btrfs: clean up le_bitmap_{set, clear}()
      btrfs: optimize free space tree bitmap conversion
      btrfs: remove unused le_test_bit()

Kees Cook (1):
      btrfs: raid56: Remove VLA usage

Liu Bo (7):
      Btrfs: add parent_transid parameter to veirfy_level_key
      Btrfs: remove superfluous free_extent_buffer in read_block_for_search
      Btrfs: use more straightforward extent_buffer_uptodate check
      Btrfs: move get root out of btrfs_search_slot to a helper
      Btrfs: grab write lock directly if write_lock_level is the max level
      Btrfs: remove always true check in unlock_up
      Btrfs: remove unused check of skip_locking

Lu Fengqi (3):
      btrfs: drop unused space_info parameter from create_space_info
      btrfs: Remove fs_info argument from btrfs_uuid_tree_add
      btrfs: Remove fs_info argument from btrfs_uuid_tree_rem

Misono Tomohiro (5):
      btrfs: Move may_destroy_subvol() from ioctl.c to inode.c
      btrfs: Factor out the main deletion process from btrfs_ioctl_snap_destroy()
      btrfs: Allow rmdir(2) to delete an empty subvolume
      btrfs: sysfs: Add entry which shows if rmdir can work on subvolumes
      btrfs: use error code returned by btrfs_read_fs_root_no_name in search ioctl

Nikolay Borisov (54):
      btrfs: Replace owner argument in add_pinned_bytes with a boolean
      btrfs: Drop delayed_refs argument from btrfs_check_delayed_seq
      btrfs: Use while loop instead of labels in __endio_write_update_ordered
      btrfs: Fix lock release order
      btrfs: Consolidate error checking for btrfs_alloc_chunk
      btrfs: Sink extent_tree arguments in try_release_extent_mapping
      btrfs: Remove map argument from try_release_extent_state
      btrfs: Remove redundant tree argument from extent_readpages
      btrfs: Use list_empty instead of list_empty_careful
      btrfs: Remove tree argument from extent_writepages
      btrfs: Remove btrfs_wait_and_free_delalloc_work
      btrfs: Drop add_delayed_ref_head fs_info parameter
      btrfs: Drop fs_info parameter from add_delayed_data_ref
      btrfs: Drop fs_info parameter from btrfs_merge_delayed_refs
      btrfs: Remove delayed_iput parameter of btrfs_start_delalloc_roots
      btrfs: Remove delayed_iput parameter from btrfs_start_delalloc_inodes
      btrfs: Remove delay_iput parameter from __start_delalloc_inodes
      btrfs: Remove delayed_iput member from btrfs_delalloc_work
      btrfs: Unexport btrfs_alloc_delalloc_work
      btrfs: Remove devid parameter from btrfs_rmap_block
      btrfs: Factor out common delayed refs init code
      btrfs: Use init_delayed_ref_common in add_delayed_tree_ref
      btrfs: Use init_delayed_ref_common in add_delayed_data_ref
      btrfs: Open-code add_delayed_tree_ref
      btrfs: Open-code add_delayed_data_ref
      btrfs: Introduce init_delayed_ref_head
      btrfs: Use init_delayed_ref_head in add_delayed_ref_head
      btrfs: split delayed ref head initialization and addition
      btrfs: Add assert in __btrfs_del_delalloc_inode
      btrfs: Make btrfs_init_dummy_trans initialize trans' fs_info field
      btrfs: Remove fs_info argument from add_block_group_free_space
      btrfs: Remove fs_info argument from __add_block_group_free_space
      btrfs: Remove fs_info argument from __add_to_free_space_tree
      btrfs: Remove fs_info parameter from add_new_free_space_info
      btrfs: Remove fs_info argument from add_new_free_space
      btrfs: Remove fs_info parameter from remove_block_group_free_space
      btrfs: Remove fs_info argument from convert_free_space_to_bitmaps
      btrfs: Remove fs_info parameter from convert_free_space_to_extents
      btrfs: Remove fs_info argument from update_free_space_extent_count
      btrfs: Remove fs_info argument from modify_free_space_bitmap
      btrfs: Remove fs_info argument from add_free_space_extent
      btrfs: Remove fs_info argument from remove_free_space_extent
      btrfs: Remove fs_info argument from __remove_from_free_space_tree
      btrfs: Remove fs_info argument from remove_from_free_space_tree
      btrfs: Remove fs_info argument from add_to_free_space_tree
      btrfs: Remove fs_info argument from populate_free_space_tree
      btrfs: Unexport and rename btrfs_invalidate_inodes
      btrfs: Remove stale comment about select_delayed_ref
      btrfs: Remove fs_info argument from alloc_reserved_tree_block
      btrfs: Simplify alloc_reserved_tree_block interface
      btrfs: Pass btrfs_delayed_extent_op to alloc_reserved_tree_block
      btrfs: Streamline shared ref check in alloc_reserved_tree_block
      btrfs: Factor out read portion of btrfs_get_blocks_direct
      btrfs: Factor out write portion of btrfs_get_blocks_direct

Omar Sandoval (16):
      Btrfs: update stale comments referencing vmtruncate()
      Btrfs: fix error handling in btrfs_truncate_inode_items()
      Btrfs: don't BUG_ON() in btrfs_truncate_inode_items()
      Btrfs: stop creating orphan items for truncate
      Btrfs: get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
      Btrfs: delete dead code in btrfs_orphan_commit_root()
      Btrfs: don't return ino to ino cache if inode item removal fails
      Btrfs: refactor btrfs_evict_inode() reserve refill dance
      Btrfs: fix ENOSPC caused by orphan items reservations
      Btrfs: get rid of unused orphan infrastructure
      Btrfs: renumber BTRFS_INODE_ runtime flags and switch to enums
      Btrfs: reserve space for O_TMPFILE orphan item deletion
      Btrfs: allow empty subvol= again
      Btrfs: fix clone vs chattr NODATASUM race
      Btrfs: fix memory and mount leak in btrfs_ioctl_rm_dev_v2()
      Btrfs: clean up error handling in btrfs_truncate()

Qu Wenruo (15):
      btrfs: print-tree: Add eb locking status output for debug build
      btrfs: trace: Remove unnecessary fs_info parameter for btrfs__reserve_extent event class
      btrfs: trace: Add trace points for unused block groups
      btrfs: trace: Allow trace_qgroup_update_counters() to record old rfer/excl value
      btrfs: qgroup: Allow trace_btrfs_qgroup_account_extent() to record its transid
      btrfs: Move btrfs_check_super_valid() to avoid forward declaration
      btrfs: Refactor btrfs_check_super_valid
      btrfs: Do super block verification before writing it to disk
      btrfs: qgroup: Search commit root for rescan to avoid missing extent
      btrfs: qgroup: Finish rescan when hit the last leaf of extent tree
      btrfs: compression: Add linux/sizes.h for compression.h
      btrfs: lzo: document the compressed data format
      btrfs: lzo: Add header length check to avoid potential out-of-bounds access
      btrfs: lzo: Harden inline lzo compressed extent decompression
      btrfs: qgroup: show more meaningful qgroup_rescan_init error message

Robbie Ko (2):
      btrfs: incremental send, move allocation until it's needed in orphan_dir_info
      btrfs: incremental send, improve rmdir performance for large directory

Su Yue (3):
      btrfs: rename btrfs_get_block_group_info and make it static
      btrfs: return error value if create_io_em failed in cow_file_range
      btrfs: return ENOMEM if path allocation fails in btrfs_cross_ref_exist

Timofey Titovets (3):
      Btrfs: split btrfs_extent_same
      Btrfs: dedupe_file_range ioctl: remove 16MiB restriction
      Btrfs: reuse cmp workspace in EXTENT_SAME ioctl

Tomohiro Misono (4):
      btrfs: sysfs: Use enum/define value for feature array definitions
      btrfs: Add unprivileged ioctl which returns subvolume information
      btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF
      btrfs: Add unprivileged version of ino_lookup ioctl

 fs/btrfs/btrfs_inode.h                 |   22 +-
 fs/btrfs/compression.c                 |    7 +-
 fs/btrfs/compression.h                 |    2 +
 fs/btrfs/ctree.c                       |  123 +--
 fs/btrfs/ctree.h                       |   76 +-
 fs/btrfs/delayed-inode.c               |    9 +-
 fs/btrfs/delayed-ref.c                 |  275 +++----
 fs/btrfs/delayed-ref.h                 |    5 +-
 fs/btrfs/dev-replace.c                 |  150 +++-
 fs/btrfs/disk-io.c                     |  391 +++++----
 fs/btrfs/extent-tree.c                 |  253 +++---
 fs/btrfs/extent_io.c                   |   62 +-
 fs/btrfs/extent_io.h                   |   20 +-
 fs/btrfs/extent_map.c                  |    6 +-
 fs/btrfs/extent_map.h                  |    3 +-
 fs/btrfs/free-space-cache.c            |    6 +-
 fs/btrfs/free-space-tree.c             |  192 +++--
 fs/btrfs/free-space-tree.h             |    8 -
 fs/btrfs/inode.c                       | 1371 ++++++++++++++++----------------
 fs/btrfs/ioctl.c                       | 1210 ++++++++++++++++++----------
 fs/btrfs/locking.c                     |   34 +-
 fs/btrfs/lzo.c                         |   76 +-
 fs/btrfs/ordered-data.c                |   14 +-
 fs/btrfs/print-tree.c                  |   21 +
 fs/btrfs/qgroup.c                      |   69 +-
 fs/btrfs/raid56.c                      |   38 +-
 fs/btrfs/relocation.c                  |    8 +-
 fs/btrfs/scrub.c                       |    1 +
 fs/btrfs/send.c                        |   46 +-
 fs/btrfs/super.c                       |    7 +-
 fs/btrfs/sysfs.c                       |   52 +-
 fs/btrfs/sysfs.h                       |    4 +-
 fs/btrfs/tests/btrfs-tests.c           |    4 +-
 fs/btrfs/tests/btrfs-tests.h           |    6 +-
 fs/btrfs/tests/extent-buffer-tests.c   |   56 +-
 fs/btrfs/tests/extent-io-tests.c       |   75 +-
 fs/btrfs/tests/extent-map-tests.c      |   90 ++-
 fs/btrfs/tests/free-space-tests.c      |  177 +++--
 fs/btrfs/tests/free-space-tree-tests.c |  129 +--
 fs/btrfs/tests/inode-tests.c           |  312 ++++----
 fs/btrfs/tests/qgroup-tests.c          |  100 +--
 fs/btrfs/transaction.c                 |   15 +-
 fs/btrfs/transaction.h                 |    1 -
 fs/btrfs/tree-log.c                    |   28 +-
 fs/btrfs/uuid-tree.c                   |   10 +-
 fs/btrfs/volumes.c                     |  506 ++++++------
 fs/btrfs/volumes.h                     |   24 +-
 include/trace/events/btrfs.h           |  323 ++++----
 include/uapi/linux/btrfs.h             |   97 +++
 49 files changed, 3579 insertions(+), 2935 deletions(-)
