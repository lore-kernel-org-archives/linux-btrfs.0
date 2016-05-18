Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48987 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbcERHid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 03:38:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b2w3n-0002wP-3L
	for linux-btrfs@vger.kernel.org; Wed, 18 May 2016 09:38:27 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 May 2016 09:38:22 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 May 2016 09:38:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS RAID 1 broken: Mounted drive(s) basically empty after
 repair attempt
Date: Wed, 18 May 2016 07:38:16 +0000 (UTC)
Message-ID: <pan$7ed1$38076faf$e144173d$221ccbc0@cox.net>
References: <CAEwOqv5fDHNVe7Q_+PH_k+W-WRPMt3W3psjzh2vjYfEKq-XWPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quanttek Jonas posted on Tue, 17 May 2016 10:00:41 -0400 as excerpted:

> So, the question is: How can I recover from this? How do I get my data
> back, after foolishly using "btrfsck --repair"?

First, let me note that I'm a list regular and btrfs user, not a dev, and 
that as such, much of your post was beyond my tech understanding level.  
Thus I snipped it above.  For a technical take perhaps one of the devs 
will help, and other user and general dev but not btrfs dev will likely 
post their thoughts as well.

But here I'd probably declare the filesystem beyond full repair and focus 
on getting any files off it I could using the below described method, and 
restoring what I couldn't get from the damaged filesystem from backup

It's worth pausing to note that this point the sysadmin's rule of 
backups, which in simplest form simply states that if you don't have at 
least one level of backup, you are by choosing not to do that backup, 
defining your data as worth less than the trouble and resources necessary 
to do that backup.  Thus, by definition, you /always/ save what was of 
most importance to you, either the data, if you decided it was worth 
making that backup, or if by your actions you defined the time and 
resources that would otherwise be spent in making that backup as more 
valuable than the data, then you saved your valuable time and resource, 
even if you lost what you had defined to be of lower value, that being 
your data.

And that rule applies in normal conditions, using fully mature and long-
term stable filesystems such as ext3/4, xfs, or (the one I still use on 
my spinning rust, I only use btrfs on my ssds) reiserfs.  Btrfs, while 
stabilizing, is not yet fully stable and mature, definitely not to the 
level of the above filesystems, so the rule applies even more strongly 
there (a less simple form of the rule takes into account varying levels 
of risk and varying data value, along with multiple levels of backup, 100 
levels of backup with some offsite in other locations may not be enough 
for extremely high value data).

So I'll assume that much like me you keep backups where the data is 
valuable enough to warrant it, but you may not always have /current/ 
backups, because the value of the data in the delta between the last 
backup and current simply doesn't warrant the hassle of refreshing the 
backup, yet, given the limited risk of /future/ loss.  However, once the 
potential loss happens, the question changes.  Now it's a matter of 
whether the hassle of further recovery efforts is justified, vs. the 
known loss of the data in that delta between the last backup and the last 
"good" state before things started going bad.

As it happens, btrfs has this really useful tool called btrfs restore, 
that can often help you recover your data at very close to the last good 
state, or at least to a state beyond that of your last backup.  It has 
certainly helped me recover this from-last-backup-delta data a couple 
times here, allowing me to use it instead of having to fall back to the 
older and more stale backup.  One nice thing about btrfs restore is that 
it's read-only with respect to the damaged filesystem, so you can safely 
use it on a filesystem to restore what you can, before trying more 
dangerous things that might cause even more damage.  Since it's a purely 
read-only operation, it won't cause further damage. =:^)

There's a page on the wiki that describes this process in more detail, 
but be aware, once you get beyond where automatic mode can help and you 
have to try manual, it gets quite technical, and a lot of folks find they 
need some additional help from a human, beyond the wiki.

Before I link the wiki page, here's an introduction...

Btrfs restore works on the /unmounted/ filesystem, writing any files it 
recovers to some other filesystem, which of course means that you need 
enough space on that other filesystem to store whatever you wish to 
recover.  By default it will write them as root, using root's umask, with 
current timestamps, and will skip writing symlinks or restoring extended 
attributes, but there are options that will restore ownership/perms/
timestamps, extended attributes, and symlinks, if desired.

Normally, btrfs restore will use a mechanism similar to the recovery 
mount option to try to find a copy of the root tree of the filesystem 
within a few commits (which are 30-seconds apart by default) of what the 
superblocks say is current.

If that works, great.  If not, you have to use a much more manual mode, 
telling btrfs restore what root to try, while using btrfs-find-root to 
find older roots (by generation, aka transid), then feeding the addresses 
found to btrfs restore -t, first with the -l option to list the other 
trees available from that root, then if it finds all the critical trees, 
using it with --dry-run to see if it seems to find most of the expected 
files, before trying the real restore if things look good.

With that, here's the wiki page link.  Try the normal mode first.  If it 
fails and you need further help with the advanced usage stuff, you can 
ask more questions then.

https://btrfs.wiki.kernel.org/index.php/Restore

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

