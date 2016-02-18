Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41271 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425960AbcBRKDI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 05:03:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aWLQQ-00031X-8k
	for linux-btrfs@vger.kernel.org; Thu, 18 Feb 2016 11:03:06 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 11:03:06 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 11:03:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send error
Date: Thu, 18 Feb 2016 10:02:58 +0000 (UTC)
Message-ID: <pan$edca8$deee79ed$ca3185e1$97ab4642@cox.net>
References: <CAH4oapcJVfd74Wg64+4Q+xXzF07U1NKrQTnhoOA1ry2sJogkXQ@mail.gmail.com>
	<CAL3q7H6XnesHaU1COssFnvdnkxZwAD+isPLcYXxeip1b4UULug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filipe Manana posted on Wed, 17 Feb 2016 14:01:15 +0000 as excerpted:

> Just upgrade to a 4.3 or 4.4 kernel, or build a kernel with the patch
> below.
> The fix for this landed in 4.3:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?
id=d6589101b67a55107652050dfbf414403a93e351

Has that patch been earmarked for stable, and stable just hasn't caught 
up to it yet?

Because the OP is on 4.1-LTS, which is definitely still within the 
reasonable support window and being an LTS, should still be supported.

If it's already earmarked for stable and simply hasn't made it into a 
stable release yet, that's understandable, tho having it specifically 
stated, thus making waiting for it to hit stable an option, would be 
nice. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

