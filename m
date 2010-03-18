From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Saving and restoring btrfs snapshots
Date: Thu, 18 Mar 2010 15:24:43 -0400
Message-ID: <20100318192443.GF14074@think>
References: <18f8b4a81003112300h3be917adgd183bb78719019e2@mail.gmail.com>
 <201003121930.01701.kreijack@libero.it>
 <20100315135301.GP3035@think>
 <201003161917.13131.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003161917.13131.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 16, 2010 at 07:17:12PM +0100, Goffredo Baroncelli wrote:
> Hi Chris
> 
> On Monday 15 March 2010, Chris Mason wrote:
> > On Fri, Mar 12, 2010 at 07:30:01PM +0100, Goffredo Baroncelli wrote:
> > > On Friday 12 March 2010, Pat Patterson wrote:
> > > > Are there any plans to implement something akin to ZFS send/recv, to
> > > > be able to create a stream representation of a snapshot and restore it
> > > > later/somewhere else? I've spent some time trawling the mailing list
> > > > and wiki, but I don't see anything there.
> > > 
> > > I spent a bit of time on this argument, in order to find how implement an 
> > > efficient method to backup incrementally the data.
> > > 
> > > AFAICT "zfs send" and "zfs recv" do the same thing that tar does. They 
> > > transform a tree (or the difference between a tree and its snapshot) to a 
> > > stream, and vice-versa.
> > > 
> > > To transform a tree to a stream is not very interesting. 
> > > The interesting part is how compare a tree and its snapshot. In fact a 
> > > snapshot of a tree should a be pointer to the original tree, and when a 
> file 
> > > is modified, a branch of the modified part (the extens of the file, the 
> > > directories of the path) is performed (yes I know that this a big 
> > > simplification of the process).
> > > The key is that the file-system knows which part of a snapshot is still 
> equal 
> > > to the source and which not.
> > > 
> > > If this kind of data is available to the user space, comparing a tree and 
> it 
> > > snapshot should be very fast. 
> > > 
> > > Reading the documentation of btrfs, it seems that associated the 
> transaction 
> > > there is a "version number". With this "version  number" of a directory, 
> we 
> > > would be able to verify the equality of two trees comparing only the root 
> of 
> > > the trees. This would increase the seed of two trees.
> > 
> > Every btree block and file extent include the transaction id of when
> > they were created.  When COW is on, this means they include the
> > transaction id of when they were last modified.
> > 
> > Finding updated file extents means searching through the tree based on
> > transaction id (ignoring any branch in the tree older than transid X),
> > which is exactly what the treelog code does to efficiently log fsyncs.
> > This is especially easy because the tree node pointers include the
> > expected transaction id of what they are pointing to, so you can skip
> > reading any tree block with an old pointer.
> 
> If I understand correctly, you say that it is possible to find the file update 
> between two transaction id. It would be wonderful. Even though a question 
> comes me: what about if the transaction doesn't contain the snapshot alone ? 
> Could the "delta" contain writes happened after the second transaction or 
> before the first transaction ?
> 
> > In the subvol branch, we have a new ioctl to do tree searches from
> > userland based on these ranges.  It can very easily be used to make a
> > list of files (and extents in those files) that have been updated since
> > a given transid.
> > 
> > > 
> > > But I was never able to get this "version number". There is the ioctl 
> command 
> > > FS_IOC_GETVERSION, which seems to return this number. But when a directory 
> or 
> > > an its children is update, this number doesn't change.
> > > 
> > > I tried to hack the kernel code in order to test different "version" 
> number: I 
> > > tried inode->i_generation, or btrfs_inode->generation or btrfs_inode-
> >sequence 
> > > or btrfs_inode->{last|last_sub|logged}_trans...
> > > But none of the above was useful for my purpose.
> > 
> > Right, I decided instead to store the generation in the file extent
> > pointer.  We needed it for other things as well, and it makes it
> > possible to find individual extents that have changed in a file instead
> > of just flagging the file as modified.
> > 
> > This would be a good project if anyone is interested, I'm happy to send
> > along full details.
> 
> 
> If you are able to provide further details, I am interested in the things. 
> I appreciate any suggestion how extract the transaction ID given a file (or a 
> directory).

The new btrfs subvol find-new command has an example to build up a list
of files that have changed based on the generation in the extent field.
This is only the start of what a real tool needs, but it should
definitely help anyone interested in this.

The usage is btrfs subvol find-new <path> <generation>

If you pass a generation of zero, it'll list every file in the
filesystem.  Otherwise it will only pass files with extents >=
given generation.

The generations are done on each extent, and have nothing to do with
mtime/ctime.  So if you just touch a file, it won't show up in the list.
For this tool to be real it will also need to check inode times against
a reference time.

The list is per-subvol only, but there's no reason it can't descend into
other subvols from userland.

Filtering the search by subdirectory is an exercise for the reader.  In
many cases it will actually be slower than doing the whole FS, but in
others it'll be much faster.

Another thing to keep in mind is the search only finds extents after
they have been written to the disk.

Example output:

btrfs subvol find-new /mnt 0 | head

# btrfs subvol find-new /mnt/foo 0 | head -n 3
inode 263 file offset 0 len 452 disk start 0 offset 0 gen 10017 flags INLINE linux.ext3/.git/hooks/applypatch-msg.sample
inode 264 file offset 0 len 160 disk start 0 offset 0 gen 10017 flags INLINE linux.ext3/.git/hooks/post-commit.sample
inode 267 file offset 0 len 8192 disk start 12582912 offset 0 gen 10017 flags NONE linux.ext3/.git/hooks/pre-rebase.sample

So we have two small inline files and one file with a regular extent.
The fields tell us:

inode number in the subvol
logical start of range in file
logical length of range in file (for a compressed file this would be the
uncompressed size)

Extent start on disk
Offset into that extent on disk

Generation number of this extent (transid that created it)
Any flags: COMPRESS,INLINE,PREALLOC

The extent number on disk is included so that files sharing the same
extents can be identified.

I'm sure we'll have to grow this a bit and play with it, but it's
definitely a start.  Just let me know if you have any questions.  Extra
points to the first person that finds a way to send this as a file list
for rsync.

One important thing to remember if you want to use this to make a backup
program is that it won't tell you about any files that have been
removed.  There are a few different ways to get this information, but
the easiest way is to make a manifest of the directory listings for any
directory that has been changed.

The search ioctl exposes the whole btrfs btree to userland, and the
find-new command has a few different examples of ways you might use
this.  Once you get a feel for the searches a lot of things get easier,
but the learning curve is pretty steep.  Please ask questions early and
often if you play with this and don't get the results you expect.

-chris

