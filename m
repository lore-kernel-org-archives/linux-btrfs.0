Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52367 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbcAIJ2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Jan 2016 04:28:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aHppF-0003Tr-NL
	for linux-btrfs@vger.kernel.org; Sat, 09 Jan 2016 10:28:45 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jan 2016 10:28:45 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jan 2016 10:28:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Filesystem hang on kernel 4.2.0 with copy reflink
Date: Sat, 9 Jan 2016 09:28:39 +0000 (UTC)
Message-ID: <pan$dc476$cfd1d0c9$da3d1c34$2b85f935@cox.net>
References: <568A2EDF.6090909@markandruth.co.uk>
	<CA+res+SW+8-R7kOxZdxXdmRyDdDQ8G=CUkVnYK=O=YzHHmCDqg@mail.gmail.com>
	<568A6154.1060101@markandruth.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Zealey posted on Mon, 04 Jan 2016 14:11:00 +0200 as excerpted:

> Also I have quota tracking enabled on the btrfs volume if that makes any
> difference.

I'm not sure whether it makes a difference for this particular hang, but 
I do know that btrfs quotas are simply not stable thru at least 4.3.  I'm 
not sure what 4.4 status is, but my general recommendation regarding 
btrfs quotas is...

If you need quotas, use a more mature filesystem where they work 
reliably, if you don't, then turn them off for now, and don't turn them 
on again until at least two complete kernel cycles have passed without a 
known quota bug or instability, which, if 4.4 is indeed known-bug-free 
and it and 4.5 remain so thru 4.6, means that would be the earliest I 
could recommend turning it on, and that's only if there's no known quota 
bugs in 4.4 or 4.5 or 4.6 by the time of 4.6 release.

Unless of course you're deliberately and specifically testing btrfs 
quotas and working with the devs on fixing quota specific issues, in 
which case, thank you. =:^)

Meanwhile, the rather long history of problems with quotas on btrfs is 
both the reason I'm suggesting two complete cycles without quota issues 
before enabling them, and a good reason to be skeptical as to current 
releases' quota code or the likelihood of that two-releases-quota-bug-
free happening any time soon.  There's definitely a lot of work going 
into the feature and there's gotta be a point where it actually works, 
but they've rewritten the code three times and are still dealing with 
bugs, and it has been in a "try back in a couple kernel cycles" state for 
years, now, so... who knows?  Kinda reminds me of how long the raid56 
code took, only quota was being worked on before that, and is still being 
worked on, so...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

