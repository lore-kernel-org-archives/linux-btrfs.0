Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:36894 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab2IJTxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 15:53:19 -0400
Date: Mon, 10 Sep 2012 15:18:03 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>, "dave@jikos.cz" <dave@jikos.cz>
Subject: Re: [PATCH v2 1/6] Btrfs: fix a bug of per-file nocow
Message-ID: <20120910191803.GG2270@localhost.localdomain>
References: <1347069690-30223-1-git-send-email-bo.li.liu@oracle.com>
 <1347069690-30223-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1347069690-30223-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2012 at 08:01:25PM -0600, Liu Bo wrote:
> Users report a bug, the reproducer is:
> $ mkfs.btrfs /dev/loop0
> $ mount /dev/loop0 /mnt/btrfs/
> $ mkdir /mnt/btrfs/dir
> $ chattr +C /mnt/btrfs/dir/
> $ dd if=/dev/zero of=/mnt/btrfs/dir/foo bs=4K count=10;
> $ lsattr /mnt/btrfs/dir/foo
> ---------------C- /mnt/btrfs/dir/foo
> $ filefrag /mnt/btrfs/dir/foo
> /mnt/btrfs/dir/foo: 1 extent found    ---> an extent
> $ dd if=/dev/zero of=/mnt/btrfs/dir/foo bs=4K count=1 seek=5 conv=notrunc,nocreat; sync
> $ filefrag /mnt/btrfs/dir/foo
> /mnt/btrfs/dir/foo: 3 extents found   ---> with nocow, btrfs breaks the extent into three parts
> 
> The new created file should not only inherit the NODATACOW flag, but also
> honor NODATASUM flag, because we must do COW on a file extent with checksum.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v1->v2: add check for only regular file
> 
>  fs/btrfs/inode.c |    3 +--
>  fs/btrfs/ioctl.c |    7 +++++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b2c3514..9bce6e9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4720,8 +4720,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  	if (S_ISREG(mode)) {
>  		if (btrfs_test_opt(root, NODATASUM))
>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
> -		if (btrfs_test_opt(root, NODATACOW) ||
> -		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW))
> +		if (btrfs_test_opt(root, NODATACOW))
>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
>  	}
>  
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 00ddf22..2fd5455 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -140,8 +140,11 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
>  		BTRFS_I(inode)->flags |= BTRFS_INODE_COMPRESS;
>  	}
>  
> -	if (flags & BTRFS_INODE_NODATACOW)
> -		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
> +	if (flags & BTRFS_INODE_NODATACOW) {
> +		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
> +		if (S_ISREG(inode->i_mode))
> +			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
> +	}
>  

This doesn't compile.  Thanks,

Josef
