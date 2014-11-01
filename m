Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51149 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbaKAHAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 1 Nov 2014 03:00:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XkSfm-0003ik-PQ
	for linux-btrfs@vger.kernel.org; Sat, 01 Nov 2014 08:00:30 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Nov 2014 08:00:30 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Nov 2014 08:00:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Quota question
Date: Sat, 1 Nov 2014 07:00:20 +0000 (UTC)
Message-ID: <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr>
	<F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cyril Scetbon posted on Fri, 31 Oct 2014 09:45:23 +0100 as excerpted:

> Besides the first question, I met an issue using parent groups (see
> http://pastebin.com/asT5ZFsi). I can't reproduce it all the time, but it
> seems to appear frequently. Is there any know BUG that can be the source
> of this error ? I'm using version 3.12 on Trusty

I don't use quotas personally, but I know for quite some time they were 
essentially "broken" in certain instances.  My recommendation as a list 
regular then was, unless your goal is specific quota-feature-testing, if 
you /need/ quotas, use a more mature filesystem that can reliably provide 
them; if you don't need quotas, turn them off and avoid the quota related 
btrfs bugs.

Recently, around 3.16 timeframe I believe, there was quite a btrfs quota-
subsystem rewrite designed to tackle and eliminate these problems.  Now 
since I don't use quotas personally and I've not seen a definitive 
statement on-list one way or the other I'm not sure if the full rewrite 
is done yet or not, but I've not see further followup patches either, so 
barring further information to the contrary I'd guess it is.  However, 
it's still early in the history of the new code  and it's still just 
that, new.  While I've not seen many quota-related bug reports from it, 
it may well be that enough people took the general recommendation above 
that it simply hasn't gotten much testing.

So I honestly can't say what the state of the new quota code is, but one 
thing I can say for sure is that the quota code in 3.12 is the old code, 
known to be broken and now rewritten, dead quota code.  So for sure I'd 
say don't use it.  It's known to be broken and there's simply no reason 
to do so.

But with the rewrite you now have three choices instead of two.  If you 
need quotas and are up for testing relatively new code (and btrfs itself 
isn't exactly the maturest around, so if you're not up for testing new 
code, why are you running btrfs at all?), try a recent enough btrfs that 
you are running the new quota code and your tests and potentially bug 
reports will be actually worthwhile.  I just read today that Ubuntu is 
maintaining the 3.16 kernel for somewhat longer in coordination with 
their distro releases, after Greg recently released the last planned 
regular stable 3.16 release, so that's a reasonable kernel series to 
settle with.  I /think/ it has the new quota code, and certainly, the bad 
bug in the 3.15 series is fixed (in 3.16.2) and the bug that plagued 
3.17, now fixed in 3.18-rc2 and headed for 3.17 stable, wouldn't be in 
3.16 stable either.  Or you can of course follow current mainline.

The other two choices are as before, turn off quotas in btrfs, or switch 
to a more mature filesystem with reliable quota support.  But staying 
with 3.12 with btrfs quotas enabled simply doesn't make sense, because as 
I said, the quota code there is dead and known broken, so that's not a 
reasonable option at all.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

