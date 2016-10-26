Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48916 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933805AbcJZUSJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 16:18:09 -0400
Subject: Re: [PATCH 5/5] fs: don't set *REFERENCED unless we are on the lru
 list
To: Dave Chinner <david@fromorbit.com>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-6-git-send-email-jbacik@fb.com>
 <20161025220112.GE14023@dastard> <20161025233604.GF14023@dastard>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>, <jack@suse.cz>,
        <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <hch@infradead.org>, <jweiner@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <20683c6a-5419-3a66-8574-fcf19f2347f9@fb.com>
Date: Wed, 26 Oct 2016 16:03:54 -0400
MIME-Version: 1.0
In-Reply-To: <20161025233604.GF14023@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/25/2016 07:36 PM, Dave Chinner wrote:
> On Wed, Oct 26, 2016 at 09:01:13AM +1100, Dave Chinner wrote:
>> On Tue, Oct 25, 2016 at 02:41:44PM -0400, Josef Bacik wrote:
>>> With anything that populates the inode/dentry cache with a lot of one time use
>>> inodes we can really put a lot of pressure on the system for things we don't
>>> need to keep in cache.  It takes two runs through the LRU to evict these one use
>>> entries, and if you have a lot of memory you can end up with 10's of millions of
>>> entries in the dcache or icache that have never actually been touched since they
>>> were first instantiated, and it will take a lot of CPU and a lot of pressure to
>>> evict all of them.
>>>
>>> So instead do what we do with pagecache, only set the *REFERENCED flags if we
>>> are being used after we've been put onto the LRU.  This makes a significant
>>> difference in the system's ability to evict these useless cache entries.  With a
>>> fs_mark workload that creates 40 million files we get the following results (all
>>> in files/sec)
>>
>> What's the workload, storage, etc?
>>
>>> Btrfs			Patched		Unpatched
>>> Average Files/sec:	72209.3		63254.2
>>> p50 Files/sec:	70850		57560
>>> p90 Files/sec:	68757		53085
>>> p99 Files/sec:	68757		53085
>>
>> So how much of this is from changing the dentry referenced
>> behaviour, and how much from the inode? Can you separate out the two
>> changes so we know which one is actually affecting reclaim
>> performance?

(Ok figured out the problem, apparently outlook thinks you are spam and has been 
filtering all your emails into its junk folder without giving them to me.  I've 
fixed this so now we should be able to get somewhere)

>
> FWIW, I just went to run my usual zero-length file creation fsmark
> test (16-way create, large sparse FS image on SSDs). XFS (with debug
> enabled) takes 4m10s to run at an average of ~230k files/s, with a
> std deviation of +/-1.7k files/s.
>
> Unfortunately, btrfs turns that into more heat than it ever has done
> before. It's only managing 35k files/s and the profile looks like
> this:
>
>   58.79%  [kernel]  [k] __pv_queued_spin_lock_slowpath
>    5.61%  [kernel]  [k] queued_write_lock_slowpath
>    1.65%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
>    1.38%  [kernel]  [k] reschedule_interrupt
>    1.08%  [kernel]  [k] _raw_spin_lock
>    0.92%  [kernel]  [k] __radix_tree_lookup
>    0.86%  [kernel]  [k] _raw_spin_lock_irqsave
>    0.83%  [kernel]  [k] btrfs_set_lock_blocking_rw
>
> I killed it because this would take too long to run.
>
> I reduced the concurrency down to 4-way, spinlock contention went
> down to about 40% of the CPU time.  I reduced the concurrency down
> to 2 and saw about 16% of CPU time being spent in lock contention.
>
> Throughput results:
> 				btrfs throughput
> 			2-way			4-way
> unpatched	46938.1+/-2.8e+03	40273.4+/-3.1e+03
> patched		45697.2+/-2.4e+03	49287.1+/-3e+03
>
>
> So, 2-way has not improved. If changing referenced behaviour was an
> obvious win for btrfs, we'd expect to see that here as well.
> however, because 4-way improved by 20%, I think all we're seeing is
> a slight change in lock contention levels inside btrfs. Indeed,
> looking at the profiles I see that lock contention time was reduced
> to around 32% of the total CPU used (down by about 20%):
>
>   20.79%  [kernel]  [k] __pv_queued_spin_lock_slowpath
>    3.85%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
>    3.68%  [kernel]  [k] _raw_spin_lock
>    3.40%  [kernel]  [k] queued_write_lock_slowpath
>    .....
>
> IOWs, the performance increase comes from the fact that changing
> inode cache eviction patterns causes slightly less lock contention
> in btrfs inode reclaim. IOWs, the problem that needs fixing is the
> btrfs lock contention, not the VFS cache LRU algorithms.
>
> Root cause analysis needs to be done properly before behavioural
> changes like this are proposed, people!
>

We are doing different things.  Yes when you do it all into the same subvol the 
lock contention is obviously much worse and the bottleneck, but that's not what 
I'm doing, I'm creating a subvol for each thread to reduce the lock contention 
on the root nodes.  If you retest by doing that then you will see the 
differences I was seeing.  Are you suggesting that I just made these numbers up? 
  Instead of assuming I'm an idiot and don't know how to root cause issues 
please instead ask what is different from your run versus my run.  Thanks,

Josef
