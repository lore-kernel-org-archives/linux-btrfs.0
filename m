From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: What to do about subvolumes?
Date: Fri, 3 Dec 2010 15:53:34 -0500
Message-ID: <20101203205334.GA25980@fieldses.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <20101201194404.GE17142@fieldses.org>
 <20101201195433.GE7021@localhost.localdomain>
 <20101201200007.GH17142@fieldses.org>
 <20101201200949.GG7021@localhost.localdomain>
 <20101202015207.GC2304@vrable.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
To: Michael Vrable <mvrable@cs.ucsd.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101202015207.GC2304@vrable.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 05:52:07PM -0800, Michael Vrable wrote:
> On Wed, Dec 01, 2010 at 03:09:52PM -0500, Josef Bacik wrote:
> >On Wed, Dec 01, 2010 at 03:00:08PM -0500, J. Bruce Fields wrote:
> >>I think you're already fine:
> >>
> >>	# mkdir TMP
> >>	# dd if=/dev/zero of=TMP-image bs=1M count=512
> >>	# mkfs.btrfs TMP-image
> >>	# mount -oloop TMP-image TMP/
> >>	# btrfs subvolume create sub-a
> >>	# btrfs subvolume create sub-b
> >>	../readdir-inos .
> >>	. 256 256
> >>	.. 256 4130609
> >>	sub-a 256 256
> >>	sub-b 257 256
> >>
> >>Where readdir-inos is my silly test program below, and the first
> >>number is from readdir, the second from stat.
> >>
> >
> >Heh as soon as I typed my email I went and actually looked at the
> >code, looks like for readdir we fill in the root id, which will be
> >unique, so hotdamn we are good and I don't have to use a stupid
> >incompat flag.  Thanks for checking that :),
> 
> Except, aren't the inode numbers within a filesystem and the
> sunbvolume tree IDs allocated out of separate namespaces?  I don't
> think there's anything preventing a file/directory from having an
> inode number that clashes with one of the snapshots.
> 
> In fact, this already happens in the example above: "." (inode 256
> in the root subvolume) and "sub-a" (subvolume ID 256).

Oof, yes, I overlooked that.

> (Though I still don't understand the semantics well enough to say
> whether we need all the inode numbers returned by readdir to be
> distinct.)

On normal mounts they're the number of the inode that was mounted over,
so normally they'd be unique across the parent filesystem.....  I don't
know if anything depends on that.

--b.
