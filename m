Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33715 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbbIPUTG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 16:19:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZcJAU-0008On-Q0
	for linux-btrfs@vger.kernel.org; Wed, 16 Sep 2015 22:19:03 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 22:19:02 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 22:19:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel BUG at
 =?us-ascii?Q?linux-4=2E2=2E0=2Ffs=2Fbtrfs=2Fextent-tree=2Ec=3A183?=
 =?us-ascii?Q?3?= on rebalance
Date: Wed, 16 Sep 2015 20:18:56 +0000 (UTC)
Message-ID: <pan$5599c$cb01bfb8$910004c8$d38ea6b6@cox.net>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
	<2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
	<532aadf0f92d08d3d2b274173548aee1@all.all>
	<pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
	<f81878fadaf2980a72522e54010e0415@all.all>
	<55F9486F.4040302@googlemail.com>
	<0973de930ee87e102c533c719807b748@all.all>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stéphane Lesimple posted on Wed, 16 Sep 2015 15:04:20 +0200 as excerpted:

> Le 2015-09-16 12:46, Holger Hoffstätte a écrit :
>> 
>> In that case the "crossing stripe boundary" messages are false
>> positives in btrfs-progs-4.2:
>> http://www.spinics.net/lists/linux-btrfs/msg47059.html
>> 
>> This should be fixed in the next release.

Thanks for reminding me of that, Holger.  I think I was too sleepy when I 
read it on-list, and forgot about it...

> Out of curiosity I compiled the btrfs-progs-4.2 release patched with the
> diff you're referencing to fix the off-by-one error, and ran a btrfsck
> again.
> Indeed those errors disappear and my filesystem seems clean in this
> regard. I also disabled quota because it has almost for sure nothing to
> do with the bug, and now btrsfck is 100% happy:

Yes.  Quotas have been a continuing issue on btrfs.  AFAIK, they're on 
the third rewrite now, and still have some bugs to work out.  So what 
I've been recommending is unless you're (a) directly and specifically 
working with the devs to find and fix the quota issues (in which case 
please keep at it! =:^), either you (b) really depend on quotas working 
and btrfs isn't appropriate for you at this time, since they're known to 
be buggy, so use a more mature filesystem where they're known to work, or 
(c) you don't actually need quotas at all, so disable them and remove the 
quota tracking metadata, thus avoiding the bugs in the feature entirely. 
=:^)

(Agreed with your conclusions and nothing to add to the rest of your 
message, so omitted here.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

