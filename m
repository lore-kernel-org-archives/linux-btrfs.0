Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40800 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756736AbcKWQzb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 11:55:31 -0500
Date: Wed, 23 Nov 2016 17:55:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix truncate down when no_holes feature is enabled
Message-ID: <20161123165526.GR12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1478903265-24273-1-git-send-email-bo.li.liu@oracle.com>
 <e740caa9-33a8-7aa0-b4a4-c6fc22be4d3e@fb.com>
 <20161122200847.GA23828@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161122200847.GA23828@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2016 at 12:08:47PM -0800, Liu Bo wrote:
> On Tue, Nov 22, 2016 at 02:13:21PM -0500, Chris Mason wrote:
> > On 11/11/2016 05:27 PM, Liu Bo wrote:
> > > For such a file mapping,
> > > 
> > > [0-4k][hole][8k-12k]
> > > 
> > > In NO_HOLES mode, we don't have the [hole] extent any more.
> > > Commit c1aa45759e90 ("Btrfs: fix shrinking truncate when the no_holes feature is enabled")
> > >  fixed disk isize not being updated in NO_HOLES mode when data is not flushed.
> > > 
> > > However, even if data has been flushed, we can still have trouble
> > > in updating disk isize since we updated disk isize to 'start' of
> > > the last evicted extent.
> > > 
> > > Also add a ASSERT for better catching (for developers only).
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > 
> > Thanks Liu!
> > 
> > Reviewed-by: Chris Mason <clm@fb.com>
> 
> The added ASSERT() can cause generic/068 to crash because I didn't
> filter out the 'log tree' case, I'm testing a V2 patch.

I've hit the assert with btrfs/003, once and not deterministically in a VM.
