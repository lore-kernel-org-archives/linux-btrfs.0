Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26984 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaGDDRc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 23:17:32 -0400
Date: Fri, 4 Jul 2014 11:17:20 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 9/9] Btrfs: fix writing data into the seed filesystem
Message-ID: <20140704031719.GF20612@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
 <1404382933-26672-9-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404382933-26672-9-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 03, 2014 at 06:22:13PM +0800, Miao Xie wrote:
> If we mounted a seed filesystem with degraded option, and then added a new
> device into the seed filesystem, then we found adding device failed because
> of the IO failure.
> 
> Steps to reproduce:
>  # mkfs.btrfs -d raid1 -m raid1 <dev0> <dev1>
>  # btrfstune -S 1 <dev0>
>  # mount <dev0> -o degraded <mnt>
>  # btrfs device add -f <dev2> <mnt>
> 
> It is because the original didn't set the chunk on the seed device to be
> read-only if the degraded flag was set. It was introduced by patch f48b90756,
> which fixed the problem the raid1 filesystem became read-only after one device
> of it was missing. But this fix method was not right, we should set the read-only
> flag according to the number of the missing devices, not the degraded mount
> option, if the number of the missing devices is less than the max error number
> that the profile of the chunk tolerates, we don't set it to be read-only.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo

> 
> Cc: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 52 ++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 36 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 73a82e5..daecfa5 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4584,12 +4584,31 @@ out:
>  	return ret;
>  }
>  
> +static inline int btrfs_chunk_max_errors(struct map_lookup *map)
> +{
> +	int max_errors;
> +
> +	if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
> +			 BTRFS_BLOCK_GROUP_RAID10 |
> +			 BTRFS_BLOCK_GROUP_RAID5 |
> +			 BTRFS_BLOCK_GROUP_DUP)) {
> +		max_errors = 1;
> +	} else if (map->type & BTRFS_BLOCK_GROUP_RAID6) {
> +		max_errors = 2;
> +	} else {
> +		max_errors = 0;
> +	}
> +
> +	return max_errors;
> +}
> +
>  int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
>  {
>  	struct extent_map *em;
>  	struct map_lookup *map;
>  	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
>  	int readonly = 0;
> +	int miss_ndevs = 0;
>  	int i;
>  
>  	read_lock(&map_tree->map_tree.lock);
> @@ -4598,18 +4617,27 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
>  	if (!em)
>  		return 1;
>  
> -	if (btrfs_test_opt(root, DEGRADED)) {
> -		free_extent_map(em);
> -		return 0;
> -	}
> -
>  	map = (struct map_lookup *)em->bdev;
>  	for (i = 0; i < map->num_stripes; i++) {
> +		if (map->stripes[i].dev->missing) {
> +			miss_ndevs++;
> +			continue;
> +		}
> +
>  		if (!map->stripes[i].dev->writeable) {
>  			readonly = 1;
> -			break;
> +			goto end;
>  		}
>  	}
> +
> +	/*
> +	 * If the number of missing devices is larger than max errors,
> +	 * we can not write the data into that chunk successfully, so
> +	 * set it readonly.
> +	 */
> +	if (miss_ndevs > btrfs_chunk_max_errors(map))
> +		readonly = 1;
> +end:
>  	free_extent_map(em);
>  	return readonly;
>  }
> @@ -5220,16 +5248,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
>  		}
>  	}
>  
> -	if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) {
> -		if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
> -				 BTRFS_BLOCK_GROUP_RAID10 |
> -				 BTRFS_BLOCK_GROUP_RAID5 |
> -				 BTRFS_BLOCK_GROUP_DUP)) {
> -			max_errors = 1;
> -		} else if (map->type & BTRFS_BLOCK_GROUP_RAID6) {
> -			max_errors = 2;
> -		}
> -	}
> +	if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS))
> +		max_errors = btrfs_chunk_max_errors(map);
>  
>  	if (dev_replace_is_ongoing && (rw & (REQ_WRITE | REQ_DISCARD)) &&
>  	    dev_replace->tgtdev != NULL) {
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
