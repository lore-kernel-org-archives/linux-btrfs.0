Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751631AbeA3IS2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 03:18:28 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 93163ACDB
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jan 2018 08:18:27 +0000 (UTC)
Subject: Re: [PATCH 2/3] btrfs: Unexport get_block_group_index()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180130074039.24987-1-wqu@suse.com>
 <20180130074039.24987-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <995dc89a-2f5e-28c0-70e5-f7b18719c1a0@suse.com>
Date: Tue, 30 Jan 2018 10:18:26 +0200
MIME-Version: 1.0
In-Reply-To: <20180130074039.24987-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.01.2018 09:40, Qu Wenruo wrote:
> That function is only used inside extent-tree.c.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ctree.h       | 1 -
>  fs/btrfs/extent-tree.c | 3 ++-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 13c260b525a1..27249240fa3e 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2629,7 +2629,6 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
>  						 u64 bytenr);
>  void btrfs_get_block_group(struct btrfs_block_group_cache *cache);
>  void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
> -int get_block_group_index(struct btrfs_block_group_cache *cache);
>  struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
>  					     struct btrfs_root *root,
>  					     u64 parent, u64 root_objectid,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e9c31b567a9c..6e1128aa29d6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7346,7 +7346,8 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
>  	return ret;
>  }
>  
> -int get_block_group_index(struct btrfs_block_group_cache *cache)
> +static enum btrfs_raid_types
> +get_block_group_index(struct btrfs_block_group_cache *cache)
>  {
>  	return btrfs_bg_flags_to_raid_index(cache->flags);
>  }

I'd rather you removed this function and used bg_flags_to_raid_index
directly. Otherwise we have yet another level of indirection with a
rather wrong name - "block_group_index" ?

> 
