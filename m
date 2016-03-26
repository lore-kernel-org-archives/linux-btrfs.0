Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51237 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbcCZEQF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 00:16:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ajfdq-0006g3-3h
	for linux-btrfs@vger.kernel.org; Sat, 26 Mar 2016 05:16:02 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 05:16:02 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 05:16:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID-1 refuses to balance large drive
Date: Sat, 26 Mar 2016 04:15:53 +0000 (UTC)
Message-ID: <pan$859b8$22092254$6856ccb5$a6a9f4f8@cox.net>
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
	<CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
	<56F2C991.9080500@gmail.com>
	<CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
	<56F2EA25.4070004@gmail.com>
	<CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
	<CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
	<CAPmG0jbUWiDNSVjv9hMF3rpe0cm4EZWkuRKEgM_t6EuU3sPYFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Fri, 25 Mar 2016 15:35:52 +0100 as excerpted:

> For the original OP situation, with chunks all filled op with extents
> and devices all filled up with chunks, 'integrating' a new 6TB drive
> in an 4TB+3TG+2TB raid1 array could probably be done in a bit unusual
> way in order to avoid immediate balancing needs:

> - 'plug-in' the 6TB
> - btrfs-replace  4TB by 6TB
> - btrfs fi resize max 6TB_devID
> - btrfs-replace  2TB by 4TB
> - btrfs fi resize max 4TB_devID
> - 'unplug' the 2TB

Way to think outside the box, Henk!  I'll have to remember this as it's
a very clever and rather useful method-tool to have in the ol' admin
toolbox (aka brain). =:^)

I only wish I had thought of it, as it sure seems clear... now that
you described it!

Greatly appreciated, in any case! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

