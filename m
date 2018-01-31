Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41470 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbeAaJ1L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 04:27:11 -0500
Subject: Re: [PATCH 2/2] btrfs: add read_mirror_policy parameter devid
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180130063020.14850-1-anand.jain@oracle.com>
 <20180130063020.14850-3-anand.jain@oracle.com>
 <f4772f0c-c53e-c859-7da9-b2181a3507c1@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <7a21d5f0-b7f0-9da6-22b6-b45976d6ab40@oracle.com>
Date: Wed, 31 Jan 2018 17:28:26 +0800
MIME-Version: 1.0
In-Reply-To: <f4772f0c-c53e-c859-7da9-b2181a3507c1@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/31/2018 04:38 PM, Nikolay Borisov wrote:
> 
> 
> On 30.01.2018 08:30, Anand Jain wrote:
>> Adds the mount option:
>>    mount -o read_mirror_policy=<devid>
>>
>> To set the devid of the device which should be used for read. That
>> means all the normal reads will go to that particular device only.
>>
>> This also helps testing and gives a better control for the test
>> scripts including mount context reads.
> 
> Some code comments below. OTOH, does such policy really make sense, what
> happens if the selected device fails, will the other mirror be retried?

  Everything as usual, read_mirror_policy=devid just lets the user to
  specify his read optimized disk, so that we don't depend on the pid
  to pick a stripe mirrored disk, and instead we would pick as suggested
  by the user, and if that disk fails then we go back to the other mirror
  which may not be the read optimized disk as we have no other choice.

> If the answer to the previous question is positive then why do we really
> care which device is going to be tried first?

  It matters.
    - If you are reading from both disks alternatively, then it
      duplicates the LUN cache on the storage.
    - Some disks are read-optimized and using that for reading and going
      back to the other disk only when this disk fails provides a better
      overall read performance.

::
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 39ba59832f38..478623e6e074 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -5270,6 +5270,16 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>>   		num = map->num_stripes;
>>   
>>   	switch(fs_info->read_mirror_policy) {
>> +	case BTRFS_READ_MIRROR_BY_DEV:
>> +		optimal = first;
>> +		if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
>> +			     &map->stripes[optimal].dev->dev_state))
>> +			break;
>> +		if (test_bit(BTRFS_DEV_STATE_READ_MIRROR,
>> +			     &map->stripes[++optimal].dev->dev_state))
>> +			break;
>> +		optimal = first;
> 
> you set optimal 2 times, the second one seems redundant.

  No actually. When both the disks containing the stripe does not
  have the BTRFS_DEV_STATE_READ_MIRROR, then I would just want to
  use first found stripe.

> Alongside this
> patch it makes sense to also send a patch to btrfs(5) man page
> describing the mount option + description of each implemented allocation
> policy.

  Yep. Will do.

> Another thing which I don't see here is how you are handling the case
> when you have more than 2 devices in the RAID1 case. As it stands
> currently you assume there are two devices and first test device 0 and
> then device 1 and completely ignore any other devices.

  Not really. That part is already handled by the extent mapping.
  As the number of stripe for raid1 is two, the extent mapping will
  manage put related two devices of this stripe.

Thanks, Anand
