Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52587 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750770AbaIIEEU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Sep 2014 00:04:20 -0400
Message-ID: <540E7CAA.6050001@cn.fujitsu.com>
Date: Tue, 9 Sep 2014 12:06:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: scan all the devices and build the fs device
 list by btrfs's self
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com> <1409751393-5403-6-git-send-email-miaox@cn.fujitsu.com> <540AF479.5050909@inwind.it>
In-Reply-To: <540AF479.5050909@inwind.it>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 6 Sep 2014 13:48:09 +0200, Goffredo Baroncelli wrote:
> On 09/03/2014 03:36 PM, Miao Xie wrote:
>> The original code need scan the devices and build the fs device list by the user
>> tool by udev or users' selves. It is flexible. But if someone re-install the
>> filesystem module, and forget to scan the devices by himself, or we plug some
>> devices with btrfs, but udev thread is blocked and doesn't register the disk
>> into btrfs in time, the filesystem would report that "can not open some device"
>> when mounting the filesystem, it was uncomfortable, this patch fixes this problem
>> by scanning all the devices if we find the number of devices is not right when
>> we mount the filesystem.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> [....]
>> +
>> +void btrfs_scan_all_devices(void *holder)
>> +{
>> +	struct class_dev_iter iter;
>> +	struct device *dev;
>> +	struct gendisk *disk;
>> +
>> +	mutex_lock(&uuid_mutex);
>> +	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
>> +	while ((dev = class_dev_iter_next(&iter))) {
>> +		disk = dev_to_disk(dev);
>> +
>> +		if (!get_capacity(disk) ||
>> +		    (!disk_max_parts(disk) &&
>> +		     (disk->flags & GENHD_FL_REMOVABLE)))
>                                     ^^^^^^^^^^^^^^^^^^
>> +			continue;
>> +
>> +		if (disk->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
>> +			continue;
> 
> 
> Hi, could you elaborate why a removable disk should be not scan-ned ? How
> a removble usb disk is classified ?

This is used to filter the non-partitionable removeable device such as cdrom,
if it is a usb disk, it should be partitionable.

Thanks
Miao
