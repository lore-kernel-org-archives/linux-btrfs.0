Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35298 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758338AbcIURft (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 13:35:49 -0400
Received: by mail-pf0-f174.google.com with SMTP id z123so21366442pfz.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 10:35:49 -0700 (PDT)
Date: Wed, 21 Sep 2016 10:35:47 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on
 big-endian systems
Message-ID: <20160921173547.GA14218@vader.DHCP.thefacebook.com>
References: <cover.1468538030.git.osandov@fb.com>
 <399ec92c-9905-0ede-d5b0-ea3b0bf922e4@fb.com>
 <20160718223104.GA6681@vader.DHCP.thefacebook.com>
 <2544227.upOtQjWuiQ@localhost.localdomain>
 <83e50f77-ae10-4c8d-4a03-3c9af298d9c7@fb.com>
 <20160818203327.GA7696@vader.DHCP.thefacebook.com>
 <20160921145012.GJ16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160921145012.GJ16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 04:50:12PM +0200, David Sterba wrote:
> On Thu, Aug 18, 2016 at 01:33:27PM -0700, Omar Sandoval wrote:
> > > Omar, looks like we need to make the patched kernel refuse to mount free
> > > space trees without a new incompat bit set.  That way there won't be any
> > > surprises for the people that have managed to get a free space tree saved.
> > > Can it please printk a message about clearing the tree and mounting again?
> > > 
> > > -chris
> > 
> > Sorry it took me a month to get around to this, I tried to implement
> > this a couple of ways but I really don't like it. Basically, when we see
> > that we're missing the compat bit, we have to assume that the free space
> > tree was created with the same endianness that we're running on now.
> > That could lead to a false positive if, say, we created the filesystem
> > on a little-endian machine with an old kernel but are using it on a
> > big-endian system, or a false negative if it was created on a big-endian
> > machine with an old kernel but we're using it on a little-endian
> > machine.
> > 
> > There's also the question of making it a compat bit vs an incompat bit.
> > An incompat bit makes sure that we don't break the filesystem by
> > mounting it on an old big-endian kernel, but needlessly breaks
> > backwards-compatibility for little-endian.
> > 
> > I'd be much happier if we could just pretend this never happened. Here's
> > the patch, anyways, for the sake of completeness. Chris, what do you
> > think?
> 
> Here's my proposal how to resolve this:
> 
> * we have reports from people using intel hw that FST works fine for
>   them, so here I don't see any need to introduce incompat bits
> 
> * there are few users on bigendian machines, they need to update kernel
>   to store the correct layout of FST bitmap
> 
> * as majority of user will never hit the BE/LE problem, I'd focus on
>   advising how to reset the free space tree and let anybody update (ie.
>   pretend this hasn't happened)
> 
> I don't think we absolutelly must introduce the incompat bit and prevent
> a disaster, because there are very few users affected.

Thanks, Dave, that's what I was thinking, too. I'll rebase this series
and send it out as is. Hopefully we can get it in for 4.9, or 4.10 at
the latest.

-- 
Omar
