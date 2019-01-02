Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F36EC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 16:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0687C2080A
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 16:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbfABQAy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 11:00:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:33236 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729042AbfABQAx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 11:00:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26393AF53;
        Wed,  2 Jan 2019 16:00:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0D86EDA781; Wed,  2 Jan 2019 17:00:22 +0100 (CET)
Date:   Wed, 2 Jan 2019 17:00:22 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND v12] btrfs: introduce feature to forget a btrfs
 device
Message-ID: <20190102160022.GW23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1546408172-5193-1-git-send-email-anand.jain@oracle.com>
 <1546408172-5193-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546408172-5193-2-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 02, 2019 at 01:49:31PM +0800, Anand Jain wrote:
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
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
> v11->v12: fix coding style add spacing before after ":".
> v1->v11: Pls ref to the cover-letter. (sorry about that).
> 
>  fs/btrfs/super.c           | 3 +++
>  fs/btrfs/volumes.c         | 9 +++++++++
>  fs/btrfs/volumes.h         | 1 +
>  include/uapi/linux/btrfs.h | 2 ++
>  4 files changed, 15 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index d3c6bbc0aa3a..eba2966913ae 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2247,6 +2247,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
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
> index 8e36cbb355df..48415a9edd46 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1397,6 +1397,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  	return 0;
>  }
>  
> +int btrfs_forget_devices(const char *path)
> +{
> +	mutex_lock(&uuid_mutex);
> +	btrfs_free_stale_devices(strlen(path) ? path : NULL, NULL);
> +	mutex_unlock(&uuid_mutex);
> +
> +	return 0;

I think this should reflect the status of the operation. The ioctl
caller has no information about success/error. Eg. an invalid device
path passed could return -ENOENT, 0 if it was released and 1 if not.

In case of all devices, it's probably ok to return 0.
