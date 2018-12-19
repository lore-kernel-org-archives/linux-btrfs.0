Return-Path: <SRS0=k4qV=O4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E55CC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 15:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32FDB21841
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Dec 2018 15:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbeLSPLm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Dec 2018 10:11:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:59152 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729500AbeLSPLl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Dec 2018 10:11:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AFCCDAD29;
        Wed, 19 Dec 2018 15:11:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B5954DA88B; Wed, 19 Dec 2018 16:11:12 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 4.21
Date:   Wed, 19 Dec 2018 16:11:04 +0100
Message-Id: <cover.1545231616.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I've planned to merge a few more patches to the 1st pull branch that belong to
a core change mentioned below as 'delayed refs reserve'. There are review
comments that I think should be addressed, so the patches are postponed.

Technically they're fixes and I presume it's ok to take them in the -rc. I
didn't want to touch the pull request branch a few days before sending it,
though the patches have been in linux-next for some time. The bugs fixed are
not critical for testing so this should not block anybody.

No merge conflicts, please pull. Thanks.

--

New features:

* swapfile support - after a long time it's here, with some limitations where
  COW design does not work well with the swap implementation (nodatacow file,
  no compression, cannot be snapshotted, not possible on multiple devices,
  ...), as this is the most restricted but working setup, we'll try to improve
  that in the future

* metadata uuid - an optional incompat feature to assign a new filesystem UUID
  without overwriting all metadata blocks, stored only in superblock

* more balance messages are printed to system log, initial is in the format of
  the command line that would be used to start it


Fixes:

* tag pages of a snapshot to better separate pages that are involved in the
  snapshot (and need to get synced) from newly dirtied pages that could slow
  down or even livelock the snapshot operation

* improved check of filesystem id associated with a device during scan to
  detect duplicate devices that could be mixed up during mount

* fix device replace state transitions, eg. when it ends up interrupted and
  reboot tries to restart balance too, or when start/cancel ioctls race

* fix a crash due to a race when quotas are enabled during snapshot creation

* GFP_NOFS/memalloc_nofs_* fixes due to GFP_KERNEL allocations in transaction
  context

* fix fsync of files with multiple hard links in new directories

* fix race of send with transaction commits that create snapshots


Core changes:

* cleanups
  * further removals of now-dead fsync code
  * core function for finding free extent has been split and provides a base
    for further cleanups to make the logic more understandable
  * removed lot of indirect callbacks for data and metadata inodes
  * simplified refcounting and locking for cloned extent buffers
  * removed redundant function arguments
  * defines converted to enums where appropriate

* separate reserve for delayed refs from global reserve, update logic to do
  less trickery and ad-hoc heuristics, move out some related expensive
  operations from transaction commit or file truncate

* dev-replace switched from custom locking scheme to semaphore

* remove first phase of balance that tried to make some space for the
  relocation by calling shrink and grow, this did not work as expected and only
  introduced more error states due to potential resize failures, slightly
  improves the runtime as the chunks on all devices are not needlessly
  enumerated

* clone and deduplication now use generic helper that adds a few more checks
  that were missing from the original btrfs implementation of the ioctls

----------------------------------------------------------------
The following changes since commit 7566ec393f4161572ba6f11ad5171fd5d59b0fbd:

  Linux 4.20-rc7 (2018-12-16 15:46:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.21-tag

for you to fetch changes up to 52042d8e82ff50d40e76a275ac0b97aa663328b0:

  btrfs: Fix typos in comments and strings (2018-12-17 14:51:50 +0100)

----------------------------------------------------------------
Anand Jain (14):
      btrfs: remove redundant replace_state init
      btrfs: harden agaist duplicate fsid on scanned devices
      btrfs: mark btrfs_dev_replace_start as static
      btrfs: dev-replace: go back to suspended state if target device is missing
      btrfs: dev-replace: go back to suspend state if another EXCL_OP is running
      btrfs: fix use-after-free due to race between replace start and cancel
      btrfs: dev-replace: set result code of cancel by status of scrub
      btrfs: dev-replace: replace's scrub must not be running in suspended state
      btrfs: dev-replace: add explicit check for replace result "no error"
      btrfs: silence warning if replace is canceled
      btrfs: don't report user-requested cancel as an error
      btrfs: add helper to describe block group flags
      btrfs: balance: print args during start and resume
      btrfs: balance: print to system log when balance ends or is paused

Andrea Gelmini (1):
      btrfs: Fix typos in comments and strings

David Sterba (18):
      btrfs: merge btrfs_submit_bio_done to its caller
      btrfs: replace async_cow::root with fs_info
      btrfs: remove redundant csum buffer in btrfs_io_bio
      btrfs: replace btrfs_io_bio::end_io with a simple helper
      btrfs: switch BTRFS_FS_STATE_* to enums
      btrfs: switch BTRFS_BLOCK_RSV_* to enums
      btrfs: switch BTRFS_FS_* to enums
      btrfs: switch BTRFS_ROOT_* to enums
      btrfs: switch EXTENT_BUFFER_* to enums
      btrfs: switch EXTENT_FLAG_* to enums
      btrfs: switch BTRFS_ORDERED_* to enums
      btrfs: drop extra enum initialization where using defaults
      btrfs: reada: reorder dev-replace locks before radix tree preload
      btrfs: dev-replace: swich locking to rw semaphore
      btrfs: dev-replace: remove custom read/write blocking scheme
      btrfs: dev-replace: open code trivial locking helpers
      btrfs: scrub: pass fs_info to scrub_setup_ctx
      btrfs: scrub: move scrub_setup_ctx allocation out of device_list_mutex

Ethan Lien (1):
      btrfs: use tagged writepage to mitigate livelock of snapshot

Filipe Manana (13):
      Btrfs: remove no longer used logged range variables when logging extents
      Btrfs: remove no longer used stuff for tracking pending ordered extents
      Btrfs: simpler and more efficient cleanup of a log tree's extent io tree
      Btrfs: remove no longer used io_err from btrfs_log_ctx
      Btrfs: allow clear_extent_dirty() to receive a cached extent state record
      Btrfs: fix access to available allocation bits when starting balance
      Btrfs: fix deadlock when enabling quotas due to concurrent snapshot creation
      Btrfs: fix deadlock with memory reclaim during scrub
      Btrfs: fix fsync of files with multiple hard links in new directories
      Btrfs: scrub, move setup of nofs contexts higher in the stack
      Btrfs: use nofs context when initializing security xattrs to avoid deadlock
      Btrfs: send, fix race with transaction commits that create snapshots
      Btrfs: use generic_remap_file_range_prep() for cloning and deduplication

Hans van Kranenburg (5):
      btrfs: alloc_chunk: do not refurbish num_bytes
      btrfs: alloc_chunk: improve chunk size variable name
      btrfs: alloc_chunk: fix more DUP stripe size handling
      btrfs: fix ncopies raid_attr for RAID56
      btrfs: introduce nparity raid_attr

Johannes Thumshirn (9):
      btrfs: remove unused drop_on_err in btrfs_mkdir
      btrfs: introduce EXPORT_FOR_TESTS macro
      btrfs: use EXPORT_FOR_TESTS for conditionally exported functions
      btrfs: remove btrfs_bio_end_io_t
      btrfs: don't initialize 'offset' in map_private_extent_buffer()
      btrfs: document extent mapping assumptions in checksum
      btrfs: use offset_in_page instead of open-coding it
      btrfs: use PAGE_ALIGNED instead of open-coding it
      btrfs: improve error handling of btrfs_add_link

Josef Bacik (12):
      btrfs: add btrfs_delete_ref_head helper
      btrfs: add cleanup_ref_head_accounting helper
      btrfs: cleanup extent_op handling
      btrfs: only track ref_heads in delayed_ref_updates
      btrfs: introduce delayed_refs_rsv
      btrfs: update may_commit_transaction to use the delayed refs rsv
      btrfs: add new flushing states for the delayed refs rsv
      btrfs: rework btrfs_check_space_for_delayed_refs
      btrfs: don't run delayed refs in the end transaction logic
      btrfs: fix truncate throttling
      btrfs: catch cow on deleting snapshots
      btrfs: run delayed items before dropping the snapshot

Lu Fengqi (4):
      btrfs: extent-tree: Detect bytes_pinned underflow earlier
      btrfs: cleanup the useless DEFINE_WAIT in cleanup_transaction
      btrfs: skip file_extent generation check for free_space_inode in run_delalloc_nocow
      btrfs: remove always true if branch in find_delalloc_range

Nikolay Borisov (36):
      btrfs: Add function to distinguish between data and btree inode
      btrfs: Remove extent_io_ops::fill_delalloc
      btrfs: Remove extent_io_ops::writepage_start_hook
      btrfs: Remove extent_io_ops::writepage_end_io_hook
      btrfs: Remove extent_io_ops::check_extent_io_range callback
      btrfs: Remove extent_io_ops::set_bit_hook extent_io callback
      btrfs: Remove extent_io_ops::clear_bit_hook callback
      btrfs: Remove extent_io_ops::merge_extent_hook callback
      btrfs: Remove extent_io_ops::split_extent_hook callback
      btrfs: Remove needless tree locking in iterate_inode_refs
      btrfs: Remove needless tree locking in iterate_inode_extrefs
      btrfs: Remove redundant extent_buffer_get in get_old_root
      btrfs: Remove extraneous extent_buffer_get from tree_mod_log_rewind
      btrfs: Remove extra reference count bumps in btrfs_compare_trees
      btrfs: Remove unnecessary tree locking code in qgroup_rescan_leaf
      btrfs: Remove special handling of EXTENT_BUFFER_UNMAPPED while freeing
      btrfs: Adjust loop in free_extent_buffer
      btrfs: Check for missing device before bio submission in btrfs_map_bio
      btrfs: Move epd::extent_locked check to writepage_delalloc's caller
      btrfs: Remove extent_page_data argument from writepage_delalloc
      btrfs: Remove unused extent_state argument from btrfs_writepage_endio_finish_ordered
      btrfs: Remove superfluous check form btrfs_remove_chunk
      btrfs: Sink find_lock_delalloc_range's 'max_bytes' argument
      btrfs: Replace BUG_ON with ASSERT in find_lock_delalloc_range
      btrfs: Introduce support for FSID change without metadata rewrite
      btrfs: Add sysfs support for metadata_uuid feature
      btrfs: Remove fsid/metadata_fsid fields from btrfs_info
      btrfs: Add handling for disk split-brain scenario during fsid change
      btrfs: add members to fs_devices to track fsid changes
      btrfs: Handle one more split-brain scenario during fsid change
      btrfs: Handle final split-brain possibility during fsid change
      btrfs: Remove extent_io_ops::readpage_io_failed_hook
      btrfs: Refactor btrfs_merge_bio_hook
      btrfs: Fix error handling in btrfs_cleanup_ordered_extents
      btrfs: Remove 1st shrink/grow phase from balance
      btrfs: Refactor main loop in extent_readpages

Omar Sandoval (3):
      Btrfs: prevent ioctls from interfering with a swap file
      Btrfs: rename and export get_chunk_map
      Btrfs: support swap files

Qu Wenruo (9):
      btrfs: extent-tree: Detect bytes_may_use underflow earlier
      btrfs: Introduce find_free_extent_ctl structure for later rework
      btrfs: Refactor clustered extent allocation into find_free_extent_clustered
      btrfs: Refactor unclustered extent allocation into find_free_extent_unclustered()
      btrfs: Refactor find_free_extent loops update into find_free_extent_update_loop
      btrfs: volumes: Make sure there is no overlap of dev extents at mount time
      btrfs: volumes: Make sure no dev extent is beyond device boundary
      btrfs: tests: Use BTRFS_MAX_EXTENT_SIZE to replace the intermediate number
      btrfs: extent-tree: cleanup one-shot usage of @blocksize in do_walk_down

 fs/btrfs/backref.c               |   13 +-
 fs/btrfs/btrfs_inode.h           |   14 +-
 fs/btrfs/check-integrity.c       |   24 +-
 fs/btrfs/compression.c           |   26 +-
 fs/btrfs/ctree.c                 |   46 +-
 fs/btrfs/ctree.h                 |  263 +++++---
 fs/btrfs/delayed-ref.c           |   61 +-
 fs/btrfs/delayed-ref.h           |    3 +-
 fs/btrfs/dev-replace.c           |  191 +++---
 fs/btrfs/dev-replace.h           |    8 -
 fs/btrfs/disk-io.c               |  117 ++--
 fs/btrfs/disk-io.h               |   10 +-
 fs/btrfs/extent-tree.c           | 1254 ++++++++++++++++++++++++--------------
 fs/btrfs/extent_io.c             |  414 ++++++-------
 fs/btrfs/extent_io.h             |   66 +-
 fs/btrfs/extent_map.c            |    3 +-
 fs/btrfs/extent_map.h            |   21 +-
 fs/btrfs/file-item.c             |   13 +-
 fs/btrfs/file.c                  |   29 +-
 fs/btrfs/free-space-tree.c       |   15 +-
 fs/btrfs/inode.c                 |  665 ++++++++++++++------
 fs/btrfs/ioctl.c                 |  643 +++++--------------
 fs/btrfs/lzo.c                   |    2 +-
 fs/btrfs/ordered-data.c          |   30 -
 fs/btrfs/ordered-data.h          |   47 +-
 fs/btrfs/qgroup.c                |   35 +-
 fs/btrfs/qgroup.h                |    6 +-
 fs/btrfs/raid56.c                |    2 +-
 fs/btrfs/reada.c                 |   16 +-
 fs/btrfs/ref-verify.c            |    6 +-
 fs/btrfs/relocation.c            |   50 +-
 fs/btrfs/scrub.c                 |   85 ++-
 fs/btrfs/send.c                  |    6 +-
 fs/btrfs/super.c                 |   10 +-
 fs/btrfs/sysfs.c                 |   14 +
 fs/btrfs/sysfs.h                 |    2 +-
 fs/btrfs/tests/btrfs-tests.c     |    4 +-
 fs/btrfs/tests/extent-io-tests.c |   29 +-
 fs/btrfs/tests/inode-tests.c     |    6 -
 fs/btrfs/transaction.c           |   93 ++-
 fs/btrfs/transaction.h           |   16 +-
 fs/btrfs/tree-checker.c          |    6 +-
 fs/btrfs/tree-log.c              |   44 +-
 fs/btrfs/tree-log.h              |    2 -
 fs/btrfs/volumes.c               |  779 +++++++++++++++++------
 fs/btrfs/volumes.h               |   25 +-
 fs/btrfs/xattr.c                 |    8 +
 include/trace/events/btrfs.h     |    4 +-
 include/uapi/linux/btrfs.h       |    1 +
 include/uapi/linux/btrfs_tree.h  |    1 +
 50 files changed, 3030 insertions(+), 2198 deletions(-)
