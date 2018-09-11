Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38955 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725737AbeILENS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 00:13:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id j8-v6so3849pff.6
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 16:11:46 -0700 (PDT)
Date: Tue, 11 Sep 2018 16:11:45 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/36] btrfs: dump block_rsv whe dumping space info
Message-ID: <20180911231145.GE26631@vader>
References: <20180911175807.26181-1-josef@toxicpanda.com>
 <20180911175807.26181-9-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180911175807.26181-9-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 01:57:39PM -0400, Josef Bacik wrote:
> For enospc_debug having the block rsvs is super helpful to see if we've
> done something wrong.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a3baa16d456f..1cf66a92829b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7918,6 +7918,16 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>  	return ret;
>  }
>  
> +static void dump_block_rsv(struct btrfs_fs_info *fs_info,
> +			   struct btrfs_block_rsv *rsv)
> +{
> +	spin_lock(&rsv->lock);
> +	btrfs_info(fs_info, "%d: size %llu reserved %llu\n",
> +		   rsv->type, (unsigned long long)rsv->size,
> +		   (unsigned long long)rsv->reserved);

How about passing a string name for each of these instead of an ID which
we have to cross-reference with the source?

Besides that,

Reviewed-by: Omar Sandoval <osandov@fb.com>

> +	spin_unlock(&rsv->lock);
> +}
> +
>  static void dump_space_info(struct btrfs_fs_info *fs_info,
>  			    struct btrfs_space_info *info, u64 bytes,
>  			    int dump_block_groups)
> @@ -7937,6 +7947,12 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
>  		info->bytes_readonly);
>  	spin_unlock(&info->lock);
>  
> +	dump_block_rsv(fs_info, &fs_info->global_block_rsv);
> +	dump_block_rsv(fs_info, &fs_info->trans_block_rsv);
> +	dump_block_rsv(fs_info, &fs_info->chunk_block_rsv);
> +	dump_block_rsv(fs_info, &fs_info->delayed_block_rsv);
> +	dump_block_rsv(fs_info, &fs_info->delayed_refs_rsv);
> +
>  	if (!dump_block_groups)
>  		return;
>  
> -- 
> 2.14.3
> 
