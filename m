Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3684 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750810AbaJKAl7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 20:41:59 -0400
Message-ID: <54387CD0.7050103@fb.com>
Date: Fri, 10 Oct 2014 20:41:52 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is based on 3.17-rc5 because that's when I forked off for -next,
but I've been testing it against linux-next or 3.17 for a while now.

The largest set of changes here come from Miao Xie.  He's cleaning up
and improving read recovery/repair for raid, and has a number of related
fixes.

I've merged another set of fsync fixes from Filipe, and he's also
improved the way we handle metadata write errors to make sure we force
the FS readonly if things go wrong.

Otherwise we have a collection of fixes and cleanups.  Dave Sterba gets
a cookie for removing the most lines (thanks Dave).

Miao Xie (36) commits (+1193/-537):
    Btrfs: cleanup similar code of the buffered data data check and dio read data check (+47/-55)
    Btrfs: cleanup double assignment of device->bytes_used when device replace finishes (+0/-1)
    Btrfs: cleanup the read failure record after write or when the inode is freeing (+41/-0)
    Btrfs: stop mounting the fs if the non-ENOENT errors happen when opening seed fs (+1/-1)
    Btrfs: update the comment of total_bytes and disk_total_bytes of btrfs_devie (+2/-2)
    Btrfs: make the device lock and its protected data in the same cacheline (+12/-13)
    Btrfs: fix unprotected device list access when getting the fs information (+7/-1)
    Btrfs: fix use-after-free problem of the device during device replace (+8/-1)
    Btrfs: Fix wrong free_chunk_space assignment during removing a device (+0/-5)
    Btrfs: Cleanup unused variant and argument of IO failure handlers (+10/-16)
    Btrfs: cleanup unused latest_devid and latest_trans in fs_devices (+11/-34)
    Btrfs: Fix the problem that the dirty flag of dev stats is cleared (+20/-6)
    Btrfs: load checksum data once when submitting a direct read io (+35/-34)
    Btrfs: fix unprotected device list access when cloning fs devices (+3/-0)
    Btrfs: fix wrong generation check of super block on a seed device (+5/-1)
    Btrfs: fix missing error handler if submiting re-read bio fails (+5/-0)
    Btrfs: Set real mirror number for read operation on RAID0/5/6 (+5/-0)
    Btrfs: fix unprotected device's variants on 32bits machine (+124/-29)
    Btrfs: modify clean_io_failure and make it suit direct io (+19/-21)
    Btrfs: make the logic of source device removing more clear (+8/-14)
    Btrfs: update free_chunk_space during allocting a new chunk (+5/-5)
    Btrfs: implement repair function when direct read fails (+281/-29)
    Btrfs: modify repair_io_failure and make it suit direct io (+7/-4)
    Btrfs: modify rw_devices counter under chunk_mutex context (+2/-2)
    Btrfs: move the missing device to its own fs device list (+52/-26)
    Btrfs: split bio_readpage_error into several functions (+123/-64)
    Btrfs: fix unprotected assignment of the target device (+28/-28)
    Btrfs: fix wrong device bytes_used in the super block (+37/-1)
    Btrfs: fix wrong disk size when writing super blocks (+83/-5)
    Btrfs: cleanup unused num_can_discard in fs_devices (+2/-15)
    Btrfs: fix unprotected system chunk array insertion (+6/-1)
    Btrfs: fix writing data into the seed filesystem (+36/-16)
    Btrfs: fix unprotected device->bytes_used update (+3/-1)
    Btrfs: do file data check by sub-bio's self (+87/-29)
    Btrfs: fix wrong fsid check of scrub (+13/-5)
    Btrfs: Fix misuse of chunk mutex (+65/-72)

David Sterba (32) commits (+507/-584):
    btrfs: remove unused parameter blocksize from btrfs_find_tree_block (+9/-12)
    btrfs: remove unlikely from data-dependent branches and slow paths (+10/-10)
    btrfs: remove obsolete comment in btrfs_clean_one_deleted_snapshot (+1/-4)
    btrfs: drop constant param from btrfs_release_extent_buffer_page (+6/-9)
    btrfs: remove blocksize from btrfs_alloc_free_block and rename (+21/-27)
    btrfs: clenaup: don't call btrfs_release_path before free_path (+0/-1)
    btrfs: remove stale define after removing ordered operations (+0/-7)
    btrfs: hide typecast to definition of BTRFS_SEND_TRANS_STUB (+4/-5)
    btrfs: remove unused parameter from readahead_tree_block (+8/-16)
    btrfs: remove parameter blocksize from read_tree_block (+18/-37)
    btrfs: use DIV_ROUND_UP instead of open-coded variants (+22/-32)
    btrfs: remove unused members from struct scrub_warning (+2/-15)
    btrfs: remove unused variable from btrfs_parse_options (+1/-3)
    btrfs: inline code of reada_tree_block and remove it (+2/-10)
    btrfs: wake up transaction thread from SYNC_FS ioctl (+6/-0)
    btrfs: new define for the inline extent data start (+9/-10)
    btrfs: defrag, use unsigned type for extent thresh (+4/-4)
    btrfs: move checks for DUMMY_ROOT into a helper (+23/-21)
    btrfs: use nodesize everywhere, kill leafsize (+89/-141)
    btrfs: cleanup ino cache members of btrfs_root (+52/-52)
    btrfs: use enum for wq endio metadata type (+14/-18)
    btrfs: return void from readahead_tree_block (+4/-8)
    btrfs: kill the key type accessor helpers (+60/-60)
    btrfs: use slab for end_io_wq structures (+38/-10)
    btrfs: let merge_reloc_roots return void (+1/-2)
    btrfs: fix error labels in init_btrfs_fs (+2/-2)
    btrfs: kill extent_buffer_page helper (+26/-35)
    btrfs: remove unlikely from NULL checks (+6/-6)
    btrfs: remove unused extent state bits (+0/-4)
    btrfs: clean away stripe_align helper (+1/-10)
    btrfs: make close_ctree return void (+3/-11)
    btrfs: add more superblock checks (+65/-2)

Filipe Manana (15) commits (+1071/-183):
    Btrfs: add missing compression property remove in btrfs_ioctl_setflags (+3/-0)
    Btrfs: be aware of btree inode write errors to avoid fs corruption (+114/-12)
    Btrfs: add missing end_page_writeback on submit_extent_page failure (+1/-0)
    Btrfs: fix data corruption after fast fsync and writeback error (+166/-102)
    Btrfs: improve free space cache management and space allocation (+653/-1)
    Btrfs: fix fsync race leading to invalid data after log replay (+63/-15)
    Btrfs: send, don't delay dir move if there's a new parent inode (+1/-1)
    Btrfs: avoid unnecessary switch of path locks to blocking mode (+1/-2)
    Btrfs: make btrfs_search_forward return with nodes unlocked (+7/-15)
    Btrfs: unlock nodes earlier when inserting items in a btree (+6/-6)
    Btrfs: send, lower mem requirements for processing xattrs (+32/-8)
    Btrfs: set error return value in btrfs_get_blocks_direct (+3/-1)
    Btrfs: shrink further sizeof(struct extent_buffer) (+0/-2)
    Btrfs: fix directory recovery from fsync log (+1/-0)
    Btrfs: reduce size of struct extent_state (+20/-18)

Anand Jain (14) commits (+80/-38):
    btrfs: rw_devices shouldn't be incremented for seed fs in btrfs_rm_dev_replace_srcdev() (+2/-1)
    btrfs: replace seed device followed by unmount causes kernel WARNING (+7/-1)
    btrfs: preparatory to make btrfs_rm_dev_replace_srcdev() seed aware (+9/-5)
    btrfs: update sprout seed pointer when seed fs is relinquished (+21/-0)
    btrfs: sysfs label interface should check for read only FS (+3/-0)
    btrfs: fix memory leak when there is no more seed device (+2/-0)
    btrfs: code optimize: BTRFS_ATTR could handle the mode (+14/-11)
    btrfs: code optimize: BTRFS_ATTR_RW could set the mode (+5/-4)
    btrfs: fix rw_devices miss match after seed replace (+2/-0)
    btrfs: use BTRFS_ATTR instead of btrfs_no_store() (+3/-10)
    btrfs: rename total_bytes to avoid confusion (+5/-5)
    btrfs: device delete must be sysloged (+3/-0)
    btrfs: fix typo in the log message (+1/-1)
    btrfs: device add must be sysloged (+3/-0)

Liu Bo (8) commits (+48/-34):
    Btrfs: show real function name in btrfs workqueue tracepoint (+1/-1)
    Btrfs: add work_struct information for workqueue tracepoint (+6/-3)
    Btrfs: cleanup the same name in end_bio_extent_readpage (+4/-4)
    Btrfs: fix crash of btrfs_release_extent_buffer_page (+1/-0)
    Btrfs: fix wrong parse of extent map's tracepoint (+7/-6)
    Btrfs: cleanup for btrfs workqueue tracepoints (+0/-7)
    Btrfs: fix loop writing of async reclaim (+14/-3)
    Btrfs: fix up bounds checking in lseek (+15/-10)

Wang Shilong (7) commits (+80/-22):
    Btrfs: clear compress-force when remounting with compress option (+7/-0)
    Btrfs: print btrfs specific info for some fatal error cases (+7/-7)
    Btrfs: fall into nocompression codes quickly if possible (+1/-4)
    Btrfs: fix wrong skipping compression for an inode (+20/-5)
    Btrfs: make defragment work with nodatacow option (+42/-3)
    Btrfs: fix off-by-one in cow_file_range_inline() (+2/-2)
    Btrfs: fix wrong max inline data size limit (+1/-1)

Josef Bacik (6) commits (+414/-117):
    Btrfs: fix build_backref_tree issue with multiple shared blocks (+4/-1)
    Btrfs: make fiemap not blow when you have lots of snapshots (+116/-36)
    Btrfs: cleanup error handling in build_backref_tree (+59/-29)
    Btrfs: remove empty block groups automatically (+226/-49)
    Btrfs: don't do async reclaim during log replay (+7/-1)
    Btrfs: try not to ENOSPC on log replay (+2/-1)

Fabian Frederick (5) commits (+9/-12):
    Btrfs: remove redundant btrfs_verify_qgroup_counts declaration. (+0/-2)
    Btrfs: fix compilation errors under DEBUG (+2/-2)
    btrfs: fix shadow warning on cmp (+4/-4)
    btrfs: use PTR_ERR_OR_ZERO (+1/-3)
    Btrfs: fix sparse warning (+2/-1)

Qu Wenruo (5) commits (+159/-29):
    btrfs: Make btrfs handle security mount options internally to avoid losing security label. (+97/-5)
    btrfs: Fix and enhance merge_extent_mapping() to insert best fitted extent map (+57/-22)
    btrfs: Fix the wrong condition judgment about subset extent map (+1/-1)
    btrfs: Fix compile error when CONFIG_SECURITY is not set. (+2/-0)
    btrfs: Fix a deadlock in btrfs_dev_replace_finishing() (+2/-1)

Mark Fasheh (2) commits (+69/-2):
    btrfs: don't go readonly on existing qgroup items (+8/-2)
    btrfs: add trace for qgroup accounting (+61/-0)

Satoru Takeuchi (2) commits (+14/-5):
    btrfs: use IS_ALIGNED() for assertion in btrfs_lookup_csums_range() for simplicity (+2/-2)
    btrfs: label should not contain return char (+12/-3)

HIMANGI SARAOGI (1) commits (+2/-2):
    Btrfs: use BUG_ON

Sage Weil (1) commits (+9/-3):
    Btrfs: fix race in WAIT_SYNC ioctl

Filipe David Borba Manana (1) commits (+3/-2):
    Btrfs: set default max_inline to 8KiB instead of 8MiB

Li RongQing (1) commits (+0/-4):
    btrfs: remove the wrong comments

Chris Mason (1) commits (+2/-3):
    Btrfs: fix compiles when CONFIG_BTRFS_FS_RUN_SANITY_TESTS is off

Sergey Senozhatsky (1) commits (+68/-70):
    btrfs compression: merge inflate and deflate z_streams

Andrey Utkin (1) commits (+1/-1):
    btrfs: Drop stray check of fixup_workers creation

Total: (139) commits

 fs/btrfs/async-thread.c           |  11 +-
 fs/btrfs/async-thread.h           |   1 +
 fs/btrfs/backref.c                | 123 +++++--
 fs/btrfs/backref.h                |   3 +
 fs/btrfs/btrfs_inode.h            |  27 +-
 fs/btrfs/check-integrity.c        |  18 +-
 fs/btrfs/compression.c            |  21 +-
 fs/btrfs/ctree.c                  | 106 +++---
 fs/btrfs/ctree.h                  |  93 +++---
 fs/btrfs/delayed-inode.c          |   8 +-
 fs/btrfs/dev-replace.c            |  82 +++--
 fs/btrfs/dir-item.c               |  12 +-
 fs/btrfs/disk-io.c                | 284 +++++++++-------
 fs/btrfs/disk-io.h                |  16 +-
 fs/btrfs/export.c                 |   4 +-
 fs/btrfs/extent-tree.c            | 265 +++++++++++----
 fs/btrfs/extent_io.c              | 483 +++++++++++++++++----------
 fs/btrfs/extent_io.h              |  60 ++--
 fs/btrfs/file-item.c              |  30 +-
 fs/btrfs/file.c                   | 151 ++++++---
 fs/btrfs/free-space-cache.c       | 157 ++++++++-
 fs/btrfs/hash.c                   |   4 +-
 fs/btrfs/inode-item.c             |  12 +-
 fs/btrfs/inode-map.c              |  68 ++--
 fs/btrfs/inode.c                  | 648 ++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c                  |  60 ++--
 fs/btrfs/lzo.c                    |   3 +-
 fs/btrfs/orphan.c                 |   4 +-
 fs/btrfs/print-tree.c             |   3 +-
 fs/btrfs/qgroup.c                 |  30 +-
 fs/btrfs/raid56.c                 |   8 +-
 fs/btrfs/reada.c                  |   2 +-
 fs/btrfs/relocation.c             | 142 ++++----
 fs/btrfs/scrub.c                  |  67 ++--
 fs/btrfs/send.c                   |  47 ++-
 fs/btrfs/super.c                  | 137 +++++++-
 fs/btrfs/sysfs.c                  |  41 ++-
 fs/btrfs/sysfs.h                  |  16 +-
 fs/btrfs/tests/free-space-tests.c | 516 ++++++++++++++++++++++++++++-
 fs/btrfs/transaction.c            |  52 ++-
 fs/btrfs/transaction.h            |   2 +-
 fs/btrfs/tree-log.c               | 259 +++++++++------
 fs/btrfs/tree-log.h               |   2 +
 fs/btrfs/uuid-tree.c              |   1 -
 fs/btrfs/volumes.c                | 676 ++++++++++++++++++++++++--------------
 fs/btrfs/volumes.h                | 166 ++++++++--
 fs/btrfs/xattr.c                  |   4 +-
 fs/btrfs/zlib.c                   | 141 ++++----
 include/trace/events/btrfs.h      |  85 ++++-
 49 files changed, 3617 insertions(+), 1534 deletions(-)
