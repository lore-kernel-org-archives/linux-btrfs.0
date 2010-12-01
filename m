From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 14:44:04 -0500
Message-ID: <20101201194404.GE17142@fieldses.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
> Hello,
> 
> Various people have complained about how BTRFS deals with subvolumes recently,
> specifically the fact that they all have the same inode number, and there's no
> discrete seperation from one subvolume to another.  Christoph asked that I lay
> out a basic design document of how we want subvolumes to work so we can hash
> everything out now, fix what is broken, and then move forward with a design that
> everybody is more or less happy with.  I apologize in advance for how freaking
> long this email is going to be.  I assume that most people are generally
> familiar with how BTRFS works, so I'm not going to bother explaining in great
> detail some stuff.
> 
> === What are subvolumes? ===
> 
> They are just another tree.  In BTRFS we have various b-trees to describe the
> filesystem.  A few of them are filesystem wide, such as the extent tree, chunk
> tree, root tree etc.  The tree's that hold the actual filesystem data, that is
> inodes and such, are kept in their own b-tree.  This is how subvolumes and
> snapshots appear on disk, they are simply new b-trees with all of the file data
> contained within them.
> 
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

OK, so I'm unclear: would it be possible for nfsd to export subvolumes
independently?

For that to work, we need to be able to take an inode that we just
looked up by filehandle, and see which subvolume it belongs in.  So if
two subvolumes can point to the same inode, it doesn't work, but if
st_dev is different between them, e.g., that'd be fine.  Sounds like
you're seeing the latter is possible, good!

> 
> 1a) In case it wasn't clear from above, each subvolume has their own inode
> numbers, so you can have the same inode numbers used between two different
> subvolumes, since they are two different trees.
> 
> 2) Obviously you can't just rm -rf subvolumes.  Because they are roots there's
> extra metadata to keep track of them, so you have to use one of our ioctls to
> delete subvolumes/snapshots.
> 
> But permissions and everything else they are the same.
> 
> There is one tricky thing.  When you create a subvolume, the directory inode
> that is created in the parent subvolume has the inode number of 256.

Is that the right way to say this?  Doing a quick test, the inode
numbers that a readdir of the parent directory returns *are* distinct.
It's just the inode number that you get when you stat that is different.

Which is all fine and normal, *if* you treat this as a real mountpoint
with its own vfsmount, st_dev, etc.

> === How do we want subvolumes to work from a user perspective? ===
> 
> 1) Users need to be able to create their own subvolumes.  The permission
> semantics will be absolutely the same as creating directories, so I don't think
> this is too tricky.  We want this because you can only take snapshots of
> subvolumes, and so it is important that users be able to create their own
> discrete snapshottable targets.
> 
> 2) Users need to be able to snapshot their subvolumes.  This is basically the
> same as #1, but it bears repeating.
> 
> 3) Subvolumes shouldn't need to be specifically mounted.  This is also
> important, we don't want users to have to go around mounting their subvolumes up
> manually one-by-one.  Today users just cd into subvolumes and it works, just
> like cd'ing into a directory.

And the separate nfsd exports is another thing I'd really love to see
work: currently you can export a subtree of a filesystem if you want,
but it's trivial to escape the subtree by guessing filehandles.  So this
gives us an easy way for administrators to create secure separate
exports without having to manage entirely separate volumes.

If subvolumes got real mountpoints and so on, this would be easy.

--b.
