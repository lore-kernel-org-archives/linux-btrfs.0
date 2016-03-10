Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43246 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbcCJIKu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 03:10:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1advg6-0006hE-EU
	for linux-btrfs@vger.kernel.org; Thu, 10 Mar 2016 09:10:38 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 09:10:38 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 09:10:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: dstat shows unexpected result for two disk RAID1
Date: Thu, 10 Mar 2016 08:10:33 +0000 (UTC)
Message-ID: <pan$8ef9e$1a5c729d$235b0083$a170814e@cox.net>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<20160310023627.2e915667@natsu>
	<pan$9dde$acf9ba51$bb837cb8$8c954a04@cox.net>
	<CAJCQCtRXEcCJQdSLYfRXrU992jn8VPuGTFpSetaANHkES0Q+7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 09 Mar 2016 22:01:21 -0700 as excerpted:

> Meh, encryption RFC patches arrived 8 days ago and I wasn't expecting
> that to happen for a couple years. So I think our expectations have
> almost no bearing on feature or fix arrival. For all we know n-way could
> appear in 4.6.

The crypto rfc patches were out of left field for me as well.

But if n-way does show up effectively "tomorrow" (as it would need to, to 
hit 4.6), I'd suspect someone with some money to spend prioritized it, 
much as I suspect that's what happened with the crypto patches.

Call me a conspiracy nut, but don't be too surprised if someone's 
introducing some product with btrfs and encrypted subvolumes a year or 18 
months from now...  I know I won't be! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

