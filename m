Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50277 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751405AbdFZPag (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 11:30:36 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1B852ABB8
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jun 2017 15:30:35 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs: Optimise layout of btrfs_block_group_cache
To: linux-btrfs@vger.kernel.org
References: <1498488155-9941-1-git-send-email-nborisov@suse.com>
 <1498488155-9941-2-git-send-email-nborisov@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <da2bf011-533c-8af8-cc33-d15d5c18d5f8@suse.com>
Date: Mon, 26 Jun 2017 18:30:34 +0300
MIME-Version: 1.0
In-Reply-To: <1498488155-9941-2-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.06.2017 17:42, Nikolay Borisov wrote:
> With this patch applied pahole stats look like:
> 
> /* size: 840, cachelines: 14, members: 40 */
> /* sum members: 833, holes: 1, sum holes: 7 */
> /* bit holes: 1, sum bit holes: 28 bits */
> /* last cacheline: 8 bytes */
> 
> No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ctree.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index cdd3775e930b..bdd06bbeb9aa 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -586,6 +586,11 @@ struct btrfs_block_group_cache {
>  	unsigned int iref:1;
>  	unsigned int has_caching_ctl:1;
>  	unsigned int removed:1;
> +	/*
> +	 * Does the block group need to be added to the free space tree?
> +	 * Protected by free_space_lock.
> +	 */
> +	unsigned int needs_free_space:1;
Upon closer inspection of memory-barriers.txt I'm not confident in this
change. This puts fields protected by different locks in the same
bitfield which can lead to corrupted values.

>  
>  	int disk_cache_state;
>  
> @@ -608,6 +613,8 @@ struct btrfs_block_group_cache {
>  	/* usage count */
>  	atomic_t count;
>  
> +	atomic_t trimming

This one will likely eliminated 1 hole in the struct so I might end up
sending v2 of this patch.

> +
>  	/* List of struct btrfs_free_clusters for this block group.
>  	 * Today it will only have one thing on it, but that may change
>  	 */
> @@ -619,8 +626,6 @@ struct btrfs_block_group_cache {
>  	/* For read-only block groups */
>  	struct list_head ro_list;
>  
> -	atomic_t trimming;
> -
>  	/* For dirty block groups */
>  	struct list_head dirty_list;
>  	struct list_head io_list;
> @@ -651,11 +656,6 @@ struct btrfs_block_group_cache {
>  	/* Lock for free space tree operations. */
>  	struct mutex free_space_lock;
>  
> -	/*
> -	 * Does the block group need to be added to the free space tree?
> -	 * Protected by free_space_lock.
> -	 */
> -	int needs_free_space;
>  
>  	/* Record locked full stripes for RAID5/6 block group */
>  	struct btrfs_full_stripe_locks_tree full_stripe_locks_root;
> 
