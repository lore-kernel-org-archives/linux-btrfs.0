Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59150 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaJTEip (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 00:38:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xg4jy-000436-EJ
	for linux-btrfs@vger.kernel.org; Mon, 20 Oct 2014 06:38:42 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Oct 2014 06:38:42 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Oct 2014 06:38:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: strange 3.16.3 problem
Date: Mon, 20 Oct 2014 04:38:28 +0000 (UTC)
Message-ID: <pan$9907e$9b197fe7$2a806862$700ddfa7@cox.net>
References: <201410181454.19375.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sat, 18 Oct 2014 14:54:19 +1100 as excerpted:

> # find . -name "*546"
> ./1412233213.M638209P10546 # ls -l ./1412233213.M638209P10546 ls: cannot
> access ./1412233213.M638209P10546: No such file or directory

Does your mail server do a lot of renames?  Is one perhaps stuck?  If so, 
that sounds like the same thing "Zygo Blaxell" is reporting in the 
"3.16.3..3.17.1 hang in renameat2()" thread, OP on Sun, 19 Oct 2014 
15:25:26 -400, Msg-ID: <20141019192525.GA29401@hungrycats.org>, as linked 
here:

<http://permalink.gmane.org/gmane.comp.file-systems.btrfs/39539>

I pointed him at this thread too.  I hadn't seen you mention a hung 
rename, but the other symptoms sound similar.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

