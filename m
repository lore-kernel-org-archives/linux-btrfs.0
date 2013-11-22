Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59692 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179Ab3KVWF7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 17:05:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VjyrL-0005Dc-NF
	for linux-btrfs@vger.kernel.org; Fri, 22 Nov 2013 23:05:55 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 23:05:55 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 23:05:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: progs integration branch moved to master (new default leafsize)
Date: Fri, 22 Nov 2013 22:05:32 +0000 (UTC)
Message-ID: <pan$15edd$cb857513$c87e20b5$67c5229@cox.net>
References: <20131108220135.3802.39092@localhost.localdomain>
	<l5jtgo$6q1$1@ger.gmane.org>
	<20131121233751.5312.13383@localhost.localdomain>
	<l6n6l2$ln6$1@ger.gmane.org>
	<20131122134038.5312.42200@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason posted on Fri, 22 Nov 2013 08:40:38 -0500 as excerpted:

> Does gentoo modify the optimizations from the Makefile?  We actually
> have many strict-aliasing warnings, but I didn't think they came up
> until -O2.
> 
> At any rate, I'm adding -fno-strict-aliasing just to be sure.

FWIW, Gentoo lets users set their own CFLAGS/CXXFLAGS/LDFLAGS, etc. 

Gentoo recommends -O2 at the global system level and I believe sets that 
as the default before user modification, as well.  -Os is considered a 
viable option, but users setting -O3 or -Ofast or whatever are often 
considered ricers and can be told to try to reproduce bugs with -O2 set.  
And -O1 or lower is not recommended either, simply because it's not 
widely tested.

Individual package builds can and routinely do, however, override or 
filter specific flags where they've been demonstrated to be problematic, 
and in some cases, may add flags such as -fno-strict-aliasing where 
upstream code requires it.

But of course a (normally masked unless a user specifically unmasks it) 
-9999 version is gentoo's way of noting a live-from-upstream-vcs version, 
and that's the case here as well.  btrfs-progs-9999 fetches and builds 
the live-git btrfs-progs direct from upstream git, and as such, it's 
subject to far less QA than ~arch (~x86, ~amd64, etc) aka testing 
packages, which in turn are less stable-tested than stable arch (x86, 
amd64, etc) packages.  Basically, gentooers unmasking -9999 packages are 
expected to be able to deal with any breakage a live-vcs build may have 
and/or trigger.

And it's likely that -fno-strict-aliasing simply hasn't made it to the 
live build yet.  But by the same token, I don't believe it'll override an 
upstream makefile's use of the flag, so now that you've added it...

... And indeed, after just rebuilding it here, with the commit (8116550) 
adding -fno-strict-aliasing as HEAD, I see no further type-punned pointer 
warnings. =:^)

I do however still see this:

cmds-restore.c: In function 'next_leaf':
cmds-restore.c:174:20: warning: array subscript is above array bounds [-
Warray-bounds]
  slot = path->slots[level] + 1;
                    ^

(I am running a newer gcc than Martin, however:
gcc (Gentoo 4.8.1-r1 p1.2, pie-0.5.7) 4.8.1
)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

