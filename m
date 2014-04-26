Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54486 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaDZEXd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 00:23:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wdu97-00017k-On
	for linux-btrfs@vger.kernel.org; Sat, 26 Apr 2014 06:23:25 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 06:23:25 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 06:23:25 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: safe/necessary to balance system chunks?
Date: Sat, 26 Apr 2014 04:23:13 +0000 (UTC)
Message-ID: <pan$3ed2f$4edb7153$eb405bea$cf2b6b8@cox.net>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung>
	<75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
	<535AA581.1080301@gmail.com>
	<pan$a73aa$187744ee$76aa9d20$301f58e9@cox.net>
	<765C03C7-08EB-4927-8934-5D6F926D6008@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 25 Apr 2014 19:41:43 -0600 as excerpted:

> OK so somehow in Steve's conversion, metadata was converted from DUP to
> RAID1 completely, but some portion of system was left as DUP,
> incompletely converted to RAID1. It doesn't seem obvious that -mconvert
> is what he'd use now, but maybe newer btrfs-progs it will also convert
> any unconverted system chunk.
> 
> If not, then -sconvert=raid1 -f and optionally -v.
> 
> This isn't exactly risk free, given that it requires -f; and I'm not
> sure we can risk assess conversion failure vs the specific drive
> containing system DUP chunks dying. But for me a forced susage balance
> was fast:
> 
> [root@rawhide ~]# time btrfs balance start -susage=100 -f -v /
> Dumping filters: flags 0xa, state 0x0, force is on
>   SYSTEM (flags 0x2): balancing, usage=100
> Done, had to relocate 1 out of 8 chunks
> 
> real	0m0.095s user	0m0.001s sys	0m0.017s

Yes.  The one thing that can be said about system chunks is that they're 
small enough that processing just them should be quite fast, even on 
spinning rust.

So regardless of whether there's a safety issue justifying the required 
-f/force for -s/system-only, or not, unlike the possibly many hours a 
full balance or some minutes to an hour or so a full balance on a large 
spinning rust based btrfs may take, at least if there is some possible 
danger in the -s system alone rebalance, the risk-window should be quite 
small, time-wise. =:^)

And correspondingly, safety issue or not, I've never seen a report here 
of bugs or filesystem loss due to use of -s -f.  That doesn't mean it 
can't happen, that's under debate and I can't safely say; it does mean 
you're pretty unlucky if you're the first to have a need to report such a 
thing, here. =:^\

But we all know that btrfs is still under heavy development, and thus 
have those tested backups ready just in case, right?  In which case, I 
think whatever risk there might be relative to that of simply using btrfs 
at all at this point in time, must be pretty negligible. =:^)  Tho a few 
people each year still do get struck by lightening... or win the lottery. 
Just living is a risk.  <shrug>

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

