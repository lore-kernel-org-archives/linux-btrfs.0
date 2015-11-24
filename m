Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51405 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbbKXEfK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 23:35:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a15Jq-0002i5-VZ
	for linux-btrfs@vger.kernel.org; Tue, 24 Nov 2015 05:35:07 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 05:35:06 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 05:35:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: shall distros run btrfsck on boot?
Date: Tue, 24 Nov 2015 04:35:01 +0000 (UTC)
Message-ID: <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
References: <1448337754.14125.33.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Tue, 24 Nov 2015 05:02:34 +0100 as
excerpted:

> Hey.
> 
> Short question since that came up on debian-devel.
> 
> Now that btrfs check get's more and more useful, are the developers
> going to recommend running it periodically on boot (of course that
> wouldn't work right now, as it would *always* check)?

I'm a list regular and btrfs user, not a dev, but all the indications 
continue to point to _not_ running it automatically at boot, nobody even 
_suggesting_ otherwise.  The btrfs kernel code itself detects and often 
corrects many problems, and btrfs check is simply not recommended for 
automatic at-boot scheduling -- if the kernel code can't fix it without 
intervention, then the problem is too serious to be fixed without 
intervention by some scheduled btrfs check run, as well.

In fact, take a look at the shipped fsck.btrfs shell-script, based upon 
the xfs one.  As both the code and the comments suggest, it's 
specifically designed to simply return success (well, if the given device 
exists, if not it does error out on that), without actually checking 
anything (beyond simple device existence).  If it's run in auto mode, as 
it would be with an on-boot run, it does nothing else.  If it's not run 
in auto mode, suggesting that a misinformed user attempted to run it, it 
prints a message redirecting them to btrfs check.

That's pretty clear as to intent -- btrfs check is simply not designed or 
intended to ever be run at boot.

> Plus... is btrfs check (without any arguments) non-desctructive, or are
> there corner-cases where it may lead to any changes on the devices?

Btrfs check, without arguments, is designed to be read-only.  AFAIK, the 
only way it wouldn't be would be if there was a serious bug.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

