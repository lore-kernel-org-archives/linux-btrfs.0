From: Arne Jansen <sensille@gmx.net>
Subject: Re: [RFC][PATCH 1/2] Btrfs: try to allocate new chunks with degenerated
 profile
Date: Wed, 18 Jan 2012 11:14:23 +0100
Message-ID: <4F169B7F.6010700@gmx.net>
References: <4F154738.8000709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F154738.8000709@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 17.01.2012 11:02, Miao Xie wrote:
> If there is no free space, the free space allocator will try to get space from
> the block group with the degenerated profile. For example, if there is no free
> space in the RAID1 block groups, the allocator will try to allocate space from
> the DUP block groups. And besides that, the space reservation has the similar
> behaviour: if there is no enough space in the space cache to reserve, it will
> reserve the space according to the disk space, and it just take mirror storage
> into account, no RAID0, RAID1, or RAID10.
> 
> So we'd better make the behaviour of chunk allocation correspond with space
> reservation and free space allocation, if there is no enough disk space to
> allocate RAID(RAID0, RAID1, RAID10) chunks, we degenerate the profile and try
> to allocate chunks again. Otherwise, enospc will happen though we reserve
> the space successfully and BUG_ON() will be triggered.
> 
> Degenerating rule:
>   RAID10 -> RAID1 -> DUP
>   RAID0 -> SINGLE
> 

Instead of changing the profile, wouldn't it be easier to just allow
RAID10 go down to 2 disks and RAID0 to 1? That would make things easier
in many places.
What I'm strongly opposed to is changing a RAID1 to DUP, as this loses
the protection against a single disk failure.

-Arne

> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c |   43 +++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3e68e2b..87cd611 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3065,6 +3065,30 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
>  	return flags;
>  }
>  
> +/*
> + * Degenerate the alloc profile:
> + *   RAID10 -> RAID1 -> DUP
> + *   RAID0 -> SINGLE
> + *
> + * This is used when there is no enough disk space to do chunk allocation.
> + * After degenerating the profile, we will try to allocate new chunks again.
> + */
> +static u64 btrfs_degenerate_alloc_profile(u64 flags)
> +{
> +	if (flags & BTRFS_BLOCK_GROUP_RAID10) {
> +		flags &= ~BTRFS_BLOCK_GROUP_RAID10;
> +		flags |= BTRFS_BLOCK_GROUP_RAID1;
> +	} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
> +		flags &= ~BTRFS_BLOCK_GROUP_RAID1;
> +		flags |= BTRFS_BLOCK_GROUP_DUP;
> +	} else if (flags & BTRFS_BLOCK_GROUP_RAID0) {
> +		flags &= ~BTRFS_BLOCK_GROUP_RAID0;
> +	} else
> +		flags = ULLONG_MAX;
> +
> +	return flags;
> +}
> +
>  static u64 get_alloc_profile(struct btrfs_root *root, u64 flags)
>  {
>  	if (flags & BTRFS_BLOCK_GROUP_DATA)
> @@ -3356,8 +3380,23 @@ again:
>  	}
>  
>  	ret = btrfs_alloc_chunk(trans, extent_root, flags);
> -	if (ret < 0 && ret != -ENOSPC)
> -		goto out;
> +	if (ret < 0) {
> +		if (ret != -ENOSPC)
> +			goto out;
> +
> +		/*
> +		 * Degenerate the alloc profile:
> +		 *   RAID10 -> RAID1 -> DUP
> +		 *   RAID0 -> SINGLE
> +		 * then we will try to allocate new chunks again. By this way,
> +		 * we can utilize the whole disk spacem and make the behaviour
> +		 * of the chunk allocation correspond with the space reservation
> +		 * and the free space allocation.
> +		 */
> +		flags = btrfs_degenerate_alloc_profile(flags);
> +		if (flags != ULLONG_MAX)
> +			goto again;
> +	}
>  
>  	spin_lock(&space_info->lock);
>  	if (ret)

