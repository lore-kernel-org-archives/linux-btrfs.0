Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38387 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbcDVB1V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 21:27:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1atPsA-0003UZ-7U
	for linux-btrfs@vger.kernel.org; Fri, 22 Apr 2016 03:27:06 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2016 03:27:06 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2016 03:27:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid5 replace disk problems
Date: Fri, 22 Apr 2016 01:27:00 +0000 (UTC)
Message-ID: <pan$5e9ab$9014ea0$e77555ac$b04d89bc@cox.net>
References: <5718ED2B.2090406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jussi Kansanen posted on Thu, 21 Apr 2016 18:09:31 +0300 as excerpted:

> The replace operation is super slow (no other load) with avg. 3x20MB/s
> (old disks) reads and 1.4MB/s write (new disk) with CFQ scheduler. Using
> deadline schd. the performance is better with avg. 3x40MB/s reads and
> 4MB/s write (both schds. with default queue/nr_requests).
> 
> Write speed seems slow but guess it possible if there's a lot random
> writes but why is the difference between data read vs. written so large?
> According to iostat replace reads 35 times more data than it writes to
> the new disk.
> 
> 
> Info:
> 
> kernel 4.5 (now 4.5.2, no change)
> btrfs-progs 4.5.1

[Just a btrfs using admin and list regular, not a dev.  Also, raid56 
isn't my own use-case, but I am following it in general on the list.]

Keep in mind that btrfs raid56 mode (aka parity raid mode) remains less 
mature and stable than non-parity raid modes such as raid1 and raid10, 
and of course single-device mode with single data and single or dup 
metadata, as well.  It's certainly /not/ considered stable enough for 
production usage at this point, and other alternatives such as btrfs 
raid1 or raid10 or use of a separate raid layer (btrfs raid1 on top of a 
pair of mdraid0s is one interesting solution) are actively recommended.

And you're not the first to report super-slow replace/restripe for raid56, 
either.  It's a known bug, tho as it doesn't seem to affect everyone it 
has been hard to pin down appropriately and fix.  The worst part is that 
for those affected, replace and restripe are so slow that they cease to 
be real-world practical, and endanger the entire array because at that 
speed there's a relatively large chance that another device may fail 
before the replace is completed, failing the entire array as more devices 
have failed than it can handle.  Which means from a reliability 
perspective it effectively degrades to slow raid0 as soon as the first 
device drops out, with no practical way of recovering back to raid5/6 
mode.

I don't recall seeing the memory issue reported before in relation to 
raid56, but it isn't horribly surprising either.  IIRC there have been 
some recent memory fix patches that so 4.6 might be better, but I 
wouldn't count on it.  I'd really just recommend getting off of raid56 
mode for now, until it has had somewhat longer to mature.

(I'm previously on record as suggesting that people wait at least a year, 
~5 kernel cycles, from nominal full raid56 support for it to stabilize, 
and then asking about current state on the list, before trying to use it 
for anything but testing with throw-away data.  With raid56 being 
nominally complete in 3.19, that would have been 4.4 at the earliest, and 
for a short time around then it did look reasonable, but then this bug 
with extremely long replace/restripe times began showing up on the list, 
and until that's traced down and fixed, I just don't see anyone 
responsible using it except of course for testing and hopefully fixing 
this thing.  I honestly don't know how long that will be or if there are 
other bugs lurking as well, but given 4.6 is nearing release and I don't 
believe the bug has even been fully traced down yet, 4.8 is definitely 
the earliest I'd say consider it again, and a more conservative 
recommendation might be to ask again around 4.10.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

