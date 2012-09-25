Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:53908 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab2IYRCm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 13:02:42 -0400
Date: Tue, 25 Sep 2012 13:02:39 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: David Sterba <dave@jikos.cz>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ENOSPC design issues
Message-ID: <20120925170239.GA2328@localhost.localdomain>
References: <20120920190306.GG2272@localhost.localdomain>
 <20120925164335.GZ14582@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120925164335.GZ14582@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 10:43:36AM -0600, David Sterba wrote:
> On Thu, Sep 20, 2012 at 03:03:06PM -0400, Josef Bacik wrote:
> > I'm going to look at fixing some of the performance issues that crop up because
> > of our reservation system.  Before I go and do a whole lot of work I want some
> > feedback.  I've done a brain dump here
> > https://btrfs.wiki.kernel.org/index.php/ENOSPC
> 
> Thanks for writing it down, much appreciated.
> 
> My first and probably naive approach is described in the page, quoting
> here:
> 
>  "Attempt to address how to flush less stated below. The
>  over-reservation of a 4k block can go up to 96k as the worst case
>  calculation (see above). This accounts for splitting the full tree path
>  from 8th level root down to the leaf plus the node splits. My question:
>  how often do we need to go up to the level N+1 from current level N?
>  for levels 0 and 1 it may happen within one transaction, maybe not so
>  often for level 2 and with exponentially decreasing frequency for the
>  higher levels. Therefore, is it possible to check the tree level first
>  and adapt the calculation according to that? Let's say we can reduce
>  the 4k reservation size from 96k to 32k on average (for a many-gigabyte
>  filesystem), thus increasing the space available for reservations by
>  some factor. The expected gain is less pressure to the flusher because
>  more reservations will succeed immediately.
>  The idea behind is to make the initial reservation more accurate to
>  current state than blindly overcommitting by some random factor (1/2).
>  Another hint to the tree root level may be the usage of the root node:
>  eg. if the root is less than half full, splitting will not happen
>  unless there are K concurrent reservations running where K is
>  proportional to overwriting the whole subtree (same exponential
>  decrease with increasing level) and this will not be possible within
>  one transaction or there will not be enough space to satisfy all
>  reservations. (This attempts to fine-tune the currently hardcoded level
>  8 up to the best value). The safe value for the level in the
>  calculations would be like N+1, ie. as if all the possible splits
>  happen with respect to current tree height."
> 
> implemented as follows on top of next/master, in short:
> * disable overcommit completely
> * do the optimistically best guess for the metadata and reserve only up
>   to the current tree height
> 

So I had tried to do this before, the problem is when height changes our reserve
changes.  So for things like delalloc we say we have X number of extents and we
reserve that much space, but then when we run delalloc we re-calculate the
metadata size for X number extents we've removed and that number could come out
differently since the height of the tree would have changed.  One thing we could
do is to store the actual reservation with the extent in the io_tree, but I
think we already use the private for something else so we'd have to add it
somewhere else.  Thanks,

Josef
