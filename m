Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47851 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3EIT0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 15:26:12 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 13C697C065C
	for <linux-btrfs@vger.kernel.org>; Thu,  9 May 2013 13:26:11 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Message-ID: <20130509192608.4271.46101@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Thu, 9 May 2013 15:26:08 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

These are mostly fixes.  The biggest exceptions are Josef's skinny
extents and Jan Schmidt's code to rebuild our quota indexes if they get
out of sync (or you enable quotas on an existing filesystem).

The skinny extents are off by default because they are a new variation
on the extent allocation tree format.  btrfstune -x enables them, and
the new format makes the extent allocation tree about 30% smaller.

I rebased this a few days ago to rework Dave Sterba's crc checks on the
super block, but almost all of these go back to rc6, since I though 3.9 was
due any minute.

The biggest missing fix is the tracepoint bug that was hit late in 3.9.
I ran into problems with that in overnight testing and I'm still
tracking it down.  I'll definitely have that fixed for rc2.

Josef Bacik (28) commits (+1322/-630):
    Btrfs: add a incompatible format change for smaller metadata extent refs (+290/-67)
    Btrfs: don't call readahead hook until we have read the entire eb (+2/-3)
    Btrfs: don't force pages under writeback to finish when aborting (+2/-3)
    Btrfs: deal with free space cache errors while replaying log (+59/-32)
    Btrfs: don't wait on ordered extents if we have a trans open (+2/-1)
    Btrfs: only exclude supers in the range of our block group (+21/-3)
    Btrfs: remove almost all of the BUG()'s from tree-log.c (+98/-53)
    Btrfs: don't panic if we're trying to drop too many refs (+7/-1)
    Btrfs: check return value of commit when recovering log (+6/-5)
    Btrfs: fix extent logging with O_DIRECT into prealloc (+13/-9)
    Btrfs: compare relevant parts of delayed tree refs (+14/-10)
    Btrfs: fix error handling in make/read block group (+33/-8)
    Btrfs: don't try and free ebs twice in log replay (+0/-7)
    Btrfs: fix possible infinite loop in slow caching (+7/-2)
    Btrfs: deal with bad mappings in btrfs_map_block (+8/-2)
    Btrfs: fix infinite loop when we abort on mount (+6/-3)
    Btrfs: cleanup fs roots if we fail to mount (+31/-31)
    Btrfs: deal with errors in write_dev_supers (+11/-1)
    Btrfs: fix all callers of read_tree_block (+59/-13)
    Btrfs: don't BUG_ON() in btrfs_num_copies (+18/-2)
    Btrfs: add tree block level sanity check (+6/-0)
    Btrfs: use REQ_META for all metadata IO (+10/-8)
    Btrfs: add some free space cache tests (+540/-0)
    Btrfs: cleanup destroy_marked_extents (+11/-32)
    Btrfs: fix bad extent logging (+40/-324)
    Btrfs: log ram bytes properly (+22/-5)
    Btrfs: various abort cleanups (+5/-4)
    Btrfs: fix lockdep warning (+1/-1)

Wang Shilong (19) commits (+317/-119):
    Btrfs: creating the subvolume qgroup automatically when enabling quota (+57/-0)
    Btrfs: add all ioctl checks before user change for quota operations (+41/-5)
    Btrfs: remove unused variable in the iterate_extent_inodes() (+0/-2)
    Btrfs: add a rb_tree to improve performance of ulist search (+56/-8)
    Btrfs: cleanup to remove reduplicate code in transaction.c (+2/-12)
    Btrfs: fix missing check before creating a qgroup relation (+8/-0)
    Btrfs: introduce a mutex lock for btrfs quota operations (+61/-25)
    Btrfs: use tree_root to avoid edquot when disabling quota (+2/-2)
    Btrfs: fix missing check about ulist_add() in qgroup.c (+44/-18)
    Btrfs: fix missing check in the btrfs_qgroup_inherit() (+15/-0)
    Btrfs: remove some BUG_ONs() when walking backref tree (+7/-3)
    Btrfs: fix double free in the iterate_extent_inodes() (+0/-2)
    Btrfs: kill some BUG_ONs() in the find_parent_nodes() (+4/-2)
    Btrfs: remove some unnecessary spin_lock usages (+6/-21)
    Btrfs: do not continue if out of memory happens (+4/-2)
    Btrfs: fix a warning when updating qgroup limit (+5/-5)
    Btrfs: make __merge_refs() return type be void (+3/-8)
    Btrfs: fix confusing edquot happening case (+2/-2)
    Btrfs: fix a warning when disabling quota (+0/-2)

David Sterba (14) commits (+249/-175):
    btrfs: remove unused gfp mask parameter from release_extent_buffer callchain (+7/-16)
    btrfs: make subvol creation/deletion killable in the early stages (+6/-2)
    btrfs: use unsigned long type for extent state bits (+40/-37)
    btrfs: handle errors returned from get_tree_block_key (+8/-4)
    btrfs: cover more error codes in btrfs_decode_error (+6/-0)
    btrfs: fix misleading variable name for flags (+20/-19)
    btrfs: merge save_error_info helpers into one (+1/-6)
    btrfs: clean up transaction abort messages (+25/-28)
    btrfs: deprecate subvolrootid mount option (+4/-13)
    btrfs: read entire device info under lock (+1/-1)
    btrfs: make orphan cleanup less verbose (+2/-2)
    btrfs: clean snapshots one by one (+57/-29)
    btrfs: enhance superblock checks (+71/-17)
    btrfs: update kconfig title (+1/-1)

Liu Bo (8) commits (+113/-102):
    Btrfs: return error when we specify wrong start to defrag (+7/-4)
    Btrfs: cleanup unused arguments of btrfs_csum_data (+15/-21)
    Btrfs: return free space in cow error path (+9/-3)
    Btrfs: improve the loop of scrub_stripe (+57/-26)
    Btrfs: use helper to cleanup tree roots (+1/-14)
    Btrfs: share stop worker code (+23/-32)
    Btrfs: cleanup unused function (+0/-1)
    Btrfs: pass NULL instead of 0 (+1/-1)

Jan Schmidt (7) commits (+682/-212):
    Btrfs: separate sequence numbers for delayed ref tracking and tree mod log (+63/-19)
    Btrfs: fix accessing the root pointer in tree mod log functions (+20/-20)
    Btrfs: split btrfs_qgroup_account_ref into four functions (+148/-105)
    Btrfs: fix tree mod log regression on root split operations (+29/-26)
    Btrfs: automatic rescan after "quota enable" command (+11/-0)
    Btrfs: fix unlock after free on rewinded tree blocks (+11/-7)
    Btrfs: rescan for qgroups (+400/-35)

Tsutomu Itoh (6) commits (+59/-79):
    Btrfs: remove unused variable in __process_changed_new_xattr() (+0/-2)
    Btrfs: cleanup of function where btrfs_extend_item() is called (+2/-3)
    Btrfs: cleanup of function where fixup_low_keys() is called (+38/-51)
    Btrfs: remove unused argument of btrfs_extend_item() (+9/-11)
    Btrfs: remove unused argument of fixup_low_keys() (+8/-10)
    Btrfs: fix error handling in btrfs_ioctl_send() (+2/-2)

Stefan Behrens (4) commits (+51/-23):
    Btrfs: allow omitting stream header and end-cmd for btrfs send (+33/-11)
    Btrfs: clear received_uuid field for new writable snapshots (+8/-4)
    Btrfs: delete unused parameter to btrfs_read_root_item() (+6/-8)
    Btrfs: set UUID in root_item for created trees (+4/-0)

Eric Sandeen (4) commits (+383/-458):
    btrfs: document mount options in Documentation/fs/btrfs.txt (+173/-7)
    btrfs: ignore device open failures in __btrfs_open_devices (+3/-3)
    btrfs: make static code static & remove dead code (+135/-392)
    btrfs: move leak debug code to functions (+72/-56)

Miao Xie (4) commits (+155/-53):
    Btrfs: use a lock to protect incompat/compat flag of the super block (+26/-11)
    Btrfs: allocate new chunks if the space is not enough for global rsv (+11/-8)
    Btrfs: improve the performance of the csums lookup (+111/-31)
    Btrfs: fix unblocked autodefraggers when remount (+7/-3)

Zhi Yong Wu (2) commits (+2/-7):
    btrfs: Cleanup some redundant codes in btrfs_lookup_csums_range() (+2/-5)
    btrfs: Cleanup some redundant codes in btrfs_log_inode() (+0/-2)

Zach Brown (1) commits (+2/-0):
    btrfs: abort unlink trans in missed error case

Simon Kirby (1) commits (+133/-109):
    Btrfs: Include the device in most error printk()s

Nathaniel Yazdani (1) commits (+1/-1):
    btrfs: fix minor typo in comment

Chris Mason (1) commits (+5/-0):
    Btrfs: allow superblock mismatch from older mkfs

Vincent (1) commits (+3/-2):
    Btrfs: fix reada debug code compilation

Total: (101) commits

 Documentation/filesystems/btrfs.txt | 180 +++++++-
 fs/btrfs/Kconfig                    |  22 +-
 fs/btrfs/backref.c                  |  87 ++--
 fs/btrfs/backref.h                  |   3 -
 fs/btrfs/btrfs_inode.h              |   2 +-
 fs/btrfs/compression.c              |  14 +-
 fs/btrfs/compression.h              |   2 -
 fs/btrfs/ctree.c                    | 382 +++++++---------
 fs/btrfs/ctree.h                    | 145 ++++---
 fs/btrfs/delayed-inode.c            |  66 +--
 fs/btrfs/delayed-ref.c              |  30 +-
 fs/btrfs/dir-item.c                 |  11 +-
 fs/btrfs/disk-io.c                  | 409 ++++++++++--------
 fs/btrfs/disk-io.h                  |   5 +-
 fs/btrfs/extent-tree.c              | 549 +++++++++++++++--------
 fs/btrfs/extent_io.c                | 310 ++++++-------
 fs/btrfs/extent_io.h                |  44 +-
 fs/btrfs/extent_map.c               |  23 +-
 fs/btrfs/extent_map.h               |   3 +-
 fs/btrfs/file-item.c                | 102 ++---
 fs/btrfs/file.c                     |  37 +-
 fs/btrfs/free-space-cache.c         | 596 +++++++++++++++++++++++--
 fs/btrfs/free-space-cache.h         |   5 +
 fs/btrfs/inode-item.c               |  17 +-
 fs/btrfs/inode.c                    | 183 ++++----
 fs/btrfs/ioctl.c                    | 108 ++++-
 fs/btrfs/locking.c                  |   4 +-
 fs/btrfs/ordered-data.c             |  28 +-
 fs/btrfs/ordered-data.h             |   3 +-
 fs/btrfs/print-tree.c               |   9 +-
 fs/btrfs/print-tree.h               |   2 +-
 fs/btrfs/qgroup.c                   | 840 ++++++++++++++++++++++++++++--------
 fs/btrfs/raid56.c                   |  14 +-
 fs/btrfs/reada.c                    |   5 +-
 fs/btrfs/relocation.c               | 111 +++--
 fs/btrfs/root-tree.c                |   7 +-
 fs/btrfs/scrub.c                    | 130 +++---
 fs/btrfs/send.c                     |  32 +-
 fs/btrfs/send.h                     |   1 -
 fs/btrfs/super.c                    | 107 +++--
 fs/btrfs/transaction.c              |  95 ++--
 fs/btrfs/transaction.h              |   3 +-
 fs/btrfs/tree-log.c                 | 390 +++++++----------
 fs/btrfs/tree-log.h                 |   3 -
 fs/btrfs/ulist.c                    |  58 ++-
 fs/btrfs/ulist.h                    |   6 +
 fs/btrfs/volumes.c                  |  97 +++--
 fs/btrfs/volumes.h                  |  13 -
 fs/btrfs/xattr.c                    |   4 +-
 include/uapi/linux/btrfs.h          |  32 +-
 50 files changed, 3418 insertions(+), 1911 deletions(-)
