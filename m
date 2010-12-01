From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 15:16:55 -0500
Message-ID: <20101201201655.GJ17142@fieldses.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <20101201194404.GE17142@fieldses.org>
 <20101201195433.GE7021@localhost.localdomain>
 <20101201200007.GH17142@fieldses.org>
 <20101201200949.GG7021@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201200949.GG7021@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 03:09:52PM -0500, Josef Bacik wrote:
> On Wed, Dec 01, 2010 at 03:00:08PM -0500, J. Bruce Fields wrote:
> > On Wed, Dec 01, 2010 at 02:54:33PM -0500, Josef Bacik wrote:
> > > Oh well crud, I was hoping that I could leave the inode numbers as 256 for
> > > everything, but I forgot about readdir.  So the inode item in the parent would
> > > have to have a unique inode number that would get spit out in readdir, but then
> > > if we stat'ed the directory we'd get 256 for the inode number.  Oh well,
> > > incompat flag it is then.
> > 
> > I think you're already fine:
> > 
> > 	# mkdir TMP
> > 	# dd if=/dev/zero of=TMP-image bs=1M count=512
> > 	# mkfs.btrfs TMP-image
> > 	# mount -oloop TMP-image TMP/
> > 	# btrfs subvolume create sub-a
> > 	# btrfs subvolume create sub-b
> > 	../readdir-inos .
> > 	. 256 256
> > 	.. 256 4130609
> > 	sub-a 256 256
> > 	sub-b 257 256
> > 
> > Where readdir-inos is my silly test program below, and the first number is from
> > readdir, the second from stat.
> >
> 
> Heh as soon as I typed my email I went and actually looked at the code, looks
> like for readdir we fill in the root id, which will be unique, so hotdamn we are
> good and I don't have to use a stupid incompat flag.  Thanks for checking that
> :),

My only complaint was just about how you said this:

	"When you create a subvolume, the directory inode that is
	created in the parent subvolume has the inode number of 256"

If you revise that you might want to clarify.  (Maybe "Every subvolume
has a root directory inode with inode number 256"?)

The way you've stated it sounds like you're talking about the
readdir-returned number, which would normally come from the inode that
has been covered up by the mount, and which really is an inode in the
parent filesystem....

--b.
