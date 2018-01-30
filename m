Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbeA3INL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 03:13:11 -0500
Subject: Re: [PATCH 1/3] btrfs: Refactor __get_raid_index() to
 btrfs_bg_flags_to_raid_index()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180130074039.24987-1-wqu@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <dd79a9bf-94fa-a0d0-c1f8-dd5a6d3ade94@oracle.com>
Date: Tue, 30 Jan 2018 16:14:22 +0800
MIME-Version: 1.0
In-Reply-To: <20180130074039.24987-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/30/2018 03:40 PM, Qu Wenruo wrote:
> Function __get_raid_index() is used to convert block group flags into
> raid index, which can be used to get various info directly from
> btrfs_raid_array[].
> 
> Refactor this function a little:
> 
> 1) Rename to btrfs_bg_flags_to_raid_index()
>     Double underline prefix is normally for internal functions, while the
>     function is used by both extent-tree and volumes.
> 
>     Although the name is a little longer, but it should explain its usage
>     quite well.
> 
> 2) Move it to volumes.h and make it static inline
>     Just several if-else branches, really no need to define it as a normal
>     function.
> 
>     This also makes later code re-use between kernel and btrfs-progs
>     easier.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


> ---
>   fs/btrfs/extent-tree.c | 26 ++++----------------------
>   fs/btrfs/volumes.c     |  2 +-
>   fs/btrfs/volumes.h     | 18 ++++++++++++++++++
>   3 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2f4328511ac8..e9c31b567a9c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7346,27 +7346,9 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
>   	return ret;
>   }
>   
> -int __get_raid_index(u64 flags)
> -{
> -	if (flags & BTRFS_BLOCK_GROUP_RAID10)
> -		return BTRFS_RAID_RAID10;
> -	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
> -		return BTRFS_RAID_RAID1;
> -	else if (flags & BTRFS_BLOCK_GROUP_DUP)
> -		return BTRFS_RAID_DUP;
> -	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
> -		return BTRFS_RAID_RAID0;
> -	else if (flags & BTRFS_BLOCK_GROUP_RAID5)
> -		return BTRFS_RAID_RAID5;
> -	else if (flags & BTRFS_BLOCK_GROUP_RAID6)
> -		return BTRFS_RAID_RAID6;
> -
> -	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
> -}
> -
>   int get_block_group_index(struct btrfs_block_group_cache *cache)
>   {
> -	return __get_raid_index(cache->flags);
> +	return btrfs_bg_flags_to_raid_index(cache->flags);
>   }
>   
>   static const char *btrfs_raid_type_names[BTRFS_NR_RAID_TYPES] = {
> @@ -7483,7 +7465,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>   	u64 empty_cluster = 0;
>   	struct btrfs_space_info *space_info;
>   	int loop = 0;
> -	int index = __get_raid_index(flags);
> +	int index = btrfs_bg_flags_to_raid_index(flags);
>   	bool failed_cluster_refill = false;
>   	bool failed_alloc = false;
>   	bool use_cluster = true;
> @@ -7579,7 +7561,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>   	}
>   search:
>   	have_caching_bg = false;
> -	if (index == 0 || index == __get_raid_index(flags))
> +	if (index == 0 || index == btrfs_bg_flags_to_raid_index(flags))
>   		full_search = true;
>   	down_read(&space_info->groups_sem);
>   	list_for_each_entry(block_group, &space_info->block_groups[index],
> @@ -9643,7 +9625,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
>   	 */
>   	target = get_restripe_target(fs_info, block_group->flags);
>   	if (target) {
> -		index = __get_raid_index(extended_to_chunk(target));
> +		index = btrfs_bg_flags_to_raid_index(extended_to_chunk(target));
>   	} else {
>   		/*
>   		 * this is just a balance, so if we were marked as full
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a25684287501..d818b1f9c625 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4625,7 +4625,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>   	if (list_empty(&fs_devices->alloc_list))
>   		return -ENOSPC;
>   
> -	index = __get_raid_index(type);
> +	index = btrfs_bg_flags_to_raid_index(type);
>   
>   	sub_stripes = btrfs_raid_array[index].sub_stripes;
>   	dev_stripes = btrfs_raid_array[index].dev_stripes;
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index ff15208344a7..413e07e44b42 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -533,6 +533,24 @@ static inline void btrfs_dev_stat_reset(struct btrfs_device *dev,
>   	btrfs_dev_stat_set(dev, index, 0);
>   }
>   
> +static inline enum btrfs_raid_types btrfs_bg_flags_to_raid_index(u64 flags)
> +{
> +	if (flags & BTRFS_BLOCK_GROUP_RAID10)
> +		return BTRFS_RAID_RAID10;
> +	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
> +		return BTRFS_RAID_RAID1;
> +	else if (flags & BTRFS_BLOCK_GROUP_DUP)
> +		return BTRFS_RAID_DUP;
> +	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
> +		return BTRFS_RAID_RAID0;
> +	else if (flags & BTRFS_BLOCK_GROUP_RAID5)
> +		return BTRFS_RAID_RAID5;
> +	else if (flags & BTRFS_BLOCK_GROUP_RAID6)
> +		return BTRFS_RAID_RAID6;
> +
> +	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
> +}
> +
>   void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
>   void btrfs_update_commit_device_bytes_used(struct btrfs_fs_info *fs_info,
>   					struct btrfs_transaction *transaction);
> 
