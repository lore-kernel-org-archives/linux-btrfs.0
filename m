From: Josef Bacik <josef@redhat.com>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 13:36:57 -0500
Message-ID: <20101201183656.GD7021@localhost.localdomain>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <201012011933.40169.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, ssorce@redhat.com,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201012011933.40169.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 07:33:39PM +0100, Goffredo Baroncelli wrote:
> On Wednesday, 01 December, 2010, Josef Bacik wrote:
> > Hello,
> > 
> 
> Hi Josef
> 
> > 
> > === What are subvolumes? ===
> > 
> > They are just another tree.  In BTRFS we have various b-trees to describe 
> the
> > filesystem.  A few of them are filesystem wide, such as the extent tree, 
> chunk
> > tree, root tree etc.  The tree's that hold the actual filesystem data, that 
> is
> > inodes and such, are kept in their own b-tree.  This is how subvolumes and
> > snapshots appear on disk, they are simply new b-trees with all of the file 
> data
> > contained within them.
> > 
> > === What do subvolumes look like? ===
> > 
> [...]
> > 
> > 2) Obviously you can't just rm -rf subvolumes.  Because they are roots 
> there's
> > extra metadata to keep track of them, so you have to use one of our ioctls 
> to
> > delete subvolumes/snapshots.
> 
> Sorry, but I can't understand this sentence. It is clear that a directory and 
> a subvolume have a totally different on-disk format. But why it would be not 
> possible to remove a subvolume via the normal rmdir(2) syscall ? I posted a 
> patch some months ago: when the rmdir is invoked on a subvolume, the same 
> action of the ioctl BTRFS_IOC_SNAP_DESTROY is performed.
> 
> See https://patchwork.kernel.org/patch/260301/
>  

Oh hey thats cool.  That would be reasonable I think.  I was just saying that
currently we can't remove subvolumes/snapshots via rm, not that it wasn't
possible at all.  So I think what you did would be a good thing to have.

> [...]
> > 
> > There is one tricky thing.  When you create a subvolume, the directory inode
> > that is created in the parent subvolume has the inode number of 256.  So if 
> you
> > have a bunch of subvolumes in the same parent subvolume, you are going to 
> have a
> > bunch of directories with the inode number of 256.  This is so when users cd
> > into a subvolume we can know its a subvolume and do all the normal voodoo to
> > start looking in the subvolumes tree instead of the parent subvolumes tree.
> > 
> > This is where things go a bit sideways.  We had serious problems with NFS, 
> but
> > thankfully NFS gives us a bunch of hooks to get around these problems.
> > CIFS/Samba do not, so we will have problems there, not to mention any other
> > userspace application that looks at inode numbers.
> 
> How this is/should be different of a mounted filesystem ?
> For example:
> 
> # cd /tmp
> # btrfs subvolume create sub-a
> # btrfs subvolume create sub-b
> # mkdir mount -a; mkdir mount-b
> # mount /dev/sda6 mount-a		# an ext4 fs
> # mount /dev/sdb2 mount-b		# an ext3 fs
> # $ stat -c "%8i %n" sub-a sub-b mount-a mount-b
>      256 sub-a
>      256 sub-b
>        2 mount-a
>        2 mount-b
> 
> In this case the inode-number returned are equal for both the mounted 
> filesystems and the subvolumes. However, the fsid is different.
> 
> # stat -fc "%8i %n" sub-a sub-b mount-a mount-b .
> cdc937c1a203df74 sub-a
> cdc937c1a203df77 sub-b
> b27d147f003561c8 mount-a
> d49e1a3d2333d2e1 mount-b
> cdc937c1a203df75 .
> 
> Moreover I suggest to look at the difference of the inode returned by 
> readdir(3) and stat(3)..
>

Yeah you are right, the inode numbering can probably be the same, we just need
to make them logically different mounts so things like NFS and samba still work
right.

> [...]
> > I feel like I'm forgetting something here, hopefully somebody will point it 
> out.
> > 
> 
> Another point that I want like to discuss is how manage the "pivoting" between 
> the subvolumes. One of the most beautiful feature of btrfs is the snapshot 
> capability. In fact it is possible to make a snapshot of the root of the 
> filesystem and to mount it in a subsequent reboot.
> But is very complicated to manage the pivoting of a snapshot of a root 
> filesystem, because I cannot delete the "old root" due to the fact that the 
> "new root" is placed in the "old root".
> 
> A possible solution is not to put the root of the filesystem (where are placed 
> /usr, /etc....) in the root of the btrfs filesystem; but it should be accepted 
> from the beginning the idea that the root of a filesystem should be placed in 
> a subvolume which int turn is placed in the root of a btrfs filesystem...
> 
> I am open to other opinions.
> 

Agreed, one of the things that Chris and I have discussed is the possiblity of
just having dangling roots, since really the directories are just an easy way to
get to the subvolumes.  This would let you delete the original volume and use
the snapshot from then on out.  Something to do in the future for sure.  Thanks,

Josef
