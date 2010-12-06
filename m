From: Chris Mason <chris.mason@oracle.com>
Subject: Re: "Appending" data to the middle of a file using btrfs-specific features
Date: Mon, 06 Dec 2010 11:05:02 -0500
Message-ID: <1291651254-sup-4263@think>
References: <AANLkTinXfbKmXYy52JF-QuJr0WTzgvbMXHAw-tYK4i5X@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTinXfbKmXYy52JF-QuJr0WTzgvbMXHAw-tYK4i5X@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Nirbheek Chauhan's message of 2010-12-06 07:41:16 -0500:
> Hello,
> 
> I'd like to know if there has been any discussion about adding a new
> feature to write (add) data at an offset, but without overwriting
> existing data, or re-writing the existing data. Essentially, in-place
> addition/removal of data to a file at a place other than the end of
> the file.
> 
> Some possible use-cases of such a feature would be:
> 
> (a) Databases (currently hack around this by allocating sparse files)
> (b) Delta-patching (rsync, patch, xdelta, etc)
> (c) Video editors (especially if combined with reflink copies)
> 
> Besides I/O savings, it would also have significant space savings if
> the current subvolume being written to has been snapshotted (a common
> use-case for incremental backups).
> 
> I've been told that the problem is somewhat difficult to solve
> properly under block-based representation of data, but I was hoping
> that btrfs' reflink mechanism and its space-efficient packing of small
> files might make it doable.
> 
> A hack I can think of is to do a BTRFS_IOC_CLONE_RANGE into a new file
> (upto the offset), writing whatever data is required, and then doing
> another BTRFS_IOC_CLONE_RANGE with an offset for the rest of the
> original file. This can be followed by a rename() over the original
> file. Similarly for removing data from the middle of a file. Would
> this work? Would it be cleaner to implement something equivalent
> internally?

It would work yes.  The operation has three cases:

1) file size doesn't change
2) extend the file with new bytes in the middle
3) make the file smaller removing bytes in the middle

#1 is the easiest case, you can just use the clone range ioctl directly

For #2 and #3, all of the file pointers past the bytes you want to add
or remove need to be updated with a new file offset.  I'd say for an
initial implementation to use the IOC_CLONE_RANGE code, and after
everything is working we can look at optimizing it with a shift ioctl if
it makes sense.

Of the use cases you list, video editors seems the most useful.
Databases already have things pretty much under control, and delta
patching wants to go to a new file anyway.  Video editing software has
long been looking for ways to do this.

-chris
