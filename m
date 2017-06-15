Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20406 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751789AbdFOWVH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 18:21:07 -0400
Subject: Re: [PATCH 4/5] btrfs: add fs flag to force device flushing
From: Anand Jain <anand.jain@oracle.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1497544265.git.dsterba@suse.com>
 <8c201990ae0acb3b80437f9de2e432b60ecf8e4a.1497544265.git.dsterba@suse.com>
 <e8b99f82-4e39-fda5-39f3-f3349577687d@oracle.com>
Message-ID: <96590a3c-ba90-c671-2e23-d629834547a6@oracle.com>
Date: Fri, 16 Jun 2017 06:27:20 +0800
MIME-Version: 1.0
In-Reply-To: <e8b99f82-4e39-fda5-39f3-f3349577687d@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 59a732a13370..659a3b4645d2 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3494,7 +3494,8 @@ static void write_dev_flush(struct btrfs_device 
>> *device)
>>       struct request_queue *q = bdev_get_queue(device->bdev);
>>       struct bio *bio = device->flush_bio;
>> -    if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
>> +    if (!test_bit(BTRFS_FS_FORCE_DEV_FLUSH, &device->fs_info->flags)
>> +        && !test_bit(QUEUE_FLAG_WC, &q->queue_flags))
>>           return;
> 
> 
>   Now I understand what you meant. But the most common case in our test
>   set up is a device with write cache. So BTRFS_FS_FORCE_DEV_FLUSH does
>   not bring any additional force. IMO.
> 
> Thanks, Anand

  Or one another idea is we could remove

    !test_bit(QUEUE_FLAG_WC, &q->queue_flags)

  which purpose is to only fail early.

  If we remove it there is consistency in our code with or
  with out the write cache.

Thanks, Anand
