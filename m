Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52574 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab3GITSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 15:18:52 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 190717C0056
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jul 2013 13:18:51 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Message-ID: <20130709191848.12026.56398@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Tue, 9 Jul 2013 15:18:48 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

This Btrfs pull is available in two flavors:

First, my for-linus branch has it against all the btrfs pulls from 3.10:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Or, with a merge commit on top of 3.10 (master branch):

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git master

I did it this way because the 3.10 merge was pretty much empty and you
probably don't want my merge commit at the top.

There's a trivial conflict with your current master involving a printk spelling
fix, but these are otherwise clean and tested against your current tree.

These are the usual mixture of bugs, cleanups and performance fixes.  Miao has
some really nice tuning of our crc code as well as our transaction commits.

Josef is peeling off more and more problems related to early enospc, and has a
number of important bug fixes in here too.

The stats below are against my for-linus branch.

Josef Bacik (27) commits (+865/-590):
    Btrfs: move btrfs_truncate_page to btrfs_cont_expand instead of btrfs_truncate (+35/-12)
    Btrfs: check for actual acls rather than just xattrs when caching no acl (+16/-2)
    Btrfs: stop using try_to_writeback_inodes_sb_nr to flush delalloc (+4/-5)
    Btrfs: fix not being able to find skinny extents during relocate (+27/-8)
    Btrfs: exclude logged extents before replying when we are mixed (+99/-37)
    Btrfs: only do the tree_mod_log_free_eb if this is our last ref (+2/-1)
    Btrfs: make the chunk allocator completely tree lockless (+166/-169)
    Btrfs: check if we can nocow if we don't have data space (+148/-26)
    Btrfs: use a percpu to keep track of possibly pinned bytes (+66/-5)
    Btrfs: unlock extent range on enospc in compressed submit (+5/-1)
    Btrfs: make backref walking code handle skinny metadata (+25/-6)
    Btrfs: add some missing iput()'s in btrfs_orphan_cleanup (+4/-1)
    Btrfs: hold the tree mod lock in __tree_mod_log_rewind (+6/-4)
    Btrfs: cleanup backref search commit root flag stuff (+16/-27)
    Btrfs: free csums when we're done scrubbing an extent (+1/-0)
    Btrfs: fix transaction throttling for delayed refs (+69/-18)
    Btrfs: wake up delayed ref flushing waiters on abort (+1/-0)
    Btrfs: stop waiting on current trans if we aborted (+11/-4)
    Btrfs: wait ordered range before doing direct io (+9/-1)
    Btrfs: put our inode if orphan cleanup fails (+3/-1)
    Btrfs: cleanup orphaned root orphan item (+29/-2)
    Btrfs: optimize read_block_for_search (+20/-27)
    Btrfs: do not pin while under spin lock (+8/-4)
    Btrfs: simplify unlink reservations (+50/-191)
    Btrfs: optimize reada_for_balance (+9/-37)
    Btrfs: fix estale with btrfs send (+35/-0)
    Btrfs: do delay iput in sync_fs (+1/-1)

Miao Xie (24) commits (+1043/-797):
    Btrfs: cleanup unnecessary assignment when cleaning up all the residual transaction (+1/-8)
    Btrfs: don't flush the delalloc inodes in the while loop if flushoncommit is set (+18/-8)
    Btrfs: just flush the delalloc inodes in the source tree before snapshot creation (+7/-9)
    Btrfs: don't wait for all the writers circularly during the transaction commit (+65/-21)
    Btrfs: remove unnecessary varient ->num_joined in btrfs_transaction structure (+1/-9)
    Btrfs: make the cleaner complete early when the fs is going to be umounted (+7/-5)
    Btrfs: remove the code for the impossible case in cleanup_transaction() (+6/-5)
    Btrfs: make the snap/subv deletion end more early when the fs is R/O (+15/-14)
    Btrfs: introduce grab/put functions for the root of the fs/file tree (+26/-3)
    Btrfs: fix several potential problems in copy_nocow_pages_for_inode (+22/-1)
    Btrfs: move the R/O check out of btrfs_clean_one_deleted_snapshot() (+9/-5)
    Btrfs: fix oops when recovering the file data by scrub function (+1/-1)
    Btrfs: remove the time check in btrfs_commit_transaction() (+6/-23)
    Btrfs: remove unnecessary ->s_umount in cleaner_kthread() (+28/-12)
    Btrfs: cleanup the code of copy_nocow_pages_for_inode() (+23/-25)
    Btrfs: make the state of the transaction more readable (+116/-94)
    Btrfs: cleanup the similar code of the fs root read (+228/-269)
    Btrfs: cleanup redundant code in btrfs_submit_direct() (+1/-9)
    Btrfs: introduce per-subvolume ordered extent list (+143/-58)
    Btrfs: introduce per-subvolume delalloc inode list (+183/-67)
    Btrfs: merge pending IO for tree log write back (+17/-6)
    Btrfs: remove btrfs_sector_sum structure (+76/-142)
    Btrfs: fix broken nocow after balance (+44/-0)
    Btrfs: fix wrong mirror number tuning (+0/-3)

Liu Bo (8) commits (+65/-39):
    Btrfs: check if leaf's parent exists before pushing items around (+1/-1)
    Btrfs: kill replicate code in replay_one_buffer (+2/-7)
    Btrfs: fix crash regarding to ulist_add_merge (+15/-0)
    Btrfs: dont do log_removal in insert_new_root (+5/-5)
    Btrfs: allow file data clone within a file (+19/-7)
    Btrfs: remove unused code in btrfs_del_root (+0/-4)
    Btrfs: update new flags for tracepoint (+23/-12)
    Btrfs: remove useless copy in quota_ctl (+0/-3)

Stefan Behrens (4) commits (+3/-50):
    Btrfs: cleanup, btrfs_read_fs_root_no_name() doesn't return NULL (+2/-8)
    Btrfs: cleanup: don't check the same thing twice (+0/-27)
    Btrfs: delete unused function (+0/-14)
    Btrfs: fix a comment (+1/-1)

Jan Schmidt (4) commits (+168/-72):
    Btrfs: fix memory patcher through fs_info->qgroup_ulist (+1/-1)
    Btrfs: add ioctl to wait for qgroup rescan completion (+36/-0)
    Btrfs: avoid double free of fs_info->qgroup_ulist (+6/-2)
    Btrfs: fix qgroup rescan resume on mount (+125/-69)

David Sterba (4) commits (+92/-59):
    btrfs: show compiled-in config features at module load time (+13/-6)
    btrfs: move ifdef around sanity checks out of init_btrfs_fs (+3/-5)
    btrfs: add debug check for extent_io range alignment (+27/-0)
    btrfs: add prefix to sanity tests messages (+49/-48)

Thomas Meyer (2) commits (+2/-6):
    Btrfs: Cocci spatch "ptr_ret.spatch" (+1/-4)
    Btrfs: Cocci spatch "memdup.spatch" (+1/-2)

Anand Jain (1) commits (+58/-31):
    btrfs: device delete to get errors from the kernel

Henrik Nordvik (1) commits (+1/-1):
    Btrfs: fix check on same raid type flag twice

Wei Yongjun (1) commits (+1/-1):
    Btrfs: return error code in btrfs_check_trunc_cache_free_space()

Jie Liu (1) commits (+2/-2):
    btrfs: fix the code comments for LZO compression workspace

Wang Shilong (1) commits (+43/-34):
    Btrfs: introduce qgroup_ulist to avoid frequently allocating/freeing ulist

Wang Sheng-Hui (1) commits (+1/-1):
    Btrfs: fix the comment typo for btrfs_attach_transaction_barrier

Tsutomu Itoh (1) commits (+90/-99):
    Btrfs: cleanup unused arguments in send.c

Andreas Philipp (1) commits (+2/-2):
    Minor format cleanup.

Total: (81) commits (+2436/-1784)

 fs/btrfs/backref.c           |  72 ++++---
 fs/btrfs/backref.h           |   2 -
 fs/btrfs/ctree.c             | 120 ++++-------
 fs/btrfs/ctree.h             | 105 +++++++--
 fs/btrfs/delayed-inode.c     |  14 --
 fs/btrfs/dev-replace.c       |   6 +-
 fs/btrfs/disk-io.c           | 483 ++++++++++++++++++++++++-----------------
 fs/btrfs/disk-io.h           |  32 ++-
 fs/btrfs/export.c            |   5 -
 fs/btrfs/extent-tree.c       | 315 +++++++++++++++++++++------
 fs/btrfs/extent_io.c         |  41 +++-
 fs/btrfs/extent_io.h         |   1 +
 fs/btrfs/file-item.c         | 144 +++++--------
 fs/btrfs/file.c              | 150 +++++++++++--
 fs/btrfs/free-space-cache.c  | 103 ++++-----
 fs/btrfs/free-space-cache.h  |   2 -
 fs/btrfs/inode.c             | 501 +++++++++++++++++++------------------------
 fs/btrfs/ioctl.c             |  74 ++++---
 fs/btrfs/lzo.c               |   4 +-
 fs/btrfs/ordered-data.c      | 128 +++++++----
 fs/btrfs/ordered-data.h      |  27 +--
 fs/btrfs/qgroup.c            | 283 +++++++++++++++---------
 fs/btrfs/relocation.c        | 102 ++++++---
 fs/btrfs/root-tree.c         | 201 +++++++----------
 fs/btrfs/scrub.c             |  90 ++++----
 fs/btrfs/send.c              | 235 +++++++++++---------
 fs/btrfs/super.c             |  25 ++-
 fs/btrfs/transaction.c       | 322 ++++++++++++++-------------
 fs/btrfs/transaction.h       |  50 +++--
 fs/btrfs/tree-log.c          |  41 ++--
 fs/btrfs/ulist.c             |  15 ++
 fs/btrfs/version.h           |   4 -
 fs/btrfs/volumes.c           | 351 ++++++++++++++----------------
 fs/btrfs/volumes.h           |   7 +-
 include/trace/events/btrfs.h |  35 +--
 include/uapi/linux/btrfs.h   |  42 +++-
 36 files changed, 2392 insertions(+), 1740 deletions(-)
