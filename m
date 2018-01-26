Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41009 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752090AbeAZKyk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 05:54:40 -0500
Subject: Re: [PATCH] Btrfs: delete dead code in btrfs_orphan_add()
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
References: <ddecfd9f65019017bba48685a86554cf21350ade.1516924547.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e8357487-934e-846d-9063-6185759dd745@suse.com>
Date: Fri, 26 Jan 2018 12:54:38 +0200
MIME-Version: 1.0
In-Reply-To: <ddecfd9f65019017bba48685a86554cf21350ade.1516924547.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.01.2018 01:56, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> btrfs_orphan_add() has had this case commented out since it was first
> introduced in commit d68fc57b7e32 ("Btrfs: Metadata reservation for
> orphan inodes"). Most of the orphan cleanup code has been rewritten
> since then, so it's safe to say that this code isn't needed.

I've tried removing this a couple of times but David objected due to
missing historical context and whether we might need it. I'm totally
fine with killing it.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/inode.c | 22 +---------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e1a7f3cb5be9..d4e3a09c0ea4 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3334,17 +3334,6 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
>  
>  	if (!test_and_set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
>  			      &inode->runtime_flags)) {
> -#if 0
> -		/*
> -		 * For proper ENOSPC handling, we should do orphan
> -		 * cleanup when mounting. But this introduces backward
> -		 * compatibility issue.
> -		 */
> -		if (!xchg(&root->orphan_item_inserted, 1))
> -			insert = 2;
> -		else
> -			insert = 1;
> -#endif
>  		insert = 1;
>  		atomic_inc(&root->orphan_inodes);
>  	}
> @@ -3370,7 +3359,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
>  	}
>  
>  	/* insert an orphan item to track this unlinked/truncated file */
> -	if (insert >= 1) {
> +	if (insert) {
>  		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
>  		if (ret) {
>  			atomic_dec(&root->orphan_inodes);
> @@ -3389,15 +3378,6 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
>  		ret = 0;
>  	}
>  
> -	/* insert an orphan item to track subvolume contains orphan files */
> -	if (insert >= 2) {
> -		ret = btrfs_insert_orphan_item(trans, fs_info->tree_root,
> -					       root->root_key.objectid);
> -		if (ret && ret != -EEXIST) {
> -			btrfs_abort_transaction(trans, ret);
> -			return ret;
> -		}
> -	}
>  	return 0;
>  }
>  
> 
