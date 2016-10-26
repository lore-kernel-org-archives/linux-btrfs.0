Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:65210 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934507AbcJZWVG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 18:21:06 -0400
Date: Thu, 27 Oct 2016 09:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hch@infradead.org, jweiner@fb.com
Subject: Re: [PATCH 5/5] fs: don't set *REFERENCED unless we are on the lru
 list
Message-ID: <20161026222054.GA22126@dastard>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-6-git-send-email-jbacik@fb.com>
 <20161025220112.GE14023@dastard>
 <20161025233604.GF14023@dastard>
 <20683c6a-5419-3a66-8574-fcf19f2347f9@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20683c6a-5419-3a66-8574-fcf19f2347f9@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 04:03:54PM -0400, Josef Bacik wrote:
> On 10/25/2016 07:36 PM, Dave Chinner wrote:
> >So, 2-way has not improved. If changing referenced behaviour was an
> >obvious win for btrfs, we'd expect to see that here as well.
> >however, because 4-way improved by 20%, I think all we're seeing is
> >a slight change in lock contention levels inside btrfs. Indeed,
> >looking at the profiles I see that lock contention time was reduced
> >to around 32% of the total CPU used (down by about 20%):
> >
> >  20.79%  [kernel]  [k] __pv_queued_spin_lock_slowpath
> >   3.85%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
> >   3.68%  [kernel]  [k] _raw_spin_lock
> >   3.40%  [kernel]  [k] queued_write_lock_slowpath
> >   .....
> >
> >IOWs, the performance increase comes from the fact that changing
> >inode cache eviction patterns causes slightly less lock contention
> >in btrfs inode reclaim. IOWs, the problem that needs fixing is the
> >btrfs lock contention, not the VFS cache LRU algorithms.
> >
> >Root cause analysis needs to be done properly before behavioural
> >changes like this are proposed, people!
> >
> 
> We are doing different things.

Well, no, we're doing the same thing. Except...

> Yes when you do it all into the same
> subvol the lock contention is obviously much worse and the
> bottleneck, but that's not what I'm doing, I'm creating a subvol for
> each thread to reduce the lock contention on the root nodes.

.. you have a non-default filesystem config that you didn't mention
even in response to a /direct question/. Seriously, this is a major
configuration detail that is necessary for anyone who wants to
replicate your results!

The difference is that I'm using is the /default/ btrfs filesystem
configuration and you're using a carefully contrived structure that
is designed to work around fundamental scalability issues the
benchmark normally exposes.

This raises another question: Does this subvol setup reflect
production configurations, or is it simply a means to get the
benchmark to put enough load on the inode cache to demonstrate the
effect of changing the reference bits?

> If you
> retest by doing that then you will see the differences I was seeing.
> Are you suggesting that I just made these numbers up? 

No, I'm suggesting that you haven't explained the problem or how to
reproduce it in sufficient detail.

You haven't explained why reducing scanning (which in and of iteself
has minimal overhead and is not visible to btrfs) has such a marked
effect on the behaviour of btrfs. You haven't given us details on
the workload or storage config so we can reproduce the numbers (and
still haven't!). You're arguing that numbers far below variablity
and accuracy measurement limits are significant (i.e. the patched
numbers are better for XFS and ext4). There's lots of information
you've chosen to omit that we need to know.

To fill in the gaps, I've done some analysis, provided perf numbers
and CPU profiles, and put them into an explanation that explains why
there is a difference in performance for a default btrfs config. I
note that you've not actually addressed that analysis and the
problems it uncovers, but instead just said "I'm using a different
configuration".

What about all the btrfs users that aren't using your configuration
that will see these problems? How does the scanning change actually
benefit them more than fixing the locking issues that exist? Memory
reclaim and LRU algorithms affect everyone, not just a benchmark
configuration. We need to know a lot more about the issue at hand
to be able to evaluate whether this is the /right solution for the
problem./

> Instead of
> assuming I'm an idiot and don't know how to root cause issues please
> instead ask what is different from your run versus my run.  Thanks,

I'm assuming you're a compentent engineer, Josef, who knows that
details about benchmarks and performance measurement are extremely
important, and that someone reviewing code needs to understand why
the behaviour change had the impact it did to be able to evaluate it
properly. I'm assuming that you also know that if you understand the
root cause of a problem, you put it in the commit message so that
everyone else knows it, too.

So if you know what the root cause of the btrfs problem that
reducing reclaim scanning avoids, then please explain it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
