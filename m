Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:47057 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbeHVBpx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 21:45:53 -0400
Date: Tue, 21 Aug 2018 15:23:36 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] address lock contention of btree root
Message-ID: <20180821222335.ej6ygychpq5dlyfd@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1534453645-17714-1-git-send-email-bo.liu@linux.alibaba.com>
 <5E5CC82C-57F8-4834-9630-B7DD7CA23C9E@fb.com>
 <20180821181521.nj4cxyjqt5fo5vng@US-160370MP2.local>
 <0F30A584-4FCA-4B60-B2C1-7CB51E091C9E@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0F30A584-4FCA-4B60-B2C1-7CB51E091C9E@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2018 at 02:48:47PM -0400, Chris Mason wrote:
> On 21 Aug 2018, at 14:15, Liu Bo wrote:
> 
> > On Tue, Aug 21, 2018 at 01:54:11PM -0400, Chris Mason wrote:
> > > On 16 Aug 2018, at 17:07, Liu Bo wrote:
> > > 
> > > > The lock contention on btree nodes (esp. root node) is apparently a
> > > > bottleneck when there're multiple readers and writers concurrently
> > > > trying to access them.  Unfortunately this is by design and it's not
> > > > easy to fix it unless with some complex changes, however, there is
> > > > still some room.
> > > > 
> > > > With a stable workload based on fsmark which has 16 threads creating
> > > > 1,600K files, we could see that a good amount of overhead comes from
> > > > switching path between spinning mode and blocking mode in
> > > > btrfs_search_slot().
> > > > 
> > > > Patch 1 provides more details about the overhead and test
> > > > results from
> > > > fsmark and dbench.
> > > > Patch 2 kills leave_spinning due to the behaviour change from
> > > > patch 1.
> > > 
> > > This is really interesting, do you have numbers about how often we
> > > are able
> > > to stay spinning?
> > > 
> > 
> > I didn't gather how long we stay spinning,
> 
> I'm less worried about length of time spinning than I am how often we're
> able to call btrfs_search_slot() without ever blocking.  If one caller ends
> up going into blocking mode, it can cascade into all of the other callers,
> which can slow things down in low-to-medium contention workloads.

Right, these blocking cases could be COW, split_node, split_leaf, etc.

> 
> The flip side is that maybe the adaptive spinning in the mutexes is good
> enough now and we can just deleting the spinning completely.
>

Looks like so.

> > but I was tracking
> > 
> > (1) how long a read lock or write lock can wait until it gets the
> > lock, with vanilla kernel, for read lock, it could be up to 10ms while
> > for write lock, it could be up to 200ms.
> 
> Nice, please add the stats to the patch descriptions, both before and after.
> I'd love to see a histogram like you can get out of bcc's argdist.py.

Just gave another run of testing with bcc tool funclatency, for write
lock, the worst latency could be up to >500ms, but it could be that
kprobe itself adds some cost to the latency.

thanks,
-liubo
