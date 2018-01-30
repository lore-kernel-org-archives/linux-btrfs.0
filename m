Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58930 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbeA3IRX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 03:17:23 -0500
Subject: Re: [PATCH 3/3] btrfs: Refactor parameter of BTRFS_MAX_DEVS() from
 root to fs_info
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180130074039.24987-1-wqu@suse.com>
 <20180130074039.24987-3-wqu@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <3eea6611-ebf2-1175-7f1e-e992aeb567ba@oracle.com>
Date: Tue, 30 Jan 2018 16:18:33 +0800
MIME-Version: 1.0
In-Reply-To: <20180130074039.24987-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/30/2018 03:40 PM, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/volumes.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d818b1f9c625..215e85e22c8e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4581,7 +4581,7 @@ static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
>   	btrfs_set_fs_incompat(info, RAID56);
>   }
>   
> -#define BTRFS_MAX_DEVS(r) ((BTRFS_MAX_ITEM_SIZE(r->fs_info)		\
> +#define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
>   			- sizeof(struct btrfs_chunk))		\
>   			/ sizeof(struct btrfs_stripe) + 1)
>   
> @@ -4638,7 +4638,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>   		max_stripe_size = SZ_1G;
>   		max_chunk_size = 10 * max_stripe_size;
>   		if (!devs_max)
> -			devs_max = BTRFS_MAX_DEVS(info->chunk_root);
> +			devs_max = BTRFS_MAX_DEVS(info);
>   	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
>   		/* for larger filesystems, use larger metadata chunks */
>   		if (fs_devices->total_rw_bytes > 50ULL * SZ_1G)
> @@ -4647,7 +4647,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>   			max_stripe_size = SZ_256M;
>   		max_chunk_size = max_stripe_size;
>   		if (!devs_max)
> -			devs_max = BTRFS_MAX_DEVS(info->chunk_root);
> +			devs_max = BTRFS_MAX_DEVS(info);
>   	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
>   		max_stripe_size = SZ_32M;
>   		max_chunk_size = 2 * max_stripe_size;
> 
