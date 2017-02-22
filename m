Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28785 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdBVFkl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 00:40:41 -0500
Date: Tue, 21 Feb 2017 21:40:22 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] btrfs: let writepage_end_io_hook return void
Message-ID: <20170222054022.GD1497@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1487615195.git.dsterba@suse.com>
 <f29564877a65f4feb138891d6023de0ec1f91c8b.1487615195.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f29564877a65f4feb138891d6023de0ec1f91c8b.1487615195.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 20, 2017 at 07:31:24PM +0100, David Sterba wrote:
> There's no error path in any of the instances, always return 0.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.c | 9 +++------
>  fs/btrfs/extent_io.h | 2 +-
>  fs/btrfs/inode.c     | 6 ++----
>  3 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d15b5ddb6732..8de29aa4d1a2 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2435,12 +2435,9 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
>  
>  	tree = &BTRFS_I(page->mapping->host)->io_tree;
>  
> -	if (tree->ops && tree->ops->writepage_end_io_hook) {
> -		ret = tree->ops->writepage_end_io_hook(page, start,
> -					       end, NULL, uptodate);
> -		if (ret)
> -			uptodate = 0;
> -	}
> +	if (tree->ops && tree->ops->writepage_end_io_hook)
> +		tree->ops->writepage_end_io_hook(page, start, end, NULL,
> +				uptodate);
>  
>  	if (!uptodate) {
>  		ClearPageUptodate(page);
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 270d03be290e..fbc92315b503 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -103,7 +103,7 @@ struct extent_io_ops {
>  	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
>  				    struct page *page, u64 start, u64 end,
>  				    int mirror);
> -	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
> +	void (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
>  				      struct extent_state *state, int uptodate);
>  	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
>  			     unsigned *bits);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index dae2734a725b..eafadf0851d1 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2977,7 +2977,7 @@ static void finish_ordered_fn(struct btrfs_work *work)
>  	btrfs_finish_ordered_io(ordered_extent);
>  }
>  
> -static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
> +static void btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
>  				struct extent_state *state, int uptodate)
>  {
>  	struct inode *inode = page->mapping->host;
> @@ -2991,7 +2991,7 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
>  	ClearPagePrivate2(page);
>  	if (!btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
>  					    end - start + 1, uptodate))
> -		return 0;
> +		return;
>  
>  	if (btrfs_is_free_space_inode(inode)) {
>  		wq = fs_info->endio_freespace_worker;
> @@ -3004,8 +3004,6 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
>  	btrfs_init_work(&ordered_extent->work, func, finish_ordered_fn, NULL,
>  			NULL);
>  	btrfs_queue_work(wq, &ordered_extent->work);
> -
> -	return 0;
>  }
>  
>  static int __readpage_endio_check(struct inode *inode,
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
