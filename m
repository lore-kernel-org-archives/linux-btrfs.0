Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36589 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932893AbdDEN1i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Apr 2017 09:27:38 -0400
Date: Wed, 5 Apr 2017 15:26:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: delete unused member nobarriers
Message-ID: <20170405132643.GG4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170331112608.32478-1-anand.jain@oracle.com>
 <20170403120639.GS4781@twin.jikos.cz>
 <735d9ef3-c3f2-2a2d-af7e-b65a8980e423@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <735d9ef3-c3f2-2a2d-af7e-b65a8980e423@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 04, 2017 at 06:59:19PM +0800, Anand Jain wrote:
> 
> 
> On 04/03/2017 08:06 PM, David Sterba wrote:
> > Please update the changelog to say why it's ok to remove it, eg. the
> > commit that removed the last user.
> >
> > commit b25de9d6da49b1a8760a89672283128aa8c78345
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Fri Apr 24 21:41:01 2015 +0200
> >
> >     block: remove BIO_EOPNOTSUPP
> 
>   Ah. I should have search the commit log. sorry about that.
> 
> 
> IMO, there is a bug in generic_make_request_checks() in which
> it should rather return EOPNOTSUPP, instead of EIO if QUEUE_FLAG_WC
> is not supported.

I think it works as intended, ie. it's not a bug. The code has been
added to avoid reporting an error code in the mentioned case. See
generic_make_request that would exit, or need to handle EOPNOTSUPP each
time. If you still think this is a bug, please report it to the
blocklayer maintainers.

> ------------------------------------------------
> 1853 static noinline_for_stack bool
> 1854 generic_make_request_checks(struct bio *bio)
> 1855 {
> ::
> 
> 1892         /*
> 1893          * Filter flush bio's early so that make_request based
> 1894          * drivers without flush support don't have to worry
> 1895          * about them.
> 1896          */
> 1897         if ((bio->bi_opf & (REQ_PREFLUSH | REQ_FUA)) &&
> 1898             !test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
> 1899                 bio->bi_opf &= ~(REQ_PREFLUSH | REQ_FUA);
> 1900                 if (!nr_sectors) {
> 1901                         err = 0;
> 1902                         goto end_io; <- this should goto  not_supported
> 1903                 }
> 1904         }
> 
> ::
> 
> 1946 not_supported:
> 1947         err = -EOPNOTSUPP;
> ------------------------------------------------
> 
> 
>   Pls ignore this patch.
> 
>   I have submitted
> [PATCH] btrfs: check if the device is flush capable
> 
>   which will remain unaffected by the above bug/not-a-bug
>   in the blk core code.
