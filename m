Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36828 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbcFCT54 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 15:57:56 -0400
Received: by mail-io0-f169.google.com with SMTP id k19so73307204ioi.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 12:57:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464979359.1571.25.camel@gmail.com>
References: <1464977432.1571.20.camel@gmail.com>
	<1464977591.6679.13.camel@scientia.net>
	<1464979359.1571.25.camel@gmail.com>
Date: Fri, 3 Jun 2016 14:57:55 -0500
Message-ID: <CAKZK7uwczSs8LpCB92o08zON8nUkGGoQGB5is_KXSQTkHjvYTg@mail.gmail.com>
Subject: Re: RAID1 vs RAID10 and best way to set up 6 disks
From: Justin Brown <justin.brown@fandingo.org>
To: Mitchell Fossen <msfossen@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Mitchell wrote:
> With RAID10, there's still only 1 other copy, but the entire "original"
disk is mirrored to another one, right?

No, full disks are never mirrored in any configuration.

Here's how I understand Btrfs' non-parity redundancy profiles:

single: only a single instance of a file exists across the file system
dup: two instances of a file exist across the file system, and they
may reside on the same physical disk (4.5.1+ required to use dup
profile on multi-disk file system)
raid1: same as dup but the instances are guaranteed to be on different disks
raid0: single but  can be striped between multiple disks
raid10: data is guaranteed to exist on two separate devices but if n>2
the data is load balanced between disks*

Even though my explanation is imperfect, I hopes that illustrates that
Btrfs RAID is different than traditional RAID. Btrfs provides the same
physical redundancy as RAID, but the implementation mechanisms are
quite a bit different. This has wonderful consequences for
flexibility, and it's what allowed me to run a 5x2TB RAID10 array for
nearly two years and essentially allow complete allocation. The
downside is that since allocations aren't enforced from start (eg. MD
requiring certain number of disks and identical sizes), it's possible
to get weird allocations over time, but the resolution is simple: run
a balance from time to time.

> Christoph wrote:
> Especially, when you have an odd number devices (or devices with
different sizes), its not clear to me, personally, at all how far that
redundancy actually goes respectively what btrfs actually does... could
be that you have your 2 copies, but maybe on the same device then?

RAID1 (and transitively RAID10) guarantees two copies on different
disks, always. Only dup allows the copies to reside on the same disk.
This is guaranteed is preserved, even when n=2k+1 and mixed-capacity
disks. If disks run out of available chunks to satisfy the redundancy
profile, the result is ENOSPC and requires the administrator to
balance the file system before new allocations can succeed. The
question essentially is asking if Btrfs will spontaneously degrade
into "dup" if chunks cannot be allocated on some devices. That will
never happen.


On Fri, Jun 3, 2016 at 1:42 PM, Mitchell Fossen <msfossen@gmail.com> wrote:
> Thanks for pointing that out, so if I'm thinking correctly, with RAID1
> it's just that there is a copy of the data somewhere on some other
> drive.
>
> With RAID10, there's still only 1 other copy, but the entire "original"
> disk is mirrored to another one, right?
>
> On Fri, 2016-06-03 at 20:13 +0200, Christoph Anton Mitterer wrote:
>> On Fri, 2016-06-03 at 13:10 -0500, Mitchell Fossen wrote:
>> >
>> > Is there any caveats between RAID1 on all 6 vs RAID10?
>> Just to be safe: RAID1 in btrfs means not what RAID1 means in any
>> other
>> terminology about RAID.
>>
>> The former has only two duplicates, the later means full mirroring of
>> all devices.
>>
>>
>> Cheers,
>> Chris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
