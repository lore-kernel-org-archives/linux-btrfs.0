Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19375 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbbAGJXk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 04:23:40 -0500
Message-ID: <54ACFAF2.2010700@cn.fujitsu.com>
Date: Wed, 7 Jan 2015 17:22:58 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: get the accurate value of used_bytes in btrfs_get_block_group_info().
References: <1414413499-28826-1-git-send-email-yangds.fnst@cn.fujitsu.com> <54AA732B.7010301@cn.fujitsu.com> <54ACEDEC.7090904@jp.fujitsu.com>
In-Reply-To: <54ACEDEC.7090904@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Satoru-san
> Hi Dongsheng,
>
> On 2015/01/05 20:19, Dongsheng Yang wrote:
>
>> Ping.....
>>
>> IOCTL of BTRFS_IOC_SPACE_INFO currently does not report
>> the data used but not synced to user.  Then btrfs fi df will
>> give user a wrong numbers before sync. This patch solve
>> this problem.
>>
>> On 10/27/2014 08:38 PM, Dongsheng Yang wrote:
>>> Reproducer:
>>>     # mkfs.btrfs -f -b 20G /dev/sdb
>>>     # mount /dev/sdb /mnt/test
>>>     # fallocate  -l 17G /mnt/test/largefile
>>>     # btrfs fi df /mnt/test
>>>     Data, single: total=17.49GiB, used=6.00GiB <- only 6G, but 
>>> actually it should be 17G.
>>>     System, DUP: total=8.00MiB, used=16.00KiB
>>>     System, single: total=4.00MiB, used=0.00B
>>>     Metadata, DUP: total=1.00GiB, used=112.00KiB
>>>     Metadata, single: total=8.00MiB, used=0.00B
>>>     GlobalReserve, single: total=16.00MiB, used=0.00B
>
> I tried to reproduce your problem with 3.19-rc1.
> However, this problem doesn't happen. Could you
> also try to reproduce with the upstream kernel?
I can still reproduce it in 3.18, but it seems to be fixed in 3.19-rc1 
already by other patch,
so this patch is no longer needed.

Thanks,
Qu
>
> * Detail
>
> test script (named "yang-test.sh" here):
> =============================================================================== 
>
> #!/bin/bash -x
>
> PART1=/dev/vdb
> MNT_PNT=./mnt
> mkfs.btrfs -f -b 20G ${PART1}
> mount ${PART1} ${MNT_PNT}
> fallocate -l 17G ${MNT_PNT}/largefile
> btrfs fi df ${MNT_PNT}
> sync
> btrfs fi df ${MNT_PNT}
> umount ${MNT_PNT}
> =============================================================================== 
>
>
> Result:
> =============================================================================== 
>
> # ./yang-test.sh
> + PART1=/dev/vdb
> + MNT_PNT=./mnt
> + mkfs.btrfs -f -b 20G /dev/vdb
> Btrfs v3.17
> See http://btrfs.wiki.kernel.org for more information.
>
> Turning ON incompat feature 'extref': increased hardlink limit per 
> file to 65536
> fs created label (null) on /dev/vdb
>         nodesize 16384 leafsize 16384 sectorsize 4096 size 20.00GiB
> + mount /dev/vdb ./mnt
> + fallocate -l 17G ./mnt/largefile
> + btrfs fi df ./mnt
> Data, single: total=17.01GiB, used=17.00GiB   # Used 17GiB properly
> System, DUP: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=1.00GiB, used=112.00KiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=16.00MiB, used=0.00B
> + sync
> + btrfs fi df ./mnt
> Data, single: total=17.01GiB, used=17.00GiB    # (of course) used 
> 17GiB too
> System, DUP: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=1.00GiB, used=112.00KiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=16.00MiB, used=0.00B
> + umount ./mnt
> =============================================================================== 
>
>
> Although I ran this test five times, the results are the same.
>
> Thanks,
> Satoru
>
>>>     # sync
>>>     # btrfs fi df /mnt/test
>>>     Data, single: total=17.49GiB, used=17.00GiB <- After sync, it is 
>>> expected.
>>>     System, DUP: total=8.00MiB, used=16.00KiB
>>>     System, single: total=4.00MiB, used=0.00B
>>>     Metadata, DUP: total=1.00GiB, used=112.00KiB
>>>     Metadata, single: total=8.00MiB, used=0.00B
>>>     GlobalReserve, single: total=16.00MiB, used=0.00B
>>>
>>> The value of 6.00GiB is actually calculated in 
>>> btrfs_get_block_group_info()
>>> by adding the @block_group->item->used for each group together. In 
>>> this way,
>>> it did not consider the bytes in cache.
>>>
>>> This patch adds the value of @pinned, @reserved and @bytes_super in
>>> struct btrfs_block_group_cache to make sure we can get the accurate 
>>> @used_bytes.
>>>
>>> Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>>> ---
>>>   fs/btrfs/ioctl.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 33c80f5..bc2aaeb 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -3892,6 +3892,10 @@ void btrfs_get_block_group_info(struct 
>>> list_head *groups_list,
>>>           space->total_bytes += block_group->key.offset;
>>>           space->used_bytes +=
>>> btrfs_block_group_used(&block_group->item);
>>> +        /* Add bytes-info in cache */
>>> +        space->used_bytes += block_group->pinned;
>>> +        space->used_bytes += block_group->reserved;
>>> +        space->used_bytes += block_group->bytes_super;
>>>       }
>>>   }
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

