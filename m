Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933920AbeEWSYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 14:24:47 -0400
Date: Wed, 23 May 2018 20:22:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: fix clone vs chattr NODATASUM race
Message-ID: <20180523182203.GD6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1527026445.git.osandov@fb.com>
 <d8b7c9b717e879eff65bb01e4247696811e975f1.1527026445.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d8b7c9b717e879eff65bb01e4247696811e975f1.1527026445.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 03:02:12PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> In btrfs_clone_files(), we must check the NODATASUM flag while the
> inodes are locked. Otherwise, it's possible that btrfs_ioctl_setflags()
> will change the flags after we check and we can end up with a party
> checksummed file.

The race window is only a few instructions in size, between the if and
the locks which is:

3834         if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
3835                 return -EISDIR;

where the setflags must be run and toggle the nodatacow flag (provided
the file size is 0).  The clone will block on the inode lock, segflags
takes the inode lock, changes flags, releases log and clone continues.

Not impossible but still needs a lot of bad luck to hit unintentionally.

Reviewed-by: David Sterba <dsterba@suse.com>

> Fixes: 0e7b824c4ef9 ("Btrfs: don't make a file partly checksummed through file clone")
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/ioctl.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index cf0d3bc6f625..784e267aad32 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4280,11 +4280,6 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>  	    src->i_sb != inode->i_sb)
>  		return -EXDEV;
>  
> -	/* don't make the dst file partly checksummed */
> -	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
> -	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
> -		return -EINVAL;
> -
>  	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
>  		return -EISDIR;
>  
> @@ -4294,6 +4289,13 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>  		inode_lock(src);
>  	}
>  
> +	/* don't make the dst file partly checksummed */
> +	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
> +	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
>  	/* determine range to clone */
>  	ret = -EINVAL;
>  	if (off + len > src->i_size || off + len < off)
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
