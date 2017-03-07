Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:28022 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753331AbdCGIHo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 03:07:44 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v276rGp0027981
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Mar 2017 06:53:16 GMT
Subject: Re: [PATCH v2 4/6] btrfs: Allow barrier_all_devices to do chunk level
 device check
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
 <20170306085855.11403-5-quwenruo@cn.fujitsu.com>
 <10be6a52-355d-d23f-b534-0bb279516a56@oracle.com>
 <2194e420-62ff-8ee3-6311-d1cc397525fb@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lists@colorremedies.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c9a004c9-57e5-3f85-b8e2-c40da6ebd4db@oracle.com>
Date: Tue, 7 Mar 2017 14:55:46 +0800
MIME-Version: 1.0
In-Reply-To: <2194e420-62ff-8ee3-6311-d1cc397525fb@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





> 1) About reentrancy
> In previous version, the err_* bits are still put into btrfs_devices
> structure, just timing of resetting these bits are changes.
>
> So either way, it's not reentrant in theory.
>
> But that doesn't make a problem, as we have other things to protect when
> calling write_all_supers(), the only caller of barrier_all_devices().
>
> So would you give me an example why we need to make it reentrant?

  Its updating the device struct I would avoid such a change
  for the reasons of this patch. (I notice that in V1 as well).
  Further btrfs does not handle online intermittent device failure,
  unless the complete story is taken care, I would avoid such a change.

  Theoretically this patch is buggy, btrfs_check_rw_degradable() has
  more consumers than just the barrier_all_devices(). However the
  dev->err_wait and dev->err_send are managed by only
  barrier_all_devices(). And the bad news is dev->err_wait and
  dev->err_send would affect the result of "missing" coming out of
  btrfs_check_rw_degradable() which is wrong for the threads other
  than barrier_all_devices(). Further, the only way dev->err_wait and
  dev->err_send gets reset is by the next call to
  barrier_all_devices(). And if lock is an answer that would makes
  it messy and complicated. I won't do that.

  There is a simple solution as below..

> 2) About using stack variable?

  pass err_send and err_write to btrfs_check_rw_degradable() through
  argument so to compute degradable for the barrier_all_devices().
  In this way changes are kept local thread specific.

Thanks, Anand


> Did you mean build a array on stack to record which devices fails to
> send/wait and use the array as check condition other than
> btrfs_device->err_* and btrfs_device->missing ?
>
> The only problem is, it sounds more complex than needed.
> Despite the err_*, we also needs to check already missing devices, so I
> prefer the easy way, just checking btrfs_device->err_* and
> btrfs_device->missing.
>
> Any simple example to explain your suggestion here?
>
> Thanks,
> Qu
>
>>
>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/disk-io.c | 15 +++++++--------
>>>  fs/btrfs/volumes.c |  4 +++-
>>>  fs/btrfs/volumes.h |  4 ++++
>>>  3 files changed, 14 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index c26b8a0b121c..f596bd130524 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -3569,17 +3569,17 @@ static int barrier_all_devices(struct
>>> btrfs_fs_info *info)
>>>  {
>>>      struct list_head *head;
>>>      struct btrfs_device *dev;
>>> -    int errors_send = 0;
>>> -    int errors_wait = 0;
>>>      int ret;
>>>
>>>      /* send down all the barriers */
>>>      head = &info->fs_devices->devices;
>>>      list_for_each_entry_rcu(dev, head, dev_list) {
>>> +        dev->err_wait = false;
>>> +        dev->err_send = false;
>>>          if (dev->missing)
>>>              continue;
>>>          if (!dev->bdev) {
>>> -            errors_send++;
>>> +            dev->err_send = true;
>>>              continue;
>>>          }
>>>          if (!dev->in_fs_metadata || !dev->writeable)
>>> @@ -3587,7 +3587,7 @@ static int barrier_all_devices(struct
>>> btrfs_fs_info *info)
>>>
>>>          ret = write_dev_flush(dev, 0);
>>>          if (ret)
>>> -            errors_send++;
>>> +            dev->err_send = true;
>>>      }
>>>
>>>      /* wait for all the barriers */
>>> @@ -3595,7 +3595,7 @@ static int barrier_all_devices(struct
>>> btrfs_fs_info *info)
>>>          if (dev->missing)
>>>              continue;
>>>          if (!dev->bdev) {
>>> -            errors_wait++;
>>> +            dev->err_wait = true;
>>>              continue;
>>>          }
>>>          if (!dev->in_fs_metadata || !dev->writeable)
>>> @@ -3603,10 +3603,9 @@ static int barrier_all_devices(struct
>>> btrfs_fs_info *info)
>>>
>>>          ret = write_dev_flush(dev, 1);
>>>          if (ret)
>>> -            errors_wait++;
>>> +            dev->err_wait = true;
>>>      }
>>> -    if (errors_send > info->num_tolerated_disk_barrier_failures ||
>>> -        errors_wait > info->num_tolerated_disk_barrier_failures)
>>> +    if (!btrfs_check_rw_degradable(info))
>>>          return -EIO;
>>>      return 0;
>>>  }
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index dd9dd94d7043..729cbd0d2b60 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -6796,7 +6796,9 @@ bool btrfs_check_rw_degradable(struct
>>> btrfs_fs_info *fs_info)
>>>              btrfs_get_num_tolerated_disk_barrier_failures(
>>>                      map->type);
>>>          for (i = 0; i < map->num_stripes; i++) {
>>> -            if (map->stripes[i].dev->missing)
>>> +            if (map->stripes[i].dev->missing ||
>>> +                map->stripes[i].dev->err_wait ||
>>> +                map->stripes[i].dev->err_send)
>>>                  missing++;
>>>          }

  This is rather wrong.


>>>          if (missing > max_tolerated) {
>>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>>> index db1b5ef479cf..112fccacdabc 100644
>>> --- a/fs/btrfs/volumes.h
>>> +++ b/fs/btrfs/volumes.h
>>> @@ -75,6 +75,10 @@ struct btrfs_device {
>>>      int can_discard;
>>>      int is_tgtdev_for_dev_replace;
>>>
>>> +    /* If this devices fails to send/wait dev flush */
>>> +    bool err_send;
>>> +    bool err_wait;
>>
>>
>>
>>>  #ifdef __BTRFS_NEED_DEVICE_DATA_ORDERED
>>>      seqcount_t data_seqcount;
>>>  #endif
>>>
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
