Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55363 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbbBSUhC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 15:37:02 -0500
Date: Thu, 19 Feb 2015 15:36:55 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150219203648.GA26100@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This was held up a little trying to track down a use-after-free in btrfs
raid5/6.  It's not clear yet if this is just made easier to trigger with
this pull or if its a new bug from the raid5/6 cleanups.  Dave Sterba is
the only one to trigger it so far, but he has a consistent way to
reproduce, so we'll get it nailed shortly.

This pull is mostly cleanups and fixes.

The raid5/6 cleanups from Zhao Lei fixup some long standing warts in the
code and add improvements on top of the scrubbing support from 3.19.

Josef has round one of our ENOSPC fixes coming from large btrfs clusters
here at FB.

Dave Sterba continues a long series of cleanups (thanks Dave), and
Filipe continues hammering on corner cases in fsync and others.

David Sterba (25) commits (+332/-306):
    btrfs: more superblock checks, lower bounds on devices and sectorsize/nodesize (+19/-0)
    btrfs: sink blocksize parameter to btrfs_find_create_tree_block (+17/-12)
    btrfs: cleanup, rename a few variables in btrfs_read_sys_array (+16/-15)
    btrfs: sink blocksize parameter to reada_tree_block_flagged (+4/-4)
    btrfs: sink blocksize parameter to btrfs_init_new_buffer (+4/-5)
    btrfs: sink blocksize parameter to readahead_tree_block (+8/-11)
    btrfs: sink blocksize parameter to tree_block_processed (+5/-4)
    btrfs: use GFP_NOFS in __alloc_extent_buffer directly (+5/-5)
    btrfs: set proper message level for skinny metadata (+1/-1)
    btrfs: expand btrfs_find_item if found_key is NULL (+21/-8)
    btrfs: update message levels after checksum errors (+2/-2)
    btrfs: remove a no-op unfreeze superbock callback (+0/-6)
    btrfs: update message levels during failed mount (+8/-8)
    btrfs: sink parameter len to alloc_extent_buffer (+8/-8)
    btrfs: add more checks to btrfs_read_sys_array (+23/-3)
    btrfs: switch extent_state state to unsigned (+55/-55)
    btrfs: cleanup, remove inode_item_info helper (+5/-15)
    btrfs: cleanup, remove inode_ref_info helper (+6/-11)
    btrfs: add checks for sys_chunk_array sizes (+19/-0)
    btrfs: fix leak of path in btrfs_find_item (+22/-15)
    btrfs: unify extent buffer allocation api (+35/-23)
    btrfs: remove blocksize from reada_extent (+6/-9)
    btrfs: kill btrfs_inode_*time helpers (+33/-69)
    btrfs: update message levels for errors (+6/-5)
    btrfs: simplify insert_orphan_item (+4/-12)

Zhao Lei (16) commits (+332/-400):
    Btrfs: Separate finding-right-mirror and writing-to-target's process in scrub_handle_errored_block() (+17/-27)
    Btrfs: Break loop when reach BTRFS_MAX_MIRRORS in scrub_setup_recheck_block() (+1/-1)
    Btrfs: Introduce BTRFS_BLOCK_GROUP_RAID56_MASK to check raid56 simply (+19/-28)
    Btrfs: Remove noneed force_write in scrub_write_block_to_dev_replace (+7/-12)
    Btrfs: Fix a jump typo of nodatasum_case to avoid wrong WARN_ON() (+2/-1)
    Btrfs: Make raid_map array be inlined in btrfs_bio structure (+105/-125)
    Btrfs: Combine per-page recover in dev-replace and scrub (+48/-72)
    Btrfs: btrfs_rm_dev_replace_blocked(): Use wait_event() (+2/-11)
    Btrfs: Simplify scrub_setup_recheck_block()'s argument (+9/-16)
    Btrfs: add ref_count and free function for btrfs_bio (+57/-54)
    Btrfs: sort raid_map before adding tgtdev stripes (+8/-14)
    Btrfs: Cleanup btrfs_bio_counter_inc_blocked() (+6/-6)
    Btrfs: fix a out-of-bound access of raid_map (+5/-2)
    Rename all ref_count to refs in struct (+13/-13)
    Btrfs: Include map_type in raid_bio (+22/-18)
    btrfs: Fix out-of-space bug (+11/-0)

Filipe Manana (12) commits (+257/-65):
    Btrfs: fix fsync log replay for inodes with a mix of regular refs and extrefs (+43/-5)
    Btrfs: fix race between transaction commit and empty block group removal (+22/-1)
    Btrfs: lookup for block group only if needed when freeing a tree block (+6/-4)
    Btrfs: don't remove extents and xattrs when logging new names (+27/-12)
    Btrfs: fix fsync when extend references are added to an inode (+16/-11)
    Btrfs: fix fsync data loss after adding hard link to inode (+73/-9)
    Btrfs: fix directory inconsistency after fsync log replay (+18/-2)
    Btrfs: fix setup_leaf_for_split() to avoid leaf corruption (+4/-2)
    Btrfs: fix scrub race leading to use-after-free (+15/-1)
    Btrfs: add missing cleanup on sysfs init failure (+9/-1)
    Btrfs: fix scheduler warning when syncing log (+1/-1)
    Btrfs: scrub, fix sleep in atomic context (+23/-16)

Josef Bacik (5) commits (+177/-147):
    Btrfs: only adjust outstanding_extents when we do a short write (+6/-5)
    Btrfs: don't set and clear delalloc for O_DIRECT writes (+2/-6)
    Btrfs: track dirty block groups on their own list (+72/-124)
    Btrfs: account for large extents with enospc (+76/-7)
    Btrfs: change how we track dirty roots (+21/-5)

Shaohua Li (1) commits (+5/-8):
    btrfs: delete chunk allocation attemp when setting block group ro

Yang Dongsheng (1) commits (+1/-2):
    btrfs: qgroup: move WARN_ON() to the correct location.

Anand Jain (1) commits (+0/-4):
    Btrfs: fix unused members in struct btrfs_root

Liu Bo (1) commits (+1/-4):
    Btrfs: cleanup unused run_most

Satoru Takeuchi (1) commits (+1/-2):
    Btrfs: Remove unnecessary placeholder in btrfs_err_code

chandan r (1) commits (+36/-2):
    Btrfs: Add code to support file creation time

Forrest Liu (1) commits (+2/-1):
    Btrfs: fix BUG_ON in btrfs_orphan_add() when delete unused block group

chandan (1) commits (+1/-1):
    Btrfs: insert_new_root: Fix lock type of the extent buffer.

Naohiro Aota (1) commits (+3/-1):
    btrfs: clear bio reference after submit_one_bio()

Gui Hecheng (1) commits (+1/-4):
    btrfs: cleanup init for list in free-space-cache

Total: (68) commits (+1149/-947)

 fs/btrfs/backref.c                   |  28 +---
 fs/btrfs/backref.h                   |   3 -
 fs/btrfs/btrfs_inode.h               |   3 +
 fs/btrfs/ctree.c                     |  55 +++----
 fs/btrfs/ctree.h                     |  39 ++---
 fs/btrfs/delayed-inode.c             |  38 +++--
 fs/btrfs/dev-replace.c               |  25 +--
 fs/btrfs/disk-io.c                   | 102 +++++++++---
 fs/btrfs/disk-io.h                   |   6 +-
 fs/btrfs/extent-tree.c               | 250 ++++++++++++----------------
 fs/btrfs/extent_io.c                 |  87 ++++++----
 fs/btrfs/extent_io.h                 |  65 ++++----
 fs/btrfs/free-space-cache.c          |  13 +-
 fs/btrfs/inode-item.c                |   9 +-
 fs/btrfs/inode.c                     | 156 +++++++++++++-----
 fs/btrfs/qgroup.c                    |   3 +-
 fs/btrfs/raid56.c                    | 103 ++++--------
 fs/btrfs/raid56.h                    |  11 +-
 fs/btrfs/reada.c                     |  19 +--
 fs/btrfs/relocation.c                |  12 +-
 fs/btrfs/scrub.c                     | 309 ++++++++++++++++-------------------
 fs/btrfs/send.c                      |   9 +-
 fs/btrfs/super.c                     |   6 -
 fs/btrfs/sysfs.c                     |  10 +-
 fs/btrfs/tests/extent-buffer-tests.c |   2 +-
 fs/btrfs/tests/extent-io-tests.c     |   3 +-
 fs/btrfs/tests/inode-tests.c         |   4 +-
 fs/btrfs/tests/qgroup-tests.c        |  23 ++-
 fs/btrfs/transaction.c               |  27 ++-
 fs/btrfs/transaction.h               |   7 +
 fs/btrfs/tree-log.c                  | 234 ++++++++++++++++++++------
 fs/btrfs/volumes.c                   | 242 +++++++++++++++------------
 fs/btrfs/volumes.h                   |  18 +-
 include/uapi/linux/btrfs.h           |   3 +-
 34 files changed, 1063 insertions(+), 861 deletions(-)
