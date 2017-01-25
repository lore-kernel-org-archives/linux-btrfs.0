Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:34779 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbdAYCjL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 21:39:11 -0500
Received: by mail-pg0-f47.google.com with SMTP id 14so59991348pgg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 18:39:11 -0800 (PST)
Date: Tue, 24 Jan 2017 18:38:44 -0800
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Murphy <lists@colorremedies.com>, kernel-team@fb.com,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] Btrfs: disable xattr operations on subvolume directories
Message-ID: <20170125023844.GA11245@vader>
References: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c96f9f4d14c7a40913a39856ca8f065d37113372.1485311744.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 06:38:02PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> When you snapshot a subvolume containing a subvolume, you get a
> placeholder read-only directory where the subvolume would be. These
> directory inodes have ->i_ops set to btrfs_dir_ro_inode_operations.
> Previously, this didn't include the xattr operation callbacks. The
> conversion to xattr_handlers missed this case, leading to bogus attempts
> to set xattrs on these inodes. This manifested itself as failures when
> running delayed inodes.
> 
> To fix this, clear the IOP_XATTR in ->i_opflags on these inodes.
> 
> Fixes: 6c6ef9f26e59 ("xattr: Stop calling {get,set,remove}xattr inode operations")
> Cc: Andreas Gruenbacher <agruenba@redhat.com>
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Applies to v4.10-rc4. Chris, this fixes the issue for me, could you please test
> it out? Andreas, does this make sense? I'll try to cook up an xfstest for this.
> 
>  fs/btrfs/inode.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4e024260ad71..3dacf0786428 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3835,10 +3835,12 @@ static int btrfs_read_locked_inode(struct inode *inode)
>  		break;
>  	case S_IFDIR:
>  		inode->i_fop = &btrfs_dir_file_operations;
> -		if (root == fs_info->tree_root)
> +		if (root == fs_info->tree_root) {
>  			inode->i_op = &btrfs_dir_ro_inode_operations;
> -		else
> +			inode->i_opflags &= ~IOP_XATTR;
> +		} else {
>  			inode->i_op = &btrfs_dir_inode_operations;
> +		}
>  		break;
>  	case S_IFLNK:
>  		inode->i_op = &btrfs_symlink_inode_operations;
> @@ -5710,6 +5712,7 @@ static struct inode *new_simple_dir(struct super_block *s,
>  
>  	inode->i_ino = BTRFS_EMPTY_SUBVOL_DIR_OBJECTID;
>  	inode->i_op = &btrfs_dir_ro_inode_operations;
> +	inode->i_opflags &= ~IOP_XATTR;
>  	inode->i_fop = &simple_dir_operations;
>  	inode->i_mode = S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO;
>  	inode->i_mtime = current_time(inode);
> -- 
> 2.11.0
> 

Forgot to cc stable, but 4.9 needs this.
