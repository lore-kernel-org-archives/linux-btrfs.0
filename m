From: Christoph Hellwig <hch@lst.de>
Subject: Re: What to do about subvolumes?
Date: Tue, 7 Dec 2010 17:48:19 +0100
Message-ID: <20101207164819.GA21375@lst.de>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

> === What do subvolumes look like? ===
> 
> All the user sees are directories.  They act like any other directory acts, with
> a few exceptions
> 
> 1) You cannot hardlink between subvolumes.  This is because subvolumes have
> their own inode numbers and such, think of them as seperate mounts in this case,
> you cannot hardlink between two mounts because the link needs to point to the
> same on disk inode, which is impossible between two different filesystems.  The
> same is true for subvolumes, they have their own trees with their own inodes and
> inode numbers, so it's impossible to hardlink between them.

which means they act like a different mount point.

> 1a) In case it wasn't clear from above, each subvolume has their own inode
> numbers, so you can have the same inode numbers used between two different
> subvolumes, since they are two different trees.

which means they act like not just a different mount point, but they
also act like beeing a separate superblock.

> 2) Obviously you can't just rm -rf subvolumes.  Because they are roots there's
> extra metadata to keep track of them, so you have to use one of our ioctls to
> delete subvolumes/snapshots.

Again this means they act like a mount point.

> 1) Users need to be able to create their own subvolumes.  The permission
> semantics will be absolutely the same as creating directories, so I don't think
> this is too tricky.  We want this because you can only take snapshots of
> subvolumes, and so it is important that users be able to create their own
> discrete snapshottable targets.

Not that I'm entirely against this, but instead of just stating they
must can you also state the detailed reason?  Allowing users to create
your subvolumes is a mostly equivalent problem to allowing user mounts,
so handling those two under one umbrella makes a lot of sense.

> This is where I expect to see the most discussion.  Here is what I want to do
> 
> 1) Scrap the 256 inode number thing.  Instead we'll just put a flag in the inode
> to say "Hey, I'm a subvolume" and then we can do all of the appropriate magic
> that way.  This unfortunately will be an incompatible format change, but the
> sooner we get this adressed the easier it will be in the long run.  Obviously
> when I say format change I mean via the incompat bits we have, so old fs's won't
> be broken and such.

>From reading later post in this threads readddir already seems to take
care of this in some way.  But is there a chance of collisions between
real inode numbers and the ones faked up for the subvolume roots?

> 2) Do something like NFS's referral mounts when we cd into a subvolume.  Now we
> just do dentry trickery, but that doesn't make the boundary between subvolumes
> clear, so it will confuse people (and samba) when they walk into a subvolume and
> all of a sudden the inode numbers are the same as in the directory behind them.
> With doing the referral mount thing, each subvolume appears to be its own mount
> and that way things like NFS and samba will work properly.
> 
> I feel like I'm forgetting something here, hopefully somebody will point it out.

The current code requires the automount trigger points to be links,
which is something that Chris didn't like at all.  But that issue is
solved by building upong David Howell's series to replace that
follow_link magic with a new d_automount dentry operation.  I'd suggest
building the new code on top of that.

And most importantly:

 3) allocate a different anon dev_t for each subvolume.


One thing that really confuses me is that the the actual root of the
subvolume appears directly in the parent namespace.  Given that you have
your subvolume identifiers that doesn't even seems nessecary.

To me the following scheme seems more useful:

 - all subvolumes/snapshots only show up in a virtual below-root
   directory, similar to how the existing "default" one doesn't
   sit on the top.
 - the entries inside a namespace that are to be automounted have
   an entry in the filesystem that just marks them as an auto-mount
   point that redirects to the actual subvolume.
 - we still allow mounting subvolumes (and only those) directly
   from get_sb by specifying the subvolume name.

This is especially important for snapshots, as just having them hang
off the filesystem that is to be snapshotted is extremly confusing.
