Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36269 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3HMEJg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 00:09:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V95vL-0004Qm-IP
	for linux-btrfs@vger.kernel.org; Tue, 13 Aug 2013 06:09:35 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 06:09:35 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 06:09:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-ino-cache is running on each reboot
Date: Tue, 13 Aug 2013 04:09:17 +0000 (UTC)
Message-ID: <pan$9b25b$c3cfd854$ecd09a4$c58fb9da@cox.net>
References: <52098BDB.5010400@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

dima posted on Tue, 13 Aug 2013 10:28:59 +0900 as excerpted:

> About a week or so ago I noticed that [btrfs-ino-cache] process was
> appearing in the 'top' on each reboot and disk is spinning like crazy
> for about five minutes or so. Quite so often this caused X failing to
> start because all I/O was busy with caching.
> Even after letting it to calm down and seeing [btrfs-ino-cache]
> disappearing from the process list, on next reboot it starts all over
> again.

> inode_cache was always enabled since the FS was created about a year or
> so ago, and actually I have never had any problems with it up until
> recently.
> 
> Removing inode_cache option from fstab solves the problem, but I am not
> sure if it is the right choice.

A number of people have reported problems with inode_cache enabled, and 
the recommendation has always been to turn it off "unless you need it".  
Easy enough problem to fix, I guess. =:^)

Of course that immediately invites the question of why have the option at 
all if all it does is cause trouble, and (as a user not a dev) I don't 
have the answer to that.  I don't know the use case when "unless you need 
it" would actually apply, but apparently, it does in some cases.

I guess the wiki[1] should really have a warning on that option, but 
without a more solid reason than "just don't turn it on, causes more 
trouble than it's worth", I'd feel kind of goofy adding it.

Anyway, yes, the general recommendation on the list at this point seems 
to be to simply leave inode_cache off and not worry about it.

---
[1] https://btrfs.wiki.kernel.org/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

