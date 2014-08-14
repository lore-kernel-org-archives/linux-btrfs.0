Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16353 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbaHNR73 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 13:59:29 -0400
Message-ID: <53ECF8FB.1070106@fb.com>
Date: Thu, 14 Aug 2014 13:59:23 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

These are fixes and cleanups, including a first stab at fixing some
deadlocks we've hit since v3.15 in the btrfs workqueues.  We have one
more fix cooking on that side not included here.

Mark Fasheh has fixed more problems with quotas during snapshot
deletion, it is working much better now.

Miao Xie (25) commits (+806/-361):
    Btrfs: cleanup similar code of the buffered data data check and dio read data check (+47/-55)
    Btrfs: cleanup the read failure record after write or when the inode is freeing (+41/-0)
    Btrfs: update the comment of total_bytes and disk_total_bytes of btrfs_devie (+2/-2)
    Btrfs: make the device lock and its protected data in the same cacheline (+12/-13)
    Btrfs: fix unzeroed members in fs_devices when creating a fs from seed fs (+3/-0)
    Btrfs: don't consider the missing device when allocating new chunks (+2/-14)
    Btrfs: Fix the problem that the replace destroys the seed filesystem (+6/-2)
    Btrfs: cleanup unused latest_devid and latest_trans in fs_devices (+11/-34)
    Btrfs: Fix the problem that the dirty flag of dev stats is cleared (+20/-6)
    Btrfs: Cleanup unused variant and argument of IO failure handlers (+10/-16)
    Btrfs: fix wrong generation check of super block on a seed device (+5/-1)
    Btrfs: load checksum data once when submitting a direct read io (+35/-34)
    Btrfs: fix missing error handler if submiting re-read bio fails (+5/-0)
    Btrfs: don't write any data into a readonly device when scrub (+11/-0)
    Btrfs: Set real mirror number for read operation on RAID0/5/6 (+5/-0)
    Btrfs: Fix wrong device size when we are resizing the device (+3/-2)
    Btrfs: modify clean_io_failure and make it suit direct io (+19/-21)
    Btrfs: implement repair function when direct read fails (+300/-39)
    Btrfs: modify repair_io_failure and make it suit direct io (+7/-4)
    Btrfs: split bio_readpage_error into several functions (+123/-64)
    Btrfs: fix put dio bio twice when we submit dio bio fail (+2/-3)
    Btrfs: fix writing data into the seed filesystem (+36/-16)
    Btrfs: fix wrong missing device counter decrease (+1/-1)
    Btrfs: do file data check by sub-bio's self (+87/-29)
    Btrfs: fix wrong fsid check of scrub (+13/-5)

Filipe Manana (13) commits (+147/-89):
    Btrfs: ensure tmpfile inode is always persisted with link count of 0 (+15/-0)
    Btrfs: fix csum tree corruption, duplicate and outdated checksums (+1/-1)
    Btrfs: avoid unnecessary switch of path locks to blocking mode (+1/-2)
    Btrfs: make btrfs_search_forward return with nodes unlocked (+7/-15)
    Btrfs: unlock nodes earlier when inserting items in a btree (+6/-6)
    Btrfs: send, lower mem requirements for processing xattrs (+34/-8)
    Btrfs: race free update of commit root for ro snapshots (+36/-33)
    Btrfs: set error return value in btrfs_get_blocks_direct (+3/-1)
    Btrfs: read lock extent buffer while walking backrefs (+3/-0)
    Btrfs: clone, don't create invalid hole extent map (+2/-1)
    Btrfs: don't monopolize a core when evicting inode (+6/-0)
    Btrfs: fix hole detection during file fsync (+13/-4)
    Btrfs: reduce size of struct extent_state (+20/-18)

Anand Jain (13) commits (+129/-32):
    btrfs: replace seed device followed by unmount causes kernel WARNING (+13/-0)
    btrfs: replace seed device followed by unmount causes kernel WARNING (+7/-1)
    btrfs: preparatory to make btrfs_rm_dev_replace_srcdev() seed aware (+9/-5)
    btrfs: update sprout seed pointer when seed fs is relinquished (+19/-0)
    Btrfs: device_list_add() should not update list when mounted (+27/-0)
    btrfs: sysfs label interface should check for read only FS (+3/-0)
    btrfs: check generation as replace duplicates devid+uuid (+21/-1)
    btrfs: code optimize: BTRFS_ATTR could handle the mode (+14/-11)
    btrfs: code optimize: BTRFS_ATTR_RW could set the mode (+5/-4)
    btrfs: fix rw_devices miss match after seed replace (+2/-0)
    btrfs: use BTRFS_ATTR instead of btrfs_no_store() (+3/-10)
    btrfs: device delete must be sysloged (+3/-0)
    btrfs: device add must be sysloged (+3/-0)

David Sterba (10) commits (+279/-317):
    btrfs: remove obsolete comment in btrfs_clean_one_deleted_snapshot (+1/-4)
    btrfs: clenaup: don't call btrfs_release_path before free_path (+0/-1)
    btrfs: adjust statfs calculations according to raid profiles (+45/-6)
    btrfs: use DIV_ROUND_UP instead of open-coded variants (+22/-32)
    btrfs: wake up transaction thread from SYNC_FS ioctl (+6/-0)
    btrfs: use nodesize everywhere, kill leafsize (+89/-141)
    btrfs: cleanup ino cache members of btrfs_root (+52/-52)
    btrfs: kill the key type accessor helpers (+60/-60)
    btrfs: clean away stripe_align helper (+1/-10)
    btrfs: make close_ctree return void (+3/-11)

Wang Shilong (9) commits (+84/-23):
    Btrfs: clear compress-force when remounting with compress option (+7/-0)
    Btrfs: fix wrong write range for filemap_fdatawrite_range() (+2/-1)
    Btrfs: print btrfs specific info for some fatal error cases (+7/-7)
    Btrfs: fall into nocompression codes quickly if possible (+1/-4)
    Btrfs: fix wrong skipping compression for an inode (+20/-5)
    Btrfs: make defragment work with nodatacow option (+42/-3)
    Btrfs: fix off-by-one in cow_file_range_inline() (+2/-2)
    Btrfs: fix wrong extent mapping for DirectIO (+2/-0)
    Btrfs: fix wrong max inline data size limit (+1/-1)

Liu Bo (4) commits (+19/-11):
    Btrfs: add work_struct information for workqueue tracepoint (+6/-3)
    Btrfs: fix compressed write corruption on enospc (+12/-0)
    Btrfs: cleanup for btrfs workqueue tracepoints (+0/-7)
    Btrfs: fix regression of btrfs device replace (+1/-1)

Qu Wenruo (4) commits (+148/-14):
    btrfs: cancel scrub/replace if the user space process receive SIGKILL. (+25/-4)
    btrfs: Return right extent when fiemap gives unaligned offset and len. (+2/-2)
    btrfs: Use right extent length when inserting overlap extent map. (+5/-6)
    btrfs: Add show_path function for btrfs_super_ops. (+116/-2)

Mark Fasheh (3) commits (+498/-5):
    btrfs: qgroup: account shared subtrees during snapshot delete (+429/-1)
    btrfs: correctly handle return from ulist_add (+9/-4)
    btrfs: add trace for qgroup accounting (+60/-0)

Fabian Frederick (2) commits (+3/-4):
    btrfs: use PTR_ERR_OR_ZERO (+1/-3)
    Btrfs: fix sparse warning (+2/-1)

Satoru Takeuchi (2) commits (+14/-5):
    btrfs: use IS_ALIGNED() for assertion in btrfs_lookup_csums_range() for simplicity (+2/-2)
    btrfs: label should not contain return char (+12/-3)

chandan (1) commits (+1/-2):
    Btrfs: fill_holes: Fix slot number passed to hole_mergeable() call.

HIMANGI SARAOGI (1) commits (+2/-2):
    Btrfs: use BUG_ON

Chris Mason (1) commits (+6/-267):
    btrfs: disable strict file flushes for renames and truncates

Sergey Senozhatsky (1) commits (+68/-70):
    btrfs compression: merge inflate and deflate z_streams

Josef Bacik (1) commits (+23/-25):
    Btrfs: __btrfs_mod_ref should always use no_quota

Takashi Iwai (1) commits (+20/-6):
    Btrfs: Fix memory corruption by ulist_add_merge() on 32bit arch

Andrey Utkin (1) commits (+1/-1):
    btrfs: Drop stray check of fixup_workers creation

Total: (92) commits (+2248/-1234)

 fs/btrfs/backref.c           |  26 +-
 fs/btrfs/btrfs_inode.h       |  22 +-
 fs/btrfs/check-integrity.c   |  16 +-
 fs/btrfs/compression.c       |  10 +-
 fs/btrfs/ctree.c             |  64 ++--
 fs/btrfs/ctree.h             |  42 +--
 fs/btrfs/delayed-inode.c     |   8 +-
 fs/btrfs/dev-replace.c       |  15 +
 fs/btrfs/dir-item.c          |  12 +-
 fs/btrfs/disk-io.c           | 178 +++++------
 fs/btrfs/disk-io.h           |   3 +-
 fs/btrfs/export.c            |   4 +-
 fs/btrfs/extent-tree.c       | 354 ++++++++++++++++++----
 fs/btrfs/extent_io.c         | 297 ++++++++++++-------
 fs/btrfs/extent_io.h         |  39 ++-
 fs/btrfs/file-item.c         |  32 +-
 fs/btrfs/file.c              |  58 +---
 fs/btrfs/free-space-cache.c  |  17 +-
 fs/btrfs/hash.c              |   4 +-
 fs/btrfs/inode-item.c        |  12 +-
 fs/btrfs/inode-map.c         |  68 ++---
 fs/btrfs/inode.c             | 684 +++++++++++++++++++++++++++++++++----------
 fs/btrfs/ioctl.c             |  80 ++---
 fs/btrfs/lzo.c               |   3 +-
 fs/btrfs/ordered-data.c      | 123 --------
 fs/btrfs/ordered-data.h      |   5 -
 fs/btrfs/orphan.c            |   4 +-
 fs/btrfs/print-tree.c        |   4 +-
 fs/btrfs/qgroup.c            | 179 ++++++++++-
 fs/btrfs/qgroup.h            |   1 +
 fs/btrfs/raid56.c            |   8 +-
 fs/btrfs/reada.c             |   2 +-
 fs/btrfs/relocation.c        |  22 +-
 fs/btrfs/scrub.c             |  87 ++++--
 fs/btrfs/send.c              |  45 ++-
 fs/btrfs/super.c             | 179 ++++++++++-
 fs/btrfs/sysfs.c             |  43 +--
 fs/btrfs/sysfs.h             |  16 +-
 fs/btrfs/transaction.c       |  40 +--
 fs/btrfs/transaction.h       |   1 -
 fs/btrfs/tree-log.c          |  28 +-
 fs/btrfs/ulist.h             |  15 +
 fs/btrfs/uuid-tree.c         |   1 -
 fs/btrfs/volumes.c           | 217 ++++++++++----
 fs/btrfs/volumes.h           |  56 ++--
 fs/btrfs/xattr.c             |   4 +-
 fs/btrfs/zlib.c              | 141 +++++----
 include/trace/events/btrfs.h |  73 ++++-
 48 files changed, 2178 insertions(+), 1164 deletions(-)
