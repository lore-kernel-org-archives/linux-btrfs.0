Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab2JHO5k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 10:57:40 -0400
Date: Mon, 8 Oct 2012 15:57:30 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121008145730.GD24071@rhmail.home.annexia.org>
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121008142757.GB4132@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 10:27:57AM -0400, Chris Mason wrote:
> On Mon, Oct 08, 2012 at 08:16:42AM -0600, Richard W.M. Jones wrote:
> > 
> > I'm tracking this bug here:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=863978
> > 
> > Since approx. last week I'm seeing lots of failures in btrfs.  The
> > common factor seems to be that the filesystem is created (mkfs.btrfs
> > /dev/sda1) and then it is immediately used -- eg.  mounted or some
> > btrfs subtool is run on it.  There is no pause or sync between the
> > operations.
> 
> This was a problem on older btrfs-progs, but this commit:
> 
> btrfs-progs-0.19.20120817git043a639-1.fc19.i686
> 
> (043a639) has long had the fixes to flush things after mkfs.  Is there
> any change the guest you're testing had an ancient progs on it?

We have a couple of guests where this fails.  One has
btrfs-progs-0.19.20120817git043a639-1.fc19.i686.  The other has
btrfs-progs-0.19-20.fc18 which appears to be based on
btrfs-progs-0.19.20120817git043a639.tar.bz2 plus some upstream
patches.

What is the commit which we need?  I can't see anything related to
this in the btrfs-progs git log.

I should note this was all working fine until very recently (under 5
days ago).  Nothing has changed in btrfs-progs in Fedora for a few
months.  Could this be related to a kernel change?

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://et.redhat.com/~rjones/virt-df/
