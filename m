Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751739AbdI0Mcv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 08:32:51 -0400
Date: Wed, 27 Sep 2017 14:31:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs: remove nr_async_submits and
 async_submit_draining
Message-ID: <20170927123117.GZ31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170907172222.20444-1-bo.li.liu@oracle.com>
 <20170907172222.20444-4-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170907172222.20444-4-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 07, 2017 at 11:22:22AM -0600, Liu Bo wrote:
> Now that we have the combo of flushing twice, which can make sure IO
> have started since the second flush will wait for page lock which
> won't be unlocked unless setting page writeback and queuing ordered
> extents, we don't need %async_submit_draining, %async_delalloc_pages
> and %nr_async_submits to tell whether IO have actually started.
> 
> Moreover, all the flushers in use are followed by functions that wait
> for ordered extents to complete, so %nr_async_submits, which tracks
> whether bio's async submit has made progress, doesn't really make
> sense.
> 
> However, %async_delalloc_pages is still required by shrink_delalloc()
> as that function doesn't flush twice in the normal case (just issues a
> writeback with WB_REASON_FS_FREE_SPACE).
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Patches like this are almost impossible to review just from the code.
This has runtime implications that we'd need to observe in real on
various workloads.

So, the patches "look good", but I did not try to forsee all the
scenarios where threads interact through the counters. I think it should
be safe to add them to for-next and give enough time to test them.

The performance has varied wildly in the last cycle(s) so it's hard to
get a baseline, other than another major release. I do expect changes in
performance characteristics but still hope it'll be the same on average.
