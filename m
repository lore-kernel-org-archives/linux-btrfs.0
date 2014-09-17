Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35950 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbaIQTtI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 15:49:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XULDu-00069n-Q2
	for linux-btrfs@vger.kernel.org; Wed, 17 Sep 2014 21:49:06 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 21:49:06 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 21:49:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can btrfs re-sync an out-of-sync RAID1 filesystem?
Date: Wed, 17 Sep 2014 19:48:54 +0000 (UTC)
Message-ID: <pan$e6d2e$8bcdb8e4$ee7c1dd5$85ffb88a@cox.net>
References: <5419C11D.1080803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alan Hagge posted on Wed, 17 Sep 2014 10:13:01 -0700 as excerpted:

> I know that sounds weird, but here's my scenario:
> 
> - Create a RAID1 filesystem (both data and metadata) using 2 same-sized
> external USB drives - Copy data (backup of other filesystem) onto this
> new filesystem - Dismount the filesystem - Split up the drives (keep one
> at home, move one to offsite backup)
> 
> This way if I need to recover a file, I can mount the one drive I have
> with "-o ro,degraded" to recover data.  If there's a read error on the
> backup drive during the copy, I can go to the offsite location, bring
> back the 2nd drive and mount both and have RAID1 protection.
> 
> BUT...if I accidentally (because I forgot to use "ro" when mounting) or
> purposely write data to the single drive in degraded mode,  is it
> possible to later mount both drives in RAID1 mode and "resync" them (as
> opposed to having to do a "replace" operation on the out-of-sync drive,
> which would force it to be completely rewritten)?  If so, how would
> btrfs know which drive is the "master" (ie. the updated one)?
> 
> Or is it not possible to write to a btrfs volume mounted in "degraded"
> mode?

In general this works.  However, as the thread linked in Piotr's reply 
mentions, don't expect it to work for NOCOW files.  (But you have to make 
files nocow, so if you haven't, that shouldn't be an issue.)

Additionally, the "newest version" detection is based on file generation, 
so you want to be SURE you don't separately mount first one device 
writable and then the other, so they diverge not only from each other but 
from the point of separation.  If you split them, make SURE only the one 
is mounted writable, so it'll be very clear which one has the updated 
content.  If you DO accidentally separately mount both of them writable, 
I'd suggest using wipefs (or dd) to kill the btrfs magic on one of them 
so there's no possibility of btrfs getting mixed up which is newer, and 
then doing a btrfs replace to replace it with a new, current copy.

Meanwhile, again as noted in the Piotr's linked thread, the detection and 
update isn't automatic.  Once split with one mounted writable, when 
rejoined you'll want to do a btrfs scrub to bring the other one current.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

