Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36542 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727057AbeG3Puh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 11:50:37 -0400
Subject: Re: [PATCH] btrfs: extent-tree.c: Remove unused
 __btrfs_free_block_rsv()
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1532572743.git.misono.tomohiro@jp.fujitsu.com>
 <01829a36-c358-e71a-4281-be8eeb8f8302@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7ce8f86e-d3f9-3c2c-e247-5b531d7014d7@suse.com>
Date: Mon, 30 Jul 2018 17:15:21 +0300
MIME-Version: 1.0
In-Reply-To: <01829a36-c358-e71a-4281-be8eeb8f8302@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.07.2018 05:40, Misono Tomohiro wrote:
> There is no user of this function.
> 
> This is forgotten to get removed in commit a575ceeb1338
> ("Btrfs: get rid of unused orphan infrastructure").
> 
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/ctree.h       | 1 -
>  fs/btrfs/extent-tree.c | 5 -----
>  2 files changed, 6 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 9c638931b75e..6506a3e8ccbd 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2764,7 +2764,6 @@ void btrfs_init_metadata_block_rsv(struct btrfs_fs_info *fs_info,
>  				   unsigned short type);
>  void btrfs_free_block_rsv(struct btrfs_fs_info *fs_info,
>  			  struct btrfs_block_rsv *rsv);
> -void __btrfs_free_block_rsv(struct btrfs_block_rsv *rsv);
>  int btrfs_block_rsv_add(struct btrfs_root *root,
>  			struct btrfs_block_rsv *block_rsv, u64 num_bytes,
>  			enum btrfs_reserve_flush_enum flush);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 16b916a33e56..240535eec2f4 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5529,11 +5529,6 @@ void btrfs_free_block_rsv(struct btrfs_fs_info *fs_info,
>  	kfree(rsv);
>  }
>  
> -void __btrfs_free_block_rsv(struct btrfs_block_rsv *rsv)
> -{
> -	kfree(rsv);
> -}
> -
>  int btrfs_block_rsv_add(struct btrfs_root *root,
>  			struct btrfs_block_rsv *block_rsv, u64 num_bytes,
>  			enum btrfs_reserve_flush_enum flush)
> 
