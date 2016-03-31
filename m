Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36708 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbcCaWoB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 18:44:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1allJm-0002NS-BF
	for linux-btrfs@vger.kernel.org; Fri, 01 Apr 2016 00:43:58 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Apr 2016 00:43:58 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Apr 2016 00:43:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "/tmp/mnt.", and not honouring compression
Date: Thu, 31 Mar 2016 22:43:52 +0000 (UTC)
Message-ID: <pan$49c11$be713ac2$a42c91f6$7e8f8b0d@cox.net>
References: <E30C9D57EC226049B1226989BABB2728418CE4@elephant.myhome.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murray posted on Thu, 31 Mar 2016 21:49:29 +0100 as excerpted:

> I'm using Proxmox, based on Debian. Kernel version 4.2.8-1-pve. Btrfs
> v3.17.

The problem itself is beyond my level, but aiming for the obvious low-
hanging fruit...

On this list, which is forward looking as btrfs remains stabilizing, not 
yet fully stable and mature, kernel support comes in four tracks, 
mainstream and btrfs development trees, mainstream current, mainstream 
lts, and everything else.

Mainstream and btrfs development trees should be obvious.  It covers 
mainstream current git and rc kernels as well as btrfs-integration and 
linux-next.  Generally only recommended for bleeding edge testers willing 
to lose what they're testing.

Mainstream current follows mainstream latest releases, with generally the 
latest two kernel series being best supported.  With 4.5 out, that's 4.5 
and 4.4.

Mainstream LTS follows mainstream LTS series, and until recently, again 
the latest two were best supported.  That's the 4.4 and 4.1 LTS series.  
However, as btrfs has matured, the previous LTS series, 3.18, hasn't 
turned out so bad and remains reasonably well supported as well, tho 
depending on the issue, you may still be asked to upgrade and see if it's 
still there in 4.1 or 4.4.

Then there's "everything else", which is where a 4.2 kernel such as 
you're running comes in.  These kernels are either long ago history 
(pre-3.18 LTS, for instance) in btrfs terms, or out of their mainstream 
kernel support windows, which is where 4.2 is.  While we recognize that 
various distros claiming btrfs support may still be using these kernels, 
because we're mainline focused we don't track what patches they may or 
may not have backported, and thus aren't in a particularly good position 
to support them.  If you're relying on your distro's support in such a 
case, that's where you need to look, as they know what they've backported 
and what they haven't and are thus in a far better position to provide 
support.

As for the list, we still do the best we can with these "everything else" 
kernels, but unless it's a known problem recognized on-sight, that's most 
often simply to recommend upgrading to something that's better supported 
and trying to duplicate the problem there.

Meanwhile, for long-term enterprise level stability, btrfs isn't likely 
to be a good choice in any case, as it really is still stabilizing and 
the expectation is that people running it will be upgrading to get the 
newer patches.  If that's not feasible, as it may not be for the 
enterprise-stability-level use-case, then it's very likely that btrfs 
isn't a good match for the use-case anyway, as it's simply not to that 
level of stability yet.  A more mature filesystem such as ext4, ext3, the 
old reiserfs which I still use on some spinning rust here (all my btrfs 
are on ssd), xfs, etc, is very likely to be a more appropriate choice for 
that use-case.

For kernel 4.2, that leaves you with a few choices:

1) Ask your distro for btrfs support if they offer it on the out-of-
mainline-support kernels which they've obviously chosen to use instead of 
the LTS series that /are/ still mainline supported.

2) Upgrade to the supported 4.4 LTS kernel series.

3) Downgrade to the older supported 4.1 LTS kernel series.

4) Decide btrfs is inappropriate for your use-case and switch to a fully 
stable and mature filesystem.

5) Continue with 4.2 and muddle thru, using our "best effort" help where 
you can and doing without or getting it elsewhere if the opportunity 
presents itself or you have money to buy it from a qualified provider.


Personally I'd choose option 2, upgrading to 4.4, but that's just me.  
The other choices may work better for you.


As for btrfs-progs userspace, when the filesystem is working it's not as 
critical, since other than filesystem creation with mkfs.btrfs, most 
operational commands simply invoke kernel code to do the real work.  
However, once problems appear, a newer version can be critical as patches 
to deal with newly discovered problems continue to be added to tools such 
as btrfs check (for detecting and repairing problems) and btrfs restore 
(for recovery of files off an unmountable filesystem).  And newer 
userspace is designed to work with older kernels, so newer isn't a 
problem in that regard.

As a result, to keep userspace from getting /too/ far behind and because 
userspace release version numbers are synced with kernel version, a good 
rule of thumb is to run a userspace version similar to that of your 
kernel, or newer.  Assuming you're already following the current or LTS 
track kernel recommendations, that will keep you reasonably current, and 
you can always upgrade to the newest available if you're trying to fix 
otherwise unfixable problems.

Unfortunately your userspace falls well outside that recommendation as 
well, with 3.17 userspace being before the earliest supported 3.18 LTS 
kernel, let alone comparable to your current 4.2 kernel or the 4.4 LTS 
upgrade or 4.1 LTS downgrade that would be recommended on the LTS track, 
or 4.4 or 4.5 on the current track.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

