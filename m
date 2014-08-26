Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44861 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbaHZI16 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 04:27:58 -0400
Message-ID: <53FC4507.701@oracle.com>
Date: Tue, 26 Aug 2014 16:27:51 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] btrfs-progs: don't fall back to recursive /dev scan
References: <53F51F4D.2090203@redhat.com> <53F51FD8.4020800@redhat.com>
In-Reply-To: <53F51FD8.4020800@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 21/08/2014 06:23, Eric Sandeen wrote:
> If we didn't find what we are looking for in /proc/partitions,
> we're not going to find it by scanning every node under /dev, either.
>
> But that's just what btrfs_scan_for_fsid() does.
>
> Remove that fallback; at that point btrfs_scan_for_fsid() just calls
> scan_for_btrfs(), so remove the wrapper & call it directly.
>
> Side note: so, these paths always use /proc/partitions, not libblkid.
> Userspace-intiated scans default to libblkid.  I presume this is
> part of the design, and intentional?  Anyway, not changing it now!
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/disk-io.c b/disk-io.c
> index d10d647..077eb7e 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1018,7 +1018,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
>   	}
>
>   	if (total_devs != 1) {
> -		ret = btrfs_scan_for_fsid(run_ioctl);
> +		ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctl);
>   		if (ret)
>   			return ret;
>   	}
> diff --git a/utils.c b/utils.c
> index d61cbec..12ed7a2 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1151,7 +1151,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
>
>   	/* scan other devices */
>   	if (is_btrfs && total_devs > 1) {
> -		if ((ret = btrfs_scan_for_fsid(!BTRFS_UPDATE_KERNEL)))
> +		if ((ret = scan_for_btrfs(BTRFS_SCAN_PROC, !BTRFS_UPDATE_KERNEL)))
>   			return ret;
>   	}
>
> @@ -1339,16 +1339,6 @@ fail:
>   	return ret;
>   }
>
> -int btrfs_scan_for_fsid(int run_ioctls)
> -{
> -	int ret;
> -
> -	ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctls);
> -	if (ret)
> -		ret = scan_for_btrfs(BTRFS_SCAN_DEV, run_ioctls);
> -	return ret;
> -}
> -
>   int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>   				 int super_offset)
>   {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
