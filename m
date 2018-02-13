Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36508 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933366AbeBMHEy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 02:04:54 -0500
Subject: Re: [PATCH v2] btrfs: fix endianness compatibility during the SB RW
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180212153749.19705-1-anand.jain@oracle.com>
 <20180213030046.14093-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4a478bb7-bf0c-20e7-0e6f-37dc3821ab5f@suse.com>
Date: Tue, 13 Feb 2018 09:04:49 +0200
MIME-Version: 1.0
In-Reply-To: <20180213030046.14093-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.02.2018 05:00, Anand Jain wrote:
> Fixes the endianness bug in the fs_info::super_copy by using its
> btrfs_set_super...() function to set values in the SB, as these
> functions manage the endianness compatibility nicely.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

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
> 
