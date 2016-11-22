Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23285 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752140AbcKVUJB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 15:09:01 -0500
Date: Tue, 22 Nov 2016 12:08:47 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix truncate down when no_holes feature is enabled
Message-ID: <20161122200847.GA23828@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1478903265-24273-1-git-send-email-bo.li.liu@oracle.com>
 <e740caa9-33a8-7aa0-b4a4-c6fc22be4d3e@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e740caa9-33a8-7aa0-b4a4-c6fc22be4d3e@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2016 at 02:13:21PM -0500, Chris Mason wrote:
> On 11/11/2016 05:27 PM, Liu Bo wrote:
> > For such a file mapping,
> > 
> > [0-4k][hole][8k-12k]
> > 
> > In NO_HOLES mode, we don't have the [hole] extent any more.
> > Commit c1aa45759e90 ("Btrfs: fix shrinking truncate when the no_holes feature is enabled")
> >  fixed disk isize not being updated in NO_HOLES mode when data is not flushed.
> > 
> > However, even if data has been flushed, we can still have trouble
> > in updating disk isize since we updated disk isize to 'start' of
> > the last evicted extent.
> > 
> > Also add a ASSERT for better catching (for developers only).
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Thanks Liu!
> 
> Reviewed-by: Chris Mason <clm@fb.com>

The added ASSERT() can cause generic/068 to crash because I didn't
filter out the 'log tree' case, I'm testing a V2 patch.

Thanks,

-liubo
