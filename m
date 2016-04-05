Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40330 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbcDEDCt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 23:02:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anHGR-0007Df-Bm
	for linux-btrfs@vger.kernel.org; Tue, 05 Apr 2016 05:02:47 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 05:02:47 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 05:02:47 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 00/13 v3] Introduce device state 'failed', Hot spare and
 Auto replace
Date: Tue, 5 Apr 2016 03:02:41 +0000 (UTC)
Message-ID: <pan$18bc7$19b02793$bd43daae$43f1ae98@cox.net>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
	<20160404020043.47ad35bf@jupiter.sol.kaishome.de>
	<pan$5fc01$c48cb58$b5aadf3d$c2af2f78@cox.net>
	<20160404221513.7fd31f8f@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Mon, 04 Apr 2016 22:15:13 +0200 as excerpted:

> Your argument would be less important if it did copy-back, tho... ;-)

FWIW, I completely misunderstood your description of copy-back in my 
original reply, and didn't realize what you meant (and thus my mistaken 
understanding) until I read some of the other replies today.

What I /thought/ you meant was some totally nonsense/WTF idea of keeping 
the newly substituted hot-spare in place, and taking the newly vacated 
"defective" device and putting it back in the the hot-spare list.

That rightly seemed stupid to me (it's a device just replaced as 
defective, now you're putting it back as a hot-spare? WTF?), but that's 
how I read what you were asking for and saying that other solutions did, 
so...

Of course today when I read the other replies and realized what you were 
/actually/ describing, returning the hot-spare to hot-spare status after 
physically replacing the actually failed drive with a new one and 
logically replacing the hot-spare with it in the filesystem, thereby 
making the hot-spare a spare once again, my reaction was "DUH!! NOW it 
makes sense!"  But I was just going to let it go and go hide my original 
misunderstanding in a hole somewhere.

But now you replied to my reply, so I figured I would reply back, 
explaining what on earth I was thinking when I wrote it, and why it must 
have seemed rather out of left field and didn't make much sense -- 
because what I was thinking you were suggesting /didn't/ make sense, but 
of course that's because I totally misunderstood what you were suggesting.

So now my very-much-former misunderstanding is out of the hole and posted 
for everyone to see and have a good laugh at, and I'm much the wiser on 
what copy-back actually entails. =:^)

Tho it seems I was correct in the one aspect, currently ENotImplemented, 
even if my idea of what you were asking to be implemented was totally and 
completely off-the-wall wrong.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

