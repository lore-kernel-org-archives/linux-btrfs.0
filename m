Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36947 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbaIQVMF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 17:12:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XUMWA-0002bH-PR
	for linux-btrfs@vger.kernel.org; Wed, 17 Sep 2014 23:12:02 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 23:12:02 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 23:12:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance enospc
Date: Wed, 17 Sep 2014 21:11:50 +0000 (UTC)
Message-ID: <pan$305c3$5abb7bbb$f19e8993$266a8cf0@cox.net>
References: <54186A4B.60902@intellasoft.net>
	<54186A82.7070801@intellasoft.net>
	<5760D61A-8550-4386-8125-0A29A81ADE3A@colorremedies.com>
	<BAY172-W49807D9D79231B7B004F04B0C90@phx.gbl>
	<5419CA37.1070608@intellasoft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Murawski posted on Wed, 17 Sep 2014 13:51:51 -0400 as excerpted:

>> Does/should a balance imply removal of missing devices (as long as
>> the minimum number of devices are still available)?
> 
> That's a really good question.  As a user I would expect it to balance
> over remaining devices assuming you still have a complete picture. Doing
> a device delete missing after a balance should be just some pool
> metadata updates at that point.

A balance does not imply removal of missing devices.  And at this point 
I'd say it shouldn't, tho perhaps some day after the code is somewhat 
more stable it could.

In fact, until recently kernelspace btrfs (which does all the work in a 
balance, userspace is simply the way you tell it what to do) didn't even 
properly detect dynamically added/removed devices, resulting in 
definitely unintuitive behavior where the balance would still queue up 
chunks to be rewritten to the missing device, that would obviously never 
be written because the device was missing and wasn't coming back! (!!!)

AFAIK (I'm a sysadmin and list regular, not a developer) that arguably 
pathological behavior has been fixed now, at least in theory, and the 
kernel should properly detect missing devices and should no longer try to 
write to them when doing a balance, so now, at least in theory and 
assuming good copies of all data and metadata on the remaining device 
from the original pair, a balance to it and a just added device in raid1 
mode should leave only the device metadata for btrfs device delete 
missing to fix up afterward.

However, as of now, there's still at least two bug reports being traced 
down in the dynamic device detection code (see the current thread where 
btrfs fi show on a two-device filesystem is pointing to the wrong place 
for one of the devices, and another where show says a device is missing, 
that isn't), and possibly others yet to be found, so it's not yet a good 
idea to have btrfs doing automatic device delete missing on balance.  
After the bug fixes are in and the code churn in that area calmed down 
for a couple kernel cycles, perhaps then we can debate whether a balance 
should automatically delete missing devices when appropriate, or not, but 
certainly now isn't isn't the time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

