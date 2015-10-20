Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37737 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbbJTVZg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 17:25:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZoePU-0007cs-GI
	for linux-btrfs@vger.kernel.org; Tue, 20 Oct 2015 23:25:32 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 23:25:32 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 23:25:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
Date: Tue, 20 Oct 2015 21:24:54 +0000 (UTC)
Message-ID: <pan$19a41$faa0e7e5$55c66e58$7ec1fc3a@cox.net>
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
	<pan$312c1$94a948da$df1250c5$4706911@cox.net> <56269A77.1080709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Tue, 20 Oct 2015 15:48:07 -0400 as
excerpted:

> FWIW, my assessment is based on some testing I did a while back (kernel
> 3.14 IIRC) using a VM.  The (significantly summarized of course)
> procedure I used was:
> 1. Create a basic minimalistic Linux system in a VM (in my case, I just
> used a stage3 tarball for Gentoo, with a paravirtuaized Xen domain)
> using BTRFS as the root filesystem with a raid1 setup.  Make sure and
> verify that it actually boots.
> 2. Shutdown the VM, use btrfs-progs on the host to find the physical
> location of an arbitrary file (ideally one that is not touched at all
> during the boot process, IIRC, I think I used one of the e2fsprogs
> binaries), and then intentionally clear the CRC in one of the copies of
> a block from the file.
> 3. Boot the VM, read the file.
> 4. Shutdown the VM again.
> 5. Verify whether the file block you cleared the checksum on has a valid
> checksum now.
> 
> I repeated this more than a dozen times using different files and
> different methods of reading the file, and each time the CRC I had
> cleared was untouched.  Based on this, unless BTRFS does some kind of
> deferred re-write that doesn't get forced during a clean unmount of the
> FS, I felt it was relatively safe to conclude that it did not
> automatically fix corrupted blocks.  I did not however, test corrupting
> the block itself instead of the checksum, but I doubt that that would
> impact anything in this case.

AFAIK:

1) It would only run into the corruption if the raid1 read-scheduler 
picked that copy based on the even/odd of the requesting PID.

However, statistically that should be a 50% hit rate and if you tested 
more than a dozen times, you'd have quite the luck to fail to hit it on 
at least /one/ of them.

2) (Based on what I understood from the discussion of btrfs check's init-
csum-tree patches a couple cycles ago, before which it was clearing but 
not reinitializing...) Btrfs interprets missing checksums differently 
than invalid checksums.  Would your "cleared" CRC be interpreted as 
invalid or missing?  If missing, AFAIK it would leave it missing.

In which case corrupting the data block itself would indeed have had a 
different result than "clearing" the csum, tho simply corrupting the csum 
should have resulted in an update.

However, by actually testing you've gone farther than I have, and pending 
further info to the contrary, I'll yield to that, changing my own 
thoughts on the matter as well, to "I formerly thought... but someone's 
testing some versions ago anyway suggested otherwise, so being too lazy 
to actually do my own testing, I'll cautiously agree with the results of 
his."

=:^)

Thanks.  I'd rather find out I was wrong, than not find out! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

