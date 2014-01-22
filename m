Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60278 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaAVQDT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 11:03:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W60Gm-0005jD-2R
	for linux-btrfs@vger.kernel.org; Wed, 22 Jan 2014 17:03:12 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 17:03:12 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 17:03:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrubbing with BTRFS Raid 5
Date: Wed, 22 Jan 2014 16:02:47 +0000 (UTC)
Message-ID: <pan$8caeb$d0be9e00$b714cdaf$5ed18e96@cox.net>
References: <95DB9BB3-D706-4023-940A-D100D93D560A@gmail.com>
	<pan$226f4$e1329373$53c2dcca$438e95e@cox.net> <52DEABC9.2040205@jrs-s.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jim Salter posted on Tue, 21 Jan 2014 12:18:01 -0500 as excerpted:

> Would it be reasonably accurate to say "btrfs' RAID5 implementation is
> likely working well enough and safe enough if you are backing up
> regularly and are willing and able to restore from backup if necessary
> if a device failure goes horribly wrong", then?

I'd say (and IIRC I did say somewhere, but don't remember if it was this 
thread) that in reliability terms btrfs raid5 should be treated like 
btrfs raid0 at this point.  Raid0 is well known to have absolutely no 
failover -- if a device fails, the raid is toast.  It's possible so-
called "extreme measures" may recover data from the surviving bits (think 
the $expen$ive$ $ervice$ of data recovery firms), but the idea is that 
either no data that's not easily replaced is stored on a raid0 in the 
first place, or if it is, there's (tested recoverable) backup to the 
level that you're fully comfortable with losing EVERYTHING not backed up.

Examples of good data for raid0 are the kernel sources (as a user, not a 
dev, so you're not hacking on them), your distro's local package cache, 
browser cache, etc.  This because by definition all those examples have 
the net as their backup, so loss of a local copy means a bit more to 
download, at worst.

That's what btrfs raid5/6 are at the moment, effectively raid0 from a 
recovery perspective.

Now the parity /is/ being written; it simply can't be treated as 
available for recovery.  So supposing you do /not/ lose a device (or 
suffer a bad checksum) on the raid5 until after the recovery code is 
complete and available, you've effectively "free" upgraded from raid0 
reliability to raid5 reliability as soon as recovery is possible, which 
will be nice, and meanwhile you can test the operational functionality, 
so there /are/ reasons you might want to run the btrfs raid5 mode now.  
As long as you remember it's currently effectively raid0 should something 
go wrong, and you either don't use it for valuable data in the first 
place, or you're willing to do without any updates to that data since the 
last tested backup, should it come to that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

