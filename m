From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Mon, 5 Dec 2011 08:14:13 -0500
Message-ID: <20111205131413.GC26622@shiny>
References: <20111201153955.GL5587@shiny>
 <4EDC7C89.6050803@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EDC7C89.6050803@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 05, 2011 at 04:10:49PM +0800, Miao Xie wrote:
> Hi, Chris and Oliva
> 
> On thu, 1 Dec 2011 10:39:55 -0500, Chris Mason wrote:
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> > 
> > Has our current set of fixes.  This is fairly small, Alexandre Oliva has
> > been chasing problems in our block allocator and kicked out important
> > fixes.
> > 
> > Jan Schmidt fixed a merge error in the raid repair code, we're now
> > properly repairing failed blocks (io errors or crc errors) without
> > having to run a scrub.
> > 
> > Alexandre Oliva (5) commits (+8/-8):
> >     Btrfs: skip block groups without enough space for a cluster (+1/-1)
> 
> This patch introduce a bug that we can not allocate blocks from the cluster
> with enough space and it may make the block allocation fail.
> 
> This is because the check that the above patch introduced make the allocator
> skip the cluster allocation, and jump to the uncluster allocation without
> reclaiming all the blocks in the cluster, At this time, if all the free space
> is in the cluster, and no space in the block group, the allocation will fail.
> (we can trigger this bug on SSD.)
> 
> Fortunately, the following patch written by Oliva can fix this bug.
> 
> [PATCH 08/20] Btrfs: try to allocate from cluster even at LOOP_NO_EMPTY_SIZE

Thanks, I'll push this 08/20 out as well.

-chris
