From: Chris Mason <chris.mason@oracle.com>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 20:42:48 -0500
Message-ID: <20100312014247.GB3035@think>
References: <4B97F7CE.4030405@bobich.net>
 <0592c2cb505638c1110eaef97192eb60@localhost>
 <20100311161932.GH6509@think>
 <201003120207.40740.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gordan Bobic <gordan@bobich.net>, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003120207.40740.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 12, 2010 at 02:07:40AM +0100, Hubert Kario wrote:
> > > For example - you have a disk that has had all it's addressable blocks
> > > tainted. A new write comes in - what do you do with it? Worse, a write
> > > comes in spanning two erase blocks as a consequence of the data
> > > re-alignment in the firmware. You have no choice but to wipe them both
> > > and re-write the data. You'd be better off not doing the magic and
> > > assuming that the FS is sensibly aligned.
> > 
> > Ok, how exactly would the FS help here?  We have a device with a 256kb
> > erasure size, and userland does a 4k write followed by an fsync.
> 
> I assume here that the FS knows about erasure size and does implement TRIM.
> 
> > If the FS were to be smart and know about the 256kb requirement, it
> > would do a read/modify/write cycle somewhere and then write the 4KB.
> 
> If all the free blocks have been TRIMmed, FS should pick a completely free 
> erasure size block and write those 4KiB of data.
> 
> Correct implementation of wear leveling in the drive should notice that the 
> write is entirely inside a free block and make just a write cycle adding zeros 
> to the end of supplied data.
> 
> > The underlying implementation is the same in the device.  It picks a
> > destination, reads it then writes it back.  You could argue (and many
> > people do) that this operation is risky and has a good chance of
> > destroying old data.  Perhaps we're best off if the FS does the rmw
> > cycle instead into an entirely safe location.
> 
> And IMO that's the idea behind TRIM -- not to force the device do do rmw 
> cycles, only write cycle or erase cycle, provided there's free space and the 
> free space  doesn't have considerably more write cycles than the already 
> allocated data.
> 
> > 
> > It's a great place for research and people are definitely looking at it.
> > 
> > But with all of that said, it has nothing to do with alignment or trim.
> > Modern ssds are a raid device with a large stripe size, and someone
> > somewhere is going to do a read/modify/write to service any small write.
> > You can force this up to the FS or the application, it'll happen
> > somewhere.
> 
> Yes, and if the parition is full rmw will happen in the drive. But if the 
> partition is far from full, free space is TRIMmed then than the r/m/w cycle 
> will happen inside btrfs and the SSD won't have to do its magic -- making the 
> process faster.

The filesystem cannot do read/modify/write faster or better than the
drive.  The drive is pushing data around internally and the FS has to
pull it in and out of the sata bus.  The drive is much faster.

The FS can be safer than the drive because it is able to do more
consistency checks on the data as it reads.  But this also has a cost
because the crcs for the blocks might not be adjacent to the block.

If the FS is the FTL, we don't need trim because the FS already knows
which blocks are in use.  So, there isn't as much complexity in finding
the free erasure block.  The FS FTL does win there.

-chris

