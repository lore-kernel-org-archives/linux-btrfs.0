From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix balance Oops
Date: Fri, 7 Aug 2009 08:50:39 +0200
Message-ID: <20090807065039.GR12579@kernel.dk>
References: <4A7BC631.3040106@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A7BC631.3040106@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 07 2009, Yan Zheng wrote:
> invalidate_inode_pages2_range may return -EBUSY occasionally
> which results Oops. This patch fixes the issue by moving
> invalidate_inode_pages2_range into a loop and keeping calling
> it until the return value is not -EBUSY.
> 
> Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
> 
> ---
> diff -urp 1/fs/btrfs/relocation.c 2/fs/btrfs/relocation.c
> --- 1/fs/btrfs/relocation.c	2009-07-29 10:03:04.367858774 +0800
> +++ 2/fs/btrfs/relocation.c	2009-08-07 13:26:43.882147138 +0800
> @@ -2553,8 +2553,13 @@ int relocate_inode_pages(struct inode *i
>  	last_index = (start + len - 1) >> PAGE_CACHE_SHIFT;
>  
>  	/* make sure the dirty trick played by the caller work */
> -	ret = invalidate_inode_pages2_range(inode->i_mapping,
> -					    first_index, last_index);
> +	while (1) {
> +		ret = invalidate_inode_pages2_range(inode->i_mapping,
> +						    first_index, last_index);
> +		if (ret != -EBUSY)
> +			break;
> +		cond_resched();
> +	}

If it returns EBUSY, would it not make more sense to call
filemap_write_and_wait_range() instead of hammering on invalidate?

-- 
Jens Axboe

