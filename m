Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:1689 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935408AbcJ1DsW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 23:48:22 -0400
Date: Fri, 28 Oct 2016 14:48:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hch@infradead.org, jweiner@fb.com
Subject: Re: [PATCH 5/5] fs: don't set *REFERENCED unless we are on the lru
 list
Message-ID: <20161028034800.GF22126@dastard>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-6-git-send-email-jbacik@fb.com>
 <20161025220112.GE14023@dastard>
 <d5f330d4-8969-b90c-9fe9-134b1bf5d57f@fb.com>
 <20161027003015.GL14023@dastard>
 <21169a48-917c-35ec-3624-758937513c6b@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <21169a48-917c-35ec-3624-758937513c6b@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 27, 2016 at 09:13:44AM -0400, Josef Bacik wrote:
> On 10/26/2016 08:30 PM, Dave Chinner wrote:
> >On Wed, Oct 26, 2016 at 11:11:35AM -0400, Josef Bacik wrote:
> >>On 10/25/2016 06:01 PM, Dave Chinner wrote:
> >>>On Tue, Oct 25, 2016 at 02:41:44PM -0400, Josef Bacik wrote:
> >>>>With anything that populates the inode/dentry cache with a lot of one time use
> >>>>inodes we can really put a lot of pressure on the system for things we don't
> >>>>need to keep in cache.  It takes two runs through the LRU to evict these one use
> >>>>entries, and if you have a lot of memory you can end up with 10's of millions of
> >>>>entries in the dcache or icache that have never actually been touched since they
> >>>>were first instantiated, and it will take a lot of CPU and a lot of pressure to
> >>>>evict all of them.
> >>>>
> >>>>So instead do what we do with pagecache, only set the *REFERENCED flags if we
> >>>>are being used after we've been put onto the LRU.  This makes a significant
> >>>>difference in the system's ability to evict these useless cache entries.  With a
> >>>>fs_mark workload that creates 40 million files we get the following results (all
> >>>>in files/sec)
> >>>
> >>>What's the workload, storage, etc?
> >>
> >>Oops sorry I thought I said it.  It's fs_mark creating 20 million
> >>empty files on a single NVME drive.
> >
> >How big is the drive/filesystem (e.g. has impact on XFS allocation
> >concurrency)?  And multiple btrfs subvolumes, too, by the sound of
> >it. How did you set those up?  What about concurrency, directory
> >sizes, etc?  Can you post the fsmark command line as these details
> >do actually matter...
> >
> >Getting the benchmark configuration to reproduce posted results
> >should not require playing 20 questions!
> 
> This is the disk
> 
> Disk /dev/nvme0n1: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
> 
> This is the script
> 
> https://paste.fedoraproject.org/461874/73910147/1

Link no workee. This does, though:

https://paste.fedoraproject.org/461874/73910147

> 
> It's on a 1 socket 8 core cpu with 16gib of ram.

Thanks!

> >Is there an order difference in reclaim as a result of earlier
> >reclaim? Is btrfs_evict_inode() blocking on a sleeping lock in btrfs
> >rather than contending on spinning locks? Is it having to wait for
> >transaction commits or some other metadata IO because reclaim is
> >happening earlier? i.e. The question I'm asking is what, exactly,
> >leads to such a marked performance improvement in steady state
> >behaviour?
> 
> I would have seen this in my traces.  There's tooooons of places to
> improve btrfs's performance and behavior here no doubt.  But simply
> moving from pagecache to a slab shrinker shouldn't have drastically
> changed how we perform in this test.

Not sure what you mean by this. Do you mean that because of the
preceeding patches that change the page cache accounting for btrfs
metadata there is now not enough pressure being placed on the btrfs
inode cache shrinker?

FWIW, this zero length file fsmark workload produces zero page
cache pressure on XFS. If the case is that btrfs is no longer using the pa

> I feel like the shrinkers need
> to be used differently, but I completely destroyed vmscan.c trying
> different approaches and none of them made a difference like this
> patch made.  From what I was seeing in my trace we were simply
> reclaiming less per kswapd scan iteration with the old approach vs.
> the new approach.

Yup, that's what default_seeks is supposed to be used to tune - the
relative pressure that should be placed on the slab compared to
everything else.

> >I want to know because if there's behavioural changes in LRU reclaim
> >order having a significant effect on affecting btrfs, then there is
> >going to be some effects on other filesystems, too. Maybe not in
> >this benchmark, but we can't anticipate potential problems if we
> >don't understand exactly what is going on here.
> 
> So I'll just describe to you what I was seeing and maybe we can work
> out where we think the problem is.
> 
> 1) We go at X speed until we fill up all of the memory with the various caches.
> 2) We lost about 15% when kswapd kicks in and it never recovered.

That's expected behaviour (i.e. that's exactly what I see when XFS
fill memory and reclaim gates new allocations). Memory reclaim does
not come for free.

> Doing tracing I was seeing that we would try to scan very small
> batches of objects, usually less than the batch size, because with
> btrfs not using pagecache for anything and the shrinker scanning
> being based on how much pagecache was scanned our scan totals would
> be very much smaller than the total cache size.  I originally
> thought this was the problem, but short of just forcing us to scan
> the whole cache every time nothing I did made any difference.

So this is from a kernel just running your patch 5 (the referenced
bit changes) and samples were taken for about a minute at steady
state after memory filled (about 20m files into a 16-way 50m file
create with subvols running at ~130k files/s in steady state) using:

# ~/trace-cmd/trace-cmd record -e mm_shrink_slab\*

There were this many shrinker invocations, but all of them came from
kswapd (no direct reclaim at all).

$ grep 0xffff88036a2774c0 t.t |grep shrink_slab_start |wc -l
1923

The amount of reclaim each shrinker invocation did was:

# grep 0xffff88036a2774c0 t.t  |awk -e '/mm_shrink_slab_end/ { print $23 }' |sort -n |uniq -c |sort -nr
    623 1025
    481 0
    172 3075
    145 2050
    131 6150
     82 12300
     54 7175
     40 4100
     40 11275
     34 5125
     32 14350
     30 13325
     19 23575
     18 24600
      7 15375
      4 8200
      3 22550
      3 10250
      2 47150
      2 16400
      1 9225
      1 25625
      1 14349
      1 11274

I don't see any partial batches there, but I also don't see enough
reclaim pressure being put on the inode cache. I'll come back to
this, but first lets look at what how XFS behaves, because it
doesn't create any page cache pressure on these workloads:


$ grep 0xffff880094aea4c0 t.t  |awk -e '/mm_shrink_slab_end/ { print $23 }' |sort -n |uniq -c |sort -nr
   1059 0
      5 1000
      4 7045
      4 1008
      3 7970
      3 7030
      2 996
      2 995
      2 962
      2 9005
      2 8961
      2 8937
      2 8062
      2 8049
.....

Very different look to thework szies. Sorting on the reclaim batch
sizes shows this:

      1 901131
      1 874354
      1 872911
      1 847679
      1 760696
      1 616491
      1 590231
      1 542313
      1 517882
      1 513400
      1 507431
      1 479111
      1 439889
      1 433734
      1 410811
      1 388127
.....

There are massive batches of inodes being reclaimed. Let's have a
look at that one of those traces more closely:

kswapd1-862   [001] 183735.856649: mm_shrink_slab_start:
	super_cache_scan+0x0 0xffff880094aea4c0: nid: 1
	objects to shrink 882936 gfp_flags GFP_KERNEL
	pgs_scanned 32 lru_pgs 6236
	cache items 2416122 delta 24792 total_scan 907728

So here we see only 32 pages were scanned in the page cache, of
a very small 6236 pages - there is no page cache to speak of, and
the 32 pages scanned is the defined minimum for the page cache.

However, the calculated delta is still reasonable at 24792, with the
cache size at 2416122 objects. It's reasonable because the delta is
almost exactly 1% of the cache size and that's a good reclaim batch
size for a single shrinker invocation.

However, total_scan is at 907728, which means there have been lots
of shrinker invocations that have not done work due to GFP_NOFS
context, and so that work has been deferred. kswapd is invoked with
GFP_KERNEL context, so we'd expect it to do most of that work right
now:

kswapd1-862   [009] 183737.582875: mm_shrink_slab_end:
	super_cache_scan+0x0 0xffff880094aea4c0: nid: 1
	unused scan count 882936 new scan count 464 total_scan 464
	last shrinker return val 874354

And it does - it freed 874354 objects from the cache, and the
deferred scan count returned to the shrinker was only 464. I'll also
point out that the reclaim rate here is about 500,000 inodes/s (per
kswapd) so we've got plenty of headroom and scalability here.

This is behaving exactly as we'd expect if there was no page cache
pressure and substantial GFP_NOFS allocations. THe delta calculation
is in the correct ballpark, the reclaim batch size is being
determined by the amount of work we are deferring to kswapd.

Just to show what GFP_NOFS windup from direct reclaim looks like:

fs_mark-30202 [006] 183695.757995: mm_shrink_slab_start:
	super_cache_scan+0x0 0xffff880094aea4c0: nid: 1
	objects to shrink 64064 gfp_flags GFP_NOFS|__GFP_NOWARN|__GFP_COMP|__GFP_NOTRACK
	pgs_scanned 32 lru_pgs 6697
	cache items 2236078 delta 21365 total_scan 85429
fs_mark-30202 [006] 183695.757995: mm_shrink_slab_end:
	super_cache_scan+0x0 0xffff880094aea4c0: nid: 1
	unused scan count 64064 new scan count 85429 total_scan 85429
	last shrinker return val 0

incoming deferred work was 64064 objects, delta added was 21365
(again, 1% of total cache size), zero objects were freed, outgoing
deferred work in now 85429 objects.

So we can see that regardless of the invocation context of the
shrinker, XFS is asking for 1% of the cache to be removed. Knowing
this, let's go back to the btrfs traces and examine that:

kswapd1-862   [013] 185883.279076: mm_shrink_slab_start:
	super_cache_scan+0x0 0xffff8803329404c0: nid: 1
	objects to shrink 1006 gfp_flags GFP_KERNEL
	pgs_scanned 203 lru_pgs 251067
	cache items 1787431 delta 2890 total_scan 3896

Ok, the first thing to note here is that the delta is much smaller
than what we see with XFS. That is also no obvious deferred work,
which we'd expect because there is no direct reclaim records in the
trace for btrfs. It's pretty clear from this that each shrinker
invocation is asking for about 0.15% of the cache to be scanned -
there's much lower pressure being put on the shrinker when compared
to XFS. Hence it will take 5-10x as many invocations of the shrinker
to do the same amount of work.

Occasionally we see the page cache get scanned enough to bring
deltas up to 1% of the cache size:

kswapd1-862   [013] 185883.943647: mm_shrink_slab_start:
	super_cache_scan+0x0 0xffff8803329404c0: nid: 1
	objects to shrink 459 gfp_flags GFP_KERNEL
	pgs_scanned 1585 lru_pgs 249194
	cache items 1784345 delta 22698 total_scan 23157

See the difference here? pgs_scanned is much higher than the
trace from than half a second ago, and now the delta reaches that
~1% of cache size number. This is an outlier, though, but what it
indicates is that the problem is with the amount of page cache
scanning being done during reclaim.

There are two ways to deal with this: fix whatever problem is
causing the page cache to be underscanned, or make the
pgs_scanned:shrinker delta ratio larger. The later can be don via
changing the shrinker seek count or modifying
/proc/sys/vm/vfs_cache_pressure to make the cache seem 10x larger
than it really is....

> Once we'd scanned through the entire LRU at once suddenly we started
> reclaiming almost as many objects as we scanned, as opposed to < 10
> items.  This is because of the whole referenced thing.

That looks like a side effect of not generating enough pressure on
the shrinker.

> So we'd see
> a small perf bump when we did manage to do this, and then it would
> drop again once the lru was full of fresh inodes again.  So we'd get
> this saw-toothy sort of reclaim.

Yup - butin normal conditions this workload should result with a
relatively even mix of referenced and unreferenced inodes on the
LRU, so this behaviour should not happen.

Indeed, I just pulled the referenced patch out of the kernel and
reran the XFS tests, and I see regular "delta 24000, freed 13000"
traces. There are much fewer huge reclaim peaks (i.e. less GFP_NOFS
windup) and no two shrinker invocations freed the exact same number
of objects.

$ grep 0xffff88033a638cc0 t.t  |awk -e '/mm_shrink_slab_end/ { print $23 }' |sort -n |uniq -c |sort -nr -k2
1 381458
1 333756
1 90265
1 88664
1 82371
1 82340
1 81849
1 80772
1 79268

i.e. changing the referenced bit behaviour has made the XFS inode
shrinker too aggressive for this workload, so rebalancing would be
necessary...

At the same time, I changed btrfs to has "seeks = 1". This shows
/substantially/ more sustained and larger amounts of pressure being
put on the btrfs inode shrinker than the referenced patch:

$ grep 0xffff88004ed79cc0: b.t  |awk -e '/mm_shrink_slab_end/ { print $23 }' |sort -n |uniq -c |sort -nr -k2
1 59021
1 56271
1 53743
1 52885
1 47992
1 44442
1 41265
1 40718
1 36038
1 34872
....

.... but it still has a really, really long tail of small reclaim
attempts so it's better but still not perfect....

Unfortunately, because default_seeks is only 2, we're going to have
to change this value  and the constants in do_shrinker_slab() to
give us more ranging to increase reclaim pressure in this manner....

> I did all sorts of tracing to try and figure out what exactly it was
> about the reclaim that made everything so much slower, but with that
> many things going on it was hard to decide what was noise and what
> was actually causing the problem. Without this patch I see kswapd
> stay at higher CPU usage for longer, because it has to keep scanning
> things to satisfy the high watermark and it takes scanning multiple
> million object lists multiple times before it starts to make any
> progress towards reclaim.  This logically makes sense and is not
> ideal behavior.

I would expect the elevated kswapd CPU is due to the fact it is
being called so many more times to do the inode cache reclaim work.
It has to do more page cache scanning because the shrinker is not
removing the memory pressure, and so it's a downward spiral of
inefficiency. let's see what happens when we get the shrinker
pressure to reliably scan 1% of the cache on every invocation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
