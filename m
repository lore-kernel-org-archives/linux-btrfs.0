Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53801 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbbJYMRn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Oct 2015 08:17:43 -0400
Subject: Re: Exclusive quota of snapshot exceeded despite no space used
To: Johannes Henninger <johannes+btrfs@henninger.io>,
        linux-btrfs@vger.kernel.org
References: <56294960.10406@henninger.io> <5629758D.203@gmx.com>
 <562A4CC7.1060802@henninger.io> <562C25DE.6050209@gmx.com>
 <562CB891.40301@henninger.io>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <562CC85D.7010107@gmx.com>
Date: Sun, 25 Oct 2015 20:17:33 +0800
MIME-Version: 1.0
In-Reply-To: <562CB891.40301@henninger.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年10月25日 19:10, Johannes Henninger 写道:
> On 25.10.2015 02:44, Qu Wenruo wrote:
>>
>>
>> 在 2015年10月23日 23:05, Johannes Henninger 写道:
>>> On 23.10.2015 01:47, Qu Wenruo wrote:
>>>> 在 2015年10月23日 04:38, Johannes Henninger 写道:
>>>>> I'm having a weird problem with snapshots and exclusive quotas. After
>>>>> creating a snapshot of a subvolume and setting an exclusive quota of
>>>>> 50MB for the snapshot, everything seems to work fine. I can write
>>>>> approximately 50MB before the quota kicks in.
>>>>>
>>>>> However, if I create a snapshot, set an exclusive quota and just wait
>>>>> for some time, I suddenly cannot even create an empty file because I'm
>>>>> getting a "quota exceeded" error. The time until the bug appears seems
>>>>> to vary. During the waiting time, I'm changing neither the snapshot
>>>>> nor
>>>>> the original subvolume. "qgroup show -e" reports an exclusive use of
>>>>> only a few kilobytes for the snapshot, which is nowhere near the
>>>>> limit.
>>>>>
>>>>> Steps to reproduce (/media/extern is a fresh and empty btrfs
>>>>> partition):
>>>>>
>>>>> Enable quota and create an empty subvolume:
>>>>>        root@t420:/media/extern# btrfs quota enable .
>>>>>        root@t420:/media/extern# btrfs subvolume create sub
>>>>>        Create subvolume './sub'
>>>>>
>>>>> Snapshot the subvolume and set a limit:
>>>>>        root@t420:/media/extern# btrfs subvolume snapshot sub snap
>>>>>        Create a snapshot of 'sub' in './snap'
>>>>>        root@t420:/media/extern# cd snap/
>>>>>        root@t420:/media/extern/snap# btrfs qgroup limit -e 50M .
>>>>>
>>>>> Sometimes it takes "longer" for the quota to kick in, so I'm
>>>>> touching a
>>>>> file every 5 minutes here:
>>>>>
>>>>>        root@t420:/media/extern/snap# for file in {1..100}; do touch
>>>>> $file;
>>>>> sleep 5m; done
>>>>>        touch: cannot touch ‘7’: Disk quota exceeded
>>>>>        ^C
>>>>>        root@t420:/media/extern/snap# btrfs qgroup show -e .
>>>>>        qgroupid         rfer         excl     max_excl
>>>>>        --------         ----         ----     --------
>>>>>        0/5          16.00KiB     16.00KiB         none
>>>>>        0/257        16.00KiB     16.00KiB         none
>>>>>        0/258        16.00KiB     16.00KiB     50.00MiB
>>>>>
>>>>> Any idea why this happens?
>>>> BTW, to make btrfs qgroup show work, it's better to call sync before
>>>> qgroup show.
>>>>
>>>> It's a known bug that even after qgroup accounting rework, qgroup
>>>> reserve still has bug and can cause reserved space to underflow,
>>>> making such problem happen.
>>>>
>>>> For such case, btrfs qgroup show won't help as reserved space is not
>>>> shown in the output.
>>>>
>>>> One workaround would be, umount the filesystem and mount again.
>>>> Which will reset the underflow reserved space and work for sometime.
>>>>
>>>> If it's OK for you to recompile the kernel, you can try the following
>>>> patchset:
>>>> [PATCH v3 00/21] Rework btrfs qgroup reserved space framework
>>>>
>>>> Which should solve the problem.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>
>>> Thanks a lot for your reply!
>>>
>>> While remounting the filesystem fixes the issue temporary, it doesn't
>>> take very long for the bug to happen again so it's not really a
>>> workaround I can work with.
>>>
>>> I did recompile the kernel using your patches, but unfortunately the
>>> problem still appears.
>>>
>>> Thanks,
>>> Johannes
>>>
>> Interesting, just touching file will cause EQUOTA is quite a big problem.
>>
>> I'll try to reproduce it with my patchset and see what really caused
>> the problem.
>> The problem seems to do with snapshot qgroup hacking.
>> But I'm not completely sure yet.
>>
>> BTW, does "sync; btrfs qgroup show -prce" still show excl as 16K?
>> 16K is the correct number with only 6 empty files, just in case.
>>
>> Thanks,
>> Qu
>
> I ran my example from the first mail again and managed to write 7 files
> this time, "qgroup show" still shows 16kB after sync:
>
> root@t420:/media/extern/snap# btrfs qg limit -e 50M .
> root@t420:/media/extern/snap# for file in {1..100}; do touch $file;
> sleep 5m; done
> touch: cannot touch ‘8’: Disk quota exceeded
> ^C
> root@t420:/media/extern/snap# sync
> root@t420:/media/extern/snap# btrfs qgroup show -pcre .
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/257        16.00KiB     16.00KiB         none         none ---     ---
> 0/258        16.00KiB     16.00KiB         none     50.00MiB ---     ---
> root@t420:/media/extern/snap# btrfs fi sync .
> FSSync '.'
> root@t420:/media/extern/snap# btrfs qgroup show -pcre .
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/257        16.00KiB     16.00KiB         none         none ---     ---
> 0/258        16.00KiB     16.00KiB         none     50.00MiB ---     ---
>
Thanks for the report.

At least, the rfer/excl number is correct.

So the problem is limited to qgroup reserved space.
I'll debug it tomorrow to see what's going wrong inside the reserved space.

> By the way, I don't if its relevant but the problem is not limited to
> exclusive quotas, but also happens when setting a "referenced" limit
> (qgroup limit without "-e").

This also indicates that the problem is in reserved space, not rfer/excl 
accounting, as reserved space is used for both rfer or excl, so if it's 
going wrong, no matter to which the limit is set, it will cause EDQUOT.

Thanks,
Qu

>
> Thanks,
> Johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
