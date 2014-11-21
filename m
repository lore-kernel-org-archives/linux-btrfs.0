Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44528 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaKUXvQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 18:51:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xrxys-0001qh-HW
	for linux-btrfs@vger.kernel.org; Sat, 22 Nov 2014 00:51:14 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 00:51:14 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 00:51:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Fri, 21 Nov 2014 23:51:03 +0000 (UTC)
Message-ID: <pan$5402c$1200654c$d49625dc$fc59fa60@cox.net>
References: <54699CC7.1050909@swiftspirit.co.za>
	<546A46A5.8030603@inwind.it>
	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>
	<pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
	<CAJCQCtR26DBb9KqYTXXew6TPQhAyya318oLXfBf=Q+NfL_dSPQ@mail.gmail.com>
	<pan$d7b2d$664c44b1$38518f25$5a7dbe8a@cox.net>
	<pan$3a23$d0e2f74c$a2cb32cc$e3e05f8@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Fri, 21 Nov 2014 23:41:49 +0000 as excerpted:

> Duncan posted on Fri, 21 Nov 2014 22:49:06 +0000 as excerpted:
> 
>> Chris Murphy posted...
> 
>>> That's not true for thin volume snapshots. They take up next to no
>>> space upon creation, they don't need space reserved in advance.
>> 
>> Thus the mention of compression if necessary.  Thin-volume snapshots
>> are effectively compression by another name, and a raw dd from them
>> should compress pretty much equally well, depending on compression
>> method chosen, of course. =:^)
> 
> Oops, I mis-parsed "thin".  Good point and thanks, Chris.

... And Zygo, who pointed out my error as well. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

