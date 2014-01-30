Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36353 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbaA3WSY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 17:18:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W8zwF-0003tB-EH
	for linux-btrfs@vger.kernel.org; Thu, 30 Jan 2014 23:18:23 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 23:18:23 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 23:18:23 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: lost with degraded RAID1
Date: Thu, 30 Jan 2014 22:18:01 +0000 (UTC)
Message-ID: <pan$3f5b6$fcf027de$d8c8fe27$ce2a7e6f@cox.net>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
	<CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Johan Kröckel posted on Thu, 30 Jan 2014 12:53:44 +0100 as excerpted:

> [Answer from Duncan, 1i5t5.duncan@DOMAIN.HIDDEN (Thanks for the try)]
> 
> [AFAIK that shouldn't be the case.  Degraded should allow the RW mount
> -- I know it did some kernels ago when I tried it then, and if it
> changed, it's news to me too, in which case I need to do some
> reevaluation here.]
> 
> What I think /might/ have happened is that there's some other damage to
> the filesystem unrelated to the missing device in the raid1, which
> forces it read-only as soon as btrfs finds that damage.  However, mount
> -o remount,rw,degraded should still work, I /think/.]
> 
> http://www.spinics.net/lists/linux-btrfs/msg20164.html

Thanks.  I had seen that message go by but obviously missed all the 
implications.

IMO the idea of the patch is correct as a default, but there should be a 
way to override, since AFAIK ro-mount will I believe at times prevent 
undegrading as well, certainly when an admin's choice to clear the 
degraded state is reduced redundancy, which is what you're doing.

IOW, I guess I don't agree with that patch as it was apparently 
committed.  There needs to be a force option as well.

Meanwhile, back to the current situation.  Given that you found the patch 
preventing what you were trying to do, what happens if you simply find 
that commit in the git repo, revert and rebuild?  Assuming there are no 
further commits building on that one, a revert and rebuild should at 
least allow you to complete the half-completed balance.

And regardless of whether btrfs policy is to prevent that entirely in the 
future or not, definitely letting you start the balance before a reboot 
and not letting you finish it afterward is a bug.  It should either be 
prevented entirely, or allowed to finish after a reboot if it was allowed 
to start.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

