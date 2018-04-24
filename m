Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51349 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934058AbeDXN2n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 09:28:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4DA8EAC65
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 13:28:42 +0000 (UTC)
Date: Tue, 24 Apr 2018 15:26:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] btrfs: Remove delay_iput parameter from
 __start_delalloc_inodes
Message-ID: <20180424132609.GG21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524470057-21969-1-git-send-email-nborisov@suse.com>
 <1524470057-21969-4-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524470057-21969-4-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 23, 2018 at 10:54:15AM +0300, Nikolay Borisov wrote:
> It's always set to 0 so remove it
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/inode.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 855237737acb..42a2590559df 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -10189,8 +10189,7 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
>   * some fairly slow code that needs optimization. This walks the list
>   * of all the inodes with pending delalloc and forces them to disk.
>   */
> -static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
> -				   int nr)
> +static int __start_delalloc_inodes(struct btrfs_root *root, int nr)

As the prototype and all callsites are changed, renaming the function
(dropping __ in this case) is an accepted change. Better than having
that as separate patch that just pollutes the git history.

>  {
>  	struct btrfs_inode *binode;
>  	struct inode *inode;
> @@ -10218,12 +10217,9 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
>  		}
>  		spin_unlock(&root->delalloc_lock);
>  
> -		work = btrfs_alloc_delalloc_work(inode, delay_iput);
> +		work = btrfs_alloc_delalloc_work(inode, 0);
>  		if (!work) {
> -			if (delay_iput)
> -				btrfs_add_delayed_iput(inode);
> -			else
> -				iput(inode);
> +			iput(inode);
>  			ret = -ENOMEM;
>  			goto out;
>  		}
> @@ -10262,7 +10258,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root)
>  	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
>  		return -EROFS;
>  
> -	ret = __start_delalloc_inodes(root, 0, -1);
> +	ret = __start_delalloc_inodes(root, -1);
>  	if (ret > 0)
>  		ret = 0;
>  	return ret;
> @@ -10291,7 +10287,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int nr)
>  			       &fs_info->delalloc_roots);
>  		spin_unlock(&fs_info->delalloc_root_lock);
>  
> -		ret = __start_delalloc_inodes(root, 0, nr);
> +		ret = __start_delalloc_inodes(root, nr);
>  		btrfs_put_fs_root(root);
>  		if (ret < 0)
>  			goto out;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
