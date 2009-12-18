From: Chris Mason <chris.mason@oracle.com>
Subject: Re: PATCH] Do not limit RAID1 and DUP transfer length to one stripe
Date: Fri, 18 Dec 2009 09:23:24 -0500
Message-ID: <20091218142324.GC3202@think>
References: <4B2A80AB.9080401@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B2A80AB.9080401@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 17, 2009 at 02:04:11PM -0500, jim owens wrote:
> 
> The 65k stripe length should be ignored as the stripes are
> physically contiguous on disk so transfers can span stripes.
> 
> Signed-off-by: jim owens <jowens@hp.com>
> ---
>  fs/btrfs/volumes.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 20cbd2e..4a0c8e5 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2697,13 +2697,13 @@ again:
>  	/* stripe_offset is the offset of this block in its stripe*/
>  	stripe_offset = offset - stripe_offset;
>  
> -	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
> -			 BTRFS_BLOCK_GROUP_RAID10 |
> -			 BTRFS_BLOCK_GROUP_DUP)) {
> +	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
> +			 BTRFS_BLOCK_GROUP_RAID10)) {
>  		/* we limit the length of each bio to what fits in a stripe */
>  		*length = min_t(u64, em->len - offset,
>  			      map->stripe_len - stripe_offset);
>  	} else {
> +		/* RAID1, DUP, and simple disk stripes are all contiguous */
>  		*length = em->len - offset;
>  	}

We do need to make sure the bio doesn't try to span a chunk.  The
mapping code can't handle that.

-chris

