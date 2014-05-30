Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46632 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932121AbaE3B0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 21:26:46 -0400
Message-ID: <5387DE92.3080103@cn.fujitsu.com>
Date: Fri, 30 May 2014 09:27:46 +0800
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
Yes, udev event is delivered before device times updated, but now 
btrfs-progs still use libblkid to do device scan things
as default, so I didn't catch the point.

Would you please tell me what the problem is?

Thanks,
Qu
>
>> +	}
>> +
>>   error_brelse:
>>   	brelse(bh);
>>   	if (bdev)

