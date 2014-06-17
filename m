Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46645 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbaFQIW5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 04:22:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WwofP-0007GN-JA
	for linux-btrfs@vger.kernel.org; Tue, 17 Jun 2014 10:22:55 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 10:22:55 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 10:22:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Slow startup of systemd-journal on BTRFS
Date: Tue, 17 Jun 2014 08:22:42 +0000 (UTC)
Message-ID: <pan$aecb0$92542867$f2905e5c$c1082165@cox.net>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
	<539B78F3.9070607@libero.it>
	<pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
	<2067769.SxD8Z17WRg@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sun, 15 Jun 2014 23:31:07 +0200 as excerpted:

> I always thought that the whole point of fallocate is that it *doesn´t*
> write out anything, but just reserves the space. Thus I don´t see how
> COW can have any adverse effect here.

Tying up loose ends...  I was wrong on fallocate being the trigger, tho I 
did call correctly on fragmentation as the result, with NOCOW and defrag 
as possible workarounds.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

