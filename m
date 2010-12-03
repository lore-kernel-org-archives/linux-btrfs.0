From: "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: What to do about subvolumes?
Date: Fri, 3 Dec 2010 17:16:15 -0500
Message-ID: <20101203221614.GB12491@pad.home.fieldses.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <20101203214526.GA4508@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101203214526.GA4508@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 03, 2010 at 04:45:27PM -0500, Josef Bacik wrote:
> So now that I've actually looked at everything, it looks like the semantics are
> all right for subvolumes
> 
> 1) readdir - we return the root id in d_ino, which is unique across the fs

Though Michael Vrable pointed out an apparent collision with "normal"
inode numbers on the parent filesystem?

> 2) stat - we return 256 for all subvolumes, because that is their inode number
> 3) dev_t - we setup an anon super for all volumes, so they all get their own
> dev_t, which is set properly for all of their children, see below
> 
> [root@test1244 btrfs-test]# stat .
>   File: `.'
>   Size: 20              Blocks: 8          IO Block: 4096   directory
> Device: 15h/21d Inode: 256         Links: 1
> Access: (0555/dr-xr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2010-12-03 15:35:41.931679393 -0500
> Modify: 2010-12-03 15:35:20.405679493 -0500
> Change: 2010-12-03 15:35:20.405679493 -0500
> 
> [root@test1244 btrfs-test]# stat foo
>   File: `foo'
>   Size: 12              Blocks: 0          IO Block: 4096   directory
> Device: 19h/25d Inode: 256         Links: 1
> Access: (0700/drwx------)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2010-12-03 15:35:17.501679393 -0500
> Modify: 2010-12-03 15:35:59.150680051 -0500
> Change: 2010-12-03 15:35:59.150680051 -0500
> 
> [root@test1244 btrfs-test]# stat foo/foobar 
>   File: `foo/foobar'
>   Size: 0               Blocks: 0          IO Block: 4096   regular empty file
> Device: 19h/25d Inode: 257         Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2010-12-03 15:35:59.150680051 -0500
> Modify: 2010-12-03 15:35:59.150680051 -0500
> Change: 2010-12-03 15:35:59.150680051 -0500
> 
> So as far as the user is concerned, everything should come out right.  Obviously
> we had to do the NFS trickery still because as far as VFS is concerned the
> subvolumes are all on the same mount.  So the question is this (and really this
> is directed at Christoph and Bruce and anybody else who may care), is this good
> enough, or do we want to have a seperate vfsmount for each subvolume?  Thanks,

For nfsd's purposes, we need to be able find out about filesystems in
two different ways:

	1. Lookup by filehandle: we need to be able to identify which
	subvolume we're dealing with from a filehandle.
	2. Lookup by path: we need to notice when we cross into a
	subvolume.

Looks like #1 already works.  Not #2: the current nfsd code just checks
for mountpoints.  We could modify nfsd to also check whether dev_t
changed each time it did a lookup.  I suppose it would work, though it's
annoying to have to do it just for the case of btrfs.

As far as I can tell, crossing into a subvolume is like crossing a
mountpoint in every way except for the lack of a separate vfsmount.  I'd
worry that the inconsistency will end up requiring more special cases
down the road, but I don't have any in mind.

--b.
