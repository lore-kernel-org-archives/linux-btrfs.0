From: Chris Mason <chris.mason@oracle.com>
Subject: Re: cp --reflink with Btrfs
Date: Thu, 28 Jan 2010 16:09:06 -0500
Message-ID: <20100128210906.GC30822@think>
References: <20100127105322.GA1983@mails.so.argh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
To: Andreas Barth <aba@not.so.argh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100127105322.GA1983@mails.so.argh.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 27, 2010 at 11:53:22AM +0100, Andreas Barth wrote:
> * Sage Weil (sage@newdream.net) [091216 17:55]:
> > On Wed, 16 Dec 2009, Li Dongyang wrote:
> > 
> > > Have a look at line 998, ioctl.c, inside btrfs_ioctl_clone(),
> > > the src->i_size(the size of the testfile created by touch) is just 0, and this 
> > > will cause btrfs_ioctl_clone just return -EINVAL.
> > > I'm not sure if it makes sense to clone a file which actually doesn't have any 
> > > data extents.
> > 
> > Probably not, but it seems more consistent to return success instead than 
> > -EINVAL.  Requiring the caller to check and special case empty files isn't 
> > very friendly...
> 
> 
> Actually it makes lots of sense if trying to e.g. cow-copy an chroot
> on an buildd, and there are some empty files inside of the linux
> installation (which normally just are).
> 
> Can I hope on getting the patch (or another patch) incorporated into
> the kernel?

In this case the application is responsible for duplicating the file.
The clone ioctl doesn't actually clone any of the file metadata or
anything else.

-chris

