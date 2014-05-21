Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45534 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaEUDf5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 23:35:57 -0400
Message-ID: <537C1FC4.8030701@oracle.com>
Date: Wed, 21 May 2014 11:38:44 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] btrfs-progs: Follow kernel changes to add new
 member of btrfs_ioctl_dev_info_args.
References: <1399358005-9780-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1399358005-9780-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Qu,

in-line below..

On 06/05/14 14:33, Qu Wenruo wrote:
> Follow the kernel header changes to add new member of
> btrfs_ioctl_dev_info_args.
>
> This change will use special bit to keep backward compatibility, so even
> on old kernels this will not screw anything up.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   ioctl.h | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/ioctl.h b/ioctl.h
> index 9627e8d..672a3a3 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -156,12 +156,15 @@ struct btrfs_ioctl_dev_replace_args {
>   	__u64 spare[64];
>   };
>
> +#define BTRFS_IOCTL_DEV_INFO_MISSING			(1ULL<<0)
> +#define BTRFS_IOCTL_DEV_INFO_FLAG_SET			(1ULL<<63)
>   struct btrfs_ioctl_dev_info_args {
>   	__u64 devid;				/* in/out */
>   	__u8 uuid[BTRFS_UUID_SIZE];		/* in/out */
>   	__u64 bytes_used;			/* out */
>   	__u64 total_bytes;			/* out */
> -	__u64 unused[379];			/* pad to 4k */
> +	__u64 flags;				/* out */
> +	__u64 unused[378];			/* pad to 4k */


  In the long term perspective we would need to revamp the way to
  obtain btrfs_fs_device and btrfs_devices from the kernel.

  one way was proposed ioctl BTRFS_IOC_GET_DEVS [1], which
  used btrfs-control interface (not the mount point) to
  obtain everything of the above two kernel structs.

  the other method discussed was using the sysfs interface.

  So these plans would duplicate any efforts trying to enhance
  current BTRFS_IOC_DEV_INFO ioctl.

[1]
  http://www.spinics.net/lists/linux-btrfs/msg34161.html


>   	__u8 path[BTRFS_DEVICE_PATH_NAME_MAX];	/* out */
>   };
>
>
