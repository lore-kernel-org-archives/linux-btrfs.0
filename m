Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdKUOCy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 09:02:54 -0500
Date: Tue, 21 Nov 2017 15:00:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix list_add corruption and soft lockups in fsync
Message-ID: <20171121140058.GL3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171113175724.7302-1-bo.li.liu@oracle.com>
 <20171120173434.GD3553@twin.jikos.cz>
 <20171120173725.GA29829@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171120173725.GA29829@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 20, 2017 at 10:37:25AM -0700, Liu Bo wrote:
> > > [1]: https://www.spinics.net/lists/linux-btrfs/msg65308.html
> > > "btrfs list corruption and soft lockups while testing writeback error handling"
> > > 
> > 
> > Fixes: 8407f553268a4611f254 ("Btrfs: fix data corruption after fast fsync and writeback error")
> > 
> > you can also add the commit author to CC.
> 
> Hmm, somehow I thought ctx->list hasn't been added at that time, but
> looks like you're right.

The commit added

+       if (ordered_io_err) {
+               ctx->io_err = -EIO;
+               return 0;
+       }
+

which you fix.

> > > --- a/fs/btrfs/file.c
> > > +++ b/fs/btrfs/file.c
> > > @@ -2241,6 +2241,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> > >  	if (ctx.io_err) {
> > >  		btrfs_end_transaction(trans);
> > >  		ret = ctx.io_err;
> > > +		ASSERT(list_empty(&ctx.list));
> > 
> > Please move that to the label 'out', so all exit paths can catch the
> > problem.
> >
> 
> 'out' can't be used as we can goto 'out' before ctx is initialized,
> I'll add a new label 'out_ctx' in a separate patch (Feel free to fold
> them into one if you prefer).

Would be better to initialize ctx->list at the beginning and then always do the
list_empty check, instead of selectively jumping to out or out_ctx.
