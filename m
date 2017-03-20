Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:46416 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755257AbdCTVKZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 17:10:25 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v2KL5X1g013828
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Mar 2017 21:05:33 GMT
Date: Mon, 20 Mar 2017 14:03:47 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/7] btrfs: remove redundant parameter from
 reada_find_zone
Message-ID: <20170320210347.GH5540@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1489593696.git.dsterba@suse.com>
 <ab9356d6b2db1095d1f09f9039e46df0099240d9.1489593696.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ab9356d6b2db1095d1f09f9039e46df0099240d9.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 15, 2017 at 05:02:36PM +0100, David Sterba wrote:
> We can read fs_info from dev.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/reada.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
> index 5edf7328f67d..c1fc79cd4b2a 100644
> --- a/fs/btrfs/reada.c
> +++ b/fs/btrfs/reada.c
> @@ -235,10 +235,10 @@ int btree_readahead_hook(struct extent_buffer *eb, int err)
>  	return ret;
>  }
>  
> -static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
> -					  struct btrfs_device *dev, u64 logical,
> +static struct reada_zone *reada_find_zone(struct btrfs_device *dev, u64 logical,
>  					  struct btrfs_bio *bbio)
>  {
> +	struct btrfs_fs_info *fs_info = dev->fs_info;
>  	int ret;
>  	struct reada_zone *zone;
>  	struct btrfs_block_group_cache *cache = NULL;
> @@ -372,7 +372,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
>  		 if (!dev->bdev)
>  			continue;
>  
> -		zone = reada_find_zone(fs_info, dev, logical, bbio);
> +		zone = reada_find_zone(dev, logical, bbio);
>  		if (!zone)
>  			continue;
>  
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
