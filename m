Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbeBTSTT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 13:19:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1KIHjTl077106
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 18:19:17 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2g8pqxrw0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 18:19:17 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1KIJGa7023668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 18:19:16 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1KIJGdZ001564
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 18:19:16 GMT
Date: Tue, 20 Feb 2018 10:16:45 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix endianness compatibility during the SB RW
Message-ID: <20180220171645.GB22059@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20180212153749.19705-1-anand.jain@oracle.com>
 <20180213030046.14093-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180213030046.14093-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 13, 2018 at 11:00:46AM +0800, Anand Jain wrote:
> Fixes the endianness bug in the fs_info::super_copy by using its
> btrfs_set_super...() function to set values in the SB, as these
> functions manage the endianness compatibility nicely.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2: Update change log. Update $Subject.
>         Old:
>         [PATCH] btrfs: use set functions to update latest refs to the SB
>  fs/btrfs/transaction.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 04f07144b45c..9220f004001c 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1722,19 +1722,23 @@ static void update_super_roots(struct btrfs_fs_info *fs_info)
>  
>  	super = fs_info->super_copy;
>  
> +	/* update latest btrfs_super_block::chunk_root refs */
>  	root_item = &fs_info->chunk_root->root_item;
> -	super->chunk_root = root_item->bytenr;
> -	super->chunk_root_generation = root_item->generation;
> -	super->chunk_root_level = root_item->level;
> +	btrfs_set_super_chunk_root(super, root_item->bytenr);
> +	btrfs_set_super_chunk_root_generation(super, root_item->generation);
> +	btrfs_set_super_chunk_root_level(super, root_item->level);
>  
> +	/* update latest btrfs_super_block::root refs */
>  	root_item = &fs_info->tree_root->root_item;
> -	super->root = root_item->bytenr;
> -	super->generation = root_item->generation;
> -	super->root_level = root_item->level;
> +	btrfs_set_super_root(super, root_item->bytenr);
> +	btrfs_set_super_generation(super, root_item->generation);
> +	btrfs_set_super_root_level(super, root_item->level);
> +
>  	if (btrfs_test_opt(fs_info, SPACE_CACHE))
> -		super->cache_generation = root_item->generation;
> +		btrfs_set_super_cache_generation(super, root_item->generation);
>  	if (test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))
> -		super->uuid_tree_generation = root_item->generation;
> +		btrfs_set_super_uuid_tree_generation(super,
> +						     root_item->generation);
>  }
>  
>  int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
