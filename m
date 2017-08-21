Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35205 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753222AbdHUTXc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 15:23:32 -0400
Received: by mail-qt0-f182.google.com with SMTP id x36so18821293qtx.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 12:23:31 -0700 (PDT)
Date: Mon, 21 Aug 2017 15:23:30 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make plug in writing meta blocks really work
Message-ID: <20170821192329.GG23807@destiny>
References: <20170818174207.21613-1-bo.li.liu@oracle.com>
 <20170821174800.GF23807@destiny>
 <20170821191416.GB26279@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170821191416.GB26279@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 12:14:16PM -0700, Liu Bo wrote:
> On Mon, Aug 21, 2017 at 01:48:01PM -0400, Josef Bacik wrote:
> > On Fri, Aug 18, 2017 at 11:42:07AM -0600, Liu Bo wrote:
> > > We have started plug in btrfs_write_and_wait_marked_extents() but the
> > > generated IOs actually go to device's schedule IO list where the work
> > > is doing in another task, thus the started plug doesn't make any
> > > sense.
> > > 
> > > And since we wait for IOs immediately after writing meta blocks, it's
> > > the same case as writing log tree, doing sync submit can merge more
> > > IOs.
> > > 
> > 
> > We're plugging when we do the per-device scheduled IO right?
> 
> Yes, we are.
> 
> > So we aren't
> > really gaining anything by it being async.  Also we do a lot of work between the
> > time that we start writing the marked extents for the tree-log and when we
> > actually wait for them, so we really don't want to do a synchronous write out in
> > that case.
> 
> Hmm, we've always been doing sync write for meta blocks of log
> tree/log root tree, because of EXTENT_BIO_TREE_LOG (introduced in
> commit de0022b9da616b95ea5b41eab32da825b0b5150f), and the commit log
> claimed about 15% performance gaining in O_SYNC workloads (maybe we
> need to re-evaluate it?).
> 
> > Instead move the sync_writers into write_and_wait_marked_extents.
> > Thanks,
> 
> I'm OK with the change, but if sync write benefits both transaction
> commit case and log tree case, we can unify them to %sync_writers
> instead of a bio_flag.
> 

Sigh you're right, I forgot about all of that.  Just delete the magic bio flags
stuff and then this is fine.  Thanks,

Josef
