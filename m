Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50374 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S934609AbcIPXS1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 19:18:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bl2Og-0001w1-8d
        for linux-btrfs@vger.kernel.org; Sat, 17 Sep 2016 01:18:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Filesystem will remount read-only
Date: Fri, 16 Sep 2016 23:18:03 +0000 (UTC)
Message-ID: <pan$d74d4$cbd69fcd$ef8693ee$7eb1227f@cox.net>
References: <8AC4324B47948D40A1031D5AB7D077820141E77717@mailstore.skyward.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jeffrey Michels posted on Fri, 16 Sep 2016 14:57:43 +0000 as excerpted:

> Hello,
> 
> I have a system that has been in production for a few years.  The SAN
> the VM was running on had a hardware failure about a month ago and now
> one of the two btrfs filesystems will remount after boot read-only. 
> Here is the system information:
> 
> uname -a
> 
> Linux retain 3.0.101-0.47.71-default #1 SMP Thu Nov 12 12:22:22 UTC 2015
> (b5b212e) x86_64 x86_64 x86_64 GNU/Linux
> 
> Btrfs --version
> 
> Btrfs v0.20+

That is positively /ancient/, both kernel and userspace (btrfs-progs).  
Keep in mind that btrfs was still considered very experimental back then, 
with the experimental labels coming off only with 3.14 or there abouts, 
IIRC (userspace releases got version-synced with kernelspace in 3.12, so 
3.14 applies to both).

So you have been running an at-the-time still extremely experimental 
filesystem for years now, and it's only now coming up with problems that 
need fixed.  Pretty remarkable for the experimental state back then, but 
it doesn't change the fact that it /was/ "may eat your data and burn your 
kids alive as a sacrifice to appease the filesystem gods" level 
experimental, with the according warnings, back then.

So first thing I'd suggest is to update to kernel 4.4 LTS series, and 
something similar for btrfs-progs userspace.  Then, given the age and 
experimental nature of the filesystem back then, I'd kill the filesystems 
and do a fresh mkfs.btrfs, restoring from backups.  That way you're 
starting with a well tested and stable LTS kernel that is both reasonably 
mature already, and will be supported for some time to come, and 
eliminate any possibility of long fixed and forgotten bugs coming back to 
bite you years later.

Alternatively, if you're using a long-term support distro, you have the 
choice of going to them for that support, since unlike this list which 
focuses on the state going forward, that sort of deep long-term support 
of long outdated versions is a good part of the reason such distros 
exist, and a good part of why a lot of people are willing to pay 
sometimes rather sizable sums of money /for/ that level of support.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

