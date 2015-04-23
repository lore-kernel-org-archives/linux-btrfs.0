Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15494 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030674AbbDWVc1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 17:32:27 -0400
Date: Thu, 23 Apr 2015 17:32:22 -0400
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs for 4.1
Message-ID: <20150423213046.GA30304@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.1

I've been running these through a longer set of load tests because my
commits change the free space cache writeout.  It fixes commit
stalls on large filesystems (~20T space used and up) that we have been
triggering here.  We were seeing new writers blocked for 10 seconds or
more during commits, which is far from good.

Josef and I fixed up ENOSPC aborts when deleting huge files (3T or
more), that are triggered because our metadata reservations were not
properly accounting for crcs and were not replenishing during the
truncate.

Also in this series, a number of qgroup fixes from Fujitsu and Dave
Sterba collected most of the pending cleanups from the list.

David Sterba (19) commits (+280/-269):
    btrfs: constify structs with op functions or static definitions (+13/-11)
    btrfs: cleanup, reduce temporary variables in btrfs_read_roots (+25/-29)
    btrfs: replace remaining do_div calls with div_u64 variants (+20/-19)
    btrfs: replace remaining do_div calls with div_u64 variants (+20/-19)
    btrfs: remove shadowing variables in __btrfs_buffered_write (+2/-2)
    btrfs: cleanup 64bit/32bit divs, provably bounded values (+24/-26)
    btrfs: cleanup 64bit/32bit divs, provably bounded values (+24/-26)
    btrfs: switch helper macros to static inlines in sysfs.h (+17/-5)
    btrfs: cleanup, use kmalloc_array/kcalloc array helpers (+18/-21)
    btrfs: cleanup 64bit/32bit divs, compile time constants (+18/-21)
    btrfs: cleanup 64bit/32bit divs, compile time constants (+18/-21)
    btrfs: remove shadowing variables in __btrfs_map_block (+1/-4)
    btrfs: don't accept bare namespace as a valid xattr (+39/-14)
    btrfs: need_resched not needed with cond_resched (+3/-4)
    btrfs: cleanup, use correct type in div_u64_rem (+9/-8)
    btrfs: cleanup, use correct type in div_u64_rem (+9/-8)
    btrfs: use explicit initializer for seq_elem (+8/-6)
    btrfs: use cond_resched_lock where possible (+7/-20)
    btrfs: use correct type for workqueue flags (+5/-5)

Dongsheng Yang (13) commits (+231/-199):
    btrfs: qgroup: update qgroup in memory at the same time when we update it in btree. (+17/-11)
    btrfs: qgroup: consolidate the parameter of fucntion update_qgroup_limit_item(). (+24/-27)
    Btrfs: qgroup: cleanup, remove an unsued parameter in btrfs_create_qgroup(). (+5/-7)
    btrfs: qgroup: return EINVAL if level of parent is not higher than child's. (+5/-0)
    Btrfs: qgroup: Introduce a may_use to account space_info->bytes_may_use. (+104/-6)
    btrfs: qgroup: allow to remove qgroup which has parent but no child. (+25/-5)
    btrfs: qgroup: inherit limit info from srcgroup in creating snapshot. (+8/-0)
    btrfs: qgroup: update limit info in function btrfs_run_qgroups(). (+4/-0)
    Btrfs: qgroup, Account data space in more proper timings. (+10/-16)
    btrfs: qgroup: fix limit args override whole limit struct (+10/-5)
    btrfs: qgroup: clear STATUS_FLAG_ON in disabling quota. (+1/-0)
    btrfs: qgroup: do a reservation in a higher level. (+14/-121)
    Btrfs: qgroup: free reserved in exceeding quota. (+4/-1)

Filipe Manana (12) commits (+421/-104):
    Btrfs: send, don't leave without decrementing clone root's send_progress (+2/-2)
    Btrfs: fix range cloning when same inode used as source and destination (+4/-2)
    Btrfs: change the insertion criteria for the qgroup operations rbtree (+4/-4)
    Btrfs: incremental send, clear name from cache after orphanization (+17/-0)
    Btrfs: fix inode eviction infinite loop after extent_same ioctl (+3/-0)
    Btrfs: fix log tree corruption when fs mounted with -o discard (+2/-3)
    Btrfs: fix inode eviction infinite loop after cloning into it (+5/-0)
    Btrfs: fix metadata inconsistencies after directory fsync (+253/-10)
    Btrfs: add missing inode item update in fallocate() (+20/-9)
    Btrfs: remove deleted xattrs on fsync log replay (+109/-14)
    Btrfs: send, add missing check for dead clone root (+2/-1)
    Btrfs: incremental send, remove dead code (+0/-59)

Eric Sandeen (10) commits (+291/-241):
    btrfs: factor btrfs_init_dev_replace_locks() out of open_ctree() (+12/-6)
    btrfs: remove unused fs_info arg from btrfs_close_extra_devices() (+4/-6)
    btrfs: factor btrfs_init_btree_inode() out of open_ctree() (+31/-25)
    btrfs: factor btrfs_init_workqueues() out of open_ctree() (+83/-70)
    btrfs: factor btrfs_init_qgroup() out of open_ctree() (+15/-11)
    btrfs: factor btrfs_init_balance() out of open_ctree() (+12/-8)
    btrfs: factor btrfs_read_roots() out of open_ctree() (+66/-65)
    btrfs: factor btrfs_replay_log() out of open_ctree() (+53/-40)
    btrfs: factor btrfs_init_scrub() out of open_ctree() (+12/-7)
    btrfs: consistently use fs_info in close_ctree() (+3/-3)

Zhao Lei (10) commits (+88/-54):
    btrfs: cleanup: remove no-used alloc_chunk in btrfs_check_data_free_space() (+2/-2)
    btrfs: Set relative data on clear btrfs_block_group_cache->pinned (+10/-0)
    btrfs: Adjust commit-transaction condition to avoid NO_SPACE more (+2/-1)
    btrfs: remove unused chunk_tree argument in several functions (+6/-14)
    btrfs: Fix tail space processing in find_free_dev_extent() (+13/-11)
    btrfs: add WARN_ON() to check is space_info op current (+10/-0)
    btrfs: cleanup: use for() loop in btrfs_map_bio() (+3/-6)
    btrfs: Fix NO_SPACE bug caused by delayed-iput (+13/-1)
    btrfs: Support busy loop of write and delete (+14/-12)
    btrfs: fix condition of commit transaction (+15/-7)

Chris Mason (9) commits (+656/-128):
    Btrfs: allow block group cache writeout outside critical section in commit (+341/-37)
    Btrfs: free and unlock our path before btrfs_free_and_pin_reserved_extent() (+1/-1)
    btrfs: actively run the delayed refs while deleting large files (+52/-5)
    Btrfs: fix use after free when close_ctree frees the orphan_rsv (+7/-1)
    btrfs: move struct io_ctl into ctree.h and rename it (+33/-33)
    Btrfs: don't use highmem for free space cache pages (+5/-7)
    Btrfs: two stage dirty block group writeout (+170/-32)
    Btrfs: refill block reserves during truncate (+46/-11)
    Btrfs: fix uninit variable in clone ioctl (+1/-1)

Qu Wenruo (6) commits (+177/-62):
    btrfs: quota: Automatically update related qgroups or mark INCONSISTENT flags when assigning/deleting a qgroup relations. (+126/-57)
    btrfs: Don't allow subvolid >= (1 << BTRFS_QGROUP_LEVEL_SHIFT) to be created (+9/-1)
    btrfs: qgroup: Fix dead judgement on qgroup_rescan_leaf() return value. (+3/-3)
    btrfs: quota: Update quota tree after qgroup relationship change. (+5/-0)
    btrfs: Update btrfs qgroup status item when rescan is done. (+24/-1)
    btrfs: Check qgroup level in kernel qgroup assign. (+10/-0)

Josef Bacik (4) commits (+146/-35):
    Btrfs: don't steal from the global reserve if we don't have the space (+44/-2)
    Btrfs: don't commit the transaction in the async space flushing (+8/-6)
    Btrfs: account for crcs in delayed ref processing (+83/-24)
    Btrfs: reserve space for block groups (+11/-3)

Daniel Dressler (3) commits (+67/-60):
    Btrfs: delayed-inode: replace root args iff only fs_info used (+5/-4)
    Btrfs: disk-io: replace root args iff only fs_info used (+40/-38)
    Btrfs: ctree: reduce args where only fs_info used (+22/-18)

Jeff Mahoney (1) commits (+9/-0):
    btrfs: cleanup orphans while looking up default subvolume

Guenter Roeck (1) commits (+1/-0):
    fs: btrfs: Add missing include file

Chengyu Song (1) commits (+4/-1):
    btrfs: incorrect handling for fiemap_fill_next_extent return

Liu Bo (1) commits (+0/-6):
    Btrfs: Remove the check for old-style mkfs

Fabian Frederick (1) commits (+1/-1):
    btrfs: fix sizeof format specifier in btrfs_check_super_valid()

Tom Van Braeckel (1) commits (+12/-0):
    btrfs: explicitly set control file's private_data

Wang Shilong (1) commits (+4/-14):
    Btrfs: switch to kvfree() helper

Total: (93) commits

 fs/btrfs/async-thread.c       |   4 +-
 fs/btrfs/async-thread.h       |   2 +-
 fs/btrfs/backref.c            |   4 +-
 fs/btrfs/btrfs_inode.h        |  14 +-
 fs/btrfs/check-integrity.c    |   9 +-
 fs/btrfs/compression.c        |   4 +-
 fs/btrfs/compression.h        |   4 +-
 fs/btrfs/ctree.c              |  62 ++---
 fs/btrfs/ctree.h              |  46 +++-
 fs/btrfs/delayed-inode.c      |   9 +-
 fs/btrfs/delayed-ref.c        |  22 +-
 fs/btrfs/delayed-ref.h        |  10 +
 fs/btrfs/dev-replace.c        |   6 +-
 fs/btrfs/disk-io.c            | 570 +++++++++++++++++++++++-------------------
 fs/btrfs/disk-io.h            |   4 +-
 fs/btrfs/extent-tree.c        | 476 ++++++++++++++++++++++++++++-------
 fs/btrfs/extent_io.c          |   5 +-
 fs/btrfs/extent_io.h          |   2 +-
 fs/btrfs/file-item.c          |   6 +-
 fs/btrfs/file.c               |  65 ++---
 fs/btrfs/free-space-cache.c   | 301 +++++++++++++++-------
 fs/btrfs/free-space-cache.h   |   9 +-
 fs/btrfs/inode-map.c          |   2 +-
 fs/btrfs/inode.c              | 147 ++++++++++-
 fs/btrfs/ioctl.c              |  33 ++-
 fs/btrfs/lzo.c                |   2 +-
 fs/btrfs/math.h               |   6 +-
 fs/btrfs/props.c              |   2 +
 fs/btrfs/qgroup.c             | 348 ++++++++++++++++++--------
 fs/btrfs/qgroup.h             |   3 +-
 fs/btrfs/raid56.c             |  16 +-
 fs/btrfs/relocation.c         |  11 +-
 fs/btrfs/scrub.c              |  25 +-
 fs/btrfs/send.c               |  83 ++----
 fs/btrfs/super.c              |  23 +-
 fs/btrfs/sysfs.c              |   2 +-
 fs/btrfs/sysfs.h              |  22 +-
 fs/btrfs/tests/qgroup-tests.c |   4 +-
 fs/btrfs/transaction.c        |  54 +++-
 fs/btrfs/transaction.h        |  12 +
 fs/btrfs/tree-log.c           | 382 ++++++++++++++++++++++++++--
 fs/btrfs/tree-log.h           |   2 +
 fs/btrfs/volumes.c            | 140 +++++------
 fs/btrfs/volumes.h            |   3 +-
 fs/btrfs/xattr.c              |  53 ++--
 fs/btrfs/zlib.c               |   2 +-
 46 files changed, 2114 insertions(+), 897 deletions(-)
