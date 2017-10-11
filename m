Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42795 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbdJKRuz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 13:50:55 -0400
Date: Wed, 11 Oct 2017 10:49:14 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs: remove nr_async_submits and
 async_submit_draining
Message-ID: <20171011164914.GA16979@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20170907172222.20444-1-bo.li.liu@oracle.com>
 <20170907172222.20444-4-bo.li.liu@oracle.com>
 <20170927123117.GZ31640@twin.jikos.cz>
 <20171011172032.GY3521@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171011172032.GY3521@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 07:20:32PM +0200, David Sterba wrote:
> On Wed, Sep 27, 2017 at 02:31:17PM +0200, David Sterba wrote:
> > On Thu, Sep 07, 2017 at 11:22:22AM -0600, Liu Bo wrote:
> > > Now that we have the combo of flushing twice, which can make sure IO
> > > have started since the second flush will wait for page lock which
> > > won't be unlocked unless setting page writeback and queuing ordered
> > > extents, we don't need %async_submit_draining, %async_delalloc_pages
> > > and %nr_async_submits to tell whether IO have actually started.
> > > 
> > > Moreover, all the flushers in use are followed by functions that wait
> > > for ordered extents to complete, so %nr_async_submits, which tracks
> > > whether bio's async submit has made progress, doesn't really make
> > > sense.
> > > 
> > > However, %async_delalloc_pages is still required by shrink_delalloc()
> > > as that function doesn't flush twice in the normal case (just issues a
> > > writeback with WB_REASON_FS_FREE_SPACE).
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > 
> > Patches like this are almost impossible to review just from the code.
> > This has runtime implications that we'd need to observe in real on
> > various workloads.
> > 
> > So, the patches "look good", but I did not try to forsee all the
> > scenarios where threads interact through the counters. I think it should
> > be safe to add them to for-next and give enough time to test them.
> > 
> > The performance has varied wildly in the last cycle(s) so it's hard to
> > get a baseline, other than another major release. I do expect changes in
> > performance characteristics but still hope it'll be the same on average.
> 
> Testing appears normal, we get more weirdnes just by enabling the
> writeback throttling, but without that I haven't observed anything
> unusual. Patches go to the misc-next part, meaning I don't expect
> changes other than fixups, as separate patches. Thanks.

Thank you Dave, I'm interesting in that weirdness part, will look into
it.

Thanks,

-liubo
