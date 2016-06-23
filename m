Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57453 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbcFWRRx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 13:17:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bG8GA-0006Mo-4J
	for linux-btrfs@vger.kernel.org; Thu, 23 Jun 2016 19:17:47 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 19:17:46 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 19:17:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrub not fixing checksum errors on RAID6
Date: Thu, 23 Jun 2016 17:17:19 +0000 (UTC)
Message-ID: <pan$5d677$54ab98f9$6198f8a8$b7bfb187@cox.net>
References: <0c0d5c8f-af85-6e4d-83b4-e11bb811dc5d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jussi Kansanen posted on Thu, 23 Jun 2016 18:17:46 +0300 as excerpted:

> Scrub found some checksum errors on my RAID6, errors are said to be
> fixed but every scrub results in identical errors. Any ideas why this is
> happening? The HDD seems to be working OK, no IO errors, no SMART errors
> and it passed SMART long-test.
> 
> Latest scrub was run with 4.6.2 kernel & 4.6 btrfs progs. Earlier runs
> where done with 4.5.x & 4.6 with up to date btrfs progs (at the time).

Short non-technical FYI...

Btrfs raid56 mode is unfortunately not yet upto current general btrfs 
stability[1].  There are a number of known raid56 mode bugs and reports 
such as this that need to be fixed first before it should be considered 
generally usable for anything but testing.

It wasn't clear from your post whether you know this and were simply 
reporting a problem that appeared in your testing so it can be fixed, or 
if you were trying to use raid56 mode for daily use and ran into this 
problem as a result.  I'm simply saying such issues are to be expected at 
this point, and that raid56 mode simply isn't ready for normal use yet, 
as there are a number of known problems such as this still around.

Btrfs raid1 mode, and to a slightly lessor extent, raid10 mode, is rather 
more mature and considered up to general btrfs stability status.  (I'm 
using raid1 mode here.  Raid10 mode basically works but may be slower 
than expected as it's not optimized yet.  Btrfs raid1 mode layered on top 
of a pair of md/dm-raid0s will likely be faster than btrfs raid10 without 
loss of the additional btrfs functionality.)

---
[1]  Current general btrfs stability status:  Stabilizing, but not yet 
fully stable and mature.  Keep backups and be prepared for occasional 
bugs that may force you to use them, but btrfs can be reasonably used for 
daily use provided you are doing so.  



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

