Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37250 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbbI1CpS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Sep 2015 22:45:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZgORI-0006no-7f
	for linux-btrfs@vger.kernel.org; Mon, 28 Sep 2015 04:45:16 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 04:45:16 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 04:45:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fstrim silently does nothing on dev add/dev rem'd filesystem
Date: Mon, 28 Sep 2015 02:45:10 +0000 (UTC)
Message-ID: <pan$73c0$b0528a34$f375bb55$bda81535@cox.net>
References: <20150927175252.GA24990@blind.goeswhere.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris West posted on Sun, 27 Sep 2015 18:52:52 +0100 as excerpted:

> I have a filesystem for which fstrim won't do anything.
> The filesystem has a history of abuse; dev add, dev remove, dding, ...
> 
> There's nothing wrong with the kernel or the disc; other btrfs volumes
> on the same disc trim fine, and the volume used to trim fine.
> 
> By "won't trim", I mean that it always, instantly returns 0 bytes
> trimmed:
> 
> % time sudo fstrim -v .
> .: 0 B (0 bytes) trimmed sudo fstrim -v .  0.00s user 0.00s system 0%
> cpu 0.004 total
> 
> It used to, as expected, take a while, then report a trimmed size.

[replying to list and OP both]

As lutz suggests, fstrim on btrfs is known to be buggy at present.  
Solutions are in general known and patches available, but they aren't in 
4.2, and while 4.3 will be better, AFAIK the patch there is only a 
partial solution.

As I overprovisioned my SSDs such that they're only something like 55% 
partitioned at all, leaving the other ~45% entirely unpartitioned empty 
space, there's plenty of room for the FTL to do its thing there and while 
I know fstrim is scheduled to run weekly, I've not personally worried too 
much about it beyond seeing the on-list discussion, but I understand why 
others with much tighter provisioning/partitioning would be more worried 
about it.

But I think part of reasoning behind the relatively low priority this 
issue has received is that it's a low visibility issue not really 
affecting most people running btrfs, either because they're not running 
on ssd or because they simply don't have a particularly high awareness of 
what trim does and thus about how it's failing to work here and what that 
means to them.  If we get a rash of people posting on-list that it's 
affecting them, that relative priority is likely to go up, and with it 
the patch testing and integration schedule for the affected patches.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

