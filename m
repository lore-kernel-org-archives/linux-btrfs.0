Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52251 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914Ab3KHKJo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 05:09:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vej0Y-0007Fz-N3
	for linux-btrfs@vger.kernel.org; Fri, 08 Nov 2013 11:09:42 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2013 11:09:42 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2013 11:09:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck errors is it save to fix?
Date: Fri, 8 Nov 2013 10:09:22 +0000 (UTC)
Message-ID: <pan$2f107$ddc92f2a$30381770$58497a03@cox.net>
References: <52742B59.3060405@friedels.name>
	<CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com>
	<5274BEC8.5060804@friedels.name> <52780E20.8020405@friedels.name>
	<CAE5mzvgrKqrv3LpmiF6iUK=GYsnGOQnSwLTM0dSfBE8ZP-4AuA@mail.gmail.com>
	<5279E581.4000700@friedels.name> <527BE712.40304@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hendrik Friedel posted on Thu, 07 Nov 2013 20:16:34 +0100 as excerpted:

> can someone please help me on this?

Your replies are upside down (reply before the quoted context in which it 
should be taken, edited to replied context as appropriate), so I've not 
included further quoted context.

To answer the "is it safe to fix" question...

The answer is relative.  Btrfs itself remains officially an experimental/
development filesystem (as seen in the kernel option enabling it and on 
the btrfs wiki[1]), suitable only for testing with data that can be lost 
to the test without serious impact, either because you keep a tested 
backup of sufficient recency that you'd be comfortable declaring what's 
on btrfs a totally irrecoverable loss, or because it's simply scratch 
data for testing only in the first place.

In that context, yes, it's safe to btrfsck --repair, because you're 
prepared to lose the entire filesystem if worse comes to worse in any 
case, so even if btrfsck --repair makes things worse instead of better, 
you've not lost anything you're particularly worried about anyway.

If that's /not/ the case, then you really should be reexamining your 
choice of btrfs in the first place, as your stability requirements simply 
are not covered by btrfs at this point.  Either choose another filesystem 
or change your backup practices and thus your stability requirements to 
be in line with btrfs' current state.

[1] https://btrfs.wiki.kernel.org

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

