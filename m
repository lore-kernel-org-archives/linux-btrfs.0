From: Ian Kent <raven@themaw.net>
Subject: Re: What to do about subvolumes?
Date: Mon, 31 Jan 2011 10:56:38 +0800
Message-ID: <1296442598.6320.8.camel@perseus>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	 <20101203214526.GA4508@localhost.localdomain>
	 <AANLkTimG7Qp_VCe71y7M4t5Y+x8kO=AAJWO1NWDN0HJO@mail.gmail.com>
	 <20101206142743.GA2556@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Mike Fedyk <mfedyk@mikefedyk.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com, bfields@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101206142743.GA2556@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2010-12-06 at 09:27 -0500, Josef Bacik wrote:
> On Sat, Dec 04, 2010 at 01:58:07PM -0800, Mike Fedyk wrote:
> > On Fri, Dec 3, 2010 at 1:45 PM, Josef Bacik <josef@redhat.com> wrote:
> > > On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
> > >> Hello,
> > >>
> > >> Various people have complained about how BTRFS deals with subvolumes recently,
> > >> specifically the fact that they all have the same inode number, and there's no
> > >> discrete seperation from one subvolume to another.  Christoph asked that I lay
> > >> out a basic design document of how we want subvolumes to work so we can hash
> > >> everything out now, fix what is broken, and then move forward with a design that
> > >> everybody is more or less happy with.  I apologize in advance for how freaking
> > >> long this email is going to be.  I assume that most people are generally
> > >> familiar with how BTRFS works, so I'm not going to bother explaining in great
> > >> detail some stuff.
> > >>
> > >> === What are subvolumes? ===
> > >>
> > >> They are just another tree.  In BTRFS we have various b-trees to describe the
> > >> filesystem.  A few of them are filesystem wide, such as the extent tree, chunk
> > >> tree, root tree etc.  The tree's that hold the actual filesystem data, that is
> > >> inodes and such, are kept in their own b-tree.  This is how subvolumes and
> > >> snapshots appear on disk, they are simply new b-trees with all of the file data
> > >> contained within them.
> > >>
> > >> === What do subvolumes look like? ===
> > >>
> > >> All the user sees are directories.  They act like any other directory acts, with
> > >> a few exceptions
> > >>
> > >> 1) You cannot hardlink between subvolumes.  This is because subvolumes have
> > >> their own inode numbers and such, think of them as seperate mounts in this case,
> > >> you cannot hardlink between two mounts because the link needs to point to the
> > >> same on disk inode, which is impossible between two different filesystems.  The
> > >> same is true for subvolumes, they have their own trees with their own inodes and
> > >> inode numbers, so it's impossible to hardlink between them.
> > >>
> > >> 1a) In case it wasn't clear from above, each subvolume has their own inode
> > >> numbers, so you can have the same inode numbers used between two different
> > >> subvolumes, since they are two different trees.
> > >>
> > >> 2) Obviously you can't just rm -rf subvolumes.  Because they are roots there's
> > >> extra metadata to keep track of them, so you have to use one of our ioctls to
> > >> delete subvolumes/snapshots.
> > >>
> > >> But permissions and everything else they are the same.
> > >>
> > >> There is one tricky thing.  When you create a subvolume, the directory inode
> > >> that is created in the parent subvolume has the inode number of 256.  So if you
> > >> have a bunch of subvolumes in the same parent subvolume, you are going to have a
> > >> bunch of directories with the inode number of 256.  This is so when users cd
> > >> into a subvolume we can know its a subvolume and do all the normal voodoo to
> > >> start looking in the subvolumes tree instead of the parent subvolumes tree.
> > >>
> > >> This is where things go a bit sideways.  We had serious problems with NFS, but
> > >> thankfully NFS gives us a bunch of hooks to get around these problems.
> > >> CIFS/Samba do not, so we will have problems there, not to mention any other
> > >> userspace application that looks at inode numbers.
> > >>
> > >> === How do we want subvolumes to work from a user perspective? ===
> > >>
> > >> 1) Users need to be able to create their own subvolumes.  The permission
> > >> semantics will be absolutely the same as creating directories, so I don't think
> > >> this is too tricky.  We want this because you can only take snapshots of
> > >> subvolumes, and so it is important that users be able to create their own
> > >> discrete snapshottable targets.
> > >>
> > >> 2) Users need to be able to snapshot their subvolumes.  This is basically the
> > >> same as #1, but it bears repeating.
> > >>
> > >> 3) Subvolumes shouldn't need to be specifically mounted.  This is also
> > >> important, we don't want users to have to go around mounting their subvolumes up
> > >> manually one-by-one.  Today users just cd into subvolumes and it works, just
> > >> like cd'ing into a directory.
> > >>
> > >> === Quotas ===
> > >>
> > >> This is a huge topic in and of itself, but Christoph mentioned wanting to have
> > >> an idea of what we wanted to do with it, so I'm putting it here.  There are
> > >> really 2 things here
> > >>
> > >> 1) Limiting the size of subvolumes.  This is really easy for us, just create a
> > >> subvolume and at creation time set a maximum size it can grow to and not let it
> > >> go farther than that.  Nice, simple and straightforward.
> > >>
> > >> 2) Normal quotas, via the quota tools.  This just comes down to how do we want
> > >> to charge users, do we want to do it per subvolume, or per filesystem.  My vote
> > >> is per filesystem.  Obviously this will make it tricky with snapshots, but I
> > >> think if we're just charging the diff's between the original volume and the
> > >> snapshot to the user then that will be the easiest for people to understand,
> > >> rather than making a snapshot all of a sudden count the users currently used
> > >> quota * 2.
> > >>
> > >> === What do we do? ===
> > >>
> > >> This is where I expect to see the most discussion.  Here is what I want to do
> > >>
> > >> 1) Scrap the 256 inode number thing.  Instead we'll just put a flag in the inode
> > >> to say "Hey, I'm a subvolume" and then we can do all of the appropriate magic
> > >> that way.  This unfortunately will be an incompatible format change, but the
> > >> sooner we get this adressed the easier it will be in the long run.  Obviously
> > >> when I say format change I mean via the incompat bits we have, so old fs's won't
> > >> be broken and such.
> > >>
> > >> 2) Do something like NFS's referral mounts when we cd into a subvolume.  Now we
> > >> just do dentry trickery, but that doesn't make the boundary between subvolumes
> > >> clear, so it will confuse people (and samba) when they walk into a subvolume and
> > >> all of a sudden the inode numbers are the same as in the directory behind them.
> > >> With doing the referral mount thing, each subvolume appears to be its own mount
> > >> and that way things like NFS and samba will work properly.
> > >>
> > >> I feel like I'm forgetting something here, hopefully somebody will point it out.
> > >>
> > >> === Conclusion ===
> > >>
> > >> There are definitely some wonky things with subvolumes, but I don't think they
> > >> are things that cannot be fixed now.  Some of these changes will require
> > >> incompat format changes, but it's either we fix it now, or later on down the
> > >> road when BTRFS starts getting used in production really find out how many
> > >> things our current scheme breaks and then have to do the changes then.  Thanks,
> > >>
> > >
> > > So now that I've actually looked at everything, it looks like the semantics are
> > > all right for subvolumes
> > >
> > > 1) readdir - we return the root id in d_ino, which is unique across the fs
> > > 2) stat - we return 256 for all subvolumes, because that is their inode number
> > > 3) dev_t - we setup an anon super for all volumes, so they all get their own
> > > dev_t, which is set properly for all of their children, see below
> > >
> > > [root@test1244 btrfs-test]# stat .
> > >  File: `.'
> > >  Size: 20              Blocks: 8          IO Block: 4096   directory
> > > Device: 15h/21d Inode: 256         Links: 1
> > > Access: (0555/dr-xr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> > > Access: 2010-12-03 15:35:41.931679393 -0500
> > > Modify: 2010-12-03 15:35:20.405679493 -0500
> > > Change: 2010-12-03 15:35:20.405679493 -0500
> > >
> > > [root@test1244 btrfs-test]# stat foo
> > >  File: `foo'
> > >  Size: 12              Blocks: 0          IO Block: 4096   directory
> > > Device: 19h/25d Inode: 256         Links: 1
> > > Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)
> > > Access: 2010-12-03 15:35:17.501679393 -0500
> > > Modify: 2010-12-03 15:35:59.150680051 -0500
> > > Change: 2010-12-03 15:35:59.150680051 -0500
> > >
> > > [root@test1244 btrfs-test]# stat foo/foobar
> > >  File: `foo/foobar'
> > >  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
> > > Device: 19h/25d Inode: 257         Links: 1
> > > Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> > > Access: 2010-12-03 15:35:59.150680051 -0500
> > > Modify: 2010-12-03 15:35:59.150680051 -0500
> > > Change: 2010-12-03 15:35:59.150680051 -0500
> > >
> > > So as far as the user is concerned, everything should come out right.  Obviously
> > > we had to do the NFS trickery still because as far as VFS is concerned the
> > > subvolumes are all on the same mount.  So the question is this (and really this
> > > is directed at Christoph and Bruce and anybody else who may care), is this good
> > > enough, or do we want to have a seperate vfsmount for each subvolume?  Thanks,
> > >
> > 
> > What are the drawbacks of having a vfsmount for each subvolume?
> > 
> > Why (besides having to code it up) are you trying to avoid doing it that way?
> 
> It's the having to code it up that way thing, I'm nothing if not lazy.

And, anything that uses the mount table, exposed from the kernel, will
grind a system to a halt with only a few thousand mounts, not to mention
that user space utilities, like df, du ..., will become painful to use
for more than a hundred or so entries.

> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


