Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52972 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751963AbaFDFui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 01:50:38 -0400
Message-ID: <538EB3EB.2080309@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 13:51:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH RFC] btrfs: Add ctime/mtime update for btrfs device add/remove.
References: <1397638952-16691-1-git-send-email-quwenruo@cn.fujitsu.com> <20140529124308.GA29992@twin.jikos.cz>
In-Reply-To: <20140529124308.GA29992@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH RFC] btrfs: Add ctime/mtime update for btrfs device 
add/remove.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年05月29日 20:43
> On Wed, Apr 16, 2014 at 05:02:32PM +0800, Qu Wenruo wrote:
>> @@ -1704,10 +1720,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>>   
>>   	ret = 0;
>>   
>> -	/* Notify udev that device has changed */
>> -	if (bdev)
>> +	if (bdev) {
>> +		/* Notify udev that device has changed */
>>   		btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
>>   
>> +		/* Update ctime/mtime for device path for libblkid */
>> +		update_dev_time(device_path);
> The change on the device comes after the uevent notification, is it
> possible that the event is delivered and processed before the device
> times are updated? I would say so.
If I understand the udev thing right, uevent notification is sent to 
udevd and udevd process the notification.
For btrfs_rm_device(), it will send KOBJ_CHANGE uevent to udevd, and 
udevd will *update* the ctime/mtime in /dev.

But the problems is, there is a time lag between uevent sending and 
udevd updating the ctime/mtime,
which makes the ctime/mtime updating later than next 'btrfs dev scan' 
commands.
Since the ctime/mtime is not changed, libblkid used by 'btrfs dev scan' 
will still consider the removed disk as btrfs,
causing the bug I reported.

IMO the best method to deal the bug is to wait udevd processing the 
uevent, but unfortunately, we can't even guarantee
that there is a udevd processing the uevent(like some embedded system 
without udevd).

So I use update_dev_time() as a workaround, which provide a completely 
synchronize method to update device file ctime/mtime.
And even the uevent is processed before the update_dev_time(), it makes 
no harm except a new ctime/mtime.

Thanks,
Qu
>
>> +	}
>> +
>>   error_brelse:
>>   	brelse(bh);
>>   	if (bdev)

