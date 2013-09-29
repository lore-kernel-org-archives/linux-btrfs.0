Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35124 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab3I2FL4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Sep 2013 01:11:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VQ9IQ-0005fO-1u
	for linux-btrfs@vger.kernel.org; Sun, 29 Sep 2013 07:11:54 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 07:11:54 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 07:11:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
Date: Sun, 29 Sep 2013 05:11:35 +0000 (UTC)
Message-ID: <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org>
	<l2826k$1uc$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Sun, 29 Sep 2013 03:10:37 +0100 as excerpted:

> So...
> 
> Any options for btrfsck to fix things?
> 
> Or is anything/everything that is fixable automatically fixed on the
> next mount?
> 
> Or should:
> 
> btrfs scrub /dev/sdX
> 
> be run first?
> 
> Or?
> 
> 
> What does btrfs do (or can do) for recovery?

Here's a general-case answer (courtesy gmane) to the order in which to 
try recovery question, that Hugo posted a few weeks ago:

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999

Note that in specific cases someone who knew what they were doing could 
omit some steps and focus on others, but I'm not at that level of "know 
what I'm doing", so...

Scrub... would go before this, if it's useful.  But scrub depends on a 
second, valid copy being available in ordered to fix the bad-checksum 
one.  On a single device btrfs, btrfs defaults to DUP metadata (unless 
it's SSD), so you may have a second copy for that, but you won't have a 
second copy of the data.  This is a very strong reason to go btrfs raid1 
mode (for both data and metadata) if you can, because that gives you a 
second copy of everything, thereby actually making use of btrfs' checksum 
and scrub ability.  (Unfortunately, there is as yet no way to do N-way 
mirroring, there's only the second copy not a third, no matter how many 
devices you have in that "raid1".)

Finally, if you mentioned your kernel (and btrfs-tools) version(s) I 
missed it, but [boilerplate recommendation, stressed repeatedly both in 
the wiki and on-list] btrfs being still labeled experimental and under 
serious development, there's still lots of bugs fixed every kernel 
release.  So as Chris Murphy said, if you're not on 3.11-stable or 3.12-
rcX already, get there.  Not only can the safety of your data depend on 
it, but by choosing to run experimental we're all testers, and our 
reports if something does go wrong will be far more usable if we're on a 
current kernel.  Similarly, btrfs-tools 0.20-rc1 is already somewhat old; 
you really should be on a git-snapshot beyond that.  (The master branch 
is kept stable, work is done in other branches and only merged to master 
when it's considered suitably stable, so a recently updated btrfs-tools 
master HEAD is at least in theory always the best possible version you 
can be running.  If that's ever NOT the case, then testers need to be 
reporting that ASAP so it can be fixed, too.)

Back to the kernel, it's worth noting that 3.12-rcX includes an option 
that turns off most btrfs bugons by default.  Unless you're a btrfs 
developer (which it doesn't sound like you are), you'll want to activate 
that (turning off the bugons), as they're not helpful for ordinary users 
and just force unnecessary reboots when something minor and otherwise 
immediately recoverable goes wrong.  That's just one of the latest fixes.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

