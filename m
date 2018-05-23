Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50041 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751085AbeEWGHX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 02:07:23 -0400
Subject: Re: [PATCH 1/2] Btrfs: fix clone vs chattr NODATASUM race
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        Timofey Titovets <nefelim4ag@gmail.com>
References: <cover.1527026445.git.osandov@fb.com>
 <d8b7c9b717e879eff65bb01e4247696811e975f1.1527026445.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <eb0a1c1b-b521-c90f-4d07-3dcfb97e5af7@suse.com>
Date: Wed, 23 May 2018 09:07:18 +0300
MIME-Version: 1.0
In-Reply-To: <d8b7c9b717e879eff65bb01e4247696811e975f1.1527026445.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.05.2018 01:02, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> In btrfs_clone_files(), we must check the NODATASUM flag while the
> inodes are locked. Otherwise, it's possible that btrfs_ioctl_setflags()
> will change the flags after we check and we can end up with a party
> checksummed file.
> 
> Fixes: 0e7b824c4ef9 ("Btrfs: don't make a file partly checksummed through file clone")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
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
> 
