Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48229 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbaEFULt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 16:11:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Whkwv-0005Rk-Dy
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 21:22:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 21:22:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 21:22:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs scrub will not start nor cancel howto
Date: Mon, 5 May 2014 02:52:37 +0000 (UTC)
Message-ID: <pan$cc5c2$d078531$622abad8$ab052cbb@cox.net>
References: <20140504075407.GM9061@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 04 May 2014 00:54:07 -0700 as excerpted:

> This has been asked a few times, so I ended up writing a blog entry on
> it [and then] in the end pasted all of it in the main wiki
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#btrfs_scrub_will_not_start_nor_cancel
> 
> Of course, this is really a stopgap until the cancel tool can realize
> that the scrub isn't really running anymore, and update the state file
> on its own.

Thanks.  As you said, this has come up a few times, so having it
on the wiki is a very good thing. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

