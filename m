Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46752 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab2KIAoM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2012 19:44:12 -0500
Date: Fri, 9 Nov 2012 08:44:01 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/26] Btrfs: add a new source file with device replace
 code
Message-ID: <20121109004400.GB5172@gmail.com>
Reply-To: bo.li.liu@oracle.com
References: <cover.1352217243.git.sbehrens@giantdisaster.de>
 <4520a248e2bcf0493b35673ea4cac2d4e0757e08.1352217243.git.sbehrens@giantdisaster.de>
 <20121108145038.GB3034@gmail.com>
 <509BEAD4.8070309@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <509BEAD4.8070309@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 08, 2012 at 06:24:36PM +0100, Stefan Behrens wrote:
> On Thu, 8 Nov 2012 22:50:47 +0800, Liu Bo wrote:
> > On Tue, Nov 06, 2012 at 05:38:33PM +0100, Stefan Behrens wrote:
[...]
> >> +	btrfs_dev_replace_unlock(dev_replace);
> >> +
> >> +	btrfs_wait_ordered_extents(root, 0);
> >> +
> >> +	/* force writing the updated state information to disk */
> >> +	trans = btrfs_start_transaction(root, 0);
> > 
> > why a start_transaction here?  Any reasons?
> > (same question also for some other places)
> > 
> 
> Without this transaction, there is outstanding I/O which is not flushed.
> Pending writes that go only to the old disk need to be flushed before
> the mode is switched to write all live data to the source disk and to
> the target disk as well. The copy operation that is part of the scrub
> code works on the commit root for performance reasons. Every write
> request that is performed after the commit root is established needs to
> go to both disks. Those requests that already have the bdev assigned
> (i.e., btrfs_map_bio() was already called) cannot be duplicated anymore
> to write to the new disk as well.
> 
> btrfs_dev_replace_finishing() looks similar and goes through a
> transaction commit between the steps where the bdev in the mapping tree
> is swapped and the step when the old bdev is freed. Otherwise the bdev
> would be accessed after being freed.
> 

I see, if you're only about to flush metadata, why not join a transaction?

thanks,
liubo
