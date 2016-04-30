Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51883 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbcD3EKC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Apr 2016 00:10:02 -0400
Date: Fri, 29 Apr 2016 21:09:46 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: =?iso-8859-1?B?R/xuZ/Zy?= Erseymen <gelurine@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix divide error upon chunk's stripe_len
Message-ID: <20160430040946.GA27901@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1461718411-809-1-git-send-email-bo.li.liu@oracle.com>
 <877ffgp7g2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <877ffgp7g2.fsf@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 29, 2016 at 09:59:25PM +0300, Güngör Erseymen wrote:
> On 2016-04-27 at 03:53:31 +0300 (EEST), Liu Bo <bo.li.liu@oracle.com> wrote:
> > The struct 'map_lookup' uses type int for @stripe_len, while
> > btrfs_chunk_stripe_len() can return a u64 value, and it may end up with
> > @stripe_len being undefined value and it can lead to 'divide error' in
> >  __btrfs_map_block().
> >
> > This changes 'map_lookup' to use type u64 for stripe_len, also right now
> > we only use BTRFS_STRIPE_LEN for stripe_len, so this adds a valid checker for
> > BTRFS_STRIPE_LEN.
> >
> > Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> > Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/volumes.c | 2 +-
> >  fs/btrfs/volumes.h | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index e2b54d5..b5cb859 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -6242,7 +6242,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
> >  			"invalid chunk length %llu", length);
> >  		return -EIO;
> >  	}
> > -	if (!is_power_of_2(stripe_len)) {
> > +	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
> >  		btrfs_err(root->fs_info, "invalid chunk stripe length: %llu",
> >  			  stripe_len);
> >  		return -EIO;
> > diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> > index 1939ebd..7507be7 100644
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -347,7 +347,7 @@ struct map_lookup {
> >  	u64 type;
> >  	int io_align;
> >  	int io_width;
> > -	int stripe_len;
> > +	u64 stripe_len;
> >  	int sector_size;
> >  	int num_stripes;
> >  	int sub_stripes;
> > -- 
> > 2.5.0
> 
> Type change of map->stripe_len to u64 cause build error "undefined
> reference to __udivdi3" on 32bit systems. Using explicit 64 bit division
> fixes it and would be better to combine into this commit for
> continuity.

Thanks a lot for fixing this.

Thanks,

-liubo

> 
> Thanks.
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 4678f03e878e..d9ef1c4f91aa 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2860,7 +2860,7 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
>         int extent_mirror_num;
>         int stop_loop = 0;
>  
> -       nsectors = map->stripe_len / root->sectorsize;
> +       nsectors = div_u64(map->stripe_len, root->sectorsize);
>         bitmap_len = scrub_calc_parity_bitmap_len(nsectors);
>         sparity = kzalloc(sizeof(struct scrub_parity) + 2 * bitmap_len,
>                           GFP_NOFS);
> 
> --
> Güngör Erseymen
