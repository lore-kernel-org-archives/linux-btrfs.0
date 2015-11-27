Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51348 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbbK0Fai (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 00:30:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a2Bc9-0006zU-A4
	for linux-btrfs@vger.kernel.org; Fri, 27 Nov 2015 06:30:33 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 06:30:33 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 06:30:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to detect / notify when a raid drive fails?
Date: Fri, 27 Nov 2015 05:30:14 +0000 (UTC)
Message-ID: <pan$2baa9$6d4c6e73$140f6177$488caa5a@cox.net>
References: <1448601297.4093478.451242913.1CEE0D6D@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ian Kelling posted on Thu, 26 Nov 2015 21:14:57 -0800 as excerpted:

> I'd like to run "mail" when a btrfs raid drive fails, but I don't know
> how to detect that a drive has failed. It don't see it in any docs.
> Otherwise I assume I would never know until enough drives fail that the
> filesystem stops working, and I'd like to know before that.

Btrfs isn't yet mature enough to have a device failure notifier daemon, 
like for instance mdadm does.  There's a patch set going around that adds 
global spares, so btrfs can detect the problem and grab a spare, but it's 
only a rather simplistic initial implementation designed to provide the 
framework for more fancy stuff later, and that's about it in terms of 
anything close, so far.

What generally happens now, however, is that the btrfs will note failures 
attempting to write the device and start queuing up writes.  If the 
device reappears fast enough, btrfs will flush the queue and be back to 
normal.  Otherwise, you pretty much need to reboot and mount degraded, 
then add a device and rebalance. (btrfs device delete missing broke some 
versions ago and just got fixed by the latest btrfs-progs-4.3.1, IIRC.)

As for alerts, you'd see the pile of accumulating write errors in the 
kernel log.  Presumably you can write up a script that can alert on that 
and mail you the log or whatever, but I don't believe there's anything 
official or close to it, yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

