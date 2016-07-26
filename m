Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33178 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbcGZROj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 13:14:39 -0400
Received: by mail-io0-f196.google.com with SMTP id y195so2590747iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jul 2016 10:14:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f7de852d-86de-b438-e79f-c57666c7d0e4@gmail.com>
References: <1469194929-27647-1-git-send-email-lkml.page@gmail.com> <f7de852d-86de-b438-e79f-c57666c7d0e4@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 26 Jul 2016 11:14:37 -0600
Message-ID: <CAJCQCtTFGMku4FJZN7oH4=UV+F+Tz_FLD7RbUE5JWgaQKFtH4A@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: Make RAID stripesize configurable
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Sanidhya Solanki <lkml.page@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 22, 2016 at 8:58 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-07-22 09:42, Sanidhya Solanki wrote:

>> +*stripesize=<number>*;;
>> +Specifies the new stripe size

It'd be nice to stop conflating stripe size and stripe element size as
if they're the same thing. I realize that LVM gets this wrong also,
and uses stripes to mean "data strips", and stripesize for stripe
element size. From a user perspective I find the inconsistency
annoying, users are always confused about these terms.

So I think we need to pay the piper now, and use either strip size or
stripe element size for this. Stripe size is the data portion of a
full stripe read or write across all devices in the array. So right
now with a 64KiB stripe element size on Btrfs, the stripe size for a 4
disk raid0 is 256KiB, and the stripe size for a 4 disk raid 5 is
192KiB.



>for a filesystem instance. Multiple BTrFS
>> +filesystems mounted in parallel with varying stripe size are supported,
>> the only
>> +limitation being that the stripe size provided to balance in this option
>> must
>> +be a multiple of 512 bytes, and greater than 512 bytes, but not larger
>> than
>> +16 KiBytes.

It's 64KiB right now. Why go so much smaller?

mdadm goes from 4KiB to GiB's, with a 512KiB default.

lvm goes from 4KiB to the physical extent size, which can be GiB's.

I'm OK with an upper limit that's sane, maybe 16MiB? Hundreds of MiB's
or even GiB's seems a bit far fetched but other RAID tools on Linux
permit that.



> I'm actually somewhat curious to see numbers for sizes larger than 16k. In
> most cases, that probably will be either higher or lower than the point at
> which performance starts suffering.  On an set of fast SSD's, that's almost
> certainly lower than the turnover point (I can't give an opinion on BTRFS,
> but for DM-RAID, the point at which performance starts degrading
> significantly is actually 64k on the SSD's I use), while on a set of
> traditional hard drives, it may be as low as 4k (yes, I have actually seen
> systems where this is the case).  I think that we should warn about sizes
> larger than 16k, not refuse to use them, especially because the point of
> optimal performance will shift when we get proper I/O parallelization.  Or,
> better yet, warn about changing this at all, and assume that if the user
> continues they know what they're doing.

OK well maybe someone wants to inform the mdadm and LVM folks that
their defaults are awfully large for SSD's. It's been quite a long
time both were using 64KiB to no ill effect on hard drives, and maybe
5 years ago that mdadm moved to a 512KiB default.

I think allowing the user to specify 512 byte strip sizes is a bad
idea. This will increase read-modify-write by the drive firmware on
all modern HDD's now that use 4096 byte physical sectors, and SSDs
with page sizes 16KiB or greater being common. Ideally we'd have a way
of knowing the page size of the drive set that as the minimum, rather
than a hard coded minimum.



-- 
Chris Murphy
