Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47927 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752503AbcIVE6A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 00:58:00 -0400
Subject: Re: [PATCH v2] btrfs: fix a possible umount deadlock
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, idryomov@gmail.com
References: <20160909083104.10383-1-anand.jain@oracle.com>
 <20160909230338.1493-1-anand.jain@oracle.com>
 <20160921142614.GI16983@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2c48278e-48f0-77e8-a8e5-5cde87d373cb@oracle.com>
Date: Thu, 22 Sep 2016 12:59:51 +0800
MIME-Version: 1.0
In-Reply-To: <20160921142614.GI16983@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/21/2016 10:26 PM, David Sterba wrote:
> On Sat, Sep 10, 2016 at 07:03:38AM +0800, Anand Jain wrote:
>>  static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>>  {
>>  	struct btrfs_device *device, *tmp;
>> +	LIST_HEAD(pending_put);
>> +	INIT_LIST_HEAD(&pending_put);
>
> LIST_HEAD declares and initializes the list to an empty one, not
> necessary to call INIT_LIST_HEAD.

   Will use struct list_head makes it with inline with rest of the code.

>>
>>  	if (--fs_devices->opened > 0)
>>  		return 0;
>> @@ -906,9 +904,24 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>>  	mutex_lock(&fs_devices->device_list_mutex);
>>  	list_for_each_entry_safe(device, tmp, &fs_devices->devices, dev_list) {
>>  		btrfs_close_one_device(device);
>> +		list_add(&device->dev_list, &pending_put);
>>  	}
>>  	mutex_unlock(&fs_devices->device_list_mutex);
>>
>> +	/*
>> +	 * btrfs_show_devname() is using the device_list_mutex,
>> +	 * sometimes a call to blkdev_put() leads vfs calling
>> +	 * into this func. So do put outside of device_list_mutex,
>> +	 * as of now.
>> +	 */
>> +	while (!list_empty(&pending_put)) {
>> +		device = list_entry(pending_put.next,
>
> Could be list_first_entry
  ok.
>> +					struct btrfs_device, dev_list);
>> +		list_del(&device->dev_list);
>> +		btrfs_close_bdev(device);
>> +		call_rcu(&device->rcu, free_device);
>> +	}
>> +
>>  	WARN_ON(fs_devices->open_devices);
>>  	WARN_ON(fs_devices->rw_devices);
>>  	fs_devices->opened = 0;
>
> After this patch, the function btrfs_close_one_device no longer does
> what it says, ie. it does not close the device.

  renamed to btrfs_prepare_close_one_device()

> I'd have to look closer
> why it allocates a new structure and replaces it in the list, but this
> looks weird.

  I asked this in the ML quite sometime back. yeah reason is unknown.
  So this reason the sysfs patches (in the ML) is probably got x2
  complicated.

-Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
