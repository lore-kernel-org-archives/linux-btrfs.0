Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51507 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2FZDwJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 23:52:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SjMOk-00013e-J0
	for linux-btrfs@vger.kernel.org; Tue, 26 Jun 2012 05:25:02 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 05:25:02 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 05:25:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: seeking advice
Date: Tue, 26 Jun 2012 03:24:51 +0000 (UTC)
Message-ID: <pan.2012.06.26.03.24.52@cox.net>
References: <CAJ8bbvtJG_=grkgdJ_Bk68QHt0eE5DghHwZNTeEGhd_PBof=sw@mail.gmail.com>
	<CAJ8bbvtN_8vY3x0LzNFC7kBChSvRruaaes+Oi2oUE6BmSob+LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maciej Sujkowski posted on Mon, 25 Jun 2012 19:43:36 +0100 as excerpted:

> Maybe someone will be able to help.
> 
> I have 2 unusable instances of btrfs.
> 
> 1. when I did a re-size (stretch) I had a power lost and now btrfs
> system is not detected on the drive (tried find-root, restore, btrfsck,
> btrfs show and maybe something else - can't remember as it was some time
> ago

As both the btrfs wiki ( https://btrfs.wiki.kernel.org/ ) and kernel 
config btrfs option have strong warnings about btrfs still being an 
experimental filesystem only appropriate for testing, and a good admin 
always has backups in any case but will DEFINITELY have backups (tested, 
since by definition, an untested backup isn't a completed backup) when 
testing an experimental filesystem such as btrfs is at this point, this 
one shouldn't be a problem.  Simply wipe that btrfs image and restore 
from those backups.

And of course, admins will also know that if they value their data, they 
make backups before resizing as well, even if they're normally careless 
with it.

It's also worth noting, since you mentioned that it was some time ago, 
that the btrfsck --repair option is fairly new.  It's possible it didn't 
even have a --repair option back when you tried it before, and that might 
fix it.  Of course, being new and even /more/ experimental than the 
filesystem in general, it could also make the problem worse, as seems to 
have been the case below, but if your alternative is restoring from 
backup anyway, it doesn't hurt to try.

(Ordinarily, testers should be running quite new kernels and utilities as 
well, and it might be worth working with the devs to check their restore 
operations, etc.  But as you said this was some time ago, I'm assuming 
the kernel is now old enough, with enough of its bugs now fixed, that the 
value of doing that is rather low now, as the code that created the 
problem is simply too stale.)

Alternatively, if you're using one of the distros that has chosen to 
support btrfs despite its experimental state upstream, you'd need to 
arrange with them to take them up on that support offer...

> 2. I did btrfsck -repair on another device and now it show incorrect
> amount of space (the difference is really huge) and when i try to mount
> it there is kernel bug. btrfsck detects some errors but can't fix it.


See the wiki on this one.  In particular, there's a mount option that you 
can try (nospace-cache, IIRC, but double-check), so check the info on 
mount options.

I'm off of btrfs now as I decided it's still not stable enough for me, 
but was testing it during the kernel 3.4 development cycle, and had a 
space-cache problem after I enabled it and had a crash.  The filesystem 
refused to mount after that just as yours is.  One-shot mount-disabling 
the space-cache allowed the filesystem to mount and repair itself in the 
process, after which mounting it normally (so space-cache auto-activated 
once again) worked fine.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

