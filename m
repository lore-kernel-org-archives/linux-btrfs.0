Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54919 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaEFVnw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 17:43:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Whn9S-0003Vp-Qr
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 23:43:50 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 23:43:50 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 23:43:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Please review and comment, dealing with btrfs full issues
Date: Tue, 6 May 2014 21:43:39 +0000 (UTC)
Message-ID: <pan$b249a$72d93c56$a58d7a0c$356c6a0f@cox.net>
References: <20140505121603.GO10159@merlins.org>
	<5367C551.6020604@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Mon, 05 May 2014 19:07:29 +0200 as excerpted:

> In your last example, a full rebalance is not necessary. If you want to
> clear all unnecessary chunks you can run the balance with -dusage=80
> (636GB/800GB~=79%). That will cause a rebalance only of the data chunks
> that are 80% and less used, which would by necessity get about ~160GB
> worth chunks back out of data and available for re-use.

I don't believe your reasoning is entirely valid.  In the pathologically 
extreme case, all data chunks are 80% plus one byte used, save for one 
that's empty, and a -dusage=80 balance will return just that one empty 
chunk (but as a consequence return real fast as there's nothing else to 
do), just the same as -dusage=0, but -dusage=81 would return the 20% 
expected, but would take as long as -dusage=100 (or simply -d).

OTOH, if all chunks but one are 100% full, with the remaining chunks 
empty, a balance with -dusage=0 will have (within one chunk, depending on 
how full it is) the same effect as -dusage=80, with both completing at 
the same fast speed and returning more chunks than expected.  But simple 
-d (or -dusage=100) would take much MUCH longer, but return nothing 
(well, within one chunk) more than the -dusage=0 would.

Actual results, therefore, depend on file AND chunk fragmentation and 
usage.  Using the autodefrag mount option should increase the likelihood 
of better results faster, at lower -Xusage= numbers, but the only way to 
be sure is to do a run with numbers you think look reasonable given the 
situation you are in and the time you're willing to wait, and then rerun 
it again if the results weren't good enough.

Your algorithm is certainly a good first approximation, but it's just 
that, an approximation.  People who want the balance over as soon as 
possible but are willing to retry if necessary, should probably try a 
lower usage= number, while those who are leaving on a trip in the morning 
and want it to run overnight, with little chance of redoing it if the 
results weren't good enough, should probably pick a higher usage= number, 
even perhaps usage=95 or the like, to recover as much space as possible, 
without wasting time rebalancing the chunks that really ARE 100% full 
already.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

