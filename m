Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33702 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933084AbcJ0OBm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 10:01:42 -0400
Subject: Re: [PATCH 5/5] fs: don't set *REFERENCED unless we are on the lru
 list
To: Dave Chinner <david@fromorbit.com>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-6-git-send-email-jbacik@fb.com>
 <20161025220112.GE14023@dastard>
 <d5f330d4-8969-b90c-9fe9-134b1bf5d57f@fb.com>
 <20161027003015.GL14023@dastard>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>, <jack@suse.cz>,
        <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <hch@infradead.org>, <jweiner@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <21169a48-917c-35ec-3624-758937513c6b@fb.com>
Date: Thu, 27 Oct 2016 09:13:44 -0400
MIME-Version: 1.0
In-Reply-To: <20161027003015.GL14023@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2016 08:30 PM, Dave Chinner wrote:
> On Wed, Oct 26, 2016 at 11:11:35AM -0400, Josef Bacik wrote:
>> On 10/25/2016 06:01 PM, Dave Chinner wrote:
>>> On Tue, Oct 25, 2016 at 02:41:44PM -0400, Josef Bacik wrote:
>>>> With anything that populates the inode/dentry cache with a lot of one time use
>>>> inodes we can really put a lot of pressure on the system for things we don't
>>>> need to keep in cache.  It takes two runs through the LRU to evict these one use
>>>> entries, and if you have a lot of memory you can end up with 10's of millions of
>>>> entries in the dcache or icache that have never actually been touched since they
>>>> were first instantiated, and it will take a lot of CPU and a lot of pressure to
>>>> evict all of them.
>>>>
>>>> So instead do what we do with pagecache, only set the *REFERENCED flags if we
>>>> are being used after we've been put onto the LRU.  This makes a significant
>>>> difference in the system's ability to evict these useless cache entries.  With a
>>>> fs_mark workload that creates 40 million files we get the following results (all
>>>> in files/sec)
>>>
>>> What's the workload, storage, etc?
>>
>> Oops sorry I thought I said it.  It's fs_mark creating 20 million
>> empty files on a single NVME drive.
>
> How big is the drive/filesystem (e.g. has impact on XFS allocation
> concurrency)?  And multiple btrfs subvolumes, too, by the sound of
> it. How did you set those up?  What about concurrency, directory
> sizes, etc?  Can you post the fsmark command line as these details
> do actually matter...
>
> Getting the benchmark configuration to reproduce posted results
> should not require playing 20 questions!

This is the disk

Disk /dev/nvme0n1: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors

This is the script

https://paste.fedoraproject.org/461874/73910147/1

It's on a 1 socket 8 core cpu with 16gib of ram.

>
>>>> The reason Btrfs has a much larger improvement is because it holds a lot more
>>>> things in memory so benefits more from faster slab reclaim, but across the board
>>>> is an improvement for each of the file systems.
>>>
>>> Less than 1% for XFS and ~1.5% for ext4 is well within the
>>> run-to-run variation of fsmark. It looks like it might be slightly
>>> faster, but it's not a cut-and-dried win for anything other than
>>> btrfs.
>>>
>>
>> Sure the win in this benchmark is clearly benefiting btrfs the most,
>> but I think the overall approach is sound and likely to help
>> everybody in theory.
>
> Yup, but without an explanation of why it makes such a big change to
> btrfs, we can't really say what effect it's really going to have.
> Why does cycling the inode a second time through the LRU make any
> difference? Once we're in steady state on this workload, one or two
> cycles through the LRU should make no difference at all to
> performance because all the inodes are instantiated in identical
> states (including the referenced bit) and so scanning treats every
> inode identically. i.e. the reclaim rate (i.e. how often
> evict_inode() is called) should be exactly the same and the only
> difference is the length of time between the inode being put on the
> LRU and when it is evicted.
>
> Is there an order difference in reclaim as a result of earlier
> reclaim? Is btrfs_evict_inode() blocking on a sleeping lock in btrfs
> rather than contending on spinning locks? Is it having to wait for
> transaction commits or some other metadata IO because reclaim is
> happening earlier? i.e. The question I'm asking is what, exactly,
> leads to such a marked performance improvement in steady state
> behaviour?

I would have seen this in my traces.  There's tooooons of places to improve 
btrfs's performance and behavior here no doubt.  But simply moving from 
pagecache to a slab shrinker shouldn't have drastically changed how we perform 
in this test.  I feel like the shrinkers need to be used differently, but I 
completely destroyed vmscan.c trying different approaches and none of them made 
a difference like this patch made.  From what I was seeing in my trace we were 
simply reclaiming less per kswapd scan iteration with the old approach vs. the 
new approach.

>
> I want to know because if there's behavioural changes in LRU reclaim
> order having a significant effect on affecting btrfs, then there is
> going to be some effects on other filesystems, too. Maybe not in
> this benchmark, but we can't anticipate potential problems if we
> don't understand exactly what is going on here.

So I'll just describe to you what I was seeing and maybe we can work out where 
we think the problem is.

1) We go at X speed until we fill up all of the memory with the various caches.
2) We lost about 15% when kswapd kicks in and it never recovered.

Doing tracing I was seeing that we would try to scan very small batches of 
objects, usually less than the batch size, because with btrfs not using 
pagecache for anything and the shrinker scanning being based on how much 
pagecache was scanned our scan totals would be very much smaller than the total 
cache size.  I originally thought this was the problem, but short of just 
forcing us to scan the whole cache every time nothing I did made any difference.

Once we'd scanned through the entire LRU at once suddenly we started reclaiming 
almost as many objects as we scanned, as opposed to < 10 items.  This is because 
of the whole referenced thing.  So we'd see a small perf bump when we did manage 
to do this, and then it would drop again once the lru was full of fresh inodes 
again.  So we'd get this saw-toothy sort of reclaim.

This is when I realized the whole REFERENCED thing was probably screwing us, so 
I went to look at what pagecache did to eliminate this problem.  They do two 
things, first start all pages on the inactive list, and second balance between 
scanning the active list vs inactive list based on the size of either list.  I 
rigged up something to do an active/inactive list inside of list_lru which again 
did basically nothing.  So I changed how the REFERENCED was marked to match how 
pagecache did things and viola, my performance was back.

I did all sorts of tracing to try and figure out what exactly it was about the 
reclaim that made everything so much slower, but with that many things going on 
it was hard to decide what was noise and what was actually causing the problem. 
Without this patch I see kswapd stay at higher CPU usage for longer, because it 
has to keep scanning things to satisfy the high watermark and it takes scanning 
multiple million object lists multiple times before it starts to make any 
progress towards reclaim.  This logically makes sense and is not ideal behavior.

>
>> Inside FB we definitely have had problems
>> where the memory pressure induced by some idi^H^H^Hprocess goes
>> along and runs find / which causes us to evict real things that are
>> being used rather than these one use inodes.
>
> That's one of the problems the IO throttling in the XFS shrinker
> tends to avoid. i.e. This is one of the specific cases we expect to see
> on all production systems - backup applications are the common cause
> of regular full filesystem traversals.
>
> FWIW, there's an element of deja vu in this thread: that XFS inode
> cache shrinker IO throttling is exactly what Chris proposed we gut
> last week to solve some other FB memory reclaim problem that had no
> explanation of the root cause.
>
> (https://urldefense.proofpoint.com/v2/url?u=http-3A__www.spinics.net_lists_linux-2Dxfs_msg01541.html&d=DQIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=REEqbp9jT-ifN0oN83tK5X3BxEL76jmuULRORyO8Qeg&s=vlsX-YRw_2HCnXFThpOjyumOHu4JFDcSqssSQG1Rt40&e= )
>
>> This sort of behavior
>> could possibly be mitigated by this patch, but I haven't sat down to
>> figure out a reliable way to mirror this workload to test that
>> theory.  Thanks
>
> I use fsmark to create filesystems with tens of millions of small
> files, then do things like run concurrent greps repeatedly over a
> small portion of the directory structure (e.g. 1M cached inodes
> and 4GB worth of cached data) and then run concurrent find
> traversals across the entire filesystem to simulate this sort
> use-once vs working set reclaim...
>

Yeah that sounds reasonable, like I said I just haven't tried to test it as my 
numbers got bigger and I was happy with that.  I'll rig this up and see how it 
performs with my patch to see if there's a significant difference with FS's 
other than btrfs.  Thanks,

Josef

