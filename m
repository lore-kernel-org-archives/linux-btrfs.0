From: Chris Mason <chris.mason@oracle.com>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 11:29:07 -0500
Message-ID: <20100311162907.GI6509@think>
References: <4B97F7CE.4030405@bobich.net>
 <20100311142130.GD6509@think>
 <fdd915134f8941e4f2087fc2f4cf4e79@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <fdd915134f8941e4f2087fc2f4cf4e79@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 11, 2010 at 04:18:48PM +0000, Gordan Bobic wrote:
> On Thu, 11 Mar 2010 09:21:30 -0500, Chris Mason <chris.mason@oracle.com>
> wrote:
> > On Wed, Mar 10, 2010 at 07:49:34PM +0000, Gordan Bobic wrote:
> >> I'm looking to try BTRFS on a SSD, and I would like to know what SSD
> >> optimizations it applies. Is there a comprehensive list of what ssd
> >> mount option does? How are the blocks and metadata arranged? Are
> >> there options available comparable to ext2/ext3 to help reduce wear
> >> and improve performance?
> >> 
> >> Specifically, on ext2 (journal means more writes, so I don't use
> >> ext3 on SSDs, since fsck typically only takes a few seconds when
> >> access time is < 100us), I usually apply the
> >> -b 4096 -E stripe-width = (erase_block/4096)
> >> parameters to mkfs in order to reduce the multiple erase cycles on
> >> the same underlying block.
> >> 
> >> Are there similar optimizations available in BTRFS?
> > 
> > All devices (raid, ssd, single spindle) tend to benefit from big chunks
> > of writes going down close together on disk.  This is true for different
> > reasons on each one, but it is still the easiest way to optimize writes.
> > COW filesystems like btrfs are very well suited to send down lots of big
> > writes because we're always reallocating things.
> 
> Doesn't this mean _more_ writes? If that's the case, then that would make
> btrfs a _bad_ choice for flash based media with limite write cycles.

It just means that when we do write, we don't overwrite the existing
data in the file.  We allocate a new block instead and write there
(freeing the old one)
.
This gives us a lot of control over grouping writes together, instead of
being restricted to the layout from when the file was first created.

It also fragments the files much more, but this isn't an issue on ssd.

> 
> > For traditional storage, we also need to keep blocks from one file (or
> > files in a directory) close together to reduce seeks during reads.  SSDs
> > have no such restrictions, and so the mount -o ssd related options in
> > btrfs focus on tossing out tradeoffs that slow down writes in hopes of
> > reading faster later.
> > 
> > Someone already mentioned the mount -o ssd and ssd_spread options.
> > Mount -o ssd is targeted at faster SSD that is good at wear leveling and
> > generally just benefits from having a bunch of data sent down close
> > together.  In mount -o ssd, you might find a write pattern like this:
> > 
> > block N, N+2, N+3, N+4, N+6, N+7, N+16, N+17, N+18, N+19, N+20 ...
> > 
> > It's a largely contiguous chunk of writes, but there may be gaps.  Good
> > ssds don't really care about the gaps, and they benefit more from the
> > fact that we're preferring to reuse blocks that had once been written
> > than to go off and find completely contiguous areas of the disk to
> > write (which are more likely to have never been written at all).
> > 
> > mount -o ssd_spread is much more strict.  You'll get N,N+2,N+3,N+4,N+5
> > etc because crummy ssds really do care about the gaps.
> > 
> > Now, btrfs could go off and probe for the erasure size and work very
> > hard to align things to it.  As someone said, alignment of the partition
> > table is very important here as well.  But for modern ssd this generally
> > matters much less than just doing big ios and letting the little log
> > structured squirrel inside the device figure things out.
> 
> Thanks, that's quite helpful. Can you provide any insight into alignment
> of FS structures in such a way that they do not straddle erase block
> boundaries?

We align on 4k (but partition alignment can defeat this).  We don't
attempt to understand or guess at erasure blocks.  Unless the filesystem
completely takes over the FTL duties, I don't think it makes sense to do
more than send large writes whenever we can.

The raid 5/6 patches will add more knobs for strict alignment, but I'd
be very surprised if they made a big difference on modern ssd.

> 
> > For trim, we do have mount -o discard.  It does introduce a run time
> > performance hit (this varies wildly from device to device) and we're
> > tuning things as discard capable devices become more common.  If anyone
> > is looking for a project it would be nice to have an ioctl that triggers
> > free space discards in bulk.
> 
> Are you saying that -o discard implements trim support?

Yes, it sends trim/discards down to devices that support it.

-chris

