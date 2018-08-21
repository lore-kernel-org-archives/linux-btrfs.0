Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33971 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727344AbeHUVgi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 17:36:38 -0400
Date: Tue, 21 Aug 2018 11:15:21 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] address lock contention of btree root
Message-ID: <20180821181521.nj4cxyjqt5fo5vng@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1534453645-17714-1-git-send-email-bo.liu@linux.alibaba.com>
 <5E5CC82C-57F8-4834-9630-B7DD7CA23C9E@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5E5CC82C-57F8-4834-9630-B7DD7CA23C9E@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2018 at 01:54:11PM -0400, Chris Mason wrote:
> On 16 Aug 2018, at 17:07, Liu Bo wrote:
> 
> > The lock contention on btree nodes (esp. root node) is apparently a
> > bottleneck when there're multiple readers and writers concurrently
> > trying to access them.  Unfortunately this is by design and it's not
> > easy to fix it unless with some complex changes, however, there is
> > still some room.
> > 
> > With a stable workload based on fsmark which has 16 threads creating
> > 1,600K files, we could see that a good amount of overhead comes from
> > switching path between spinning mode and blocking mode in
> > btrfs_search_slot().
> > 
> > Patch 1 provides more details about the overhead and test results from
> > fsmark and dbench.
> > Patch 2 kills leave_spinning due to the behaviour change from patch 1.
> 
> This is really interesting, do you have numbers about how often we are able
> to stay spinning?
>

I didn't gather how long we stay spinning, but I was tracking

(1) how long a read lock or write lock can wait until it gets the
lock, with vanilla kernel, for read lock, it could be up to 10ms while
for write lock, it could be up to 200ms.

(2) how many switches occurs when reader/writers wait for blocking locks,
for both readers and writers, there are up to 50 times.

but I guess it highly depends on the test environment, I'm using a 24
core VM and the test dispatches 16 threads to do the job.

> IOW, do we end up blocking every time?

With setting leave_spinning, we don't, this part works fine.

I just realize that patch 2 can result in softlockup as
btrfs_search_slot() may return a path with all nodes being in spinning
lock, and if the callers want to sleep, we're in trouble.  I've
removed patch 2 and am re-running the test (xfstests, fsmark and
dbench).

thanks,
-liubo
