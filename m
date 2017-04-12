Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36049 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753768AbdDLLS4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 07:18:56 -0400
Received: by mail-io0-f193.google.com with SMTP id x86so5887040ioe.3
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Apr 2017 04:18:56 -0700 (PDT)
Subject: Re: BTRFS as a GlusterFS storage back-end, and what I've learned from
 using it as such.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        BTRFS ML <linux-btrfs@vger.kernel.org>
References: <7e63733a-6ab5-d92d-f9b2-f129ebd81f36@gmail.com>
 <e31fb17b-3331-b168-e96a-72398ea8af62@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <45e228aa-c650-98a6-f23a-095eb690a181@gmail.com>
Date: Wed, 12 Apr 2017 07:18:44 -0400
MIME-Version: 1.0
In-Reply-To: <e31fb17b-3331-b168-e96a-72398ea8af62@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-12 01:49, Qu Wenruo wrote:
>
>
> At 04/11/2017 11:40 PM, Austin S. Hemmelgarn wrote:
>> About a year ago now, I decided to set up a small storage cluster to
>> store backups (and partially replace Dropbox for my usage, but that's
>> a separate story).  I ended up using GlusterFS as the clustering
>> software itself, and BTRFS as the back-end storage.
>>
>> GlusterFS itself is actually a pretty easy workload as far as cluster
>> software goes.  It does some processing prior to actually storing the
>> data (a significant amount in fact), but the actual on-device storage
>> on any given node is pretty simple.  You have the full directory
>> structure for the whole volume, and whatever files happen to be on
>> that node are located within that tree exactly like they are in the
>> GlusterFS volume. Beyond the basic data, gluster only stores 2-4
>> xattrs per-file (which are used to track synchronization, and also for
>> it's internal data scrubbing), and a directory called .glusterfs in
>> the top of the back-end storage location for the volume which contains
>> the data required to figure out which node a file is on.  Overall, the
>> access patterns mostly mirror whatever is using the Gluster volume, or
>> are reduced to slow streaming writes (when writing files and the
>> back-end nodes are computationally limited instead of I/O limited),
>> with the addition of some serious metadata operations in the
>> .glusterfs directory (lots of stat calls there, together with large
>> numbers of small files).
>
> Any real world experience is welcomed to share.
>
>>
>> As far as overall performance, BTRFS is actually on par for this usage
>> with both ext4 and XFS (at least, on my hardware it is), and I
>> actually see more SSD friendly access patterns when using BTRFS in
>> this case than any other FS I tried.
>
> We also find that, for pure buffered read/write, btrfs is no worse than
> traditional fs.
>
> In our PostgreSQL test, btrfs can even get a little better performance
> than ext4/xfs when handling DB files.
>
> But if using btrfs for PostgreSQL Write Ahead Log (WAL), then it's
> completely another thing.
> Btrfs falls far behind ext4/xfs on HDD, only half of the TPC performance
> for low concurrency load.
>
> Due to btrfs CoW, btrfs causes extra IO for fsync.
> For example, if only to fsync 4K data, btrfs can cause 64K metadata
> write for default mkfs options.
> (One tree block for log root tree, one tree block for log tree, multiple
> by 2 for default DUP profile)
>
>>
>> After some serious experimentation with various configurations for
>> this during the past few months, I've noticed a handful of other things:
>>
>> 1. The 'ssd' mount option does not actually improve performance on
>> these SSD's.  To a certain extent, this actually surprised me at
>> first, but having seen Hans' e-mail and what he found about this
>> option, it actually makes sense, since erase-blocks on these devices
>> are 4MB, not 2MB, and the drives have a very good FTL (so they will
>> aggregate all the little writes properly).
>>
>> Given this, I'm beginning to wonder if it actually makes sense to not
>> automatically enable this on mount when dealing with certain types of
>> storage (for example, most SATA and SAS SSD's have reasonably good
>> FTL's, so I would expect them to have similar behavior).
>> Extrapolating further, it might instead make sense to just never
>> automatically enable this, and expose the value this option is
>> manipulating as a mount option as there are other circumstances where
>> setting specific values could improve performance (for example, if
>> you're on hardware RAID6, setting this to the stripe size would
>> probably improve performance on many cheaper controllers).
>>
>> 2. Up to a certain point, running a single larger BTRFS volume with
>> multiple sub-volumes is more computationally efficient than running
>> multiple smaller BTRFS volumes.  More specifically, there is lower
>> load on the system and lower CPU utilization by BTRFS itself without
>> much noticeable difference in performance (in my tests it was about
>> 0.5-1% performance difference, YMMV).  To a certain extent this makes
>> some sense, but the turnover point was actually a lot higher than I
>> expected (with this workload, the turnover point was around half a
>> terabyte).
>
> This seems to be related to tree locking overhead.
My thought too, although I find it interesting that the benefit starts 
to disappear as the FS gets bigger beyond a certain point (on my system 
it was about half a terabyte, but I would expect it to be different on 
systems with different numbers of CPU cores (differing levels of lock 
contention) or different workloads (probably inversely proportionate to 
the amount of metadata work the workload produces).
>
> The most obvious solution is just as you stated, use many small
> subvolumes other than one large subvolume.
>
> Another less obvious solution is to reduce tree block size at mkfs time.
>
> This Btrfs is not that good at handling metadata workload, limited by
> both the overhead of mandatory metadata CoW and current tree lock
> algorithm.
>
>>
>> I believe this to be a side-effect of how we use per-filesystem
>> worker-pools.  In essence, we can schedule parallel access better when
>> it's all through the same worker pool than we can when using multiple
>> worker pools.  Having realized this, I think it might be interesting
>> to see if using a worker-pool per physical device (or at least what
>> the system sees as a physical device) might make more sense in terms
>> of performance than our current method of using a pool per-filesystem.
>>
>> 3. On these SSD's, running a single partition in dup mode is actually
>> marginally more efficient than running 2 partitions in raid1 mode.  I
>> was actually somewhat surprised by this, and I haven't been able to
>> find a clear explanation as to why (I suspect caching may have
>> something to do with it, but I'm not 100% certain about that),  but
>> some limited testing with other SSD's seems to indicate that it's the
>> case for most SSD's, with the difference being smaller on smaller and
>> faster devices. On a traditional hard disk, it's significantly more
>> efficient, but that's generally to be expected.
>>
>> 4. Depending on other factors, compression can actually slow you down
>> pretty significantly.  In the particular case I saw this happen (all
>> cores completely utilized by userspace software), LZO compression
>> actually caused around 5-10% performance degradation compared to no
>> compression.  This is somewhat obvious once it's explained, but it's
>> not exactly intuitive  and as such it's probably worth documenting in
>> the man pages that compression won't always make things better.  I may
>> send a patch to add this at some point in the near future.
>
> This seems interesting.
> Maybe it's CPU limiting the performance?
In this case, I'm pretty certain that that's the cause.  I've only ever 
seen this happen though when the CPU was under either full or more than 
full load (so pretty much full utilization of all the cores), and it 
gets worse as the CPU load increases.
