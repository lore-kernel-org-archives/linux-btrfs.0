From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Online resize vs ENOSPC
Date: Tue, 10 Mar 2009 09:37:34 -0400
Message-ID: <1236692254.23800.6.camel@think.oraclecorp.com>
References: <20090309103141.GA5335@vlad.carfax.org.uk>
	 <20090309143501.GD6698@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090309143501.GD6698@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-03-09 at 14:35 +0000, Hugo Mills wrote:
> On Mon, Mar 09, 2009 at 10:31:41AM +0000, Hugo Mills wrote:
> >    After an online resize, the filesystem reports its new size, but
> > still runs out of space at the old size:
> [...]
> >    Unmounting and remounting the filesystem seems to make the new
> > space available for use again.
> > 
> >    This is the second time I've had this happen to me now, so it seems
> > to be more-or-less reproducible, although I haven't deliberately tried
> > to trigger the behaviour yet.
> 
>    Just to confirm, I can indeed reproduce it trivially:
> 

Ok, thanks for tracking this down.  I see the bug and will send out a
fix shortly for you to try.

-chris


