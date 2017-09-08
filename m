Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44634 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932214AbdIHSKa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 14:10:30 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs for 4.14
Date: Fri,  8 Sep 2017 20:08:59 +0200
Message-Id: <cover.1504892447.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following btrfs branch to 4.14. The changes range through all
types: cleanups, core chagnes, sanity checks, fixes, other user visible
changes, detailed list below.

Merging notes: there's a minor conflict with the blk_status_t fix that went to
4.13-rc7 while this pull is on top of 4.13-rc5 as I did not want to rebase. The
resolution is simple, there's a removed parameter 'skip_sum' in function
__btrfs_submit_dio_bio. My resolution can be found in branch for-4.14-merged.

Changes:
* deprecated: user transaction ioctl
* mount option ssd does not change allocation alignments
* degraded read-write mount is allowed if all the raid profile constraints are
  met, now based on more accurate check
* defrag: do not reset compression afterwards; the NOCOMPRESS flag can be now
  overriden by defrag
* prep work for better extent reference tracking (related to the qgroup
  slowness with balance)
* prep work for compression heuristics
* memory allocation reductions (may help latencies on a loaded system)
* better accounting for io waiting states
* error handling improvements (removed BUGs)
* added more sanity checks for shared refs
* fix readdir vs pagefault deadlock under some circumstances
* fix for 'no-hole' mode, certain combination of compressed and inline extents
* send: fix emission of invalid clone operations
* fixup file mode if setting acls fail
* more fixes from fuzzing
* oher cleanups

The following changes since commit ef954844c7ace62f773f4f23e28d2d915adc419f:

  Linux 4.13-rc5 (2017-08-13 16:01:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.14

for you to fetch changes up to db95c876c568cef951fbbd4c0118cb5386e4bb99:

  btrfs: submit superblock io with REQ_META and REQ_PRIO (2017-08-22 13:22:05 +0200)

----------------------------------------------------------------
Aleksa Sarai (1):
      btrfs: resume qgroup rescan on rw remount

Anand Jain (4):
      btrfs: btrfs_inherit_iflags() can be static
      btrfs: use appropriate define for the fsid
      btrfs: use BTRFS_FSID_SIZE for fsid
      btrfs: remove unused BTRFS_COMPRESS_LAST

Colin Ian King (1):
      btrfs: remove redundant check on ret being non-zero

David Sterba (30):
      btrfs: drop newlines from strings when using btrfs_* helpers
      btrfs: use GFP_KERNEL in mount and remount
      btrfs: use GFP_KERNEL in btrfs_defrag_file
      btrfs: defrag: make readahead state allocation failure non-fatal
      btrfs: factor reading progress out of btrfs_dev_replace_status
      btrfs: simplify btrfs_dev_replace_kthread
      btrfs: get fs_info from eb in btrfs_print_leaf, remove argument
      btrfs: get fs_info from eb in btrfs_print_tree, remove argument
      btrfs: cleanup types storing REQ_*
      btrfs: merge REQ_OP and REQ_ flags to one parameter in submit_extent_page
      btrfs: merge alloc_device helpers
      btrfs: refactor find_device helper
      btrfs: split write_dev_supers to two functions
      btrfs: use named constant for bdev blocksize
      btrfs: fix spelling of snapshotting
      btrfs: drop ancient page flag mappings
      btrfs: remove trivial wrapper btrfs_force_ra
      btrfs: drop chunk locks at the end of close_ctree
      btrfs: account that we're waiting for DIO read
      btrfs: account that we're waiting for IO in scrub_submit_raid56_bio_wait
      btrfs: rename variable holding per-inode compression type
      btrfs: separate defrag and property compression
      btrfs: defrag: cleanup checking for compression status
      btrfs: allow defrag compress to override NOCOMPRESS attribute
      btrfs: prepare for extensions in compression options
      btrfs: scrub: use bool for flush_all_writes
      btrfs: scrub: clean up division in __scrub_mark_bitmap
      btrfs: scrub: clean up division in scrub_find_csum
      btrfs: scrub: simplify scrub worker initialization
      btrfs: submit superblock io with REQ_META and REQ_PRIO

Edmund Nadolski (6):
      btrfs: btrfs_check_shared should manage its own transaction
      btrfs: remove ref_tree implementation from backref.c
      btrfs: convert prelimary reference tracking to use rbtrees
      btrfs: add cond_resched() calls when resolving backrefs
      btrfs: allow backref search checks for shared extents
      btrfs: clean up extraneous computations in add_delayed_refs

Ernesto A. Fernández (1):
      btrfs: preserve i_mode if __btrfs_set_acl() fails

Filipe Manana (3):
      Btrfs: avoid unnecessarily locking inode when clearing a range
      Btrfs: fix assertion failure during fsync in no-holes mode
      Btrfs: incremental send, fix emission of invalid clone operations

Hans van Kranenburg (1):
      btrfs: Do not use data_alloc_cluster in ssd mode

Jeff Mahoney (9):
      btrfs: struct-funcs, constify readers
      btrfs: constify tracepoint arguments
      btrfs: backref, constify some arguments
      btrfs: backref, add unode_aux_to_inode_list helper
      btrfs: backref, cleanup __ namespace abuse
      btrfs: add a node counter to each of the rbtrees
      btrfs: backref, add tracepoints for prelim_ref insertion and merging
      btrfs: account for pinned bytes in should_alloc_chunk
      btrfs: pass fs_info to btrfs_del_root instead of tree_root

Josef Bacik (2):
      btrfs: fix readdir deadlock with pagefault
      btrfs: increase ctx->pos for delayed dir index

Liu Bo (9):
      Btrfs: report errors when checksum is not found
      Btrfs: fix out of bounds array access while reading extent buffer
      Btrfs: add a helper to retrive extent inline ref type
      Btrfs: convert to use btrfs_get_extent_inline_ref_type
      Btrfs: remove BUG() in btrfs_extent_inline_ref_size
      Btrfs: remove BUG() in print_extent_item
      Btrfs: remove BUG() in add_data_reference
      Btrfs: remove BUG_ON in __add_tree_block
      Btrfs: add one more sanity check for shared ref type

Lu Fengqi (1):
      btrfs: use btrfsic_submit_bio instead of submit_bio in write_dev_flush

Matthias Kaehlcke (1):
      btrfs: Remove extra parentheses from condition in copy_items()

Nick Terrell (1):
      btrfs: Keep one more workspace around

Nikolay Borisov (27):
      btrfs: convert while loop to list_for_each_entry
      btrfs: Use explicit round_down call rather than open-coding it
      btrfs: Be explicit about usage of min()
      btrfs: remove unused sectorsize member
      btrfs: Remove redundant argument of flush_space
      btrfs: Remove redundant checks from btrfs_alloc_data_chunk_ondemand
      btrfs: Prevent possible ERR_PTR() dereference
      btrfs: qgroups: Fix BUG_ON condition in tree level check
      btrfs: Use explicit round_down macro in btrfs resize ioctl handler
      btrfs: Remove find_raid56_stripe_len
      btrfs: Remove unused variables
      btrfs: Remove unused parameters from volume.c functions
      btrfs: Remove never reached error handling code in __add_reloc_root
      btrfs: Deprecate userspace transaction ioctls
      btrfs: Make flush_space return void
      btrfs: Simplify math in should_alloc chunk
      btrfs: Remove never-reached WARN_ON
      btrfs: Remove unused sectorsize variable from struct map_lookup
      btrfs: expose internal free space tree routine only if sanity tests are enabled
      btrfs: Move skip checksum check from btrfs_submit_direct to __btrfs_submit_dio_bio
      btrfs: Fix -EOVERFLOW handling in btrfs_ioctl_tree_search_v2
      btrfs: Remove redundant setting of uuid in btrfs_block_header
      btrfs: Remove chunk_objectid argument from btrfs_make_block_group
      btrfs: Remove extraneous chunk_objectid variable
      btrfs: Remove chunk_objectid parameter of btrfs_alloc_dev_extent
      btrfs: remove superfluous chunk_tree argument from btrfs_alloc_dev_extent
      btrfs: remove unnecessary memory barrier in btrfs_direct_IO

Qu Wenruo (6):
      btrfs: Introduce a function to check if all chunks a OK for degraded rw mount
      btrfs: Do chunk level check for degraded rw mount
      btrfs: Do chunk level check for degraded remount
      btrfs: Allow barrier_all_devices to do chunk level device check
      btrfs: Cleanup num_tolerated_disk_barrier_failures
      btrfs: Enhance message when a device is missing during mount

Timofey Titovets (1):
      Btrfs: add skeleton code for compression heuristic

 fs/btrfs/acl.c                         |    6 +-
 fs/btrfs/async-thread.c                |    6 +-
 fs/btrfs/async-thread.h                |    6 +-
 fs/btrfs/backref.c                     | 1085 ++++++++++++++------------------
 fs/btrfs/backref.h                     |   16 +-
 fs/btrfs/btrfs_inode.h                 |   13 +-
 fs/btrfs/check-integrity.c             |    8 +-
 fs/btrfs/compression.c                 |   35 +-
 fs/btrfs/compression.h                 |    3 +-
 fs/btrfs/ctree.c                       |   14 +-
 fs/btrfs/ctree.h                       |  183 +++---
 fs/btrfs/delayed-inode.c               |    1 +
 fs/btrfs/dev-replace.c                 |   74 ++-
 fs/btrfs/disk-io.c                     |  242 +++----
 fs/btrfs/disk-io.h                     |   10 +-
 fs/btrfs/extent-tree.c                 |  200 ++++--
 fs/btrfs/extent_io.c                   |   92 ++-
 fs/btrfs/extent_io.h                   |   19 +-
 fs/btrfs/file.c                        |   19 +-
 fs/btrfs/free-space-cache.c            |    2 +-
 fs/btrfs/free-space-tree.c             |    2 +-
 fs/btrfs/free-space-tree.h             |    3 +-
 fs/btrfs/inode.c                       |  221 +++++--
 fs/btrfs/ioctl.c                       |  116 ++--
 fs/btrfs/print-tree.c                  |   40 +-
 fs/btrfs/print-tree.h                  |    4 +-
 fs/btrfs/props.c                       |   10 +-
 fs/btrfs/qgroup.c                      |    7 +-
 fs/btrfs/relocation.c                  |   32 +-
 fs/btrfs/root-tree.c                   |    9 +-
 fs/btrfs/scrub.c                       |   47 +-
 fs/btrfs/send.c                        |   21 +-
 fs/btrfs/struct-funcs.c                |    9 +-
 fs/btrfs/super.c                       |   41 +-
 fs/btrfs/tests/btrfs-tests.c           |    1 -
 fs/btrfs/tests/free-space-tree-tests.c |    2 +-
 fs/btrfs/tree-log.c                    |    9 +-
 fs/btrfs/volumes.c                     |  296 ++++-----
 fs/btrfs/volumes.h                     |    8 +-
 include/trace/events/btrfs.h           |  331 ++++++----
 40 files changed, 1702 insertions(+), 1541 deletions(-)
