Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24359 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2K3GSt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 01:18:49 -0500
Date: Fri, 30 Nov 2012 14:17:14 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Brandenburger <filbranden@google.com>
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix permissions of empty files not affected
 by umask
Message-ID: <20121130061714.GA2613@liubo.cn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1354246809-32339-1-git-send-email-filbranden@google.com>
 <1354246809-32339-2-git-send-email-filbranden@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1354246809-32339-2-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 29, 2012 at 07:40:08PM -0800, Filipe Brandenburger wrote:
> When a new file is created with btrfs_create(), the inode will initially be
> created with permissions 0666 and later on in btrfs_init_acl() it will be
> adapted to mask out the umask bits. The problem is that this change won't make
> it into the btrfs_inode unless there's another change to the inode (e.g. writing
> content changing the size or touching the file changing the mtime.)
> 
> This fix adds a call to btrfs_update_inode() to btrfs_create() to make sure that
> the change will not get lost if the in-memory inode is flushed before other
> changes are made to the file.
> 

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
liubo

> Signed-off-by: Filipe Brandenburger <filbranden@google.com>
> ---
>  fs/btrfs/inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 95542a1..caf9d76 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4996,6 +4996,12 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
>  		goto out_unlock;
>  	}
>  
> +	err = btrfs_update_inode(trans, root, inode);
> +	if (err) {
> +		drop_inode = 1;
> +		goto out_unlock;
> +	}
> +
>  	/*
>  	* If the active LSM wants to access the inode during
>  	* d_instantiate it needs these. Smack checks to see
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
