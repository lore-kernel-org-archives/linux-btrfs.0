Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37530 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbaIPQiB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 12:38:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XTvlO-0005c6-71
	for linux-btrfs@vger.kernel.org; Tue, 16 Sep 2014 18:37:58 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 18:37:58 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 18:37:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance enospc
Date: Tue, 16 Sep 2014 16:37:46 +0000 (UTC)
Message-ID: <pan$87ec6$9545d881$ab61f879$16b488c7@cox.net>
References: <541706ED.4010901@intellasoft.net> <20140915170722.GA9160@sune>
	<541723EA.6010608@intellasoft.net>
	<657EBB8A-8957-4E07-829E-171A1FF702E8@colorremedies.com>
	<pan$21d6d$91a64041$49bf8e34$6b7c2e69@cox.net>
	<54179F33.2010600@intellasoft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Murawski posted on Mon, 15 Sep 2014 22:23:47 -0400 as excerpted:

> I wish i could follow your procedure, but this wasn't an ext conversion.
> 
> I made this with mkfs for btrfs with kernel circa 3.8ish

Good.  That possible corner-case is eliminated. then.  I had seen nothing 
indicating it might apply, but better to find that out now than to spend 
days tearing hair out trying to trace it down, only to discover it's that 
one already known corner-case!  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

