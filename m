Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:33080 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732190AbeITAWp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 20:22:45 -0400
Received: by mail-yb1-f194.google.com with SMTP id y9-v6so2825338ybh.0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 11:43:33 -0700 (PDT)
Date: Wed, 19 Sep 2018 14:43:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH v7 2/6] mm: export add_swap_extent()
Message-ID: <20180919184331.GA20181@cmpxchg.org>
References: <cover.1536704650.git.osandov@fb.com>
 <bb1208575e02829aae51b538709476964f97b1ea.1536704650.git.osandov@fb.com>
 <20180919180909.GC18068@cmpxchg.org>
 <20180919182800.GK479@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180919182800.GK479@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2018 at 11:28:00AM -0700, Omar Sandoval wrote:
> On Wed, Sep 19, 2018 at 02:09:09PM -0400, Johannes Weiner wrote:
> > On Tue, Sep 11, 2018 at 03:34:45PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > Btrfs will need this for swap file support.
> > > 
> > > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > 
> > That looks reasonable. After reading the last patch, it's somewhat
> > understandable why you cannot simply implemnet ->bmap and use the
> > generic activation code. But it would be good to explain the reason(s)
> > for why you can't here briefly to justify this patch.
> 
> I'll rewrite it to:
> 
> Btrfs currently does not support swap files because swap's use of bmap
> does not work with copy-on-write and multiple devices. See 35054394c4b3
> ("Btrfs: stop providing a bmap operation to avoid swapfile
> corruptions"). However, the swap code has a mechanism for the filesystem
> to manually add swap extents using add_swap_extent() from the
> ->swap_activate() aop. iomap has done this since 67482129cdab ("iomap:
> add a swapfile activation function"). Btrfs will do the same in a later
> patch, so export add_swap_extent().

That explains it perfectly. Thanks!
