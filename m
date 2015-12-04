Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36680 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbbLDCZy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 21:25:54 -0500
Date: Thu, 3 Dec 2015 18:25:37 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/12] btrfs: change how delay_iput is tracked in
 btrfs_delalloc_work
Message-ID: <20151204022537.GH19589@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1449161602.git.dsterba@suse.com>
 <a4469a31e3b0cc55ebba9c3aee26cd5632743056.1449161602.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a4469a31e3b0cc55ebba9c3aee26cd5632743056.1449161602.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 03, 2015 at 05:56:32PM +0100, David Sterba wrote:
> The dellaloc work is not frequently used, the delayed status is once set
> and read so it looks quite safe to drop the member and store the status
> in the lowest bit of the inode pointer.
> 
> Combined with the removal of 'wait' we got +2 objects per 4k slab.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h |  5 ++++-
>  fs/btrfs/inode.c | 11 +++++++++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index a61c53bce162..d5e250a65725 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3901,8 +3901,11 @@ void btrfs_extent_item_to_extent_map(struct inode *inode,
>  
>  /* inode.c */
>  struct btrfs_delalloc_work {
> +	/*
> +	 * Note: lowest bit of inode tracks if the iput is delayed,
> +	 * do not access the pointer directly.
> +	 */
>  	struct inode *inode;
> -	int delay_iput;
>  	struct completion completion;
>  	struct list_head list;
>  	struct btrfs_work work;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 15b29e879ffc..529a53b80ca0 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9436,16 +9436,21 @@ static void btrfs_run_delalloc_work(struct btrfs_work *work)
>  {
>  	struct btrfs_delalloc_work *delalloc_work;
>  	struct inode *inode;
> +	int delay_iput;
>  
>  	delalloc_work = container_of(work, struct btrfs_delalloc_work,
>  				     work);
>  	inode = delalloc_work->inode;
> +	/* Lowest bit of inode pointer tracks the delayed status */
> +	delay_iput = ((unsigned long)inode & 1UL);
> +	inode = (struct inode *)((unsigned long)inode & ~1UL);
> +

To be quite frankly, I don't like this, it's a pointer anyway, error-prone in a debugging view, instead would 'u8 delayed_iput' help?

Thanks,

-liubo

>  	filemap_flush(inode->i_mapping);
>  	if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
>  				&BTRFS_I(inode)->runtime_flags))
>  		filemap_flush(inode->i_mapping);
>  
> -	if (delalloc_work->delay_iput)
> +	if (delay_iput)
>  		btrfs_add_delayed_iput(inode);
>  	else
>  		iput(inode);
> @@ -9464,7 +9469,9 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
>  	init_completion(&work->completion);
>  	INIT_LIST_HEAD(&work->list);
>  	work->inode = inode;
> -	work->delay_iput = delay_iput;
> +	/* Lowest bit of inode pointer tracks the delayed status */
> +	if (delay_iput)
> +		*((unsigned long *)work->inode) |= 1UL;
>  	WARN_ON_ONCE(!inode);
>  	btrfs_init_work(&work->work, btrfs_flush_delalloc_helper,
>  			btrfs_run_delalloc_work, NULL, NULL);
> -- 
> 2.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
