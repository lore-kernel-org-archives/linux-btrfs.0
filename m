Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56197 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbcCYNGT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 09:06:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ajRRP-0002dn-FO
	for linux-btrfs@vger.kernel.org; Fri, 25 Mar 2016 14:06:15 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 14:06:15 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 14:06:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Aw: cannot repair raid6 volume rescue zero-log crashed
Date: Fri, 25 Mar 2016 13:06:09 +0000 (UTC)
Message-ID: <pan$efd$ff2650cf$f7365299$5ce9796d@cox.net>
References: <trinity-bf6c2c0d-170a-40b8-9658-c5ed72e8b58f-1456564286770@3capp-gmx-bs71>
	<trinity-17ca2179-b6d5-4eb0-9255-81cd338d02e8-1458903748979@3capp-gmx-bs05>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Koester posted on Fri, 25 Mar 2016 12:02:29 +0100 as excerpted:

> with btrfs tools 4.5 i got this message:

Unfortunately this isn't going to be a lot of direct help in regard to 
your specific situation as I'm simply a btrfs using admin and list 
regular, not a dev, and I don't use btrfs raid56 mode here at all, both 
because it doesn't fit my use-case (I use raid1 mode, with backups =:^), 
and because btrfs raid56 mode isn't yet appropriately mature enough to 
handle my use-case even if parity raid would otherwise be an appropriate 
choice.  However, as I don't see any other answers, here's some rather 
generic notes:

These first points are btrfs generic, not specific to raid56 mode.

1) Btrfs in general is considered stabilizing, but not yet fully stable 
and mature.  As such, backups are extremely strongly recommended, more so 
than with fully stable and mature filesystems, unless you are using 
purely testing data that's trivial enough you simply don't care if it 
dies.

2) Additionally, given the speed at which btrfs is still changing and the 
fact that this list is mainline focused, not specific distro focused, 
list-recommended kernels are in two tracks based on mainline kernels, 
current track and LTS.  On the current track, the latest two current 
kernel series are recommended and best supported.  With 4.5 out, that's 
kernel series 4.5 and 4.4.

On the LTS track, until recently it was again the latest two, but 
mainline LTS kernel versions, which would be the 4.4 and 4.1 LTS kernel 
series.  However, as btrfs stabilizes and because the previous LTS 
kernel, 3.18, was relatively stable as well, while newer is recommended, 
we do recognize that more conservative users may wish to stay a bit 
further back, and as such LTS series 3.18 remains supported to some 
extent as well.

3) While this list is mainline focused, we do recognize that various 
distros support btrfs on kernels outside the above recommended mainline 
current and LTS track versions.  However, as we're mainline focused, we 
don't track what patches they may or may not have backported to whatever 
kernels they are running, and thus, while we'll do our best to help, 
often that "best" is going to be asking that you try with something newer 
and report back the results from that, if need be.

Alternatively, you may of course turn to the support your distro is 
providing for btrfs on that kernel, as they're better positioned to know 
what exactly they've backported and what they haven't, which would then 
make it a matter between you and your distro, rather than between you and 
the list.

It can be noted here that kernel 4.2, specifically, is not a mainline LTS 
track kernel, which means it's subject to the current track kernel 
upgrade rules, and support for mainline 4.2 series is now expired with no 
further patches being backported to it.  Therefore, the recommendation, 
both from a general mainline kernel perspective and from the btrfs 
specific perspective, would be to upgrade to something within current 
support scope, presently 4.4 and 4.5, or switch to the LTS track, as 
mentioned, 4.4, 4.1 and 3.18, the alternative being looking to your 
distro for longer term support if they've chosen to provide it for 4.2.

4) In terms of the btrfs-progs userspace, during normal runtime, most 
commands simply invoke kernel code, so userspace code isn't as critical.  
However, once you're dealing with a filesystem that's failing to mount, 
and trying to repair it using btrfs check and other userspace tools, or 
retrieve files from the unmounted filesystem using btrfs restore, then 
it's actually userspace code doing the work, and it's at that point that 
the userspace version becomes critical, as newer versions have the newest 
repair and restore code to best deal with problems only recently 
understood.

In this regard you're current, as you're now running btrfs-progs 4.5.


Those are the generic points applying to btrfs in general.  For btrfs 
raid56 mode more specifically...

5) Btrfs raid56 mode, while nominally complete with kernel 3.19, had show-
stopper-critical bugs into the 4.1 development cycle, and while those 
were fixed by 4.1 and later 4.2 release, btrfs raid56 mode code remains 
somewhat less stable than btrfs code in general.  As such, using the very 
latest code, kernel 4.5 and its matching 4.5 userspace, is extremely 
strongly recommended.

6) In addition, while there's no specific show-stopper level bugs with 
the raid56 code that I know of, there remains one known in-practice 
critical bug that hasn't been tracked down, the fact that in some cases, 
device replacement and array rebuild can be /extremely/ slow, to the 
point where it can take weeks to return to full undegraded mode.  
Unfortunately, the entire filesystem is at risk during that extended 
rebuild, due to the real risk of further loss of devices while the 
filesystem is already degraded.  With the length of that high-risk 
rebuild time so extended, the raid5/raid6 functionality may actually be 
of little practical use, since dropping of further devices may kill the 
array before it's fully rebuilt.

7) It shouldn't need to be said, but to make it explicit, with raid56 
mode not yet as stable as btrfs in general, having backups is even *MORE* 
strongly recommended.  IOW, unless the data really is of only trivial 
"just testing and I don't care if I lose it" value, putting it on btrfs 
raid56 in its current state without backups in case that btrfs dies, is 
irresponsiblity to the highest degree.

* IOW, when it comes to btrfs raid56 mode: Just. Have. That. Backup. Or. 
You. Have. Defined. Your. Data. As. Not. Worth. Saving. *

8) Of course people who care about their data are going to do their 
research when choosing the filesystem they wish to put it on.  Therefore, 
anyone not knowing btrfs, and in particular, btrfs raid56, status, while 
having data on it, simply means they don't value that data enough to do 
the research to know the above, particularly point #7.


Given all the above, particularly points #7 and 8, even if you can't 
recover the data from the filesystem, it's no big deal.  Either you had 
backups and can recover from them, or you didn't.  If you did, no big 
deal, restore from backups.  If you didn't have backups then by virtue of 
points 7 and 8, you defined the data as not valuable enough to be worth 
the trouble, either of the backup if you knew the risk, or of the 
research to know the risk in the first place.  Thus, you can be happy at 
saving that hassle which you defined to be of more value than your data, 
even if the data itself ends up being unrecoverable.

So either way you save what was of more value to you.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

