Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50522 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084AbaHGQlZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Aug 2014 12:41:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XFQkg-0007Bn-ST
	for linux-btrfs@vger.kernel.org; Thu, 07 Aug 2014 18:41:18 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Aug 2014 18:41:18 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Aug 2014 18:41:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: [Bug]  btrfs' clear_cache mount option doesn't appear to do a
 rebuild, as documented that it should.
Date: Thu, 7 Aug 2014 16:40:58 +0000 (UTC)
Message-ID: <pan$f4136$1d752440$590a6445$c86d4566@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel 3.16.0 from git, btrfs-progs 3.14.2 from git, gentoo/~amd64.

Earlier today I had a device (SSD) not respond quickly enough after 
resume from suspend-to-ram, a problem I had frequently some months ago, 
but that I though was fixed as I've not had it in awhile.

The affected filesystems were all dual-device raid1 (data/metadata), and 
to the best of my knowledge a quit-X, systemctl emergency and SRQ-s-u-b 
prevented too much damage.  After reboot I did a scrub on the affected 
filesystems (/ is btrfs as well, but is mounted read-only by default as 
it was in this case, so it was clean, only /home and /var/log were 
writable and damaged) and believe I recovered (almost) everything else, 
as (besides not seeing any files missing/damaged) scrub did fix a number 
of errors on the first run, which on a second-run-verify didn't show up.

But, the space-cache remained screwed up on /home (/log was fine after 
the scrub).

After trying various things, including (an at first read-only to be sure 
it wasn't going to do anything else) btrfs check, remounting with 
clear_cache, remounting with nospace_cache and again with it enabled, 
etc, nothing was clearing the space-cache errors.

In fact, mounting with clear_cache resulted in even *MORE* space-cache 
errors!  As best I can see, it cleared the space-cache, but didn't 
rebuild it as the documentation says it should -- no activity beyond the 
initial mount, and the errors remained, both as reported by /mount/umount 
and as reported by btrfs check.

After I persuaded myself it wasn't going to do anything else besides 
attempt to fix the cache, I ran btrfs check --repair as well, and same 
thing, it apparently cleared the cache, but neither then nor on a 
subsequent mount did it appear to be rebuilt, and I kept getting the 
errors.

Eventually I did a (full) balance, which DID cure the problem, no more 
space-cache errors. =:^)

But why didn't clear_cache, or for that matter, btrfs check --repair, 
trigger a cache rebuild, and why was I still getting space-cache 
generation errors after a couple mount/umount cycles, with no space_cache 
rebuild activity noted?

That might be while space-cache errors are so common in the various 
posted reports -- once there's a single space-cache error, nothing but 
balance is actually fixing it, despite documentation to the contrary.

Meanwhile, I did a full balance (under 100 GB on SSD so that doesn't take 
long) and that DID fix the problem, but now I'm wondering what bit of the 
balance I actually had to run?  Would a -s/system have fixed it, or would 
-m/metadata (which implies -s as well, I believe) have been necessary, or 
is there no direct way to rebalance the space-cache at all, without doing 
a full rebalance?  I guess the space_cache wouldn't be -d/data area?

So the bug is, clear_cache may indeed clear it, but it doesn't appear to 
trigger a rebuild as documented, and btrfs check --repair seems to have 
the same behavior, possible clear, but no triggered rebuild either then 
or on the next mount.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

