Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50035 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbaLAFre (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 00:47:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvJpd-0002W7-FI
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 06:47:33 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 06:47:33 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 06:47:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
Date: Mon, 1 Dec 2014 05:47:18 +0000 (UTC)
Message-ID: <pan$6be5e$a00482b7$895022c1$577dcbfa@cox.net>
References: <547BCB43.5020505@cn.fujitsu.com>
	<pan$d4d18$d4463d$8df93dd7$d770703b@cox.net>
	<547BDF82.3030305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 01 Dec 2014 11:24:50 +0800 as excerpted:

> The db file is mostly used in memory, only when the metadata is really
> really big, maybe when the fs tree's level is 7 or 8 we may need to use
> db file.

So fscking the database in ordered to fsck the database isn't an issue.  
One objection down! =:^)

But seriously, the politics of the idea remains its biggest nemesis in my 
opinion.  And in systemd we've unfortunately a live demonstration of just 
how big a nemesis that can be.  =:^(  If the technical reasoning for it 
is sound and the benefit high enough, great, but IMO the benefit will 
need to be pretty high to justify the risk of political fallout, and I 
doubt it's anything close to that high.  But it's not my call, so we'll 
see.  Thinks could certainly get interesting if it's judged to be worth 
it.  < Checking popcorn stash >

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

