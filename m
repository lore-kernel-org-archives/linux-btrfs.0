Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33154 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbbLaNcH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 08:32:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aEdKn-0002g6-QS
	for linux-btrfs@vger.kernel.org; Thu, 31 Dec 2015 14:32:06 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 14:32:05 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 14:32:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID10 question
Date: Thu, 31 Dec 2015 13:31:59 +0000 (UTC)
Message-ID: <pan$b2d51$f981c36c$54145fc4$c0b07bc0@cox.net>
References: <47770e1d8a804d31994eebaf733adf55@nex-exchng-01-v.bcn.nexica.com>
	<20151231115153.GW1586@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Thu, 31 Dec 2015 11:51:53 +0000 as excerpted:

> On Thu, Dec 31, 2015 at 09:52:16AM +0000, Xavier Romero wrote:
>> Hello,
>> 
>> I have 2 completely independent set of 12 disks each, let's name them
>> A1, A2, A3... A12 for first set, and B1, B2, B3...B12 for second set.
>> For availability purposes I want disks to be paired that way:
>> A1 <--> B1: RAID1 A2 <--> B2: RAID1 ...
>> A12 <--> B12: RAID1
>> 
>> And then I want a RAID0 out of all these RAID1.
>> 
>> I know I can achieve that by doing all the RAID1 with MD and then build
>> the RAID0 with BTRFS. But my question is: can I achieve that directly
>> with BTRFS RAID10?
> 
>    No, not at the moment.

Additionally, if you're going to put btrfs on mdraid, then you may wish 
to consider reversing the above, doing raid01, which while ordinarily 
discouraged in favor of raid10, has some things going for it when the top 
level is btrfs, that raid10 doesn't.

The btrfs feature in question here is data and metadata checksumming and 
file integrity.  Btrfs normally checksums all data and metadata and 
verifies checksums at read-time, but when there's only one copy, as is 
the case with btrfs single and raid0 modes, if there's a checksum verify 
failure, all it can do is report it and fail the read.  If however, 
there's a second copy, as there is with btrfs raid1, then a checksum 
failure on the first copy will automatically failover to trying the 
second.  Assuming the second copy is good, it will use that instead of 
failing the read, and btrfs scrub can be used to systematically scrub and 
detect (if single/raid0 mode) or repair (if raid1/10 mode and the other 
copy is good) the entire filesystem.

Mdraid doesn't have that sort of integrity verification.  All it does 
with raid1 scrub is check that the copies agree, and pick an arbitrary 
copy to replace the other one with if they don't.  But for all it or you 
know, it can be replacing the good copy with the bad one, since it has no 
checksum verification to tell which is actually the good copy.

If that sort of data integrity verification and repair is of interest to 
you, you obviously want btrfs raid1, not mdraid1.  But btrfs, as the 
filesystem, must be the top layer.  So while raid10 is normally preferred 
over raid01, in this case, you may want to do raid01, putting the btrfs 
raid1 on top of the mdraid0.

Unfortunately that won't let you do a1 <-> b1, a2 <-> b2, etc.  But it 
will let you do a[1-6] <-> b[1-6], if that's good enough for your use-
case.

IOW, you have to choose between btrfs raid1 with data integrity repair on 
top, with only two mdraid0's underneath, or btrfs raid0 with only data 
integrity detection, not repair, on top, and a bunch of mdraid1 that 
don't have data integrity at all, underneath.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

