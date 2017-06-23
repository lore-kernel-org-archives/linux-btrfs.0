Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754520AbdFWQvn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 12:51:43 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs for 4.13, part 1
Date: Fri, 23 Jun 2017 17:16:46 +0200
Message-Id: <cover.1498229425.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is the main batch for 4.13. There are some user visible changes, see
below. The core updates improve error handling (mostly related to bios), with
the usual incremental work on the GFP_NOFS (mis)use removal. All patches have
been in for-next for an extensive amount of time.

Thre will be followups but I want push the series (111 patches) forward. There
are also some updates to adjacent subsystems (writeback and blocklayer), so I
want to give some stable point for merging in the upcoming weeks.

User visible changes:
* quota override tunable
* improved compression thresholds
* statx support
* obsoleted mount option alloc_start

Core updates:
* bio-related updates
  - faster bio cloning
  - no allocation failures
  - preallocated flush bios
* more kvzalloc use, memalloc_nofs protections, GFP_NOFS updates
* prep work for btree_inode removal
* dir-item validation
* qgoup fixes and updates
* cleanups
  - removed unused struct members, unused code, refactoring
  - argument refactoring (fs_info/root, caller -> callee sink)
  - SEARCH_TREE docs

----------------------------------------------------------------
The following changes since commit 41f1830f5a7af77cf5c86359aba3cbd706687e52:

  Linux 4.12-rc6 (2017-06-19 22:19:37 +0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.13-part1

for you to fetch changes up to f3f000297be88b1b75fde5027d660a8d8a44de14:

  btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges (2017-06-21 20:56:14 +0200)

----------------------------------------------------------------
Anand Jain (7):
      btrfs: cleanup unused qgroup trace event
      btrfs: add framework to handle device flush error as a volume
      btrfs: btrfs_decompress_bio() could accept compressed_bio instead
      btrfs: reduce arguments for decompress_bio ops
      btrfs: write_dev_flush does not return ENOMEM anymore
      btrfs: remove redundant null bdev counting during flush submission
      btrfs: wait part of the write_dev_flush() can be separated out

Arnd Bergmann (1):
      Btrfs: work around maybe-uninitialized warning

Daichou (1):
      Btrfs: remove obsolete FIXMEs in qgroup ioctls

Dan Carpenter (1):
      Btrfs: remove an unused variable

David Sterba (39):
      btrfs: remove unused member err from reada_extent
      btrfs: remove unused member list from async_submit_bio
      btrfs: remove unused members dir_path from recorded_ref
      btrfs: remove unused member list from btrfs_end_io_wq
      btrfs: fix bool type in btrfs_page_exists_in_range
      btrfs: scrub: inline helper scrub_setup_wr_ctx
      btrfs: scrub: inline helper scrub_free_wr_ctx
      btrfs: scrub: simplify cleanup of wr_ctx in scrub_free_ctx
      btrfs: scrub: use fs_info::sectorsize and drop it from scrub context
      btrfs: scrub: embed scrub_wr_ctx into scrub context
      btrfs: use generic slab for for btrfs_transaction
      btrfs: replace opencoded kvzalloc with the helper
      btrfs: send: use kvmalloc in iterate_dir_item
      btrfs: scrub: add memalloc_nofs protection around init_ipath
      btrfs: use GFP_KERNEL in init_ipath
      btrfs: adjust includes after vmalloc removal
      btrfs: add memalloc_nofs protections around alloc_workspace callback
      btrfs: switch kmallocs to GFP_KERNEL in lzo/zlib alloc_workspace
      btrfs: switch to kvmalloc and GFP_KERNEL in lzo/zlib alloc_workspace
      btrfs: bioset allocations will never fail, adapt our helpers
      btrfs: btrfs_bio_alloc never fails, skip error handling
      btrfs: btrfs_bio_clone never fails, skip error handling
      btrfs: btrfs_io_bio_alloc never fails, skip error handling
      btrfs: sink gfp parameter to btrfs_bio_clone
      btrfs: remove redundant parameters from btrfs_bio_alloc
      btrfs: opencode trivial compressed_bio_alloc, simplify error handling
      btrfs: pass bytes to btrfs_bio_alloc
      btrfs: document mandatory order of bio in btrfs_io_bio
      btrfs: add helper to initialize the non-bio part of btrfs_io_bio
      btrfs: sink gfp parameter to btrfs_io_bio_alloc
      btrfs: use GFP_KERNEL in btrfs_calc_avail_data_space
      btrfs: use GFP_KERNEL in btrfs_init_dev_replace_tgtdev
      btrfs: cleanup duplicate return value in insert_inline_extent
      btrfs: move fs_info::fs_frozen to the flags
      btrfs: obsolete and remove mount option alloc_start
      btrfs: preallocate device flush bio
      btrfs: account as waiting for IO, while waiting fot the flush bio completion
      btrfs: move dev stats accounting out of wait_dev_flush
      btrfs: fix validation of XATTR_ITEM dir items

Fabian Frederick (1):
      btrfs: kmap() can't fail

Filipe Manana (3):
      Btrfs: fix invalid extent maps due to hole punching
      Btrfs: send, fix invalid path after renaming and linking file
      Btrfs: incremental send, fix invalid path for unlink commands

Guoqing Jiang (1):
      btrfs: simplify code with bio_io_error

Hans van Kranenburg (1):
      Btrfs: btrfs_ioctl_search_key documentation

Jeff Layton (1):
      btrfs: btrfs_wait_tree_block_writeback can be void return

Jeff Mahoney (3):
      btrfs: cleanup root usage by btrfs_get_alloc_profile
      btrfs: remove root usage from can_overcommit
      btrfs: add cond_resched to btrfs_qgroup_trace_leaf_items

Josef Bacik (3):
      Btrfs: replace tree->mapping with tree->private_data
      btrfs: remove inode argument from repair_io_failure
      Btrfs: don't pass the inode through clean_io_failure

Liu Bo (12):
      Btrfs: use bio_clone_fast to clone our bio
      Btrfs: new helper btrfs_bio_clone_partial
      Btrfs: use bio_clone_bioset_partial to simplify DIO submit
      Btrfs: change how we iterate bios in endio
      Btrfs: record error if one block has failed to retry
      Btrfs: check-integrity use bvec_iter
      Btrfs: unify naming of btrfs_io_bio
      Btrfs: hardcode GFP_NOFS for btrfs_bio_clone_partial
      Btrfs: skip commit transaction if we don't have enough pinned bytes
      Btrfs: let btrfs_print_leaf print more about block group
      Btrfs: tolerate errors if we have retried successfully
      Btrfs: skip checksum verification if IO error occurs

Nikolay Borisov (8):
      btrfs: Convert fs_info->free_chunk_space to atomic64_t
      btrfs: Separate space_info create/update
      btrfs: Refactor update_space_info
      btrfs: rename btrfs_leaf_data to BTRFS_LEAF_DATA_OFFSET
      btrfs: remove __BTRFS_LEAF_DATA_SIZE
      btrfs: Use btrfs_space_info_used instead of opencoding it
      btrfs: Manually implement device_total_bytes getter/setter
      btrfs: Round down values which are written for total_bytes_size

Omar Sandoval (7):
      Btrfs: use memalloc_nofs and kvzalloc() for free space tree bitmaps
      Btrfs: make add_pinned_bytes() take an s64 num_bytes instead of u64
      Btrfs: make BUG_ON() in add_pinned_bytes() an ASSERT()
      Btrfs: update total_bytes_pinned when pinning down extents
      Btrfs: always account pinned bytes when dropping a tree block ref
      Btrfs: return old and new total ref mods when adding delayed refs
      Btrfs: rework delayed ref total_bytes_pinned accounting

Qu Wenruo (6):
      btrfs: qgroup: Add quick exit for non-fs extents
      btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function
      btrfs: qgroup: Return actually freed bytes for qgroup release or free data
      btrfs: qgroup: Fix qgroup reserved space underflow caused by buffered write and quotas being enabled
      btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
      btrfs: qgroup: Fix qgroup reserved space underflow by only freeing reserved ranges

Sahil Kang (1):
      btrfs: Remove unnecessary branching in free-space-tree.c

Sargun Dhillon (2):
      btrfs: add quota override flag to enable quota override for CAP_SYS_RESOURCE
      btrfs: Add quota_override knob into sysfs

Su Yue (9):
      btrfs: Introduce btrfs_is_name_len_valid to avoid reading beyond boundary
      btrfs: Check name_len with boundary in verify dir_item
      btrfs: Check name_len on add_inode_ref call path
      btrfs: Verify dir_item in replay_xattr_deletes
      btrfs: Check name_len in btrfs_check_ref_name_override
      btrfs: Check name_len before read in iterate_dir_item
      btrfs: Check name_len before reading btrfs_get_name
      btrfs: Check name_len before in btrfs_del_root_ref
      btrfs: Verify dir_item in iterate_object_props

Timofey Titovets (3):
      Btrfs: lzo: fix typo in error message after failed deflate
      Btrfs: lzo: compressed data size must be less then input size
      Btrfs: compression must free at least one sector size

Yonghong Song (1):
      Btrfs: add statx support

 fs/btrfs/backref.c               |  10 +-
 fs/btrfs/check-integrity.c       |  53 ++---
 fs/btrfs/compression.c           |  94 ++------
 fs/btrfs/compression.h           |  44 +++-
 fs/btrfs/ctree.c                 |  42 ++--
 fs/btrfs/ctree.h                 |  84 ++++---
 fs/btrfs/delayed-ref.c           |  29 ++-
 fs/btrfs/delayed-ref.h           |   6 +-
 fs/btrfs/dir-item.c              |  94 +++++++-
 fs/btrfs/disk-io.c               | 179 +++++++--------
 fs/btrfs/disk-io.h               |   8 +-
 fs/btrfs/export.c                |   5 +
 fs/btrfs/extent-tree.c           | 481 +++++++++++++++++++++------------------
 fs/btrfs/extent_io.c             | 217 ++++++++----------
 fs/btrfs/extent_io.h             |  82 +++++--
 fs/btrfs/file-item.c             |  31 ++-
 fs/btrfs/file.c                  |  46 ++--
 fs/btrfs/free-space-tree.c       |  38 ++--
 fs/btrfs/inode-map.c             |   4 +-
 fs/btrfs/inode.c                 | 449 ++++++++++++++++++++----------------
 fs/btrfs/ioctl.c                 |  16 +-
 fs/btrfs/lzo.c                   |  33 +--
 fs/btrfs/print-tree.c            |   7 +-
 fs/btrfs/props.c                 |   7 +
 fs/btrfs/qgroup.c                | 223 +++++++++++++-----
 fs/btrfs/qgroup.h                |   9 +-
 fs/btrfs/raid56.c                |  16 +-
 fs/btrfs/reada.c                 |   1 -
 fs/btrfs/relocation.c            |  15 +-
 fs/btrfs/root-tree.c             |   7 +
 fs/btrfs/scrub.c                 | 209 +++++++----------
 fs/btrfs/send.c                  | 112 ++++++---
 fs/btrfs/super.c                 |  72 +-----
 fs/btrfs/sysfs.c                 |  41 ++++
 fs/btrfs/tests/extent-io-tests.c |   2 +-
 fs/btrfs/transaction.c           |  23 +-
 fs/btrfs/tree-log.c              |  44 +++-
 fs/btrfs/volumes.c               |  74 +++---
 fs/btrfs/volumes.h               |   7 +
 fs/btrfs/xattr.c                 |   2 +-
 fs/btrfs/zlib.c                  |  20 +-
 include/trace/events/btrfs.h     |  36 ---
 include/uapi/linux/btrfs.h       |  63 +++--
 43 files changed, 1682 insertions(+), 1353 deletions(-)
