Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034572AbeE1Pme (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:42:34 -0400
Subject: Re: [PATCH] btrfs: drop unused space_info parameter from
 create_space_info
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180528063027.4527-1-lufq.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f45ddea5-cbb4-f301-1c85-714ff38a2671@suse.com>
Date: Mon, 28 May 2018 09:40:21 +0300
MIME-Version: 1.0
In-Reply-To: <20180528063027.4527-1-lufq.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.05.2018 09:30, Lu Fengqi wrote:
> Since commit dc2d3005d27d ("btrfs: remove dead create_space_info
> calls"), there is only one caller btrfs_init_space_info. However, it
> doesn't need create_space_info to return space_info at all.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Nice,

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 2c65a09535b6..31627de751d1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4007,8 +4007,7 @@ static const char *alloc_name(u64 flags)
>  	};
>  }
>  
> -static int create_space_info(struct btrfs_fs_info *info, u64 flags,
> -			     struct btrfs_space_info **new)
> +static int create_space_info(struct btrfs_fs_info *info, u64 flags)
>  {
>  
>  	struct btrfs_space_info *space_info;
> @@ -4046,7 +4045,6 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags,
>  		return ret;
>  	}
>  
> -	*new = space_info;
>  	list_add_rcu(&space_info->list, &info->space_info);
>  	if (flags & BTRFS_BLOCK_GROUP_DATA)
>  		info->data_sinfo = space_info;
> @@ -10810,7 +10808,6 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>  
>  int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
>  {
> -	struct btrfs_space_info *space_info;
>  	struct btrfs_super_block *disk_super;
>  	u64 features;
>  	u64 flags;
> @@ -10826,21 +10823,21 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
>  		mixed = 1;
>  
>  	flags = BTRFS_BLOCK_GROUP_SYSTEM;
> -	ret = create_space_info(fs_info, flags, &space_info);
> +	ret = create_space_info(fs_info, flags);
>  	if (ret)
>  		goto out;
>  
>  	if (mixed) {
>  		flags = BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA;
> -		ret = create_space_info(fs_info, flags, &space_info);
> +		ret = create_space_info(fs_info, flags);
>  	} else {
>  		flags = BTRFS_BLOCK_GROUP_METADATA;
> -		ret = create_space_info(fs_info, flags, &space_info);
> +		ret = create_space_info(fs_info, flags);
>  		if (ret)
>  			goto out;
>  
>  		flags = BTRFS_BLOCK_GROUP_DATA;
> -		ret = create_space_info(fs_info, flags, &space_info);
> +		ret = create_space_info(fs_info, flags);
>  	}
>  out:
>  	return ret;
> 
