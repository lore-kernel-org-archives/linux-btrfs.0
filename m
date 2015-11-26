Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35538 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbbKZQkN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 11:40:13 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a1zaT-0006gR-JF
	for linux-btrfs@vger.kernel.org; Thu, 26 Nov 2015 17:40:01 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 17:40:01 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 17:40:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [4.3-rc4] scrubbing aborts before finishing
Date: Thu, 26 Nov 2015 16:39:56 +0000 (UTC)
Message-ID: <pan$ecfab$57cc777c$ca4a8e04$f7991114@cox.net>
References: <16063727.bYixifcRQC@merkaba> <1475910.a5YfPuWqAN@merkaba>
	<4738187.k1WenrURk2@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Wed, 25 Nov 2015 16:35:39 +0100 as excerpted:

> I´d report a bug report, in case anyone would be interested. But if the
> interest it like in this mailinglist post I can spare myself the time
> for reporting via bugzilla.
> 
> So does anyone at all care about this issue?

FWIW I'm interested, but haven't as a user seen the same thing here... 
scrubs have worked fine here unless I forget to sudo, in which case they 
don't work at all as they can't get necessary privs.

And I'm stumped as to what else it might be.  I don't even have an idea 
where to start looking for clues.

But not being a dev and having not the foggiest what the problem may be, 
it's not like my interest is going to help much, which is why I didn't 
reply earlier.  Just posting now to say you're not alone in your 
interest.  Things like this that don't seem to have any logic bother me, 
tho, so I really would like to at least learn why it's happening.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

