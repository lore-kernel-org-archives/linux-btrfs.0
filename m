Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44672 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaEFVUv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 17:20:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Whmn8-0006uF-21
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 23:20:46 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 23:20:46 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 23:20:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Please review and comment, dealing with btrfs full issues
Date: Tue, 6 May 2014 21:20:31 +0000 (UTC)
Message-ID: <pan$ac283$6ed0cbe3$bfd5f020$4928a971@cox.net>
References: <20140506121937.GD10159@merlins.org>
	<53690E27.6090101@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Tue, 06 May 2014 18:30:31 +0200 as excerpted:

>> So in my case when I hit that case, I had to use dusage=0 to recover.
>> Anything above that just didn't work.
> 
> I suspect when using more than zero the first chunk it wanted to balance
> wasn't empty - and it had nowhere to put it. Then when you did dusage=0,
> it didn't need a destination for the data. That is actually an
> interesting workaround for that case.

I've actually used -Xusage=0 (where X=m or d, obviously) for exactly 
that.  If every last bit of filesystem is allocated so another chunk 
simply cannot be written in ordered to rewrite partially used chunks 
into, BUT the spread between allocated and actually used is quite high, 
there's a reasonably good chance that at least one of those allocated 
chunks is entirely empty, and -Xusage=0 allows returning it to the 
unallocated pool without actually requiring a new chunk allocation to do 
so.

With luck, that will free at least one zero-usage chunk (two for metadata 
dup, but it would both allocate and return to unallocated in pairs as so 
it balances out), allowing the user to rerun balance, this time with a 
higher -Xusage=.  


The other known valid use-case for -Xusage=0 is when freeing the 
extraneous zero-usage single-mode chunks first created by mkfs.btrfs as 
part of the mkfs process, so they don't clutter up the btrfs filesystem df 
output. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

