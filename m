Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f51.google.com ([209.85.216.51]:42241 "EHLO
	mail-vn0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbbGNX3V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 19:29:21 -0400
Received: by vnbf62 with SMTP id f62so2728912vnb.9
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 16:29:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559F4DED.5020005@cn.fujitsu.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
	<558CB0D4.8060401@cn.fujitsu.com>
	<558CB404.8050300@cn.fujitsu.com>
	<CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
	<CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
	<CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
	<559F131B.30206@cn.fujitsu.com>
	<CAJCQCtQ4j7hjtwmXhmxAqVv6zzQ-PZs2kP5-NsdOKhyCK5P6pg@mail.gmail.com>
	<559F4DED.5020005@cn.fujitsu.com>
Date: Tue, 14 Jul 2015 17:29:20 -0600
Message-ID: <CAJCQCtQC822+PF9eo9s9sQURG7gEaEnLz2CwREYaDrwXD4CG4Q@mail.gmail.com>
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 9, 2015 at 10:45 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Chris Murphy wrote on 2015/07/09 18:45 -0600:
>>
>> On Thu, Jul 9, 2015 at 6:34 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>
>>> One of my patch addressed a problem that a converted btrfs can't pass
>>> btrfsck.
>>>
>>> Not sure if that is the cause, but if you can try btrfs-progs v3.19.1,
>>> the
>>> one without my btrfs-progs patches and some other newer convert related
>>> patches, and see the result?
>>>
>>> I think this would at least provide the base for bisect the btrfs-progs
>>> if
>>> the bug is in btrfs-progs.
>>
>>
>> I'm happy to regression test with 3.19.1 but I'm confused. After
>> conversion, btrfs check (4.1) finds no problems. After ext2_saved
>> snapshot is deleted, btrfsck finds no problems. After defrag, again
>> btrfsck finds no problems. After the failed balance, btrfsck finds no
>> problems but crashes with "Aborted (core dump)".
>
> Even btrfsck reports no error, some btrfs-convert behavior change may lead
> to kernel mis-function.
>
> But we are not sure it's btrfs-progs or kernel itself has bug.
> Maybe btrfs convert did something wrong/different triggering the bug, or
> just kernel regression?
>
> So hat I'd like to check is, with 3.19.1 progs (kernel version doesn't
> change), whether the kernel still failes to do balance.
>
> If the problem still happens, then  we can focus on kernel part, or at
> least, put at least less effort on btrfs-progs.
>
>>
>> Should I still test 3.19.1?

I'm not able to reproduce this for reasons I don't understand. The
setup is in a qemu-kvm VM, with the ext4 original as a qcow2. I had
been using 'qemu-img create -f qcow2 -o nocow=on -b original.qcow2
converted qcow2' and then doing the conversions with the
converted.qcow2 file in the VM. I did this half a dozen times and
always at the balance step it imploded (but differently for 4.1 and
4.2). Now the balance completes with no errors. btrfs check doesn't
complaint either. Very irritating as nothing else has changed with
that VM.

There is another user who had this similar problem with the converted
ext4 going read-only. They ran btrfs check with both 3.19.1 and 4.0.
Their results are here, hopefully it's helpful until I can figure out
how to get this reproducing again.
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg44701.html



-- 
Chris Murphy
