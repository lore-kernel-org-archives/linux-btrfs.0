Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from henninger.io ([144.76.155.217]:34261 "EHLO mail.henninger.io"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbbJ0APN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 20:15:13 -0400
From: Johannes Henninger <johannes+btrfs@henninger.io>
Subject: Re: Exclusive quota of snapshot exceeded despite no space used
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <56294960.10406@henninger.io> <5629758D.203@gmx.com>
 <562A4CC7.1060802@henninger.io> <562C25DE.6050209@gmx.com>
 <562CB891.40301@henninger.io> <562DD249.200@cn.fujitsu.com>
Message-ID: <562EC20B.909@henninger.io>
Date: Tue, 27 Oct 2015 01:15:07 +0100
MIME-Version: 1.0
In-Reply-To: <562DD249.200@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 26.10.2015 08:12, Qu Wenruo wrote:
>
>>>> Thanks a lot for your reply!
>>>>
>>>> While remounting the filesystem fixes the issue temporary, it doesn't
>>>> take very long for the bug to happen again so it's not really a
>>>> workaround I can work with.
>>>>
>>>> I did recompile the kernel using your patches, but unfortunately the
>>>> problem still appears.
>>>>
>>>> Thanks,
>>>> Johannes
>>>>
>>> Interesting, just touching file will cause EQUOTA is quite a big
>>> problem.
>>>
>>> I'll try to reproduce it with my patchset and see what really caused
>>> the problem.
>>> The problem seems to do with snapshot qgroup hacking.
>>> But I'm not completely sure yet.
>>>
>>> BTW, does "sync; btrfs qgroup show -prce" still show excl as 16K?
>>> 16K is the correct number with only 6 empty files, just in case.
>>>
>>> Thanks,
>>> Qu
>>
>> I ran my example from the first mail again and managed to write 7 files
>> this time, "qgroup show" still shows 16kB after sync:
>>
>> root@t420:/media/extern/snap# btrfs qg limit -e 50M .
>> root@t420:/media/extern/snap# for file in {1..100}; do touch $file;
>> sleep 5m; done
>> touch: cannot touch ‘8’: Disk quota exceeded
>> ^C
>> root@t420:/media/extern/snap# sync
>> root@t420:/media/extern/snap# btrfs qgroup show -pcre .
>> qgroupid         rfer         excl     max_rfer     max_excl parent 
>> child
>> --------         ----         ----     --------     -------- ------ 
>> -----
>> 0/5          16.00KiB     16.00KiB         none         none ---     ---
>> 0/257        16.00KiB     16.00KiB         none         none ---     ---
>> 0/258        16.00KiB     16.00KiB         none     50.00MiB ---     ---
>> root@t420:/media/extern/snap# btrfs fi sync .
>> FSSync '.'
>> root@t420:/media/extern/snap# btrfs qgroup show -pcre .
>> qgroupid         rfer         excl     max_rfer     max_excl parent 
>> child
>> --------         ----         ----     --------     -------- ------ 
>> -----
>> 0/5          16.00KiB     16.00KiB         none         none ---     ---
>> 0/257        16.00KiB     16.00KiB         none         none ---     ---
>> 0/258        16.00KiB     16.00KiB         none     50.00MiB ---     ---
>>
>> By the way, I don't if its relevant but the problem is not limited to
>> exclusive quotas, but also happens when setting a "referenced" limit
>> (qgroup limit without "-e").
>>
>> Thanks,
>> Johannes
>>
>
> The bug is located, and turns out to be quite a stupid problem caused
> by myself.
>
> I just forgot to include a cleanup patch during rebase!!!! AGAIN!!!
>
> You can apply the following patch to resolve it:
> [PATCH 3/3] btrfs: qgroup: Fix a rebase bug which will cause qgroup
> double free
>
> Or just apply the whole patchset:
> [4.4][PATCH 0/3] btrfs: Qgroup hotfix
>
> At least, with the patchset based on Chris' integration-4.4 branch, it
> succeeded in touching all the 100 files in my test box.
>
> Thanks,
> Qu
>

It's working! Thank you so much for fixing this bug, you don't even know
how much this has helped me!

Thanks!
Johannes
