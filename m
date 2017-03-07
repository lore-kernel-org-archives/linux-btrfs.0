Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20859 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750718AbdCGFoh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 00:44:37 -0500
Subject: Re: [PATCH v2 4/6] btrfs: Allow barrier_all_devices to do chunk level
 device check
To: Anand Jain <anand.jain@oracle.com>
References: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
 <20170306085855.11403-5-quwenruo@cn.fujitsu.com>
 <10be6a52-355d-d23f-b534-0bb279516a56@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <lists@colorremedies.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2194e420-62ff-8ee3-6311-d1cc397525fb@cn.fujitsu.com>
Date: Tue, 7 Mar 2017 13:36:07 +0800
MIME-Version: 1.0
In-Reply-To: <10be6a52-355d-d23f-b534-0bb279516a56@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/07/2017 12:48 PM, Anand Jain wrote:
>
>
> On 03/06/2017 04:58 PM, Qu Wenruo wrote:
>> The last user of num_tolerated_disk_barrier_failures is
>> barrier_all_devices().
>> But it's can be easily changed to new per-chunk degradable check
>> framework.
>>
>> Now btrfs_device will have two extra members, representing send/wait
>> error, set at write_dev_flush() time.
>> With these 2 new members, btrfs_check_rw_degradable() can check if the
>> fs is still OK when the fs is committed to disk.
>
>  This logic isn't reentrant, earlier it was. How about using
>  stack variable instead ?
>
> Thanks, Anand

Thanks for the review.

However I didn't quite get the point about the re-entrance and stack 
variable here.

1) About reentrancy
In previous version, the err_* bits are still put into btrfs_devices 
structure, just timing of resetting these bits are changes.

So either way, it's not reentrant in theory.

But that doesn't make a problem, as we have other things to protect when 
calling write_all_supers(), the only caller of barrier_all_devices().

So would you give me an example why we need to make it reentrant?

2) About using stack variable?
Did you mean build a array on stack to record which devices fails to 
send/wait and use the array as check condition other than 
btrfs_device->err_* and btrfs_device->missing ?

The only problem is, it sounds more complex than needed.
Despite the err_*, we also needs to check already missing devices, so I 
prefer the easy way, just checking btrfs_device->err_* and 
btrfs_device->missing.

Any simple example to explain your suggestion here?

Thanks,
Qu

>
>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  fs/btrfs/disk-io.c | 15 +++++++--------
>>  fs/btrfs/volumes.c |  4 +++-
>>  fs/btrfs/volumes.h |  4 ++++
>>  3 files changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index c26b8a0b121c..f596bd130524 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3569,17 +3569,17 @@ static int barrier_all_devices(struct
>> btrfs_fs_info *info)
>>  {
>>      struct list_head *head;
>>      struct btrfs_device *dev;
>> -    int errors_send = 0;
>> -    int errors_wait = 0;
>>      int ret;
>>
>>      /* send down all the barriers */
>>      head = &info->fs_devices->devices;
>>      list_for_each_entry_rcu(dev, head, dev_list) {
>> +        dev->err_wait = false;
>> +        dev->err_send = false;
>>          if (dev->missing)
>>              continue;
>>          if (!dev->bdev) {
>> -            errors_send++;
>> +            dev->err_send = true;
>>              continue;
>>          }
>>          if (!dev->in_fs_metadata || !dev->writeable)
>> @@ -3587,7 +3587,7 @@ static int barrier_all_devices(struct
>> btrfs_fs_info *info)
>>
>>          ret = write_dev_flush(dev, 0);
>>          if (ret)
>> -            errors_send++;
>> +            dev->err_send = true;
>>      }
>>
>>      /* wait for all the barriers */
>> @@ -3595,7 +3595,7 @@ static int barrier_all_devices(struct
>> btrfs_fs_info *info)
>>          if (dev->missing)
>>              continue;
>>          if (!dev->bdev) {
>> -            errors_wait++;
>> +            dev->err_wait = true;
>>              continue;
>>          }
>>          if (!dev->in_fs_metadata || !dev->writeable)
>> @@ -3603,10 +3603,9 @@ static int barrier_all_devices(struct
>> btrfs_fs_info *info)
>>
>>          ret = write_dev_flush(dev, 1);
>>          if (ret)
>> -            errors_wait++;
>> +            dev->err_wait = true;
>>      }
>> -    if (errors_send > info->num_tolerated_disk_barrier_failures ||
>> -        errors_wait > info->num_tolerated_disk_barrier_failures)
>> +    if (!btrfs_check_rw_degradable(info))
>>          return -EIO;
>>      return 0;
>>  }
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index dd9dd94d7043..729cbd0d2b60 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6796,7 +6796,9 @@ bool btrfs_check_rw_degradable(struct
>> btrfs_fs_info *fs_info)
>>              btrfs_get_num_tolerated_disk_barrier_failures(
>>                      map->type);
>>          for (i = 0; i < map->num_stripes; i++) {
>> -            if (map->stripes[i].dev->missing)
>> +            if (map->stripes[i].dev->missing ||
>> +                map->stripes[i].dev->err_wait ||
>> +                map->stripes[i].dev->err_send)
>>                  missing++;
>>          }
>>          if (missing > max_tolerated) {
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index db1b5ef479cf..112fccacdabc 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -75,6 +75,10 @@ struct btrfs_device {
>>      int can_discard;
>>      int is_tgtdev_for_dev_replace;
>>
>> +    /* If this devices fails to send/wait dev flush */
>> +    bool err_send;
>> +    bool err_wait;
>
>
>
>>  #ifdef __BTRFS_NEED_DEVICE_DATA_ORDERED
>>      seqcount_t data_seqcount;
>>  #endif
>>
>
>


