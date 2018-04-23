Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:45024 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753895AbeDWCi0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Apr 2018 22:38:26 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 47DA3AC0121
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 11:38:20 +0900 (JST)
Subject: Re: [PATCH 4/7] btrfs: rename btrfs_flags_to_ioctl to reflect which
 flags it touches
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1524242295.git.dsterba@suse.com>
 <2f7110c081dcf9c2523de8ca5357ad7efeeba40d.1524242295.git.dsterba@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <3f774d5d-e756-9491-abbb-31415088644e@jp.fujitsu.com>
Date: Mon, 23 Apr 2018 11:37:08 +0900
MIME-Version: 1.0
In-Reply-To: <2f7110c081dcf9c2523de8ca5357ad7efeeba40d.1524242295.git.dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/04/21 2:02, David Sterba wrote:
> Converts btrfs_inode::flags to the FS_*_FL flags.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ioctl.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 953473f2a136..f0e6074233fa 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -105,9 +105,10 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
>  }
>  
>  /*
> - * Export inode flags to the format expected by the FS_IOC_GETFLAGS ioctl.
> + * Export internal inode flags to the format expected by the FS_IOC_GETFLAGS
> + * ioctl.
>   */
> -static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
> +static unsigned int btrfs_inode_flags_to_fsflags(unsigned int flags)
>  {
>  	unsigned int iflags = 0;
>  
> @@ -161,7 +162,7 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
>  static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
>  {
>  	struct btrfs_inode *ip = BTRFS_I(file_inode(file));

*ip here and in btrfs_ioctl_setflags() should be changed to *binode as in 1st patch?

> -	unsigned int flags = btrfs_flags_to_ioctl(ip->flags);
> +	unsigned int flags = btrfs_inode_flags_to_fsflags(ip->flags);
>  
>  	if (copy_to_user(arg, &flags, sizeof(flags)))
>  		return -EFAULT;
> @@ -221,7 +222,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  	mode = inode->i_mode;
>  
>  	flags = btrfs_mask_fsflags_for_type(inode, flags);
> -	oldflags = btrfs_flags_to_ioctl(ip->flags);
> +	oldflags = btrfs_inode_flags_to_fsflags(ip->flags);
>  	if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
>  		if (!capable(CAP_LINUX_IMMUTABLE)) {
>  			ret = -EPERM;
> 

