Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11950 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbbF2VMG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 17:12:06 -0400
Date: Mon, 29 Jun 2015 17:11:50 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150629211150.GC23627@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus-4.2 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.2

Outside of our usual batch of fixes, this integrates the subvolume quota
updates that Qu Wenruo from Fujitsu has been working on for a few
releases now.  He gets an extra gold star for making btrfs smaller this
time, and fixing a number of quota corners in the process.

Dave Sterba tested and integrated Anand Jain's sysfs improvements.
Outside of exporting a symbol (ack'd by Greg) these are all internal to
btrfs and it's mostly cleanups and fixes.  Anand also attached some of
our sysfs objects to our internal device management structs instead of
an object off the super block.  It will make device management easier
overall and it's a better fit for how the sysfs files are used.  None of
the existing sysfs files are moved around.

Thanks for all the fixes everyone:

Anand Jain (28) commits (+304/-115):
    Btrfs: sysfs: move super_kobj and device_dir_kobj from fs_info to btrfs_fs_devices (+56/-43)
    Btrfs: sysfs: fix, btrfs_release_super_kobj() should to clean up the kobject data (+2/-0)
    Btrfs: sysfs: introduce function btrfs_sysfs_add_fsid() to create sysfs fsid (+14/-1)
    Btrfs: sysfs: fix, fs_info kobject_unregister has init_completion() twice (+0/-1)
    Btrfs: sysfs btrfs_kobj_rm_device() pass fs_devices instead of fs_info (+10/-10)
    Btrfs: sysfs: rename __btrfs_sysfs_remove_one to btrfs_sysfs_remove_fsid (+4/-4)
    Btrfs: sysfs: fix, kobject pointer clean up needed after kobject release (+1/-0)
    Btrfs: sysfs btrfs_kobj_add_device() pass fs_devices instead of fs_info (+6/-7)
    Btrfs: sysfs: don't fail seeding for the sake of sysfs kobject issue (+1/-1)
    Btrfc: sysfs: fix, check if device_dir_kobj is init before destroy (+6/-4)
    Btrfs: sysfs: provide framework to remove all fsid sysfs kobject (+16/-1)
    Btrfs: sysfs: separate device kobject and its attribute creation (+15/-6)
    Btrfs: sysfs: add support to show replacing target in the sysfs (+7/-1)
    Btrfs: check error before reporting missing device and add uuid (+2/-1)
    Btrfs: sysfs: add pointer to access fs_info from fs_devices (+25/-0)
    Btrfs: sysfs: btrfs_sysfs_remove_fsid() make it non static (+2/-1)
    Btrfs: sysfs: let default_attrs be separate from the kset (+8/-4)
    Btrfs: sysfs: separate kobject and attribute creation (+19/-14)
    Btrfs: sysfs: make btrfs_sysfs_add_device() non static (+1/-0)
    Btrfs: sysfs: make btrfs_sysfs_add_fsid() non static (+3/-1)
    Btrfs: introduce btrfs_get_fs_uuids to get fs_uuids (+5/-0)
    Btrfs: Check if kobject is initialized before put (+5/-3)
    Btrfs: sysfs: add support to add parent for fsid (+2/-2)
    Btrfs: sysfs: reorder the kobject creations (+13/-10)
    Btrfs: sysfs: fix, undo sysfs device links (+17/-0)
    Btrfs: log when missing device is created (+2/-0)
    lib: export symbol kobject_move() (+1/-0)
    Btrfs: free the stale device (+61/-0)

Qu Wenruo (19) commits (+879/-1542):
    btrfs: extent-tree: Use ref_node to replace unneeded parameters in __inc_extent_ref() and __free_extent() (+21/-21)
    btrfs: qgroup: Make snapshot accounting work with new extent-oriented (+33/-20)
    btrfs: qgroup: Add the ability to skip given qgroup for old/new_roots. (+40/-0)
    btrfs: qgroup: Switch self test to extent-oriented qgroup mechanism. (+89/-27)
    btrfs: delayed-ref: Use list to replace the ref_root in ref_head. (+114/-123)
    btrfs: qgroup: Cleanup open-coded old/new_refcnt update and read. (+54/-41)
    btrfs: qgroup: Switch to new extent-oriented qgroup mechanism. (+28/-100)
    btrfs: qgroup: Record possible quota-related extent for qgroup. (+95/-7)
    btrfs: backref: Don't merge refs which are not for same block. (+3/-3)
    btrfs: qgroup: Cleanup the old ref_node-oriented mechanism. (+3/-972)
    btrfs: backref: Add special time_seq == (u64)-1 case for (+29/-6)
    btrfs: qgroup: Add function qgroup_update_counters(). (+120/-0)
    btrfs: qgroup: Add new function to record old_roots. (+29/-0)
    btrfs: delayed-ref: Cleanup the unneeded functions. (+0/-174)
    btrfs: qgroup: Add new qgroup calculation function (+118/-0)
    btrfs: qgroup: Add function qgroup_update_refcnt(). (+58/-0)
    btrfs: qgroup: Switch rescan to new mechanism. (+7/-36)
    btrfs: ulist: Add ulist_del() function. (+37/-11)
    btrfs: Fix superblock csum type check. (+1/-1)

Filipe Manana (14) commits (+340/-76):
    Btrfs: incremental send, check if orphanized dir inode needs delayed rename (+37/-19)
    Btrfs: fix necessary chunk tree space calculation when allocating a chunk (+7/-12)
    Btrfs: wake up extent state waiters on unlock through clear_extent_bits (+6/-1)
    Btrfs: incremental send, fix clone operations for compressed extents (+17/-1)
    Btrfs: incremental send, don't delay directory renames unnecessarily (+46/-2)
    Btrfs: fix chunk allocation regression leading to transaction abort (+19/-3)
    Btrfs: fix mutex unlock without prior lock on space cache truncation (+6/-8)
    Btrfs: avoid syncing log in the fast fsync path when not necessary (+23/-3)
    Btrfs: fix hang during inode eviction due to concurrent readahead (+21/-5)
    Btrfs: check pending chunks when shrinking fs to avoid corruption (+40/-9)
    Btrfs: don't attach unnecessary extents to transaction on fsync (+15/-1)
    Btrfs: fix block group ->space_info null pointer dereference (+23/-2)
    Btrfs: fix -ENOSPC when finishing block group creation (+50/-2)
    Btrfs: fix -ENOSPC on block group removal (+30/-8)

Omar Sandoval (7) commits (+257/-142):
    Btrfs: don't invalidate root dentry when subvolume deletion fails (+1/-3)
    Btrfs: fail on mismatched subvol and subvolid mount options (+25/-8)
    Btrfs: remove all subvol options before mounting top-level (+20/-36)
    Btrfs: lock superblock before remounting for rw subvol (+2/-0)
    Btrfs: clean up error handling in mount_subvol() (+33/-28)
    Btrfs: show subvol= and subvolid= in /proc/mounts (+5/-0)
    Btrfs: unify subvol= and subvolid= mounting (+171/-67)

David Sterba (5) commits (+36/-22):
    btrfs: add 'cold' compiler annotations to all error handling functions (+7/-0)
    btrfs: fix warnings after changes in btrfs_abort_transaction (+4/-4)
    btrfs: report exact callsite where transaction abort occurs (+9/-11)
    btrfs: make root id query unprivileged (+16/-4)
    btrfs: let tree defrag work in SSD mode (+0/-3)

Liu Bo (4) commits (+57/-46):
    Btrfs: fix up read_tree_block to return proper error (+54/-29)
    Btrfs: fix use-after-free in btrfs_replay_log (+2/-1)
    Btrfs: add missing free_extent_buffer (+1/-0)
    Btrfs: remove csum_bytes_left (+0/-16)

Zhao Lei (2) commits (+30/-3):
    btrfs: Fix lockdep warning of wr_ctx->wr_lock in scrub_free_wr_ctx() (+27/-3)
    btrfs: wait for delayed iputs on no space (+3/-0)

chandan (2) commits (+2/-2):
    Btrfs: btrfs_defrag_file: Fix calculation of max_to_defrag. (+1/-1)
    Btrfs: btrfs_defrag_file: Fix ra_index computation. (+1/-1)

Josef Bacik (2) commits (+23/-4):
    Btrfs: set UNWRITTEN for prealloc'ed extents in fiemap (+2/-0)
    Btrfs: use received_uuid of parent during send (+21/-4)

Sasha Levin (1) commits (+2/-2):
    btrfs: use after free when closing devices

Mark Fasheh (1) commits (+14/-6):
    btrfs: Handle unaligned length in extent_same

Christian Engelmayer (1) commits (+4/-4):
    btrfs: qgroup: Fix possible leak in btrfs_add_qgroup_relation()

Dan Carpenter (1) commits (+11/-9):
    btrfs: delayed-ref: double free in btrfs_add_delayed_tree_ref()

Total: (87) commits

 fs/btrfs/async-thread.c       |    1 +
 fs/btrfs/async-thread.h       |    2 +
 fs/btrfs/backref.c            |   59 ++-
 fs/btrfs/ctree.c              |   16 +-
 fs/btrfs/ctree.h              |   28 +-
 fs/btrfs/delayed-ref.c        |  372 +++++----------
 fs/btrfs/delayed-ref.h        |   29 +-
 fs/btrfs/dev-replace.c        |    7 +-
 fs/btrfs/disk-io.c            |   56 ++-
 fs/btrfs/extent-tree.c        |  308 ++++++------
 fs/btrfs/extent-tree.h        |    0
 fs/btrfs/extent_io.c          |    9 +-
 fs/btrfs/file.c               |    9 +-
 fs/btrfs/free-space-cache.c   |   14 +-
 fs/btrfs/inode.c              |   26 +-
 fs/btrfs/ioctl.c              |   50 +-
 fs/btrfs/ordered-data.c       |   37 +-
 fs/btrfs/ordered-data.h       |    6 +-
 fs/btrfs/qgroup.c             | 1052 +++++++++++------------------------------
 fs/btrfs/qgroup.h             |   61 +--
 fs/btrfs/relocation.c         |   19 +-
 fs/btrfs/scrub.c              |   26 +-
 fs/btrfs/send.c               |  147 +++++-
 fs/btrfs/super.c              |  397 ++++++++++------
 fs/btrfs/sysfs.c              |  148 ++++--
 fs/btrfs/sysfs.h              |    8 +-
 fs/btrfs/tests/qgroup-tests.c |  109 ++++-
 fs/btrfs/transaction.c        |   79 +++-
 fs/btrfs/transaction.h        |   24 +
 fs/btrfs/tree-defrag.c        |    3 -
 fs/btrfs/tree-log.c           |    6 -
 fs/btrfs/ulist.c              |   47 +-
 fs/btrfs/ulist.h              |    1 +
 fs/btrfs/volumes.c            |  186 +++++++-
 fs/btrfs/volumes.h            |    9 +
 fs/seq_file.c                 |    1 +
 include/trace/events/btrfs.h  |   55 ---
 lib/kobject.c                 |    1 +
 38 files changed, 1697 insertions(+), 1711 deletions(-)
