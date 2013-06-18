Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46781 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab3FRGFK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 02:05:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Uop2S-0007uX-2L
	for linux-btrfs@vger.kernel.org; Tue, 18 Jun 2013 08:05:08 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 08:05:08 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 08:05:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BUG at fs/btrfs/print-tree when trying to mount after a crash
Date: Tue, 18 Jun 2013 06:04:50 +0000 (UTC)
Message-ID: <pan$89a8$49bdccdf$48e0ce45$59d9acc9@cox.net>
References: <1371496227.3925.44.camel@ivbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Zugelder posted on Mon, 17 Jun 2013 21:10:27 +0200 as excerpted:

> Hi,
> 
> my laptop with a btrfs on dm-crypt on SSD freezed today shortly after
> resuming from suspend (it doesn't normally do that). I was running a
> self compiled 3.9.6 at this point. There should be around 20 of 114 GiB
> free on the file system and it was probably created with 16K leaf size.
> 
> After rebooting, mounting the rootfs didn't work anymore. I made a copy
> of the disk and am now trying to fix it using my desktop. Trying to
> mount it with -o recovery on 3.10-rc6 triggers the following bug: 
[snipped]

> Any suggestions? Never had a problem before running btrfs on that
> machine and SSD for about 2 years now.

The technical debugging's for others, but two suggestions as a btrfs user/
tester:

1) I had an similar issue some time back that turned out to be a 
corrupted space-cache.  Try mounting with the "nospace_cache" option.  If 
that works that's it; mount with the "clear_cache" option to clear the 
bad cache and perhaps once again with space_cache to turn it back on. 
(Space-cache is one of the few options that's persistent, but I'm not 
sure if no-cache is equally persistent, making it a toggle, or if once 
it's on there's no way to turn it off permanently.)

The clear_cache option will trigger a cache rebuild, so will take some 
time on slower devices (you said SSD but didn't say whether it was a slow 
one or a fast one).  See the mount-options page at the wiki for more.

https://btrfs.wiki.kernel.org/index.php/Mount_options#Space_cache_control

2) Apparently some corruption bugs in 3.9 were fixed for 3.10.  It's 
worth trying say the latest 3.10-rc kernel, to see if can handle it.

As the wiki mentions in several places and as is frequently repeated 
here, btrfs is still under heavy development and the development kernels 
often have fixes missing in even latest stable.  So unless there's a 
known regression in the current development kernel that you're 
purposefully avoiding, really, relatively speaking, in terms of btrfs 
development, latest mainline kernel stable is in practice already a bit 
dated, and btrfs testers are encouraged to run the development kernels 
from rc2 or rc3 at least.  (I can understand not wanting to run them 
during the commit window, or until rc2/3, as I often hold off during the 
commit window here, too.  Some even run btrfs-next, before it hits 
mainline, but I've chosen to stick with mainline here.  That's just 
simpler all around for me, and the rcs are still current /enough/.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

