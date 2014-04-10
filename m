Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38846 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaDJPPR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 11:15:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WYGh9-0004FD-Aa
	for linux-btrfs@vger.kernel.org; Thu, 10 Apr 2014 17:15:15 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 17:15:15 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 17:15:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Thu, 10 Apr 2014 15:15:02 +0000 (UTC)
Message-ID: <pan$2aca0$96a1810f$3919e968$6678f073@cox.net>
References: <4783411.VVGoQz5kVU@fuchsia>
	<CAPpBBdMCAFASLgGpbWo7-Pp74S_KQdZ2A7qrSNzo0rGrZAbqMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Eleftheriou posted on Thu, 10 Apr 2014 16:00:06 +0200 as excerpted:

> Maybe there is another much more complicated solution:
> 
> Plug the old disk in a USB dock/case, do the same for the new disk in
> another dock/case, plug both docks/cases in another linux system running
> recent kernel and btrfs-progs and convert to a "-dconvert=raid1
> -mconvert=raid1" profile with a balance. Then degrade it by removing the
> old disk and rebalance-convert back to single or DUP profile (i am not
> quite sure this is even possible).
> 
> Just an idea. I wouldn't trust me.

Creative idea, actually, and one I've seen come up here before tho if you 
read my earlier response I didn't mention it myself, as I failed to 
recall it.

But yes, it is somewhat more complicated, and sort of an abuse of 
existing features for a purpose they weren't intended for.  It should 
still work and such unintended purpose uses are a good thing, but because 
it is unintended usage, it won't have been tested much if at all, and 
given that btrfs isn't itself fully stable yet, there's a fair likelihood 
that some unanticipated complexities would arise while doing it, as well.

Meanwhile, by the very fact that btrfs is /not/ yet entirely stable, 
there's even more reason than normal to have good, tested backups.  Given 
that, there should be no harm in trying this, since even if it somehow 
kills the working copy, one can still restore from those already tested 
backups.  And someone's gotta be the first to test this method and report 
on how it went, right?

Meanwhile (2), given the existence of those tested backups, there's yet 
another way to accomplish things.  Simply restore from the backups the 
same way you would if the working copy went down and you had to restore 
it, only restore to the new device instead of the old one.  =:^)

(Actually, given my usual insistence on this key point, that btrfs isn't 
yet fully stable and that as a result by definition, you either have 
tested backups or you're demonstrating by practice that you simply don't 
care about losing the data anyway whatever your words might otherwise 
claim, I really should have thought of and mentioned the restoring from 
backups method first, instead of having it occur to me as an after-
thought.  I must be getting sloppy and careless in my thinking! =:^( )

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

