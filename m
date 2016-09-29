Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753151AbcI2Lnm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 07:43:42 -0400
Date: Thu, 29 Sep 2016 13:43:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [PATCH v2 3/6] Btrfs: catch invalid free space trees
Message-ID: <20160929114340.GA5531@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1474580472.git.osandov@fb.com>
 <1381db7b5de30b8ea0d2e87aff26bfdb83b030e7.1474580472.git.osandov@fb.com>
 <20160926231329.GA23991@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160926231329.GA23991@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2016 at 04:13:29PM -0700, Omar Sandoval wrote:
> > +/*
> > + * Older kernels on big-endian systems produced broken free space tree bitmaps,
> > + * and btrfs-progs also used to corrupt the free space tree. If this bit is
> > + * clear, then the free space tree cannot be trusted. btrfs-progs can also
> > + * intentionally clear this bit to ask the kernel to rebuild the free space
> > + * tree.
> > + */
> 
> Hm, I think I changed my mind about allowing btrfs-progs to clear the
> bit intentionally. This creates a problem where we have a valid free
> space tree, modify it with btrfs-progs and clear the bit, and then mount
> it on an older kernel that doesn't check for the valid bit. If we really
> wanted to, we could add yet another bit, say, FREE_SPACE_TREE_INVALID,
> which prevents old kernels from mounting it, but I don't want to add
> more hacks just because write support hasn't been implemented in progs
> yet. That doesn't change this patch at all except for the comment here.

What you describe is possible to happen but still rare, the lowest
recommended kernel for general FST feature use will be at least 4.9. We
can describe the buggy kernel/tools combinations and recommended stafety
steps, like clearing the cache manually etc.

> Should I resend it or can this be fixed on applying?

I can update the wording.
