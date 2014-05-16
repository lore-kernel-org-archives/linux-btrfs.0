Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:34847 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbaEPOki (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 10:40:38 -0400
Received: by mail-qc0-f178.google.com with SMTP id l6so4392499qcy.37
        for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 07:40:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400249160-23186-1-git-send-email-anand.jain@oracle.com>
References: <1400249160-23186-1-git-send-email-anand.jain@oracle.com>
Date: Fri, 16 May 2014 22:40:38 +0800
Message-ID: <CAP9B-Q=rxYAtoyKp899+8w+8u-OighEm2KRjuvKPyn3uXWWuwA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO
 miss-matched with slots
From: Shilong Wang <wangshilong1991@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-05-16 22:06 GMT+08:00 Anand Jain <anand.jain@oracle.com>:
> BTRFS_IOC_FS_INFO return num_devices which does not include seed disks,
> BTRFS_IOC_DEV_INFO fetches seed disk when probed. So in this case hits
> the btrfs-progs bug:
>             get_fs_info()
>             ::
>                     BUG_ON(ndevs >= fi_args->num_devices);
> which is very easy to hit by using btrfs filesystem show.
>
> This patch will make BTRFS_IOC_DEV_INFO ioctl to provide disks only
> of the FSID being probed (seed disks are under different FSID).
>
> which means when seed is still not deleted from the sprout the btrfs
> filesystem show command will show disks them under their
> respective FSIDs

Just a quick comment:

Newly created filesystem is based on existed seeding filesystem.
Though they have different fsid, newly created filesystem devices
should include seed devices, from seed device filesytem, they can not
see newly created filesystem devices! No?

Will the follow patch change the above behavior?

Thanks,
Wang
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/ioctl.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ff27c08..902d279 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2584,7 +2584,8 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
>                 s_uuid = di_args->uuid;
>
>         mutex_lock(&fs_devices->device_list_mutex);
> -       dev = btrfs_find_device(root->fs_info, di_args->devid, s_uuid, NULL);
> +       dev = btrfs_find_device(root->fs_info, di_args->devid, s_uuid,
> +                               fs_devices->fsid);
>
>         if (!dev) {
>                 ret = -ENODEV;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
