Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47792 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729804AbeHMPgc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Aug 2018 11:36:32 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 4.19
Date: Mon, 13 Aug 2018 14:54:07 +0200
Message-Id: <cover.1534161966.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

there are mostly fixes and cleanups, nothing big, though the notable
thing is the inserted/deleted lines delta -1124.

There are no known pending merge conflicts with other trees. Please
pull, thanks.


User visible changes:

* allow defrag on opened read-only files that have rw permissions; similar
  to what dedupe will allow on such files


Core changes:

* tree checker improvements, reported by fuzzing:
  * more checks for: block group items, essential trees
  * chunk type validation
  * mount time cross-checks that physical and logical chunks match
  * switch more error codes to EUCLEAN aka. EFSCORRUPTED


Fixes:

* fsync corner case fixes

* fix send failure when root has deleted files still open

* send, fix incorrect file layout after hole punching beyond eof

* fix races between mount and deice scan ioctl, found by fuzzing

* fix deadlock when delayed iput is called from writeback on the same
  inode; rare but has been observed in practice, also removes code

* fix pinned byte accounting, using the right percpu helpers; this should
  avoid some write IO inefficiency during low space conditions

* don't remove block group that still has pinned bytes

* reset on-disk device stats value after replace, otherwise this would
  report stale values for the new device


Cleanups:

* time64_t/timespec64 cleanups

* remove remaining dead code in scrub handling NOCOW extents after
  disabling it in previous cycle

* simplify fsync regarding ordered extents logic and remove all the
  related code

* remove redundant arguments in order to reduce stack space consumption

* remove support for V0 type of extents, not in use since 2.6.30

* remove several unused structure members

* fewer indirect function calls by inlining some callbacks

* qgroup rescan timing fixes

* vfs: iget cleanups

----------------------------------------------------------------
The following changes since commit 1ffaddd029c867d134a1dde39f540dcc8c52e274:

  Linux 4.18-rc8 (2018-08-05 12:37:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.19-tag

for you to fetch changes up to 39379faaad79e3cf403a6904a08676b7850043ae:

  btrfs: revert fs_devices state on error of btrfs_init_new_device (2018-08-06 13:13:04 +0200)

----------------------------------------------------------------
Adam Borowski (1):
      btrfs: allow defrag on a file opened read-only that has rw permissions

Al Viro (4):
      btrfs: btrfs_iget never returns an is_bad_inode inode
      btrfs: simplify IS_ERR/PTR_ERR checks
      btrfs: lift make_bad_inode into btrfs_iget
      btrfs: simplify btrfs_iget

Allen Pais (1):
      btrfs: replace get_seconds with new 64bit time API

Anand Jain (9):
      btrfs: use a temporary variable for fs_devices in btrfs_init_new_device
      btrfs: drop unnecessary variable in btrfs_init_new_device
      btrfs: fix in-memory value of total_devices after seed device deletion
      btrfs: do btrfs_free_stale_devices outside of device_list_add
      btrfs: extend locked section when adding a new device in device_list_add
      btrfs: rename local devices for fs_devices in btrfs_free_stale_devices(
      btrfs: use device_list_mutex when removing stale devices
      btrfs: rename btrfs_parse_early_options
      btrfs: use the assigned fs_devices instead of the dereference

Arnd Bergmann (2):
      btrfs: use monotonic time for transaction handling
      btrfs: use timespec64 for i_otime

Bart Van Assche (3):
      btrfs: Fix misleading indentation reported by smatch
      btrfs: Annotate fall-through when parsing mount option
      btrfs: Fix a C compliance issue

Chengguang Xu (5):
      btrfs: return error instead of crash when detecting unexpected type in btrfs_get_acl
      btrfs: replace empty string with NULL when getting attribute length in btrfs_get_acl
      btrfs: remove unnecessary -ERANGE check in btrfs_get_acl
      btrfs: avoid error code override in btrfs_get_acl
      btrfs: remove unnecessary curly braces in btrfs_get_acl

David Sterba (34):
      btrfs: remove remaing full_sync logic from btrfs_sync_file
      btrfs: annotate unlikely branches after V0 extent type removal
      btrfs: simplify some assignments of inode numbers
      btrfs: simplify pointer chasing of local fs_info variables
      btrfs: use copy_page for copying pages instead of memcpy
      btrfs: prune unused includes
      btrfs: pass only eb to num_extent_pages
      btrfs: use round_up wrapper in num_extent_pages
      btrfs: switch types to int when counting eb pages
      btrfs: open-code bio_set_op_attrs
      btrfs: raid56: add new helper for starting async work
      btrfs: raid56: use new helper for async_rmw_stripe
      btrfs: raid56: use new helper for async_read_rebuild
      btrfs: raid56: use new helper for async_scrub_parity
      btrfs: raid56: merge rbio_is_full helpers
      btrfs: raid56: catch errors from full_stripe_write
      btrfs: lift uuid_mutex to callers of btrfs_scan_one_device
      btrfs: lift uuid_mutex to callers of btrfs_open_devices
      btrfs: lift uuid_mutex to callers of btrfs_parse_early_options
      btrfs: reorder initialization before the mount locks uuid_mutex
      btrfs: fix mount and ioctl device scan ioctl race
      btrfs: refactor block group replication factor calculation to a helper
      btrfs: rename btrfs_release_extent_buffer_page
      btrfs: remove unused member async_submit_bio::fs_info
      btrfs: remove unused member async_submit_bio::bio_flags
      btrfs: unify end_io callbacks of async_submit_bio
      btrfs: drop extent_io_ops::tree_fs_info callback
      btrfs: drop extent_io_ops::merge_bio_hook callback
      btrfs: drop extent_io_ops::set_range_writeback callback
      btrfs: remove unused member btrfs_root::name
      btrfs: dev-replace: remove unused members of btrfs_dev_replace
      btrfs: constify strings passed to assertion helper
      btrfs: merge free_fs_root helpers
      btrfs: extent-tree: remove unused member walk_control::for_reloc

Ethan Lien (2):
      btrfs: use correct compare function of dirty_metadata_bytes
      btrfs: use customized batch size for total_bytes_pinned

Filipe Manana (4):
      Btrfs: remove unused key assignment when doing a full send
      Btrfs: fix mount failure after fsync due to hard link recreation
      Btrfs: fix send failure when root has deleted files still open
      Btrfs: send, fix incorrect file layout after hole punching beyond eof

Geert Uytterhoeven (1):
      btrfs: Refactor count handling in btrfs_unpin_free_ino

Goldwyn Rodrigues (1):
      btrfs: Use iocb to derive pos instead of passing a separate parameter

Gu Jinxiang (4):
      btrfs: remove unused parameter from btrfs_parse_subvol_options
      btrfs: make fs_devices a local variable in btrfs_parse_early_options
      btrfs: return device pointer from btrfs_scan_one_device
      btrfs: validate type when reading a chunk

Josef Bacik (6):
      btrfs: always wait on ordered extents at fsync time
      btrfs: remove the wait ordered logic in the log_one_extent path
      btrfs: clean up the left over logged_list usage
      btrfs: remove the logged extents infrastructure
      Btrfs: fix btrfs_write_inode vs delayed iput deadlock
      btrfs: don't leak ret from do_chunk_alloc

Lu Fengqi (27):
      btrfs: qgroup: cleanup the unused srcroot from btrfs_qgroup_inherit
      btrfs: qgroup: Drop quota_root parameter from add_qgroup_relation_item
      btrfs: qgroup: Drop quota_root parameter from del_qgroup_relation_item
      btrfs: qgroup: Drop quota_root parameter from del_qgroup_item
      btrfs: qgroup: Drop root parameter from update_qgroup_limit_item
      btrfs: qgroup: Drop root parameter from update_qgroup_info_item
      btrfs: qgroup: Drop quota_root and fs_info parameters from update_qgroup_status_item
      btrfs: qgroup: Drop fs_info parameter from btrfs_add_qgroup_relation
      btrfs: qgroup: Drop fs_info parameter from __del_qgroup_relation
      btrfs: qgroup: Drop fs_info parameter from btrfs_del_qgroup_relation
      btrfs: qgroup: Drop fs_info parameter from btrfs_create_qgroup
      btrfs: qgroup: Drop fs_info parameter from btrfs_remove_qgroup
      btrfs: qgroup: Drop fs_info parameter from btrfs_limit_qgroup
      btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_trace_extent
      btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_trace_leaf_items
      btrfs: qgroup: Drop root parameter from btrfs_qgroup_trace_subtree
      btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_account_extent
      btrfs: qgroup: Drop fs_info parameter from btrfs_run_qgroups
      btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_inherit
      btrfs: qgroup: Drop fs_info parameter from qgroup_rescan_leaf
      btrfs: Remove fs_info from btrfs_insert_delayed_dir_index
      btrfs: Remove fs_info from btrfs_delete_delayed_dir_index
      btrfs: Remove fs_info from btrfs_del_root
      btrfs: Remove fs_info from btrfs_del_root_ref
      btrfs: Remove fs_info from btrfs_add_root_ref
      btrfs: Remove root parameter from btrfs_unlink_subvol
      btrfs: Remove redundant btrfs_release_path from btrfs_unlink_subvol

Misono Tomohiro (4):
      btrfs: backref: Use ERR_CAST to return error code
      btrfs: extent-tree: Remove unused __btrfs_free_block_rsv
      btrfs: replace: Reset on-disk dev stats value after replace
      btrfs: Use wrapper macro for rcu string to remove duplicate code

Naohiro Aota (1):
      btrfs: revert fs_devices state on error of btrfs_init_new_device

Nikolay Borisov (55):
      btrfs: Document __btrfs_inc_extent_ref
      btrfs: Fix comment in lookup_inline_extent_backref
      btrfs: Streamline log_extent_csums a bit
      btrfs: Remove fs_info from insert_tree_block_ref
      btrfs: Remove fs_info from insert_extent_data_ref
      btrfs: Remove fs_info argument from insert_extent_backref
      btrfs: Remove fs_info from remove_extent_data_ref
      btrfs: Remove fs_info from fixup_low_keys
      btrfs: Remove fs_info from lookup_inline_extent_backref
      btrfs: Remove fs_info argument from update_inline_extent_backref
      btrfs: Remove fs_info argument from lookup_tree_block_ref
      btrfs: Remove fs_info argument from lookup_extent_data_ref
      btrfs: Remove fs_info from lookup_extent_backref
      btrfs: Remove fs_info from btrfs_add_delayed_tree_ref
      btrfs: Remove fs_info from btrfs_add_delayed_data_ref
      btrfs: Remove fs_info from btrfs_make_block_group
      btrfs: Remove fs_info from btrfs_remove_block_group
      btrfs: Remove fs_info from __btrfs_free_extent
      btrfs: Remove fs_info from alloc_reserved_file_extent
      btrfs: Remove fs_info argument from __btrfs_inc_extent_ref
      btrfs: Remove fs_info from run_delayed_data_ref
      btrfs: Remove fs_info from run_delayed_extent_op
      btrfs: Remove unused fs_info from cleanup_extent_op
      btrfs: Remove fs_info from cleanup_ref_head
      btrfs: Remove fs_info from run_delayed_tree_ref
      btrfs: Remove fs_info from do_chunk_alloc
      btrfs: Remove fs_info from btrfs_alloc_chunk
      btrfs: Remove fs_info from check_system_chunk
      btrfs: Remove fs_info from free_excluded_extents
      btrfs: Remove fs_info from exclude_super_stripes
      btrfs: Remove fs_info from insert_inline_extent_backref
      btrfs: Remove fs_info from run_one_delayed_ref
      btrfs: Remove fs_info from remove_extent_backref
      btrfs: Remove fs_info from btrfs_alloc_logged_file_extent
      btrfs: Remove fs_info from btrfs_inc_block_group_ro
      btrfs: Remove fs_info from btrfs_force_chunk_alloc
      btrfs: Deduplicate extent_buffer init code
      btrfs: Streamline memory allocation failure handling in btrfs_add_delayed_tree_ref
      btrfs: Remove V0 extent support
      btrfs: Add graceful handling of V0 extents
      btrfs: qgroups: Move transaction management inside btrfs_quota_enable/disable
      btrfs: close devices without offloading to a temporary list
      btrfs: Rewrite retry logic in do_chunk_alloc
      btrfs: Simplify page unlocking in alloc_extent_buffer
      btrfs: Reword dodgy comments in alloc_extent_buffer
      btrfs: Refactor loop in btrfs_release_extent_buffer_page
      btrfs: Document locking requirement via lockdep_assert_held
      btrfs: Rename EXTENT_BUFFER_DUMMY to EXTENT_BUFFER_UNMAPPED
      btrfs: Remove fs_info argument from btrfs_add_dev_item
      btrfs: Remove fs_info from btrfs_rm_dev_replace_remove_srcdev
      btrfs: remove fs_info argument from update_dev_stat_item
      btrfs: Remove fs_info from btrfs_assign_next_active_device
      btrfs: Remove fs_info from btrfs_destroy_dev_replace_tgtdev
      btrfs: Remove fs_info form btrfs_free_chunk
      btrfs: Remove fs_info from btrfs_finish_chunk_alloc

Qu Wenruo (15):
      btrfs: scrub: Remove unused copy_nocow_pages and its callchain
      btrfs: check-integrity: Fix NULL pointer dereference for degraded mount
      btrfs: Get rid of the confusing btrfs_file_extent_inline_len
      btrfs: Don't remove block group that still has pinned down bytes
      btrfs: tree-checker: Verify block_group_item
      btrfs: tree-checker: Detect invalid and empty essential trees
      btrfs: relocation: Only remove reloc rb_trees if reloc control has been initialized
      btrfs: Remove unused function btrfs_account_dev_extents_size
      btrfs: Use btrfs_mark_bg_unused to replace open code
      btrfs: scrub: cleanup the remaining nodatasum fixup code
      btrfs: extent-tree: Remove dead alignment check
      btrfs: Check that each block group has corresponding chunk at mount time
      btrfs: Verify that every chunk has corresponding block group at mount time
      btrfs: Introduce mount time chunk <-> dev extent mapping check
      btrfs: Exit gracefully when chunk map cannot be inserted to the tree

Su Yue (2):
      btrfs: print more details when checking tree block finds a problem
      btrfs: return EUCLEAN if extent_inline_ref type is invalid

Zhihui Zhang (1):
      Btrfs: free space cache: make sure there is always room for generation number

 fs/btrfs/acl.c                |  13 +-
 fs/btrfs/backref.c            |   6 +-
 fs/btrfs/btrfs_inode.h        |   2 +-
 fs/btrfs/check-integrity.c    |   9 +-
 fs/btrfs/compression.c        |  18 +-
 fs/btrfs/ctree.c              |  53 +--
 fs/btrfs/ctree.h              |  89 ++---
 fs/btrfs/delayed-inode.c      |  14 +-
 fs/btrfs/delayed-inode.h      |   2 -
 fs/btrfs/delayed-ref.c        |  43 +-
 fs/btrfs/delayed-ref.h        |   6 +-
 fs/btrfs/dev-replace.c        |  29 +-
 fs/btrfs/dir-item.c           |   4 +-
 fs/btrfs/disk-io.c            | 113 ++----
 fs/btrfs/disk-io.h            |   5 +-
 fs/btrfs/extent-tree.c        | 883 +++++++++++++++++++-----------------------
 fs/btrfs/extent_io.c          | 156 ++++----
 fs/btrfs/extent_io.h          |  16 +-
 fs/btrfs/file-item.c          |   4 +-
 fs/btrfs/file.c               | 128 +-----
 fs/btrfs/free-space-cache.c   |  19 +-
 fs/btrfs/free-space-tree.c    |   2 +-
 fs/btrfs/inode-map.c          |  12 +-
 fs/btrfs/inode.c              | 161 +++-----
 fs/btrfs/ioctl.c              |  69 ++--
 fs/btrfs/ordered-data.c       | 138 -------
 fs/btrfs/ordered-data.h       |  23 +-
 fs/btrfs/print-tree.c         |  39 +-
 fs/btrfs/qgroup.c             | 270 +++++++------
 fs/btrfs/qgroup.h             |  46 +--
 fs/btrfs/raid56.c             | 109 ++----
 fs/btrfs/reada.c              |   3 +-
 fs/btrfs/relocation.c         | 216 ++---------
 fs/btrfs/root-tree.c          |  22 +-
 fs/btrfs/scrub.c              | 679 +-------------------------------
 fs/btrfs/send.c               | 172 ++++++--
 fs/btrfs/struct-funcs.c       |   1 -
 fs/btrfs/super.c              | 115 +++---
 fs/btrfs/sysfs.c              |   2 -
 fs/btrfs/tests/qgroup-tests.c |  24 +-
 fs/btrfs/transaction.c        |  11 +-
 fs/btrfs/transaction.h        |   2 +-
 fs/btrfs/tree-checker.c       | 115 +++++-
 fs/btrfs/tree-log.c           | 270 +++++--------
 fs/btrfs/volumes.c            | 611 ++++++++++++++++++-----------
 fs/btrfs/volumes.h            |  31 +-
 include/trace/events/btrfs.h  |   3 +-
 47 files changed, 1817 insertions(+), 2941 deletions(-)
