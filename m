Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752277AbdGYPrl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 11:47:41 -0400
Date: Tue, 25 Jul 2017 17:46:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: Deprecate userspace transaction ioctls
Message-ID: <20170725154623.GB2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <1500988378-16318-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500988378-16318-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 25, 2017 at 04:12:58PM +0300, Nikolay Borisov wrote:
> Userspace transactions were introduced in commit
> 6bf13c0cc833 ("Btrfs: transaction ioctls") to provide semantics that Ceph's
> object store required. However, things have changed significantly since then,
> to the point where btrfs is no longer suitable as a backend for ceph and in fact
> it's actively advised against such usages. Considering this, there doesn't
> seem to be a widespread, legit use case of userspace transaction. They also
> clutter the file->private pointer.
> 
> So to end the agony let's nuke the userspace transaction ioctls. As a first
> step let's give time for people to voice their objection by just WARN()ining
> when the userspace transaction are used.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ioctl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index fa1b78cf25f6..5ddbacf67e95 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4000,6 +4000,8 @@ static long btrfs_ioctl_trans_start(struct file *file)
>  	struct btrfs_trans_handle *trans;
>  	int ret;
>  
> +	WARN_ON_ONCE(1);
> +
>  	ret = -EPERM;
>  	if (!capable(CAP_SYS_ADMIN))
>  		goto out;
> @@ -4280,6 +4282,8 @@ long btrfs_ioctl_trans_end(struct file *file)
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_trans_handle *trans;
>  
> +	WARN_ON_ONCE(1);

I don't think we need to warn twice, the ioctls must pair. Also, add
some printk about deprecation.

> +
>  	trans = file->private_data;
>  	if (!trans)
>  		return -EINVAL;
> -- 
> 2.7.4
> 
