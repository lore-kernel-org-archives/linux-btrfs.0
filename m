Return-Path: <SRS0=W6bw=RH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C15C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 19:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9830E20823
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Mar 2019 19:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfCDTTs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 14:19:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:57048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726038AbfCDTTs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Mar 2019 14:19:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0317AE8D;
        Mon,  4 Mar 2019 19:19:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C825CDA7F5; Mon,  4 Mar 2019 20:21:04 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 5.1, part 1
Date:   Mon,  4 Mar 2019 20:20:53 +0100
Message-Id: <cover.1551726327.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

the branch contains usual mix of new features, core changes and fixes;
full list below. I'm planning 2nd pull request, with a few more fixes
that arrived recently but too close to merge window, will send it next
week.

Please pull, thanks.


New features:

- support zstd compression levels

- new ioctl to unregister a device from the module (ie. reverse of device
  scan)

- scrub prints a message to log when it's about to start or finish


Core changes:

- qgroups can now skip part of a tree that does not get updated during
  relocation, because this does not affect the quota accounting, estimated
  speedup in run time is about 20%

- the compression workspace management had to be enhanced due to zstd
  requirements

- various enospc fixes, when there's high fragmentation the
  over-reservation can cause ENOSPC that might not happen after a flush,
  in such cases try to wait if the situation improves


Fixes:

- various ioctls could overwrite previous return value if copy_to_user
  fails, fix this so the original error is reported

- more reclaim vs GFP_KERNEL fixes

- other cleanups and refactoring

- fix a (valid) lockdep warning in a test when device replace is
  destroying worker threads

- make qgroup async transaction commit more aggressive, this avoids some
  'quota limit reached' errors if there are not enough data to trigger
  transaction in order to flush

- fix deadlock between snapshot deletion and quotas when backref walking
  is called from context that already holds the same locks

- fsync fixes:
  - fix fsync after succession of renames of different files
  - fix fsync after succession of renames and unlink/rmdir

----------------------------------------------------------------
The following changes since commit 5908e6b738e3357af42c10e1183753c70a0117a9:

  Linux 5.0-rc8 (2019-02-24 16:46:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.1-part1-tag

for you to fetch changes up to f65e25e343cfc0e6f4db9a687c4085fad268325d:

  btrfs: Remove unnecessary casts in btrfs_read_root_item (2019-02-25 14:19:23 +0100)

----------------------------------------------------------------
Anand Jain (11):
      btrfs: merge btrfs_find_device_missing_or_by_path() into parent
      btrfs: cleanup btrfs_find_device_by_devspec()
      btrfs: refactor btrfs_find_device() take fs_devices as argument
      btrfs: refactor btrfs_free_stale_devices() to get return value
      btrfs: merge btrfs_find_device and find_device
      btrfs: scrub: print messages when started or finished
      btrfs: introduce new ioctl to unregister a btrfs device
      btrfs: fix comment its device list mutex not volume lock
      btrfs: scrub: fix circular locking dependency warning
      btrfs: scrub: add scrub_lock lockdep check in scrub_workers_get
      btrfs: scrub: convert scrub_workers_refcnt to refcount_t

Anders Roxell (1):
      btrfs: let the assertion expression compile in all configs

Dan Carpenter (1):
      btrfs: drop the lock on error in btrfs_dev_replace_cancel

Dan Robertson (1):
      btrfs: init csum_list before possible free

David Sterba (9):
      btrfs: simplify workqueue name when allocating
      btrfs: split btrfs_set_lock_blocking_rw to read and write helpers
      btrfs: split btrfs_clear_lock_blocking_rw to read and write helpers
      btrfs: replace btrfs_set_lock_blocking_rw with appropriate helpers
      btrfs: open code now trivial btrfs_set_lock_blocking
      btrfs: simplify waiting loop in btrfs_tree_lock
      btrfs: merge btrfs_set_lock_blocking_rw with it's caller
      btrfs: scrub: add assertions for worker pointers
      btrfs: scrub: remove unused nocow worker pointer

Dennis Zhou (12):
      btrfs: add helpers for compression type and level
      btrfs: rename workspaces_list to workspace_manager
      btrfs: manage heuristic workspace as index 0
      btrfs: unify compression ops with workspace_manager
      btrfs: add helper methods for workspace manager init and cleanup
      btrfs: add compression interface in (get/put)_workspace
      btrfs: move to function pointers for get/put workspaces
      btrfs: plumb level through the compression interface
      btrfs: change set_level() to bound the level passed in
      btrfs: zstd use the passed through level instead of default
      btrfs: make zstd memory requirements monotonic
      btrfs: add zstd compression level support

Filipe Manana (14):
      Btrfs: do not overwrite scrub error with fault error in scrub ioctl
      Btrfs: do not overwrite error return value in scrub progress ioctl
      Btrfs: do not overwrite error return value in the get device stats ioctl
      Btrfs: setup a nofs context for memory allocation at btrfs_create_tree()
      Btrfs: setup a nofs context for memory allocation at __btrfs_set_acl
      Btrfs: remove redundant check for swapfiles when reflinking
      Btrfs: do not overwrite error return value in the device replace ioctl
      Btrfs: do not overwrite error return value in the balance ioctl
      Btrfs: move duplicated nodatasum check into common reflink/dedupe helper
      Btrfs: fix fsync after succession of renames of different files
      Btrfs: fix fsync after succession of renames and unlink/rmdir
      Btrfs: remove no longer needed range length checks for deduplication
      Btrfs: add missing error handling after doing leaf/node binary search
      Btrfs: remove assertion when searching for a key in a node/leaf

Johannes Thumshirn (1):
      btrfs: ensure that a DUP or RAID1 block group has exactly two stripes

Josef Bacik (12):
      btrfs: make btrfs_destroy_delayed_refs use btrfs_delayed_ref_lock
      btrfs: make btrfs_destroy_delayed_refs use btrfs_delete_ref_head
      btrfs: call btrfs_create_pending_block_groups unconditionally
      btrfs: replace cleaner_delayed_iput_mutex with a waitqueue
      btrfs: check if there are free block groups for commit
      btrfs: dump block_rsv details when dumping space info
      btrfs: don't use global reserve for chunk allocation
      btrfs: don't enospc all tickets on flush failure
      btrfs: loop in inode_rsv_refill
      btrfs: be more explicit about allowed flush states
      btrfs: reserve extra space during evict
      btrfs: honor path->skip_locking in backref code

Julia Lawall (1):
      Btrfs: drop useless LIST_HEAD in merge_reloc_root

Nikolay Borisov (17):
      btrfs: Make first argument of btrfs_run_delalloc_range directly an inode
      btrfs: Remove unused arguments from btrfs_get_extent_fiemap
      btrfs: Refactor btrfs_get_extent_fiemap
      btrfs: Remove redundant assignment in btrfs_get_extent_fiemap
      btrfs: Remove inode argument from async_cow_submit
      btrfs: Remove isize local variable in compress_file_range
      btrfs: Use ihold instead of igrab in cow_file_range_async
      btrfs: Remove WARN_ON in btrfs_alloc_delalloc_work
      btrfs: Document logic regarding inode in async_cow_submit
      btrfs: Refactor shrink_delalloc
      btrfs: Remove impossible condition from mergable_maps
      btrfs: Rename found_type to extent_type in btrfs_get_extent
      btrfs: Consolidate retval checking of core btree functions
      btrfs: Remove not_found_em label from btrfs_get_extent
      btrfs: use WARN_ON in a canonical form btrfs_remove_block_group
      btrfs: Remove EXTENT_FIRST_DELALLOC bit
      btrfs: Fix grossly misleading argument names in extent io search

Qu Wenruo (10):
      btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots
      btrfs: qgroup: Refactor btrfs_qgroup_trace_subtree_swap
      btrfs: qgroup: Introduce per-root swapped blocks infrastructure
      btrfs: qgroup: Use delayed subtree rescan for balance
      btrfs: qgroup: Cleanup old subtree swap code
      btrfs: qgroup: Remove duplicated trace points for qgroup_rsv_add/release
      btrfs: Output ENOSPC debug info in inc_block_group_ro
      btrfs: extent_io: Kill the forward declaration of flush_write_bio
      btrfs: qgroup: Move reserved data accounting from btrfs_delayed_ref_head to btrfs_qgroup_extent_record
      btrfs: qgroup: Make qgroup async transaction commit more aggressive

YueHaibing (2):
      btrfs: remove set but not used variable 'num_pages'
      btrfs: Remove unnecessary casts in btrfs_read_root_item

 fs/btrfs/acl.c               |   9 ++
 fs/btrfs/async-thread.c      |  10 +-
 fs/btrfs/backref.c           |  22 ++-
 fs/btrfs/compression.c       | 253 ++++++++++++++---------------
 fs/btrfs/compression.h       |  52 +++++-
 fs/btrfs/ctree.c             |  74 ++++-----
 fs/btrfs/ctree.h             |  61 +++++--
 fs/btrfs/delayed-ref.c       |  15 +-
 fs/btrfs/delayed-ref.h       |  11 --
 fs/btrfs/dev-replace.c       |   9 +-
 fs/btrfs/disk-io.c           |  39 +++--
 fs/btrfs/extent-tree.c       | 292 +++++++++++++++++++++------------
 fs/btrfs/extent_io.c         |  87 +++++-----
 fs/btrfs/extent_io.h         |  15 +-
 fs/btrfs/extent_map.c        |   5 +-
 fs/btrfs/extent_map.h        |   1 +
 fs/btrfs/file.c              |   3 +-
 fs/btrfs/inode.c             | 207 +++++++++++++++---------
 fs/btrfs/ioctl.c             |  60 ++-----
 fs/btrfs/locking.c           | 108 ++++++-------
 fs/btrfs/locking.h           |  15 +-
 fs/btrfs/lzo.c               |  31 +++-
 fs/btrfs/qgroup.c            | 372 ++++++++++++++++++++++++++++++++-----------
 fs/btrfs/qgroup.h            | 120 ++++++++++++--
 fs/btrfs/ref-verify.c        |   4 +-
 fs/btrfs/relocation.c        | 119 ++++++++++----
 fs/btrfs/root-tree.c         |   4 +-
 fs/btrfs/scrub.c             |  49 ++++--
 fs/btrfs/super.c             |  13 +-
 fs/btrfs/transaction.c       |   9 +-
 fs/btrfs/tree-defrag.c       |   2 +-
 fs/btrfs/tree-log.c          | 282 ++++++++++++++++++++++++++------
 fs/btrfs/volumes.c           | 202 ++++++++++++-----------
 fs/btrfs/volumes.h           |   5 +-
 fs/btrfs/zlib.c              |  45 +++++-
 fs/btrfs/zstd.c              | 316 ++++++++++++++++++++++++++++++++++--
 include/trace/events/btrfs.h |  30 +---
 include/uapi/linux/btrfs.h   |   2 +
 38 files changed, 1993 insertions(+), 960 deletions(-)
