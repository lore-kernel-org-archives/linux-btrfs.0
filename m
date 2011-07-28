From: Christian Brunner <chb@muc.de>
Subject: Re: Btrfs slowdown
Date: Thu, 28 Jul 2011 17:10:27 +0200
Message-ID: <CAO47_-9r86Bbfzh7VpmUCP8BQgE4ciPAgDapJmxMsoTWz4PE3w@mail.gmail.com>
References: <CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com>
	<1311623446-sup-8105@shiny>
	<CAO47_--KOyMdS-OP06cLpD+qTQ+gqGcw_DCPUrLOeypt5j_G4g@mail.gmail.com>
	<CALFpzo4aNPmypyHXbK9YnxuQxNcDXv7wf+KPxakkcJVuZN5eaw@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel <ceph-devel@vger.kernel.org>
To: Marcus Sorensen <shadowsor@gmail.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CALFpzo4aNPmypyHXbK9YnxuQxNcDXv7wf+KPxakkcJVuZN5eaw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/7/28 Marcus Sorensen <shadowsor@gmail.com>:
> Christian,
>
> Have you checked up on the disks themselves and hardware? High
> utilization can mean that the i/o load has increased, but it can also
> mean that the i/o capacity has decreased. =A0Your traces seem to
> indicate that a good portion of the time is being spent on commits,
> that could be waiting on disk. That "wait_for_commit" looks to
> basically just spin waiting for the commit to complete, and at least
> one thing that calls it raises a BUG_ON, not sure if it's one you've
> seen even on 2.6.38.
>
> There could be all sorts of performance related reasons that aren't
> specific to btrfs or ceph, on our various systems we've seen things
> like the raid card module being upgraded in newer kernels and suddenl=
y
> our disks start to go into sleep mode after a bit, dirty_ratio causin=
g
> multiple gigs of memory to sync because its not optimized for the
> workload, external SAS enclosures stop communicating a few days after
> reboot (but the disks keep working with sporadic issues), things like
> patrol read hitting a bad sector on a disk, causing it to go into
> enhanced error recovery and stop responding, etc.

I' fairly confident that the hardware is ok. We see the problem on
four machines. It could be a problem with the hpsa driver/firmware,
but we haven't seen the behavior with 2.6.38 and the changes in the
hpsa driver are not that big.

> Maybe you have already tried these things. It's where I would start
> anyway. Looking at /proc/meminfo, dirty, writeback, swap, etc both
> while the system is functioning desirably and when it's misbehaving.
> Looking at anything else that might be in D state. Looking at not jus=
t
> disk util, but the workload causing it (e.g. Was I doing 300 iops
> previously with an average size of 64k, and now I'm only managing 50
> iops at 64k before the disk util reports 100%?) Testing the system in
> a filesystem-agnostic manner, for example when performance is bad
> through btrfs, is performance the same as you got on fresh boot when
> testing iops on /dev/sdb or whatever? You're not by chance swapping
> after a bit of uptime on any volume that's shared with the underlying
> disks that make up your osd, obfuscated by a hardware raid? I didn't
> see the kernel warning you're referring to, just the ixgbe malloc
> failure you mentioned the other day.

I've looked at most of this. What makes me point to btrfs, is that the
problem goes away when I reboot on server in our cluster, but persists
on the other systems. So it can't be related to the number of requests
that come in.

> I do not mean to presume that you have not looked at these things
> already. I am not very knowledgeable in btrfs specifically, but I
> would expect any degradation in performance over time to be due to
> what's on disk (lots of small files, fragmented, etc). This is
> obviously not the case in this situation since a reboot recovers the
> performance. I suppose it could also be a memory leak or something
> similar, but you should be able to detect something like that by
> monitoring your memory situation, /proc/slabinfo etc.

It could be related to a memory leak. The machine has a lot RAM (24
GB), but we have seen page allocation failures in the ixgbe driver,
when we are using jumbo frames.

> Just my thoughts, good luck on this. I am currently running 2.6.39.3
> (btrfs) on the 7 node cluster I put together, but I just built it and
> am comparing between various configs. It will be awhile before it is
> under load for several days straight.

Thanks!

When I look at the latencytop results, there is a high latency when
calling "btrfs_commit_transaction_async". Isn't "async" supposed to
return immediately?

Regards,
Christian
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
