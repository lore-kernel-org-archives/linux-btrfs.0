Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:38890 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732230AbeITAVB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 20:21:01 -0400
Received: by mail-yw1-f65.google.com with SMTP id n21-v6so2690071ywh.5
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 11:41:50 -0700 (PDT)
Date: Wed, 19 Sep 2018 14:41:47 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH v7 1/6] mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
Message-ID: <20180919184147.GA19595@cmpxchg.org>
References: <cover.1536704650.git.osandov@fb.com>
 <6d63d8668c4287a4f6d203d65696e96f80abdfc7.1536704650.git.osandov@fb.com>
 <20180919180232.GB18068@cmpxchg.org>
 <20180919181202.GJ479@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180919181202.GJ479@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2018 at 11:12:02AM -0700, Omar Sandoval wrote:
> On Wed, Sep 19, 2018 at 02:02:32PM -0400, Johannes Weiner wrote:
> > On Tue, Sep 11, 2018 at 03:34:44PM -0700, Omar Sandoval wrote:
> > > @@ -2411,8 +2412,10 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
> > >  
> > >  	if (mapping->a_ops->swap_activate) {
> > >  		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
> > > +		if (ret >= 0)
> > > +			sis->flags |= SWP_ACTIVATED;
> > >  		if (!ret) {
> > > -			sis->flags |= SWP_FILE;
> > > +			sis->flags |= SWP_FS;
> > >  			ret = add_swap_extent(sis, 0, sis->max, 0);
> > 
> > Won't this single, linear extent be in conflict with the discontiguous
> > extents you set up in your swap_activate callback in the last patch?
> 
> That's only in the case that ->swap_activate() returned 0, which only
> nfs_swap_activate() will do. btrfs_swap_activate() and
> iomap_swapfile_activate() both return the number of extents they set up.

Ah yes, I missed that.

That's a little under-documented I guess, but that's not your fault.
