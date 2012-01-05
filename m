From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [3.2-rc7] slowdown, warning + oops creating lots of files
Date: Thu, 05 Jan 2012 14:11:31 -0500
Message-ID: <4F05F5E3.70600@cn.fujitsu.com>
References: <20120104214445.GE17026@dastard> <20120104221105.GF17026@dastard> <4F04D178.2070006@csamuel.org> <20120104230122.GA24466@dastard> <4F050996.1060206@cn.fujitsu.com> <20120105022630.GD24466@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120105022630.GD24466@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/04/2012 09:26 PM, Dave Chinner wrote:
> On Wed, Jan 04, 2012 at 09:23:18PM -0500, Liu Bo wrote:
>> On 01/04/2012 06:01 PM, Dave Chinner wrote:
>>> On Thu, Jan 05, 2012 at 09:23:52AM +1100, Chris Samuel wrote:
>>>> On 05/01/12 09:11, Dave Chinner wrote:
>>>>
>>>>> Looks to be reproducable.
>>>> Does this happen with rc6 ?
>>> I haven't tried. All I'm doing is running some benchmarks to get
>>> numbers for a talk I'm giving about improvements in XFS metadata
>>> scalability, so I wanted to update my last set of numbers from
>>> 2.6.39.
>>>
>>> As it was, these benchmarks also failed on btrfs with oopsen and
>>> corruptions back in 2.6.39 time frame.  e.g. same VM, same
>>> test, different crashes, similar slowdowns as reported here:
>>> http://comments.gmane.org/gmane.comp.file-systems.btrfs/11062
>>>
>>> Given that there is now a history of this simple test uncovering
>>> problems, perhaps this is a test that should be run more regularly
>>> by btrfs developers?
>>>
>>>> If not then it might be easy to track down as there are only
>>>> 2 modifications between rc6 and rc7..
>>> They don't look like they'd be responsible for fixing an extent tree
>>> corruption, and I don't really have the time to do an open-ended
>>> bisect to find where the problem fix arose.
>>>
>>> As it is, 3rd attempt failed at 22m inodes, without the warning this
>>> time:
> 
> .....
> 
>>> It's hard to tell exactly what path gets to that BUG_ON(), so much
>>> code is inlined by the compiler into run_clustered_refs() that I
>>> can't tell exactly how it got to the BUG_ON() triggered in
>>> alloc_reserved_tree_block().
>>>
>> This seems to be an oops led by ENOSPC.
> 
> At the time of the oops, this is the space used on the filesystem:
> 
> $ df -h /mnt/scratch
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/vdc         17T   31G   17T   1% /mnt/scratch
> 
> It's less than 0.2% full, so I think ENOSPC can be ruled out here.
> 

This bug has done something with our block reservation allocator, not the real disk space.

Can you try the below one and see what happens?

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b1c8732..5a7f918 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3978,8 +3978,8 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 		    csum_size * 2;
 	num_bytes += div64_u64(data_used + meta_used, 50);
 
-	if (num_bytes * 3 > meta_used)
-		num_bytes = div64_u64(meta_used, 3);
+	if (num_bytes * 2 > meta_used)
+		num_bytes = div64_u64(meta_used, 2);
 
 	return ALIGN(num_bytes, fs_info->extent_root->leafsize << 10);
 }

> I have noticed one thing, however, in that the there are significant
> numbers of reads coming from disk when the slowdowns and oops occur.
> When everything runs fast, there are virtually no reads occurring at
> all.  It looks to me that maybe the working set of metadata is being
> kicked out of memory, only to be read back in again short while
> later. Maybe that is a contributing factor.
> 
> BTW, there is a lot of CPU time being spent on the tree locks. perf
> shows this as the top 2 CPU consumers:
> 
> -   9.49%  [kernel]  [k] __write_lock_failed
>    - __write_lock_failed
>       - 99.80% _raw_write_lock
>          - 79.35% btrfs_try_tree_write_lock
>               99.99% btrfs_search_slot
>          - 20.63% btrfs_tree_lock
>               89.19% btrfs_search_slot
>               10.54% btrfs_lock_root_node
>                  btrfs_search_slot
> -   9.25%  [kernel]  [k] _raw_spin_unlock_irqrestore
>    - _raw_spin_unlock_irqrestore
>       - 55.87% __wake_up
>          + 93.89% btrfs_clear_lock_blocking_rw
>          + 3.46% btrfs_tree_read_unlock_blocking
>          + 2.35% btrfs_tree_unlock
> 

hmm, the new extent_buffer lock scheme written by Chris is aimed to avoid such cases,
maybe he can provide some advices.

thanks,
liubo

> Cheers,
> 
> Dave.

