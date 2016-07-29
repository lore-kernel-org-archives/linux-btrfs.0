Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51785 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcG2D5D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 23:57:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bSyuy-00084i-I6
	for linux-btrfs@vger.kernel.org; Fri, 29 Jul 2016 05:57:00 +0200
Received: from ip-64-134-228-15.public.wayport.net ([64.134.228.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jul 2016 05:57:00 +0200
Received: from 1i5t5.duncan by ip-64-134-228-15.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jul 2016 05:57:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi defrag does not defrag files >256kB?
Date: Fri, 29 Jul 2016 03:56:53 +0000 (UTC)
Message-ID: <pan$7c912$9463b0ec$94c17ac2$5933daf0@cox.net>
References: <pan$acc$75dc71b8$532c7a5c$47aab598@cox.net>
	<CAD=QJKjoSR8R_hDnr4sgWizMugp+jvmHQwT-SMDdNJH=G9HEkw@mail.gmail.com>
	<20160728105555.GR30795@twin.jikos.cz>
	<CAD=QJKgmrd_pmcYPOk6BXstVJ+JSdSwm7s0KEPbLJrezbUCLpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas D Steeves posted on Thu, 28 Jul 2016 13:53:31 -0400 as excerpted:

> Additionally, I've read that -o autodefrag doesn't yet work well for
> large databases.  Would a supplementary targeted defrag policy be useful
> here?  For example: a general cron/systemd.trigger default of "-t 32M",
> and then another job for /var/lib/mysql/ with a policy of "-f -t 1G"? 
> Or did your findings also show that large databases did not benefit from
> larger target extent defrags?

That the autodefrag mount option didn't work well with large rewrite-
pattern files like vm images and databases was the previous advice, yes, 
but that changed at some point.  I'm not sure if autodefrag has always 
worked this way and they simply weren't sure before, or if it changed, 
but in any case, these days, it doesn't rewrite the entire file, only a 
(relatively) larger block of it than the individual 4 KiB block that 
would otherwise be rewritten.  (I'm not sure what size, perhaps the same 
256 KiB that's the kernel default for manual defrag?)

As such, it scales better than it would if the full gig-size (or 
whatever) file was being rewritten, altho there will still be some 
fragmentation.

And for the same reason, it's actually not as bad with snapshots as it 
might have been otherwise, because it only cows/de-reflinks a bit more of 
the file than would otherwise be cowed due to the write in any case, so 
it doesn't duplicate the entire file as originally feared by some, either.

Tho the only way to be sure would be to try it.


Meanwhile, it's worth noting that autodefrag works best if on from the 
beginning, so fragmentation doesn't get ahead of it.  Here, I ensure 
autodefrag is on from the first time I mount it, while the filesystem is 
still empty.  That way, fragmentation should never get out of hand, 
fragmenting free space so badly that free large extents to defrag into
/can't/ be found, as may be the case if autodefrag isn't turned on until 
later and manual defrag hasn't been done regularly either.  There have 
been a few reports of people waiting to turn it on until the filesystem 
is highly fragmented, and then having several days of low performance as 
defrag tries to catch up.  If it's consistently on from the beginning, 
that shouldn't happen.

Of course that may mean backing up and recreating the filesystem fresh in 
ordered to have autodefrag on from the beginning, if you're looking at 
trying it on existing filesystems that are likely highly fragmented.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

