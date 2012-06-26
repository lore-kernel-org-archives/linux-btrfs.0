Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:52130 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab2FZM0W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 08:26:22 -0400
Date: Tue, 26 Jun 2012 14:26:18 +0200
From: David Sterba <dave@jikos.cz>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use _IOR for BTRFS_IOC_SUBVOL_GETFLAGS
Message-ID: <20120626122618.GQ28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1340660172-1531-1-git-send-email-ablock84@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340660172-1531-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2012 at 11:36:12PM +0200, Alexander Block wrote:
> We used the wrong ioctl macro for the getflags ioctl before.
> As we don't have the set/getflags ioctls in the user space ioctl.h
> at the moment, it's safe to fix it now.

The _IOW is clearly wrong here, the direction is 'from kernel', so _IOR.
I hope it's yet ok to change it, though it's a user visible change.

> 
> Signed-off-by: Alexander Block <ablock84@googlemail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

> ---
>  fs/btrfs/ioctl.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 497c530..e440aa6 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -339,7 +339,7 @@ struct btrfs_ioctl_get_dev_stats {
>  #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
>  #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
>  				   struct btrfs_ioctl_vol_args_v2)
> -#define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
> +#define BTRFS_IOC_SUBVOL_GETFLAGS _IOR(BTRFS_IOCTL_MAGIC, 25, __u64)
>  #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
>  #define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
>  			      struct btrfs_ioctl_scrub_args)
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
