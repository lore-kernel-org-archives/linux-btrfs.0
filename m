Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:46567 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2JIVFr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 17:05:47 -0400
Date: Tue, 9 Oct 2012 17:05:43 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20121009210543.GC9275@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

This is a large pull, with the bulk of the updates coming from:

* Hole punching

* send/receive fixes

* fsync performance

* Disk format extension allowing more hardlinks inside a single directory
(btrfs-progs patch required to enable the compat bit for this one)

I'm cooking more unrelated RAID code, but I wanted to make sure this
original batch makes it in.  The largest updates here are relatively old
and have been in testing for some time.

They are all in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Josef Bacik (35) commits (+1353/-424):
    Btrfs: handle not finding the extent exactly when logging changed extents (+40/-6)
    Btrfs: fix possible corruption when fsyncing written prealloced extents (+12/-0)
    Btrfs: do not warn_on when we cannot alloc a page for an extent buffer (+1/-3)
    Btrfs: do not hold the file extent leaf locked when adding extent item (+1/-3)
    Btrfs: don't bother committing delayed inode updates when fsyncing (+65/-19)
    Btrfs: do not hold the write_lock on the extent tree while logging (+20/-5)
    Btrfs: create a pinned em when writing to a prealloc range in DIO (+55/-0)
    Btrfs: cache extent state when writing out dirty metadata pages (+63/-16)
    Btrfs: remove unused hint byte argument for btrfs_drop_extents (+14/-30)
    Btrfs: only warn if we hit an error when doing the tree logging (+1/-1)
    Btrfs: move the sb_end_intwrite until after the throttle logic (+2/-2)
    Btrfs: don't do anything in our ->freeze_fs and ->unfreeze_fs (+0/-6)
    Btrfs: do not needlessly restart the transaction for enospc (+20/-36)
    Btrfs: do not async metadata csumming in certain situations (+35/-2)
    Btrfs: be smarter about dropping things from the tree log (+13/-2)
    Btrfs: cleanup pages properly when ENOMEM in compression (+10/-3)
    Btrfs: fix race when getting the eb out of page->private (+19/-4)
    Btrfs: update last trans if we don't update the inode (+2/-0)
    Btrfs: fix race with freeze and free space inodes (+11/-2)
    Btrfs: remove bytes argument from do_chunk_alloc (+10/-15)
    Btrfs: wait on async pages when shrinking delalloc (+7/-0)
    Btrfs: run delayed refs first when out of space (+10/-10)
    Btrfs: btrfs_drop_extent_cache should never fail (+11/-6)
    Btrfs: don't commit instead of overcommitting (+6/-28)
    Btrfs: don't lookup csums for prealloc extents (+1/-2)
    Btrfs: remove unused write cache pages hook (+0/-47)
    Btrfs: do not allocate chunks as agressively (+3/-9)
    Btrfs: fix punch hole when no extent exists (+3/-1)
    Btrfs: fix race in sync and freeze again (+18/-10)
    Btrfs: delay block group item insertion (+79/-67)
    Btrfs: don't bug on enomem in readpage (+7/-4)
    Btrfs: fix our overcommit math (+42/-29)
    Btrfs: turbo charge fsync (+416/-42)
    Btrfs: add hole punching (+355/-13)
    Btrfs: fix page leakage (+1/-1)

Alexander Block (23) commits (+482/-419):
    Btrfs: don't treat top/root directory inode as deleted/reused (+20/-1)
    Btrfs: fix use of radix_tree for name_cache in send/receive (+37/-39)
    Btrfs: rename backref_ctx::found_in_send_root to found_itself (+4/-4)
    Btrfs: pass root instead of parent_root to iterate_inode_ref (+2/-2)
    Btrfs: add correct parent to check_dirs when dir got moved (+11/-0)
    Btrfs: add missing check for dir != tmp_dir to is_first_ref (+1/-1)
    Btrfs: fix check for changed extent in is_extent_unchanged (+2/-2)
    Btrfs: free nce and nce_head on error in name_cache_insert (+5/-1)
    Btrfs: don't break in the final loop of find_extent_clone (+0/-1)
    Btrfs: fix cur_ino < parent_ino case for send/receive (+146/-244)
    Btrfs: add/fix comments/documentation for send/receive (+134/-6)
    Btrfs: use normal return path for root == send_root case (+0/-6)
    Btrfs: fix memory leak for name_cache in send/receive (+1/-0)
    Btrfs: use kmalloc instead of stack for backref_ctx (+18/-11)
    Btrfs: remove unused use_list from send/receive code (+0/-2)
    Btrfs: remove unused tmp_path from iterate_dir_item (+0/-8)
    Btrfs: add rdev to get_inode_info in send/receive (+17/-13)
    Btrfs: use <= instead of < in is_extent_unchanged (+1/-1)
    Btrfs: update send_progress at correct places (+20/-6)
    Btrfs: ignore non-FS inodes for send/receive (+5/-0)
    Btrfs: code cleanups for send/receive (+35/-48)
    Btrfs: make aux field of ulist 64 bit (+21/-23)
    Btrfs: remove unused code with #if 0 (+2/-0)

Miao Xie (18) commits (+344/-236):
    Btrfs: fix unnecessary warning when the fragments make the space alloc fail (+1/-1)
    Btrfs: fix wrong size for the reservation when doing, file pre-allocation. (+2/-2)
    Btrfs: output more information when aborting a unused transaction handle (+7/-1)
    Btrfs: fix the missing error information in create_pending_snapshot() (+35/-22)
    Btrfs: fix full backref problem when inserting shared block reference (+4/-0)
    Btrfs: add a new "type" field into the block reservation structure (+39/-22)
    Btrfs: fix wrong size for the reservation of the, snapshot creation (+4/-4)
    Revert "Btrfs: do not do filemap_write_and_wait_range in fsync" (+11/-3)
    Btrfs: fix file extent discount problem in the, snapshot (+25/-44)
    Btrfs: fix orphan transaction on the freezed filesystem (+49/-23)
    Btrfs: add a type field for the transaction handle (+21/-42)
    Btrfs: fix error path in create_pending_snapshot() (+17/-23)
    Btrfs: use a slab for ordered extents allocation (+31/-3)
    Btrfs: fix wrong orphan count of the fs/file tree (+1/-1)
    Btrfs: fix corrupted metadata in the snapshot (+32/-18)
    Btrfs: fix the snapshot that should not exist (+53/-15)
    Btrfs: fix memory leak in start_transaction() (+3/-1)
    Btrfs: fix unprotected ->log_batch (+9/-11)

Liu Bo (13) commits (+150/-113):
    Btrfs: fix a bug in checking whether a inode is already in log (+10/-8)
    Btrfs: kill obsolete arguments in btrfs_wait_ordered_extents (+7/-18)
    Btrfs: fix a bug in parsing return value in logical resolve (+34/-20)
    Btrfs: use larger limit for translation of logical to inode (+5/-4)
    Btrfs: check if an inode has no checksum when logging it (+12/-11)
    Btrfs: update delayed ref's tracepoints to show sequence (+10/-4)
    Btrfs: use flag EXTENT_DEFRAG for snapshot-aware defrag (+28/-14)
    Btrfs: improve fsync by filtering extents that we want (+26/-3)
    Btrfs: cleanup for duplicated code in find_free_extent (+0/-4)
    Btrfs: cleanup extents after we finish logging inode (+6/-0)
    Btrfs: use helper for logical resolve (+3/-16)
    Btrfs: fix off-by-one in file clone (+9/-9)
    Btrfs: cleanup fs_info->hashers (+0/-2)

Tsutomu Itoh (6) commits (+19/-20):
    Btrfs: confirmation of value is added before trace_btrfs_get_extent() is called (+2/-1)
    Btrfs: remove unnecessary IS_ERR in bio_readpage_error() (+1/-1)
    Btrfs: cleanup of error processing in btree_get_extent() (+5/-9)
    Btrfs: fix error handling in delete_block_group_cache() (+2/-2)
    Btrfs: remove unnecessary code in btree_get_extent() (+1/-7)
    Btrfs: check return value of ulist_alloc() properly (+8/-0)

David Sterba (4) commits (+119/-62):
    btrfs: allow setting NOCOW for a zero sized file via ioctl (+27/-4)
    btrfs: move transaction aborts to the point of failure (+80/-47)
    btrfs: return EPERM upon rmdir on a subvolume (+3/-2)
    btrfs: polish names of kmem caches (+9/-9)

Sage Weil (3) commits (+18/-2):
    Btrfs: do not take cleanup_work_sem in btrfs_run_delayed_iputs() (+0/-2)
    Btrfs: pass lockdep rwsem metadata to async commit transaction (+16/-0)
    Btrfs: set journal_info in async trans commit worker (+2/-0)

Stefan Behrens (2) commits (+156/-21):
    Btrfs: make filesystem read-only when submitting barrier fails (+142/-19)
    Btrfs: detect corrupted filesystem after write I/O errors (+14/-2)

Robin Dong (2) commits (+12/-157):
    btrfs: remove unused function btrfs_insert_some_items() (+0/-143)
    btrfs: move inline function code to header file (+12/-14)

Mark Fasheh (2) commits (+848/-116):
    btrfs: extended inode ref iteration (+138/-37)
    btrfs: extended inode refs (+710/-79)

Wei Yongjun (2) commits (+3/-6):
    Btrfs: fix possible memory leak in scrub_setup_recheck_block() (+1/-0)
    Btrfs: using for_each_set_bit_from to simplify the code (+2/-6)

Chris Mason (2) commits (+38/-16):
    Btrfs: fix btrfs send for inline items and compression (+37/-15)
    btrfs: init ref_index to zero in add_inode_ref (+1/-1)

Jan Schmidt (2) commits (+129/-112):
    btrfs: improved readablity for add_inode_ref (+97/-81)
    Btrfs: fix gcc warnings for 32bit compiles (+32/-31)

Zach Brown (1) commits (+2/-1):
    btrfs: fix min csum item size warnings in 32bit

Daniel J Blueman (1) commits (+11/-11):
    btrfs: fix message printing

Anand Jain (1) commits (+7/-5):
    Btrfs: write_buf is now callable outside send.c

Kent Overstreet (1) commits (+2/-17):
    btrfs: Kill some bi_idx references

Andrei Popa (1) commits (+13/-1):
    Btrfs: make compress and nodatacow mount options mutually exclusive

liubo (1) commits (+0/-8):
    Btrfs: cleanup for unused ref cache stuff

Wang Sheng-Hui (1) commits (+0/-4):
    Btrfs: remove repeated eb->pages check in, disk-io.c/csum_dirty_buffer

Total: (121) commits

 fs/btrfs/backref.c           | 299 +++++++++++---
 fs/btrfs/backref.h           |  10 +-
 fs/btrfs/btrfs_inode.h       |  15 +-
 fs/btrfs/check-integrity.c   |  16 +-
 fs/btrfs/compression.c       |  13 +-
 fs/btrfs/ctree.c             | 148 +------
 fs/btrfs/ctree.h             | 109 +++++-
 fs/btrfs/delayed-inode.c     |   6 +-
 fs/btrfs/disk-io.c           | 230 ++++++-----
 fs/btrfs/disk-io.h           |   2 +
 fs/btrfs/extent-tree.c       | 376 +++++++++---------
 fs/btrfs/extent_io.c         | 128 ++++--
 fs/btrfs/extent_io.h         |  23 +-
 fs/btrfs/extent_map.c        |  55 ++-
 fs/btrfs/extent_map.h        |   8 +-
 fs/btrfs/file-item.c         |   5 +-
 fs/btrfs/file.c              | 447 +++++++++++++++++++--
 fs/btrfs/free-space-cache.c  |  10 +-
 fs/btrfs/hash.h              |  10 +
 fs/btrfs/inode-item.c        | 285 +++++++++++++-
 fs/btrfs/inode.c             | 386 ++++++++++++------
 fs/btrfs/ioctl.c             | 100 ++---
 fs/btrfs/ordered-data.c      |  97 ++---
 fs/btrfs/ordered-data.h      |  12 +-
 fs/btrfs/qgroup.c            |  40 +-
 fs/btrfs/relocation.c        |  11 +-
 fs/btrfs/root-tree.c         |  29 +-
 fs/btrfs/scrub.c             |  30 +-
 fs/btrfs/send.c              | 915 +++++++++++++++++++++++--------------------
 fs/btrfs/send.h              |   1 +
 fs/btrfs/super.c             |  74 ++--
 fs/btrfs/transaction.c       | 283 +++++++++----
 fs/btrfs/transaction.h       |  20 +-
 fs/btrfs/tree-log.c          | 889 +++++++++++++++++++++++++++++++++--------
 fs/btrfs/ulist.c             |   7 +-
 fs/btrfs/ulist.h             |   9 +-
 fs/btrfs/volumes.c           |  73 +++-
 fs/btrfs/zlib.c              |   8 +-
 include/trace/events/btrfs.h |  14 +-
 39 files changed, 3574 insertions(+), 1619 deletions(-)
