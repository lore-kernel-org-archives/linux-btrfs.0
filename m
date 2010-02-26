From: Chris Mason <chris.mason@oracle.com>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 14:09:15 -0500
Message-ID: <20100226190915.GI12841@think>
References: <20100226175927.GG12841@think>
 <20100226181157.50F73414B9@viridian.itc.virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226181157.50F73414B9@viridian.itc.virginia.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2010 at 01:11:57PM -0500, Bill Pemberton wrote:
> > 
> > Does the array have any kind of writeback cache?
> > 
> 
> Yes, the array has a writeback cache.

Ok, this would be my top suspect then, especially if it had to be
powered off to reset it.  The errors you sent look like some IO just
didn't happen, which the btrfs code goes to great length to
detect and complain about.

Going back to the errors:

parent transid verify failed on 20971520 wanted 206856 found 214247
parent transid verify failed on 20971520 wanted 206856 found 214247
parent transid verify failed on 20971520 wanted 206856 found 214247
btrfsck: disk-io.c:723: open_ctree_fd: Assertion `!(!chunk_root->node)' failed.
Aborted (core dumped)

You're actually hitting this very early in the mount.  We read in the
super block and then we read all the tree roots it points to.  Each
pointer includes the generation number it expects to find.

The generation number is similar to a version counter.  Each transaction
that updates that block increments the generation number.

So, the super block says: go read block number 20971520, and it is
supposed to be generation 206856.  Instead we find: 214247, which is
much newer.

The most likely cause of this is that a write to either the super block
or block 20971520 went to the writeback cache but never made it to the
drive.

My would be the super block, it is updated more often and so more likely
to get stuck in the array's cache.

-chris

