Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:48779 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758451Ab2IFQ0X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 12:26:23 -0400
Date: Thu, 6 Sep 2012 18:26:17 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] Btrfs: fix a bug of per-file nocow
Message-ID: <20120906162617.GQ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
 <1346391419-4278-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1346391419-4278-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2012 at 01:36:54PM +0800, Liu Bo wrote:
> The new created file should not only inherit the NODATACOW flag, but also
> honor NODATASUM flag, because we must do COW on a file extent with checksum.

I was not entierly correct when suggesting to move NODATASUM to
inherit_iflags. Se below.

> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/inode.c |    3 +--
>  fs/btrfs/ioctl.c |    3 ++-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b2c3514..9bce6e9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4720,8 +4720,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  	if (S_ISREG(mode)) {

Originaly it applied to regular files only.

>  		if (btrfs_test_opt(root, NODATASUM))
>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
> -		if (btrfs_test_opt(root, NODATACOW) ||
> -		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW))
> +		if (btrfs_test_opt(root, NODATACOW))
>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
>  	}
>  
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 00ddf22..7390b25 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -141,7 +141,8 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
>  	}
>  
>  	if (flags & BTRFS_INODE_NODATACOW)
> -		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
> +		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
> +					 BTRFS_INODE_NODATASUM;

But now this will happen to:

* nodes (mknod)
* directories -- NODATASUM for a dir does nothing, but does not feel
  right
* symlinks -- same
* subvolume roots -- same, and even more confusing what it does

While the fix you suggested in

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg18292.html

is simple, I'm still inclined to keep all flag inheritance at one place,
so the fix I'm proposing is to do

>  	if (flags & BTRFS_INODE_NODATACOW)
>  		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;

		if (S_ISREG(inode->i_mode))
			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
	}

>  
>  	btrfs_update_iflags(inode);
>  }
