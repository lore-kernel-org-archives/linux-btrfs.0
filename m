Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:34271 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab2LQV20 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 16:28:26 -0500
Date: Mon, 17 Dec 2012 16:28:22 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kerrnel.org>,
        Btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20121217212822.GB15235@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

My for-linus branch has a big set of fixes and features:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This was against 3.7, and it has two easy conflicts against Linus'
current head.  My -next branch has the resolutions, but Linus wills
surely fix these himself.

In terms of line count, most of the code comes from Stefan, who added
the ability to replace a single drive in place.  This is different from
how btrfs normally replaces drives, and is much much much faster.

Josef is plowing through our synchronous write performance.  This pull
request does not include the DIO_OWN_WAITING patch that was discussed on
the list, but it has a number of other improvements to cut down our
latencies and CPU time during fsync/O_DIRECT writes.

Miao Xie has a big series of fixes and is spreading out ordered
operations over more CPUs.  This improves performance and reduces
contention.

I've put in fixes for error handling around hash collisions.  These are
going back to individual stable kernels as I test against them.

Otherwise we have a lot of fixes and cleanups, thanks everyone!  raid5/6
is being rebased against the device replacement code.  I'll have it
posted this Friday along with a nice series of benchmarks.

Stefan Behrens (33) commits (+3446/-831):
    Btrfs: change core code of btrfs to support the device replace operations (+111/-14)
    Btrfs: allow repair code to include target disk when searching mirrors (+154/-5)
    Btrfs: changes to live filesystem are also written to replacement disk (+49/-1)
    Btrfs: introduce GET_READ_MIRRORS functionality for btrfs_map_block() (+11/-7)
    Btrfs: remove the block device pointer from the scrub context struct (+73/-60)
    Btrfs: disallow some operations on the device replace target device (+54/-18)
    Btrfs: disallow mutually exclusive admin operations from user mode (+40/-17)
    Btrfs: Pass fs_info to btrfs_num_copies() instead of mapping_tree (+15/-15)
    Btrfs: fix BUG() in scrub when first superblock reading gives EIO (+11/-0)
    Btrfs: pass fs_info to btrfs_map_block() instead of mapping_tree (+32/-37)
    Btrfs: Don't trust the superblock label and simply printk("%s") it (+5/-2)
    Btrfs: don't allow degraded mount if too many devices are missing (+16/-0)
    Btrfs: optionally avoid reads from device replace source drive (+35/-11)
    Btrfs: fix race in check-integrity caused by usage of bitfield (+1/-1)
    Btrfs: in scrub repair code, optimize the reading of mirrors (+12/-23)
    Btrfs: add code to scrub to copy read data to another disk (+851/-73)
    Btrfs: in scrub repair code, simplify alloc error handling (+26/-35)
    Btrfs: enhance btrfs structures for device replace support (+44/-0)
    Btrfs: make the scrub page array dynamically allocated (+121/-74)
    Btrfs: increase BTRFS_MAX_MIRRORS by one for dev replace (+1/-1)
    Btrfs: handle errors from btrfs_map_bio() everywhere (+65/-33)
    Btrfs: avoid risk of a deadlock in btrfs_handle_error (+10/-1)
    Btrfs: fix a scrub regression in case of write errors (+2/-1)
    Btrfs: add new sources for device replace code (+1069/-1)
    Btrfs: move some common code into a subfunction (+50/-43)
    Btrfs: introduce a btrfs_dev_replace_item type (+69/-0)
    Btrfs: add btrfs_scratch_superblock() function (+19/-0)
    Btrfs: cleanup scrub bio and worker wait code (+71/-35)
    Btrfs: fix a build warning for an unused label (+0/-1)
    Btrfs: add support for device replace ioctls (+52/-3)
    Btrfs: rename the scrub context structure (+253/-253)
    Btrfs: add two more find_device() methods (+64/-0)
    Btrfs: pass fs_info instead of root (+60/-66)

Miao Xie (32) commits (+840/-471):
    Btrfs: fix missing reserved space release in error path of delalloc reservation (+7/-0)
    Btrfs: fix off-by-one error of the same page check in btrfs_punch_hole() (+2/-2)
    Btrfs: fix unprotected extent map operation when logging file extents (+2/-0)
    Btrfs: fix unnecessary while loop when search the free space, cache (+10/-20)
    Btrfs: fix off-by-one error of the reserved size of btrfs_allocate() (+2/-2)
    Btrfs: fix joining the same transaction handler more than 2 times (+48/-30)
    Btrfs: fix missing log when BTRFS_INODE_NEEDS_FULL_SYNC is set (+4/-1)
    Btrfs: pass root object into btrfs_ioctl_{start, wait}_sync() (+6/-6)
    Btrfs: get write access when setting the default subvolume (+28/-12)
    Btrfs: make ordered operations be handled by multi-task (+45/-21)
    Btrfs: fix wrong return value of btrfs_wait_for_commit() (+8/-7)
    Btrfs: don't start a new transaction when starting sync (+18/-9)
    Btrfs: fix missing flush when committing a transaction (+47/-35)
    Btrfs: fix wrong return value of btrfs_truncate_page() (+1/-2)
    Btrfs: make delalloc inodes be flushed by multi-task (+103/-8)
    Btrfs: use existing align macros in btrfs_allocate() (+4/-4)
    Btrfs: make ordered extent be flushed by multi-task (+37/-9)
    Btrfs: don't auto defrag a file when doing directIO (+0/-3)
    Btrfs: fix unprotected defragable inode insertion (+55/-15)
    Btrfs: restructure btrfs_run_defrag_inodes() (+109/-91)
    Btrfs: get write access for qgroup operations (+48/-25)
    Btrfs: get write access when removing a device (+8/-4)
    Btrfs: cleanup duplicated division functions (+46/-40)
    Btrfs: punch hole past the end of the file (+12/-10)
    Btrfs: use slabs for auto defrag allocation (+34/-5)
    Btrfs: get write access when doing resize fs (+8/-2)
    Btrfs: fix wrong comment in can_overcommit() (+3/-3)
    Btrfs: improve the noflush reservation (+97/-86)
    Btrfs: fix the page that is beyond EOF (+9/-7)
    Btrfs: fix wrong file extent length (+23/-9)
    Btrfs: get write access for scrub (+13/-3)
    Btrfs: fix freeze vs auto defrag (+3/-0)

Josef Bacik (18) commits (+805/-361):
    Btrfs: don't take inode delalloc mutex if we're a free space inode (+19/-6)
    Btrfs: only clear dirty on the buffer if it is marked as dirty (+4/-4)
    Btrfs: recheck bio against block device when we map the bio (+131/-28)
    Btrfs: do not mark ems as prealloc if we are writing to them (+5/-4)
    Btrfs: don't bother copying if we're only logging the inode (+34/-6)
    Btrfs: log changed inodes based on the extent map tree (+372/-210)
    Btrfs: only log the inode item if we can get away with it (+11/-2)
    Btrfs: keep track of the extents original block length (+24/-4)
    Btrfs: fill the global reserve when unpinning space (+24/-5)
    Btrfs: do not call file_update_time in aio_write (+48/-29)
    Btrfs: use tokens where we can in the tree log (+73/-54)
    Btrfs: move checks in set_page_dirty under DEBUG (+2/-0)
    Btrfs: only unlock and relock if we have to (+4/-1)
    Btrfs: fix autodefrag and umount lockup (+17/-2)
    Btrfs: inline csums if we're fsyncing (+21/-1)
    Btrfs: add path->really_keep_locks (+6/-2)
    Btrfs: optimize leaf_space_used (+9/-2)
    Btrfs: don't memset new tokens (+1/-1)

Liu Bo (17) commits (+124/-151):
    Btrfs: MOD_LOG_KEY_REMOVE_WHILE_MOVING never change node's nritems (+2/-2)
    Btrfs: fix a double free on pending snapshots in error handling (+5/-1)
    Btrfs: reorder tree mod log operations in deleting a pointer (+6/-4)
    Btrfs: fix a deadlock in aborting transaction due to ENOSPC (+7/-0)
    Btrfs: skip adding an acl attribute if we don't have to (+2/-0)
    Btrfs: get right arguments for btrfs_wait_ordered_range (+1/-1)
    Btrfs: parse parent 0 into correct value in tracepoint (+2/-1)
    Btrfs: do not log extents when we only log new names (+2/-1)
    Btrfs: put raid properties into global table (+29/-33)
    Btrfs: cleanup for btrfs_btree_balance_dirty (+34/-81)
    Btrfs: kill unnecessary arguments in del_ptr (+7/-9)
    Btrfs: don't add a NULL extended attribute (+10/-0)
    Btrfs: protect devices list with its mutex (+5/-4)
    Btrfs: cleanup for btrfs_wait_order_range (+0/-3)
    Btrfs: fix an while-loop of listxattr (+1/-1)
    Btrfs: fix a bug of per-file nocow (+5/-3)
    Btrfs: cleanup unused arguments (+6/-7)

Filipe Brandenburger (3) commits (+21/-12):
    Btrfs: refactor error handling to drop inode in btrfs_create() (+11/-12)
    Btrfs: fix permissions of empty files not affected by umask (+4/-0)
    Btrfs: fix permissions of empty files not affected by umask (+6/-0)

Julia Lawall (2) commits (+26/-48):
    fs/btrfs: drop if around WARN_ON (+5/-10)
    fs/btrfs: use WARN (+21/-38)

Wang Sheng-Hui (2) commits (+9/-12):
    Btrfs: use ctl->unit for free space calculation instead of block_group->sectorsize (+9/-11)
    Btrfs: do not warn_on io_ctl->cur in io_ctl_map_page (+0/-1)

Tsutomu Itoh (2) commits (+11/-0):
    Btrfs: set hole punching time properly (+3/-0)
    Btrfs: add fiemap's flag check (+8/-0)

Lukas Czerner (1) commits (+16/-0):
    btrfs: Notify udev when removing device

Anand Jain (1) commits (+16/-16):
    Btrfs: rename root_times_lock to root_item_lock

Alexander Block (1) commits (+11/-2):
    Btrfs: merge inode_list in __merge_refs

Chris Mason (1) commits (+95/-2):
    Btrfs: fix hash overflow handling

Masanari Iida (1) commits (+2/-2):
    Btrfs: Fix typo in fs/btrfs

jeff.liu (1) commits (+1/-4):
    Btrfs: Remove the invalid shrink size check up from btrfs_shrink_dev()

Total: (115) commits (+5423/-1912)

 fs/btrfs/Makefile            |    2 +-
 fs/btrfs/acl.c               |    2 +
 fs/btrfs/backref.c           |   16 +-
 fs/btrfs/btrfs_inode.h       |    4 +
 fs/btrfs/check-integrity.c   |   31 +-
 fs/btrfs/compression.c       |    6 +-
 fs/btrfs/ctree.c             |  241 ++++--
 fs/btrfs/ctree.h             |  184 ++++-
 fs/btrfs/delayed-inode.c     |   11 +-
 fs/btrfs/dev-replace.c       |  856 ++++++++++++++++++++
 fs/btrfs/dev-replace.h       |   44 +
 fs/btrfs/dir-item.c          |   59 ++
 fs/btrfs/disk-io.c           |  142 ++--
 fs/btrfs/disk-io.h           |    4 +-
 fs/btrfs/extent-tree.c       |  227 +++---
 fs/btrfs/extent_io.c         |   37 +-
 fs/btrfs/extent_io.h         |    4 +-
 fs/btrfs/extent_map.c        |   24 +-
 fs/btrfs/extent_map.h        |    2 +
 fs/btrfs/file-item.c         |   21 +-
 fs/btrfs/file.c              |  406 ++++++----
 fs/btrfs/free-space-cache.c  |   51 +-
 fs/btrfs/inode-map.c         |    5 +-
 fs/btrfs/inode.c             |  484 ++++++-----
 fs/btrfs/ioctl.c             |  317 ++++++--
 fs/btrfs/ioctl.h             |   48 +-
 fs/btrfs/math.h              |   44 +
 fs/btrfs/ordered-data.c      |   90 ++-
 fs/btrfs/ordered-data.h      |    7 +-
 fs/btrfs/print-tree.c        |    3 +
 fs/btrfs/reada.c             |   31 +-
 fs/btrfs/relocation.c        |   40 +-
 fs/btrfs/root-tree.c         |    4 +-
 fs/btrfs/scrub.c             | 1836 ++++++++++++++++++++++++++++++------------
 fs/btrfs/send.c              |    8 +-
 fs/btrfs/super.c             |   48 +-
 fs/btrfs/transaction.c       |  170 ++--
 fs/btrfs/transaction.h       |    2 +-
 fs/btrfs/tree-log.c          |  477 ++++++-----
 fs/btrfs/volumes.c           |  966 +++++++++++++++++-----
 fs/btrfs/volumes.h           |   35 +-
 fs/btrfs/xattr.c             |   13 +-
 include/trace/events/btrfs.h |    3 +-
 43 files changed, 5258 insertions(+), 1747 deletions(-)
