From: "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: What to do about subvolumes?
Date: Fri, 3 Dec 2010 17:45:26 -0500
Message-ID: <20101203224525.GC12491@pad.home.fieldses.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <20101203214526.GA4508@localhost.localdomain>
 <20101203222756.GF23339@dastard>
 <1291415351-sup-4820@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291415351-sup-4820@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 03, 2010 at 05:29:24PM -0500, Chris Mason wrote:
> Excerpts from Dave Chinner's message of 2010-12-03 17:27:56 -0500:
> > On Fri, Dec 03, 2010 at 04:45:27PM -0500, Josef Bacik wrote:
> > > On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
> > > > Hello,
> > > > 
> > > > Various people have complained about how BTRFS deals with subvolumes recently,
> > > > specifically the fact that they all have the same inode number, and there's no
> > > > discrete seperation from one subvolume to another.  Christoph asked that I lay
> > > > out a basic design document of how we want subvolumes to work so we can hash
> > > > everything out now, fix what is broken, and then move forward with a design that
> > > > everybody is more or less happy with.  I apologize in advance for how freaking
> > > > long this email is going to be.  I assume that most people are generally
> > > > familiar with how BTRFS works, so I'm not going to bother explaining in great
> > > > detail some stuff.
> > > > 
> > ....
> > > > are things that cannot be fixed now.  Some of these changes will require
> > > > incompat format changes, but it's either we fix it now, or later on down the
> > > > road when BTRFS starts getting used in production really find out how many
> > > > things our current scheme breaks and then have to do the changes then.  Thanks,
> > > > 
> > > 
> > > So now that I've actually looked at everything, it looks like the semantics are
> > > all right for subvolumes
> > > 
> > > 1) readdir - we return the root id in d_ino, which is unique across the fs
> > > 2) stat - we return 256 for all subvolumes, because that is their inode number
> > > 3) dev_t - we setup an anon super for all volumes, so they all get their own
> > > dev_t, which is set properly for all of their children, see below
> > 
> > A property of NFS fileshandles is that they must be stable across
> > server reboots. Is this anon dev_t used as part of the NFS
> > filehandle and if so how can you guarantee that it is stable?
> 
> It isn't today, that's something we'll have to address.

We're using statfs64.fs_fsid for this; I believe that's both stable
across reboots and distinguishes between subvolumes, so that's OK.

(That said, since fs_fsid doesn't work for other filesystems, we depend
on an explicit check for a filesystem type of "btrfs", which is
awful--btrfs won't always be the only filesystem that wants to do this
kind of thing, etc.)

--b.
