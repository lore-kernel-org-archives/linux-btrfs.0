Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52637 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaJSKUC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Oct 2014 06:20:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xfnai-0007ZZ-V9
	for linux-btrfs@vger.kernel.org; Sun, 19 Oct 2014 12:20:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Oct 2014 12:20:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Oct 2014 12:20:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: strange 3.16.3 problem
Date: Sun, 19 Oct 2014 10:19:50 +0000 (UTC)
Message-ID: <pan$ae8b8$e1969f5d$427e912a$f8f0705f@cox.net>
References: <201410181454.19375.russell@coker.com.au>
	<54426C16.5030206@pobox.com> <201410191041.42013.russell@coker.com.au>
	<pan$9d78b$40e61441$d421f088$d69188b0@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Sun, 19 Oct 2014 05:37:36 +0000 as excerpted:

> Russell Coker posted on Sun, 19 Oct 2014 10:41:41 +1100 as excerpted:
> 
>> # find . -name "*546" -exec rm "{}" \;
>> rm: cannot remove `./1412233213.M638209P10546': No such file or
>> directory
> 
> Going with the non-printable-character theory, what happens if you
> expand that *546 find one character at a time?  Does *0546 work? *10546?
> etc.
> 
> When you find a boundary where it goes from working to not-working, what
> happens if you stick a wildcard in that boundary?  Assuming *0546
> doesn't work, for instance, thus creating a boundary between the 0 and
> the 5, what about *0*546 or *0?546?

FWIW, I just had something similar happen here, except ls could see the 
files and tell me what happened, tho for a moment I was wondering...  In 
my case it was a couple symlinks, dead because the partition they pointed 
into wasn't mounted.  But with this thread fresh in my mind, of course it 
was the first thing to come to mind...


Another idea for potentially figuring out what's going on...

If you have tab-completion active, what sort of auto-completes does it 
offer with for instance ls 141<tab> ?  If necessary, again you can try 
expanding one character at a time, except of course from the left here 
instead of from the right as above.

For things like colons, I know bash-completion here fills in \: in place 
of simply colon.  I just tested what it'd do with a backspace char 
embedded in a filename, and tab-completion substitutes ^H (while ls 
substitutes ? ).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

