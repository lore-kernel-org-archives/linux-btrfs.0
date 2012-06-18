Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33836 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab2FRLuY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 07:50:24 -0400
Date: Mon, 18 Jun 2012 13:50:21 +0200
From: David Sterba <dave@jikos.cz>
To: Andrei Popa <andrei.popa@i-neo.ro>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Fix NOCOW file attribute
Message-ID: <20120618115021.GX32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339850232-25584-1-git-send-email-andrei.popa@i-neo.ro>
 <1339850232-25584-2-git-send-email-andrei.popa@i-neo.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339850232-25584-2-git-send-email-andrei.popa@i-neo.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 16, 2012 at 03:37:12PM +0300, Andrei Popa wrote:
> Adds BTRFS_INODE_NODATASUM to inode flags when setting NOCOW for a file (chattr +C file).
> In btrfs, NOCOW implies NODATASUM and without setting NODATASUM, btrfs doesn't honour correctly the NOCOW attribute.
> 
> Signed-off-by: Andrei Popa <andrei.popa@i-neo.ro>
> ---
>  fs/btrfs/ioctl.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0e92e57..8a7be76 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -139,7 +139,7 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
>  	}
>  
>  	if (flags & BTRFS_INODE_NODATACOW)
> -		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
> +		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW | BTRFS_INODE_NODATASUM;
>  
>  	btrfs_update_iflags(inode);
>  }
> @@ -236,7 +236,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  	else
>  		ip->flags &= ~BTRFS_INODE_DIRSYNC;
>  	if (flags & FS_NOCOW_FL)
> -		ip->flags |= BTRFS_INODE_NODATACOW;
> +		ip->flags |= BTRFS_INODE_NODATACOW | BTRFS_INODE_NODATASUM;
>  	else
>  		ip->flags &= ~BTRFS_INODE_NODATACOW;
>  

you cannot switch on NODATASUM for a file that already has extents that
are checksummed. The invariant here is that either all the extents or
none are checksummed.

Setting NODATASUM is safe only on a zero sized file, that's what you saw
in your test.

Theoretically it's possible to add/remove all checksums from a given
file, but it's a potentially longtime operation, the file has to be in
some intermediate state where the checksums partially exist but have to
be ignored (for the csum->nocsum) until the file is fully converted,
this brings more special cases to extent handling, it has to survive
power failure and remain consistent, and probably needs to be restarted
after next mount.


david
