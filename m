From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [GIT PULL] Btrfs fixes and features
Date: Mon, 02 Apr 2012 19:45:27 +0800
Message-ID: <4F799157.3000805@cn.fujitsu.com>
References: <20120330175106.GB755@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120330175106.GB755@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/31/2012 01:51 AM, Chris Mason wrote:
> Hi everyone,
> 
> This pull request is pretty big, picking up patches that have been under
> development for some time.  I have it in two branches:
> 
> # against 3.3
> #
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> # merged with linus git as of this morning (conflict in fs/btrfs/scrub.c)
> #
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-merged
> 
> The conflict resolution was to pick my version of scrub.c and then go in
> and drop all the KM_ args from kmap/unmap_atomic.
> 
> We've merged in the error handling patches from SuSE.  These are already
> shipping in the sles kernel, and they give btrfs the ability to abort
> transactions and go readonly on errors.  It involves a lot of churn as
> they clarify BUG_ONs, and remove the ones we now properly deal with.
> 
> Josef reworked the way our metadata interacts with the page cache.
> page->private now points to the btrfs extent_buffer object, which makes
> everything faster.  He changed it so we write an whole extent buffer at
> a time instead of allowing individual pages to go down,, which will be
> important for the raid5/6 code (for the 3.5 merge window ;)
> 
> Josef also made us more aggressive about dropping pages for metadata
> blocks that were freed due to COW.  Overall, our metadata caching is
> much faster now.
> 
> We've integrated my patch for metadata bigger than the page size.  This
> allows metadata blocks up to 64KB in size.  In practice 16K and 32K seem
> to work best.  For workloads with lots of metadata, this cuts down the
> size of the extent allocation tree dramatically and fragments much less.
> 

We still suffer pains in using a sectorsize larger than PAGE_SIZE, so
we'd better add a checker for it, something like:

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20196f4..08e49d2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2104,6 +2104,14 @@ int open_ctree(struct super_block *sb,
                err = -EINVAL;
                goto fail_alloc;
        }
+       if (btrfs_super_sectorsize(disk_super) > PAGE_CACHE_SIZE) {
+               printk(KERN_ERR "BTRFS: couldn't mount because sectorsize(%d)"
+                      " was larger than PAGE_SIZE(%lu)\n",
+                      btrfs_super_sectorsize(disk_super),
+                      (unsigned long long)PAGE_CACHE_SIZE);
+               err = -EINVAL;
+               goto fail_alloc;
+       }

        features = btrfs_super_incompat_flags(disk_super);
        features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
-- 
1.6.5.2


thanks,
liubo

> Scrub was updated to support the larger block sizes, which ended up
> being a fairly large change (thanks Stefan Behrens).
> 
> We also have an assortment of fixes and updates, especially to the
> balancing code (Ilya Dryomov), the back ref walker (Jan Schmidt) and the
> defragging code (Liu Bo).
> 
> Jeff Mahoney (21) commits (+1982/-1051):
>     btrfs: clean_tree_block should panic on observed memory corruption and return void (+12/-7)
>     btrfs: avoid NULL deref in btrfs_reserve_extent with DEBUG_ENOSPC (+2/-1)
>     btrfs: Catch locking failures in {set,clear,convert}_extent_bit (+38/-20)
>     btrfs: return void in functions without error conditions (+293/-410)
>     btrfs: replace many BUG_ONs with proper error handling (+980/-385)
>     btrfs: Remove set bits return from clear_extent_bit (+5/-7)
>     btrfs: enhance transaction abort infrastructure (+300/-56)
>     btrfs: Factor out tree->ops->merge_bio_hook call (+17/-5)
>     btrfs: Fix kfree of member instead of structure (+3/-3)
>     btrfs: btrfs_drop_snapshot should return int (+12/-8)
>     btrfs: ->submit_bio_hook error push-up (+31/-15)
>     btrfs: find_and_setup_root error push-up (+6/-5)
>     btrfs: __add_reloc_root error push-up (+16/-6)
>     btrfs: btrfs_update_root error push-up (+7/-4)
>     btrfs: Panic on bad rbtree operations (+39/-9)
>     btrfs: Simplify btrfs_submit_bio_hook (+4/-3)
>     btrfs: drop gfp_t from lock_extent (+63/-76)
>     btrfs: add varargs to btrfs_error (+66/-9)
>     btrfs: Simplify btrfs_insert_root (+3/-6)
>     btrfs: split extent_state ops (+25/-15)
>     btrfs: Add btrfs_panic() (+60/-1)
> 
> Ilya Dryomov (11) commits (+177/-159):
>     Btrfs: validate target profiles only if we are going to use them (+11/-16)
>     Btrfs: stop silently switching single chunks to raid0 on balance (+2/-3)
>     Btrfs: add wrappers for working with alloc profiles (+30/-30)
>     Btrfs: move alloc_profile_is_valid() to volumes.c (+25/-30)
>     Btrfs: make profile_is_valid() check more strict (+17/-12)
>     Btrfs: fix infinite loop in btrfs_shrink_device() (+2/-3)
>     Btrfs: improve the logic in btrfs_can_relocate() (+18/-6)
>     Btrfs: allow dup for data chunks in mixed mode (+9/-4)
>     Btrfs: add __get_block_group_index() helper (+12/-5)
>     Btrfs: add get_restripe_target() helper (+50/-44)
>     Btrfs: fix memory leak in resolver code (+1/-6)
> 
> Mark Fasheh (10) commits (+60/-19):
>     btrfs: Don't BUG_ON kzalloc error in btrfs_lookup_csums_range() (+13/-2)
>     btrfs: Don't BUG_ON insert errors in btrfs_alloc_dev_extent() (+3/-1)
>     btrfs: Go readonly on bad extent refs in update_ref_for_cow() (+5/-1)
>     btrfs: Don't BUG_ON errors from btrfs_create_subvol_root() (+6/-2)
>     btrfs: Don't BUG_ON errors from update_ref_for_cow() (+4/-1)
>     btrfs: Don't BUG_ON errors in __finish_chunk_alloc() (+6/-4)
>     btrfs: Don't BUG_ON() errors in update_ref_for_cow() (+7/-4)
>     btrfs: Go readonly on tree errors in balance_level (+11/-2)
>     btrfs: Remove BUG_ON from __finish_chunk_alloc() (+3/-1)
>     btrfs: Remove BUG_ON from __btrfs_alloc_chunk() (+2/-1)
> 
> Liu Bo (8) commits (+133/-52):
>     Btrfs: do not bother to defrag an extent if it is a big real extent (+3/-6)
>     Btrfs: add a check to decide if we should defrag the range (+35/-1)
>     Btrfs: show useful info in space reservation tracepoint (+13/-25)
>     Btrfs: fix recursive defragment with autodefrag option (+5/-3)
>     Btrfs: fix race between direct io and autodefrag (+5/-1)
>     Btrfs: update to the right index of defragment (+3/-0)
>     Btrfs: fix deadlock during allocating chunks (+50/-0)
>     Btrfs: fix the mismatch of page->mapping (+19/-16)
> 
> Chris Mason (8) commits (+356/-247):
>     Btrfs: update the checks for mixed block groups with big metadata blocks (+17/-12)
>     Btrfs: don't use threaded IO completion helpers for metadata writes (+4/-4)
>     Btrfs: flush out and clean up any block device pages during mount (+4/-0)
>     Btrfs: allow metadata blocks larger than the page size (+190/-189)
>     Btrfs: add the ability to cache a pointer into the eb (+116/-30)
>     Btrfs: adjust the write_lock_level as we unlock (+17/-6)
>     Btrfs: don't use crc items bigger than 4KB (+3/-1)
>     Btrfs: loop waiting on writeback (+5/-5)
> 
> Josef Bacik (8) commits (+788/-497):
>     Btrfs: remove search_start and search_end from find_free_extent and callers (+9/-19)
>     Btrfs: deal with read errors on extent buffers differently (+66/-27)
>     Btrfs: only use the existing eb if it's count isn't 0 (+8/-2)
>     Btrfs: ensure an entire eb is written at once (+390/-209)
>     Btrfs: introduce mark_extent_buffer_accessed (+15/-2)
>     Btrfs: introduce free_extent_buffer_stale (+201/-60)
>     Btrfs: remove the ideal caching code (+8/-85)
>     Btrfs: set page->private to the eb (+91/-93)
> 
> Stefan Behrens (3) commits (+1045/-381):
>     Btrfs: introduce common define for max number of mirrors (+7/-5)
>     Btrfs: change scrub to support big blocks (+1013/-340)
>     Btrfs: minor cleanup in scrub (+25/-36)
> 
> Jan Schmidt (3) commits (+79/-57):
>     Btrfs: fix regression in scrub path resolving (+73/-55)
>     Btrfs: check return value of btrfs_cow_block() (+4/-2)
>     Btrfs: actually call btrfs_init_lockdep (+2/-0)
> 
> David Sterba (2) commits (+26/-5):
>     btrfs: disallow unequal data/metadata blocksize for mixed block groups (+8/-0)
>     Btrfs: enhance superblock sanity checks (+18/-5)
> 
> Jan Kara (1) commits (+7/-2):
>     btrfs: Fix busyloop in transaction_kthread()
> 
> Total: (75) commits
> 
>  fs/btrfs/async-thread.c      |   15 +-
>  fs/btrfs/async-thread.h      |    4 +-
>  fs/btrfs/backref.c           |  122 ++--
>  fs/btrfs/backref.h           |    5 +-
>  fs/btrfs/compression.c       |   38 +-
>  fs/btrfs/compression.h       |    2 +-
>  fs/btrfs/ctree.c             |  384 ++++++------
>  fs/btrfs/ctree.h             |  169 +++--
>  fs/btrfs/delayed-inode.c     |   33 +-
>  fs/btrfs/delayed-ref.c       |   33 +-
>  fs/btrfs/dir-item.c          |   10 +-
>  fs/btrfs/disk-io.c           |  649 ++++++++++---------
>  fs/btrfs/disk-io.h           |   10 +-
>  fs/btrfs/export.c            |    2 +-
>  fs/btrfs/extent-tree.c       |  737 ++++++++++++----------
>  fs/btrfs/extent_io.c         | 1035 ++++++++++++++++++++++---------
>  fs/btrfs/extent_io.h         |   62 +-
>  fs/btrfs/file-item.c         |   57 +-
>  fs/btrfs/file.c              |   52 +-
>  fs/btrfs/free-space-cache.c  |   15 +-
>  fs/btrfs/inode-item.c        |    6 +-
>  fs/btrfs/inode-map.c         |   25 +-
>  fs/btrfs/inode.c             |  457 +++++++++-----
>  fs/btrfs/ioctl.c             |  194 ++++--
>  fs/btrfs/locking.c           |    6 +-
>  fs/btrfs/locking.h           |    4 +-
>  fs/btrfs/ordered-data.c      |   60 +-
>  fs/btrfs/ordered-data.h      |   24 +-
>  fs/btrfs/orphan.c            |    2 +-
>  fs/btrfs/reada.c             |   10 +-
>  fs/btrfs/relocation.c        |  130 ++--
>  fs/btrfs/root-tree.c         |   25 +-
>  fs/btrfs/scrub.c             | 1408 +++++++++++++++++++++++++++++++-----------
>  fs/btrfs/struct-funcs.c      |   53 +-
>  fs/btrfs/super.c             |  192 +++++-
>  fs/btrfs/transaction.c       |  213 +++++--
>  fs/btrfs/transaction.h       |    3 +
>  fs/btrfs/tree-log.c          |   96 ++-
>  fs/btrfs/tree-log.h          |    2 +-
>  fs/btrfs/volumes.c           |  240 ++++---
>  fs/btrfs/volumes.h           |    4 +-
>  include/trace/events/btrfs.h |   44 ++
>  42 files changed, 4407 insertions(+), 2225 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

