Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from henninger.io ([144.76.155.217]:55560 "EHLO mail.henninger.io"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbbJWPFr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Oct 2015 11:05:47 -0400
Subject: Re: Exclusive quota of snapshot exceeded despite no space used
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <56294960.10406@henninger.io> <5629758D.203@gmx.com>
From: Johannes Henninger <johannes+btrfs@henninger.io>
Message-ID: <562A4CC7.1060802@henninger.io>
Date: Fri, 23 Oct 2015 17:05:43 +0200
MIME-Version: 1.0
In-Reply-To: <5629758D.203@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23.10.2015 01:47, Qu Wenruo wrote:
> 在 2015年10月23日 04:38, Johannes Henninger 写道:
>> I'm having a weird problem with snapshots and exclusive quotas. After
>> creating a snapshot of a subvolume and setting an exclusive quota of
>> 50MB for the snapshot, everything seems to work fine. I can write
>> approximately 50MB before the quota kicks in.
>>
>> However, if I create a snapshot, set an exclusive quota and just wait
>> for some time, I suddenly cannot even create an empty file because I'm
>> getting a "quota exceeded" error. The time until the bug appears seems
>> to vary. During the waiting time, I'm changing neither the snapshot nor
>> the original subvolume. "qgroup show -e" reports an exclusive use of
>> only a few kilobytes for the snapshot, which is nowhere near the limit.
>>
>> Steps to reproduce (/media/extern is a fresh and empty btrfs partition):
>>
>> Enable quota and create an empty subvolume:
>>      root@t420:/media/extern# btrfs quota enable .
>>      root@t420:/media/extern# btrfs subvolume create sub
>>      Create subvolume './sub'
>>
>> Snapshot the subvolume and set a limit:
>>      root@t420:/media/extern# btrfs subvolume snapshot sub snap
>>      Create a snapshot of 'sub' in './snap'
>>      root@t420:/media/extern# cd snap/
>>      root@t420:/media/extern/snap# btrfs qgroup limit -e 50M .
>>
>> Sometimes it takes "longer" for the quota to kick in, so I'm touching a
>> file every 5 minutes here:
>>
>>      root@t420:/media/extern/snap# for file in {1..100}; do touch $file;
>> sleep 5m; done
>>      touch: cannot touch ‘7’: Disk quota exceeded
>>      ^C
>>      root@t420:/media/extern/snap# btrfs qgroup show -e .
>>      qgroupid         rfer         excl     max_excl
>>      --------         ----         ----     --------
>>      0/5          16.00KiB     16.00KiB         none
>>      0/257        16.00KiB     16.00KiB         none
>>      0/258        16.00KiB     16.00KiB     50.00MiB
>>
>> Any idea why this happens?
> BTW, to make btrfs qgroup show work, it's better to call sync before
> qgroup show.
>
> It's a known bug that even after qgroup accounting rework, qgroup
> reserve still has bug and can cause reserved space to underflow,
> making such problem happen.
>
> For such case, btrfs qgroup show won't help as reserved space is not
> shown in the output.
>
> One workaround would be, umount the filesystem and mount again.
> Which will reset the underflow reserved space and work for sometime.
>
> If it's OK for you to recompile the kernel, you can try the following
> patchset:
> [PATCH v3 00/21] Rework btrfs qgroup reserved space framework
>
> Which should solve the problem.
>
> Thanks,
> Qu
>

Thanks a lot for your reply!

While remounting the filesystem fixes the issue temporary, it doesn't
take very long for the bug to happen again so it's not really a
workaround I can work with.

I did recompile the kernel using your patches, but unfortunately the
problem still appears.

Thanks,
Johannes

