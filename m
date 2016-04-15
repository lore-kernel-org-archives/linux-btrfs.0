Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54368 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbcDOAYa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 20:24:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aqrYh-000491-Uo
	for linux-btrfs@vger.kernel.org; Fri, 15 Apr 2016 02:24:28 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 02:24:27 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 02:24:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help ! "btrfs check" looping recursive
Date: Fri, 15 Apr 2016 00:24:21 +0000 (UTC)
Message-ID: <pan$9e5b6$4adde6c7$caa17ba5$f91d4445@cox.net>
References: <570FCBBD.2010500@petaramesh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Thu, 14 Apr 2016 18:56:29 +0200 as excerpted:

> It seems that i have a "btrfs check" process that’s stuck in an infinite
> recursive loop…
> 
> How could I end this without breaking my filesystem ?

...

> root@PartedMagic:~# btrfs check --repair /dev/VGZ/LINUX
> enabling repair mode [...]


[Just a btrfs user and list regular myself, not a btrfs dev and not at a 
level to specifically answer the question.]

Given the prompt above, you're running from parted-magic, but that 
doesn't tell us the btrfs-progs or kernel versions unless we look it up.

So kernel and btrfs-progs version?  Also, btrfs filesystem show output 
might be useful.

(Tho in this specific context, kernel version isn't as useful as normal, 
since unlike many btrfs commands that simply call kernel code to do the 
real work, check code is all userspace.  But it's can't hurt to post it.  
Similarly, btrfs fi df to compliment btrfs fi show, or btrfs fi usage to 
output the same information as both, would in other contexts be useful, 
but they require a mounted filesystem, not something you can really even 
try with check running.)

Btrfs-progs version in particular, since the recursive nature of this 
loop is very obviously a bug.  If it's a current progs version, the bug 
may have been recently introduced.  If it's a dated version, the bug may 
have already been fixed.  (Either way, it may be that someone else will 
recognize the bug and tell you to try a later/earlier version, or if not, 
you very well may prompt a new patch, possibly after some further 
debugging.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

