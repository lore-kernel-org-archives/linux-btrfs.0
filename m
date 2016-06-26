Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37055 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbcFZCxM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 22:53:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bH0C5-0002cb-Lx
	for linux-btrfs@vger.kernel.org; Sun, 26 Jun 2016 04:53:11 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 04:53:09 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 04:53:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
Date: Sun, 26 Jun 2016 02:53:03 +0000 (UTC)
Message-ID: <pan$60ea0$54eb541$a3b060fc$181835e5@cox.net>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
	<CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 25 Jun 2016 11:25:05 -0600 as excerpted:

> Wow. So it sees the data strip corruption, uses good parity on disk to
> fix it, writes the fix to disk, recomputes parity for some reason but
> does it wrongly, and then overwrites good parity with bad parity?
> That's fucked. So in other words, if there are any errors fixed up
> during a scrub, you should do a 2nd scrub. The first scrub should make
> sure data is correct, and the 2nd scrub should make sure the bug is
> papered over by computing correct parity and replacing the bad parity.
> 
> I wonder if the same problem happens with balance or if this is just a
> bug in scrub code?

Could this explain why people have been reporting so many raid56 mode 
cases of btrfs replacing a first drive appearing to succeed just fine, 
but then they go to btrfs replace a second drive, and the array crashes 
as if the first replace didn't work correctly after all, resulting in two 
bad devices once the second replace gets under way, of course bringing 
down the array?

If so, then it looks like we have our answer as to what has been going 
wrong that has been so hard to properly trace and thus to bugfix.

Combine that with the raid4 dedicated parity device behavior you're 
seeing if the writes are all exactly 128 MB, with that possibly 
explaining the super-slow replaces, and this thread may have just given 
us answers to both of those until-now-untraceable issues.

Regardless, what's /very/ clear by now is that raid56 mode as it 
currently exists is more or less fatally flawed, and a full scrap and 
rewrite to an entirely different raid56 mode on-disk format may be 
necessary to fix it.

And what's even clearer is that people /really/ shouldn't be using raid56 
mode for anything but testing with throw-away data, at this point.  
Anything else is simply irresponsible.

Does that mean we need to put a "raid56 mode may eat your babies" level 
warning in the manpage and require a --force to either mkfs.btrfs or 
balance to raid56 mode?  Because that's about where I am on it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

