Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:49267 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab2JHPEW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 11:04:22 -0400
Date: Mon, 8 Oct 2012 11:04:19 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121008150419.GE4132@shiny>
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121008145730.GD24071@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 08:57:30AM -0600, Richard W.M. Jones wrote:
> On Mon, Oct 08, 2012 at 10:27:57AM -0400, Chris Mason wrote:
> > On Mon, Oct 08, 2012 at 08:16:42AM -0600, Richard W.M. Jones wrote:
> > > 
> > > I'm tracking this bug here:
> > > 
> > > https://bugzilla.redhat.com/show_bug.cgi?id=863978
> > > 
> > > Since approx. last week I'm seeing lots of failures in btrfs.  The
> > > common factor seems to be that the filesystem is created (mkfs.btrfs
> > > /dev/sda1) and then it is immediately used -- eg.  mounted or some
> > > btrfs subtool is run on it.  There is no pause or sync between the
> > > operations.
> > 
> > This was a problem on older btrfs-progs, but this commit:
> > 
> > btrfs-progs-0.19.20120817git043a639-1.fc19.i686
> > 
> > (043a639) has long had the fixes to flush things after mkfs.  Is there
> > any change the guest you're testing had an ancient progs on it?
> 
> We have a couple of guests where this fails.  One has
> btrfs-progs-0.19.20120817git043a639-1.fc19.i686.  The other has
> btrfs-progs-0.19-20.fc18 which appears to be based on
> btrfs-progs-0.19.20120817git043a639.tar.bz2 plus some upstream
> patches.
> 
> What is the commit which we need?  I can't see anything related to
> this in the btrfs-progs git log.

Sorry, I was remembering wrong.  I fixed this up in the kernel by
running invalidate_bdev during mount.  I just double checked and the
invalidates look right, so something strange must be going on.

If it is possible to reproduce this reliably, could you please check and
see if syncs do fix it?  We saw this often with xfstests in the past,
but haven't seen it since the invalidates were added.

-chris
