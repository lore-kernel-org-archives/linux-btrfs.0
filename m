From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Thu, 14 Aug 2008 17:00:56 -0400
Message-ID: <1218747656.15342.439.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <877ias66v4.fsf@basil.nowhere.org>
	 <1218221293.15342.263.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1218221293.15342.263.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-08-08 at 14:48 -0400, Chris Mason wrote:
> On Thu, 2008-08-07 at 20:02 +0200, Andi Kleen wrote:
> > Chris Mason <chris.mason@oracle.com> writes:
> > >
> > > Metadata is duplicated by default even on single spindle drives, 
> > 
> > Can you please say a bit how much that impacts performance? That sounds 
> > costly.
> 
> Most metadata is allocated in groups of 128k or 256k, and so most of the
> writes are nicely sized.  The mirroring code has areas of the disk
> dedicated to mirror other areas. 

[ ... ]

> So, the mirroring turns a single large write into two large writes.
> Definitely not free, but always a fixed cost.

> With /sys/block/sdb/queue/nr_requests at 8192 to hide my IO ordering
> submission problems:
> 
> Btrfs defaults: 57MB/s
> Btrfs no mirror: 61.51MB/s

I spent a bunch of time hammering on different ways to fix this without
increasing nr_requests, and it was a mixture of needing better tuning in
btrfs and needing to init mapping->writeback_index on inode allocation.

So, today's numbers for creating 30 kernel trees in sequence:

Btrfs defaults                  57.41 MB/s
Btrfs dup no csum               74.59 MB/s 
Btrfs no duplication            76.83 MB/s
Btrfs no dup no csum no inline  76.85 MB/s

Ext4 data=writeback, delalloc   60.50 MB/s

I may be able to get the duplication numbers higher by tuning metadata
writeback.  My current code doesn't push metadata throughput as high in
order to give some spindle time to data writes.

This graph may give you an idea of how the duplication goes to disk:

http://oss.oracle.com/~mason/seekwatcher/btrfs-dup/btrfs-default.png

Compared with the result of mkfs.btrfs -m single (no duplication):

http://oss.oracle.com/~mason/seekwatcher/btrfs-dup/btrfs-single.png

Both on one graph is a little hard to read:

http://oss.oracle.com/~mason/seekwatcher/btrfs-dup/btrfs-dup-compare.png

Here is btrfs with duplication on, but without checksumming.  Even with
inline extents on, the checksums seem to cause most of the metadata
related syncing (they are stored in the btree):

http://oss.oracle.com/~mason/seekwatcher/btrfs-dup/btrfs-dup-nosum.png

It is worth noting that with checksumming on, I go through async
kthreads to do the checksumming and they may be reordering the IO a bit
as they submit things.  So, I'm not 100% sure the extra seeks aren't
coming from my async code.

And Ext4:

http://oss.oracle.com/~mason/seekwatcher/btrfs-dup/ext4-writeback.png

This benchmark has questionable real world value, but since it includes
a number of smallish files it is a good place to look at the cost of
metadata and metadata dup

I'll push the btrfs related changes for this out tonight after some
stress testing.

-chris


