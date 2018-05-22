Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40526 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbeEVJJ1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 05:09:27 -0400
Subject: Re: [PATCH 10/15] btrfs: drop uuid_mutex in btrfs_free_extra_devids()
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180412022938.8257-1-anand.jain@oracle.com>
 <20180412022938.8257-11-anand.jain@oracle.com>
 <20180515162647.GT6649@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2d44cf7d-46e1-194e-06d5-b060859e9a44@oracle.com>
Date: Tue, 22 May 2018 17:11:58 +0800
MIME-Version: 1.0
In-Reply-To: <20180515162647.GT6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/16/2018 12:26 AM, David Sterba wrote:
> On Thu, Apr 12, 2018 at 10:29:33AM +0800, Anand Jain wrote:
>> btrfs_free_extra_devids() frees the orphan fsid::devid but its search is
>> limited to btrfs_fs_devices::devices, so we dont need uuid_mutex.
> 
>  From that it's not clear why there's no locking at all now:
> 
>> @@ -897,7 +897,6 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
>>   	struct btrfs_device *device, *next;
>>   	struct btrfs_device *latest_dev = NULL;
>>   
>> -	mutex_lock(&uuid_mutex);
> 
> ie. why is this not replaced by the device_list_lock. Please resend this
> patch and explain in the changelog.

  My apologies for the delay.

  btrfs_free_extra_devids() needs device_list_mutex, will send a v2 for
  this.

  Thanks.

>>   again:
>>   	/* This is the initialized path, it is safe to release the devices. */
>>   	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
>> @@ -951,8 +950,6 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
>>   	}
>>   
>>   	fs_devices->latest_bdev = latest_dev->bdev;
>> -
>> -	mutex_unlock(&uuid_mutex);
>>   }
>>   
>>   static void free_device_rcu(struct rcu_head *head)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
