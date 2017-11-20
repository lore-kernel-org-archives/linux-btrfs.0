Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48799 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdKTW6Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 17:58:16 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eGv0t-0004uG-Ty
        for linux-btrfs@vger.kernel.org; Mon, 20 Nov 2017 23:58:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: test btrfs scrubbing/get system's total capacity
Date: Mon, 20 Nov 2017 22:57:55 +0000 (UTC)
Message-ID: <pan$52793$c6a99c59$481f8d0c$e85aa3e9@cox.net>
References: <1511196626.1657.29.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ST posted on Mon, 20 Nov 2017 18:50:26 +0200 as excerpted:

> [...] to set btrfs quota on a /home subvolume as say
> 0.8*TotalCapacityOfRoot and then assign to it individual users'
> subvolumes with certain (smaller) quatos.

On the narrow subject of btrfs quotas...

Just be sure you're aware of the effect of btrfs quotas on btrfs 
maintenance command times, and are using a "newish" kernel, as...

* For years quotas were so buggy that they simply weren't sanely reliable 
(negative numbers, anyone?).  In general those bugs are fixed in newer 
kernels, but there's still minor tweaks going in.  I'd for sure want at 
/least/ 4.9-LTS series if I were relying on kernels (and I'm not 
/entirely/ sure the appropriate patches have all made it there), and 
would want to move to 4.14-LTS ASAP.  Or just use the current kernel 
series and upgrade with it.

IOW, don't even consider quotas pre-4.9.  They're too buggy to be worth 
the hassle.

* While the worst quota bugs now appear to be quashed and it's at least 
usable (the numbers come out correct), quotas continue to have scaling 
issues and likely will for some time to come.

Generally these scaling issues don't affect generic filesystem (or quota) 
operation, but they *do* affect various btrfs maintenance commands where 
they compound already severe scaling interactions with snapshots and 
reflinks in commands such as btrfs subvol delete, btrfs balance (and thus 
btrfs device remove due to its implicit balance), and btrfs check, to the 
point that the commands cannot complete in practical time (days to weeks, 
even months, instead of hours).

For commands such as btrfs balance, temporarily disabling quotas (renable 
and rescan if necessary when done) speeds things up dramatically, but 
that's not likely to be possible in many of the scenarios one would find 
themselves wanting to run btrfs check in.


If you're already aware of and prepared to work with those caveats, 
great, but I've seen enough people complaining about slow balance, etc, 
due to having quotas enabled (and being thrilled with the actually 
workable speed once they turn them off) when they didn't really need 
them, that I tend to cringe inside every time I see people saying they 
plan on using them, without mentioning that they're aware of the issues 
and find them an acceptable tradeoff for their use-case.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

