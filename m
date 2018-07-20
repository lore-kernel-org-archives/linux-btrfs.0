Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51822 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727410AbeGTMrq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 08:47:46 -0400
Date: Fri, 20 Jul 2018 13:59:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 08/22] btrfs: dump block_rsv whe dumping space info
Message-ID: <20180720115941.GB26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <20180719145006.17532-8-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180719145006.17532-8-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 10:49:52AM -0400, Josef Bacik wrote:
> For enospc_debug having the block rsvs is super helpful to see if we've
> done something wrong.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6de9a180abdd..35c1c1b7ba1d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8050,6 +8050,15 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>  	return ret;
>  }
>  
> +static void dump_block_rsv(struct btrfs_block_rsv *rsv)
> +{
> +	spin_lock(&rsv->lock);
> +	printk(KERN_ERR "%d: size %llu reserved %llu\n",
> +	       rsv->type, (unsigned long long)rsv->size,
> +	       (unsigned long long)rsv->reserved);

As you have fs_info available in the caller, you can pass it and use the
btrfs_err helper that print the filesystem identification.

> +	spin_unlock(&rsv->lock);
> +}
> +
>  static void dump_space_info(struct btrfs_fs_info *fs_info,
>  			    struct btrfs_space_info *info, u64 bytes,
>  			    int dump_block_groups)
> @@ -8069,6 +8078,12 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
>  		info->bytes_readonly);
>  	spin_unlock(&info->lock);
>  
> +	dump_block_rsv(&fs_info->global_block_rsv);
> +	dump_block_rsv(&fs_info->trans_block_rsv);
> +	dump_block_rsv(&fs_info->chunk_block_rsv);
> +	dump_block_rsv(&fs_info->delayed_block_rsv);
> +	dump_block_rsv(&fs_info->delayed_refs_rsv);
> +
>  	if (!dump_block_groups)
>  		return;
>  
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
