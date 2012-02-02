From: Chris Mason <chris.mason@oracle.com>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache
 off?
Date: Thu, 2 Feb 2012 07:42:41 -0500
Message-ID: <20120202124241.GW16796@shiny>
References: <20120130003754.GD4380@merlins.org>
 <20120201175624.GE16796@shiny>
 <20120202032345.GB31903@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120202032345.GB31903@merlins.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 01, 2012 at 07:23:45PM -0800, Marc MERLIN wrote:
> On Wed, Feb 01, 2012 at 12:56:24PM -0500, Chris Mason wrote:
> > > Second, I was wondering if anyone is running btrfs over dmcrypt on an SSD
> > > and what the performance is like with write cache turned off (I'm actually
> > > not too sure what the impact is for SSDs considering that writing to flash
> > > can actually be slower than writing to a hard drive).
> > 
> > Performance without the cache on is going to vary wildly from one SSD to
> > another.  Some really need it to give them nice fat writes while others
> > do better on smaller writes.  It's best to just test yours and see.
> > 
> > With a 3.2 kernel (it really must be 3.2 or higher), both btrfs and dm
> > are doing the right thing for barriers.
> 
> Thanks for the answer.
> Can you confirm that I still must disable write cache on the SSD to avoid
> corruption with btrfs on top of dmcrypt, or is there a chance that it just
> works now?

No, with 3.2 or higher it is expected to work.  dm-crypt is doing the
barriers correctly and as of 3.2 btrfs is sending them down correctly.

-chris

