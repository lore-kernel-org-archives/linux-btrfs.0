Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57951 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaILF7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 01:59:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XSJtf-0003Mz-Ci
	for linux-btrfs@vger.kernel.org; Fri, 12 Sep 2014 07:59:51 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 07:59:51 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 07:59:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how long should "btrfs device delete missing ..."  take?
Date: Fri, 12 Sep 2014 05:59:37 +0000 (UTC)
Message-ID: <pan$b85d$251aebce$f889e0c4$87a03321@cox.net>
References: <84a98bc5f667c04ca74ff77b56f537d9@admin.virtall.com>
	<pan$2d5ba$86c3ebd8$b81abab$13e892ea@cox.net>
	<4A9B52AD-8104-4C31-9BA4-13D329D2F952@colorremedies.com>
	<pan$a2cc2$dc8ad02$d35780a0$4fefc791@cox.net>
	<6AE06E73-C89E-42F0-9A09-FA92C68DED69@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 11 Sep 2014 20:10:26 -0600 as excerpted:

> Sure. But what's the next step? Given 260+ snapshots might mean well
> more than 350GB of data, depending on how deduplicated the fs is, it
> still probably would be faster to rsync this to a pile of drives in
> linear/concat+XFS than wait a month (?) for device delete to finish.

That was what I was getting at in my other just-finished short reply.  It 
may be time to give up on the btrfs specific solutions for the moment and 
go with tried and tested traditional solutions (tho I'd definitely *NOT* 
try rsync or the like with the delete still going, we know from other 
reports that rsync places its own stresses on btrfs and one major 
stressor, the delete-triggered rebalance, at a time, is bad enough).

> Alternatively, script some way to create 260+ ro snapshots to btrfs
> send/receive to a new btrfs volume; and turn it into a raid1 later.

No confirmation yet but I strongly suspect most of those subs are 
snapshots.  Assuming that's the case, it's very likely most of them can 
simply be eliminated as I originally suggested, a process that /should/ 
be fast, decomplexifying the situation dramatically.

> I'm curious if a sysrq+s followed by sysrq+u might leave the filessystem
> in a state where it could still be rw mountable. But I'm skeptical of
> anything interrupting the device delete before being fully prepared for
> the fs to be toast for rw mount. If only ro mount is possible, any
> chance of creating ro snapshots is out.

In theory, that is, barring bugs, interrupting the delete with normal 
shutdown to the extent possible, then sysrq+s, sysrq+u, should not be a 
problem.  The delete is basically a balance, going chunk by chunk, and 
either the chunk has been duplicated to the new device or it hasn't.  In 
either case, the existing chunk on the remaining old device shouldn't be 
affected.

So rebooting in that way in ordered to stop the delete temporarily 
/should/ have no bad effects.  Of course, that's barring bugs.  Btrfs is 
still not fully stabilized, and bugs do happen, so anything's possible.  
But I'd consider it safe enough to try here, certainly so if I had 
backups, as is still STRONGLY recommended for btrfs at this point, much 
more so than the routine sysadmin "if it's not backed up by definition 
it's not valuable to you" rule.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

