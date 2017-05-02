Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35356 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdEBUeS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 16:34:18 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1d5eUy-0004c5-SB
        for linux-btrfs@vger.kernel.org; Tue, 02 May 2017 22:34:16 +0200
Date: Tue, 2 May 2017 22:34:16 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Can I see what device was used to mount btrfs?
Message-ID: <20170502203416.td2fzb6xet44eve2@angband.pl>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
 <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
 <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
 <20170502184923.jdpfx3pwkl5avdph@angband.pl>
 <c7f3c9fe-2f28-e102-9df7-273dc5a6ca8e@inwind.it>
 <20170502221506.3dfe125e@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502221506.3dfe125e@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 10:15:06PM +0200, Kai Krakow wrote:
> Ideally, the btrfs wouldn't even appear in /dev until it was assembled
> by udev. But apparently that's not the case, and I think this is where
> the problems come from. I wish, btrfs would not show up as device nodes
> in /dev that the mount command identified as btrfs. Instead, btrfs
> would expose (probably through udev) a device node
> in /dev/btrfs/fs_identifier when it is ready.
> 
> Apparently, the core problem of how to handle degraded btrfs still
> remains. Maybe it could be solved by adding more stages of btrfs nodes,
> like /dev/btrfs-incomplete (for unusable btrfs), /dev/btrfs-degraded
> (for btrfs still missing devices but at least one stripe of btrfs raid
> available) and /dev/btrfs as the final stage.

The problem is, we can't tell these states apart other than doing the vast
majority of mount's work.  As I described earlier in this thread, even the
"fully available" stage is not trivial.


Meow!
-- 
Don't be racist.  White, amber or black, all beers should be judged based
solely on their merits.  Heck, even if occasionally a cider applies for a
beer's job, why not?
On the other hand, corpo lager is not a race.
