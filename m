From: Andreas Barth <aba@not.so.argh.org>
Subject: Re: cp --reflink with Btrfs
Date: Wed, 27 Jan 2010 11:53:22 +0100
Message-ID: <20100127105322.GA1983@mails.so.argh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

* Sage Weil (sage@newdream.net) [091216 17:55]:
> On Wed, 16 Dec 2009, Li Dongyang wrote:
> 
> > Have a look at line 998, ioctl.c, inside btrfs_ioctl_clone(),
> > the src->i_size(the size of the testfile created by touch) is just 0, and this 
> > will cause btrfs_ioctl_clone just return -EINVAL.
> > I'm not sure if it makes sense to clone a file which actually doesn't have any 
> > data extents.
> 
> Probably not, but it seems more consistent to return success instead than 
> -EINVAL.  Requiring the caller to check and special case empty files isn't 
> very friendly...


Actually it makes lots of sense if trying to e.g. cow-copy an chroot
on an buildd, and there are some empty files inside of the linux
installation (which normally just are).

Can I hope on getting the patch (or another patch) incorporated into
the kernel?



Cheers,
Andi
