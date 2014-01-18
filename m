Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44326 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbaARHRI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jan 2014 02:17:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W4Q9S-000307-Vj
	for linux-btrfs@vger.kernel.org; Sat, 18 Jan 2014 08:17:06 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Jan 2014 08:17:06 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Jan 2014 08:17:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs and ECC RAM
Date: Sat, 18 Jan 2014 07:16:42 +0000 (UTC)
Message-ID: <pan$a84be$d3729bcc$cd2b0fdb$783fe765@cox.net>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ian Hinder posted on Sat, 18 Jan 2014 01:23:41 +0100 as excerpted:

> I have been reading a lot of articles online about the dangers of using
> ZFS with non-ECC RAM.  Specifically, the fact that when good data is
> read from disk and compared with its checksum, a RAM error can cause the
> read data to be incorrect, causing a checksum failure, and the bad data
> might now be written back to the disk in an attempt to correct it,
> corrupting it in the process.  This would be exacerbated by a scrub,
> which could run through all your data and potentially corrupt it.  There
> is a strong current of opinion that using ZFS without ECC RAM is
> "suicide for your data".
> 
> I have been unable to find any discussion of the extent to which this is
> true for btrfs.  Does btrfs handle checksum errors in the same way as
> ZFS, or does it perform additional checks before writing "corrected"
> data back to disk?  For example, if it detects a checksum error, it
> could read the data again to a different memory location to determine
> if the error existed in the disk copy or the memory.

Given the license issues around zfs and linux, zfs is a non-starter for 
me here, and as a result I've never looked particularly closely at how it 
works, so I can't really say what it does with checksums or how that 
compares to btrfs.

I /can/ however say that btrfs does /not/ work the way described above, 
however.

When reading data from disk, btrfs will check the checksum.  If it shows 
up as bad and btrfs has another copy of the data available (as it will in 
dup, raid1 or raid10 mode, but not in single or raid0 mode, I'm not 
actually sure how the newer and still not fully complete raid5 and raid6 
modes work in that regard), btrfs will read the other copy and see if 
that matches the checksum.  If it does, the good copy is used and the bad 
copy is rewritten.  If no good copy exists, btrfs fails the read.

So while I don't know how zfs works and whether your scenario of 
rewriting bad data due to checksum failure could happen there or not, it 
can't happen with btrfs, because btrfs will only rewrite the data if it 
has another copy that matches the checksum.  Otherwise it (normally) 
fails the read entirely.  

It is possible to turn off btrfs checksumming entirely with a mount 
option, or to turn off both COW and checksumming on an individual file 
using xattributes, but that's definitely not recommended in general (tho 
it is on specific types of files, generally large internal-write files 
that otherwise end up hugely fragmented due to COW).

As George Mitchell mentions in his followup, there's another thread 
discussing ECC memory and btrfs already.  However, the OP in that thread 
didn't explain the alleged problem with zfs (which again, I've no idea 
whether it's true or not, since due to the licensing issues zfs is a flat 
non-starter for me so I've never looked into it that closely) in that 
regard, so all we were able to say was that ECC and btrfs aren't related 
in that way.  At least here you explained a bit about the alleged 
problem, so we can say for sure that btrfs doesn't work that way.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

