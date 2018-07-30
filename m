Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38716 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726395AbeG3Jr3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 05:47:29 -0400
Subject: Re: [PATCH 08/16] btrfs: btrfs_iget() never returns an is_bad_inode()
 inode.
To: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180729220317.GB30522@ZenIV.linux.org.uk>
 <20180729220453.13431-1-viro@ZenIV.linux.org.uk>
 <20180729220453.13431-8-viro@ZenIV.linux.org.uk>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <16170408-4e51-d603-5080-76d60c447092@suse.com>
Date: Mon, 30 Jul 2018 11:13:36 +0300
MIME-Version: 1.0
In-Reply-To: <20180729220453.13431-8-viro@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


[ADDED David Sterba and Linux-btrf ml]
On 30.07.2018 01:04, Al Viro wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
> 
> just get rid of pointless checks
> 
> Cc: Chris Mason <clm@fb.com>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

It seems even if we return is_bad_inode from btrfs_read_locked_inode we
always override it in the else branch in btrfs_iget. So :

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/free-space-cache.c | 4 ----
>  fs/btrfs/relocation.c       | 7 ++-----
>  fs/btrfs/tree-log.c         | 6 +-----
>  3 files changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index d5f80cb300be..79f03b3bbbd4 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -71,10 +71,6 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
>  	inode = btrfs_iget(fs_info->sb, &location, root, NULL);
>  	if (IS_ERR(inode))
>  		return inode;
> -	if (is_bad_inode(inode)) {
> -		iput(inode);
> -		return ERR_PTR(-ENOENT);
> -	}
>  
>  	mapping_set_gfp_mask(inode->i_mapping,
>  			mapping_gfp_constraint(inode->i_mapping,
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 879b76fa881a..f6e8dc134e44 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3563,11 +3563,8 @@ static int delete_block_group_cache(struct btrfs_fs_info *fs_info,
>  	key.offset = 0;
>  
>  	inode = btrfs_iget(fs_info->sb, &key, root, NULL);
> -	if (IS_ERR(inode) || is_bad_inode(inode)) {
> -		if (!IS_ERR(inode))
> -			iput(inode);
> +	if (IS_ERR(inode))
>  		return -ENOENT;
> -	}
>  
>  truncate:
>  	ret = btrfs_check_trunc_cache_free_space(fs_info,
> @@ -4284,7 +4281,7 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
>  	key.type = BTRFS_INODE_ITEM_KEY;
>  	key.offset = 0;
>  	inode = btrfs_iget(fs_info->sb, &key, root, NULL);
> -	BUG_ON(IS_ERR(inode) || is_bad_inode(inode));
> +	BUG_ON(IS_ERR(inode));
>  	BTRFS_I(inode)->index_cnt = group->key.objectid;
>  
>  	err = btrfs_orphan_add(trans, BTRFS_I(inode));
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index f8220ec02036..fcfbe1d8584a 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -545,12 +545,8 @@ static noinline struct inode *read_one_inode(struct btrfs_root *root,
>  	key.type = BTRFS_INODE_ITEM_KEY;
>  	key.offset = 0;
>  	inode = btrfs_iget(root->fs_info->sb, &key, root, NULL);
> -	if (IS_ERR(inode)) {
> +	if (IS_ERR(inode))
>  		inode = NULL;
> -	} else if (is_bad_inode(inode)) {
> -		iput(inode);
> -		inode = NULL;
> -	}
>  	return inode;
>  }
>  
> 
