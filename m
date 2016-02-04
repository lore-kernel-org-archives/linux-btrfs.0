Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47956 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965102AbcBDL63 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 06:58:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aRIYM-0003bQ-Lc
	for linux-btrfs@vger.kernel.org; Thu, 04 Feb 2016 12:58:26 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 12:58:26 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 12:58:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs partition spontaneously corrupted - No recovery options.
 Kernel oops / "Kernel Bug"?
Date: Thu, 4 Feb 2016 11:58:19 +0000 (UTC)
Message-ID: <pan$4011$3b1fe622$6c264b3e$ad231174@cox.net>
References: <CCD0821AE781994EB8BAB510676B5EF502F2987D7119@ZEUS.faredge.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dion Gullotta posted on Thu, 04 Feb 2016 12:28:09 +1100 as excerpted:

> root@odin:/var/readynasd# uname -a
> Linux odin 3.0.101.RN2120.3 #1 SMP
> Wed Apr 1 16:09:30 PDT 2015 armv7l GNU/Linux

Qu's helping you on the practical side, as a dev, far better than I could 
as a user, but here's a bit of additional higher-level information for 
your consideration.

That's an incredibly ancient kernel, in btrfs terms.  Btrfs didn't have 
the experimental tag stripped until 3.12, which is already seriously 
ancient in btrfs terms, and at least nominally that's a 3.0 kernel, not 
only half a decade old now (four years of 3.x kernels plus a year of 4.x, 
at five releases/year), but more than two years back before the 
experimental label came off in 3.12!

Of course the comparatively (still nearly a year old, tho) recent April, 
2015 build date does hint that it's likely a heavily backport-patched 
kernel, but what btrfs patches have been backported and which ones 
haven't, probably only the project devs are tracking, and it's nothing 
we'd know here, targeting mainstream, where for btrfs at least, that's a 
very old and heavily experimental btrfs kernel indeed!

General recommendations here, in view of the fact that btrfs, while no 
longer experimental, is still under heavy development, is to keep to the 
latest couple of release series, either current or LTS.  With 4.4 out as 
an LTS, that would be 4.4 and 4.1 as LTS kernel series, and 4.4 and 4.3 
as current kernel series, tho with 4.4 so new in LTS terms and btrfs 
stability and maturity still developing, the previous LTS, 3.18, is still 
somewhat supported and may continue to be, making it three LTS series.  
But certainly, before 3.18 LTS, while we do still try to help, 
development remains fast enough that it's simply old, and unlikely to be 
well supported at all simply for practical reasons.

So you may want to either upgrade to at /least/ the 3.18 LTS series and 
preferably at least 4.1 LTS if you're continuing to run btrfs, *OR* get 
support from your distro, as presumably if they're still running and 
choosing to support then highly experimental btrfs on such nominally old 
and seriously experimental btrfs kernels, they have good reasons, and 
they may be better positioned to provide btrfs support on something that 
ancient than this list is, *OR* if you have good reason to continue on 
such old kernels, I'd strongly urge you to reconsider whether btrfs, 
particularly at the experimental level it was back in kernel 3.0, is an 
appropriate choice for such long-term-stable projects as that appears to 
be, using half-decade-old kernels with then still highly experimental 
btrfs.  It's very likely in the latter case, that a fully stable and 
mature filesystem such as ext3/4 (was ext4 even really stable yet a half 
decade ago? ext3 may be better on a 3.0 kernel, I'm not sure), or the 
reiserfs I used for years and have had very good experience with (at 
least since the data=ordered default was introduced a decade or so ago), 
is much more suitable for that use-case, than something like the still 
stabilizING and maturING even in current kernels btrfs.

Now your btrfs userspace tools are rather more current at 3.17, but even 
that's relatively old, now, the rule of thumb for userspace being to keep 
its version at least matching the kernel version, assuming it's kept 
reasonably current, which would again mean 3.18 series at the oldest, 
that being the oldest LTS series really supported, and again, preferably 
newer than that, 4.1 series or newer, up to the current 4.4, as current 
userspace can normally be used with older kernels without issue except 
for mkfs.btrfs, where you'll want to specify options to be compatible 
with older kernels that didn't have code for newer on-device formats, yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

