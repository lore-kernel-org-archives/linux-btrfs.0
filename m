Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1330 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136AbbGaCIb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jul 2015 22:08:31 -0400
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260
 __btrfs_abort_transaction+0x4b/0x120
To: Robert Munteanu <robert.munteanu@gmail.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
 <558CB0D4.8060401@cn.fujitsu.com> <558CB404.8050300@cn.fujitsu.com>
 <CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
 <CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
 <CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
 <559F131B.30206@cn.fujitsu.com>
 <CAC8ULPaOWS=WS-_oSkihrzi7bnWXuevyqL3R7FPFFQQCdjqdvA@mail.gmail.com>
 <CAC8ULPaYmQNj_cvgGxqKtJ4w237J5vAJFTQMO1=o+y+eUYrPLg@mail.gmail.com>
CC: Chris Murphy <lists@colorremedies.com>, Vytautas D <vytdau@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55BAD89A.8030203@cn.fujitsu.com>
Date: Fri, 31 Jul 2015 10:08:26 +0800
MIME-Version: 1.0
In-Reply-To: <CAC8ULPaYmQNj_cvgGxqKtJ4w237J5vAJFTQMO1=o+y+eUYrPLg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Robert Munteanu wrote on 2015/07/30 16:16 +0300:
>> The disk image (still) contains sensitive data so I can't share it
>> unfortunately. What I can do is keep it untouched until Friday evening
>> EEST and run any debugging commands that you might think of to trace
>> down the source of the errors. Alternatively, if there's an easy and
>> safe fix and debugging is not worth it, I'm happy to apply that fix as
>> well.
>
>
> Based on the results of running btrfs check --repair on an image file
> taken from the actual disk I ran a btrfs check --repair on the
> physical partition
>
> The output was ( again, re-typed so might contain typos )
>
> # btfrs check --repair /dev/sda1
> enabling repair mode
> repair mode will force to clear out log tree, Are you sure [y/N]: y
> Checking filesystem on /dev/sda1
> UUID: ...
> checking extents
> Fixed 0 roots.
> checking free space cache.
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> Fixed discount file extends for inode: 14214570 in root: 5
> root 5 inode 14214570 errors 100, file extend discount
> Found file extent holes:
> Fixed discount file extends for inode: 14214570 in root: 5
> root 5 inode 14214570 errors 100, file extend discount
> Found file extent holes:
Any full output about it?

Not sure if it real loops, but maybe the inode number changed in later 
output?

Thanks,
Qu

>
> The previous 3 lines repeat a lot, every 10 seconds maybe. After 30
> minutes I got bored and stopped the process, as it looks like it's
> looping at some condition that without making any progress. At any
> rate, something worked well and I can now mount the volume again from
> the rescue disk and boot from a read-only snapshot.
>
> Cheers,
>
> Robert
>
