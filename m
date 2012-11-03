Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59187 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761931Ab2KCAPI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Nov 2012 20:15:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TUROL-0002f6-Hw
	for linux-btrfs@vger.kernel.org; Sat, 03 Nov 2012 01:15:13 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Nov 2012 01:15:13 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Nov 2012 01:15:13 +0100
To: linux-btrfs@vger.kernel.org
From: Gabriel <g2p.code@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
Date: Sat, 3 Nov 2012 00:14:53 +0000 (UTC)
Message-ID: <k71nlt$7go$5@ger.gmane.org>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
	<201211021218.29778.Martin@lichtvoll.de> <5093B658.3000007@gmail.com>
	<k715i0$7go$1@ger.gmane.org> <20121102220604.GC28864@carfax.org.uk>
	<k71kl2$7go$3@ger.gmane.org> <20121102234419.GD28864@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 02 Nov 2012 23:44:19 +0000, Hugo Mills wrote:
> On Fri, Nov 02, 2012 at 11:23:14PM +0000, Gabriel wrote:
>> On Fri, 02 Nov 2012 22:06:04 +0000, Hugo Mills wrote:
>> >    I've not considered the full semantics of all this yet -- I'll try
>> > to do that tomorrow. However, I note that the "×2" here could become
>> > non-integer with the RAID-5/6 code (which is due Real Soon Now). In
>> > the first RAID-5/6 code drop, it won't even be simple to calculate
>> > where there are different-sized devices in the filesystem. Putting an
>> > exact figure on that number is potentially going to be awkward. I
>> > think we're going to need kernel help for working out what that number
>> > should be, in the general case.
>> 
>> DUP can be nested below a device because it represents same-device
>> redundancy (purpose: survive smudges but not device failure).
>> 
>> On the other hand raid levels should occupy the same space on all
>> linked devices (a necessary consequence of the guarantee that RAID5
>> can survive the loss of any device and RAID6 any two devices).
> 
>    No, the multiplier here is variable. Consider:
> 
> 1 MiB stored in RAID-5 across 3 devices takes up 1.5 MiB -- multiplier ×1.5
>    (1 MiB over 2 devices is 512 KiB, plus an additional 512 KiB for parity)
> 1 MiB stored in RAID-5 across 6 devices takes up 1.2 MiB -- multipler ×1.2
>    (1 MiB over 5 devices is 204.8 KiB, plus an additional 204.8 KiB for parity)
> 
>    With the (initial) proposed implementation of RAID-5, the
> stripe-width (i.e. the number of devices used for any given chunk
> allocation) will be *as many as can be allocated*. Chris confirmed
> this today on IRC. So if I have a disk array of 2T, 2T, 2T, 1T, 1T,
> 1T, then the first 1T of allocation will stripe across 6 devices,
> giving me 5 data+1 parity, or a multiplier of ×1.2. As soon as the
> smaller devices are full, the stripe width will drop to 3 devices, and
> we'll be using 2 data+1 parity allocation, or a multiplier of ×1.5 for
> any subsequent chunks. So, as more data over the first 5T is stored,
> the multiplier steadily decreases, until we fill the FS, and we get a
> multiplier of ×1.35 overall. This gets more complicated if you have
> devices of many different sizes. (Imagine 6 disks with sizes 500G, 1T,
> 1.5T, 2T, 3T, 3T).
> 
>    We probably can work out the current RAID overhead and feed it back
> sensibly, but it's (a) not constant as the allocation of the chunks
> increases, and (b) not trivial to compute.

All right, your example does illustrate things better. And I had no
idea about the implementation, but the as-many-stripes-as-possible
logic does make sense.

That doesn't break the sketch I made; I used RAIDn(device list)
as the block heading.

Your first example becomes:
RAID5(disk[1-6]), up to 6⁄5×5T.

Once that is filled we add a second block:
RAID5(disk[1-6])
  (the usual grid: free, reserved; data metadata system)
RAID5(disk[1-3]), 3⁄2×2T more.
  (the usual grid)

For proper reporting of free space we either need the kernel
to reserve all the blocks and tell us about them, or just some
info about the kernel's policy.
RAID5 with maximum stripes and no reduced redundancy is enough
info to compute the rest in userspace. Though the block approach
will be more reliable if the kernel has to make complicated policy
decisions, like the choice to reshape after device failure.

>> The two probably won't need to be represented at the same time
>> except during a reshape, because I imagine DUP gets converted to
>> RAID (1 or 5) as soon as the second device is added.
>> 
>> A 1→2 reshape would look a bit like this (doing only the data column
>> and skipping totals):
>> 
>> InitialDevice
>>   Reserved           1.21TB
>>   Used               1.21TB
>> RAID1(InitialDevice, SecondDevice)
>>   Reserved   1.31TB + 100GB
>>   Used             2× 100GB
>> 
>> RAID5, RAID6: same with fractions, n+1⁄n and n+2⁄n.
> 
>    Except that n isn't guaranteed to be constant. That was pretty much
> my only point. Don't assume that it will be (or at the very least, be
> aware that you are assuming it is, and be prepared for inconsistencies).
> 
>    Hugo.


