From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 19:33:39 +0100
Message-ID: <201012011933.40169.kreijack@libero.it>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>, ssorce@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 01 December, 2010, Josef Bacik wrote:
> Hello,
> 

Hi Josef

> 
> === What are subvolumes? ===
> 
> They are just another tree.  In BTRFS we have various b-trees to describe 
the
> filesystem.  A few of them are filesystem wide, such as the extent tree, 
chunk
> tree, root tree etc.  The tree's that hold the actual filesystem data, that 
is
> inodes and such, are kept in their own b-tree.  This is how subvolumes and
> snapshots appear on disk, they are simply new b-trees with all of the file 
data
> contained within them.
> 
> === What do subvolumes look like? ===
> 
[...]
> 
> 2) Obviously you can't just rm -rf subvolumes.  Because they are roots 
there's
> extra metadata to keep track of them, so you have to use one of our ioctls 
to
> delete subvolumes/snapshots.

Sorry, but I can't understand this sentence. It is clear that a directory and 
a subvolume have a totally different on-disk format. But why it would be not 
possible to remove a subvolume via the normal rmdir(2) syscall ? I posted a 
patch some months ago: when the rmdir is invoked on a subvolume, the same 
action of the ioctl BTRFS_IOC_SNAP_DESTROY is performed.

See https://patchwork.kernel.org/patch/260301/
 
[...]
> 
> There is one tricky thing.  When you create a subvolume, the directory inode
> that is created in the parent subvolume has the inode number of 256.  So if 
you
> have a bunch of subvolumes in the same parent subvolume, you are going to 
have a
> bunch of directories with the inode number of 256.  This is so when users cd
> into a subvolume we can know its a subvolume and do all the normal voodoo to
> start looking in the subvolumes tree instead of the parent subvolumes tree.
> 
> This is where things go a bit sideways.  We had serious problems with NFS, 
but
> thankfully NFS gives us a bunch of hooks to get around these problems.
> CIFS/Samba do not, so we will have problems there, not to mention any other
> userspace application that looks at inode numbers.

How this is/should be different of a mounted filesystem ?
For example:

# cd /tmp
# btrfs subvolume create sub-a
# btrfs subvolume create sub-b
# mkdir mount -a; mkdir mount-b
# mount /dev/sda6 mount-a		# an ext4 fs
# mount /dev/sdb2 mount-b		# an ext3 fs
# $ stat -c "%8i %n" sub-a sub-b mount-a mount-b
     256 sub-a
     256 sub-b
       2 mount-a
       2 mount-b

In this case the inode-number returned are equal for both the mounted 
filesystems and the subvolumes. However, the fsid is different.

# stat -fc "%8i %n" sub-a sub-b mount-a mount-b .
cdc937c1a203df74 sub-a
cdc937c1a203df77 sub-b
b27d147f003561c8 mount-a
d49e1a3d2333d2e1 mount-b
cdc937c1a203df75 .

Moreover I suggest to look at the difference of the inode returned by 
readdir(3) and stat(3)..

[...]
> I feel like I'm forgetting something here, hopefully somebody will point it 
out.
> 

Another point that I want like to discuss is how manage the "pivoting" between 
the subvolumes. One of the most beautiful feature of btrfs is the snapshot 
capability. In fact it is possible to make a snapshot of the root of the 
filesystem and to mount it in a subsequent reboot.
But is very complicated to manage the pivoting of a snapshot of a root 
filesystem, because I cannot delete the "old root" due to the fact that the 
"new root" is placed in the "old root".

A possible solution is not to put the root of the filesystem (where are placed 
/usr, /etc....) in the root of the btrfs filesystem; but it should be accepted 
from the beginning the idea that the root of a filesystem should be placed in 
a subvolume which int turn is placed in the root of a btrfs filesystem...

I am open to other opinions.

> === Conclusion ===
> 
> There are definitely some wonky things with subvolumes, but I don't think 
they
> are things that cannot be fixed now.  Some of these changes will require
> incompat format changes, but it's either we fix it now, or later on down the
> road when BTRFS starts getting used in production really find out how many
> things our current scheme breaks and then have to do the changes then.  
Thanks,
> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
