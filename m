From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: don't be as aggressive about using bitmaps
Date: Mon, 21 Mar 2011 10:34:31 +0800
Message-ID: <4D86B937.7080905@cn.fujitsu.com>
References: <1300479538-4385-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300479538-4385-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

04:18, Josef Bacik wrote:
> We have been creating bitmaps for small extents unconditionally forever.  This
> was great when testing to make sure the bitmap stuff was working, but is
> overkill normally.  So instead of always adding small chunks of free space to
> bitmaps, only start doing it if we go past half of our extent threshold.  This
> will keeps us from creating a bitmap for just one small free extent at the front
> of the block group, and will make the allocator a little faster as a result.
> Thanks,
> 

I was wondering this strategy when reading the code, so this patch
looks good to me.

Just a small nit:

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/free-space-cache.c |   19 ++++++++++++++++---
>  1 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 63776ae..7a808d7 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1287,9 +1287,22 @@ static int insert_into_bitmap(struct btrfs_block_group_cache *block_group,
>  	 * If we are below the extents threshold then we can add this as an
>  	 * extent, and don't have to deal with the bitmap
>  	 */
> -	if (block_group->free_extents < block_group->extents_thresh &&
> -	    info->bytes > block_group->sectorsize * 4)
> -		return 0;
> +	if (block_group->free_extents < block_group->extents_thresh) {
> +		/*
> +		 * If this block group has some small extents we don't want to
> +		 * use up all of our free slots in the cache with them, we want
> +		 * to reserve them to larger extents, however if we have plent
> +		 * of cache left then go ahead an dadd them, no sense in adding
> +		 * the overhead of a bitmap if we don't have to.
> +		 */
> +		if (info->bytes < block_group->sectorsize * 4) {

This also changes how we define a small extent (from 4 sectorsize to 3).
Is it intended?

> +			if ((block_group->free_extents * 2) <=

The parentheses isn't necessary nor help in readability I think.

> +			    block_group->extents_thresh)
> +				return 0;
> +		} else {
> +			return 0;
> +		}
> +	}
>  
>  	/*
>  	 * some block groups are so tiny they can't be enveloped by a bitmap, so

