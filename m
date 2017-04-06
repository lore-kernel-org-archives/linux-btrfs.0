Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52709 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756246AbdDFPCK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Apr 2017 11:02:10 -0400
Date: Thu, 6 Apr 2017 17:01:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
Message-ID: <20170406150125.GQ4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170406090516.7113-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170406090516.7113-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 06, 2017 at 05:05:16PM +0800, Qu Wenruo wrote:
> [BUG]
> Cycle mount btrfs can cause fiemap to return different result.
> Like:
>  # mount /dev/vdb5 /mnt/btrfs
>  # dd if=/dev/zero bs=16K count=4 oflag=dsync of=/mnt/btrfs/file
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>  /mnt/test/file:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..127]:        25088..25215       128   0x1
>  # umount /mnt/btrfs
>  # mount /dev/vdb5 /mnt/btrfs
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>  /mnt/test/file:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..31]:         25088..25119        32   0x0
>    1: [32..63]:        25120..25151        32   0x0
>    2: [64..95]:        25152..25183        32   0x0
>    3: [96..127]:       25184..25215        32   0x1
> But after above fiemap, we get correct merged result if we call fiemap
> again.
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>  /mnt/test/file:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..127]:        25088..25215       128   0x1
> 
> [REASON]
> Btrfs will try to merge extent map when inserting new extent map.
> 
> btrfs_fiemap(start=0 len=(u64)-1)
> |- extent_fiemap(start=0 len=(u64)-1)
>    |- get_extent_skip_holes(start=0 len=64k)
>    |  |- btrfs_get_extent_fiemap(start=0 len=64k)
>    |     |- btrfs_get_extent(start=0 len=64k)
>    |        |  Found on-disk (ino, EXTENT_DATA, 0)
>    |        |- add_extent_mapping()
>    |        |- Return (em->start=0, len=16k)
>    |
>    |- fiemap_fill_next_extent(logic=0 phys=X len=16k)
>    |
>    |- get_extent_skip_holes(start=0 len=64k)
>    |  |- btrfs_get_extent_fiemap(start=0 len=64k)
>    |     |- btrfs_get_extent(start=16k len=48k)
>    |        |  Found on-disk (ino, EXTENT_DATA, 16k)
>    |        |- add_extent_mapping()
>    |        |  |- try_merge_map()
>    |        |     Merge with previous em start=0 len=16k
>    |        |     resulting em start=0 len=32k
>    |        |- Return (em->start=0, len=32K)    << Merged result
>    |- Stripe off the unrelated range (0~16K) of return em
>    |- fiemap_fill_next_extent(logic=16K phys=X+16K len=16K)
>       ^^^ Causing split fiemap extent.
> 
> And since in add_extent_mapping(), em is already merged, in next
> fiemap() call, we will get merged result.
> 
> [FIX]
> Here we introduce a new structure, fiemap_cache, which records previous
> fiemap extent.
> 
> And will always try to merge current fiemap_cache result before calling
> fiemap_fill_next_extent().
> Only when we failed to merge current fiemap extent with cached one, we
> will call fiemap_fill_next_extent() to submit cached one.
> 
> So by this method, we can merge all fiemap extents.
> 
> It can also be done in fs/ioctl.c, however the problem is if
> fieinfo->fi_extents_max == 0, we have no space to cache previous fiemap
> extent.
> So I choose to merge it in btrfs.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>   Since fiemap_extent_info has a limit for number of fiemap_extent, it's possible
>   that fiemap_fill_next_extent() return 1 halfway. Remove the WARN_ON() which can
>   cause kernel warning if we fiemap is called on large compressed file.
> ---
>  fs/btrfs/extent_io.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 110 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 28e81922a21c..84f4090dfaff 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4353,6 +4353,107 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
>  	return NULL;
>  }
>  
> +/*
> + * To cache previous fiemap extent
> + *
> + * Will be used for merging fiemap extent
> + */
> +struct fiemap_cache {
> +	bool cached;
> +	u64 offset;
> +	u64 phys;
> +	u64 len;
> +	u32 flags;
> +};
> +
> +/*
> + * Helper to submit fiemap extent.
> + *
> + * Will try to merge current fiemap extent specified by @offset, @phys,
> + * @len and @flags with cached one.
> + * And only when we fails to merge, cached one will be submitted as
> + * fiemap extent.
> + *
> + * Return 0 if merged or submitted.
> + * Return <0 for error.
> + */
> +static int submit_fiemap_extent(struct fiemap_extent_info *fieinfo,
> +				struct fiemap_cache *cache,
> +				u64 offset, u64 phys, u64 len, u32 flags)
> +{
> +	int ret;
> +
> +	if (!cache->cached) {
> +assign:
> +		cache->cached = true;
> +		cache->offset = offset;
> +		cache->phys = phys;
> +		cache->len = len;
> +		cache->flags = flags;
> +		return 0;
> +	}
> +
> +	/*
> +	 * Sanity check, extent_fiemap() should have ensured that new
> +	 * fiemap extent won't overlap with cahced one.
> +	 * NOTE: Physical address can overlap, due to compression
> +	 */
> +	WARN_ON(cache->offset + cache->len > offset);
> +
> +	/*
> +	 * Only merge fiemap extents if
> +	 * 1) Their logical addresses are continuous
> +	 *
> +	 * 2) Their physical addresses are continuous
> +	 *    So truly compressed (physical size smaller than logical size)
> +	 *    extents won't get merged with each other
> +	 *
> +	 * 3) Share same flags except FIEMAP_EXTENT_LAST
> +	 *    So regular extent won't get merged with prealloc extent
> +	 *
> +	 * 4) Merged result is no larger than BTRFS_MAX_EXTENT_SIZE

Actually, why this? Currently fiemap reports extents larger than this.

> +	 */
> +	if (cache->offset + cache->len  == offset &&
> +	    cache->phys + cache->len == phys  &&
> +	    cache->len + len <= BTRFS_MAX_EXTENT_SIZE &&
> +	    (cache->flags & ~FIEMAP_EXTENT_LAST) ==
> +			(flags & ~FIEMAP_EXTENT_LAST)) {
> +		cache->len += len;
> +		cache->flags |= flags;
> +
> +		/* Last extent, submit it anyway */
> +		if (cache->flags & FIEMAP_EXTENT_LAST) {
> +			cache->cached = false;
> +			return fiemap_fill_next_extent(fieinfo, cache->offset,
> +					cache->phys, cache->len, cache->flags);
> +		}
> +		return 0;
> +	}
> +
> +	/* Not mergeable, need to submit cached one */
> +	ret = fiemap_fill_next_extent(fieinfo, cache->offset, cache->phys,
> +				      cache->len, cache->flags);
> +	if (ret)
> +		return ret;
> +	goto assign;
> +}
> +
> +/*
> + * Submit the last cached fiemap extent.
> + */
> +static int finish_fiemap_extent(struct fiemap_extent_info *fieinfo,
> +				struct fiemap_cache *cache)
> +{
> +	int ret;
> +
> +	if (!cache->cached)
> +		return 0;
> +	ret = fiemap_fill_next_extent(fieinfo, cache->offset, cache->phys,
> +				      cache->len, cache->flags);
> +	cache->cached = false;
> +	return ret;
> +}
> +
>  int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		__u64 start, __u64 len, get_extent_t *get_extent)
>  {
> @@ -4370,6 +4471,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  	struct extent_state *cached_state = NULL;
>  	struct btrfs_path *path;
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct fiemap_cache cache = { 0 };
>  	int end = 0;
>  	u64 em_start = 0;
>  	u64 em_len = 0;
> @@ -4549,15 +4651,17 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  			flags |= FIEMAP_EXTENT_LAST;
>  			end = 1;
>  		}
> -		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
> -					      em_len, flags);
> -		if (ret) {
> -			if (ret == 1)
> -				ret = 0;
> +		ret = submit_fiemap_extent(fieinfo, &cache, em_start, disko,
> +					   em_len, flags);
> +		if (ret)
>  			goto out_free;
> -		}
>  	}
>  out_free:
> +	/* Submit any cached one */
> +	if (!ret)
> +		ret = finish_fiemap_extent(fieinfo, &cache);
> +	if (ret > 0)
> +		ret = 0;
>  	free_extent_map(em);
>  out:
>  	btrfs_free_path(path);
> -- 
> 2.12.2
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
