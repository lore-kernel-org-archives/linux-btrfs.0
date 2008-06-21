From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Sat, 21 Jun 2008 03:27:30 -0400
Message-ID: <20080621072730.GA20871@infradead.org>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com> <485B3EC5.8090006@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming <cmm@us.ibm.com>, linux-btrfs@vger.kernel.org
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <485B3EC5.8090006@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 19, 2008 at 10:23:17PM -0700, Zach Brown wrote:
> 
> > +#define BTRFS_IOC_NODATACOW _IO(BTRFS_IOCTL_MAGIC, 13)
> > +#define BTRFS_IOC_DATACOW _IO(BTRFS_IOCTL_MAGIC, 14)
> > +#define BTRFS_IOC_NODATASUM _IO(BTRFS_IOCTL_MAGIC, 15)
> > +#define BTRFS_IOC_DATASUM _IO(BTRFS_IOCTL_MAGIC, 16)
> 
> Hmm.  Do we really want 4 different ioctl commands to turn 2 features on
> and off?  Surely we could have 1 ioctl which updates a bitfield?  Or a
> ioctl that takes an explicit feature enum argument and a boolean which
> indicates that it should be enabled or not?

The best interface for per-file boolean flags
FS_IOC_SETFLAGS/FS_IOC_GETFLAGS ioctls which would fir this really
nicely.

> (And is ioctl the right interface for this?  maybe it should be xattr
> ops in some defined btrfs string namespace?  I'm just making this up.  I
> feel the the lack of a single comment in the patch, while in keeping
> with the existing precedent in btrfs, leaves a lot of room for wild
> speculation :))

Synthetic xattrs are a really utterly horrible interface.  Xattrs on
disk are nice and simple, but the Linux invention of making some up
on the fly, starting with the Posix ACL interface makes the
implementation not just utterly complicated but also confuses backup
programs.

