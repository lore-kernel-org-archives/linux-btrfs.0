Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56289 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753419AbdEDOYY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 May 2017 10:24:24 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d6Hg0-0007hp-1e
        for linux-btrfs@vger.kernel.org; Thu, 04 May 2017 16:24:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Struggling with file system slowness
Date: Thu, 4 May 2017 14:24:10 +0000 (UTC)
Message-ID: <pan$f7b5$29c9da6e$210621d4$45b3231c@cox.net>
References: <a5052685-e126-d11d-7e9c-fc010c958319@techsquare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Matt McKinnon posted on Thu, 04 May 2017 09:15:28 -0400 as excerpted:

> Hi All,
> 
> Trying to peg down why I have one server that has btrfs-transacti pegged
> at 100% CPU for most of the time.
> 
> I thought this might have to do with fragmentation as mentioned in the
> Gotchas page in the wiki (btrfs-endio-wri doesn't seem to be involved as
> mentioned in the wiki), but after running a full defrag of the file
> system, and also enabling the 'autodefrag' mount option, the problem
> still persists.
> 
> What's the best way to figure out what btrfs is chugging away at here?
> 
> Kernel: 4.10.13-custom
> btrfs-progs: v4.10.2

Headed for work so briefer than usual...

Three questions:

Number of snapshots per subvolume?

Quotas enabled?

Do you do dedupe or otherwise have lots of reflinks?


These dramatically affect scaling.  Keeping the number of snapshots per 
subvolume under 300, under 100 if possible, should help a lot.  Quotas 
dramatically worsen the problem, so keeping them disabled unless your use-
case calls for them should help (and if your use-case calls for them, 
consider a filesystem where the quota feature is more mature).  And 
reflinks are the mechanism behind snapshots, so too many of them for 
other reasons (such as dedupe) create problems too, tho a snapshot 
basically reflinks /everything/, so it takes quite a few reflinks to 
trigger the scaling issues of a single snapshot, meaning they aren't 
normally a problem unless dedupe is done on a /massive/ scale.

Of course defrag interacts with snapshots too, tho it shouldn't affect 
/this/ problem, but potentially eating up more space than expected as it 
breaks the reflinks.


Beyond that, have you tried a (readonly) btrfs check and/or a scrub or 
balance recently?  Perhaps there's something wrong that's snagging 
things, and you simply haven't otherwise detected it yet?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

