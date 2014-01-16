Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51458 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbaAPQ50 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 11:57:26 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W3qFp-0008Ha-Dh
	for linux-btrfs@vger.kernel.org; Thu, 16 Jan 2014 17:57:17 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 17:57:17 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 17:57:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [newb] btrfs send problem
Date: Thu, 16 Jan 2014 16:56:50 +0000 (UTC)
Message-ID: <pan$a779b$653e2560$2b5dbfeb$aa12eb1a@cox.net>
References: <lb8ue0$hic$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Neal Becker posted on Thu, 16 Jan 2014 10:38:52 -0500 as excerpted:

> I hope this is an appropriate place to ask user questions.

Yes. Welcome!  =:^)

> I'm trying out snapshot and replication.

Being just an admin aka btrfs-user myself (altho a list regular), and as 
well one that doesn't do a lot with snapshots or send/receive, I don't go 
too deep into those areas.  However, I do know that there was a recent 
bug with snapshots not appearing where they were expected -- something 
about prepending @.  And they're working on send/receive bugs as well.

Others will probably have more detailed answers, but meanwhile, you can 
check the back-list to a couple weeks back and see what's going on.  I 
use gmane.org's list2news service and an nntp client (pan, in my case) to 
handle my lists including this one, and they have various web interfaces 
to their archive as well, in addition to the official kernel lists 
archives.

Meanwhile, the more or less standard newbie lecture. =:^)

You don't mention what kernel and btrfs-progs versions you are using.  
Please include that information in any future questions/reports.

FWIW, while btrfs is beginning to stabilize now and the warnings are 
toned down a bit from what they were, it's still under heavy development, 
so:

1) Even more than with a fully stable filesystem, make backups and test 
that you can actually recover from them, because btrfs /does/ still have 
bugs and you just /might/ have to use those backups!

2) Keeping current on both the kernel and btrfs-progs is strongly 
recommended, both because older versions (particularly kernel) have known 
bugs that are now fixed, that may unnecessarily trigger use of those 
backups, and because in its current state btrfs users /are/ btrfs 
testers, and any bug reports we generate are going to be far more useful 
to the devs if we're using current code.

For the kernel, latest kernel of the latest stable series (currently 
3.12.x) is recommended, if not the development kernel (currently very 
late in the 3.13-rc series, 3.13.0-rc8+), if not the btrfs-next patches 
slated for the /next/ development kernel (would be 3.14 at this point).  
And if you're running more than a full kernel series behind (older than 
3.11 at this point, but 3.13 is due at which point it'll be 3.12), 
really, DO update -- it's your data you're placing at unnecessary risk!

Personally, I like to switch to the new development kernel around rc2 or 
rc3.  That should be long enough that any real bad data-eating 
regressions are at least known about and are normally already fixed, but 
still early enough in the cycle to report bugs and get them fixed before 
release.

For btrfs-progs, the version policy just recently changed, and version 
numbers now (from v3.12, the current release and the first one under this 
policy) roughly match the kernel version number.  Previous to that, the 
latest release was v0.20-rc1, tho that's over a year old now, and 
previous to that, 0.19, which is now VERY old, altho some distros have 
git snapshot versions 0.19-20130707 (July 7, 2013) or the like.

So presently you really want the latest v3.12.x or v3.13-rc kernels, 
along with btrfs-progs v3.12.  And note that early 3.11 and 3.12 release 
kernels had bugs that are now fixed too, so 3.12.0 doesn't really cut it 
either.  There are reasons people go with older LTS kernel releases, but 
in general those reasons don't tend to be compatible with testing a still 
not entirely stable btrfs.  IOW, if you have reason to run an old kernel, 
that same reason is reason NOT to be running btrfs at this point.

3) If you've not already done so, please read up on the btrfs wiki, 
particularly the various user documentation pages.  The information there 
will likely be very helpful on your btrfs journey. Of course, reading up 
a few weeks of back-list here can't hurt, either. =:^)

https://btrfs.wiki.kernel.org

4) A word of warning since a lot of newbies are making this mistake.  
btrfsck --repair is still considered quite experimental and should only 
be used once you've tried everything else, including btrfs recover 
(there's a page on the wiki for that) if you need to make a final backup, 
as btrfs --repair can at times make things worse instead of better.  Just 
btrfsck without --repair should be fine as it's generally read-only and 
thus won't make things worse, but don't trust its output too much -- it 
can occasionally report problems where there aren't any or report the 
wrong problems (which if --repair were used it'd try to fix, thus making 
the problems worse).

5) Same as #1, make and test your backups -- you might need 'em!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

