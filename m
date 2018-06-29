Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43376 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932395AbeF2HNr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 03:13:47 -0400
Subject: Re: [PATCH v2] Revert "btrfs: fix a possible umount deadlock"
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
References: <1530249965-24746-1-git-send-email-nborisov@suse.com>
 <1b4173b5-857c-f261-7e69-656d47aa0bcb@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <de9adc8b-3131-c310-e17e-247ec375475b@suse.com>
Date: Fri, 29 Jun 2018 10:13:44 +0300
MIME-Version: 1.0
In-Reply-To: <1b4173b5-857c-f261-7e69-656d47aa0bcb@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.06.2018 10:11, Anand Jain wrote:
> 
> On 06/29/2018 01:26 PM, Nikolay Borisov wrote:
>> Since commit 88c14590cdd6 ("btrfs: use RCU in btrfs_show_devname for
>> device list traversal") btrfs_show_devname no longer takes
>> device_list_mutex. As such the deadlock that 0ccd05285e7f ("btrfs: fix
>> a possible umount deadlock") aimed to fix no longer exists. So remove
>> the extra code that commit added.
>>
>> This reverts commit 0ccd05285e7f5a8e297e1d6dfc41e7c65757d6fa.
> 
>  Its not exactly a revert.
> 
>  Because before 88c14590cdd6 was written, 0ccd05285e7f was already their
>  for the right purpose OR a new title is even better.

What I'm saying is that commit 88c14590cdd6 obsoleted 0ccd05285e7f,
hence this patch reverts the latter. I've literally generated it with
git revert 0ccd05285e7f + minor fixups.

> 
> 
>> Why do we first replace the closed device with a copy in
>> btrfs_close_one_device, then dispose of the copied
>> devices in btrfs_close_devices IFF we had fs_devices->seed not being
>> NULL?
> 
>  I doubt if its for the fs_devices->seed purpose, we could have
>  just NULLed few items in device and it would have worked
>  as well. I guess it for the purpose of RCU satisfactions,
>  I remember running into that issues while trying to fix.
>  If you have plans to fix that pls go ahead. Thanks. While
>  my time is occupied with volume locks as of now. Otherwise
>  its in the list to fix.

Yeah , I spoke with David about that and he said it was related to RCU
and of course the commit that introduced that had nothing about RCU in
the change log. Device close logic seems to be a train wreck atm.
> 
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Reviewed-by: Anand Jain <anand.jain@oracle.com>
> 
> Thanks, Anand
> 
>> ---
>>
>> V2:
>>   * Fixed build failure due to using old name of free_device_rcu
>> function.
>>   fs/btrfs/volumes.c | 26 ++++++--------------------
>>   1 file changed, 6 insertions(+), 20 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 5bd6f3a40f9c..011a19b7930f 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1004,7 +1004,7 @@ static void btrfs_close_bdev(struct btrfs_device
>> *device)
>>       blkdev_put(device->bdev, device->mode);
>>   }
>>   -static void btrfs_prepare_close_one_device(struct btrfs_device
>> *device)
>> +static void btrfs_close_one_device(struct btrfs_device *device)
>>   {
>>       struct btrfs_fs_devices *fs_devices = device->fs_devices;
>>       struct btrfs_device *new_device;
>> @@ -1022,6 +1022,8 @@ static void
>> btrfs_prepare_close_one_device(struct btrfs_device *device)
>>       if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
>>           fs_devices->missing_devices--;
>>   +    btrfs_close_bdev(device);
>> +
>>       new_device = btrfs_alloc_device(NULL, &device->devid,
>>                       device->uuid);
>>       BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
>> @@ -1035,39 +1037,23 @@ static void
>> btrfs_prepare_close_one_device(struct btrfs_device *device)
>>         list_replace_rcu(&device->dev_list, &new_device->dev_list);
>>       new_device->fs_devices = device->fs_devices;
>> +
>> +    call_rcu(&device->rcu, free_device_rcu);
>>   }
>>     static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
>>   {
>>       struct btrfs_device *device, *tmp;
>> -    struct list_head pending_put;
>> -
>> -    INIT_LIST_HEAD(&pending_put);
>>         if (--fs_devices->opened > 0)
>>           return 0;
>>         mutex_lock(&fs_devices->device_list_mutex);
>>       list_for_each_entry_safe(device, tmp, &fs_devices->devices,
>> dev_list) {
>> -        btrfs_prepare_close_one_device(device);
>> -        list_add(&device->dev_list, &pending_put);
>> +        btrfs_close_one_device(device);
>>       }
>>       mutex_unlock(&fs_devices->device_list_mutex);
>>   -    /*
>> -     * btrfs_show_devname() is using the device_list_mutex,
>> -     * sometimes call to blkdev_put() leads vfs calling
>> -     * into this func. So do put outside of device_list_mutex,
>> -     * as of now.
>> -     */
>> -    while (!list_empty(&pending_put)) {
>> -        device = list_first_entry(&pending_put,
>> -                struct btrfs_device, dev_list);
>> -        list_del(&device->dev_list);
>> -        btrfs_close_bdev(device);
>> -        call_rcu(&device->rcu, free_device_rcu);
>> -    }
>> -
>>       WARN_ON(fs_devices->open_devices);
>>       WARN_ON(fs_devices->rw_devices);
>>       fs_devices->opened = 0;
>>
> 
