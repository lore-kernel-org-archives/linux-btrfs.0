Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40989 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbbD3Gpi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 02:45:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YniE4-0007wS-FS
	for linux-btrfs@vger.kernel.org; Thu, 30 Apr 2015 08:45:36 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2015 08:45:36 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2015 08:45:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Carefully crafted BTRFS-image causes kernel to crash
Date: Thu, 30 Apr 2015 06:45:29 +0000 (UTC)
Message-ID: <pan$ed01c$e6116e7b$212a3ca1$143655a4@cox.net>
References: <CAJF-kYngS4U6=oiXhs0ZF3Na3ezTGcMX1Wyd5HVVm887V61mWw@mail.gmail.com>
	<5535C11C.2050308@cn.fujitsu.com> <20150421151714.GA19017@hungrycats.org>
	<5536EB13.8060902@cn.fujitsu.com>
	<CAJF-kY=eqWA_hc+XCHYUEH58x7=hKQ0rm+bSGiaXoWv+tppGyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lukas Lueg posted on Wed, 29 Apr 2015 21:50:23 +0200 as excerpted:

> To give some context: Testing the userland tools to some depths comes
> back with around 13 percent of all execution paths in around 40 million
> runs to result in a segmentation fault, an uncatched divide-by-zero or
> self-destruction due to a heap buffer overflow catched by glibc. That is
> to be compared with zero crashes in the ext2fs userland tools.

In a field of 40 million trinity fuzz tester runs, one out of eight btrfs-
tools userspace runs crashed due to some abnormality, compared to 0 
crashes for e2fsprogs.

That's _very_ impressive for e2fs.  I'm sure it's because people have 
been doing just that, beating on it with trinity and the like, for 
awhile, and the problems have been fixed already, but that makes it no 
less impressive.  It takes both work and loving care to get to that 
point, and this demonstrates just how much of that it gets, to get to the 
_zero_ crash (in tens of millions of runs) point.

Meanwhile, one of eight for btrfs-progs.  Of course the focus has so far 
been pretty much on just getting the tools and basic functionality, so 
there's a reason, but it has a _long_ way to go from one of eight to 
_zero_ of 40-million!

Just one more demonstration of the fact that btrfs really isn't and can't 
be called stable yet, even if from about a year ago they _have_ pretty 
well stripped all the warnings telling people that.

Of course userspace is only the half of it, but _zero_ fuzzer crashes in 
40 million runs... userspace or kernelspace regardless, that's quite some 
work showing off there, and they have a right to be proud of it.  Btrfs 
would be so lucky!  But your beating on it and Qu's fixup patches are a 
start at getting us there.  Thanks! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

