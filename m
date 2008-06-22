From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Sun, 22 Jun 2008 10:10:06 -0400
Message-ID: <1214143806.10187.538.camel@think.oraclecorp.com>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com>
	 <485B3EC5.8090006@oracle.com>  <20080621072730.GA20871@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zach Brown <zach.brown@oracle.com>, Mingming <cmm@us.ibm.com>,
	linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080621072730.GA20871@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2008-06-21 at 03:27 -0400, Christoph Hellwig wrote:
> On Thu, Jun 19, 2008 at 10:23:17PM -0700, Zach Brown wrote:
> > 
> > > +#define BTRFS_IOC_NODATACOW _IO(BTRFS_IOCTL_MAGIC, 13)
> > > +#define BTRFS_IOC_DATACOW _IO(BTRFS_IOCTL_MAGIC, 14)
> > > +#define BTRFS_IOC_NODATASUM _IO(BTRFS_IOCTL_MAGIC, 15)
> > > +#define BTRFS_IOC_DATASUM _IO(BTRFS_IOCTL_MAGIC, 16)
> > 
> > Hmm.  Do we really want 4 different ioctl commands to turn 2 features on
> > and off?  Surely we could have 1 ioctl which updates a bitfield?  Or a
> > ioctl that takes an explicit feature enum argument and a boolean which
> > indicates that it should be enabled or not?
> 
> The best interface for per-file boolean flags
> FS_IOC_SETFLAGS/FS_IOC_GETFLAGS ioctls which would fir this really
> nicely.
> 
> > (And is ioctl the right interface for this?  maybe it should be xattr
> > ops in some defined btrfs string namespace?  I'm just making this up.  I
> > feel the the lack of a single comment in the patch, while in keeping
> > with the existing precedent in btrfs, leaves a lot of room for wild
> > speculation :))
> 
> Synthetic xattrs are a really utterly horrible interface.  Xattrs on
> disk are nice and simple, but the Linux invention of making some up
> on the fly, starting with the Posix ACL interface makes the
> implementation not just utterly complicated but also confuses backup
> programs.

The idea is that backup programs already know how to do xattrs and can
easily be changed to preserve them.  Every ioctl interface we
create/make up has to be handed coded into the backup program.

I know xattrs are ugly, but we need to weigh the cost of the perfect
interface with the availability of a common one.  Dave Chinner had
talked about using xattrs to control file behavior in XFS as well, not
sure if that ever happened.

-chris


