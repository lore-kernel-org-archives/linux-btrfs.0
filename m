Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07852C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 08:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2A112087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 08:48:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2A112087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbeJLQUD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 12:20:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:55002 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726071AbeJLQUC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 12:20:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 902FDACC2;
        Fri, 12 Oct 2018 08:48:37 +0000 (UTC)
Subject: Re: [PATCH] btrfs: introduce feature to forget a btrfs device
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1539317191-9265-1-git-send-email-anand.jain@oracle.com>
 <1539317191-9265-2-git-send-email-anand.jain@oracle.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <286b1a54-1cd4-2e70-781a-a6ea4255572d@suse.com>
Date:   Fri, 12 Oct 2018 11:48:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1539317191-9265-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12.10.2018 07:06, Anand Jain wrote:
> Support for a new command 'btrfs dev forget [dev]' is proposed here
> to undo the effects of 'btrfs dev scan [dev]'. For this purpose
> this patch proposes to use ioctl #5 as it was empty.
> 	IOW(BTRFS_IOCTL_MAGIC, 5, ..)
> This patch adds new ioctl BTRFS_IOC_FORGET_DEV which can be sent from
> the /dev/btrfs-control to forget one or all devices, (devices which are
> not mounted) from the btrfs kernel.
> 
> The argument it takes is struct btrfs_ioctl_vol_args, and ::name can be
> set to specify the device path. And all unmounted devices can be removed
> from the kernel if no device path is provided.
> 
> Again, the devices are removed only if the relevant fsid aren't mounted.
> 
> This new cli can provide..
>  . Release of unwanted btrfs_fs_devices and btrfs_devices memory if the
>    device is not going to be mounted.
>  . Ability to mount the device in degraded mode when one of the other
>    device is corrupted like in split brain raid1.
>  . Running test cases which requires btrfs.ko-reload if the rootfs
>    is btrfs.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/super.c           | 3 +++
>  fs/btrfs/volumes.c         | 9 +++++++++
>  fs/btrfs/volumes.h         | 1 +
>  include/uapi/linux/btrfs.h | 2 ++
>  4 files changed, 15 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 6601c9aa5e35..f14610ef1c66 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2244,6 +2244,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>  		ret = PTR_ERR_OR_ZERO(device);
>  		mutex_unlock(&uuid_mutex);
>  		break;
> +	case BTRFS_IOC_FORGET_DEV:
> +		ret = btrfs_forget_devices(vol->name);
> +		break;
>  	case BTRFS_IOC_DEVICES_READY:
>  		mutex_lock(&uuid_mutex);
>  		device = btrfs_scan_one_device(vol->name, FMODE_READ,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f4405e430da6..e2ab203d9c1d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1208,6 +1208,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  	return 0;
>  }
>  
> +int btrfs_forget_devices(const char *path)
> +{
> +	mutex_lock(&uuid_mutex);
> +	btrfs_free_stale_devices(strlen(path) ? path:NULL, NULL);

Checking the len of path is redundant since userspace will pass a zeroed
struct which will be NULL in any case. Additionally in
btrfs_free_stalce_devices there is existing check whether path is set or
not.

> +	mutex_unlock(&uuid_mutex);
> +
> +	return 0;
> +}
> +
>  /*
>   * Look for a btrfs signature on a device. This may be called out of the mount path
>   * and we are not allowed to call set_blocksize during the scan. The superblock
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 23e9285d88de..394079d5d08d 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -406,6 +406,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  		       fmode_t flags, void *holder);
>  struct btrfs_device *btrfs_scan_one_device(const char *path,
>  					   fmode_t flags, void *holder);
> +int btrfs_forget_devices(const char *path);
>  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>  void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
>  void btrfs_assign_next_active_device(struct btrfs_device *device,
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 5ca1d21fc4a7..b1be7f828cb4 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -836,6 +836,8 @@ enum btrfs_err_code {
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>  				   struct btrfs_ioctl_vol_args)
> +#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
> +				   struct btrfs_ioctl_vol_args)
>  /* trans start and trans end are dangerous, and only for
>   * use by applications that know how to avoid the
>   * resulting deadlocks
> 
