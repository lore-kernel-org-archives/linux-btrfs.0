Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40010 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbaA2Bzw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 20:55:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W8KNb-0003dr-LQ
	for linux-btrfs@vger.kernel.org; Wed, 29 Jan 2014 02:55:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 02:55:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 02:55:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Rapid memory exhaustion during normal operation
Date: Wed, 29 Jan 2014 01:55:28 +0000 (UTC)
Message-ID: <pan$4117f$37c109bd$5e86c97$a007d311@cox.net>
References: <52E430F7.7030801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dan Merillat posted on Sat, 25 Jan 2014 16:47:35 -0500 as excerpted:

> I'm trying to track this down - this started happening without changing
> the kernel in use, so probably a corrupted filesystem. The symptoms are
> that all memory is suddenly used by no apparent source.  OOM killer is
> invoked on every task, still can't free up enough memory to continue.
> 
> When it goes wrong, it's extremely rapid - system goes from stable to
> dead in less than 30 seconds.
> 
> Tested 3.9.0, 3.12.0, 3.12.8.   Limited testing on 3.13 shows I think
> the same problem but I need to double-check that it's not a different
> issue. Blows up the exact same way on a real kernel or in UML.
> 
> All sorts of things can trigger it - defrag, random writes to files.
> Balance and scrub don't,
> readonly mount doesn't.
> 
> I can reproduce this trivially, mount the filesystem read-write and
> perform some activity.  It only takes a few minutes.   The other btrfs
> filesystems on the same machine don't show similar problems.

I was hoping someone with a bit more expertise in the area would reply to 
this, but if they did, I missed it, and I had kept this marked unread to 
reply to after the weekend if nobody better qualified replied first.  So 
here it is... sorry it took so long (I've been on the other end myself), 
but under the circumstances...

Two possibilities I'm aware of.

The one that best matches the outlined circumstances is qgroups.  Are you 
using quotas/qgroups on that filesystem?  There's some weird corner-cases 
with them still, including negative quotas after subvolume delete and 
apparently qgroup-triggered runaway memory usage as reported here, that 
remain a problem.  I see patches addressing various bits going by on the 
list, but I've been steering a wide course around any potential qgroups 
usage here in part because of the scary reports I keep seeing onlist, and 
would recommend others not directly involved in qgroup development and 
testing do the same for now.  So if you can avoid qgroups on your btrfs 
deployments do so, for now.  If your use-case NEEDS quota/qgroup 
functionality, then I'd recommend using something other than btrfs for 
the time being, perhaps with a reexamination scheduled in a year as 
hopefully the qgroup bugs will be worked thru by then and it'll be 
reasonably stable functionality, something I'd definitely NOT 
characterize qgroups as, ATM.

The other but less close match possibility I'm aware of is the large 
(half-gig plus) internal-write file case, with VM images, large database 
files and pre-allocated-then-written files such as bittorrent clients 
often create, being prime examples.  Ideally these should be located in a 
directory with the NOCOW (chattr +C) set on the directory BEFORE the 
files are created and written into, so they inherit it.  There are 
present reported problems, sometimes reaching pathelogic degree, with 
these files if NOT properly marked NOCOW, but the biggest trigger there 
appears to be extreme snapshotting (thousand-plus) in addition to the 
large internal-rewritten files, and the bottleneck is reported to be CPU, 
not IO or memory.  Additionally, balance will trigger that issue too, and 
you're saying it doesn't for you, so I'd say this isn't likely to be your 
particular problem ATM, and am mostly just throwing it in in case you're 
not using qgroups so the above can't be your issue, and as a heads-up to 
be on the lookout for.

If you're using qgroups, I'd consider that the 90+% likely culprit.  
They're Just. Not. Ready.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

