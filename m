Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52707 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbaDZEzy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 00:55:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WdueV-00070c-3v
	for linux-btrfs@vger.kernel.org; Sat, 26 Apr 2014 06:55:51 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 06:55:51 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 06:55:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: safe/necessary to balance system chunks?
Date: Sat, 26 Apr 2014 04:55:39 +0000 (UTC)
Message-ID: <pan$e0a75$522b09ff$7d8fffd0$f0b99281@cox.net>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung>
	<75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
	<535AA581.1080301@gmail.com> <535AACC0.2000600@shaw.ca>
	<7336D5A2-5CDD-45A4-9D43-E94F1C451137@colorremedies.com>
	<alpine.DEB.2.10.1404252035150.4873@cubia.leung>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steve Leung posted on Fri, 25 Apr 2014 20:56:06 -0600 as excerpted:

> Incidentally, is there a way for someone to tell what the node size
> currently is for a btrfs filesystem?  I never noticed that info printed
> anywhere from any of the btrfs utilities.

btrfs-show-super <device> displays that, among other relatively obscure 
information.  Look for node-size and leaf-size.  (Today they are labeled 
synonyms in the mkfs.btrfs manpage and should be set the same.  But if 
I'm remembering correctly, originally they could be set separately in 
mkfs.btrfs, and apparently had slightly different technical meaning.  Tho 
I don't believe actually setting them to different sizes was ever 
supported.)  

Sectorsize is also printed.  The only value actually supported for it, 
however, has always been the architecture's kernel page size, 4096 bytes 
for x86 in both 32- and 64-bit variants, and I'm told in arm as well.  
But there are other archs (including sparc, mips and s390) where it's 
different, and as the mkfs.btrfs manpage says, don't set it unless you 
plan on actually using the filesystem on a different arch.  There is, 
however, work to allow btrfs to use different sector-sizes, 2048 bytes to 
I believe 64 KiB, thus allowing a btrfs created on an arch with a 
different page size to at least work on other archs, even if it's never 
going to be horribly efficient.

The former default for all three settings was page size, 4096 bytes on 
x86, but node/leafsize were apparently merged at the same time their 
default was changed to 16 KiB, since that's more efficient for nearly all 
users.

What I've wondered, however, is if a 16K nodesize is more efficient than 
4K for nearly everyone, under what conditions might the even larger 32 KiB 
or even 64 KiB (the max) be even MORE efficient.

That I don't know, and anyway, I strongly suspect that being less tested, 
it might trigger more bugs anyway, and while I'm testing a still not 
entirely stable btrfs, I've not been /that/ interested in trying the more 
unusual stuff or in triggering more bugs than I might normally come 
across.

But someday curiosity might get the better of me and I might try it...

> In case anyone's wondering, I did balance the system chunks on my
> filesystem and "btrfs fi df" now looks normal.  So thanks to all for the
> hints and advice.

Heh, good to read. =:^)

Anyway, you provokes quite a discussion, and I think most of us learned 
something from it or at least thought about angles we'd not thought of 
before, so I'm glad you posted the questions. Challenged me, anyway! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

