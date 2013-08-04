Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47467 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab3HDWUG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Aug 2013 18:20:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V66eh-0006Zx-UC
	for linux-btrfs@vger.kernel.org; Mon, 05 Aug 2013 00:20:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 00:20:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 00:20:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recovery advice
Date: Sun, 4 Aug 2013 22:19:31 +0000 (UTC)
Message-ID: <pan$b7e2c$bf7f3666$af6e4a6$909b9d97@cox.net>
References: <CAPs0BijizOo0c566U6-uAe1voCr-W2SVHkMeT1sirTfi4jgeSg@mail.gmail.
	com> <kpu1da-elm.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sun, 04 Aug 2013 14:41:54 +0200 as excerpted:

> It is a RAID-1 so why bother with the faulty drive? Just wipe it, put it
> back in, then run a btrfs balance... There should be no data loss
> because all data is stored twice (two-way mirroring).

The caveat would be if it didn't start as btrfs raid1, and there's still 
some data (or possibly metadata if it was the single drive at one point 
or they're ssds, as btrfs defaults to metadata single in ssd mode) that 
hasn't been duped elsewhere.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

