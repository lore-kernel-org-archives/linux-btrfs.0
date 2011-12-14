From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Error handling: How to "lose" a transaction
Date: Tue, 13 Dec 2011 19:13:19 -0500
Message-ID: <20111214001319.GX31158@shiny>
References: <4EE7C7F2.2080905@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Fasheh <mfasheh@suse.de>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE7C7F2.2080905@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 13, 2011 at 04:47:30PM -0500, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> Hi Chris -
> 
> I'm starting to dig into the fun part of error handling and
> btrfs_commit_transaction is a minefield right now.
> 
> I've been thinking about how I would go about recovering from a
> serious error like an -EIO while writing out or an -ENOMEM in a deep
> part of the code that it's prohibitively expensive to recover from.
> Mostly I'm looking for the best way to make calling btrfs_std_error()
> be functionally equivalent to killing the power on the disk. We
> already block off new writers, but that's obviously nowhere near
> enough. We could have an open transaction floating around, uncommitted
> transactions queued, and then an unrecoverable error hits, forcing us
> to shut it all down.
> 
> It seems to me that that a similar method of recovery that I wrote for
> reiserfs can be used here as well. Am I understanding correctly that
> if I go through the motions of committing the transaction *except* for
> updating the tree roots, or maybe even doing that but declining to
> write the superblocks out, that the transaction essentially doesn't
> exist on disk? Including the allocations? The in-memory representation
> will not match what's on disk, but that's what happens with every file
> system in RO-failure mode. With CoW even for data, data is essentially
> frozen in time as well. (I suppose with nodatacow that's not true, but
> that's for another day.)

Hi Jeff,

Thanks for taking another pass at this.

It should be possible to just skip the step where we update the roots in
the super and you'll keep a fully consistent FS on disk.  The only rule
would be that you're not allowed to take a block that we've freed in the
aborted transaction and reuse it.

-chris
