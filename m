Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57509 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdLEVaR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 16:30:17 -0500
Subject: Re: [PATCH v4 1/2] btrfs: add function to device list delete
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171205085258.4038-1-anand.jain@oracle.com>
 <20171205085258.4038-2-anand.jain@oracle.com>
 <20171205190616.GU3553@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <fd040d83-f7c7-4069-81e7-697d6e757db2@oracle.com>
Date: Wed, 6 Dec 2017 05:30:43 +0800
MIME-Version: 1.0
In-Reply-To: <20171205190616.GU3553@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/06/2017 03:06 AM, David Sterba wrote:
> On Tue, Dec 05, 2017 at 04:52:56PM +0800, Anand Jain wrote:
>> We need device delete from the dev_list so create a new function.
>> New instead of refactor of btrfs_free_stale_device() because,
>> btrfs_free_stale_device() doesn't hold device_list_mutex which
>> is actually needed here.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v1: title of this patch
>>    btrfs: refactor btrfs_free_stale_device() to get device list delete
>> v2:
>>   delete_device_from_list() is not pealed from btrfs_free_stale_device()
>>   as this needs device_list_mutex. And its static now.
>> v3: Send to correct ML
>> v4: no change
>>
>>   fs/btrfs/volumes.c | 22 ++++++++++++++++++++++
>>   1 file changed, 22 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 04164337ac69..5deda80316f0 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -531,6 +531,28 @@ static void pending_bios_fn(struct btrfs_work *work)
>>   	run_scheduled_bios(device);
>>   }
>>   
>> +static void delete_device_from_list(struct btrfs_device *device)
>> +{
>> +	struct btrfs_fs_devices *fs_devices;
>> +
>> +	fs_devices = device->fs_devices;
>> +
>> +	lockdep_assert_held(&uuid_mutex);
>> +
>> +	mutex_lock(&fs_devices->device_list_mutex);
>> +	fs_devices->num_devices--;
>> +	list_del(&device->dev_list);
>> +	mutex_unlock(&fs_devices->device_list_mutex);
>> +
>> +	rcu_string_free(device->name);
>> +	kfree(device);
> 
> Please use the new helper introduced in patch "btrfs: introduce
> free_device helper" (currently in misc-next), you'd leak the flush bio
> here.

   Ok. Will do.

Thanks, Anand

>> +
>> +	if (fs_devices->num_devices == 0) {
>> +		btrfs_sysfs_remove_fsid(fs_devices);
>> +		list_del(&fs_devices->list);
>> +		free_fs_devices(fs_devices);
>> +	}
>> +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
