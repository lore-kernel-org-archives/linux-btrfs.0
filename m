Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46068 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933187AbaH0Gje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 02:39:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XMWtJ-0000N9-Ep
	for linux-btrfs@vger.kernel.org; Wed, 27 Aug 2014 08:39:33 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 08:39:33 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 08:39:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fallocate fail on btrfs
Date: Wed, 27 Aug 2014 06:39:19 +0000 (UTC)
Message-ID: <pan$427a1$f65bd1f8$7ddfd94c$6b06de1b@cox.net>
References: <CADw2B2PYPJdcLWvkufY71kvAdCdgXhsdO2Gizf8hXAruppxXPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

G. Richard Bellamy posted on Tue, 26 Aug 2014 22:05:01 -0700 as excerpted:

> When I try to run fallocate with "--keep-size" on my btrfs partitions,
> it's failing, and I'm at a loss as to why. This was working in prior
> versions.
> 
> Any suggestions on how to attack this problem? I'm betting I'm missing
> something simple here, and have just gone down the rabbit hole...
> 
> BTW, I've confirmed that the line that fails is fallocate.c:368 [2],
> with "open" always returning -1.

One "something simple" you're missing (either that or I am) is any 
reference to which version you're running.  You say it was working in 
prior versions, but /which/ prior versions, and /which/ version doesn't 
work now?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

