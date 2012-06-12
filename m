Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54374 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab2FLBxg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jun 2012 21:53:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SeGIY-0007ul-Ha
	for linux-btrfs@vger.kernel.org; Tue, 12 Jun 2012 03:53:34 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 03:53:34 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 03:53:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Moving top level to a subvolume
Date: Tue, 12 Jun 2012 01:53:23 +0000 (UTC)
Message-ID: <pan.2012.06.12.01.53.23@cox.net>
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Matthew Hawn posted on Fri, 08 Jun 2012 12:24:26 -0700 as excerpted:

> I just converted my root filesystem to btrfs with btrfs-convert. 
> However,
> since I am running Ubuntu, I would like to have the same subvolume
> structure as a default install,. How do I move the top-level subvolume
> (where all my files currently are) to another subvolume?

(Replied to list and to you, in case you're not subscribed.)

Arne answered your question, but just let me add a caution.

We get a lot of folks on this list who somehow miss the kernel warning, 
and the wiki warning, and the general community knowledge, that btrfs is 
still marked experimental and is still under heavy development.  If 
something goes wrong, as it often has for these folks when they post 
here...

So just be aware of that and be sure that if you're going to run it, you 
keep backups on something other than btrfs just in case, and that you 
keep them relatively current (depending on how much data from your btrfs 
systems you're willing to lose if it dies).

Also, it's worthwhile to keep up with this list to see current 
developments and bugs, to run a current kernel, generally meaning latest 
Linus release either stable or rc, and if you've not read up on the wiki, 
read up on btrfs there, too.

https://btrfs.wiki.kernel.org/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

