Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:44479 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaIFLl5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Sep 2014 07:41:57 -0400
Message-ID: <540AF479.5050909@inwind.it>
Date: Sat, 06 Sep 2014 13:48:09 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] Btrfs: scan all the devices and build the fs device
 list by btrfs's self
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com> <1409751393-5403-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751393-5403-6-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/03/2014 03:36 PM, Miao Xie wrote:
> The original code need scan the devices and build the fs device list by the user
> tool by udev or users' selves. It is flexible. But if someone re-install the
> filesystem module, and forget to scan the devices by himself, or we plug some
> devices with btrfs, but udev thread is blocked and doesn't register the disk
> into btrfs in time, the filesystem would report that "can not open some device"
> when mounting the filesystem, it was uncomfortable, this patch fixes this problem
> by scanning all the devices if we find the number of devices is not right when
> we mount the filesystem.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
[....]
> +
> +void btrfs_scan_all_devices(void *holder)
> +{
> +	struct class_dev_iter iter;
> +	struct device *dev;
> +	struct gendisk *disk;
> +
> +	mutex_lock(&uuid_mutex);
> +	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
> +	while ((dev = class_dev_iter_next(&iter))) {
> +		disk = dev_to_disk(dev);
> +
> +		if (!get_capacity(disk) ||
> +		    (!disk_max_parts(disk) &&
> +		     (disk->flags & GENHD_FL_REMOVABLE)))
                                    ^^^^^^^^^^^^^^^^^^
> +			continue;
> +
> +		if (disk->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
> +			continue;


Hi, could you elaborate why a removable disk should be not scan-ned ? How
a removble usb disk is classified ?

Thanks.
G.Baroncelli

[...]


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
