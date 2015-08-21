Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53764 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbbHUJyR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 05:54:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZSj1T-0000SL-Ui
	for linux-btrfs@vger.kernel.org; Fri, 21 Aug 2015 11:54:07 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 11:54:07 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 11:54:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send/receive freezes a system
Date: Fri, 21 Aug 2015 09:54:00 +0000 (UTC)
Message-ID: <pan$cfe41$8e4e4add$ad942ea0$b8e86edd@cox.net>
References: <20150821021146.eb0d8b756fe7f3600685ee53@reasonset.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

MASAKI Yuhsuke posted on Fri, 21 Aug 2015 02:11:46 +0900 as excerpted:

> I want to "soft" mirroring between two remote btrfs volumes.
> I tried to use btrfs send/receive [but] it failed everytime.
> 
> 1st ) Pipe with SSH, to fresh filesystem. sender was flozen after
> transfared 2.79TiB.
> 2nd ) Delete snapshots and try again. sender was flozen after transfared
> 1.34TiB.

[...] 

> (Sender) ... Linux 4.1.5-1-MANJARO ...
> (Receiver) ... Linux 3.10.0-229.11.1.el7.x86_64 ...

On this list current kernels are strongly recommended, as btrfs remains 
in heavy development and is still not entirely stable yet. Now redhat 
(and presumably centos) does port many of the btrfs stability patches and 
some of the functionality back, such that the btrfs above is probably 
newer than the 3.10 would suggest, but there's still a rather large gap 
between the 4.1 on the sender side and the 3.10 on the receiver, and a 
lot of send/receive bugs have been found and fixed in the eleven 
intervening kernel cycles... about two years worth of development on a 
filesystem that as I said is under "heavy development"... between the two.

In fact, given that the "experimental" labels didn't even come off until 
3.12, IIRC, a 3.10 kernel is still officially experimental btrfs where 
even *more* stress was placed on keeping current as stable-patch backports 
weren't yet routine and thus should be *WELL* out of service more than 
two years and eleven kernel cycles later!

So I'd suggest trying a relatively new kernel, closer to the 4.1 on the 
receiver side, on the sender side as well, at least to test if it makes a 
difference in your send/receive results.  If possible, I'd recommend 
testing with the same kernel version, perhaps the latest longterm-stable 
series 3.18 (with 3.18.20 now current according to kernel.org), or the 
latest stable 4.1, on both.  You can try syncing up userspace versions as 
well (4.1.2 being latest stable last I checked a week or so ago).

Again, for testing, at least.  That way, you eliminate version 
differences as a possible problem.

If it works then, I'd suggest filing a bug with RH/CentOS, since their 
supposedly stable-backported version isn't compatible with a newer 
version, and that'd be a bug, due either to lack of appropriate 
backporting or lack of keeping reasonably current versions with a still 
in heavy development filesystem, one of the two.

If it doesn't work with send/receive versions synced and either current 
stable 4.1 series or latest current LTS 3.18 series, then it's a more 
current bug and this is the right place to report it, updated with the 
synced-current-version test results.

Because I know that quite a few send/receive fixes actually did go in 
over the last couple years, and while your distro may well have backported 
them, this is the upstream list, not your distro list, and that version 
number still says to us that you're using a more than two years outdated 
kernel, where btrfs was in fact still experimental, and for all we know, 
it's still lacking all those send/receive patches that have been applied 
in the mean time, and is thus still crawling with bugs that have long 
been exterminated in current stable.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

