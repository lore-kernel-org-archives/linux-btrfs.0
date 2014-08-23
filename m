Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50365 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbaHWF4n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 01:56:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XL4Je-0006ug-Bg
	for linux-btrfs@vger.kernel.org; Sat, 23 Aug 2014 07:56:42 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 07:56:42 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 07:56:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted
 in various ways
Date: Sat, 23 Aug 2014 05:56:28 +0000 (UTC)
Message-ID: <pan$3fa9$3263e6a0$42fec4bc$6017376e@cox.net>
References: <20140822155040.GU3875@merlins.org>
	<pan$a7366$366442ed$60aa89a1$c636b8e3@cox.net>
	<20140822184919.GE3875@merlins.org>
	<pan$644c4$e5e83b2d$34cd9e4d$75795b7@cox.net>
	<20140823031055.GH3875@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Fri, 22 Aug 2014 20:10:55 -0700 as excerpted:

> On Sat, Aug 23, 2014 at 02:52:16AM +0000, Duncan wrote:
>> > For mysql, I got:
>> > InnoDB: Page directory corruption:
>> > infimum not pointed to 140708 11:53:58 InnoDB: Page dump in ascii and
>> > hex (16384 bytes):
>> > len 16384; hex 00000000(16KB of 0's).
>> 
>> Is that on ssd or spinning rust, and if ssd, do you run with
>> trim/discard and/or have you filled the device yet if not (since
>> mkfs.btrfs trims the device as part of the process)?  I'm wondering if
>> that's 4 4 KiB btrfs data blocks of trimmed and unwritten SSD?
> 
> It's on SSD, I do have trim/discard, I never filled the device.
> 
> But I could totally remove trim and see what happens. I'll do that.

You'd probably have to mostly fill up the device with garbage and then 
delete it (with discard off) before it's return anything but already 
trimmed/zeroed blocks, since if I'm correct it's pre-allocating a bunch 
but then not actually writing it before the crash.  It'd be pre-
allocating from what it thought was free space, so as long as most of 
that free space hasn't been written at all since it was trimmed, you'd 
still likely get zeros even after turning trim off.  Only after you have 
written something to that space and then deleted it, would the chance of 
coming up "dirty" increase dramatically.

That is of course assuming the pre-allocation doesn't pre-zero as well, 
which it might.

It just struck me that with trim on, a bunch of zero-blocks is what you'd 
expect from free-space, which is what a COW filesystem would be 
allocating from when there's a write into a database file like that 
(assuming it's not set NOCOW).  On spinning rust or without trim/discard 
set, unzeroed garbage would accumulate in the free space over time, and a 
full 16 KiB of zeros would be far more interesting, as that would mean 
something's actually zeroing it but that mysql isn't getting data written 
back to it after the zeroing, before the crash.

Of course that begs the question of whether it was a normal COW file or 
if you had it NOCOW.  Setting it NOCOW (of course doing the correct set 
the directory NOCOW, copy the file into it dance, so it's NOCOW from the 
beginning) could be interesting too, and may in fact actually eliminate 
the problem depending on how mysql handles such things.  Presumably it 
has some sort of database resiliency scheme as most filesystems don't do 
the checksumming that btrfs does so it can't rely on that, and my 
argument has always been that in some cases it might actually be better 
to let the database handle it how it normally does with ordinary 
filesystems and not try to get in the way, which is what NOCOW basically 
does, tell btrfs to let the application handle that file and not to 
interfere.  It'd be interesting to see how well my hypothesis holds up, 
anyway.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

