From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: Btrfs slowdown
Date: Wed, 27 Jul 2011 22:05:36 -0600
Message-ID: <CALFpzo4aNPmypyHXbK9YnxuQxNcDXv7wf+KPxakkcJVuZN5eaw@mail.gmail.com>
References: <CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com>
	<1311623446-sup-8105@shiny>
	<CAO47_--KOyMdS-OP06cLpD+qTQ+gqGcw_DCPUrLOeypt5j_G4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel <ceph-devel@vger.kernel.org>
To: chb@muc.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO47_--KOyMdS-OP06cLpD+qTQ+gqGcw_DCPUrLOeypt5j_G4g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Christian,

Have you checked up on the disks themselves and hardware? High
utilization can mean that the i/o load has increased, but it can also
mean that the i/o capacity has decreased.  Your traces seem to
indicate that a good portion of the time is being spent on commits,
that could be waiting on disk. That "wait_for_commit" looks to
basically just spin waiting for the commit to complete, and at least
one thing that calls it raises a BUG_ON, not sure if it's one you've
seen even on 2.6.38.

There could be all sorts of performance related reasons that aren't
specific to btrfs or ceph, on our various systems we've seen things
like the raid card module being upgraded in newer kernels and suddenly
our disks start to go into sleep mode after a bit, dirty_ratio causing
multiple gigs of memory to sync because its not optimized for the
workload, external SAS enclosures stop communicating a few days after
reboot (but the disks keep working with sporadic issues), things like
patrol read hitting a bad sector on a disk, causing it to go into
enhanced error recovery and stop responding, etc.

Maybe you have already tried these things. It's where I would start
anyway. Looking at /proc/meminfo, dirty, writeback, swap, etc both
while the system is functioning desirably and when it's misbehaving.
Looking at anything else that might be in D state. Looking at not just
disk util, but the workload causing it (e.g. Was I doing 300 iops
previously with an average size of 64k, and now I'm only managing 50
iops at 64k before the disk util reports 100%?) Testing the system in
a filesystem-agnostic manner, for example when performance is bad
through btrfs, is performance the same as you got on fresh boot when
testing iops on /dev/sdb or whatever? You're not by chance swapping
after a bit of uptime on any volume that's shared with the underlying
disks that make up your osd, obfuscated by a hardware raid? I didn't
see the kernel warning you're referring to, just the ixgbe malloc
failure you mentioned the other day.

I do not mean to presume that you have not looked at these things
already. I am not very knowledgeable in btrfs specifically, but I
would expect any degradation in performance over time to be due to
what's on disk (lots of small files, fragmented, etc). This is
obviously not the case in this situation since a reboot recovers the
performance. I suppose it could also be a memory leak or something
similar, but you should be able to detect something like that by
monitoring your memory situation, /proc/slabinfo etc.

Just my thoughts, good luck on this. I am currently running 2.6.39.3
(btrfs) on the 7 node cluster I put together, but I just built it and
am comparing between various configs. It will be awhile before it is
under load for several days straight.

On Wed, Jul 27, 2011 at 2:41 AM, Christian Brunner <chb@muc.de> wrote:
> 2011/7/25 Chris Mason <chris.mason@oracle.com>:
>> Excerpts from Christian Brunner's message of 2011-07-25 03:54:47 -0400:
>>> Hi,
>>>
>>> we are running a ceph cluster with btrfs as it's base filesystem
>>> (kernel 3.0). At the beginning everything worked very well, but after
>>> a few days (2-3) things are getting very slow.
>>>
>>> When I look at the object store servers I see heavy disk-i/o on the
>>> btrfs filesystems (disk utilization is between 60% and 100%). I also
>>> did some tracing on the Cepp-Object-Store-Daemon, but I'm quite
>>> certain, that the majority of the disk I/O is not caused by ceph or
>>> any other userland process.
>>>
>>> When reboot the system(s) the problems go away for another 2-3 days,
>>> but after that, it starts again. I'm not sure if the problem is
>>> related to the kernel warning I've reported last week. At least there
>>> is no temporal relationship between the warning and the slowdown.
>>>
>>> Any hints on how to trace this would be welcome.
>>
>> The easiest way to trace this is with latencytop.
>>
>> Apply this patch:
>>
>> http://oss.oracle.com/~mason/latencytop.patch
>>
>> And then use latencytop -c for a few minutes while the system is slow.
>> Send the output here and hopefully we'll be able to figure it out.
>
> I've now installed latencytop. Attached are two output files: The
> first is from yesterday and was created aproxematly half an hour after
> the boot. The second on is from today, uptime is 19h. The load on the
> system is already rising. Disk utilization is approximately at 50%.
>
> Thanks for your help.
>
> Christian
>
