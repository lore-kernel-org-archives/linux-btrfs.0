Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41468 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752527AbeGCEWp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 00:22:45 -0400
Date: Mon, 2 Jul 2018 21:22:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Message-ID: <20180703042241.GI5567@merlins.org>
References: <20180629061001.kkmgvdgqfhz23kll@merlins.org> <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com> <20180629064354.kbaepro5ccmm6lkn@merlins.org> <20180701232202.vehg7amgyvz3hpxc@merlins.org> <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com> <20180702032259.GD5567@merlins.org> <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com> <20180702140527.wfbq5jenm67fvvjg@merlins.org> <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com> <CAJCQCtQsNnebkZ-vOfw5WABUj2vOChaE2yyeTBDKVyUcPMgcCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQsNnebkZ-vOfw5WABUj2vOChaE2yyeTBDKVyUcPMgcCg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 06:31:43PM -0600, Chris Murphy wrote:
> So the idea behind journaled file systems is that journal replay
> enabled mount time "repair" that's faster than an fsck. Already Btrfs
> use cases with big, but not huge, file systems makes btrfs check a
> problem. Either running out of memory or it takes too long. So already
> it isn't scaling as well as ext4 or XFS in this regard.
> 
> So what's the future hold? It seems like the goal is that the problems
> must be avoided in the first place rather than to repair them after
> the fact.
> 
> Are the problem's Marc is running into understood well enough that
> there can eventually be a fix, maybe even an on-disk format change,
> that prevents such problems from happening in the first place?
> 
> Or does it make sense for him to be running with btrfs debug or some
> subset of btrfs integrity checking mask to try to catch the problems
> in the act of them happening?

Those are all good questions.
To be fair, I cannot claim that btrfs was at fault for whatever filesystem
damage I ended up with. It's very possible that it happened due to a flaky
Sata card that kicked drives off the bus when it shouldn't have.
Sure in theory a journaling filesystem can recover from unexpected power
loss and drives dropping off at bad times, but I'm going to guess that
btrfs' complexity also means that it has data structures (extent tree?) that
need to be updated completely "or else".

I'm obviously ok with a filesystem check being necessary to recover in cases
like this, afterall I still occasionally have to run e2fsck on ext4 too, but
I'm a lot less thrilled with the btrfs situation where basically the repair
tools can either completely crash your kernel, or take days and then either
get stuck in an infinite loop or hit an algorithm that can't scale if you
have too many hardlinks/snapshots.

It sounds like there may not be a fix to this problem with the filesystem's
design, outside of "do not get there, or else".
It would even be useful for btrfs tools to start computing heuristics and
output warnings like "you have more than 100 snapshots on this filesystem,
this is not recommended, please read http://url/"

Qu, Su, does that sound both reasonable and doable?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
