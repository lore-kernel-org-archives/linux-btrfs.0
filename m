Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57710 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252AbcGLPWm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 11:22:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bMzW7-0003pO-Or
	for linux-btrfs@vger.kernel.org; Tue, 12 Jul 2016 17:22:35 +0200
Received: from ip-64-134-228-164.public.wayport.net ([64.134.228.164])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 17:22:35 +0200
Received: from 1i5t5.duncan by ip-64-134-228-164.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 17:22:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
Date: Tue, 12 Jul 2016 15:22:29 +0000 (UTC)
Message-ID: <pan$74d1e$3fac5c54$6a613f6$6e9626ab@cox.net>
References: <20160621151659.32157-1-ahferroin7@gmail.com>
	<20160711072612.GA1417185@mother.pipebreaker.pl>
	<63dba99e-cf1c-63f5-bee6-548270b7a653@gmail.com>
	<20160711165822.GB1417185@mother.pipebreaker.pl>
	<adc6bbe4-48d8-27d2-468f-7e7816ae96cf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 12 Jul 2016 08:25:24 -0400 as
excerpted:

> As far as daemonization, I have no man-page called daemon in section
> seven, yet I have an up-to-date upstream copy of the Linux man pages. My
> guess is that this is a systemd man page, which in turn means it does a
> bunch of stuff that's only needed for system services on systemd based
> systems.

Your guess would appear to be correct, as my systemd package includes a 
daemon manpage, here (gentoo).

As for the general debate, while I'm a systemd user, I definitely support 
it remaining optional, which means things need to work without it, too.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

