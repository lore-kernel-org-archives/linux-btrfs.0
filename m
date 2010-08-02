From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Are enormous extents harmful?
Date: Mon, 2 Aug 2010 11:12:51 -0400
Message-ID: <20100802151251.GN16630@think>
References: <4C557681.90905@kochanski.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Greg Kochanski <gpk@kochanski.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C557681.90905@kochanski.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 01, 2010 at 02:28:33PM +0100, Greg Kochanski wrote:
> I created a btrfs file system with a single 420 megabyte file
> in it.     And, when I look at the file system with btrfs-debug,
> I see gigantic extents, as large as 99 megabytes:
> 
> > $ sudo btrfs-debug-tree /dev/sdb | grep extent
> > ...

btrfs-debug-tree is a great way to look at and learn more about the
btrfs disk layout.

> >         dev extent chunk_tree 3
> >         dev extent chunk_tree 3
> >         extent data disk byte 80084992 nr 99958784
> >         extent data offset 0 nr 99958784 ram 99958784
> >         extent compression 0
> >         extent data disk byte 181534720 nr 74969088
> >         extent data offset 0 nr 74969088 ram 74969088
> > ...
> 
> 
> This may be too much of a good thing.   From the point
> of view of efficient reading, large extents are good, because
> they minimize seeks in sequential reads.
> But there will be diminishing returns when
> the extent gets bigger than the size of a physical disk cylinder.

Even for small extents, (4k blocks) you can do large IOs.  ext23 both do
this and generally are able to do ios much larger than a physical
cylinder.

This is another way of saying the size of the extent doesn't have to
impact fragmentation or seeking.  We can have 512 byte blocks with zero
seeks if we lay them out correctly.

> 
> For instance, modern disks have a data transfer rate of (about) 200MB/s,
> so adding one extra seek (about 8ms) in the middle of a
> 200MB extent can't possibly slow things down by more than 1%.
> (And, that's the worst-possible case.)
> 
> But, large extents (I think) also have costs.   For instance, if you are
> writing a byte into the middle of an extent, doesn't Btrfs have to copy
> the entire extent?    If so, and if you have a 99MB extent, the cost
> of that write operation will be *huge*.

Btrfs doesn't do COW on the whole extent, just the portion you are
changing. 

The real benefit of extents for traditional filesystems is that you just
don't need as much metadata to describe the space used on disk by a
given file.  For huge files this matters quite a lot, just look at how
long it takes to delete a 1TB sparse file on ext3.

In btrfs the size of the extent matters even more.  For COW and
snapshots, we have more tracking per-extent than most filesystems do.
Keeping larger extents allows us to have less tracking and generally
makes things much more efficient.

> 
> Likewise, if you have compressed extents, and you want to read one
> byte near the end of the extent, Btrfs needs to uncompress the
> entire extent.    Under some circumstances, you might have to
> decompress 99MB to read one short block of data.   (Admittedly,
> cacheing will make this worst-case scenario less common, but
> it will still be there sometimes.)

The size of a compressed extent is limited to 256k, both on disk and in
ram.  We try to make sure uncompressing the extent won't make the
machine fall over.

So, the issues you talk about do all exist.  We try to manage the
compromises around extent size and still keep the benefits of large
extents.  There was a mount option to limit the max extent size in the
past, but it was not used very often and made the enospc code
dramatically more complex.  It was removed to cut down on enospc
problems.

(more extents mean more metadata which means more space per operation)

-chris
