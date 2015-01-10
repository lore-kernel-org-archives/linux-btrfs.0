Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49111 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbbAJJ2a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Jan 2015 04:28:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y9sLL-0006M5-N9
	for linux-btrfs@vger.kernel.org; Sat, 10 Jan 2015 10:28:27 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 10:28:27 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 10:28:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Segfault in "btrfs balance start" due to kernel page allocation
 failure
Date: Sat, 10 Jan 2015 09:28:17 +0000 (UTC)
Message-ID: <pan$3ea4e$eb4d7d19$bbe46563$3cc96659@cox.net>
References: <m8odfs$rv2$1@ger.gmane.org>
	<pan$91b96$595041e4$b1777a9d$1c82bf25@cox.net>
	<m8psfs$h0t$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remy Blank posted on Sat, 10 Jan 2015 01:41:31 +0100 as excerpted:

> Maybe it would be worth adding some tests using rsync to the test suite
> (I assume there is one)?

Yes.  xfs-tests (which isn't just for xfs any more, ext4, btrfs, and 
possibly others, use it too).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

