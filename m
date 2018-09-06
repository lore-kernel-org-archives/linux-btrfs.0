Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41164 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbeIFWp3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 18:45:29 -0400
Received: by mail-pg1-f194.google.com with SMTP id s15-v6so5628436pgv.8
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2018 11:08:51 -0700 (PDT)
Date: Thu, 6 Sep 2018 11:08:49 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v5 0/6] Btrfs: implement swap file support
Message-ID: <20180906180849.GB27057@vader>
References: <cover.1535754957.git.osandov@fb.com>
 <20180906115954.GZ24025@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180906115954.GZ24025@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2018 at 01:59:54PM +0200, David Sterba wrote:
> On Fri, Aug 31, 2018 at 03:36:35PM -0700, Omar Sandoval wrote:
> > This series implements swap file support for Btrfs.
> > 
> > Changes since v4 [1]:
> > 
> > - Added a kernel doc for btrfs_get_chunk_map()
> > - Got rid of "Btrfs: push EXCL_OP set into btrfs_rm_device()"
> > - Made activate error messages more clear and consistent
> > - Changed clear vs unlock order in activate error case
> > - Added "mm: export add_swap_extent()" as a separate patch
> > - Added a btrfs_wait_ordered_range() at the beginning of
> >   btrfs_swap_activate() to catch newly created files
> > - Added some Reviewed-bys from Nikolay
> > 
> > I took a stab at adding support for balance when a swap file is active,
> > but it's a major pain: we need to mark block groups which contain swap
> > file extents, check the block group counter in relocate/scrub, then
> > unmark the block groups when the swap file is deactivated, which gets
> > really messy because the file can grow while it is an active swap file.
> > If this is a deal breaker, I can work something out, but I don't think
> > it's worth the trouble.
> 
> I'm afraid it is a deal breaker. Unlike dev-replace or resize, balance
> is used more often so switching off the swap file for the duration of
> the operation is administration pain.
> 
> If it's possible to constrain the swap file further, like no growing
> that you mention, or mandatory preallocation or similar, then I hope it
> would make it possible to implement in a sane way.

Alright, I'll have another go.
