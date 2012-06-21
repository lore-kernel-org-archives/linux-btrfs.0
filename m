Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50608 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab2FUX6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 19:58:17 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id A3D863EE081
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 08:58:15 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 8A1D845DE51
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 08:58:15 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 7210B45DE50
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 08:58:15 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 659A71DB8037
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 08:58:15 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 1BF3EE18001
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 08:58:15 +0900 (JST)
Message-ID: <4FE3B4FE.2040202@jp.fujitsu.com>
Date: Fri, 22 Jun 2012 08:57:50 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] Btrfs: do not set subvolume flags in readonly mode
References: <1340279297-3964-1-git-send-email-liubo2009@cn.fujitsu.com> <1340279297-3964-4-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1340279297-3964-4-git-send-email-liubo2009@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2012/06/21 20:48), Liu Bo wrote:
> $ mkfs.btrfs /dev/sdb7
> $ btrfstune -S1 /dev/sdb7
> $ mount /dev/sdb7 /mnt/btrfs
> mount: block device /dev/sdb7 is write-protected, mounting read-only
> $ btrfs dev add /dev/sdb8 /mnt/btrfs/
> 
> Now we get a btrfs in which mnt flags has readonly but sb flags does
> not.  So for those ioctls that only check sb flags with MS_RDONLY, it
> is going to be a problem.
> Setting subvolume flags is such an ioctl, we should use mnt_want_write_file()
> to check RO flags.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>   fs/btrfs/ioctl.c |   27 ++++++++++++++++++---------
>   1 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index df4c04d..ae29737 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1519,29 +1519,35 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>   	u64 flags;
>   	int ret = 0;
>   
> -	if (root->fs_info->sb->s_flags & MS_RDONLY)
> -		return -EROFS;
> +	ret = mnt_want_write_file(file);
> +	if (ret)
> +		goto out;
>   
> +	ret = -EINVAL;
>   	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID)
> -		return -EINVAL;
> +		goto out_drop_write;
>   
> +	ret = -EFAULT;
>   	if (copy_from_user(&flags, arg, sizeof(flags)))
> -		return -EFAULT;
> +		goto out_drop_write;
>   
> +	ret = -EINVAL;
>   	if (flags & BTRFS_SUBVOL_CREATE_ASYNC)
> -		return -EINVAL;
> +		goto out_drop_write;
>   
> +	ret = -EOPNOTSUPP;
>   	if (flags & ~BTRFS_SUBVOL_RDONLY)
> -		return -EOPNOTSUPP;
> +		goto out_drop_write;
>   
> +	ret = -EACCES;
>   	if (!inode_owner_or_capable(inode))
> -		return -EACCES;
> +		goto out_drop_write;

I think that

	if (!inode_owner_or_capable(inode)) {
		ret = -EACCES;
		goto out_drop_write;
	}

is better than

	ret = -EACCES;
	if (!inode_owner_or_capable(inode))
		goto out_drop_write;

Thanks,
Tsutomu

>   
>   	down_write(&root->fs_info->subvol_sem);
>   
>   	/* nothing to do */
>   	if (!!(flags & BTRFS_SUBVOL_RDONLY) == btrfs_root_readonly(root))
> -		goto out;
> +		goto out_drop_sem;
>   
>   	root_flags = btrfs_root_flags(&root->root_item);
>   	if (flags & BTRFS_SUBVOL_RDONLY)
> @@ -1564,8 +1570,11 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
>   out_reset:
>   	if (ret)
>   		btrfs_set_root_flags(&root->root_item, root_flags);
> -out:
> +out_drop_sem:
>   	up_write(&root->fs_info->subvol_sem);
> +out_drop_write:
> +	mnt_drop_write_file(file);
> +out:
>   	return ret;
>   }
>   
> 

