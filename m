Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34555 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaASTCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 14:02:44 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and ECC RAM
Date: Sun, 19 Jan 2014 20:02:41 +0100
Message-ID: <1420240.1BEopi7BrR@merkaba>
In-Reply-To: <pan$a84be$d3729bcc$cd2b0fdb$783fe765@cox.net>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de> <pan$a84be$d3729bcc$cd2b0fdb$783fe765@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 18. Januar 2014, 07:16:42 schrieb Duncan:
> Ian Hinder posted on Sat, 18 Jan 2014 01:23:41 +0100 as excerpted:
> > I have been reading a lot of articles online about the dangers of using
> > ZFS with non-ECC RAM.  Specifically, the fact that when good data is
> > read from disk and compared with its checksum, a RAM error can cause the
> > read data to be incorrect, causing a checksum failure, and the bad data
> > might now be written back to the disk in an attempt to correct it,
> > corrupting it in the process.  This would be exacerbated by a scrub,
> > which could run through all your data and potentially corrupt it.  There
> > is a strong current of opinion that using ZFS without ECC RAM is
> > "suicide for your data".
> > 
> > I have been unable to find any discussion of the extent to which this is
> > true for btrfs.  Does btrfs handle checksum errors in the same way as
> > ZFS, or does it perform additional checks before writing "corrected"
> > data back to disk?  For example, if it detects a checksum error, it
> > could read the data again to a different memory location to determine
> > if the error existed in the disk copy or the memory.
> 
> Given the license issues around zfs and linux, zfs is a non-starter for
> me here, and as a result I've never looked particularly closely at how it
> works, so I can't really say what it does with checksums or how that
> compares to btrfs.
> 
> I /can/ however say that btrfs does /not/ work the way described above,
> however.
> 
> When reading data from disk, btrfs will check the checksum.  If it shows
> up as bad and btrfs has another copy of the data available (as it will in
> dup, raid1 or raid10 mode, but not in single or raid0 mode, I'm not
> actually sure how the newer and still not fully complete raid5 and raid6
> modes work in that regard), btrfs will read the other copy and see if
> that matches the checksum.  If it does, the good copy is used and the bad
> copy is rewritten.  If no good copy exists, btrfs fails the read.
> 
> So while I don't know how zfs works and whether your scenario of
> rewriting bad data due to checksum failure could happen there or not, it
> can't happen with btrfs, because btrfs will only rewrite the data if it
> has another copy that matches the checksum.  Otherwise it (normally)
> fails the read entirely.

I think Ian refers to the slight chance that BTRFS assumes the checksum on one 
disk to be incorrect due to a memory error *and* on another disk to be correct 
due to another memory error *and* will silently rewrite the incorrect data to 
the correct data.

AFAIK BTRFS still does not correct such errors automatically, but only on a 
scrub. There this *could* happen theoretically.

My gut feeling is, that this is highly, highly unlikely.

At least not more likely than a controller writing out garbage or other such 
hardware issues.

And for hardware issues there are backups.

I´d probably like if all computers had ECC RAM, but then I heard more than 
once that ECC doesn´t even detect all possible memory errors.

Maybe at one point the kernel will be able to checksum memory pages itself?

Actually I only once had a memory error in a machine which went completely 
undetected under Windows XP, but let Debian and Ubuntu installers segfault at 
random places. This was years ago. I have never notices a memory error since 
then and I am not aware of any co-workers having had memory errors on their 
laptops. But then… those are usually enterprise grade laptops, which to my 
knowledge nonetheless just use RAM without ECC. I don´t think that this 
ThinkPad T520 uses ECC RAM.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
