Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54502 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756185AbeARNyT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 08:54:19 -0500
Subject: Re: [PATCH 1/2] btrfs: fix device order consistency
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180118023212.14256-1-anand.jain@oracle.com>
 <20180118023212.14256-2-anand.jain@oracle.com>
 <391db1ec-484d-938e-5fa9-a06d52446d21@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <4ce14287-b849-6dee-b62a-bb127cb81448@oracle.com>
Date: Thu, 18 Jan 2018 21:55:18 +0800
MIME-Version: 1.0
In-Reply-To: <391db1ec-484d-938e-5fa9-a06d52446d21@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/18/2018 04:32 PM, Nikolay Borisov wrote:
> 
> 
> On 18.01.2018 04:32, Anand Jain wrote:
>> By maintaining the device order consistency it makes reproducing
>> the problem more consistent. So fix this by having the devices
> 
> Which problem is that ?

  I noticed when trying to reproduce raid1 missed writes issue
  (xfstests test case is coming up). This is good to have as
  such with any device related issue.

Thanks, Anand

>> sorted by some order within the kernel, lets say by devid.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index d393808071d5..68be58a5b03f 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -27,6 +27,7 @@
>>   #include <linux/raid/pq.h>
>>   #include <linux/semaphore.h>
>>   #include <linux/uuid.h>
>> +#include <linux/list_sort.h>
>>   #include <asm/div64.h>
>>   #include "ctree.h"
>>   #include "extent_map.h"
>> @@ -1108,6 +1109,20 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>>   	return ret;
>>   }
>>   
>> +static int device_sort(void *priv, struct list_head *a, struct list_head *b)
>> +{
>> +	struct btrfs_device *dev1, *dev2;
>> +
>> +	dev1 = list_entry(a, struct btrfs_device, dev_list);
>> +	dev2 = list_entry(b, struct btrfs_device, dev_list);
>> +
>> +	if (dev1->devid < dev2->devid)
>> +		return -1;
>> +	else if (dev1->devid > dev2->devid)
>> +		return 1;
>> +	return 0;
>> +}
>> +
>>   int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>>   		       fmode_t flags, void *holder)
>>   {
>> @@ -1118,6 +1133,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>>   		fs_devices->opened++;
>>   		ret = 0;
>>   	} else {
>> +		list_sort(NULL, &fs_devices->devices, device_sort);
>>   		ret = __btrfs_open_devices(fs_devices, flags, holder);
>>   	}
>>   	mutex_unlock(&uuid_mutex);
>>
