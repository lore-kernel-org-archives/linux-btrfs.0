From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH][TAKE-1] fs/btrfs: Return EPERM for rmdir on subvolumes and snapshots
Date: Fri, 9 Apr 2010 19:58:36 +0200
Message-ID: <201004091958.36715.kreijack@libero.it>
References: <1270766820-7345-1-git-send-email-harsha@gluster.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1270766820-7345-1-git-send-email-harsha@gluster.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Can I suggest to return -EINVAL instead of -EPERM ?
To me EPERM seems that the user don't have the right to perform an action. But 
the problem is that "rm" is not the right command to use in order to delete a 
subvolume.

As side note, what is the reason for which an user is able to create a 
subvolume, but not to destroy it ?

BR
Goffredo

On Friday 09 April 2010, Harshavardhana wrote:
> Break the conditional to return EPERM for subvolumes,snapshots and 
> ENOTEMPTY for normal directories with files.
> 
> Signed-off-by: Harshavardhana <harsha@gluster.com>
> ---
>  fs/btrfs/inode.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a85b90c..465c3de 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2591,9 +2591,11 @@ static int btrfs_rmdir(struct inode *dir, struct 
dentry *dentry)
>  	struct btrfs_trans_handle *trans;
>  	unsigned long nr = 0;
>  
> -	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
> -	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
> -		return -ENOTEMPTY;
> +	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE) 
> +                return -ENOTEMPTY;
> +
> +        if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
> +		return -EPERM;
>  
>  	ret = btrfs_reserve_metadata_space(root, 5);
>  	if (ret)
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
