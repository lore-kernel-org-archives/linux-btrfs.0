Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52176 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbbL2QoW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 11:44:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDxNh-0000An-PN
	for linux-btrfs@vger.kernel.org; Tue, 29 Dec 2015 17:44:18 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 17:44:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 17:44:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Date: Tue, 29 Dec 2015 16:44:12 +0000 (UTC)
Message-ID: <pan$77b8$70538e05$c21bb62d$4aa6e02@cox.net>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<1451341195.7094.0.camel@scientia.net> <20151228153801.6561feff@gmail.com>
	<1451352069.7094.3.camel@scientia.net> <20151228164333.2b8d8336@gmail.com>
	<1451360528.7094.7.camel@scientia.net> <20151228190336.59a3f440@gmail.com>
	<1451363188.7094.23.camel@scientia.net>
	<20151228203111.7ba8b0be@gmail.com>
	<1451368991.7094.45.camel@scientia.net>
	<20151228212343.449c8631@gmail.com>
	<1451403179.13713.11.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Tue, 29 Dec 2015 16:32:59 +0100 as
excerpted:

>> From Documentation/filesystems/BTRFS.txt:
>> Btrfs is under heavy development, and is not suitable for any uses
>> other than benchmarking and review.

> Well I guess now it's time for Duncan's usual "stable or not" talk
> (@Duncan, I think by now, you should have made it into some verse or
> ballad form... :D for general pleasure ;) )

=:^)

The devs did remove most of the experimental warnings some versions ago.  
I guess they missed that one.  The "heavy development" part is definitely 
still correct, but with the caveats below, I don't believe the "only 
benchmarking and review" fits the generally held list position, these 
days.

As I normally put it, btrfs is "definitely stabilizING, but not yet 
entirely stable and mature."  What that means in real life is that while 
not yet recommended for production use where down time costs money and 
potentially jobs, it's generally ready for routine daily use, PROVIDED 
one observes the usual admin's rule of backups, that for any level of 
backup, either you have it, or you consider the data it would cover to be 
worth less than the hassle and resources that backup would take, modified 
by the risk factor of actually having to use the backup.  Because btrfs 
is still stabilizing, that risk factor remains somewhat elevated, so you 
better have at least 1-2 levels of backup if you don't consider the data 
of trivial throw-away value.

Beyond that, keeping up with the list and staying relatively current with 
your kernel and btrfs-progs userspace are strongly recommended as well.

But it's definitely not recommended yet for the conservative stability 
types that run half a decade old "stable" enterprise distros.  That sort 
of use-case is in basic conflict with where btrfs is at this point, and 
people wishing to run it should be looking to some other filesystem, or 
if they /do/ choose to take up the enterprise distros on their offer of 
support for btrfs, should be looking to them for that support, as it's 
them that are choosing to offer it, while the general position on the 
list seems to be "that's insane".

Similarly of course for those unwilling to do backups or run relatively 
current kernels and btrfs userspace, or to keep up with the list.  In 
that case, btrfs isn't an appropriate choice for them.

But while not entirely stable and mature yet, that's still rather beyond 
"not suitable for any uses other than benchmarking and review", and 
indeed, most of the other wording of that nature was stripped around 
kernel 3.12, and while some of us considered that a bit early, I think 
most would agree that the "benchmarking and review" only wording is 
somewhat dated, by now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

