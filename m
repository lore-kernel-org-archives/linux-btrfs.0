Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35663 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315AbaJUL1J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 07:27:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XgXai-0002XH-UY
	for linux-btrfs@vger.kernel.org; Tue, 21 Oct 2014 13:27:04 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 13:27:04 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 13:27:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: downgrade from kernel 3.17 to 3.10
Date: Tue, 21 Oct 2014 11:26:53 +0000 (UTC)
Message-ID: <pan$e55c6$e7985780$d6580cb2$76eb6d4@cox.net>
References: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cristian Falcas posted on Tue, 21 Oct 2014 11:13:48 +0300 as excerpted:

> Can I downgrade the kernel from 3.17.1 to latest 3.10 if I have a btrfs
> partition formatted and used on 3.17.1?
> 
> I mean, is there something that could go wrong with the fs if suddenly I
> use an older kernel?
> 
> I want to downgrade because last night we had some 1200 oops's in 1 hour
> on the 3.17 kernel related to "CPU#n stuck" and what seems to be btrfs
> work:

You definitely don't want to downgrade that far -- there's way too many 
btrfs fixes since then and you'd be needlessly risking your data.

Much more viable would be to downgrade to the latest 3.16.x stable kernel 
(definitely not 3.16.0 or 3.16.1 as they had an open issue much like 
3.17.0 does), and then upgrade to the latest 3.17.x in a couple weeks, as 
there's some critical stable fixes in the pipeline for it.

Or if you must, 3.14.x is the latest long-term-stable series, and is 
continuing to get btrfs-stable patches along with the other stable 
patches it gets.

But I'd definitely not recommend reverting to older than 3.14.x stable 
series, because even if it's a stable series and they catch and apply to 
stable all the patches that ideally need to be applied back that far, if 
you have problems, what you'd be running is simply too far back in 
history to get much support on this list for.

Also, keep in mind that the btrfs-is-experimental warnings didn't come 
off until 3.12 or so.  Any btrfs older than that was officially 
experimental when it came out, and even if it's a long-term-stable 
kernel, no stable series patches are going to remove the still 
experimental nature of btrfs in a kernel that old.

So 3.10, no way if it were /my/ data!  Latest 3.14.x stable, I'd 
consider.  But preferably step back to the latest 3.16.x (past 3.16.2 for 
sure) temporarily, and try latest 3.17.x again in a couple weeks (or 3.18-
live-git now) as there's some critical fixes for 3.17-stable now in 3.18 
and still making their way to the stable releases.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

