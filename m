Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60722 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951AbbGJEpj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 00:45:39 -0400
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260
 __btrfs_abort_transaction+0x4b/0x120
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
 <558CB0D4.8060401@cn.fujitsu.com> <558CB404.8050300@cn.fujitsu.com>
 <CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
 <CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
 <CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
 <559F131B.30206@cn.fujitsu.com>
 <CAJCQCtQ4j7hjtwmXhmxAqVv6zzQ-PZs2kP5-NsdOKhyCK5P6pg@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <559F4DED.5020005@cn.fujitsu.com>
Date: Fri, 10 Jul 2015 12:45:33 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ4j7hjtwmXhmxAqVv6zzQ-PZs2kP5-NsdOKhyCK5P6pg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Murphy wrote on 2015/07/09 18:45 -0600:
> On Thu, Jul 9, 2015 at 6:34 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> One of my patch addressed a problem that a converted btrfs can't pass
>> btrfsck.
>>
>> Not sure if that is the cause, but if you can try btrfs-progs v3.19.1, the
>> one without my btrfs-progs patches and some other newer convert related
>> patches, and see the result?
>>
>> I think this would at least provide the base for bisect the btrfs-progs if
>> the bug is in btrfs-progs.
>
> I'm happy to regression test with 3.19.1 but I'm confused. After
> conversion, btrfs check (4.1) finds no problems. After ext2_saved
> snapshot is deleted, btrfsck finds no problems. After defrag, again
> btrfsck finds no problems. After the failed balance, btrfsck finds no
> problems but crashes with "Aborted (core dump)".
Even btrfsck reports no error, some btrfs-convert behavior change may 
lead to kernel mis-function.

But we are not sure it's btrfs-progs or kernel itself has bug.
Maybe btrfs convert did something wrong/different triggering the bug, or
just kernel regression?

So hat I'd like to check is, with 3.19.1 progs (kernel version doesn't 
change), whether the kernel still failes to do balance.

If the problem still happens, then  we can focus on kernel part, or at 
least, put at least less effort on btrfs-progs.

>
> Should I still test 3.19.1?
>
Yes, please.

Thanks,
Qu
