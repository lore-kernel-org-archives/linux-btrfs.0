Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750722AbeDCN6o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 09:58:44 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 4.17
Date: Tue,  3 Apr 2018 15:56:02 +0200
Message-Id: <cover.1522762769.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following btrfs changes. There are a several user
visible changes, the rest is mostly invisible and continues to clean up
the whole code base.

There are no merge conflicts with current master. Please pull, thanks.

User visible changes:

  - new mount option nossd_spread (pair for ssd_spread)

  - mount option subvolid will detect junk after the number and fail the mount

  - add message after cancelled device replace

  - direct module dependency on libcrc32, removed own crc wrappers

  - removed user space transaction ioctls

  - use lighter locking when reading /proc/self/mounts, RCU instead of mutex
    to avoid unnecessary contention

Enhancements:

  - skip writeback of last page when truncating file to same size

  - send: do not issue unnecessary truncate operations

  - mount option token specifiers: use %u for unsigned values, more validation

  - selftests: more tree block validations

qgroups:

  - preparatory work for splitting reservation types for data and metadata,
    this should allow for more accurate tracking and fix some issues with
    underflows or do further enhancements

  - split metadata reservations for started and joined transaction so they do
    not get mixed up and are accounted correctly at commit time

  - with the above, it's possible to revert patch that potentially deadlocks
    when trying to make more space by explicitly committing when the quota
    limit is hit

  - fix root item corruption when multiple same source snapshots are created
    with quota enabled

RAID56:

  - make sure target is identical to source when raid56 rebuild fails after
    dev-replace

  - faster rebuild during scrub, batch by stripes and not block-by-block

  - make more use of cached data when rebuilding from a missing device

Fixes:

  - null pointer deref when device replace target is missing

  - fix fsync after hole punching when using no-holes feature

  - fix lockdep splat when allocating percpu data with wrong GFP flags

Cleanups, refactoring, core changes:

  - drop redunant parameters from various functions

  - kill and opencode trivial helpers

  - __cold/__exit function annotations

  - dead code removal

  - continued audit and documentation of memory barriers

  - error handling: handle removal from uuid tree

  - error handling: remove handling of impossible condtitons

  - more debugging or error messages

  - updated tracepoints

  - 1 VLA use removal (1 still left)

----------------------------------------------------------------
The following changes since commit 3eb2ce825ea1ad89d20f7a3b5780df850e4be274:

  Linux 4.16-rc7 (2018-03-25 12:44:30 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.17-tag

for you to fetch changes up to 57599c7e7722daf5f8c2dba4b0e4628f5c500771:

  btrfs: lift errors from add_extent_changeset to the callers (2018-03-31 02:03:25 +0200)

----------------------------------------------------------------
Anand Jain (25):
      btrfs: open code btrfs_dev_replace_cancel()
      btrfs: rename __btrfs_dev_replace_cancel()
      btrfs: btrfs_dev_replace_cancel() can return int
      btrfs: open code btrfs_init_dev_replace_tgtdev_for_resume()
      btrfs: extent_buffer_uptodate() make it static and inline
      btrfs: manage thread_pool mount option as %u
      btrfs: manage metadata_ratio mount option as %u
      btrfs: manage check_int_print_mask mount option as %u
      btrfs: manage commit mount option as %u
      btrfs: add a comment to mark the deprecated mount option
      btrfs: fix null pointer deref when target device is missing
      btrfs: log, when replace, is canceled by the user
      btrfs: remove unused function btrfs_async_submit_limit()
      btrfs: cow_file_range() num_bytes and disk_num_bytes are same
      btrfs: use ASSERT to report logical error in cow_file_range()
      btrfs: not a disk error if the bio_add_page fails
      btrfs: keep device list sorted
      btrfs: insert newly opened device to the end of the list
      btrfs: verify subvolid mount parameter
      btrfs: remove assert in btrfs_init_dev_replace_tgtdev()
      btrfs: unify types for metadata_ratio and data_chunk_allocations
      btrfs: rename btrfs_close_extra_device to btrfs_free_extra_devids
      btrfs: add define for oldest generation
      btrfs: drop num argument from find_live_mirror()
      btrfs: drop optimal argument from find_live_mirror()

Colin Ian King (2):
      btrfs: remove redundant check on ret and goto
      Btrfs: extent map selftest: add missing void parameter to btrfs_test_extent_map

David Sterba (37):
      btrfs: add (the only possible) __exit annotation
      btrfs: add more __cold annotations
      btrfs: drop underscores from exported xattr functions
      btrfs: drop extern from function declarations
      btrfs: adjust return type of btrfs_getxattr
      btrfs: move btrfs_listxattr prototype to xattr.h
      btrfs: open code trivial helper btrfs_page_exists_in_range
      btrfs: sort and group mount option definitions
      btrfs: assume that bio_ret is always valid in submit_extent_page
      btrfs: remove redundant variable in __do_readpage
      btrfs: cleanup merging conditions in submit_extent_page
      btrfs: document more parameters of submit_extent_page
      btrfs: drop fs_info parameter from tree_mod_log_set_node_key
      btrfs: drop fs_info parameter from tree_mod_log_insert_move
      btrfs: drop fs_info parameter from tree_mod_log_insert_key
      btrfs: drop fs_info parameter from tree_mod_log_free_eb
      btrfs: drop fs_info parameter from tree_mod_log_free_eb
      btrfs: drop unused fs_info parameter from tree_mod_log_eb_move
      btrfs: embed tree_mod_move structure to tree_mod_elem
      btrfs: drop fs_info parameter from __tree_mod_log_oldest_root
      btrfs: remove trivial locking wrappers of tree mod log
      btrfs: kill trivial wrapper tree_mod_log_eb_move
      btrfs: kill tree_mod_log_set_node_key helper
      btrfs: kill tree_mod_log_set_root_pointer helper
      btrfs: separate types for submit_bio_start and submit_bio_done
      btrfs: remove unused parameters from extent_submit_bio_start_t
      btrfs: remove unused parameters from extent_submit_bio_done_t
      btrfs: rename submit callbacks and drop double underscores
      btrfs: use helper to set ulist aux from a qgroup
      btrfs: use lockdep_assert_held for spinlocks
      btrfs: use lockdep_assert_held for mutexes
      btrfs: update barrier in should_cow_block
      btrfs: use RCU in btrfs_show_devname for device list traversal
      btrfs: remove stale comments about fs_mutex
      btrfs: split dev-replace locking helpers for read and write
      btrfs: user proper type for btrfs_mask_flags flags
      btrfs: lift errors from add_extent_changeset to the callers

Filipe Manana (4):
      Btrfs: skip writeback of last page when truncating file to same size
      Btrfs: send, do not issue unnecessary truncate operations
      Btrfs: fix fsync after hole punching when using no-holes feature
      Btrfs: fix copy_items() return value when logging an inode

Gu JinXiang (1):
      btrfs: use reada direction enum instead of constant value in load_free_space_tree

Gu Jinxiang (1):
      btrfs: use reada direction enum instead of constant value in populate_free_space_tree

Howard McLauchlan (2):
      btrfs: print error if primary super block write fails
      btrfs: Add nossd_spread mount option

Jeff Mahoney (3):
      btrfs: fix lockdep splat in btrfs_alloc_subvolume_writers
      btrfs: remove dead create_space_info calls
      btrfs: defer adding raid type kobject until after chunk relocation

Liu Bo (11):
      Btrfs: enhance leak debug checker for extent state and extent buffer
      Btrfs: do not check inode's runtime flags under root->orphan_lock
      Btrfs: add tracepoint for em's EEXIST case
      Btrfs: fix unexpected cow in run_delalloc_nocow
      Btrfs: dev-replace: skip prealloc extents when copy nocow pages
      Btrfs: send: fix typo in TLV_PUT
      Btrfs: raid56: remove redundant async_missing_raid56
      Btrfs: dev-replace: make sure target is identical to source when raid56 rebuild fails
      Btrfs: scrub: batch rebuild for raid56
      Btrfs: replace: cache rbio when rebuild data on missing device
      Btrfs: print error messages when failing to read trees

Matthew Wilcox (1):
      btrfs: Use filemap_range_has_page()

Misono, Tomohiro (1):
      btrfs: ctree.h: Fix wrong comment position about csum size

Nikolay Borisov (50):
      btrfs: Remove unused btrfs_start_transaction_lflush function
      btrfs: Don't hardcode the csum size in btrfs_ordered_sum_size
      btrfs: Make btrfs_trans_release_metadata private to transaction.c
      btrfs: Open code btrfs_write_and_wait_marked_extents
      btrfs: Remove fs_info argument from btrfs_trans_release_metadata
      btrfs: Remove fs_info argument from btrfs_create_pending_block_groups
      btrfs: Don't pass fs_info arg to btrfs_start_dirty_block_groups
      btrfs: Don't pass fs_info to __btrfs_run_delayed_items
      btrfs: Don't pass fs_info to btrfs_run_delayed_items/_nr
      btrfs: Don't pass fs_info to commit_fs_roots
      btrfs: Don't pass fs_info to commit_cowonly_roots
      btrfs: Remove root argument of cleanup_transaction
      btrfs: Remove fs_info argument from switch_commit_roots
      btrfs: Remove fs_info argument from create_pending_snapshots/create_pending_snapshot
      btrfs: Remove fs_info argument from btrfs_update_commit_device_bytes_used
      btrfs: Remove fs_info argument of btrfs_write_and_wait_transaction
      btrfs: Remove invalid null checks from btrfs_cleanup_dirty_bgs
      btrfs: Document consistency of transaction->io_bgs list
      btrfs: Add enospc_debug printing in metadata_reserve_bytes
      btrfs: Move error handling of btrfs_start_dirty_block_groups closer to call site
      btrfs: Use schedule_timeout_interruptible
      btrfs: Streamline btrfs_delalloc_reserve_metadata initial operations
      btrfs: Remove btrfs_inode::delayed_iput_count
      btrfs: Move qgroup rescan on quota enable to btrfs_quota_enable
      libcrc32c: Add crc32c_impl function
      btrfs: Remove custom crc32c init code
      btrfs: Remove redundant memory barriers around dio_private error status
      btrfs: Remove redundant comment from btrfs_search_forward
      btrfs: Remove root arg from btrfs_log_inode_parent
      btrfs: Remove root argument from btrfs_log_dentry_safe
      btrfs: Remove root argument from cow_file_range_inline
      btrfs: Relax memory barrier in btrfs_tree_unlock
      btrfs: Remove userspace transaction ioctls
      btrfs: Remove btrfs_file_private::trans
      btrfs: Remove code referencing unused TRANS_USERSPACE
      btrfs: Remove btrfs_fs_info::open_ioctl_trans
      btrfs: Use sizeof directly instead of a constant variable
      btrfs: Handle error from btrfs_uuid_tree_rem call in _btrfs_ioctl_set_received_subvol
      btrfs: Document parameters of btrfs_reserve_extent
      btrfs: Remove unused op_key var from add_delayed_refs
      btrfs: Remove unused length var from scrub_handle_errored_block
      btrfs: Remove unused tot_len var from lzo_decompress
      btrfs: Remove unused root var from relink_file_extents
      btrfs: remove max_active var from open_ctree
      btrfs: Remove unused extent_root var from caching_thread
      btrfs: Remove unused flush var in shrink_delalloc
      btrfs: drop fs_info parameter from btrfs_run_delayed_refs
      btrfs: Drop fs_info parameter from btrfs_qgroup_account_extents
      btrfs: Drop fs_info parameter from btrfs_finish_extent_commit
      btrfs: Drop fs_info parameter from __btrfs_run_delayed_refs

Omar Sandoval (1):
      Btrfs: delete dead code in btrfs_orphan_add()

Qu Wenruo (23):
      btrfs: Refactor parameter of BTRFS_MAX_DEVS() from root to fs_info
      btrfs: Add chunk allocation ENOSPC debug message for enospc_debug mount option
      btrfs: volumes: Cleanup stripe size calculation
      btrfs: tree-checker: Replace root parameter with fs_info
      btrfs: Refactor __get_raid_index() to btrfs_bg_flags_to_raid_index()
      btrfs: qgroup: Fix root item corruption when multiple same source snapshots are created with quota enabled
      btrfs: volumes: Remove the meaningless condition of minimal nr_devs when allocating a chunk
      btrfs: qgroup: Skeleton to support separate qgroup reservation type
      btrfs: qgroup: Introduce helpers to update and access new qgroup rsv
      btrfs: qgroup: Make qgroup_reserve and its callers to use separate reservation type
      btrfs: qgroup: Fix wrong qgroup reservation update for relationship modification
      btrfs: qgroup: Update trace events to use new separate rsv types
      btrfs: qgroup: Cleanup the remaining old reservation counters
      btrfs: qgroup: Split meta rsv type into meta_prealloc and meta_pertrans
      btrfs: qgroup: Don't use root->qgroup_meta_rsv for qgroup
      btrfs: qgroup: Introduce function to convert META_PREALLOC into META_PERTRANS
      btrfs: qgroup: Use separate meta reservation type for delalloc
      btrfs: delayed-inode: Use new qgroup meta rsv for delayed inode and item
      btrfs: qgroup: Use root::qgroup_meta_rsv_* to record qgroup meta reserved space
      btrfs: qgroup: Update trace events for metadata reservation
      Revert "btrfs: qgroups: Retry after commit on getting EDQUOT"
      btrfs: tests/qgroup: Fix wrong tree backref level
      btrfs: Validate child tree block's level and first key

Su Yue (1):
      btrfs: adjust return values of btrfs_inode_by_name

Yang Shi (1):
      btrfs: remove unused hardirq.h

 fs/btrfs/Kconfig                  |   3 +-
 fs/btrfs/Makefile                 |   2 +-
 fs/btrfs/acl.c                    |  14 +-
 fs/btrfs/backref.c                |  13 +-
 fs/btrfs/backref.h                |   2 +-
 fs/btrfs/btrfs_inode.h            |   3 -
 fs/btrfs/check-integrity.c        |   4 +-
 fs/btrfs/compression.c            |   2 +-
 fs/btrfs/compression.h            |   2 +-
 fs/btrfs/ctree.c                  | 263 +++++++++++-------------
 fs/btrfs/ctree.h                  |  86 ++++----
 fs/btrfs/delayed-inode.c          |  62 +++---
 fs/btrfs/delayed-inode.h          |   8 +-
 fs/btrfs/delayed-ref.c            |   8 +-
 fs/btrfs/delayed-ref.h            |   2 +-
 fs/btrfs/dev-replace.c            | 130 ++++++------
 fs/btrfs/dev-replace.h            |   9 +-
 fs/btrfs/dir-item.c               |   1 -
 fs/btrfs/disk-io.c                | 226 ++++++++++++++-------
 fs/btrfs/disk-io.h                |  15 +-
 fs/btrfs/extent-tree.c            | 317 +++++++++++++++--------------
 fs/btrfs/extent_io.c              |  82 ++++----
 fs/btrfs/extent_io.h              |  19 +-
 fs/btrfs/extent_map.c             |   6 +-
 fs/btrfs/extent_map.h             |   2 +-
 fs/btrfs/file.c                   |  30 ++-
 fs/btrfs/free-space-cache.c       |   2 +-
 fs/btrfs/free-space-tree.c        |   4 +-
 fs/btrfs/hash.c                   |  54 -----
 fs/btrfs/hash.h                   |  43 ----
 fs/btrfs/inode-item.c             |   1 -
 fs/btrfs/inode-map.c              |   4 +-
 fs/btrfs/inode.c                  | 335 ++++++++++++-------------------
 fs/btrfs/ioctl.c                  | 127 ++----------
 fs/btrfs/locking.c                |   2 +-
 fs/btrfs/lzo.c                    |   2 -
 fs/btrfs/ordered-data.c           |   4 +-
 fs/btrfs/ordered-data.h           |   6 +-
 fs/btrfs/print-tree.c             |  10 +-
 fs/btrfs/props.c                  |   8 +-
 fs/btrfs/qgroup.c                 | 406 ++++++++++++++++++++++++++------------
 fs/btrfs/qgroup.h                 | 106 +++++++++-
 fs/btrfs/raid56.c                 |  28 +--
 fs/btrfs/reada.c                  |  10 +-
 fs/btrfs/ref-verify.c             |   7 +-
 fs/btrfs/relocation.c             |  34 +++-
 fs/btrfs/scrub.c                  | 126 ++++++++----
 fs/btrfs/send.c                   |  35 +++-
 fs/btrfs/super.c                  | 259 ++++++++++++------------
 fs/btrfs/sysfs.c                  |   4 +-
 fs/btrfs/tests/btrfs-tests.c      |   3 +-
 fs/btrfs/tests/extent-map-tests.c |   2 +-
 fs/btrfs/tests/qgroup-tests.c     |   2 +-
 fs/btrfs/transaction.c            | 231 +++++++++++-----------
 fs/btrfs/transaction.h            |  25 ++-
 fs/btrfs/tree-checker.c           | 151 +++++++-------
 fs/btrfs/tree-checker.h           |   7 +-
 fs/btrfs/tree-defrag.c            |   5 +-
 fs/btrfs/tree-log.c               |  88 ++++++---
 fs/btrfs/tree-log.h               |   2 +-
 fs/btrfs/uuid-tree.c              |   2 +-
 fs/btrfs/volumes.c                | 162 +++++++++------
 fs/btrfs/volumes.h                |  31 ++-
 fs/btrfs/xattr.c                  |  12 +-
 fs/btrfs/xattr.h                  |   7 +-
 include/linux/crc32c.h            |   1 +
 include/trace/events/btrfs.h      | 108 +++++++++-
 lib/libcrc32c.c                   |   6 +
 68 files changed, 2075 insertions(+), 1698 deletions(-)
 delete mode 100644 fs/btrfs/hash.c
 delete mode 100644 fs/btrfs/hash.h
