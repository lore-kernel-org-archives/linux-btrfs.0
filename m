Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35227 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaCINzp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Mar 2014 09:55:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WMeCe-00012M-0V
	for linux-btrfs@vger.kernel.org; Sun, 09 Mar 2014 14:55:44 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Mar 2014 14:55:44 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Mar 2014 14:55:44 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send kernel error btrfs_compare_tree
Date: Sun, 9 Mar 2014 13:55:12 +0000 (UTC)
Message-ID: <pan$c437$d4e1a698$ae626ce6$8ef08785@cox.net>
References: <531B6434.1080409@travislists.com>
	<531B7F04.30908@travislists.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Travis Cross posted on Sat, 08 Mar 2014 20:35:16 +0000 as excerpted:

> The filesystem here was likely created with Linux 3.2 and hasn't seen
> much use for awhile, until today I mounted it to try to btrfs send off
> those volumes.
> 
> xaba noted this could be the result of some 3.2-era kernel bug.  He
> recognized the messages I was seeing.  If this is the case, and this
> sort of thing is common, it seems we might want to have a way of
> detecting this and trying to salvage the situation (particularly as
> Debian wheezy -- the last Debian stable release -- is on a 3.2 kernel).

Well, until 3.13 (IIRC) btrfs was officially experimental, with a very 
strongly worded warning on the kernel option activating it.  And even 
after that semi-stabilization (the wording still doesn't suggest fully 
stable) current wiki and mkfs.btrfs strongly encourage keeping current on 
your kernel if you're running btrfs, something kernel 3.2 definitely is 
*NOT*.

So I'd consider backing up the data and doing a clean mkfs.btrfs on the 
filesystem, starting over with a filesystem created with a post-eat-your-
babies-warning kernel.  I did that here recently, taking advantage of 
several of the newer btrfs disk-format features, and plan to do it again 
at least once more after a few more kernel cycles of code settling, just 
to be sure I'm not relying on something written by potentially still 
buggy and not yet entirely stable btrfs code.

Tho I expect the devs will try to salvage this specific situation and 
have a bug-fix for it.  But I know at least personally, I rest better 
knowing that none of my btrfs has been touched by that officially still 
very experimental code; they've all been redone with a newer kernel 
beyond that warning and haven't run anything older, and as I said, I plan 
to redo them again at least once more, as btrfs settles down further.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

