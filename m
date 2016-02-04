Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43712 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022AbcBDK5F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 05:57:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aRHaw-0002CU-SH
	for linux-btrfs@vger.kernel.org; Thu, 04 Feb 2016 11:57:03 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 11:57:02 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 11:57:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Question about a specific error.
Date: Thu, 4 Feb 2016 10:56:55 +0000 (UTC)
Message-ID: <pan$8c79e$f48a8297$43b8c26c$ded608ed@cox.net>
References: <56AFB598.2020307@gmail.com>
	<20160201202112.GB8313@carfax.org.uk> <56B0A881.5080403@gmail.com>
	<CAJCQCtQ_c1-ck6=_XasvDVwEepXQjB7V4jfxJ9Fe_pPmExtG=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 03 Feb 2016 14:17:06 -0700 as excerpted:

> The problems look different. You're reporting errors 2000. I'm seeing
> errors 2001. I'm not sure what the distinction is; but in my case,
> cancelling btrfs check and just rerunning it gives different results.
> https://bugzilla.kernel.org/show_bug.cgi?id=111841

You likely know this but didn't explicitly state it, and for others...

AFAIK, errors is a bitmask, so errors 2001 is the same bitmask error as 
2000, plus another, errors 0001.

But I'm not sure what errors those actually are, either.  The errors 
bitmask is obviously targeted at devs who can read the code and see what 
each bit means, and to my knowledge there's no table posted on the wiki 
or wherever for non-devs to look it up.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

