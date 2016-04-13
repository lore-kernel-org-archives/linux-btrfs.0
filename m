Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54694 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756002AbcDMDNp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 23:13:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aqBFL-0008CV-RI
	for linux-btrfs@vger.kernel.org; Wed, 13 Apr 2016 05:13:40 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Apr 2016 05:13:39 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Apr 2016 05:13:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: enospace regression in 4.4
Date: Wed, 13 Apr 2016 03:13:33 +0000 (UTC)
Message-ID: <pan$43c78$d863b627$e38d5fc3$8e7a854b@cox.net>
References: <570CCCFB.5000104@googlemail.com>
	<570D19D9.8030702@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Julian Taylor posted on Tue, 12 Apr 2016 17:52:57 +0200 as excerpted:

> $ sudo btrfs fi balance start -dusage=0 .
> ERROR: error during balancing '.': No space left on device

Not much to add, but this one really surprises me and it may be related 
to the new problem you're seeing.

I don't recall ever seeing a -dusage=0 actually error out due to ENOSPC 
before.  It normally either works, killing some empty chunks, or runs 
without error but also without finding any empty chunks to kill, thus 
"doing nothing, successfully" (to borrow the one-line name and 
description for true (1)).

That even a balance with -dusage=0 is actually failing, not just 
completing without doing anything as might be expected, is strange 
indeed.  With a bit of luck that's a strong hint to the devs as to what 
has actually gone wrong and how to fix it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

