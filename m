Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:44485 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbcDNQ4z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 12:56:55 -0400
Date: Thu, 14 Apr 2016 19:56:45 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v5 11/13] btrfs: introduce device dynamic state
 transition to offline or failed
Message-ID: <20160414165644.GA28722@jeknote.loshitsa1.net>
References: <1460470563-752-12-git-send-email-anand.jain@oracle.com>
 <1460631118-7847-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460631118-7847-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 14, 2016 at 06:51:58PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> This patch provides helper functions to force a device to offline
> or failed, and we need this device states for the following reasons,
> 1) a. it can be reported that device has failed when it does
>    b. close the device when it goes offline so that blocklayer can
>       cleanup
> 2) identify the candidate for the auto replace
> 3) avoid further commit error reported against the failing device and
> 4) a device in the multi device btrfs may go offline from the system
>    (but as of now in in some system config btrfs gets unmounted in this
>     context, which is not a correct behavior)
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> ---
> v5:
>   Originally we had a bug as fixed in the patch
>    [PATCH] btrfs: s_bdev is not null after missing replace
>   Incorporate those changes at force close a failed device.
>   To test pls have both this patch and above patch which
>   fixes the original issue, not introduced as part of this
>   patch set.

...

> +void device_force_close(struct btrfs_device *device)
> +{
> +	struct btrfs_device *next_device;
> +	struct btrfs_fs_devices *fs_devices;
> +
> +	fs_devices = device->fs_devices;
> +
> +	mutex_lock(&fs_devices->device_list_mutex);
> +	mutex_lock(&fs_devices->fs_info->chunk_mutex);
> +	spin_lock(&fs_devices->fs_info->free_chunk_lock);
> +
> +	next_device = list_entry(fs_devices->devices.next,
> +					struct btrfs_device, dev_list);
> +	if (fs_devices->fs_info->sb->s_bdev &&
> +		(fs_devices->fs_info->sb->s_bdev == device->bdev))
> +		fs_devices->fs_info->sb->s_bdev = next_device->bdev;
> +
> +	if (device->bdev == fs_devices->latest_bdev)
> +		fs_devices->latest_bdev = next_device->bdev;

latest_bdev can point to invalid bdev here if next_device is the same as
closing device.


-- 
Yauhen Kharuzhy
