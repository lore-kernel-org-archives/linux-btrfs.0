Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46234 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755856AbeAJNZP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 08:25:15 -0500
Subject: Re: [PATCH 3/4] btrfs: get device pointer from device_list_add()
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180110051624.3813-1-anand.jain@oracle.com>
 <20180110051624.3813-4-anand.jain@oracle.com>
 <a5fdc40b-43fe-d4d9-3154-fec9855d3a76@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <16faaf35-238e-fb6f-e33f-0c01f0011068@oracle.com>
Date: Wed, 10 Jan 2018 21:26:12 +0800
MIME-Version: 1.0
In-Reply-To: <a5fdc40b-43fe-d4d9-3154-fec9855d3a76@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> @@ -742,7 +741,7 @@ static noinline int device_list_add(const char *path,
>>   	if (!fs_devices) {
>>   		fs_devices = alloc_fs_devices(disk_super->fsid);
>>   		if (IS_ERR(fs_devices))
>> -			return PTR_ERR(fs_devices);
>> +			return ERR_PTR(PTR_ERR(fs_devices));
> 
> No need to do any conversion, alloc_fs_devices already returns ERR_PTR
> value so plain return fs_devices suffices.

   'return fs_devices;' will get compile time warn as the
   function return is of type btrfs_device *.

>>   
>>   		list_add(&fs_devices->list, &fs_uuids);
>>   
>> @@ -754,19 +753,19 @@ static noinline int device_list_add(const char *path,
>>   
>>   	if (!device) {
>>   		if (fs_devices->opened)
>> -			return -EBUSY;
>> +			return ERR_PTR(-EBUSY);
>>   
>>   		device = btrfs_alloc_device(NULL, &devid,
>>   					    disk_super->dev_item.uuid);
>>   		if (IS_ERR(device)) {
>>   			/* we can safely leave the fs_devices entry around */
>> -			return PTR_ERR(device);
>> +			return ERR_PTR(PTR_ERR(device));
> Ditto

  Here I will fix.

Thanks, Anand
