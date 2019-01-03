Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFB0C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 15:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B253B2070D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 15:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbfACPY5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 10:24:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:36284 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728208AbfACPY5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 10:24:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17264AD05;
        Thu,  3 Jan 2019 15:24:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 31806DA781; Thu,  3 Jan 2019 16:24:26 +0100 (CET)
Date:   Thu, 3 Jan 2019 16:24:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v13] btrfs: introduce feature to forget a btrfs device
Message-ID: <20190103152426.GI23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1546502498-28070-1-git-send-email-anand.jain@oracle.com>
 <1546502498-28070-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546502498-28070-2-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 04:01:37PM +0800, Anand Jain wrote:
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
> v12->v13:  
>   btrfs.ko returns error on failing to find the given device.
>   For no argument (btrfs device scan --forget) if there is
>   no device to forget then it shall just return success.
> v11->v12: fix coding style add spacing before after ":".
> v1->v11: Pls ref to the cover-letter. (sorry about that).
> 
>  fs/btrfs/super.c           |  3 +++
>  fs/btrfs/volumes.c         | 55 +++++++++++++++++++++++++++++++++++-----------
>  fs/btrfs/volumes.h         |  1 +
>  include/uapi/linux/btrfs.h |  2 ++
>  4 files changed, 48 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 33cc9aba9c94..a4e8beec0fc5 100644
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
> index 2576b1a379c9..2ab42bfe5d3c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -734,6 +734,19 @@ static void pending_bios_fn(struct btrfs_work *work)
>  	run_scheduled_bios(device);
>  }
>  
> +static bool device_path_matched(const char *path, struct btrfs_device *device)
> +{
> +	int found;
> +
> +	rcu_read_lock();
> +	found = strcmp(rcu_str_deref(device->name), path);
> +	rcu_read_unlock();
> +
> +	if (!found)
> +		return true;
> +	return false;
> +}
> +
>  /*
>   *  Search and remove all stale (devices which are not mounted) devices.
>   *  When both inputs are NULL, it will search and release all stale devices.
> @@ -742,44 +755,47 @@ static void pending_bios_fn(struct btrfs_work *work)
>   *  skip_dev:	Optional. Will skip this device when searching for the stale
>   *		devices.
>   */
> -static void btrfs_free_stale_devices(const char *path,
> +static int btrfs_free_stale_devices(const char *path,
>  				     struct btrfs_device *skip_device)
>  {
>  	struct btrfs_fs_devices *fs_devices, *tmp_fs_devices;
>  	struct btrfs_device *device, *tmp_device;
> +	int ret;
> +
> +	if (path)
> +		ret = -ENXIO;
> +	else
> +		ret = 0;

Can you please split this change to another patch? It's a preparatory
work for the new ioctl. The return value meaning should be also
documented in the function comment.
