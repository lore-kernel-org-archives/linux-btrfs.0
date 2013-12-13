Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38975 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3LMJd7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 04:33:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VrP88-0007gc-QV
	for linux-btrfs@vger.kernel.org; Fri, 13 Dec 2013 10:33:56 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 10:33:56 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 10:33:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
Date: Fri, 13 Dec 2013 09:33:35 +0000 (UTC)
Message-ID: <pan$7c9f2$f2f178cc$d355f3bc$802bbad3@cox.net>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
	<01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
	<CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
	<F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
	<CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
	<B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
	<pan$cd4bd$8058fd9d$d320fdd8$6cb46f0f@cox.net>
	<CAK5rZE5oxr381MhwxdgwJs7HHJC2-_Du+N+FzZUAT2vVynuGcw@mail.gmail.com>
	<pan$dd37b$1a442a8d$594e1d2e$ae5b97e3@cox.net>
	<20131212155720.11479.7400@ret> <20131212175815.GR6498@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Thu, 12 Dec 2013 18:58:16 +0100 as excerpted:

> I've been testing --mixed mode with various other raid profiles types as
> far as I remember. Some bugs popped up, reported and Josef fixed them.

FWIW, I'm running a mixed-mode btrfs-raid1 mode here on my log partition 
and haven't seen any issues, altho that's sub-GiB (640 MiB), so anything 
that would only be seen at larger sizes will not have triggered, here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

