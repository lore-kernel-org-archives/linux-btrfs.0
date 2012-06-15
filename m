Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30561 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab2FOItX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 04:49:23 -0400
Message-ID: <4FDAF8D9.60201@cn.fujitsu.com>
Date: Fri, 15 Jun 2012 16:56:57 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: don't update atime on RO subvolumes
References: <1339746573-3573-1-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1339746573-3573-1-git-send-email-ablock84@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15/2012 03:49 PM, Alexander Block wrote:

> Before the update_time inode operation was indroduced, it was
> not possible to prevent updates of atime on RO subvolumes. VFS
> was only able to check for RO on the mount, but did not know
> anything about btrfs subvolumes.
> 
> btrfs_update_time does now check if the root is RO and skip
> updating of times.
> 
> Signed-off-by: Alexander Block <ablock84@googlemail.com>
> ---
>  fs/btrfs/inode.c |    5 +++++
>  fs/inode.c       |    2 ++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index f6ab6f5..4d0ceed 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4478,6 +4478,11 @@ int btrfs_dirty_inode(struct inode *inode)
>  static int btrfs_update_time(struct inode *inode, struct timespec *now,
>  			     int flags)
>  {
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +
> +	if (btrfs_root_readonly(root))
> +		return -EROFS;
> +


It also needs to acquire root->fs_info->subvol_sem, doesn't it?

thanks,
liubo

>  	if (flags & S_VERSION)
>  		inode_inc_iversion(inode);
>  	if (flags & S_CTIME)
> diff --git a/fs/inode.c b/fs/inode.c
> index c99163b..033529e 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1551,6 +1551,8 @@ void touch_atime(struct path *path)
>  	 * Btrfs), but since we touch atime while walking down the path we
>  	 * really don't care if we failed to update the atime of the file,
>  	 * so just ignore the return value.
> +	 * We may also fail on filesystems that have the ability to make parts
> +	 * of the fs read only, e.g. subvolumes in Btrfs.
>  	 */
>  	update_time(inode, &now, S_ATIME);
>  	mnt_drop_write(mnt);


