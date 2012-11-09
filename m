Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43937 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2KIOpc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Nov 2012 09:45:32 -0500
Date: Fri, 9 Nov 2012 22:45:16 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/26] Btrfs: add a new source file with device replace
 code
Message-ID: <20121109144512.GC6347@gmail.com>
References: <cover.1352217243.git.sbehrens@giantdisaster.de>
 <4520a248e2bcf0493b35673ea4cac2d4e0757e08.1352217243.git.sbehrens@giantdisaster.de>
 <20121108145038.GB3034@gmail.com>
 <509BEAD4.8070309@giantdisaster.de>
 <20121109004400.GB5172@gmail.com>
 <509CD8A5.5000901@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <509CD8A5.5000901@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 09, 2012 at 11:19:17AM +0100, Stefan Behrens wrote:
> On Fri, 9 Nov 2012 08:44:01 +0800, Liu Bo wrote:
> > On Thu, Nov 08, 2012 at 06:24:36PM +0100, Stefan Behrens wrote:
> >> On Thu, 8 Nov 2012 22:50:47 +0800, Liu Bo wrote:
> >>> On Tue, Nov 06, 2012 at 05:38:33PM +0100, Stefan Behrens wrote:
> >>>> +	trans = btrfs_start_transaction(root, 0);
> >>>
> >>> why a start_transaction here?  Any reasons?
> >>> (same question also for some other places)
> >>>
> >>
> >> Without this transaction, there is outstanding I/O which is not flushed.
> >> Pending writes that go only to the old disk need to be flushed before
> >> the mode is switched to write all live data to the source disk and to
> >> the target disk as well. The copy operation that is part of the scrub
> >> code works on the commit root for performance reasons. Every write
> >> request that is performed after the commit root is established needs to
> >> go to both disks. Those requests that already have the bdev assigned
> >> (i.e., btrfs_map_bio() was already called) cannot be duplicated anymore
> >> to write to the new disk as well.
> >>
> >> btrfs_dev_replace_finishing() looks similar and goes through a
> >> transaction commit between the steps where the bdev in the mapping tree
> >> is swapped and the step when the old bdev is freed. Otherwise the bdev
> >> would be accessed after being freed.
> >>
> > 
> > I see, if you're only about to flush metadata, why not join a transaction?
> 
> btrfs_join_transaction() would delay the current transaction and enforce
> that the current transaction is used and not a new one.
> btrfs_start_transaction() would use either the current transaction, or a
> new one. It is less interfering.

hmm...btrfs_start_transaction() would not use the current transaction unless
you're still in the same task, ie. current->journal_info remains unchanged,
otherwise it will be blocked by the current transaction(wait_current_trans()).

If there are several btrfs_start_transaction() being blocked, after the current
one's commit, one of them will allocate a new transaction, and the rest can join it.

But btrfs_join_transaction will join the current as much as possible.

And since here we don't do any reservation and seems to just update chunk/device
tree(which will use global block rsv directly), I perfer btrfs_join_transaction().

thanks,
liubo

> 
> Since in dev-replace.c it is not required to enforce that a current
> transaction is joined, btrfs_start_transaction() is the one to choose
> here, as I understood it.
> 
> But that's an interesting topic and I would appreciate to get a definite
> rule which one to choose when.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
