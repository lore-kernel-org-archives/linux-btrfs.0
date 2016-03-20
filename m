Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37826 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933015AbcCTDMg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Mar 2016 23:12:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ahTn8-0004zK-15
	for linux-btrfs@vger.kernel.org; Sun, 20 Mar 2016 04:12:34 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 04:12:34 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 04:12:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unable to mount btrfs partition, please help :(
Date: Sun, 20 Mar 2016 03:12:23 +0000 (UTC)
Message-ID: <pan$3da0e$a0702b68$f707e006$9ff5a561@cox.net>
References: <trinity-168495fe-1b45-46b7-bd18-d68fb686437e-1458425733744@3capp-gmx-bs02>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patrick Tschackert posted on Sat, 19 Mar 2016 23:15:33 +0100 as excerpted:

> I'm growing increasingly desperate, can anyone help me?

No need to be desperate.  As the sysadmin's rule of backups states, 
simple form, you either have at least one level of backup, or you are by 
your (in)action defining the data not backed up as worth less than the 
time, hassle and resources necessary to do that backup.

Therefore, there are only two possibilities:

1) You have a backup.  No sweat.  You can use it if you need to, so no 
desperation needed.

2) You don't have a backup.  No sweat.  By not having a backup, your 
actions defined the data at risk as worth less than the time, hassle and 
resources necessary for that backup, so if you lose the data, you can 
still be happy, because you saved what you defined as of most importance, 
the time, resources and hassle of doing that backup.

Since you saved what you yourself defined by your own actions as of most 
value to you, either way, you have what was most valuable to you and can 
thus be happy to have the valuable stuff, even if you lost what was 
therefore much more trivial.

There are no other possibilities.  Your words might lie.  Your actions 
don't.  Either way, you saved the valuable stuff and thus have no reason 
to be desperate.


And of course, btrfs, while stabilizing, is not yet fully stable and 
mature, and while stable enough to be potentially suitable for those who 
have tested backups or are only using it with trivial data they can 
afford to lose anyway, if they don't have backups, it's certainly not to 
the level of stability of the more mature filesystems the above sysadmin's 
rule of backups was designed for.  So that rule applies even MORE 
strongly to btrfs than it does to more mature and stable filesystems.  
(FWIW, there's a more complex version of the rule that takes relative 
risk into account and covers multiple levels of backup where either the 
risk is high enough or the data valuable enough to warrant it, but the 
simple form just says if you don't have at least one backup, you are by 
that lack of backup defining the data at risk as not worth the time and 
trouble to do it.)

And there's no way that not knowing the btrfs status changes that either, 
because if you didn't know the status, it can only be because you didn't 
care enough about the reliability of the filesystem you were entrusting 
your data to, to care about researching it.  After all, both the btrfs 
wiki and the kernel btrfs option stress the need for backups if you're 
choosing btrfs, as does this list, repeatedly.  So the only way someone 
couldn't know is if they didn't care enough to /bother/ to know, which 
again defines the data stored on the filesystem as of only trivial value, 
worth so little it's not worth researching a new filesystem you plan on 
storing it on.

So there's no reason to be desperate.  It'll only stress you out and 
increase your blood pressure.  Either you considered the data valuable 
enough to have a backup, or you didn't.  There is no third option.  And 
either way, it's not worth stressing out over, because you either have 
that backup and thus don't need to stress, or you yourself defined the 
data as trivial by not having it.

> $ uname -a Linux vmhost 3.16.0-4-amd64 #1 SMP Debian
> 3.16.7-ckt20-1+deb8u4 (2016-02-29) x86_64 GNU/Linux
> 
> $ btrfs --version btrfs-progs v4.4

As CMurphy says, that's an old kernel, not really supported by the 
list.   With btrfs still stabilizing, the code is still changing pretty 
fast, and old kernels are known buggy kernels.  The list focuses on the 
mainline kernel and its two primary tracks, LTS kernel series and current 
kernel series.  On the current kernel track, the last two kernels are 
best supported.  With 4.5 just out, that's 4.5 and 4.4.

On the LTS track, the two latest LTS kernel series are recommended, with 
4.4 being the latest LTS kernel, and 4.1 being the one previous to that.  
However, 3.18 was the one previous to that and has been reasonably 
stable, so while the two latest LTS series remain recommended, we're 
still trying to support 3.18 too, for those who need that far back.

But 3.16 is previous to that and is really too far back to be practically 
supported well by the list, as btrfs really is still stabilizing and our 
focus is forward, not backward.  That doesn't mean we won't try to 
support it, it simply means that when there's a problem, the first 
recommendation, as you've seen, is likely to be try a newer kernel.

Of course various distros do offer support for btrfs on older kernels and 
we recognize that.  However, our focus is on mainline, and we don't track 
what patches the various distros have backported and what patches they 
haven't, so we're not in a particularly good position to provide support 
for them, at least back further than the mainline kernels we support.  If 
you wish to use btrfs on such old kernels, then, our recommendation is to 
get that support from the distro offering it to you, as only they know 
what patches are backported and are thus in a suitable position to offer 
that support.

Meanwhile, while we recognize that there's a place for distros focusing 
on and providing support for the old and known stable, btrfs, at least 
from the perspective of this list, really isn't in that old and stable 
class as it really is still stabilizing.  As such, there's really a 
mismatch between btrfs and people wanting/needing that level of stability 
and maturity.  Either a still stabilizing filesystem like btrfs works for 
them and they don't need code that mature and stable after all, or they 
probably shouldn't be using btrfs in the first place.

Which again is where that research I mentioned above comes in... if their 
data is valuable enough to actually care enough to do it, of course...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

