Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52760 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab3GTMzI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Jul 2013 08:55:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V0Wgl-0006J0-9P
	for linux-btrfs@vger.kernel.org; Sat, 20 Jul 2013 14:55:07 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Jul 2013 14:55:07 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Jul 2013 14:55:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: abysmal rm performance?
Date: Sat, 20 Jul 2013 12:54:50 +0000 (UTC)
Message-ID: <pan$ced03$25979b41$99925d6e$d5a92251@cox.net>
References: <20130720133726.7c2e1314@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Sat, 20 Jul 2013 13:37:26 +0800 as excerpted:

> So it looks like removing files with btrfs [as opposed to ext4] needs
> much more metadata updates?

You /really/ need to read up on the btrfs wiki.

The short answer is yes, btrfs does a LOT more metadata processing due to 
the checksumming it does by default.  (Consider that it must have all the 
metadata from a leaf available in ordered to rechecksum it when one 
file's metadata from that leaf gets deleted.)  Additionally, btrfs keeps 
two copies of metadata by default, in raid1 mode if there's multiple 
devices (btrfs raid1), DUP mode if not (other forms of raid, which would 
appear to btrfs as a single device).

Then there's the whole problem that you didn't provide nearly enough 
information about your test to tell what it was actually comparing.  What 
sort of raid1, btrfs/md/dm/hardware/what, and if btrfs raid1, was that 
for both data and metadata or just one of the two and what was the other 
one if they weren't both raid1?  And if you were testing btrfs raid1, 
what did you do with the ext4 test to try to make it comparable since 
ext4 doesn't have a native raid1 mode, or was it on a single device?

So... read up on the wiki a bit, then come back with questions you have 
that aren't answered there.  (I certainly had some I didn't see directly 
answered there when I first started with btrfs.)

https://btrfs.wiki.kernel.org/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

