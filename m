Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51358 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727575AbeGSQXH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 12:23:07 -0400
Subject: Re: [PATCH 08/22] btrfs: dump block_rsv whe dumping space info
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <20180719145006.17532-8-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c38eec9f-82f9-f644-613f-58df462fcb55@suse.com>
Date: Thu, 19 Jul 2018 18:39:20 +0300
MIME-Version: 1.0
In-Reply-To: <20180719145006.17532-8-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.07.2018 17:49, Josef Bacik wrote:
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

Why do you cast to unsigned long long given that size/reserved are
already defined as u64? Also use pr_err rather than printk.

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
> 
