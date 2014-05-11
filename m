Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37245 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbaEKQR5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 12:17:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WjWRo-0003j6-2n
	for linux-btrfs@vger.kernel.org; Sun, 11 May 2014 18:17:56 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 18:17:56 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 18:17:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: -musage=>0 means always reporting relocation
Date: Sun, 11 May 2014 16:17:44 +0000 (UTC)
Message-ID: <pan$bf0a8$25fa97dc$2ae1cf04$b68a5dc3@cox.net>
References: <201405111943.16913.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sun, 11 May 2014 19:43:16 +1000 as excerpted:

> Below is the output of running a balance a few times on a 120G SSD.
> 
> It seems that whenever I set the metadata usage to be greater than 0 it
> will report relocating something, regardless of whether that's possible.

Why would it be impossible?  It's certainly not impossible from the 
information posted.

As Brendan suggests, depending on the amount of metadata present, it's 
entirely possible that you have enough to fill X whole metadata chunks, 
plus under 10% and possibly under 1% of the next chunk, such that 
repeatedly running -musage=10 or -musage=1 will repeatedly balance that 
last chunk.

Also, not being a dev I don't normally read code to know whether this is 
an issue or not, but given that btrfs will inline small enough files in 
the metadata, it's theoretically possible that a balanced state where 
more than one metadata chunk remains less than 100% full, if the inlined 
file data doesn't line up to exact chunks.

Then of course there's the dup or raid1 metadata case (dup being the 
normal single-device metadata default, except if ssd is detected, raid1 
being the multi-device metadata default in all cases), such that all 
metadata chunks are duplicated, effectively doubling the number of chunks 
rebalanced since each one has two copies.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

