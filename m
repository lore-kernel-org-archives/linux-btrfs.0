Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:38481 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3KFJmh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 04:42:37 -0500
Message-ID: <527A0F0B.7020009@giantdisaster.de>
Date: Wed, 06 Nov 2013 10:42:35 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs: change ioctl number of BTRFS_IOC_START_SYNC
 to 21
References: <1383728479-29037-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1383728479-29037-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed,  6 Nov 2013 17:01:19 +0800, Liu Bo wrote:
> 24 has been assigned to both BTRFS_IOC_START_SYNC and BTRFS_IOC_SUBVOL_CREATE_V2,
> and BTRFS_IOC_SUBVOL_CREATE_V2 is at least used in btrfs-progs
> while BTRFS_IOC_START_SYNC is not.
> 
> 21 is free according to link[1], and seems safe to be assigned to BTRFS_IOC_START_SYNC.
> 
> [1]:
> https://btrfs.wiki.kernel.org/index.php/Project_ideas
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  include/uapi/linux/btrfs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 45e6189..0f5a1af 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -552,7 +552,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>  #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, __u64)
>  #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
>  				    struct btrfs_ioctl_space_args)
> -#define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 24, __u64)
> +#define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 21, __u64)
>  #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
>  #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
>  				   struct btrfs_ioctl_vol_args_v2)
> 

You don't _have to_ eliminate the duplicated use of the value 24, the
directions are different and the parameter sizes are different,
therefore these ioctls can be distinguished.

Sharing the ioctl value seems to have happened by mistake and is
uncommon, but IMHO now it's too late to change this interface just for
esthetical reasons.

