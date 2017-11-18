Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26890 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163662AbdKRNup (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 08:50:45 -0500
Subject: Re: [PATCH 1/2] btrfs: refactor btrfs_free_stale_device() to get
 device list delete
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20171113054410.24872-1-anand.jain@oracle.com>
 <20171113054410.24872-2-anand.jain@oracle.com>
 <4a9afb0a-f6a5-d9b7-6846-f915d496d20c@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ec2c9e78-a9e1-aa7b-43d2-2d8c73489781@oracle.com>
Date: Sat, 18 Nov 2017 21:50:14 +0800
MIME-Version: 1.0
In-Reply-To: <4a9afb0a-f6a5-d9b7-6846-f915d496d20c@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/16/2017 09:59 PM, Nikolay Borisov wrote:
> 
> 
> On 13.11.2017 07:44, Anand Jain wrote:
>> We need to delete a device from the dev_list, so refactor
>> btrfs_free_stale_device() for delete_device_from_list().
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 27 +++++++++++++++++----------
>>   1 file changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 8bac1cf17048..8ead85dba6f5 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -546,6 +546,22 @@ static void pending_bios_fn(struct btrfs_work *work)
>>   	run_scheduled_bios(device);
>>   }
>>   
>> +void delete_device_from_list(struct btrfs_device *dev)
> 
> In this patch and the other one this function is used only in volume.c
> so make static.

  Right. Will do.

> Also if it relies on some particular lock being held why
> not add lockdep_assert_held(xxx) as a means of documenting that ?

  Actually, btrfs_free_stale_device() should be holding device_list_mutex
  but it didn't so I would like to fix it separately. So here I shall
  create a new function instead of peal from btrfs_free_stale_device(),
  which I think btrfs_free_stale_device() can use it later.

Thanks, Anand

>> +{
>> +	struct btrfs_fs_devices *fs_devs;
>> +	fs_devs = dev->fs_devices;
>> +
>> +	if (fs_devs->num_devices == 1) {
>> +		btrfs_sysfs_remove_fsid(fs_devs);
>> +		list_del(&fs_devs->list);
>> +		free_fs_devices(fs_devs);
>> +	} else {
>> +		fs_devs->num_devices--;
>> +		list_del(&dev->dev_list);
>> +		rcu_string_free(dev->name);
>> +		kfree(dev);
>> +	}
>> +}
>>   
>>   void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>>   {
>> @@ -586,16 +602,7 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>>   
>>   		if (!del) {
>>   			/* delete the stale device */
>> -			if (fs_devs->num_devices == 1) {
>> -				btrfs_sysfs_remove_fsid(fs_devs);
>> -				list_del(&fs_devs->list);
>> -				free_fs_devices(fs_devs);
>> -			} else {
>> -				fs_devs->num_devices--;
>> -				list_del(&dev->dev_list);
>> -				rcu_string_free(dev->name);
>> -				kfree(dev);
>> -			}
>> +			delete_device_from_list(dev);
>>   			break;
>>   		}
>>   	}
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
