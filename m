Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:32887 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751675AbdFIXi7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 19:38:59 -0400
Received: by mail-pg0-f46.google.com with SMTP id f185so30820552pgc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jun 2017 16:38:59 -0700 (PDT)
Date: Fri, 9 Jun 2017 16:38:42 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        kernel-team@fb.com
Subject: Re: [PATCH 6/7] Btrfs: rework delayed ref total_bytes_pinned
 accounting
Message-ID: <20170609233842.GA15078@vader.Home>
References: <cover.1496792333.git.osandov@fb.com>
 <e632aa7e9beeff738885de7b7c9e689f5e54ae70.1496792333.git.osandov@fb.com>
 <20170607201810.GB16793@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170607201810.GB16793@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 01:18:10PM -0700, Liu Bo wrote:
> On Tue, Jun 06, 2017 at 04:45:31PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > The total_bytes_pinned counter is completely broken when accounting
> > delayed refs:
> > 
> > - If two drops for the same extent are merged, we will decrement
> >   total_bytes_pinned twice but only increment it once.
> > - If an add is merged into a drop or vice versa, we will decrement the
> >   total_bytes_pinned counter but never increment it.
> > - If multiple references to an extent are dropped, we will account it
> >   multiple times, potentially vastly over-estimating the number of bytes
> >   that will be freed by a commit and doing unnecessary work when we're
> >   close to ENOSPC.
> > 
> > The last issue is relatively minor, but the first two make the
> > total_bytes_pinned counter leak or underflow very often. These
> > accounting issues were introduced in b150a4f10d87 ("Btrfs: use a percpu
> > to keep track of possibly pinned bytes"), but they were papered over by
> > zeroing out the counter on every commit until d288db5dc011 ("Btrfs: fix
> > race of using total_bytes_pinned").
> > 
> > We need to make sure that an extent is accounted as pinned exactly once
> > if and only if we will drop references to it when when the transaction
> > is committed. Ideally we would only add to total_bytes_pinned when the
> > *last* reference is dropped, but this information isn't readily
> > available for data extents. Again, this over-estimation can lead to
> > extra commits when we're close to ENOSPC, but it's not as bad as before.
> > 
> > The fix implemented here is to increment total_bytes_pinned when the
> > total refmod count for an extent goes negative and decrement it if the
> > refmod count goes back to non-negative or after we've run all of the
> > delayed refs for that extent.
> >
> 
> The patch could be cleaner if we inc/dec %pinned inside delayed_ref.c.
> 
> The idea looks good to me.
> 
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Yeah, I think that'll work. My first reaction was that it'd be a
layering violation, but I think it makes sense, this counter really is
necessary because of delayed refs.
