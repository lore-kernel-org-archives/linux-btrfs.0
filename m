Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42473 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KGAbW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2012 19:31:22 -0500
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 270EA3EE0C0
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 09:31:20 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0D0F945DED2
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 09:31:20 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id E908045DECD
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 09:31:19 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id DB6F11DB8040
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 09:31:19 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 7DF1E1DB804B
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Nov 2012 09:31:19 +0900 (JST)
Message-ID: <5099ABC3.6050806@jp.fujitsu.com>
Date: Wed, 07 Nov 2012 09:30:59 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 19/26] Btrfs: add code to scrub to copy read data to another
 disk
References: <cover.1352214751.git.sbehrens@giantdisaster.de> <cef5c0f66f73ef151157fa524dede94eb29ae882.1352217244.git.sbehrens@giantdisaster.de>
In-Reply-To: <cef5c0f66f73ef151157fa524dede94eb29ae882.1352217244.git.sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2012/11/07 1:38), Stefan Behrens wrote:
> The device replace procedure makes use of the scrub code. The scrub
> code is the most efficient code to read the allocated data of a disk,
> i.e. it reads sequentially in order to avoid disk head movements, it
> skips unallocated blocks, it uses read ahead mechanisms, and it
> contains all the code to detect and repair defects.
> This commit adds code to scrub to allow the scrub code to copy read
> data to another disk.
> One goal is to be able to perform as fast as possible. Therefore the
> write requests are collected until huge bios are build, and the
> write process is decoupled from the read process with some kind of
> flow control, of course, in order to limit the allocated memory.
> The best performance on spinning disks could by reached when the
> head movements are avoided as much as possible. Therefore a single
> worker is used to interface the read process with the write process.
> The regular scrub operation works as fast as before, it is not
> negatively influenced and actually it is more or less unchanged.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>   fs/btrfs/ctree.h |   2 +
>   fs/btrfs/reada.c |  10 +-
>   fs/btrfs/scrub.c | 881 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
>   fs/btrfs/super.c |   3 +-
>   4 files changed, 823 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 83904b5..e17f211 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1483,6 +1483,8 @@ struct btrfs_fs_info {
>   	struct rw_semaphore scrub_super_lock;
>   	int scrub_workers_refcnt;
>   	struct btrfs_workers scrub_workers;
> +	struct btrfs_workers scrub_wr_completion_workers;
> +	struct btrfs_workers scrub_nocow_workers;
>   
>   #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>   	u32 check_integrity_print_mask;
> diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
> index 0ddc565..9f363e1 100644
> --- a/fs/btrfs/reada.c
> +++ b/fs/btrfs/reada.c
> @@ -418,12 +418,17 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
>   			 */
>   			continue;
>   		}
> +		if (!dev->bdev) {
> +			/* cannot read ahead on missing device */
> +			continue;
> +		}
>   		prev_dev = dev;
>   		ret = radix_tree_insert(&dev->reada_extents, index, re);
>   		if (ret) {
>   			while (--i >= 0) {
>   				dev = bbio->stripes[i].dev;
>   				BUG_ON(dev == NULL);
> +				/* ignore whether the entry was inserted */
>   				radix_tree_delete(&dev->reada_extents, index);
>   			}
>   			BUG_ON(fs_info == NULL);
> @@ -914,7 +919,10 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
>   	generation = btrfs_header_generation(node);
>   	free_extent_buffer(node);
>   
> -	reada_add_block(rc, start, &max_key, level, generation);
> +	if (reada_add_block(rc, start, &max_key, level, generation)) {
> +		kfree(rc);
> +		return ERR_PTR(-ENOMEM);
> +	}
>   
>   	reada_start_machine(root->fs_info);
>   
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 460e30b..59c69e0 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -25,6 +25,7 @@
>   #include "transaction.h"
>   #include "backref.h"
>   #include "extent_io.h"
> +#include "dev-replace.h"
>   #include "check-integrity.h"
>   #include "rcu-string.h"
>   
> @@ -44,8 +45,15 @@
>   struct scrub_block;
>   struct scrub_ctx;
>   
> -#define SCRUB_PAGES_PER_BIO	16	/* 64k per bio */
> -#define SCRUB_BIOS_PER_CTX	16	/* 1 MB per device in flight */
> +/*
> + * the following three values only influence the performance.
> + * The last one configures the number of parallel and outstanding I/O
> + * operations. The first two values configure an upper limit for the number
> + * of (dynamically allocated) pages that are added to a bio.
> + */
> +#define SCRUB_PAGES_PER_RD_BIO	32	/* 128k per bio */
> +#define SCRUB_PAGES_PER_WR_BIO	32	/* 128k per bio */
> +#define SCRUB_BIOS_PER_SCTX	64	/* 8MB per device in flight */
>   
>   /*
>    * the following value times PAGE_SIZE needs to be large enough to match the
> @@ -62,6 +70,7 @@ struct scrub_page {
>   	u64			generation;
>   	u64			logical;
>   	u64			physical;
> +	u64			physical_for_dev_replace;
>   	atomic_t		ref_count;
>   	struct {
>   		unsigned int	mirror_num:8;
> @@ -79,7 +88,11 @@ struct scrub_bio {
>   	int			err;
>   	u64			logical;
>   	u64			physical;
> -	struct scrub_page	*pagev[SCRUB_PAGES_PER_BIO];
> +#if SCRUB_PAGES_PER_WR_BIO >= SCRUB_PAGES_PER_RD_BIO
> +	struct scrub_page	*pagev[SCRUB_PAGES_PER_WR_BIO];
> +#else
> +	struct scrub_page	*pagev[SCRUB_PAGES_PER_RD_BIO];
> +#endif
>   	int			page_count;
>   	int			next_free;
>   	struct btrfs_work	work;
> @@ -99,8 +112,16 @@ struct scrub_block {
>   	};
>   };
>   
> +struct scrub_wr_ctx {
> +	struct scrub_bio *wr_curr_bio;
> +	struct btrfs_device *tgtdev;
> +	int pages_per_wr_bio; /* <= SCRUB_PAGES_PER_WR_BIO */
> +	atomic_t flush_all_writes;
> +	struct mutex wr_lock;
> +};
> +
>   struct scrub_ctx {
> -	struct scrub_bio	*bios[SCRUB_BIOS_PER_CTX];
> +	struct scrub_bio	*bios[SCRUB_BIOS_PER_SCTX];
>   	struct btrfs_root	*dev_root;
>   	int			first_free;
>   	int			curr;
> @@ -112,12 +133,13 @@ struct scrub_ctx {
>   	struct list_head	csum_list;
>   	atomic_t		cancel_req;
>   	int			readonly;
> -	int			pages_per_bio; /* <= SCRUB_PAGES_PER_BIO */
> +	int			pages_per_rd_bio;
>   	u32			sectorsize;
>   	u32			nodesize;
>   	u32			leafsize;
>   
>   	int			is_dev_replace;
> +	struct scrub_wr_ctx	wr_ctx;
>   
>   	/*
>   	 * statistics
> @@ -135,6 +157,15 @@ struct scrub_fixup_nodatasum {
>   	int			mirror_num;
>   };
>   
> +struct scrub_copy_nocow_ctx {
> +	struct scrub_ctx	*sctx;
> +	u64			logical;
> +	u64			len;
> +	int			mirror_num;
> +	u64			physical_for_dev_replace;
> +	struct btrfs_work	work;
> +};
> +
>   struct scrub_warning {
>   	struct btrfs_path	*path;
>   	u64			extent_item_size;
> @@ -156,8 +187,9 @@ static void scrub_pending_trans_workers_dec(struct scrub_ctx *sctx);
>   static int scrub_handle_errored_block(struct scrub_block *sblock_to_check);
>   static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
>   				     struct btrfs_fs_info *fs_info,
> +				     struct scrub_block *original_sblock,
>   				     u64 length, u64 logical,
> -				     struct scrub_block *sblock);
> +				     struct scrub_block *sblocks_for_recheck);
>   static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
>   				struct scrub_block *sblock, int is_metadata,
>   				int have_csum, u8 *csum, u64 generation,
> @@ -174,6 +206,9 @@ static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
>   static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
>   					    struct scrub_block *sblock_good,
>   					    int page_num, int force_write);
> +static void scrub_write_block_to_dev_replace(struct scrub_block *sblock);
> +static int scrub_write_page_to_dev_replace(struct scrub_block *sblock,
> +					   int page_num);
>   static int scrub_checksum_data(struct scrub_block *sblock);
>   static int scrub_checksum_tree_block(struct scrub_block *sblock);
>   static int scrub_checksum_super(struct scrub_block *sblock);
> @@ -181,14 +216,38 @@ static void scrub_block_get(struct scrub_block *sblock);
>   static void scrub_block_put(struct scrub_block *sblock);
>   static void scrub_page_get(struct scrub_page *spage);
>   static void scrub_page_put(struct scrub_page *spage);
> -static int scrub_add_page_to_bio(struct scrub_ctx *sctx,
> -				 struct scrub_page *spage);
> +static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
> +				    struct scrub_page *spage);
>   static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
>   		       u64 physical, struct btrfs_device *dev, u64 flags,
> -		       u64 gen, int mirror_num, u8 *csum, int force);
> +		       u64 gen, int mirror_num, u8 *csum, int force,
> +		       u64 physical_for_dev_replace);
>   static void scrub_bio_end_io(struct bio *bio, int err);
>   static void scrub_bio_end_io_worker(struct btrfs_work *work);
>   static void scrub_block_complete(struct scrub_block *sblock);
> +static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
> +			       u64 extent_logical, u64 extent_len,
> +			       u64 *extent_physical,
> +			       struct btrfs_device **extent_dev,
> +			       int *extent_mirror_num);
> +static int scrub_setup_wr_ctx(struct scrub_ctx *sctx,
> +			      struct scrub_wr_ctx *wr_ctx,
> +			      struct btrfs_fs_info *fs_info,
> +			      struct btrfs_device *dev,
> +			      int is_dev_replace);
> +static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx);
> +static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
> +				    struct scrub_page *spage);
> +static void scrub_wr_submit(struct scrub_ctx *sctx);
> +static void scrub_wr_bio_end_io(struct bio *bio, int err);
> +static void scrub_wr_bio_end_io_worker(struct btrfs_work *work);
> +static int write_page_nocow(struct scrub_ctx *sctx,
> +			    u64 physical_for_dev_replace, struct page *page);
> +static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
> +				      void *ctx);
> +static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
> +			    int mirror_num, u64 physical_for_dev_replace);
> +static void copy_nocow_pages_worker(struct btrfs_work *work);
>   
>   
>   static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
> @@ -262,19 +321,20 @@ static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
>   	if (!sctx)
>   		return;
>   
> +	scrub_free_wr_ctx(&sctx->wr_ctx);
> +
>   	/* this can happen when scrub is cancelled */
>   	if (sctx->curr != -1) {
>   		struct scrub_bio *sbio = sctx->bios[sctx->curr];
>   
>   		for (i = 0; i < sbio->page_count; i++) {
> -			BUG_ON(!sbio->pagev[i]);
> -			BUG_ON(!sbio->pagev[i]->page);
> +			WARN_ON(!sbio->pagev[i]->page);
>   			scrub_block_put(sbio->pagev[i]->sblock);
>   		}
>   		bio_put(sbio->bio);
>   	}
>   
> -	for (i = 0; i < SCRUB_BIOS_PER_CTX; ++i) {
> +	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
>   		struct scrub_bio *sbio = sctx->bios[i];
>   
>   		if (!sbio)
> @@ -292,18 +352,29 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
>   	struct scrub_ctx *sctx;
>   	int		i;
>   	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
> -	int pages_per_bio;
> +	int pages_per_rd_bio;
> +	int ret;
>   
> -	pages_per_bio = min_t(int, SCRUB_PAGES_PER_BIO,
> -			      bio_get_nr_vecs(dev->bdev));
> +	/*
> +	 * the setting of pages_per_rd_bio is correct for scrub but might
> +	 * be wrong for the dev_replace code where we might read from
> +	 * different devices in the initial huge bios. However, that
> +	 * code is able to correctly handle the case when adding a page
> +	 * to a bio fails.
> +	 */
> +	if (dev->bdev)
> +		pages_per_rd_bio = min_t(int, SCRUB_PAGES_PER_RD_BIO,
> +					 bio_get_nr_vecs(dev->bdev));
> +	else
> +		pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
>   	sctx = kzalloc(sizeof(*sctx), GFP_NOFS);
>   	if (!sctx)
>   		goto nomem;
>   	sctx->is_dev_replace = is_dev_replace;
> -	sctx->pages_per_bio = pages_per_bio;
> +	sctx->pages_per_rd_bio = pages_per_rd_bio;
>   	sctx->curr = -1;
>   	sctx->dev_root = dev->dev_root;
> -	for (i = 0; i < SCRUB_BIOS_PER_CTX; ++i) {
> +	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
>   		struct scrub_bio *sbio;
>   
>   		sbio = kzalloc(sizeof(*sbio), GFP_NOFS);
> @@ -316,7 +387,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
>   		sbio->page_count = 0;
>   		sbio->work.func = scrub_bio_end_io_worker;
>   
> -		if (i != SCRUB_BIOS_PER_CTX - 1)
> +		if (i != SCRUB_BIOS_PER_SCTX - 1)
>   			sctx->bios[i]->next_free = i + 1;
>   		else
>   			sctx->bios[i]->next_free = -1;
> @@ -334,6 +405,13 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
>   	spin_lock_init(&sctx->list_lock);
>   	spin_lock_init(&sctx->stat_lock);
>   	init_waitqueue_head(&sctx->list_wait);
> +
> +	ret = scrub_setup_wr_ctx(sctx, &sctx->wr_ctx, fs_info,
> +				 fs_info->dev_replace.tgtdev, is_dev_replace);
> +	if (ret) {
> +		scrub_free_ctx(sctx);
> +		return ERR_PTR(ret);
> +	}
>   	return sctx;
>   
>   nomem:
> @@ -341,7 +419,8 @@ nomem:
>   	return ERR_PTR(-ENOMEM);
>   }
>   
> -static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root, void *ctx)
> +static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
> +				     void *warn_ctx)
>   {
>   	u64 isize;
>   	u32 nlink;
> @@ -349,7 +428,7 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root, void *ctx)
>   	int i;
>   	struct extent_buffer *eb;
>   	struct btrfs_inode_item *inode_item;
> -	struct scrub_warning *swarn = ctx;
> +	struct scrub_warning *swarn = warn_ctx;
>   	struct btrfs_fs_info *fs_info = swarn->dev->dev_root->fs_info;
>   	struct inode_fs_paths *ipath = NULL;
>   	struct btrfs_root *local_root;
> @@ -492,11 +571,11 @@ out:
>   	kfree(swarn.msg_buf);
>   }
>   
> -static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *ctx)
> +static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
>   {
>   	struct page *page = NULL;
>   	unsigned long index;
> -	struct scrub_fixup_nodatasum *fixup = ctx;
> +	struct scrub_fixup_nodatasum *fixup = fixup_ctx;
>   	int ret;
>   	int corrected = 0;
>   	struct btrfs_key key;
> @@ -660,7 +739,9 @@ out:
>   		spin_lock(&sctx->stat_lock);
>   		++sctx->stat.uncorrectable_errors;
>   		spin_unlock(&sctx->stat_lock);
> -
> +		btrfs_dev_replace_stats_inc(
> +			&sctx->dev_root->fs_info->dev_replace.
> +			num_uncorrectable_read_errors);
>   		printk_ratelimited_in_rcu(KERN_ERR
>   			"btrfs: unable to fixup (nodatasum) error at logical %llu on dev %s\n",
>   			(unsigned long long)fixup->logical,
> @@ -715,6 +796,11 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>   	csum = sblock_to_check->pagev[0]->csum;
>   	dev = sblock_to_check->pagev[0]->dev;
>   
> +	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
> +		sblocks_for_recheck = NULL;
> +		goto nodatasum_case;
> +	}
> +
>   	/*
>   	 * read all mirrors one after the other. This includes to
>   	 * re-read the extent or metadata block that failed (that was
> @@ -758,7 +844,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>   	}
>   
>   	/* setup the context, map the logical blocks and alloc the pages */
> -	ret = scrub_setup_recheck_block(sctx, fs_info, length,
> +	ret = scrub_setup_recheck_block(sctx, fs_info, sblock_to_check, length,
>   					logical, sblocks_for_recheck);
>   	if (ret) {
>   		spin_lock(&sctx->stat_lock);
> @@ -789,6 +875,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>   		sctx->stat.unverified_errors++;
>   		spin_unlock(&sctx->stat_lock);
>   
> +		if (sctx->is_dev_replace)
> +			scrub_write_block_to_dev_replace(sblock_bad);
>   		goto out;
>   	}
>   
> @@ -822,12 +910,15 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>   				BTRFS_DEV_STAT_CORRUPTION_ERRS);
>   	}
>   
> -	if (sctx->readonly)
> +	if (sctx->readonly && !sctx->is_dev_replace)
>   		goto did_not_correct_error;
>   
>   	if (!is_metadata && !have_csum) {
>   		struct scrub_fixup_nodatasum *fixup_nodatasum;
>   
> +nodatasum_case:
> +		WARN_ON(sctx->is_dev_replace);
> +
>   		/*
>   		 * !is_metadata and !have_csum, this means that the data
>   		 * might not be COW'ed, that it might be modified
> @@ -883,18 +974,79 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>   		if (!sblock_other->header_error &&
>   		    !sblock_other->checksum_error &&
>   		    sblock_other->no_io_error_seen) {
> -			int force_write = is_metadata || have_csum;
> -
> -			ret = scrub_repair_block_from_good_copy(sblock_bad,
> -								sblock_other,
> -								force_write);
> +			if (sctx->is_dev_replace) {
> +				scrub_write_block_to_dev_replace(sblock_other);
> +			} else {
> +				int force_write = is_metadata || have_csum;
> +
> +				ret = scrub_repair_block_from_good_copy(
> +						sblock_bad, sblock_other,
> +						force_write);
> +			}
>   			if (0 == ret)
>   				goto corrected_error;
>   		}
>   	}
>   
>   	/*
> -	 * in case of I/O errors in the area that is supposed to be
> +	 * for dev_replace, pick good pages and write to the target device.
> +	 */
> +	if (sctx->is_dev_replace) {
> +		success = 1;
> +		for (page_num = 0; page_num < sblock_bad->page_count;
> +		     page_num++) {
> +			int sub_success;
> +
> +			sub_success = 0;
> +			for (mirror_index = 0;
> +			     mirror_index < BTRFS_MAX_MIRRORS &&
> +			     sblocks_for_recheck[mirror_index].page_count > 0;
> +			     mirror_index++) {
> +				struct scrub_block *sblock_other =
> +					sblocks_for_recheck + mirror_index;
> +				struct scrub_page *page_other =
> +					sblock_other->pagev[page_num];
> +
> +				if (!page_other->io_error) {
> +					ret = scrub_write_page_to_dev_replace(
> +							sblock_other, page_num);
> +					if (ret == 0) {
> +						/* succeeded for this page */
> +						sub_success = 1;
> +						break;
> +					} else {
> +						btrfs_dev_replace_stats_inc(
> +							&sctx->dev_root->
> +							fs_info->dev_replace.
> +							num_write_errors);
> +					}
> +				}
> +			}
> +
> +			if (!sub_success) {
> +				/*
> +				 * did not find a mirror to fetch the page
> +				 * from. scrub_write_page_to_dev_replace()
> +				 * handles this case (page->io_error), by
> +				 * filling the block with zeros before
> +				 * submitting the write request
> +				 */
> +				success = 0;
> +				ret = scrub_write_page_to_dev_replace(
> +						sblock_bad, page_num);
> +				if (ret)
> +					btrfs_dev_replace_stats_inc(
> +						&sctx->dev_root->fs_info->
> +						dev_replace.num_write_errors);
> +			}
> +		}
> +
> +		goto out;
> +	}
> +
> +	/*
> +	 * for regular scrub, repair those pages that are errored.
> +	 * In case of I/O errors in the area that is supposed to be
>   	 * repaired, continue by picking good copies of those pages.
>   	 * Select the good pages from mirrors to rewrite bad pages from
>   	 * the area to fix. Afterwards verify the checksum of the block
> @@ -1017,6 +1169,7 @@ out:
>   
>   static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
>   				     struct btrfs_fs_info *fs_info,
> +				     struct scrub_block *original_sblock,
>   				     u64 length, u64 logical,
>   				     struct scrub_block *sblocks_for_recheck)
>   {
> @@ -1047,7 +1200,7 @@ static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
>   			return -EIO;
>   		}
>   
> -		BUG_ON(page_index >= SCRUB_PAGES_PER_BIO);
> +		BUG_ON(page_index >= SCRUB_PAGES_PER_RD_BIO);
>   		for (mirror_index = 0; mirror_index < (int)bbio->num_stripes;
>   		     mirror_index++) {
>   			struct scrub_block *sblock;
> @@ -1071,6 +1224,10 @@ leave_nomem:
>   			sblock->pagev[page_index] = page;
>   			page->logical = logical;
>   			page->physical = bbio->stripes[mirror_index].physical;
> +			BUG_ON(page_index >= original_sblock->page_count);
> +			page->physical_for_dev_replace =
> +				original_sblock->pagev[page_index]->
> +				physical_for_dev_replace;
>   			/* for missing devices, dev->bdev is NULL */
>   			page->dev = bbio->stripes[mirror_index].dev;
>   			page->mirror_num = mirror_index + 1;
> @@ -1249,6 +1406,12 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
>   		int ret;
>   		DECLARE_COMPLETION_ONSTACK(complete);
>   
> +		if (!page_bad->dev->bdev) {
> +			printk_ratelimited(KERN_WARNING
> +				"btrfs: scrub_repair_page_from_good_copy(bdev == NULL) is unexpected!\n");
> +			return -EIO;
> +		}
> +
>   		bio = bio_alloc(GFP_NOFS, 1);
>   		if (!bio)
>   			return -EIO;
> @@ -1269,6 +1432,9 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
>   		if (!bio_flagged(bio, BIO_UPTODATE)) {
>   			btrfs_dev_stat_inc_and_print(page_bad->dev,
>   				BTRFS_DEV_STAT_WRITE_ERRS);
> +			btrfs_dev_replace_stats_inc(
> +				&sblock_bad->sctx->dev_root->fs_info->
> +				dev_replace.num_write_errors);
>   			bio_put(bio);
>   			return -EIO;
>   		}
> @@ -1278,7 +1444,166 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
>   	return 0;
>   }
>   
> -static void scrub_checksum(struct scrub_block *sblock)
> +static void scrub_write_block_to_dev_replace(struct scrub_block *sblock)
> +{
> +	int page_num;
> +
> +	for (page_num = 0; page_num < sblock->page_count; page_num++) {
> +		int ret;
> +
> +		ret = scrub_write_page_to_dev_replace(sblock, page_num);
> +		if (ret)
> +			btrfs_dev_replace_stats_inc(
> +				&sblock->sctx->dev_root->fs_info->dev_replace.
> +				num_write_errors);
> +	}
> +}
> +
> +static int scrub_write_page_to_dev_replace(struct scrub_block *sblock,
> +					   int page_num)
> +{
> +	struct scrub_page *spage = sblock->pagev[page_num];
> +
> +	BUG_ON(spage->page == NULL);
> +	if (spage->io_error) {
> +		void *mapped_buffer = kmap_atomic(spage->page);
> +
> +		memset(mapped_buffer, 0, PAGE_CACHE_SIZE);
> +		flush_dcache_page(spage->page);
> +		kunmap_atomic(mapped_buffer);
> +	}
> +	return scrub_add_page_to_wr_bio(sblock->sctx, spage);
> +}
> +
> +static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
> +				    struct scrub_page *spage)
> +{
> +	struct scrub_wr_ctx *wr_ctx = &sctx->wr_ctx;
> +	struct scrub_bio *sbio;
> +	int ret;
> +
> +	mutex_lock(&wr_ctx->wr_lock);
> +again:
> +	if (!wr_ctx->wr_curr_bio) {
> +		wr_ctx->wr_curr_bio = kzalloc(sizeof(*wr_ctx->wr_curr_bio),
> +					      GFP_NOFS);
> +		if (!wr_ctx->wr_curr_bio)

I think mutex_unlock(&wr_ctx->wr_lock) is necessary before it returns.

> +			return -ENOMEM;
> +		wr_ctx->wr_curr_bio->sctx = sctx;
> +		wr_ctx->wr_curr_bio->page_count = 0;
> +	}
...
...

- Tsutomu


