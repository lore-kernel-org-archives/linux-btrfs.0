Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56582 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaAYEei (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 23:34:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W6ux2-0000Fj-W2
	for linux-btrfs@vger.kernel.org; Sat, 25 Jan 2014 05:34:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 05:34:36 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 05:34:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs and ECC RAM
Date: Sat, 25 Jan 2014 04:34:14 +0000 (UTC)
Message-ID: <pan$e5673$29a4d4ab$eacdefea$4b2cc29f@cox.net>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
	<1420240.1BEopi7BrR@merkaba> <52DC3386.7020502@chinilu.com>
	<126421479.FuRWa26fOs@russell.coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sat, 25 Jan 2014 10:57:43 +1100 as excerpted:

> On Sun, 19 Jan 2014 12:20:22 George Mitchell wrote:
>> I can easily imagine btrfs taking a system down due to memory error,
>> but not btrfs causing data corruption due to a memory error.
> 
> I had a system which had apparently worked OK on Ext4 but had some
> memory errors.  After twice having a serious BTRFS corruption (needed
> backup-format- restore) I ran memtest and found that a DIMM was broken.
> 
> In that sort of situation it seems that BTRFS is likely to be more
> fragile due to the more complex data structures and due to the fact that
> it's a newer filesystem with less corner cases handled.

I believe that was his point (as it has been mine, elsewhere).  If there 
are memory errors, btrfs might well "take down the system", or as you 
mention, corrupt the btrfs such that it needs blown away with a mkfs and 
restore from backup, but it should NOT invisibly corrupt the data.  If 
the data is available, it should be correct as it was stored, memory 
issue or no memory issue, ECC DRAM or non-ECC DRAM.  (Tho there's a small 
chance that the data was corrupted in memory before it was stored, but 
that's the case no matter the filesystem, as the filesystem has nothing 
to do with it then.)

IOW, btrfs is binary.  The data is either there and valid, or its not 
there, period.  There's no there but not valid case -- btrfs simply won't 
serve the data period if it's invalid and there's no valid copy available 
to substitute for it.

And yes, that does make btrfs more brittle on defective equipment, 
because it'll break all the way much more frequently than filesystems 
that would instead serve only slightly invalid data, without knowing how 
valid it is because they don't do the checks btrfs does.

*CAVEAT!  This assumes the filesystem isn't mounted with nodatacow/
nodatasum, and that we're not talking about files with the NOCOW extended 
attribute set, thus specific-case disabling these important features of 
btrfs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

