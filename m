Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40612 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbeEVJJf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 05:09:35 -0400
Subject: Re: [PATCH 12/15] btrfs: drop uuid_mutex in close_fs_devices()
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180412022938.8257-1-anand.jain@oracle.com>
 <20180412022938.8257-13-anand.jain@oracle.com>
 <20180515163030.GU6649@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6a054501-d477-4780-63fe-8153160909eb@oracle.com>
Date: Tue, 22 May 2018 17:12:07 +0800
MIME-Version: 1.0
In-Reply-To: <20180515163030.GU6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/16/2018 12:30 AM, David Sterba wrote:
> On Thu, Apr 12, 2018 at 10:29:35AM +0800, Anand Jain wrote:
>> close_fs_devices() closes devices of a given fsid, and it is limited
>> to all the devices of a fsid, so we don't have to hold the global
>> uuid_mutex, instead we need the device_list_mutex as the device state is
>> being changed.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 9 ++++-----
>>   1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index dfebf8f29916..4c29214e0c18 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -995,7 +995,6 @@ static void btrfs_prepare_close_one_device(struct btrfs_device *device)
>>   					device->uuid);
>>   	BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
>>   
>> -	/* Safe because we are under uuid_mutex */
>>   	if (device->name) {
>>   		name = rcu_string_strdup(device->name->str, GFP_NOFS);
>>   		BUG_ON(!name); /* -ENOMEM */
>> @@ -1013,10 +1012,12 @@ static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
>>   
>>   	INIT_LIST_HEAD(&pending_put);
>>   
>> -	if (--fs_devices->opened > 0)
>> +	mutex_lock(&fs_devices->device_list_mutex);
>> +	if (--fs_devices->opened > 0) {
>> +		mutex_unlock(&fs_devices->device_list_mutex);
>>   		return 0;
>> +	}
>>   
>> -	mutex_lock(&fs_devices->device_list_mutex);
>>   	list_for_each_entry_safe(device, tmp, &fs_devices->devices, dev_list) {
>>   		btrfs_prepare_close_one_device(device);
>>   		list_add(&device->dev_list, &pending_put);
>> @@ -1050,13 +1051,11 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>>   	struct btrfs_fs_devices *seed_devices = NULL;
>>   	int ret;
>>   
>> -	mutex_lock(&uuid_mutex);
>>   	ret = close_fs_devices(fs_devices);
>>   	if (!fs_devices->opened) {
>>   		seed_devices = fs_devices->seed;
>>   		fs_devices->seed = NULL;
> 
> This still touches ->seed, and also reads ->opened, some locking is
> required here or it has to be clearly explained why it's not.

  The ->seed here is %fs_devices local so we don't need the
  global uuid_mutex. We cloned it in btrfs_prepare_sprout().

  Will add comments and send v2.

Thanks, Anand

>>   	}
>> -	mutex_unlock(&uuid_mutex);
>>   
>>   	while (seed_devices) {
>>   		fs_devices = seed_devices;
>> -- 
>> 2.7.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
