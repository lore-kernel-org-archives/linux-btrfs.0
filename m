Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56342 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932298AbdETAMW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 20:12:22 -0400
Date: Fri, 19 May 2017 17:11:34 -0700
From: Marc MERLIN <marc@merlins.org>
To: Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 4.11.0: kernel BUG at fs/btrfs/ctree.h:1779!
Message-ID: <20170520001134.GW29894@merlins.org>
References: <20170519041638.sf7sensley4lpxiz@merlins.org> <20170519190358.GC10137@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170519190358.GC10137@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 12:03:58PM -0700, Liu Bo wrote:
> Hi Marc,
> 
> On Thu, May 18, 2017 at 09:16:38PM -0700, Marc MERLIN wrote:
> > Looks like all the unhelpful BUG() aren't gone yet :-/
> > This one is really not helpful, I don't even know which one of my filesystems caused the crash :(
> > 
> > Why is this not remounting the filesystem read only?
> > Really, from a user and admin perspective, this is really not helpful.
> > 
> > Could someone who know more than me do a pass and eradicate those? 
> > Btrfs cannot be a production filesystem as long as those are still around IMO.
> 
> Looks like there's a security hole hidden in code, I don't think it's
> a bug in code, it's more like caused by a corrupted metadata reading
> from disk rather than a memory corruption.
> 
> A quick glance at the stack shows in extent-tree.c:lookup_inline_extent_backref()
> 
> type = btrfs_extent_inline_ref_type(leaf, iref);
> then...
> ptr += btrfs_extent_inline_ref_size(type);
> 
> I agree that a corrupted image should not corrupt the kernel, so we
> can fix it by forcing it to readonly.

Thanks.
Can I make another plea for just removing all those BUG/BUG_ON?
They really have no place in production code, there is no excuse for a
filesystem to bring down the entire and in the process not even tell you
which of your filesystems had the issue to start with.

Could this be made part of a cleanup for this build to remove them all?

Pretty please with cherry on top? :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
