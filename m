Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53214 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbbKOECG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 23:02:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZxoVv-0002YZ-4g
	for linux-btrfs@vger.kernel.org; Sun, 15 Nov 2015 05:02:03 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2015 05:02:03 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2015 05:02:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using Btrfs on single drives
Date: Sun, 15 Nov 2015 04:01:57 +0000 (UTC)
Message-ID: <pan$eeab5$356873bd$675c810f$20fe76ea@cox.net>
References: <CA+LE0jwrdpjmJhwmG9Yv5HjqZh28-yp3Man8NSmXqCoB=JJ=Ew@mail.gmail.com>
	<CA+LE0jyvd8f=z8GR7V2=cLzV3Khfn1YpEHka5-6k0JiSPa5-+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

audio muze posted on Sun, 15 Nov 2015 05:27:00 +0200 as excerpted:

> I've gone ahead and created a single drive Btrfs filesystem on a 3TB
> drive and started copying content from a raid5 array to the Btrfs
> volume.  Initially copy speeds were very good sustained at ~145MB/s and
> I left it to run overnight.  This morning I ran btrfs fi usage
> /mnt/btrfs and it reported around 700GB free.  I selected another folder
> containing 204GB and started a copy operation, again from the raid5
> array to the Btrfs volume.  Copying is now materially slower and slowing
> further...it started at ~105MB/s and after 141GB has slowed to around
> 97MB/s.  Is this to be expected with Btrfs of have I come across a bug
> of some sort?

That looks to /me/ like native drive limitations.

Due to the fact that a modern hard drive spins at the same speed no 
matter where the read/write head is located, when it's reading/writing to 
the first part of the drive -- the outside -- much more linear drive 
distance will pass under the read/write heads in say a tenth of a second 
than will be the case as the last part of the drive is filled -- the 
inside -- and throughput will be much higher at the first of the drive.

You report a 3 TB drive with initial/outside speeds of ~145 MB/s, then 
after copying quite some data, in the morning it had ~700 GB free, so 
presumably you had written something over 2 TB to it.  I'll leave the 
precise math to someone else, but you report that it started the second 
copy at 105 MB/s and was down to 97 MB/s after another 141 GB, so 
presumably ~550 GB free.  That's a slowdown of roughly a third from the 
initial outside edge where it was covering perhaps twice as much linear 
drive distance per unit of time, so it doesn't sound at all unreasonable 
to me.

What's the actual extended sequential write throughput rating on the 
drive?  What do the online reviews of the product say it does?  Have you 
used hdparm to test it?

It's kinda late for this test now, but if before creating a big 
filesystem out of the whole thing, if for testing you had created a small 
partition at the beginning of the drive, and another at the end, you 
could have then used hdparm to test each to see what the relative speed 
difference was between them, and further, if desired, you could have 
created small partitions at specific size locations into the drive, and 
done similar testing, to find the speed at say 1 TB into the drive, 2 TB 
in, etc.  Of course after testing you could erase those temporary 
partitions and make one big filesystem out of it, if desired.

Of course this is one of the big differences with SSDs, since they aren't 
spinning any longer and have direct access to any part of the device with 
just an address change, so speeds for them, in addition to being far 
faster, should normally be the same across the device.  But of course 
they cost far more per GB or TB, and tend to be vastly more expensive in 
the TB+ size ranges, tho you can of course combine many smaller ones 
using raid technologies to create a larger logical one, but you'll still 
be paying a marked premium for the SSD technology.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

