Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47470 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S933199AbeFTI5o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 04:57:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fVYtl-0001Jr-Pg
        for linux-btrfs@vger.kernel.org; Wed, 20 Jun 2018 10:55:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance did not progress after 12H
Date: Wed, 20 Jun 2018 08:55:23 +0000 (UTC)
Message-ID: <pan$2d3f1$510af9e4$2a3856f6$1a419b18@cox.net>
References: <20180618130055.3rzngk5a5sktfp7p@merlins.org>
        <20180619154730.fblylttw2nyps4cp@merlins.org>
        <CA+X5Wn5_TEH5zwWS8cihnadK_hFg9CL6NcT9Q28mDxtZK97Beg@mail.gmail.com>
        <ab17f789-d475-9812-9c76-83702fc2bd65@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 19 Jun 2018 12:58:44 -0400 as
excerpted:

> That said, I would question the value of repacking chunks that are
> already more than half full.  Anything above a 50% usage filter
> generally takes a long time, and has limited value in most cases (higher
> values are less likely to reduce the total number of allocated chunks).
> With `-duszge=50` or less, you're guaranteed to reduce the number of
> chunk if at least two match, and it isn't very time consuming for the
> allocator, all because you can pack at least two matching chunks into
> one 'new' chunk (new in quotes because it may re-pack them into existing
> slack space on the FS). Additionally, `-dusage=50` is usually sufficient
> to mitigate the typical ENOSPC issues that regular balancing is supposed
> to help with.

While I used to agree, 50% for best efficiency, perhaps 66 or 70% if 
you're really pressed for space, now that the allocator can repack into 
existing chunks more efficiently than it used to (at least in ssd mode, 
which all my storage is now), I've seen higher values result in practical/
noticeable recovery of space to unallocated as well.

In fact, I routinely use usage=70 these days, and sometimes use higher, 
to 99 or even 100%[1].  But of course I'm on ssd so it's far faster, and 
partition it up with the biggest partitions being under 100 GiB, so even 
full unfiltered balances are normally under 10 minutes and normal 
filtered balances under a minute, to the point I usually issue the 
balance command and actually wait for completion, so it's a far different 
ball game than issuing a balance command on a multi-TB hard drive and 
expecting it to take hours or even days.  In that case, yeah, a 50% cap 
arguably makes sense, tho he was using 60, which still shouldn't (sans 
bugs like we seem to have here) be /too/ bad.

---
[1] usage=100: -musage=1..100 is the only way I've found to balance 
metadata without rebalancing system as well, with the unfortunate penalty 
for rebalancing system on small filesystems being an increase of the 
system chunk size from 8 MB original mkfs.btrfs size to 32 MB... only a 
few KiB used! =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

