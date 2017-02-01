Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37858 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdBAFJn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 00:09:43 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cYnAk-0005Pi-Ql
        for linux-btrfs@vger.kernel.org; Wed, 01 Feb 2017 06:09:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
Date: Wed, 1 Feb 2017 05:09:28 +0000 (UTC)
Message-ID: <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
References: <1485905578.6441.20.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Lupien posted on Tue, 31 Jan 2017 18:32:58 -0500 as excerpted:

> I have been testing btrfs send/receive. I like it.
> 
> During those tests I discovered that it is possible to access and modify
> (add files, delete files ...) of the new receive snapshot during the
> transfer. After the transfer it becomes readonly but it could already
> have been modified.
> 
> So you can end up with a source and a destination which are not the
> same. Therefore during a subsequent incremental transfers I can get
> receive to crash (trying to unlink a file that is not in the parent but
> should).
> 
> Is this behavior by design or will it be prevented in the future?
> 
> I can of course just not modify the subvolume during receive but is
> there a way to make sure no user/program modifies it?

I'm just a btrfs-using list regular not a dev, but AFAIK, the behavior is 
likely to be by design and difficult to change, because the send stream 
is simply a stream of userspace-context commands for receive to act upon, 
and any other suitably privileged userspace program could run the same 
commands.  (If your btrfs-progs is new enough receive even has a dump 
option, that prints the metadata operations in human readable form, one 
operation per line.)

So making the receive snapshot read-only during the transfer would 
prevent receive itself working.

> I can also get in the same kind of trouble by modifying a parent (after
> changing its property temporarily to ro=false). send/receive is checking
> that the same parent uuid is available on both sides but not that
> generation has not changed. Of course in this case it requires direct
> user intervention. Never changing the ro property of subvolumes would
> prevent the problem.
> 
> Again is this by design?

Again, yes.  The ability to toggle snapshots between ro/rw is a useful 
feature and was added deliberately.  This one would seem to me to be much 
like the (no doubt apocryphal) guy who went to the doctor complaining 
that when he beat his head against the wall, it hurt.  The doctor said, 
"Stop doing that then."

> Otherwise I would suggest finding a way to avoid those conditions (using
> the generation maybe?). There could be an override option to allow more
> flexibility if needed.

There's a send-stream format version bump planned, that should fix 
various issues and eliminate various limitations.  However, in ordered to 
minimize the number of format versions that must continue to be supported 
into the future, they don't plan to do that bump until they're relatively 
sure their list of changes to make is complete.  They don't want to do 
the bump and then a kernel series or two later discover they need yet 
another tweak.

Remember, btrfs' status remains "stabilizing, but not yet fully stable 
and mature."  A lot of stuff hasn't been optimized either, because 
they're focused on eliminating the bugs and adding missing features 
still, not optimizing, at this point, and they don't want to spend a 
bunch of time optimizing something, only to have to rewrite or even just 
tweak it, perhaps to support say N-way-mirroring, and have to redo the 
optimization as a result.

This sort of additional sync guarantees may be in the final generally 
considered stabilized product, but that's yet some time (years) away.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

