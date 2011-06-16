From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v1 6/6] scrub: add fixup code for errors on nodatasum
 files
Date: Thu, 16 Jun 2011 23:27:17 +0200
Message-ID: <20110616212717.GD12709@twin.jikos.cz>
References: <cover.1307991539.git.list.btrfs@jan-o-sch.net>
 <15e5902b4d0e0dbe6fdaa0994ea97ba874daf019.1307991539.git.list.btrfs@jan-o-sch.net>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <15e5902b4d0e0dbe6fdaa0994ea97ba874daf019.1307991539.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 13, 2011 at 09:10:39PM +0200, Jan Schmidt wrote:
> This removes a FIXME comment and introduces the first part of nodatasum
> fixup: It gets the corresponding inode for a logical address and triggers a
> regular readpage for the corrupted sector.
> 
> Once we have on-the-fly error correction our error will be automatically
> corrected. The correction code is expected to clear the newly introduced
> EXTENT_DAMAGED flag, making scrub report that error as "corrected" instead
> of "uncorrectable" eventually.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/extent_io.h |    1 +
>  fs/btrfs/scrub.c     |  174 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 170 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 2fef77f..906ea42 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -17,6 +17,7 @@
>  #define EXTENT_NODATASUM (1 << 10)
>  #define EXTENT_DO_ACCOUNTING (1 << 11)
>  #define EXTENT_FIRST_DELALLOC (1 << 12)
> +#define EXTENT_DAMAGED (1 << 13)
>  #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
>  #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
>  
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index ec29ce8..a2aa47a 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -27,6 +27,7 @@
>  #include "volumes.h"
>  #include "disk-io.h"
>  #include "ordered-data.h"
> +#include "transaction.h"
>  #include "backref.h"
>  
>  /*
> @@ -94,6 +95,7 @@ struct scrub_dev {
>  	int			first_free;
>  	int			curr;
>  	atomic_t		in_flight;
> +	atomic_t		fixup;

a nondescriptive name; a counter?

>  	spinlock_t		list_lock;
>  	wait_queue_head_t	list_wait;
>  	u16			csum_size;
> @@ -107,6 +109,14 @@ struct scrub_dev {
>  	spinlock_t		stat_lock;
>  };
>  
> +struct scrub_fixup_nodatasum {
> +	struct scrub_dev	*sdev;
> +	u64			logical;
> +	struct btrfs_root	*root;
> +	struct btrfs_work	work;
> +	u64			mirror_num;

int should be enough and is used elsewhere but scrub_page, uses u64 as well;
that's a bit too much IMO

> +};
> +
>  struct scrub_warning {
>  	struct btrfs_path	*path;
>  	u64			extent_item_size;
> @@ -195,12 +205,13 @@ struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
>  
>  		if (i != SCRUB_BIOS_PER_DEV-1)
>  			sdev->bios[i]->next_free = i + 1;
> -		 else
> +		else
>  			sdev->bios[i]->next_free = -1;
>  	}
>  	sdev->first_free = 0;
>  	sdev->curr = -1;
>  	atomic_set(&sdev->in_flight, 0);
> +	atomic_set(&sdev->fixup, 0);
>  	atomic_set(&sdev->cancel_req, 0);
>  	sdev->csum_size = btrfs_super_csum_size(&fs_info->super_copy);
>  	INIT_LIST_HEAD(&sdev->csum_list);
> @@ -330,6 +341,141 @@ out:
>  	kfree(swarn.msg_buf);
>  }
>  
> +static int scrub_fixup_readpage(u64 inum, loff_t offset, void *ctx)
> +{
> +	struct page *page;
> +	unsigned long index;
> +	struct scrub_fixup_nodatasum *fixup = ctx;
> +	int ret;
> +	int corrected;
> +	struct btrfs_key key;
> +	struct inode *inode;
> +	int end = offset + PAGE_SIZE - 1;

loff_t to int?

> +
> +	key.type = BTRFS_INODE_ITEM_KEY;
> +	key.objectid = inum;
> +	key.offset = 0;
> +	inode = btrfs_iget(fixup->root->fs_info->sb, &key,
> +				fixup->root->fs_info->fs_root, NULL);
> +	if (IS_ERR(inode))
> +		return -1;

needs better error code

> +
> +	ret = set_extent_bit(&BTRFS_I(inode)->io_tree, offset, end,
> +				EXTENT_DAMAGED, 0, NULL, NULL, GFP_NOFS);
> +	if (ret)
> +		return ret < 0 ? ret : -1;

needs better error code

> +
> +	index = offset >> PAGE_CACHE_SHIFT;
> +
> +	page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
> +	if (!page)
> +		return -1;

needs better error code

> +
> +	ret = extent_read_full_page(&BTRFS_I(inode)->io_tree, page,
> +					btrfs_get_extent, fixup->mirror_num);
> +	wait_on_page_locked(page);
> +	corrected = !test_range_bit(&BTRFS_I(inode)->io_tree, offset, end,
> +					EXTENT_DAMAGED, 0, NULL);
> +
> +	if (corrected)
> +		WARN_ON(!PageUptodate(page));
> +	else
> +		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset, end,
> +					EXTENT_DAMAGED, 0, 0, NULL, GFP_NOFS);
> +
> +	put_page(page);
> +	iput(inode);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret == 0 && corrected) {
> +		/*
> +		 * we only need to call readpage for one of the inodes belonging
> +		 * to this extent. so make iterate_extent_inodes stop
> +		 */
> +		return 1;
> +	}
> +
> +	return -1;
> +}
> +
> +static void scrub_fixup_nodatasum(struct btrfs_work *work)
> +{
> +	int ret;
> +	struct scrub_fixup_nodatasum *fixup;
> +	struct scrub_dev *sdev;
> +	struct btrfs_trans_handle *trans = NULL;
> +	struct btrfs_fs_info *fs_info;
> +	struct btrfs_path *path;
> +	int uncorrectable = 0;
> +
> +	fixup = container_of(work, struct scrub_fixup_nodatasum, work);
> +	sdev = fixup->sdev;
> +	fs_info = fixup->root->fs_info;
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		spin_lock(&sdev->stat_lock);
> +		++sdev->stat.malloc_errors;
> +		spin_unlock(&sdev->stat_lock);
> +		uncorrectable = 1;
> +		goto out;
> +	}
> +
> +	trans = btrfs_join_transaction(fixup->root);
> +	if (IS_ERR(trans)) {
> +		uncorrectable = 1;
> +		goto out;
> +	}
> +
> +	/*
> +	 * the idea is to trigger a regular read through the standard path. we
> +	 * read a page from the (failed) logical address by specifying the
> +	 * corresponding copynum of the failed sector. thus, that readpage is
> +	 * expected to fail.
> +	 * that is the point where on-the-fly error correction will kick in
> +	 * (once it's finished) and rewrite the failed sector if a good copy
> +	 * can be found.
> +	 */
> +	ret = iterate_inodes_from_logical(fixup->logical, fixup->root->fs_info,
> +						path, scrub_fixup_readpage,
> +						fixup);
> +	if (ret < 0) {
> +		uncorrectable = 1;
> +		goto out;
> +	}
> +	WARN_ON(ret != 1);
> +
> +	spin_lock(&sdev->stat_lock);
> +	++sdev->stat.corrected_errors;
> +	spin_unlock(&sdev->stat_lock);
> +
> +out:
> +	if (trans && !IS_ERR(trans))
> +		btrfs_end_transaction(trans, fixup->root);
> +	if (uncorrectable) {
> +		spin_lock(&sdev->stat_lock);
> +		++sdev->stat.uncorrectable_errors;
> +		spin_unlock(&sdev->stat_lock);
> +		if (printk_ratelimit())

                printk_ratelimited

> +			printk(KERN_ERR "btrfs: unable to fixup (nodatasum) "
> +				"error at logical %llu\n", fixup->logical);
> +	}
> +
> +	btrfs_free_path(path);
> +	kfree(fixup);
> +
> +	/* see caller why we're pretending to be paused in the scrub counters */
> +	mutex_lock(&fs_info->scrub_lock);
> +	atomic_dec(&fs_info->scrubs_running);
> +	atomic_dec(&fs_info->scrubs_paused);
> +	mutex_unlock(&fs_info->scrub_lock);
> +	atomic_dec(&sdev->fixup);
> +	wake_up(&fs_info->scrub_pause_wait);
> +	wake_up(&sdev->list_wait);
> +}
> +
>  /*
>   * scrub_recheck_error gets called when either verification of the page
>   * failed or the bio failed to read, e.g. with EIO. In the latter case,
> @@ -398,6 +544,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
>  	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
>  	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>  	struct btrfs_multi_bio *multi = NULL;
> +	struct scrub_fixup_nodatasum *fixup;
>  	u64 logical = sbio->logical + ix * PAGE_SIZE;
>  	u64 length;
>  	int i;
> @@ -406,12 +553,28 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
>  
>  	if ((sbio->spag[ix].flags & BTRFS_EXTENT_FLAG_DATA) &&
>  	    (sbio->spag[ix].have_csum == 0)) {
> +		fixup = kzalloc(sizeof(*fixup), GFP_NOFS);

what happens if the allocation fails?

> +		fixup->sdev = sdev;
> +		fixup->logical = logical;
> +		fixup->root = fs_info->extent_root;
> +		fixup->mirror_num = sbio->spag[ix].mirror_num;
>  		/*
> -		 * nodatasum, don't try to fix anything
> -		 * FIXME: we can do better, open the inode and trigger a
> -		 * writeback
> +		 * increment scrubs_running to prevent cancel requests from
> +		 * completing as long as a fixup worker is running. we must also
> +		 * increment scrubs_paused to prevent deadlocking on pause
> +		 * requests used for transactions commits (as the worker uses a
> +		 * transaction context). it is safe to regard the fixup worker
> +		 * as paused for all matters practical. effectively, we only
> +		 * avoid cancellation requests from completing.

from a rather brief look, this works as advertised

>  		 */
> -		goto uncorrectable;
> +		mutex_lock(&fs_info->scrub_lock);
> +		atomic_inc(&fs_info->scrubs_running);
> +		atomic_inc(&fs_info->scrubs_paused);
> +		mutex_unlock(&fs_info->scrub_lock);
> +		atomic_inc(&sdev->fixup);
> +		fixup->work.func = scrub_fixup_nodatasum;
> +		btrfs_queue_worker(&fs_info->scrub_workers, &fixup->work);
> +		return;
>  	}
>  
>  	length = PAGE_SIZE;
> @@ -1404,6 +1567,7 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
>  		ret = scrub_enumerate_chunks(sdev, start, end);
>  
>  	wait_event(sdev->list_wait, atomic_read(&sdev->in_flight) == 0);
> +	wait_event(sdev->list_wait, atomic_read(&sdev->fixup) == 0);

what about joining those into one wait?

>  
>  	atomic_dec(&fs_info->scrubs_running);
>  	wake_up(&fs_info->scrub_pause_wait);
