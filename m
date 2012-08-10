Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:36512 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab2HJL4c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Aug 2012 07:56:32 -0400
Date: Fri, 10 Aug 2012 07:56:28 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH] Btrfs: fix full backref problem when inserting
 shared block reference
Message-ID: <20120810115628.GE32103@shiny>
References: <50232A19.2010704@cn.fujitsu.com>
 <20120809180405.GC32103@shiny>
 <5024E4B7.20600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5024E4B7.20600@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2012 at 04:38:47AM -0600, Miao Xie wrote:
> On 	thu, 9 Aug 2012 14:04:05 -0400, Chris Mason wrote:
> > On Wed, Aug 08, 2012 at 09:10:17PM -0600, Miao Xie wrote:
> >> If we create several snapshots at the same time, the following BUG_ON() will be
> >> triggered.
> >>
> >> 	kernel BUG at fs/btrfs/extent-tree.c:6047!
> >>
> >> Steps to reproduce:
> >>  # mkfs.btrfs <partition>
> >>  # mount <partition> <mnt>
> >>  # cd <mnt>
> >>  # for ((i=0;i<2400;i++)); do touch long_name_to_make_tree_more_deep$i; done
> >>  # for ((i=0; i<4; i++))
> >>  > do
> >>  > mkdir $i
> >>  > for ((j=0; j<200; j++))
> >>  > do
> >>  > btrfs sub snap . $i/$j
> >>  > done &
> >>  > done
> > 
> > snapshot creation has a critical section.  Once we copy a given root to
> > its snapshot, we're not allowed to change it until the transaction
> > is fully committed.
> 
> I knew this critical section. But I think we can kick it away by forcing the
> snapshoted tree to do COW.

Yes, it should be possible.

> 
> BTW, I will take a vacation next week, so I can not reply it until the week after next.
> If it is not urgent, I will continue looking into this problem after I come back.

No problem, we can take the current patch for now and improve add back
the ability to do multiple snapshots per root later.

-chris
