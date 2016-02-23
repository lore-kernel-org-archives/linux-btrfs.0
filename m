Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54546 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbcBWXRO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 18:17:14 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aYMCe-0008JY-6d
	for linux-btrfs@vger.kernel.org; Wed, 24 Feb 2016 00:17:12 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 00:17:12 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 00:17:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Documentation for BTRFS error (device dev): bdev /dev/xx errs:
 wr 22, rd 0, flush 0, corrupt 0, gen 0
Date: Tue, 23 Feb 2016 23:17:06 +0000 (UTC)
Message-ID: <pan$1ce2f$38765775$42544d39$1c9fd0a5@cox.net>
References: <20160223215911.GA13811@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Tue, 23 Feb 2016 13:59:11 -0800 as excerpted:

> I have a freshly created md5 array, with drives that I specifically
> scanned one by one block by block, and for good measure, I also scanned
> the entire software raid with a check command which took 3 days to run.
> 
> Everything passed.
> 
> Then, I made a bcache of that device, an ssd that seems to work fine
> otherwise (brand new), and dmcrypted the result
> 
> md5 - bache - dmcrypt - btrfs ssd /
> 
> Now, I'm copying data over with btrfs send, and I'm seeing these slowly
> show up and the write counter go up one by one.
> BTRFS error (device dm-7): bdev /dev/mapper/oldds1 errs: wr 17, rd 0,
> flush 0, corrupt 0, gen 0
> 
> Where is the documentation for those counters?
> Is the write error fatal, or a recovered error?
> Should I consider that my filesystem is corrupted as soon as any of
> those counters go up?
> (I couldn't find an exact meaning of each of them)

I believe all formal documentation of what the error counters actually 
mean is developer-level -- "Trust the Source, Luke."

Unless something has recently been added to the wiki documenting them, 
admin/user level documentation is only the simple mention in the
btrfs-device manpage under stats, and what can be gathered, often by 
reading between the lines or from simply observing real behavior and the 
kernel log when errors increment, from the simple error counter names and 
comments here on this list.

Yet another point supporting the "btrfs is still stabilizing, not yet 
fully stable" position, I suppose, as it could definitely be argued that 
those counters and their visibility, including display in the kernel log 
at mount time, are definitely intended to be consumed at the admin-user 
level, and that it follows that they should be documented at the admin-
user level before the filesystem can properly be defined as fully stable.


Meanwhile, not saying my own admin-user viewpoint is gospel, by any 
stretch, but with the intent of hopefully helping make sense of things...

>From my own experience of some months with a failing ssd (as part of a 
raid1 pair with an ssd that was working fine, so I could and did 
regularly scrub the errors and took advantage of the checksummed raid1 
pairing to let it go much further than I would have in other 
circumstances, simply to observe how things worked as it degraded)...

Write error counter increments should be accompanied by kernel log events 
telling you more -- what level of the device stack is returning the 
errors that propagate up to the filesystem level, for instance.  Expected 
would be either bus level timeouts and resets, or storage device errors.  

If it's storage device errors, SMART data should show increasing raw 
value relocated sectors or the like (smartctl -A).  If it's bus errors, 
it could be bad cabling (bad connections or bad shielding, or using 
SATA-150 certified cables for SATA-600 or some such), or, as I saw on an 
old and failing mobo (when I pulled it there were bulging and some 
exploded capacitors) a few years ago, failing filter-capacitors on the 
mobo signalling paths.  Bad power, including the possibility of an 
overloaded UPS that hit one guy I know, is notorious for both this sort 
of issue and memory problems, as well.

Of course bus timeout errors can also be due to lower timeouts on the bus 
(typically 30-second) than on the device (often 2-minute retry time, on 
consumer-level devices), but there's others here with far more knowledge 
in that area, including what to do to try to fix it, than I have, and the 
various options to fix it have been posted multiple times by now, and 
likely will be posted here again.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

