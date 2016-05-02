Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35707 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbcEBGK5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 02:10:57 -0400
Subject: Re: [PATCH 1/2] btrfs: create degraded-RAID1 chunks
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
References: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
 <1461812780-538-2-git-send-email-anand.jain@oracle.com>
 <20160429164234.GE29353@suse.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5726EF6B.7010404@oracle.com>
Date: Mon, 2 May 2016 14:10:51 +0800
MIME-Version: 1.0
In-Reply-To: <20160429164234.GE29353@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for comments, more below..

On 04/30/2016 12:42 AM, David Sterba wrote:
> On Thu, Apr 28, 2016 at 11:06:19AM +0800, Anand Jain wrote:
>> When RAID1 is degraded, newer chunks should be degraded-RAID1
>> chunks instead of single chunks.
>>
>> The bug is because the devs_min for raid1 was wrong it should
>> be 1, instead of 2.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 38 +++++++++++++++++++++++++++++++++-----
>>   1 file changed, 33 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index e2b54d546b7c..8b87ed6eb381 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -56,7 +56,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>>   		.sub_stripes	= 1,
>>   		.dev_stripes	= 1,
>>   		.devs_max	= 2,
>> -		.devs_min	= 2,
>> +		.devs_min	= 1,
>
> I think we should introduce another way how to determine the lower limit
> for the degraded mounts. We need the proper raidX constraints and use
> the degraded limits only if in case of the degraded mount.
>
>>   		.tolerated_failures = 1,
>
> Which is exactly the tolerated_failures:
>
>    degraded_devs_min == devs_min - tolerated_failures

  that is devs_min is actually healthy_devs_min.

> which works for all raid levels with redundancy.

But not for RAID5 and RAID6.

Here is a (simulation?) tool which gives some ready ans.
I have added devs_min - tolerated_failures to it.

https://github.com/asj/btrfs-raid-cal.git

I am seeing problem as this:
RAID5&6 devs_min values are in the context of degraded volume.
RAID1&10.. devs_min values are in the context of healthy volume.

RAID56 is correct. We already have devs_max to know the number
of devices in a healthy volumes. RAID1 is devs_min is wrong so
it ended up being same as devs_max.

?

Thanks, Anand


>>   		.devs_increment	= 2,
>>   		.ncopies	= 2,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
