Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41240 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbeGCEPy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 00:15:54 -0400
Date: Mon, 2 Jul 2018 21:15:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: how to best segment a big block device in resizeable btrfs filesystems?
Message-ID: <20180703041550.GH5567@merlins.org>
References: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com> <20180629064354.kbaepro5ccmm6lkn@merlins.org> <20180701232202.vehg7amgyvz3hpxc@merlins.org> <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com> <20180702032259.GD5567@merlins.org> <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com> <20180702140527.wfbq5jenm67fvvjg@merlins.org> <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com> <20180702151853.mwlrinipbihq46zu@merlins.org> <ee8ff481-0aac-54ec-b496-f28feab2227b@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ee8ff481-0aac-54ec-b496-f28feab2227b@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 09:37:47AM +0800, Qu Wenruo wrote:
> > If I do this, I would have
> > software raid 5 < dmcrypt < bcache < lvm < btrfs
> > That's a lot of layers, and that's also starting to make me nervous :)
> 
> If you could keep the number of snapshots to minimal (less than 10) for
> each btrfs (and the number of send source is less than 5), one big btrfs
> may work in that case.
 
Well, we kind of discussed this already. If btrfs falls over if you reach
100 snapshots or so, and it sure seems to in my case, I won't be much better
off.
Having btrfs check --repair fail because 32GB of RAM is not enough, and it's
unable to use swap, is a big deal in my case. You also confirmed that btrfs
check lowmem does not scale to filesystems like mine, so this translates
into "if regular btrfs check repair can't fit in 32GB, I am completely out
of luck if anything happens to the filesystem"

You're correct that I could tweak my backups and snapshot rotation to get
from 250 or so down to 100, but it seems that I'll just be hoping to avoid
the problem by being just under the limit, until I'm not, again, and it'll
be too late to do anything it next time I'm in trouble again, putting me
back right in the same spot I'm in now.
Is all this fair to say, or did I misunderstand?

> BTW, IMHO the bcache is not really helping for backup system, which is
> more write oriented.

That's a good point. So, what I didn't explain is that I still have some old
filesystem that do get backed up with rsync instead of btrfs send (going
into the same filesystem, but not same subvolume).
Because rsync is so painfully slow when it needs to scan both sides before
it'll even start doing any work, bcache helps there.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
