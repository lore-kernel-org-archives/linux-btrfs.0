Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46420 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab2JVQ7q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 12:59:46 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1167416bkc.19
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 09:59:45 -0700 (PDT)
Message-ID: <50857BA2.90403@gmail.com>
Date: Mon, 22 Oct 2012 19:00:18 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: don't check the permission of the subvolume
 which we want to delete
References: <50853040.1030404@cn.fujitsu.com>
In-Reply-To: <50853040.1030404@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-22 13:38, Miao Xie wrote:
> Step to reproduce:
>  # mkfs.btrfs <disk>
>  # mount -o user_subvol_rm_allowed <disk> <mnt>
>  # mkdir <mnt>/dir0
>  # chmod 777 <mnt>/dir0
>  # btrfs sub snap <mnt> <mnt>/dir0/snap0
>  # su -c "btrfs sub del <mnt>/dir0/snap0" -s /bin/bash nobody
>  ERROR: cannot delete '<mnt>/dir0/snap0' - Permission denied
> 
> This is because we checked the permission of the subvolume that we want to
> delete, and found the user - nobody have no WRITE permission of this subvolume.
> 
> I think we need not check the permission of the subvolume we want to delete,
> because we have the right to clean up the directory since we have WRITE and
> EXECUTE permission, just like rmdir command.

I think that removing a subvolume is a bit different than removing a
directory.
With "user_subvol_rm_allowed" allow an ordinary user to remove  things
that an plain "rm -rf" is not allowed.

For example if inside a directories tree there is a directory with
permission 700 (uid==root) an ordinary user is not able to remove this
directory.
Instead with the subvolumes (and the flag user_subvol_rm_allowed) an
ordinary user would be allowed to do it.
As mitigation it is required that user has WX permission on subvolume.
IIRC this is what we discussed at time.

See the thread "[PATCH] Btrfs: allow subvol deletion by unprivileged
user with -o user_subvol_rm_allowed"

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06525.html


> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index f5a2e6c..29fb07c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2062,10 +2062,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  		if (root == dest)
>  			goto out_dput;
>  
> -		err = inode_permission(inode, MAY_WRITE | MAY_EXEC);
> -		if (err)
> -			goto out_dput;
> -
>  		/* check if subvolume may be deleted by a non-root user */
>  		err = btrfs_may_delete(dir, dentry, 1);
>  		if (err)


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
