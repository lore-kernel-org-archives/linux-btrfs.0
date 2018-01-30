Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60780 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751631AbeA3INR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 03:13:17 -0500
Subject: Re: [PATCH 2/3] btrfs: Unexport get_block_group_index()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180130074039.24987-1-wqu@suse.com>
 <20180130074039.24987-2-wqu@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <405e0c97-9a71-da20-618a-6c55b6223ab3@oracle.com>
Date: Tue, 30 Jan 2018 16:14:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180130074039.24987-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e9c31b567a9c..6e1128aa29d6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7346,7 +7346,8 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
>   	return ret;
>   }
>   
> -int get_block_group_index(struct btrfs_block_group_cache *cache)
> +static enum btrfs_raid_types
> +get_block_group_index(struct btrfs_block_group_cache *cache)
>   {
>   	return btrfs_bg_flags_to_raid_index(cache->flags);
>   }

  This changed should rather be part of 1/3.

Thanks, Anand
