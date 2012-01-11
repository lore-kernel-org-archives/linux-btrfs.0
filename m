From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Warning: bad fsid on block 20971520
Date: Wed, 11 Jan 2012 17:54:39 -0500
Message-ID: <20120111225439.GL2179@shiny>
References: <20120111154621.GX7322@twin.jikos.cz>
 <20120111163714.GE2179@shiny>
 <20120111223434.GY7322@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120111223434.GY7322@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 11, 2012 at 11:34:34PM +0100, David Sterba wrote:
> On Wed, Jan 11, 2012 at 11:37:14AM -0500, Chris Mason wrote:
> > I've been seeing this as well.  It's new with 3.2, and I haven't yet
> > been able to track it down.
> > 
> > The first thing that happens when we mount the FS is a block layer
> > invalidate, and that must be dropping the write.
> > 
> > It's also possible (but very unlikely) that mkfs.btrfs is neglecting to
> > write that block.
> > 
> > Do you have a reliable way to reproduce?  If so, can you try with a much
> > older mkfs.btrfs.
> 
> I built mkfs from v0.19 and let 209 loop again, the error appeared 6x
> during 3 hours, the last 5 occurences within 10 minutes.  Should I try
> even older mkfs?

Nah, I'd try the latest mkfs on a 3.0 kernel.  I think its a change to
the block device invalidate code that happens on mount.

-chris
