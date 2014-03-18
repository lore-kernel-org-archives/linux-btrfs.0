Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42537 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbaCRJCk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 05:02:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WPpus-0003XW-Ty
	for linux-btrfs@vger.kernel.org; Tue, 18 Mar 2014 10:02:34 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 10:02:34 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 10:02:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to handle a RAID5 arrawy with a failing drive?
Date: Tue, 18 Mar 2014 09:02:07 +0000 (UTC)
Message-ID: <pan$2239d$446ec5c7$d67506b7$f25a7c65@cox.net>
References: <1394983430-20440-1-git-send-email-fdmanana@gmail.com>
	<1395002246-3840-1-git-send-email-fdmanana@gmail.com>
	<20140316222026.GU16946@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 16 Mar 2014 15:20:26 -0700 as excerpted:

> Do I have other options?
> (data is not important at all, I just want to learn how to deal with
> such a case with the current code)

First just a note that you hijacked Mr Manana's patch thread.  Replying 
to a post and changing the topic (the usual cause of such hijacks) does 
NOT change the thread, as the References and In-Reply-To headers still 
includes the Message-IDs from the original thread, and that's what good 
clients thread by since the subject line isn't a reliable means of 
threading.  To start a NEW thread, don't reply to an existing thread, 
compose a NEW message, starting a NEW thread. =:^)

Back on topic...

Since you don't have to worry about the data I'd suggest blowing it away 
and starting over.  Btrfs raid5/6 code is known to be incomplete at this 
point, to work in normal mode and write everything out, but with 
incomplete recovery code.  So I'd treat it like the raid-0 mode it 
effectively is, and consider it lost if a device drops.

There *IS* a post from an earlier thread where someone mentioned a 
recovery under some specific circumstance that worked for him, but I'd 
consider that the exception not the norm since the code is known to be 
incomplete and I think he just got lucky and didn't hit the particular 
missing code in his specific case.  Certainly you could try to go back 
and see what he did and under what conditions, and that might actually be 
worth doing if you had valuable data you'd be losing otherwise, but since 
you don't, while of course it's up to you, I'd not bother were it me.

Which I haven't.  My use-case wouldn't be looking at raid5/6 (or raid0) 
anyway, but even if it were, I'd not touch the current code unless it 
/was/ just for something I'd consider risking on a raid0.  Other than 
pure testing, the /only/ case I'd consider btrfs raid5/6 for right now, 
would be something that I'd consider raid0 riskable currently, but with 
the bonus of it upgrading "for free" to raid5/6 when the code is complete 
without any further effort on my part, since it's actually being written 
as raid5/6 ATM, the recovery simply can't be relied upon as raid5/6, so 
in recovery terms you're effectively running raid0 until it can be.  
Other than that and for /pure/ testing, I just don't see the point of 
even thinking about raid5/6 at this point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

