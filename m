Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.galliera.it ([62.101.86.54]:32947 "EHLO smtp.galliera.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaIXO2i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 10:28:38 -0400
Received: from galliera.it (simoman.ceed [10.0.6.66])
	by smtp.galliera.it (Postfix) with ESMTP id ED93330F755A
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Sep 2014 16:28:35 +0200 (CEST)
Date: Wed, 24 Sep 2014 16:28:35 +0200
From: Simone Ferretti <simone@galliera.it>
To: linux-btrfs@vger.kernel.org
Subject: Re: mount problem
Message-ID: <20140924142835.GA18272@galliera.it>
References: <20140923120641.GA27624@galliera.it>
 <pan$b29db$c1fc8f39$f1e6e06c$d6b3042c@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$b29db$c1fc8f39$f1e6e06c$d6b3042c@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wed, Sep 24, 2014 at 01:23:32PM +0000, Duncan wrote:
> Simone Ferretti posted on Tue, 23 Sep 2014 14:06:41 +0200 as excerpted:
> 
> > we're testing BTRFS on our Debian server.  After a lot of operations
> > simulating a RAID1 failure, every time I mount my BTRFS RAID1 volume the
> > kernel logs these messages:
> > 
> > [73894.436173] BTRFS: bdev /dev/etherd/e30.20 errs:
> > wr 33036, rd 0, flush 0, corrupt 2806, gen 0
> > [73894.436181] BTRFS: bdev /dev/etherd/e60.28 errs:
> > wr 244165, rd 0, flush 0, corrupt 1, gen 4
> > 
> > Everything seems to work nice but I'm courious to know what these
> > messages mean (in particular what do "gen" and "corrupt" mean?).
> 
> Gen=generation.  The generation or transaction-ID (different names for 
> the exact same thing) is a monotonically increasing integer that gets 
> updated every time a tree update reaches all the way to the superblock.  
> In the error context, it means the superblock had one generation number 
> but N other blocks had a different (presumably older) generation number.
> 
> Corrupt is simply the number of blocks where the calculated checksum 
> didn't match the recorded checksum, thus indicating an error.
>
> See btrfs device stats -z to reset the numbers to zero (after printing 
> them one last time).


Thank you much for your quick and illuminating answer.

I'm wondering if you (or anyone else of course) know if there is btrfs
documentation/papers/anything (besides wiki I did not find anything),
in which it's possible to learn this kind of informations?

-- 
Bye,
Simone
