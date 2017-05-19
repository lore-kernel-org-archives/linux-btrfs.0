Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16939 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753106AbdESUD3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 16:03:29 -0400
Date: Fri, 19 May 2017 13:01:42 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: clear EXTENT_DEFRAG bits in finish_ordered_io
Message-ID: <20170519200141.GE10137@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1494370935-19965-1-git-send-email-bo.li.liu@oracle.com>
 <20170519190642.GB4065@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170519190642.GB4065@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 09:06:42PM +0200, David Sterba wrote:
> On Tue, May 09, 2017 at 05:02:15PM -0600, Liu Bo wrote:
> > Before this, we use 'filled' mode here, ie. if all range has been filled
> > with EXTENT_DEFRAG bits, get to clear it, but if the defrag range joins
> > the adjacent delalloc range, then we'll leave EXTENT_DEFRAG bits until
> > evicting inode.
> >
> > This clears the bit if any was found within the ordered extent.
> 
> What effects, good or bad, can this have?
> 
> Is it worth backporting to stable trees?

The good effect of this patch is to free extent_state quickly if we
don't need it, without this, it can't be freed since the extent_state
has at least EXTENT_DEFRAG bit in ->state.

Just notice that I made a mistake in the changelog, the bit will be
cleared until releasing pages, which may be called by
invalidate_mapping_ranges(), not evicting inode.

No, I don't think it's a candidate for stable tree.

thanks,
-liubo
