Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727363AbeHaMAH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 08:00:07 -0400
Subject: Re: [PATCH 07/35] btrfs: dump block_rsv whe dumping space info
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-8-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f6b8c728-1ce5-f14a-533a-ad3ca9efeed7@suse.com>
Date: Fri, 31 Aug 2018 10:53:54 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-8-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:41, Josef Bacik wrote:
> For enospc_debug having the block rsvs is super helpful to see if we've
> done something wrong.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 80615a579b18..df826f713034 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7910,6 +7910,15 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>  	return ret;
>  }
>  
> +static void dump_block_rsv(struct btrfs_block_rsv *rsv)
> +{
> +	spin_lock(&rsv->lock);
> +	printk(KERN_ERR "%d: size %llu reserved %llu\n",
> +	       rsv->type, (unsigned long long)rsv->size,
> +	       (unsigned long long)rsv->reserved);
> +	spin_unlock(&rsv->lock);
> +}

There was feedback on this hunk which you seem to have ignored:

https://www.spinics.net/lists/linux-btrfs/msg80473.html

> +
>  static void dump_space_info(struct btrfs_fs_info *fs_info,
>  			    struct btrfs_space_info *info, u64 bytes,
>  			    int dump_block_groups)
> @@ -7929,6 +7938,12 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
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
