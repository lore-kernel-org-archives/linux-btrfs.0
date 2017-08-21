Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18698 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753665AbdHUT5X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 15:57:23 -0400
Date: Mon, 21 Aug 2017 12:54:06 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make plug in writing meta blocks really work
Message-ID: <20170821195405.GC26279@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170818174207.21613-1-bo.li.liu@oracle.com>
 <20170821174800.GF23807@destiny>
 <20170821191416.GB26279@lim.localdomain>
 <20170821192329.GG23807@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170821192329.GG23807@destiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 03:23:30PM -0400, Josef Bacik wrote:
> On Mon, Aug 21, 2017 at 12:14:16PM -0700, Liu Bo wrote:
> > On Mon, Aug 21, 2017 at 01:48:01PM -0400, Josef Bacik wrote:
> > > On Fri, Aug 18, 2017 at 11:42:07AM -0600, Liu Bo wrote:
> > > > We have started plug in btrfs_write_and_wait_marked_extents() but the
> > > > generated IOs actually go to device's schedule IO list where the work
> > > > is doing in another task, thus the started plug doesn't make any
> > > > sense.
> > > > 
> > > > And since we wait for IOs immediately after writing meta blocks, it's
> > > > the same case as writing log tree, doing sync submit can merge more
> > > > IOs.
> > > > 
> > > 
> > > We're plugging when we do the per-device scheduled IO right?
> > 
> > Yes, we are.
> > 
> > > So we aren't
> > > really gaining anything by it being async.  Also we do a lot of work between the
> > > time that we start writing the marked extents for the tree-log and when we
> > > actually wait for them, so we really don't want to do a synchronous write out in
> > > that case.
> > 
> > Hmm, we've always been doing sync write for meta blocks of log
> > tree/log root tree, because of EXTENT_BIO_TREE_LOG (introduced in
> > commit de0022b9da616b95ea5b41eab32da825b0b5150f), and the commit log
> > claimed about 15% performance gaining in O_SYNC workloads (maybe we
> > need to re-evaluate it?).
> > 
> > > Instead move the sync_writers into write_and_wait_marked_extents.
> > > Thanks,
> > 
> > I'm OK with the change, but if sync write benefits both transaction
> > commit case and log tree case, we can unify them to %sync_writers
> > instead of a bio_flag.
> > 
> 
> Sigh you're right, I forgot about all of that.  Just delete the magic bio flags
> stuff and then this is fine.  Thanks,
>

OK, good to know it, thanks for the comments.

thanks,
-liubo
