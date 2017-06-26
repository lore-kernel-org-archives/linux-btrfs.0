Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37585 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdFZSFF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 14:05:05 -0400
Date: Mon, 26 Jun 2017 11:02:39 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Liu Bo <boliu@localhost.localdomain>
Subject: Re: [PATCH] Btrfs-progs: fix infinite loop in find_free_extent
Message-ID: <20170626180239.GA31661@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170624042831.8068-1-bo.li.liu@oracle.com>
 <20170626140953.GJ2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170626140953.GJ2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 04:09:53PM +0200, David Sterba wrote:
> On Fri, Jun 23, 2017 at 10:28:31PM -0600, Liu Bo wrote:
> > From: Liu Bo <boliu@localhost.localdomain>

Ah, my From was broken again.

> > 
> > %search_start is calculated in a wrong way, and if %ins is a cross-stripe
> >  one, it'll search the same block group forever.
> 
> That's a bit terse description, so please check if my understanding is right:
> search_start advances by at least one stripe len, but the math would be wrong
> as using bg_offset would not move us to the next stripe. bg_cache->key.objectid
> is the full length so this will reach the next stripe and will not loop forever.

Yes, it's correct, the code's logic is like, now that the returned %ins is a
cross-stripe one, it then calculates a BTRFS_STRIPE_LEN aligned one as the new
%search_start and see if there is any free block matching %search_start.  The
current code is using a wrong offset, the offset really should be the start
position of a block group.

> 
> Do you happen to have a test for that?

Unfortunately it's not a test with vanilla progs.

I found this when mkfs.btrfs with a 12K nodesize, but now kernel has a
power_of_2 limitation for nodesize and progs code is using a weird IS_ALIGNED()
which has the same effect with power_of_2(), mkfs.btrfs -n 12K is not allowed.
I changed IS_ALIGNED() to (blocksize % nodesize != 0) and got the above loop.

> 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  extent-tree.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/extent-tree.c b/extent-tree.c
> > index b12ee29..5e09274 100644
> > --- a/extent-tree.c
> > +++ b/extent-tree.c
> > @@ -2614,8 +2614,9 @@ check_failed:
> >  				goto no_bg_cache;
> >  			bg_offset = ins->objectid - bg_cache->key.objectid;
> >  
> > -			search_start = round_up(bg_offset + num_bytes,
> > -						BTRFS_STRIPE_LEN) + bg_offset;
> > +			search_start = round_up(
> > +				bg_offset + num_bytes, BTRFS_STRIPE_LEN) +
> > +				bg_cache->key.object;
> 
> extent-tree.c: In function ‘find_free_extent’:
> extent-tree.c:2617:18: error: ‘struct btrfs_key’ has no member named ‘object’; did you mean ‘objectid’?
>      bg_cache->key.object;
>                   ^

Ouch, that's right, it's %objectid.

I'll send a updated one, thanks for the comments.

-liubo
