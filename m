Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95C4C10F14
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 10:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F2E22083E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 10:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfDLKRo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 06:17:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:58192 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726708AbfDLKRn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 06:17:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3690FAB48;
        Fri, 12 Apr 2019 10:17:42 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs: track odirect bytes in flight
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20190410195610.84110-1-josef@toxicpanda.com>
 <20190410195610.84110-2-josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <044fa7af-3c45-46ba-d15b-fdb606c83a3b@suse.com>
Date:   Fri, 12 Apr 2019 13:17:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190410195610.84110-2-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10.04.19 г. 22:56 ч., Josef Bacik wrote:
> When diagnosing a slowdown of generic/224 I noticed we were wasting a
> lot of time in shrink_delalloc() despite all writes being O_DIRECT
> writes.  O_DIRECT writes still have outstanding extents, but obviously
> cannot be directly flushed, instead we need to wait on their
> corresponding ordered extent.  Track the outstanding odirect write bytes
> and if this amount is higher than the delalloc bytes in the system go
> ahead and force us to wait on the ordered extents.

This is way too sparse. I've been running generic/224 to try and
reproduce your slowdown. So far I can confirm that this test exhibits
drastic swings in performance - I've seen it complete from 30s up to
300s. I've also been taking an offcputime[0] measurements in the case
where high completion times were observed but so far I haven't really
seen shrink_delalloc standing out.

Provide more information how you measured the said slowdown as well as
more information in the changelog about why it's happening. At the very
least this could be split into 2 patches:

1. Could add the percpu counter init + modification in ordered extent
routines

2. Should add the logic in shrink_delalloc. Ideally that patch will
include detailed explanation of how the problem manifests.


Slight off topic:

What purpose do the checks of trans in shrink_delalloc serve? Does it
mean "if there is currently an open transaction don't do any ordered
wait because that's expensive" ?


[0] https://drive.google.com/open?id=1rEtMchqll6LZ0hq7uAzYkC4vY975Mw4i

> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/ctree.h        |  1 +
>  fs/btrfs/disk-io.c      | 15 ++++++++++++++-
>  fs/btrfs/extent-tree.c  | 17 +++++++++++++++--
>  fs/btrfs/ordered-data.c |  9 ++++++++-
>  4 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 7e774d48c48c..e293d74b2ead 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1016,6 +1016,7 @@ struct btrfs_fs_info {
>  	/* used to keep from writing metadata until there is a nice batch */
>  	struct percpu_counter dirty_metadata_bytes;
>  	struct percpu_counter delalloc_bytes;
> +	struct percpu_counter odirect_bytes;
>  	s32 dirty_metadata_batch;
>  	s32 delalloc_batch;
>  
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7a88de4be8d7..3f0b1854cedc 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2641,11 +2641,17 @@ int open_ctree(struct super_block *sb,
>  		goto fail;
>  	}
>  
> -	ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0, GFP_KERNEL);
> +	ret = percpu_counter_init(&fs_info->odirect_bytes, 0, GFP_KERNEL);
>  	if (ret) {
>  		err = ret;
>  		goto fail_srcu;
>  	}
> +
> +	ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0, GFP_KERNEL);
> +	if (ret) {
> +		err = ret;
> +		goto fail_odirect_bytes;
> +	}
>  	fs_info->dirty_metadata_batch = PAGE_SIZE *
>  					(1 + ilog2(nr_cpu_ids));
>  
> @@ -3344,6 +3350,8 @@ int open_ctree(struct super_block *sb,
>  	percpu_counter_destroy(&fs_info->delalloc_bytes);
>  fail_dirty_metadata_bytes:
>  	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
> +fail_odirect_bytes:
> +	percpu_counter_destroy(&fs_info->odirect_bytes);
>  fail_srcu:
>  	cleanup_srcu_struct(&fs_info->subvol_srcu);
>  fail:
> @@ -4025,6 +4033,10 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>  		       percpu_counter_sum(&fs_info->delalloc_bytes));
>  	}
>  
> +	if (percpu_counter_sum(&fs_info->odirect_bytes))
> +		btrfs_info(fs_info, "at unmount odirect count %lld",
> +			   percpu_counter_sum(&fs_info->odirect_bytes));
> +
>  	btrfs_sysfs_remove_mounted(fs_info);
>  	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
>  
> @@ -4056,6 +4068,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>  
>  	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
>  	percpu_counter_destroy(&fs_info->delalloc_bytes);
> +	percpu_counter_destroy(&fs_info->odirect_bytes);
>  	percpu_counter_destroy(&fs_info->dev_replace.bio_counter);
>  	cleanup_srcu_struct(&fs_info->subvol_srcu);
>  
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index d0626f945de2..0982456ebabb 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4727,6 +4727,7 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
>  	struct btrfs_space_info *space_info;
>  	struct btrfs_trans_handle *trans;
>  	u64 delalloc_bytes;
> +	u64 odirect_bytes;
>  	u64 async_pages;
>  	u64 items;
>  	long time_left;
> @@ -4742,7 +4743,9 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
>  
>  	delalloc_bytes = percpu_counter_sum_positive(
>  						&fs_info->delalloc_bytes);
> -	if (delalloc_bytes == 0) {
> +	odirect_bytes = percpu_counter_sum_positive(
> +						&fs_info->odirect_bytes);
> +	if (delalloc_bytes == 0 && odirect_bytes == 0) {
>  		if (trans)
>  			return;
>  		if (wait_ordered)
> @@ -4750,8 +4753,16 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
>  		return;
>  	}
>  
> +	/*
> +	 * If we are doing more ordered than delalloc we need to just wait on
> +	 * ordered extents, otherwise we'll waste time trying to flush delalloc
> +	 * that likely won't give us the space back we need.
> +	 */
> +	if (odirect_bytes > delalloc_bytes)
> +		wait_ordered = true;
> +
>  	loops = 0;
> -	while (delalloc_bytes && loops < 3) {
> +	while ((delalloc_bytes || odirect_bytes)  && loops < 3) {
>  		nr_pages = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
>  
>  		/*
> @@ -4801,6 +4812,8 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
>  		}
>  		delalloc_bytes = percpu_counter_sum_positive(
>  						&fs_info->delalloc_bytes);
> +		odirect_bytes = percpu_counter_sum_positive(
> +						&fs_info->odirect_bytes);
>  	}
>  }
>  
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 6fde2b2741ef..967c62b85d77 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -194,8 +194,11 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>  	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
>  		set_bit(type, &entry->flags);
>  
> -	if (dio)
> +	if (dio) {
> +		percpu_counter_add_batch(&fs_info->odirect_bytes, len,
> +					 fs_info->delalloc_batch);
>  		set_bit(BTRFS_ORDERED_DIRECT, &entry->flags);
> +	}
>  
>  	/* one ref for the tree */
>  	refcount_set(&entry->refs, 1);
> @@ -468,6 +471,10 @@ void btrfs_remove_ordered_extent(struct inode *inode,
>  	if (root != fs_info->tree_root)
>  		btrfs_delalloc_release_metadata(btrfs_inode, entry->len, false);
>  
> +	if (test_bit(BTRFS_ORDERED_DIRECT, &entry->flags))
> +		percpu_counter_add_batch(&fs_info->odirect_bytes, -entry->len,
> +					 fs_info->delalloc_batch);
> +
>  	tree = &btrfs_inode->ordered_tree;
>  	spin_lock_irq(&tree->lock);
>  	node = &entry->rb_node;
> 
