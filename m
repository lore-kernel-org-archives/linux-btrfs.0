Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51354 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751934AbdCNDbv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 23:31:51 -0400
Subject: Re: [PATCH 4/4] btrfs: cleanup barrier_all_devices() to check dev
 stat flush error
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20170313074214.24123-1-anand.jain@oracle.com>
 <20170313074214.24123-5-anand.jain@oracle.com>
 <c425830d-9c70-f795-9ad6-05d6ea62a0dc@cn.fujitsu.com>
 <1d9050d3-64c0-76d9-26e7-e06c278797da@oracle.com>
 <e181c53d-0a54-710b-95af-d38901e2812d@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <01cc891a-0fb6-5107-0ba3-1567b9c7330b@oracle.com>
Date: Tue, 14 Mar 2017 11:36:28 +0800
MIME-Version: 1.0
In-Reply-To: <e181c53d-0a54-710b-95af-d38901e2812d@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>>>>
>>>> +struct device_checkpoint {
>>>> +    struct list_head list;
>>>> +    struct btrfs_device *device;
>>>> +    int stat_value_checkpoint;
>>>> +};
>>>> +
>>>> +static int add_device_checkpoint(struct list_head *checkpoint,
>>>
>>> Could we have another structure instead of list_head to record device
>>> checkpoints?
>>> The list_head is never a meaningful structure under most cases.
>>
>>  I didn't understand this, there is device_checkpoint and the context
>>  of struct list_head *checkpoint would start and end within
>>  barrier_all_devices().
>
> I just mean to encapsulate the list_head into another structure, e.g,
> call it device_checkpoints or something else.
>
> Just a list_head is not quite meaningful.

  OK. Will do.

>>>> +static int check_stat_flush(struct btrfs_device *dev,
>>>> +                struct list_head *checkpoint)
>>>> +{
>>>> +    int val;
>>>> +    struct device_checkpoint *cdev;
>>>> +
>>>> +    list_for_each_entry(cdev, checkpoint, list) {
>>>> +        if (cdev->device == dev) {
>>>> +            val = btrfs_dev_stat_read(dev,
>>>> +                BTRFS_DEV_STAT_FLUSH_ERRS);
>>>> +            if (cdev->stat_value_checkpoint != val)
>>>> +                return 1;
>>>
>>> This check implies that BTRFS_DEV_STAT_FLUSH_ERRS will only be modified
>>> by checkpoint related code.
>>> Or any other modifier can easily break the check, causing false alert.
>>
>>  I have already checked it, its not possible with the current code,
>>  or do you see if that is possible with the current code ? or Did I
>>  miss something ?
>
> You didn't miss anything.
>
> However I just got the same comment on better not to play around
> something inside btrfs_device.
>
> So I'm not sure if it's good to do it this time just for cleaning up
> barrier_all_devices().


  Right. The reason I said that before was first of all the concept
  of err_send and err_wait wasn't needed as shown in the patch set
  1 to 3 in this patch-set. We have the dev_stat flush which keeps
  track of the flush error in the right way.
  Next to monitor the change in the flush error instead of checkpoint
  probably dev_stat_ccnt is the correct way (which in the long term
  we would need that kind on the per error-stat for rest of the
  error-stat including flush). But unless we have all the requirements
  well understood from the other pending stuff like device disappear
  and reappear I won't change the struct btrfs_devices as of now.

  Hope this clarifies better. Will send out the patch with the review
  comment incorporated. Thanks. On top of which per chunk missing
  device check patch can be added.

Thanks, Anand
