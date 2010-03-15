From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Saving and restoring btrfs snapshots
Date: Mon, 15 Mar 2010 09:53:01 -0400
Message-ID: <20100315135301.GP3035@think>
References: <18f8b4a81003112300h3be917adgd183bb78719019e2@mail.gmail.com>
 <201003121930.01701.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003121930.01701.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 12, 2010 at 07:30:01PM +0100, Goffredo Baroncelli wrote:
> On Friday 12 March 2010, Pat Patterson wrote:
> > Are there any plans to implement something akin to ZFS send/recv, to
> > be able to create a stream representation of a snapshot and restore it
> > later/somewhere else? I've spent some time trawling the mailing list
> > and wiki, but I don't see anything there.
> 
> I spent a bit of time on this argument, in order to find how implement an 
> efficient method to backup incrementally the data.
> 
> AFAICT "zfs send" and "zfs recv" do the same thing that tar does. They 
> transform a tree (or the difference between a tree and its snapshot) to a 
> stream, and vice-versa.
> 
> To transform a tree to a stream is not very interesting. 
> The interesting part is how compare a tree and its snapshot. In fact a 
> snapshot of a tree should a be pointer to the original tree, and when a file 
> is modified, a branch of the modified part (the extens of the file, the 
> directories of the path) is performed (yes I know that this a big 
> simplification of the process).
> The key is that the file-system knows which part of a snapshot is still equal 
> to the source and which not.
> 
> If this kind of data is available to the user space, comparing a tree and it 
> snapshot should be very fast. 
> 
> Reading the documentation of btrfs, it seems that associated the transaction 
> there is a "version number". With this "version  number" of a directory, we 
> would be able to verify the equality of two trees comparing only the root of 
> the trees. This would increase the seed of two trees.

Every btree block and file extent include the transaction id of when
they were created.  When COW is on, this means they include the
transaction id of when they were last modified.

Finding updated file extents means searching through the tree based on
transaction id (ignoring any branch in the tree older than transid X),
which is exactly what the treelog code does to efficiently log fsyncs.
This is especially easy because the tree node pointers include the
expected transaction id of what they are pointing to, so you can skip
reading any tree block with an old pointer.

In the subvol branch, we have a new ioctl to do tree searches from
userland based on these ranges.  It can very easily be used to make a
list of files (and extents in those files) that have been updated since
a given transid.

> 
> But I was never able to get this "version number". There is the ioctl command 
> FS_IOC_GETVERSION, which seems to return this number. But when a directory or 
> an its children is update, this number doesn't change.
> 
> I tried to hack the kernel code in order to test different "version" number: I 
> tried inode->i_generation, or btrfs_inode->generation or btrfs_inode->sequence 
> or btrfs_inode->{last|last_sub|logged}_trans...
> But none of the above was useful for my purpose.

Right, I decided instead to store the generation in the file extent
pointer.  We needed it for other things as well, and it makes it
possible to find individual extents that have changed in a file instead
of just flagging the file as modified.

This would be a good project if anyone is interested, I'm happy to send
along full details.

-chris

