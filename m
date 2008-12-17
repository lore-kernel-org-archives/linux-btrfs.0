From: Andreas Dilger <adilger@sun.com>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Wed, 17 Dec 2008 14:24:09 -0700
Message-ID: <20081217212409.GB5000@webber.adilger.int>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
 <1228962896.21376.11.camel@think.oraclecorp.com>
 <20081211141436.030c2d65.sfr@canb.auug.org.au>
 <20081210200604.8e190b0d.akpm@linux-foundation.org>
 <1229006596.22236.46.camel@think.oraclecorp.com>
 <20081215210323.GB5000@webber.adilger.int>
 <20081217132343.GA14695@infradead.org>
 <20081217115325.3312858a.akpm@linux-foundation.org>
 <1229547485.27170.77.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>, sfr@canb.auug.org.au,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <1229547485.27170.77.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Dec 17, 2008  15:58 -0500, Chris Mason wrote:
> On Wed, 2008-12-17 at 11:53 -0800, Andrew Morton wrote:
> > One thing I've never seen comprehensively addressed is: why do this in
> > the filesystem at all?  Why not let MD take care of all this and
> > present a single block device to the fs layer?
> > 
> > Lots of filesystems are violating this, and I'm sure the reasons for
> > this are good, but this document seems like a suitable place in which to
> > briefly decribe those reasons.
> 
> I'd almost rather see this doc stick to the device topology interface in
> hopes of describing something that RAID and MD can use too.  But just to
> toss some information into the pool:

Add in here (most important reason, IMHO) that the filesystem wants to make
sure that different copies of redundant metadata are stored on different
physical devices.  It seems pointless to have 4 copies of important data if
a single disk failure makes them all inaccessible.

At the same time, not all data/metadata is of the same importance, so
it makes sense to store e.g. 4 full copies of important metadata like
the allocation bitmaps and the tree root block, but only RAID-5 for
file data.  Even if MD was used to implement the RAID-1 and RAID-5 layer
in this case there would need to be multiple MD devices involved.

> * When moving data around (raid rebuild, restripe, pvmove etc), we want
> to make sure the data read off the disk is correct before writing it to
> the new location (checksum verification).
> 
> * When moving data around, we don't want to move data that isn't
> actually used by the filesystem.  This could be solved via new APIs, but
> keeping it crash safe would be very tricky.
> 
> * When checksum verification fails on read, the FS should be able to ask
> the raid implementation for another copy.  This could be solved via new
> APIs.
> 
> * Different parts of the filesystem might want different underlying raid
> parameters.  The easiest example is metadata vs data, where a 4k
> stripesize for data might be a bad idea and a 64k stripesize for
> metadata would result in many more rwm cycles.

Not just different underlying RAID parameters, but completely separate
physical storage characteristics.  Having e.g. metadata stored on RAID-1
SSD flash (excellent for small random IO) while the data for large files
is stored on SATA RAID-5 would maximize performance while minimizing cost.

If there is a single virtual block device the filesystem can't make such
allocation decisions unless the virtual block device exposes grotty
details like "first 1MB of 128MB is really SSD" or "first 64GB is SSD,
rest is SATA" to the filesystem somehow, at which point you are just
shoehorning multiple devices into a bad interface (linear array of block
numbers) that has to be worked around.

> * Sharing the filesystem transaction layer.  LVM and MD have to pretend
> they are a single consistent array of bytes all the time, for each and
> every write they return as complete to the FS.
> 
> By pushing the multiple device support up into the filesystem, I can
> share the filesystem's transaction layer.  Work can be done in larger
> atomic units, and the filesystem will stay consistent because it is all
> coordinated.

This is even true with filesystems other than btrfs.  As it stands today
the MD RAID-1 code implements its own transaction mechanism for the
recovery bitmaps, and it would have been more efficient to hook this into
the JBD transaction code to avoid 2 layers of flush-then-wait_for_completion.


I can't speak for btrfs, but I don't think multiple device access from
the filesystem is a "layering violation" as some people comment.  It is
just a different type of layering.  With ZFS there is a distinct layer
that is handling the allocation, redundancy, and transactions (SPA, DMU)
that is exporting an object interface, and the filesystem (ZPL, or future
versions of Lustre) is built on top of that object interface.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

