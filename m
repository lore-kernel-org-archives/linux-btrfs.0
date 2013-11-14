Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59869 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3KNRT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 12:19:59 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C7BC17C0427
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 10:19:58 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20131114171952.3802.93244@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Thu, 14 Nov 2013 12:19:52 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is our usual merge window set of bug fixes, performance
improvements and cleanups.  Miao Xie has some really nice optimizations
for writeback.

Josef also expanded our sanity checks quite a bit; these make up a big
chunk of the new lines.

This was tested both on 3.12 and your current git

Josef Bacik (30) commits (+2038/-419):
    Btrfs: make sure the delalloc workers actually flush compressed writes (+12/-6)
    Btrfs: do not free the dirty bytes from the trans block rsv on cleanup (+0/-2)
    Btrfs: add a sanity test for a vacant extent at the front of a file (+128/-5)
    Btrfs: take ordered root lock when removing ordered operations inode (+2/-0)
    Btrfs: stop committing the transaction so much during relocate (+13/-20)
    Btrfs: do not bug_on if we try to cow a free space cache inode (+4/-1)
    Btrfs: add an assert to btrfs_lookup_csums_range for alignment (+3/-0)
    Btrfs: cleanup reserved space when freeing tree log on error (+25/-22)
    Btrfs: fix two use-after-free bugs with transaction cleanup (+52/-82)
    Btrfs: don't delete ordered roots from list during cleanup (+2/-1)
    Btrfs: do a full search everytime in btrfs_search_old_slot (+6/-2)
    Btrfs: handle a missing extent for the first file extent (+9/-2)
    Btrfs: return an error from btrfs_wait_ordered_range (+78/-41)
    Btrfs: remove all BUG_ON()'s from commit_cowonly_roots (+8/-5)
    Btrfs: don't abort transaction in run_delalloc_nocow (+5/-15)
    Btrfs: do not release metadata for space cache inodes (+7/-1)
    Btrfs: relocate csums properly with prealloc extents (+15/-3)
    Btrfs: free reserved space on error in a few places (+21/-2)
    Btrfs: check file extent type before anything else (+5/-5)
    Btrfs: stop all workers after we free block groups (+2/-2)
    Btrfs: add tests for find_lock_delalloc_range (+389/-9)
    Btrfs: add a sanity test for btrfs_split_item (+283/-7)
    Btrfs: fix up seek_hole/seek_data handling (+19/-75)
    Btrfs: free up block groups after everything (+2/-2)
    Btrfs: reset intwrite on transaction abort (+2/-0)
    Btrfs: fix hole check in log_one_extent (+1/-1)
    Btrfs: add tests for btrfs_get_extent (+861/-2)
    Btrfs: stop using vfs_read in send (+72/-103)
    Btrfs: cleanup transaction on abort (+6/-1)
    Btrfs: fixup reserved trace points (+6/-2)

Filipe David Borba Manana (19) commits (+127/-104):
    Btrfs: fix sync fs to actually wait for all data to be persisted (+9/-3)
    Btrfs: fix csum search offset/length calculation in log tree (+7/-7)
    Btrfs: optimize extent item search in run_delayed_extent_op (+20/-7)
    Btrfs: remove path arg from btrfs_truncate_free_space_cache (+3/-15)
    Btrfs: remove unused max_key arg from btrfs_search_forward (+7/-30)
    Btrfs: don't leak delayed node on path allocation failure (+3/-1)
    Btrfs: remove unnecessary tree search when logging inode (+5/-5)
    Btrfs: log recovery, don't unlink inode always on error (+4/-1)
    Btrfs: fix btrfs_prev_leaf() previous key computation (+8/-4)
    Btrfs: remove unnecessary key copy when logging inode (+2/-3)
    Btrfs: fix memory leaks on transaction commit failure (+8/-4)
    Btrfs: remove duplicated ino cache's inode lookup (+5/-9)
    Btrfs: improve inode hash function/inode lookup (+25/-3)
    Btrfs: don't store NULL byte in symlink extents (+2/-2)
    Btrfs: optimize tree-log.c:count_inode_refs() (+5/-0)
    Btrfs: fix tracking of orphan inode count (+8/-5)
    Btrfs: don't leak block group on error (+1/-2)
    Btrfs: fix incorrect inode acl reset (+1/-1)
    Btrfs: fix verification of dir_item (+4/-2)

Miao Xie (10) commits (+121/-52):
    Btrfs: remove unnecessary initialization and memory barrior in shrink_delalloc() (+3/-4)
    Btrfs: pick up the code for the item number calculation in flush_space() (+16/-9)
    Btrfs: fix the free space write out failure when there is no data space (+12/-3)
    Btrfs: don't wait for all the async delalloc when shrinking delalloc (+12/-2)
    Btrfs: fix the confusion between delalloc bytes and metadata bytes (+6/-0)
    Btrfs: improve jitter performance of the sequential buffered write (+4/-3)
    Btrfs: don't wait for the completion of all the ordered extents (+31/-18)
    Btrfs: fix BUG_ON() casued by the reserved space migration (+28/-3)
    Btrfs: wait for the ordered extent only when we want (+2/-1)
    Btrfs: rename btrfs_start_all_delalloc_inodes (+7/-9)

Liu Bo (7) commits (+69/-32):
    Btrfs: fix a crash when running balance and defrag concurrently (+3/-0)
    Btrfs: do not run snapshot-aware defragment on error (+28/-19)
    Btrfs: export btrfs space shared info to userspace (+33/-1)
    Btrfs: fixup error path in __btrfs_inc_extent_ref (+2/-8)
    Btrfs: kill unused code in btrfs_search_forward (+0/-2)
    Btrfs: fix memory leak of chunks' extent map (+2/-0)
    Btrfs: cleanup dead code of defragment (+1/-2)

Stefan Behrens (6) commits (+25/-21):
    Btrfs: Wait for uuid-tree rebuild task on remount read-only (+6/-0)
    Btrfs: fix check_int 'leaf item out of bounce' regression (+1/-1)
    Btrfs: eliminate the exceptional root_tree refs=0 (+10/-15)
    Btrfs: Don't allocate inode that is already in use (+1/-1)
    Btrfs: check_int, remove warning for mixed-mode (+5/-4)
    Btrfs: init device stats for new devices (+2/-0)

Dulshani Gunawardhana (6) commits (+68/-111):
    btrfs: Enclose macros with complex values within parenthesis (+4/-4)
    btrfs: Use WARN_ON()'s return value in place of WARN_ON(1) (+28/-70)
    btrfs: Fix checkpatch.pl warning of spacing issues (+19/-19)
    btrfs: Remove redundant local zero structure (+2/-3)
    btrfs: Replace kmalloc with kmalloc_array (+5/-5)
    btrfs: Pack struct btrfs_device (+10/-10)

Ilya Dryomov (4) commits (+16/-7):
    Btrfs: nuke a bogus rw_devices decrement in __btrfs_close_devices (+2/-1)
    Btrfs: disallow 'btrfs {balance,replace} cancel' on ro mounts (+6/-0)
    Btrfs: don't leak ioctl args in btrfs_ioctl_dev_replace (+5/-4)
    Btrfs: fix the dev-replace suspend sequence (+3/-2)

Zach Brown (3) commits (+11/-56):
    btrfs: use get_seconds() instead of btrfs wrapper (+4/-12)
    btrfs: remove fs/btrfs/compat.h (+6/-26)
    btrfs: remove move_pages() (+1/-18)

Rashika (3) commits (+24/-49):
    btrfs: Replace multiple atomic_inc() with atomic_add() (+4/-4)
    btrfs: Remove useless variable in write_ctree_super() (+1/-4)
    btrfs: Add helper function for free_root_pointers() (+19/-41)

Wang Shilong (3) commits (+19/-34):
    Btrfs: use 'u64' rather than 'int' to get extent's generation (+1/-1)
    Btrfs: remove scrub_super_lock holding in btrfs_sync_log() (+8/-20)
    Btrfs: avoid unnecessary scrub workers allocation (+10/-13)

Ross Kirk (2) commits (+41/-42):
    btrfs: remove unused parameter from btrfs_header_fsid (+10/-10)
    btrfs: drop unused parameter from btrfs_item_nr (+31/-32)

Geyslan G. Bem (2) commits (+22/-22):
    btrfs: simplify kmalloc+copy_from_user to memdup_user (+3/-8)
    btrfs: Fix memory leakage in the tree-log.c (+19/-14)

Jeff Mahoney (1) commits (+7/-0):
    btrfs: add tracing for failed reservations

Chandra Seetharaman (1) commits (+28/-40):
    Btrfs: Simplify the logic in alloc_extent_buffer() for existing extent buffer case

chandan (1) commits (+1/-1):
    Btrfs: btrfs_add_ordered_operation: Fix last modified transaction comparison.

Total: (98) commits (+2601 /-974)

 fs/btrfs/Makefile                    |   4 +-
 fs/btrfs/acl.c                       |   2 +-
 fs/btrfs/async-thread.c              |   2 +-
 fs/btrfs/backref.c                   |   8 +-
 fs/btrfs/btrfs_inode.h               |  20 +
 fs/btrfs/check-integrity.c           |  18 +-
 fs/btrfs/compat.h                    |   7 -
 fs/btrfs/compression.c               |   3 +-
 fs/btrfs/ctree.c                     |  75 +--
 fs/btrfs/ctree.h                     |  36 +-
 fs/btrfs/delayed-inode.c             |  19 +-
 fs/btrfs/dev-replace.c               |  26 +-
 fs/btrfs/dir-item.c                  |   8 +-
 fs/btrfs/disk-io.c                   | 248 ++++-----
 fs/btrfs/disk-io.h                   |   4 +
 fs/btrfs/export.c                    |   1 -
 fs/btrfs/extent-tree.c               | 174 +++++--
 fs/btrfs/extent_io.c                 | 135 +++--
 fs/btrfs/extent_io.h                 |   8 +-
 fs/btrfs/extent_map.h                |   8 +-
 fs/btrfs/file-item.c                 |   7 +-
 fs/btrfs/file.c                      | 163 +++---
 fs/btrfs/free-space-cache.c          |  21 +-
 fs/btrfs/free-space-cache.h          |   4 +-
 fs/btrfs/inode-item.c                |   2 +-
 fs/btrfs/inode-map.c                 |  13 +-
 fs/btrfs/inode.c                     | 207 ++++----
 fs/btrfs/ioctl.c                     |  74 ++-
 fs/btrfs/ordered-data.c              |  52 +-
 fs/btrfs/ordered-data.h              |   6 +-
 fs/btrfs/print-tree.c                |   2 +-
 fs/btrfs/raid56.c                    |   1 -
 fs/btrfs/relocation.c                |  94 ++--
 fs/btrfs/scrub.c                     |  46 +-
 fs/btrfs/send.c                      | 193 +++----
 fs/btrfs/super.c                     |  31 +-
 fs/btrfs/tests/btrfs-tests.c         |  74 +++
 fs/btrfs/tests/btrfs-tests.h         |  25 +
 fs/btrfs/tests/extent-buffer-tests.c | 229 +++++++++
 fs/btrfs/tests/extent-io-tests.c     | 276 ++++++++++
 fs/btrfs/tests/inode-tests.c         | 955 +++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c               |  81 ++-
 fs/btrfs/transaction.h               |   2 +
 fs/btrfs/tree-defrag.c               |   5 +-
 fs/btrfs/tree-log.c                  | 148 +++---
 fs/btrfs/uuid-tree.c                 |   6 +-
 fs/btrfs/volumes.c                   |  26 +-
 fs/btrfs/volumes.h                   |  24 +-
 include/uapi/linux/magic.h           |   2 +-
 49 files changed, 2601 insertions(+), 974 deletions(-)
