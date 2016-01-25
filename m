Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38327 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbcAYA2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 19:28:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aNV1X-0006Km-MH
	for linux-btrfs@vger.kernel.org; Mon, 25 Jan 2016 01:28:51 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 01:28:51 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 01:28:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: uknown issues - different sha256 hash - files corruption
Date: Mon, 25 Jan 2016 00:28:46 +0000 (UTC)
Message-ID: <pan$b9def$888b2261$49e72de1$f428a4c9@cox.net>
References: <CAAcrkYJRzvmwdVVYLJ_+LAob=tGQrW3=R7hDfbU_jE3kaD+Kxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Smith posted on Sun, 24 Jan 2016 23:00:55 +0100 as excerpted:

> Dear,
> 
> I have cubox-i4, running debian with 4.4 kernel. The icy box
> IB-3664SU3 enclosure is attached into cubox using esata port,
> enclosure uses JM393 and JM539 chipsets.
> 
> I use btrfs volume in raid0 created from the two drives, and lvm ext4
> volume that contains two drives also. When I copy (using rsync) big
> file (the one i copied is 130GB) from ext4 to btrfs the sha256 hash is
> differs.
> 
> I did 2 tests, copy the source file from ext4 to btrfs, count sha256
> hash, each time the destination file on btrfs has different hash
> compared to the source file located on ext4 and even hashes from both
> runs of target files on btrfs differs.
> 
> I run cmp -l <(hexdump source_file_ext4) <(hexdump target_file_btrfs).
> The snapshot of the result is here http://paste.debian.net/367678/,
> the is so many bytes with differences. The size of the source and
> target file is exactly the same.
> 
> 
> I also copied around 600GB of data set that contains small files,
> music, videos, etc... and i did sha256 on all the files ext4 vs btrfs
> - all was fine.
> 
> Any idea what can cause that issue or how can i debug it in more detail?

My immediate first question is what happens if you do another lvm ext4 on 
the the two devices you're creating the btrfs on?  Does the file sha256 
the same in that case?

Second question, have you run badblocks on the devices in question, and 
what's their smart status (smartctl -A)?

Does repeatedly rsyncing the same file over itself trigger different 
sha256 hashes each time?  Does that result in more hexdump diffs or 
fewer, and do they occur at roughly the same spots in the file or do they 
move around?

What about copying the same file twice (to different subdirs or 
something), so it exists twice on the destination device?  Does that 
change where the diffs occur and do the two copies on the same btrfs 
differ (presumably yes, since copying it twice yielded different hashes).

What about copies from the btrfs to somewhere else on the same btrfs 
(being sure to actually copy the data, not create reflinks)?  Do both 
copies then have the same hash or does it change yet again, and if so, 
are the diffs in the same place or not?

And does an overnite memtest run come up good or not?

The interesting thing with the linked hexdump diff is that its only 38 
bytes different, and they're all in a single 39-byte sequence (there's 
apparently one byte that's the same in the 39 bytes, ...435, so only 38 
bytes different), at just over 38 GB, between 35 and 36 GiB, into the 
file.  That's not on a nice, even boundary and doesn't reoccur say every 
36 GiB or something, so the problem is unlikely to be a block offset 
issue.

It could be bad blocks on the devices in question or bad ESATA 
connections to them, but ordinarily, btrfs would catch that due to its 
own checksumming, and would fail the file read at the bad block, which it 
isn't doing here.  That would tend to indicate that btrfs is saving and 
returning exactly what it was given in the first place, and that the data 
was bad by the time btrfs got it.

But it could be bad memory or a faulty network issue, such that the data 
is already bad by the time btrfs gets it, so it checksums already bad 
data and faithfully returns what it got, but what it got was already bad.

If it's bad memory, then local btrfs to btrfs copies should show random 
differences as well.  If it's a bad network, then local copies should be 
fine, but transfer over the network to ext4 on lvm should turn up random 
differences.


Meanwhile, cubox-i4 means little to me, but FWIW google says freescale 
iMX6 CPU.  But the evidence so far isn't pointing to an arch-specific 
bug.    

I did see, however, a footnote to the effect that while the network port 
is gigabit Ethernet, it's hardware limited to 400-something megabit due 
to bus size and speed on the cubox.  If indicators point to the network 
as being at fault, you might try manually setting it to 100 megabit 
Ethernet instead of gigabit.  That will likely throttle things down far 
enough stabilize things.  Given the evidence so far, I'd put the chance 
of it being network-transfer corruption at 80% or better, and if so, I'd 
give manually setting 100 megabit speed around a 90% chance of fixing it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

