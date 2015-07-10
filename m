Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41613 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751413AbbGJAej (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 20:34:39 -0400
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260
 __btrfs_abort_transaction+0x4b/0x120
To: Chris Murphy <lists@colorremedies.com>, Vytautas D <vytdau@gmail.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
 <558CB0D4.8060401@cn.fujitsu.com> <558CB404.8050300@cn.fujitsu.com>
 <CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
 <CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
 <CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
CC: Robert Munteanu <robert.munteanu@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <559F131B.30206@cn.fujitsu.com>
Date: Fri, 10 Jul 2015 08:34:35 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of my patch addressed a problem that a converted btrfs can't pass 
btrfsck.

Not sure if that is the cause, but if you can try btrfs-progs v3.19.1, 
the one without my btrfs-progs patches and some other newer convert 
related patches, and see the result?

I think this would at least provide the base for bisect the btrfs-progs 
if the bug is in btrfs-progs.

Thanks,
Qu

Chris Murphy wrote on 2015/07/09 15:38 -0600:
> On Thu, Jul 9, 2015 at 4:52 AM, Vytautas D <vytdau@gmail.com> wrote:
>> <Slightly off topic>
>>
>> does these bugs exist in systems that converted from ext4 to btrfs using
>> kernel 3.13 and then upgraded to kernel 4.1 ?
>
> I don't recall what btrfs-progs and kernel I last tested ext4
> conversion with. I know this is a regression, I just don't know how
> old it is. I think there's more than one bug here (obviously since
> I've filed 4 related bugs in ~24 hours), but I really don't know the
> scope of the problem. But the case where the recommended procedure not
> only fails but corrupts the file system and it can't be fixed or
> rolled back, is not good.
>
> Perhaps the wiki should provide a warning that this is currently
> broken, status unknown, or something?
>
