Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58576 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751294AbaDAO0P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Apr 2014 10:26:15 -0400
Message-ID: <533ACC62.1080701@fb.com>
Date: Tue, 1 Apr 2014 10:25:38 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs pull -- part 1
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We still have some corruption fixes and other patches coming in for the
merge window, but this batch is tested and ready to go.

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git master

This is a pretty long stream of bug fixes and performance fixes.

Qu Wenruo has replaced the btrfs async threads with regular kernel
workqueues.  We'll keep an eye out for performance differences, but it's
nice to be using more generic code for this.

Miao Xie (23) commits (+621/-237):
    Btrfs: use ACCESS_ONCE to prevent the optimize accesses to ->last_trans_log_full_commit (+10/-7)
    Btrfs: don't mix the ordered extents of all files together during logging the inodes (+49/-35)
    Btrfs: fix unprotected alloc list insertion during the finishing procedure of replace (+3/-0)
    Btrfs: just do dirty page flush for the inode with compression before direct IO (+7/-7)
    Btrfs: fix use-after-free in the finishing procedure of the device replace (+111/-15)
    Btrfs: use signed integer instead of unsigned long integer for log transid (+11/-11)
    Btrfs: don't flush all delalloc inodes when we doesn't get s_umount lock (+29/-24)
    Btrfs: fix possible empty list access when flushing the delalloc inodes (+8/-0)
    Btrfs: fix early enospc due to the race of the two ordered extent wait (+14/-3)
    Btrfs: introduce btrfs_{start, end}_nocow_write() for each subvolume (+133/-10)
    Btrfs: don't start the log transaction if the log tree init fails (+14/-12)
    Btrfs: fix the skipped transaction commit during the file sync (+16/-10)
    Btrfs: fix wrong lock range and write size in check_can_nocow() (+3/-2)
    Btrfs: remove the unnecessary flush when preparing the pages (+5/-8)
    Btrfs: remove unnecessary memory barrier in btrfs_sync_log() (+0/-3)
    Btrfs: remove unnecessary lock in may_commit_transaction() (+1/-8)
    Btrfs: stop joining the log transaction if sync log fails (+14/-2)
    Btrfs: just wait or commit our own log sub-transaction (+47/-23)
    Btrfs: fix skipped error handle when log sync failed (+111/-31)
    Btrfs: wake up the tasks that wait for the io earlier (+10/-4)
    Btrfs: reclaim delalloc metadata more aggressively (+1/-1)
    Btrfs: split the global ordered extents mutex (+7/-13)
    Btrfs: fix preallocate vs double nocow write (+17/-8)

Filipe Manana (21) commits (+482/-153):
    Btrfs: part 2, fix incremental send's decision to delay a dir move/rename (+66/-5)
    Btrfs: don't insert useless holes when punching beyond the inode's size (+17/-11)
    Btrfs: correctly determine if blocks are shared in btrfs_compare_trees (+10/-1)
    Btrfs: fix send issuing outdated paths for utimes, chown and chmod (+12/-19)
    Btrfs: fix incremental send's decision to delay a dir move/rename (+3/-3)
    Btrfs: make defrag not fragment files when using prealloc extents (+2/-1)
    Btrfs: correctly flush data on defrag when compression is enabled (+5/-1)
    Btrfs: remove unneeded field / smaller extent_map structure (+12/-13)
    Btrfs: avoid unnecessary utimes update in incremental send (+11/-10)
    Btrfs: fix send attempting to rmdir non-empty directories (+221/-26)
    Btrfs: send, don't send rmdir for same target multiple times (+4/-1)
    Btrfs: incremental send, fix invalid path after dir rename (+34/-7)
    Btrfs: less fs tree lock contention when using autodefrag (+10/-2)
    Btrfs: remove unnecessary inode generation lookup in send (+2/-7)
    Btrfs: add missing kfree in btrfs_destroy_workqueue (+1/-0)
    Btrfs: more efficient split extent state insertion (+8/-5)
    Btrfs: remove unnecessary ref heads rb tree search (+3/-4)
    Btrfs: fix race when updating existing ref head (+1/-1)
    Btrfs: more efficient btrfs_drop_extent_cache (+45/-14)
    Btrfs: cache extent states in defrag code path (+9/-4)
    Btrfs: cleanup delayed-ref.c:find_ref_head() (+6/-18)

Qu Wenruo (21) commits (+907/-1287):
    btrfs: Added btrfs_workqueue_struct implemented ordered execution based on kernel workqueue (+164/-0)
    btrfs: Replace fs_info->qgroup_rescan_worker workqueue with btrfs_workqueue. (+16/-15)
    btrfs: Replace fs_info->readahead_workers workqueue with btrfs_workqueue. (+11/-14)
    btrfs: Replace fs_info->delayed_workers workqueue with btrfs_workqueue. (+11/-13)
    btrfs: Replace fs_info->fixup_workers workqueue with btrfs_workqueue. (+10/-11)
    btrfs: Replace fs_info->cache_workers workqueue with btrfs_workqueue. (+11/-11)
    btrfs: Add high priority workqueue support for btrfs_workqueue_struct (+83/-13)
    btrfs: Replace fs_info->rmw_workers workqueue with btrfs_workqueue. (+21/-28)
    btrfs: Replace fs_info->scrub_* workqueue with btrfs_workqueue. (+55/-48)
    btrfs: Replace fs_info->endio_* workqueue with btrfs_workqueue. (+68/-81)
    btrfs: Replace fs_info->delalloc_workers with btrfs_workqueue (+14/-20)
    btrfs: Replace fs_info->submit_workers with btrfs_workqueue. (+18/-16)
    btrfs: Replace fs_info->flush_workers with btrfs_workqueue. (+18/-19)
    btrfs: Cleanup the "_struct" suffix in btrfs_workequeue (+116/-120)
    btrfs: Cleanup the btrfs_workqueue related function type (+14/-12)
    btrfs: Add threshold workqueue based on kernel workqueue (+101/-9)
    btrfs: Replace fs_info->workers with btrfs_workqueue. (+23/-22)
    btrfs: Add trace for btrfs_workqueue alloc/destroy (+61/-3)
    btrfs: Cleanup the unused struct async_sched. (+0/-7)
    btrfs: Add ftrace for btrfs_workqueue (+89/-0)
    btrfs: Cleanup the old btrfs_worker. (+3/-825)

David Sterba (10) commits (+115/-125):
    btrfs: send: simplify allocation code in fs_path_ensure_buf (+12/-18)
    btrfs: send: replace check with an assert in gen_unique_name (+1/-5)
    btrfs: send: fix old buffer length in fs_path_ensure_buf (+3/-3)
    btrfs: send: lower memory requirements in common case (+37/-69)
    btrfs: send: remove virtual_mem member from fs_path (+2/-6)
    btrfs: send: remove prepared member from fs_path (+13/-13)
    btrfs: send: remove BUG_ON from name_cache_delete (+9/-2)
    btrfs: send: remove BUG from process_all_refs (+4/-1)
    btrfs: send: squeeze bitfilelds in fs_path (+2/-2)
    btrfs: add simple debugfs interface (+32/-6)

Wang Shilong (9) commits (+87/-56):
    Btrfs: fix a possible deadlock between scrub and transaction committing (+11/-11)
    Btrfs: only add roots if necessary in find_parent_nodes() (+3/-11)
    Btrfs: skip readonly root for snapshot-aware defragment (+5/-0)
    Btrfs: wake up @scrub_pause_wait as much as we can (+10/-0)
    Btrfs: device_replace: fix deadlock for nocow case (+15/-2)
    Revert "Btrfs: remove transaction from btrfs send" (+33/-0)
    Btrfs: skip locking when searching commit root (+3/-1)
    Btrfs: switch to btrfs_previous_extent_item() (+6/-31)
    Btrfs: cancel scrub on transaction abortion (+1/-0)

Liu Bo (6) commits (+64/-45):
    Btrfs: share the same code for __record_{new,deleted}_ref (+17/-32)
    Btrfs: fix possible deadlock in btrfs_cleanup_transaction (+3/-1)
    Btrfs: fix a crash of clone with inline extents's split (+18/-7)
    Btrfs: avoid warning bomb of btrfs_invalidate_inodes (+2/-1)
    Btrfs: skip search tree for REG files (+15/-4)
    Btrfs: add readahead for send_write (+9/-0)

Filipe David Borba Manana (6) commits (+101/-77):
    Btrfs: use right extent item position in send when finding extent clones (+0/-2)
    Btrfs: more send support for parent/child dir relationship inversion (+2/-2)
    Btrfs: faster/more efficient insertion of file extent items (+30/-22)
    Btrfs: fix send dealing with file renames and directory moves (+1/-9)
    Btrfs: make some tree searches in send.c more efficient (+64/-41)
    Btrfs: add missing error check in incremental send (+4/-1)

Josef Bacik (4) commits (+28/-22):
    Btrfs: take into account total references when doing backref lookup (+18/-11)
    Btrfs: unlock extent and pages on error in cow_file_range (+2/-1)
    Btrfs: fix deadlock with nested trans handles (+4/-10)
    Btrfs: balance delayed inode updates (+4/-0)

Hidetoshi Seto (1) commits (+4/-0):
    Btrfs: skip submitting barrier for missing device

Guangyu Sun (1) commits (+3/-1):
    Btrfs: return EPERM when deleting a default subvolume

Justin Maggard (1) commits (+1/-0):
    btrfs: wake up transaction thread upon remount

Hugo Mills (1) commits (+111/-12):
    btrfs: Fix 32/64-bit problem with BTRFS_SET_RECEIVED_SUBVOL ioctl

Chris Mason (1) commits (+1/-1):
    btrfs: fix uninit variable warning

Sachin Kamat (1) commits (+2/-1):
    btrfs: Use PTR_ERR_OR_ZERO

Kusanagi Kouichi (1) commits (+1/-1):
    btrfs: Return EXDEV for cross file system snapshot

Stanislaw Gruszka (1) commits (+5/-4):
    btrfs: always choose work from prio_head first

Total: (108) commits (+2533/-2022)

 fs/btrfs/async-thread.c      | 848 ++++++++++++-------------------------------
 fs/btrfs/async-thread.h      | 121 ++----
 fs/btrfs/backref.c           |  84 ++---
 fs/btrfs/btrfs_inode.h       |  14 +-
 fs/btrfs/ctree.c             |  11 +-
 fs/btrfs/ctree.h             |  73 ++--
 fs/btrfs/delayed-inode.c     |   6 +-
 fs/btrfs/delayed-ref.c       |  29 +-
 fs/btrfs/dev-replace.c       |  79 +++-
 fs/btrfs/disk-io.c           | 281 +++++++-------
 fs/btrfs/extent-tree.c       |  58 ++-
 fs/btrfs/extent_io.c         |  15 +-
 fs/btrfs/extent_map.c        |  56 ++-
 fs/btrfs/extent_map.h        |  10 +-
 fs/btrfs/file.c              | 158 +++++---
 fs/btrfs/inode.c             | 121 +++---
 fs/btrfs/ioctl.c             | 210 +++++++++--
 fs/btrfs/ordered-data.c      |  68 +++-
 fs/btrfs/ordered-data.h      |   6 +-
 fs/btrfs/qgroup.c            |  15 +-
 fs/btrfs/raid56.c            |  21 +-
 fs/btrfs/reada.c             |   4 +-
 fs/btrfs/relocation.c        |   2 +-
 fs/btrfs/root-tree.c         |   3 +-
 fs/btrfs/scrub.c             |  97 +++--
 fs/btrfs/send.c              | 821 +++++++++++++++++++++++++++--------------
 fs/btrfs/super.c             |  37 +-
 fs/btrfs/sysfs.c             |  33 +-
 fs/btrfs/sysfs.h             |   5 +
 fs/btrfs/transaction.c       |  39 +-
 fs/btrfs/tree-log.c          | 236 ++++++++----
 fs/btrfs/tree-log.h          |  18 +-
 fs/btrfs/volumes.c           |  46 ++-
 fs/btrfs/volumes.h           |   1 +
 include/trace/events/btrfs.h | 137 +++++++
 35 files changed, 2137 insertions(+), 1626 deletions(-)
