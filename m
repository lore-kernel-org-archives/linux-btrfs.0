Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23276 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754666AbcIIXGk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 19:06:40 -0400
Subject: Re: [PATCH] btrfs: fix a possible umount deadlock
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com,
        idryomov@gmail.com
References: <20160909083104.10383-1-anand.jain@oracle.com>
 <20160909125313.GS16983@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c10cc06b-1a4c-4000-12f4-5d19ba9f2754@oracle.com>
Date: Sat, 10 Sep 2016 07:08:22 +0800
MIME-Version: 1.0
In-Reply-To: <20160909125313.GS16983@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/09/2016 08:53 PM, David Sterba wrote:
> On Fri, Sep 09, 2016 at 04:31:04PM +0800, Anand Jain wrote:
>>  static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>>  {
>>  	struct btrfs_device *device, *tmp;
>> +	static LIST_HEAD(pending_put);
>
> Why is it static?

  sorry my mistake its typo. v2 is sent out.

Thanks, Anand


>> +	INIT_LIST_HEAD(&pending_put);
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
>> +					struct btrfs_device, dev_list);
>> +		list_del(&device->dev_list);
>> +		btrfs_close_bdev(device);
>> +		call_rcu(&device->rcu, free_device);
>> +	}
>> +
>>  	WARN_ON(fs_devices->open_devices);
>>  	WARN_ON(fs_devices->rw_devices);
>>  	fs_devices->opened = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
