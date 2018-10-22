Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22E8C7112C
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 17:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6567F205F4
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 17:22:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6567F205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbeJWBlr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 21:41:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:36912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728639AbeJWBlr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 21:41:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0BA46AF9F;
        Mon, 22 Oct 2018 17:22:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C1A02DAF52; Mon, 22 Oct 2018 19:22:15 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 4.20, part 1
Date:   Mon, 22 Oct 2018 19:22:14 +0200
Message-Id: <cover.1540227161.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

this is the first batch with fixes and some nice performance improvements.

Preliminary results show eg. more files/sec in fsmark, better perf on
multi-threaded workloads (filebench, dbench), fewer context switches and
overall better memory allocation characteristics (multiple benchmarks).

Apart from general performance, there's an improvement for qgroups +
balance workload that's been troubling our users.

Note for stable: there are 20+ patches tagged for stable, out of 90. Not
all of them apply cleanly on all stable versions but the conflicts are
mostly due to simple cleanups and resolving should be obvious. The fixes
are otherwise independent.

No merge conflicts expected. Please pull, thanks.


Performance improvements:

* blocking mode of path is gone, means that only the spinning mode is used;
  the blocking resulted in more unnecessary wakeups and updates to the path
  locks, the effects are measurable and improve latency and scaleability

* qgroups: first batch of changes that should speedup balancing with qgroups
  on, skip quota accounting on unchanged subtrees, overall gain is about 30+%
  in runtime

* use rb-tree with cached first node for several structures, small improvement
  to avoid pointer chasing

Fixes:

* trim
  * fix: some blockgroups could have been missed if their logical address was
    past the total filesystem size (ie. after a lot of balancing)
  * better error reporting, after processing blockgroups and whole device
  * fix: continue trimming block groups after an error is encountered
  * check for trim support of the device earlier and avoid some unnecessary work
  * less interaction with transaction commit that improves latency on slower
    storage (eg. image files over NFS)

* fsync
  * fix warning when replaying log after fsync of a O_TMPFILE
  * fix wrong dentries after fsync of file that got its parent replaced

* qgroups: fix rescan that might misc some dirty groups

* don't clean dirty pages during buffered writes, this could lead to lost
  updates in some corner cases

* some block groups could have been delayed in creation, if the allocation
  triggered another one

* error handling improvements

Cleanups:

  * removed unused struct members and variables
  * function return type cleanups
  * delayed refs code refactoring

* protect against deadlock that could be caused by crafted image that tries to
  allocate from a tree that's locked already

----------------------------------------------------------------
The following changes since commit 35a7f35ad1b150ddf59a41dcac7b2fa32982be0e:

  Linux 4.19-rc8 (2018-10-15 07:20:24 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.20-part1-tag

for you to fetch changes up to d9352794dad9f28535439d85a815978878c141ab:

  btrfs: switch return_bigger to bool in find_ref_head (2018-10-15 17:23:41 +0200)

----------------------------------------------------------------
Anand Jain (2):
      btrfs: add assertions where number of devices could go below 0
      btrfs: add helper to obtain number of devices with ongoing dev-replace

Chris Mason (1):
      Btrfs: don't clean dirty pages during buffered writes

Colin Ian King (2):
      btrfs: remove unused pointer inode in relink_file_extents
      btrfs: remove unused pointer 'tree' in btrfs_submit_compressed_read

David Sterba (12):
      btrfs: tests: add separate stub for find_lock_delalloc_range
      btrfs: tests: move testing members of struct btrfs_root to the end
      btrfs: tests: group declarations of self-test helpers
      btrfs: tests: polish ifdefs around testing helper
      btrfs: use common helper instead of open coding a bit test
      btrfs: remove btrfs_dev_replace::read_locks
      btrfs: open code btrfs_dev_replace_clear_lock_blocking
      btrfs: open code btrfs_dev_replace_stats_inc
      btrfs: open code btrfs_after_dev_replace_commit
      btrfs: dev-replace: avoid useless lock on error handling path
      btrfs: dev-replace: move replace members out of fs_info
      btrfs: dev-replace: remove pointless assert in write unlock

Filipe Manana (2):
      Btrfs: fix warning when replaying log after fsync of a tmpfile
      Btrfs: fix wrong dentries after fsync of file that got its parent replaced

Jeff Mahoney (5):
      btrfs: fix error handling in free_log_tree
      btrfs: fix error handling in btrfs_dev_replace_start
      btrfs: iterate all devices during trim, instead of fs_devices::alloc_list
      btrfs: don't attempt to trim devices that don't support it
      btrfs: keep trim from interfering with transaction commits

Josef Bacik (7):
      btrfs: wait on caching when putting the bg cache
      btrfs: release metadata before running delayed refs
      btrfs: protect space cache inode alloc with GFP_NOFS
      btrfs: reset max_extent_size on clear in a bitmap
      btrfs: make sure we create all new block groups
      btrfs: assert on non-empty delayed iputs
      btrfs: drop min_size from evict_refill_and_join

Liu Bo (19):
      Btrfs: do not unnecessarily pass write_lock_level when processing leaf
      Btrfs: remove always true if branch in btrfs_get_extent
      Btrfs: use next_state in find_first_extent_bit
      btrfs: free path at an earlier point in btrfs_get_extent
      Btrfs: remove confusing tracepoint in btrfs_add_reserved_bytes
      Btrfs: fix alignment in declaration and prototype of btrfs_get_extent
      Btrfs: set leave_spinning in btrfs_get_extent
      Btrfs: use args in the correct order for kcalloc in btrfsic_read_block
      Btrfs: unify error handling of btrfs_lookup_dir_item
      Btrfs: remove unnecessary level check in balance_level
      Btrfs: assert page dirty bit on extent buffer pages
      Btrfs: skip set_page_dirty if eb pages are already dirty
      Btrfs: remove wait_ordered_range in btrfs_evict_inode
      Btrfs: delayed-refs: use rb_first_cached for href_root
      Btrfs: delayed-refs: use rb_first_cached for ref_tree
      Btrfs: delayed-inode: use rb_first_cached for ins_root and del_root
      Btrfs: extent_map: use rb_first_cached
      Btrfs: preftree: use rb_first_cached
      Btrfs: kill btrfs_clear_path_blocking

Lu Fengqi (10):
      btrfs: simplify the send_in_progress check in btrfs_delete_subvolume
      btrfs: switch update_size to bool in btrfs_block_rsv_migrate and btrfs_rsv_add_bytes
      btrfs: Remove root parameter from btrfs_insert_dir_item
      btrfs: remove a useless return statement in btrfs_block_rsv_add
      btrfs: qgroup: move the qgroup->members check out from (!qgroup)'s else branch
      btrfs: delayed-ref: pass delayed_refs directly to btrfs_select_ref_head
      btrfs: delayed-ref: pass delayed_refs directly to btrfs_delayed_ref_lock
      btrfs: remove fs_info from btrfs_check_space_for_delayed_refs
      btrfs: remove fs_info from btrfs_should_throttle_delayed_refs
      btrfs: switch return_bigger to bool in find_ref_head

Misono Tomohiro (2):
      btrfs: Remove 'objectid' member from struct btrfs_root
      btrfs: remove redundant variable from btrfs_cross_ref_exist

Nikolay Borisov (8):
      btrfs: Make btrfs_find_device_by_path return struct btrfs_device
      btrfs: Make btrfs_find_device_missing_or_by_path return directly a device
      btrfs: Make btrfs_find_device_by_devspec return btrfs_device directly
      btrfs: Remove logically dead code from btrfs_orphan_cleanup
      btrfs: handle error of get_old_root
      btrfs: Factor out ref head locking code in __btrfs_run_delayed_refs
      btrfs: Factor out loop processing all refs of a head
      btrfs: refactor __btrfs_run_delayed_refs loop

Omar Sandoval (2):
      Btrfs: clean up scrub is_dev_replace parameter
      Btrfs: get rid of btrfs_symlink_aops

Qu Wenruo (16):
      btrfs: qgroup: Dirty all qgroups before rescan
      btrfs: Handle owner mismatch gracefully when walking up tree
      btrfs: locking: Add extra check in btrfs_init_new_buffer() to avoid deadlock
      btrfs: Enhance btrfs_trim_fs function to handle error better
      btrfs: Ensure btrfs_trim_fs can trim the whole filesystem
      btrfs: relocation: Add basic extent backref related comments for build_backref_tree
      btrfs: qgroup: Introduce trace event to analyse the number of dirty extents accounted
      btrfs: qgroup: Introduce function to trace two swaped extents
      btrfs: qgroup: Introduce function to find all new tree blocks of reloc tree
      btrfs: qgroup: Use generation-aware subtree swap to mark dirty extents
      btrfs: qgroup: Don't trace subtree if we're dropping reloc tree
      btrfs: qgroup: Only trace data extents in leaves if we're relocating data block group
      btrfs: tree-checker: Check level for leaves and nodes
      btrfs: qgroup: Avoid calling qgroup functions if qgroup is not enabled
      btrfs: relocation: Cleanup while loop using rbtree_postorder_for_each_entry_safe
      btrfs: relocation: Remove redundant tree level check

Su Yue (1):
      btrfs: defrag: use btrfs_mod_outstanding_extents in cluster_pages_for_defrag

zhong jiang (4):
      btrfs: remove unneeded NULL checks before kfree
      btrfs: change btrfs_free_reserved_bytes to return void
      btrfs: change btrfs_pin_log_trans to return void
      btrfs: change remove_extent_mapping to return void

 fs/btrfs/backref.c                |  39 ++--
 fs/btrfs/btrfs_inode.h            |   8 +-
 fs/btrfs/check-integrity.c        |   6 +-
 fs/btrfs/compression.c            |   2 -
 fs/btrfs/ctree.c                  |  68 +-----
 fs/btrfs/ctree.h                  |  56 ++---
 fs/btrfs/delayed-inode.c          |  41 ++--
 fs/btrfs/delayed-inode.h          |   4 +-
 fs/btrfs/delayed-ref.c            |  69 +++---
 fs/btrfs/delayed-ref.h            |  10 +-
 fs/btrfs/dev-replace.c            |  64 ++----
 fs/btrfs/dev-replace.h            |   8 -
 fs/btrfs/dir-item.c               |   8 +-
 fs/btrfs/disk-io.c                |  24 +-
 fs/btrfs/export.c                 |   4 +-
 fs/btrfs/extent-tree.c            | 424 +++++++++++++++++++++--------------
 fs/btrfs/extent_io.c              |  33 ++-
 fs/btrfs/extent_io.h              |   4 +-
 fs/btrfs/extent_map.c             |  32 +--
 fs/btrfs/extent_map.h             |   4 +-
 fs/btrfs/file.c                   |  33 ++-
 fs/btrfs/free-space-cache.c       |  16 +-
 fs/btrfs/inode.c                  | 120 ++++------
 fs/btrfs/ioctl.c                  |  18 +-
 fs/btrfs/qgroup.c                 | 455 ++++++++++++++++++++++++++++++++++++--
 fs/btrfs/qgroup.h                 |   8 +
 fs/btrfs/ref-verify.c             |   8 +-
 fs/btrfs/relocation.c             |  74 +++----
 fs/btrfs/scrub.c                  |  34 ++-
 fs/btrfs/send.c                   |  24 +-
 fs/btrfs/super.c                  |   6 +-
 fs/btrfs/tests/extent-io-tests.c  |  10 +-
 fs/btrfs/tests/extent-map-tests.c |   4 +-
 fs/btrfs/transaction.c            |  31 +--
 fs/btrfs/tree-checker.c           |  14 ++
 fs/btrfs/tree-log.c               |  86 +++++--
 fs/btrfs/tree-log.h               |   2 +-
 fs/btrfs/volumes.c                | 117 +++++-----
 fs/btrfs/volumes.h                |   9 +-
 include/trace/events/btrfs.h      |  36 ++-
 40 files changed, 1268 insertions(+), 745 deletions(-)
