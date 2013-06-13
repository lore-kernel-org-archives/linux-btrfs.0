Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49172 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab3FMGhz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 02:37:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Un1AP-00061R-DX
	for linux-btrfs@vger.kernel.org; Thu, 13 Jun 2013 08:37:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2013 08:37:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2013 08:37:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel bug at fs/btrfs/inode.c:906
Date: Thu, 13 Jun 2013 06:37:38 +0000 (UTC)
Message-ID: <pan$214b9$28f2d8aa$e9b96fca$d12b08b@cox.net>
References: <kp9nbo$tdh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Frederik Himpe posted on Wed, 12 Jun 2013 11:51:20 +0000 as excerpted:

> After this happened, I was unable to unlock my X session, and running
> reboot in a console did not have any effect, so I had to do a hard
> reset.

Not specific to this bug, but just a potentially helpful hint with such 
lockups:

"Magic SysRQ".  Not to go into too much detail on what's a side topic, 
but briefly:

Kernel option: CONFIG_MAGIC_SYSRQ

Hit Alt+SysRQ+key at the same time (or one at a time but holding the 
first two down until "key" is hit, SysRQ key may be labeled SysRequest, 
PrtScr or similar), where "key" determines the action.  There's a number 
of debugging actions possible, but for "ordinary users", the standard 
emergency sequence for "key" is "reisub".

R: unRaw the keyboard (useful in X or elsewhere where the keyboard is put 
in raw mode).

E: SIGTERM all processes (but init).

I: SIGKILL all processes (but init).

S: Sync mounted filesystems.

U: Remount mounted filesystems read-only.

B: Reboot (without syncing or unmounting/remounting, thus the S/U above).

However, in my experience by the time you actually need it, the REI part 
does nothing as if it did you'd not be needing it, so simply "SUB" is the 
critical bit to remember.

If the system's too locked up even the S/U won't work (the kernel will 
refuse to sync and remount ro if it believes it's too confused to do so 
safely), and only the B works, but of course that's about as bad as a 
hard reset so it's mostly helpful in knowing how hard the lockup was.  If 
the kernel is dead too, even the B won't work, leaving only hard-reset.  
But where it works, "SUB" certainly does help save data that might 
otherwise be lost due to the unclean shutdown.

The fact that you could /get/ to a console to try to run reboot 
definitely indicates that at least the SUB (and likely the REI bit as 
well) should have worked, had you used it, thus potentially saving any 
data otherwise at risk with a hard reset.

Google for more, or check the wikipedia entry, which mentions the caveat 
that for magic-srq, QWERTY keyboard layout is always used, with a helpful 
conversion table for Dvorak, AZERTY and Colemak layouts.  (Another caveat 
is that on some X-based desktops Ctrl might need added to the combo as 
well.)

http://en.wikipedia.org/wiki/Magic_SysRq_key

http://www.google.com/search?q=magic+sysrq

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

