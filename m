Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60874 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758619Ab3KMMZE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 07:25:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VgZVH-0008Pq-GL
	for linux-btrfs@vger.kernel.org; Wed, 13 Nov 2013 13:25:03 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 13:25:03 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 13:25:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck errors is it save to fix?
Date: Wed, 13 Nov 2013 12:24:15 +0000 (UTC)
Message-ID: <pan$a3720$6cf50f31$9d15d3bf$b3bbf4bb@cox.net>
References: <52742B59.3060405@friedels.name>
	<CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com>
	<5274BEC8.5060804@friedels.name> <52780E20.8020405@friedels.name>
	<CAE5mzvgrKqrv3LpmiF6iUK=GYsnGOQnSwLTM0dSfBE8ZP-4AuA@mail.gmail.com>
	<5279E581.4000700@friedels.name> <527BE712.40304@friedels.name>
	<pan$2f107$ddc92f2a$30381770$58497a03@cox.net>
	<527DF34B.2030309@friedels.name> <52812AAA.1080106@friedels.name>
	<3j78la-3nn.ln1@hurikhan77.spdns.de>
	<pan$9db1e$bf9333c2$543d2730$1c706b4d@cox.net>
	<llcala-j7c.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Tue, 12 Nov 2013 20:37:57 +0100 as excerpted:

> Possible? Yes. Although I did not implicitly mention it, you would
> combine "clear_cache" and "nospace_cache" - that should do the trick.
> Then unmount and check.

Thanks and mentally noted for further reference.  I didn't think about 
combining the options, but it makes perfect sense now that I have, thanks 
to you. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

