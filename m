Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752183AbeGBHtt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 03:49:49 -0400
Subject: Re: [PATCH] btrfs: use correct compare function of
 dirty_metadata_bytes
To: Ethan Lien <ethanlien@synology.com>, linux-btrfs@vger.kernel.org
References: <20180702074458.16270-1-ethanlien@synology.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <068bb6e1-78b9-ed1c-f9e2-08e90de5e928@suse.com>
Date: Mon, 2 Jul 2018 10:49:46 +0300
MIME-Version: 1.0
In-Reply-To: <20180702074458.16270-1-ethanlien@synology.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.07.2018 10:44, Ethan Lien wrote:
> We use customized, nodesize batch value to update dirty_metadata_bytes.
> We should also use batch version of compare function or we will easily
> goto fast path and get false result from percpu_counter_compare().
> 
> Signed-off-by: Ethan Lien <ethanlien@synology.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Also this needs the following tag: 

Fixes: e2d845211eda ("Btrfs: use percpu counter for dirty metadata count")

And perhaps stable from 4.4 onwards. But David will take care
of that. So the patch is good. 

> ---
>  fs/btrfs/disk-io.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 205092dc9390..dfed08e70ec1 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -961,8 +961,9 @@ static int btree_writepages(struct address_space *mapping,
>  
>  		fs_info = BTRFS_I(mapping->host)->root->fs_info;
>  		/* this is a bit racy, but that's ok */
> -		ret = percpu_counter_compare(&fs_info->dirty_metadata_bytes,
> -					     BTRFS_DIRTY_METADATA_THRESH);
> +		ret = __percpu_counter_compare(&fs_info->dirty_metadata_bytes,
> +					     BTRFS_DIRTY_METADATA_THRESH,
> +					     fs_info->dirty_metadata_batch);
>  		if (ret < 0)
>  			return 0;
>  	}
> @@ -4150,8 +4151,9 @@ static void __btrfs_btree_balance_dirty(struct btrfs_fs_info *fs_info,
>  	if (flush_delayed)
>  		btrfs_balance_delayed_items(fs_info);
>  
> -	ret = percpu_counter_compare(&fs_info->dirty_metadata_bytes,
> -				     BTRFS_DIRTY_METADATA_THRESH);
> +	ret = __percpu_counter_compare(&fs_info->dirty_metadata_bytes,
> +				     BTRFS_DIRTY_METADATA_THRESH,
> +				     fs_info->dirty_metadata_batch);
>  	if (ret > 0) {
>  		balance_dirty_pages_ratelimited(fs_info->btree_inode->i_mapping);
>  	}
> 
