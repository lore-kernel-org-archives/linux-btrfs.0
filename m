Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58105 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751810AbeA2VCp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 16:02:45 -0500
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs for 4.16
Date: Mon, 29 Jan 2018 22:00:26 +0100
Message-Id: <cover.1517259362.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the btrfs updates for this cycle are mostly cleanups with a few raid56 bugfixes
and some feature additions. Please pull, thanks.


Features or user visible changes:

- fallocate: implement zero range mode

- avoid losing data raid profile when deleting a device

- tree item checker: more checks for directory items and xattrs

Notable fixes:

- raid56 recovery: don't use cached stripes, that could be potentially changed
  and a later RMW or recovery would lead to corruptions or failures

- let raid56 try harder to rebuild damaged data, reading from all stripes if
  necessary

- fix scrub to repair raid56 in a similar way as in the case above

Other:

- cleanups: device freeing, removed some call indirections, redundant
  bio_put/_get, unused parameters, refactorings and renames

- RCU list traversal fixups

- simplify mount callchain, remove recursing back when mounting a subvolume

- plug for fsync, may improve bio merging on multiple devices

- compression heurisic: replace heap sort with radix sort, gains some
  performance

- add extent map selftests, buffered write vs dio

----------------------------------------------------------------

The following changes since commit 0c5b9b5d9adbad4b60491f9ba0d2af38904bb4b9:

  Linux 4.15-rc9 (2018-01-21 13:51:26 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.16-tag

for you to fetch changes up to 3acbcbfc8f06d4ade2aab2ebba0a2542a05ce90c:

  btrfs: drop devid as device_list_add() arg (2018-01-29 19:31:16 +0100)

----------------------------------------------------------------
Anand Jain (33):
      btrfs: clean up btrfs_dev_stat_inc usage
      btrfs: move volume_mutex into the btrfs_rm_device()
      btrfs: rename btrfs_add_device to btrfs_add_dev_item
      btrfs: set fs_devices->seed directly
      btrfs: move check for device generation to the last
      btrfs: factor __btrfs_open_devices() to create btrfs_open_one_device()
      btrfs: drop btrfs_device::can_discard to query directly
      btrfs: add helper for device path or missing
      btrfs: cleanup device states define BTRFS_DEV_STATE_WRITEABLE
      btrfs: cleanup device states define BTRFS_DEV_STATE_IN_FS_METADATA
      btrfs: cleanup device states define BTRFS_DEV_STATE_MISSING
      btrfs: cleanup device states define BTRFS_DEV_STATE_REPLACE_TGT
      btrfs: cleanup device states define BTRFS_DEV_STATE_FLUSH_SENT
      btrfs: put btrfs_ioctl_vol_args_v2 related defines together
      btrfs: factor btrfs_check_rw_degradable() to check given device
      btrfs: remove check for BTRFS_FS_STATE_ERROR which we just set
      btrfS: collapse btrfs_handle_error() into __btrfs_handle_fs_error()
      btrfs: rename btrfs_device::scrub_device to scrub_ctx
      btrfs: simplify mutex unlocking code in btrfs_commit_transaction
      btrfs: minor style cleanups in btrfs_scan_one_device
      btrfs: define SUPER_FLAG_METADUMP_V2
      btrfs: add support for SUPER_FLAG_CHANGING_FSID
      btrfs: fail mount when sb flag is not in BTRFS_SUPER_FLAG_SUPP
      btrfs: cleanup btrfs_free_stale_device() usage
      btrfs: no need to check for btrfs_fs_devices::seeding
      btrfs: make btrfs_free_stale_device() to iterate all stales
      btrfs: make btrfs_free_stale_devices() argument optional
      btrfs: rename btrfs_free_stale_devices() arg to skip_dev
      btrfs: make btrfs_free_stale_devices() to match the path
      btrfs: move pr_info into device_list_add
      btrfs: set the total_devices in device_list_add()
      btrfs: get device pointer from device_list_add()
      btrfs: drop devid as device_list_add() arg

Arnd Bergmann (1):
      btrfs: tree-checker: use %zu format string for size_t

Colin Ian King (1):
      btrfs: make function update_share_count static

David Sterba (46):
      btrfs: rename device free rcu helper to free_device_rcu
      btrfs: introduce free_device helper
      btrfs: use free_device where opencoded
      btrfs: simplify exit paths in btrfs_init_new_device
      btrfs: document device locking
      btrfs: simplify btrfs_close_bdev
      btrfs: switch to RCU for device traversal in btrfs_ioctl_dev_info
      btrfs: switch to RCU for device traversal in btrfs_ioctl_fs_info
      btrfs: use non-RCU list traversal in write_all_supers callees
      btrfs: prepare to drop gfp mask parameter from clear_extent_bit
      btrfs: sink gfp parameter to clear_extent_bit
      btrfs: sink gfp parameter to clear_extent_uptodate
      btrfs: use GFP_KERNEL in btrfs_alloc_inode
      btrfs: sink get_extent parameter to extent_writepages
      btrfs: sink get_extent parameter to extent_write_locked_range
      btrfs: sink get_extent parameter to extent_write_full_page
      btrfs: drop get_extent from extent_page_data
      btrfs: sink get_extent parameter to extent_fiemap
      btrfs: sink get_extent parameter to get_extent_skip_holes
      btrfs: sink get_extent parameter to extent_readpages
      btrfs: sink get_extent parameter to __extent_readpages
      btrfs: sink get_extent parameter to __do_contiguous_readpages
      btrfs: sink get_extent parameter to read_extent_buffer_pages
      btrfs: switch to on-stack csum buffer in csum_tree_block
      btrfs: switch btrfs_trans_handle::adding_csums to bool
      btrfs: remove unused member of btrfs_trans_handle
      btrfs: switch to refcount_t type for btrfs_trans_handle::use_count
      btrfs: reorder btrfs_trans_handle members for better packing
      btrfs: use narrower type for btrfs_transaction::num_dirty_bgs
      btrfs: reorder btrfs_transaction members for better packing
      btrfs: move some zstd work data from stack to workspace
      btrfs: compression: add helper for type to string conversion
      btrfs: SETFLAGS ioctl: use helper for compression type conversion
      btrfs: prop: use common helper for type to string conversion
      btrfs: show options: use helper to convert compression type string
      btrfs: merge two flush_write_bio helpers
      btrfs: sink flush_fn to extent_write_cache_pages
      btrfs: sink writepage parameter to extent_write_cache_pages
      btrfs: unify extent_page_data type passed as void
      btrfs: heuristic: open code get_num callback of radix sort
      btrfs: heuristic: open code copy_call callback of radix sort
      btrfs: heuristic: call get4bits directly
      btrfs: drop unused parameters from mount_subvol
      btrfs: add separate helper for unlock_extent_cached with GFP_ATOMIC
      btrfs: sink unlock_extent parameter gfp_flags
      btrfs: tree-check: reduce stack consumption in check_dir_item

Edmund Nadolski (2):
      btrfs: btrfs_inode_log_parent should use defined inode_only values.
      btrfs: remove dead code from btrfs_get_extent

Filipe Manana (4):
      Btrfs: add support for fallocate's zero range operation
      Btrfs: use cached state when dirtying pages during buffered write
      Btrfs: fix missing inode i_size update after zero range operation
      Btrfs: fix space leak after fallocate and zero range operations

Geert Uytterhoeven (1):
      btrfs: ref-verify: Remove unused parameter from walk_up_tree() to kill warning

Liu Bo (26):
      Btrfs: remove redundant btrfs_balance_delayed_items
      Btrfs: free btrfs_device in place
      Btrfs: remove rcu_barrier in btrfs_close_devices
      Btrfs: add __init macro to btrfs init functions
      Btrfs: document rules about bio async submit
      Btrfs: set plug for fsync
      Btrfs: remove unused variable wait in lock_stripe_add
      Btrfs: use struct completion in scrub_submit_raid56_bio_wait
      Btrfs: remove unused wait in btrfs_stripe_hash
      Btrfs: fix scrub to repair raid6 corruption
      Btrfs: make raid6 rebuild retry more
      Btrfs: remove redundant check in rbio_can_merge
      Btrfs: do not merge rbios if their fail stripe index are not identical
      Btrfs: avoid losing data raid profile when deleting a device
      Btrfs: raid56: iterate raid56 internal bio with bio_for_each_segment_all
      Btrfs: do not cache rbio pages if using raid6 recover
      Btrfs: raid56: fix race between merge_bio and rbio_orig_end_io
      Btrfs: fix incorrect block_len in merge_extent_mapping
      Btrfs: fix unexpected EEXIST from btrfs_get_extent
      Btrfs: add helper for em merge logic
      Btrfs: move extent map specific code to extent_map.c
      Btrfs: add extent map selftests
      Btrfs: extent map selftest: buffered write vs dio read
      Btrfs: extent map selftest: dio write vs dio read
      Btrfs: add WARN_ONCE to detect unexpected error from merge_extent_mapping
      Btrfs: noinline merge_extent_mapping

Matthew Wilcox (1):
      btrfs: Remove unused readahead spinlock

Misono, Tomohiro (6):
      btrfs: add btrfs_mount_root() and new file_system_type
      btrfs: cleanup btrfs_mount() using btrfs_mount_root()
      btrfs: split parse_early_options() in two
      btrfs: remove unused setup_root_args()
      btrfs: remove unused arg from parse_subvol_options()
      btrfs: cleanup unnecessary string dup in btrfs_parse_options()

Nikolay Borisov (25):
      btrfs: Fix memory barriers usage with device stats counters
      btrfs: Remove redundant memory barrier in dev stats
      btrfs: Remove unused function
      btrfs: Remove redundant mirror_num arg
      btrfs: Make btrfs_async_run_delayed_root use a loop rather than multiple labels
      btrfs: Move checks from btrfs_wq_run_delayed_node to btrfs_balance_delayed_items
      btrfs: Move loop termination condition in while()
      btrfs: Use locked_end rather than open coding it
      btrfs: Reduce scope of delayed_rsv->lock in may_commit_trans
      btrfs: Remove redundant FLAG_VACANCY
      btrfs: Remove unused variable in btrfs_get_extent
      btrfs: remove redundant check in btrfs_get_extent_fiemap
      btrfs: Handle btrfs_set_extent_delalloc failure in fixup worker
      btrfs: Fix out of bounds access in btrfs_search_slot
      btrfs: Remove pair of bio_get/put in btrfs_schedule_bio
      btrfs: sink extent_write_locked_range tree parameter
      btrfs: sink extent_write_full_page tree argument
      btrfs: Rename bin_search -> btrfs_bin_search
      btrfs: Improve btrfs_search_slot description
      btrfs: Remove redundant bio_get/set calls in compressed read/write paths
      btrfs: Remove redundant bio_get/set from submit_dio_repair_bio
      btrfs: Remove redundant bio_get/bio_set pair from submit_one_bio
      btrfs: Remove redundant pair of bio_get/set in __btrfs_submit_dio_bio
      btrfs: Make btrfs_inode_rsv_release static
      btrfs: Use IS_ALIGNED in btrfs_truncate_block instead of opencoding it

Pravin Shedge (1):
      btrfs: remove duplicate includes

Qu Wenruo (4):
      btrfs: Don't generate UUID for non-fs tree
      btrfs: tree-checker: Add checker for dir item
      btrfs: Cleanup existing name_len checks
      btrfs: extent-tree: Make btrfs_inode_rsv_refill function static

Su Yue (1):
      btrfs: correct wrong comment about magic number of index_cnt

Timofey Titovets (2):
      Btrfs: compression heuristic: replace heap sort with radix sort
      Btrfs: compress_file_range() change page dirty status once

Xiongfeng Wang (1):
      btrfs: use correct string length in DEV_INFO ioctl

 fs/btrfs/Makefile                 |   2 +-
 fs/btrfs/backref.c                |   3 +-
 fs/btrfs/compression.c            | 137 ++++++--
 fs/btrfs/compression.h            |   4 +-
 fs/btrfs/ctree.c                  |  56 ++--
 fs/btrfs/ctree.h                  |  12 +-
 fs/btrfs/delayed-inode.c          |  59 ++--
 fs/btrfs/delayed-ref.c            |   2 +-
 fs/btrfs/delayed-ref.h            |   2 +-
 fs/btrfs/dev-replace.c            |  30 +-
 fs/btrfs/dir-item.c               | 108 ------
 fs/btrfs/disk-io.c                |  75 ++---
 fs/btrfs/disk-io.h                |   3 +
 fs/btrfs/export.c                 |   5 -
 fs/btrfs/extent-tree.c            |  21 +-
 fs/btrfs/extent_io.c              | 143 ++++----
 fs/btrfs/extent_io.h              |  48 +--
 fs/btrfs/extent_map.c             | 132 ++++++++
 fs/btrfs/extent_map.h             |   3 +-
 fs/btrfs/file.c                   | 391 ++++++++++++++++-----
 fs/btrfs/free-space-cache.c       |  13 +-
 fs/btrfs/inode.c                  | 278 ++++-----------
 fs/btrfs/ioctl.c                  |  44 +--
 fs/btrfs/props.c                  |  13 +-
 fs/btrfs/qgroup.c                 |   3 +-
 fs/btrfs/raid56.c                 | 119 ++++---
 fs/btrfs/ref-verify.c             |   6 +-
 fs/btrfs/root-tree.c              |   7 -
 fs/btrfs/scrub.c                  |  95 +++---
 fs/btrfs/send.c                   |   6 -
 fs/btrfs/super.c                  | 348 ++++++++++---------
 fs/btrfs/sysfs.c                  |   2 +-
 fs/btrfs/tests/btrfs-tests.c      |   3 +
 fs/btrfs/tests/btrfs-tests.h      |   1 +
 fs/btrfs/tests/extent-map-tests.c | 366 ++++++++++++++++++++
 fs/btrfs/tests/inode-tests.c      |  17 +-
 fs/btrfs/transaction.c            |  22 +-
 fs/btrfs/transaction.h            |  11 +-
 fs/btrfs/tree-checker.c           | 142 ++++++++
 fs/btrfs/tree-log.c               |  54 +--
 fs/btrfs/volumes.c                | 689 ++++++++++++++++++++++----------------
 fs/btrfs/volumes.h                |  45 ++-
 fs/btrfs/xattr.c                  |   6 -
 fs/btrfs/zstd.c                   | 132 ++++----
 include/trace/events/btrfs.h      |   1 -
 include/uapi/linux/btrfs.h        |  11 +-
 include/uapi/linux/btrfs_tree.h   |   2 +
 47 files changed, 2267 insertions(+), 1405 deletions(-)
 create mode 100644 fs/btrfs/tests/extent-map-tests.c
