Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46619 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbbFQAvW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 20:51:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z51ZS-00087w-Nd
	for linux-btrfs@vger.kernel.org; Wed, 17 Jun 2015 02:51:14 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 02:51:14 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 02:51:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Replacing a drive from a RAID 1 array
Date: Wed, 17 Jun 2015 00:51:07 +0000 (UTC)
Message-ID: <pan$dac84$64f98ae$82762b56$a7dc0d79@cox.net>
References: <CAOQP4cG2344VZYT8eZ4=MJzi_KsdzH7pxFJ+ZpOTXtdDOrXRyQ@mail.gmail.com>
	<20150616165832.GN9850@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Tue, 16 Jun 2015 16:58:32 +0000 as excerpted:

> On Tue, Jun 16, 2015 at 06:43:23PM +0200, Arnaud Kapp wrote:
>> 
>> Consider the following situation: I have a RAID 1 array with 4 drives.
>> I want to replace one the drive by a new one, with greater capacity.
>> 
>> However, let's say I only have 4 HDD slots so I cannot plug the new
>> drive, add it to the array then remove the other one.
>> If there a *safe* way to change drives in this situation? I'd bet that
>> booting with 3drives, adding the new one then removing the old, non
>> connected one would work. However, is there something that could go
>> wrong in this situation?
> 
> The main thing that could go wrong with that is a disk failure.

Agreed with Hugo (and Chris), but there's a couple additional factors to 
consider that they didn't mention.

1) Btrfs raid1, unlike for example mdraid raid1, is two copies, 
regardless of the number of devices.  More devices results in more 
storage capacity, not more copies and thus more redundancy.

So physical removal of a device from a btrfs raid1 means you only have 
one copy left of anything that was on that device, since there's only two 
copies and you just removed the device containing one of them.

Which of course is why the device failure Hugo mentioned is so critical, 
because that would mean loss of the other copy for anything where the 
second copy was on the newly failed device. =:^(

2) Btrfs' data integrity feature adds another aspect to btrfs raid1 that 
normal raid1 doesn't deal with.  The great thing about btrfs raid1 is 
that both copies of the data (and metadata) are checksummed, and in 
normal operation, should one copy fail its checksum validation, btrfs can 
check the second copy and assuming it's fine, use it, while rewriting the 
checksum-failure copy with the good one.

Thus, removing one of those two copies has the additional aspect that if 
the remaining one is now found to be bad, there's no fallback, and that 
file (for data) is simply unavailable.  For bad metadata the problem is 
of course worse, as that bad metadata very likely covered multiple files 
and possibly directories, and you will likely lose access to them all.

The overall effect, then, is to take the device-failure possibility from 
the whole device level to the individual file level.  While failure of 
the whole device may be considered unlikely, on today's multi-terabyte 
devices, there's statistically actually a reasonable chance of at least 
one failure on each device.  If your devices become that statistic, and 
whatever one remaining copy ends up bad while the device with the other 
copy is unavailable...

The bottom line is that with a device and its copy removed, there's a 
reasonable statistical chance you'll lose access to at least one file 
because the remaining copy is found to fail checksum and be bad.

Which of course makes it even MORE important to if at all possible 
arrange a way to keep the to-be-removed device online, via a temporary 
hookup if necessary, while running the replace that will ultimately move 
its contents to another device.  Playing with the odds is acceptable when 
a device failed and there's no other way (tho as always, the sysadmin's 
rule that if you didn't have a backup, by definition and by (lack of) 
action, you didn't care about that data, despite any claims to the 
contrary, most definitely applies), but if you have a choice, don't play 
the odds, play it smart.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

