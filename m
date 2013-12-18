Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42605 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3LRVBb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 16:01:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VtOFG-0007XP-RT
	for linux-btrfs@vger.kernel.org; Wed, 18 Dec 2013 22:01:30 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 22:01:30 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 22:01:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Backporting bugfixes
Date: Wed, 18 Dec 2013 21:01:09 +0000 (UTC)
Message-ID: <pan$d376f$c26d0392$a268b32d$b503d0c7@cox.net>
References: <20131218140615.dbjsgs7zkssgckos-cebfxv@webmail.spamcop.net>
	<1387394605.25093.4.camel@ret.masoncoding.com>
	<20131218143153.4ffeb40a@IRBT4585>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pavel Roskin posted on Wed, 18 Dec 2013 14:31:53 -0500 as excerpted:

> On Wed, 18 Dec 2013 19:23:08 +0000 Chris Mason <clm@fb.com> wrote:
> 
>> We do tag some commits for stable, but Dave Sterba actually just sent a
>> request to the stable tree to pull in a few more.
> 
> That's great news!  Thank you for a quick reply!

In fact, here's the stable-queue request.

<http://permalink.gmane.org/gmane.linux.kernel.stable/73711

(It was cross-posted to both the btrfs and stable lists. =:^)

That said, while btrfs bugfixes are generally being submitted to stable 
when appropriate, as with all stable-tree patches since they aren't 
eligible for stable until they've hit the development kernel, the fastest 
(non-btrfs-next or direct-off-the-list) way to get them is to run either 
that development kernel.

Which isn't entirely inappropriate in any case, given that while the 
btrfs kconfig warnings were turned down some in 3.12, it's still under 
heavy development such that users who choose to run it are choosing to 
run a not yet fully stable filesystem, and if they're already risking 
their data on that, they might as well run a full development kernel too.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

