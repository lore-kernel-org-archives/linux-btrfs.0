Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34163 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753169AbdDJLN4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 07:13:56 -0400
Date: Mon, 10 Apr 2017 13:13:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Icenowy Zheng <icenowy@aosc.io>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: scrub: use do_div() for 64-by-32 division
Message-ID: <20170410111353.GX4781@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAOMZO5B9J15qvrsjOb-e5gk47gA=+2p2yLNLhswG+H3S0L7LXg@mail.gmail.com>
 <20170408210737.5456-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170408210737.5456-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 08, 2017 at 11:07:37PM +0200, Adam Borowski wrote:
> Unbreaks ARM and possibly other 32-bit architectures.
> 
> Fixes: 7d0ef8b4d: Btrfs: update scrub_parity to use u64 stripe_len
> Reported-by: Icenowy Zheng <icenowy@aosc.io>
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
> You'd probably want to squash this with Liu's commit, to be nice to future
> bisects.

Thanks for finding it!

> Tested on amd64 where all is fine, and on arm (Odroid-U2) where scrub
> sometimes works, but, like most operations, randomly dies with some badness
> that doesn't look related: io_schedule, kunmap_high.  That badness wasn't
> there in 4.11-rc5, needs investigating, but since it's not connected to our
> issue at hand, I consider this patch sort-of tested.
> 
>  fs/btrfs/scrub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index b6fe1cd08048..95372e3679f3 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2407,7 +2407,7 @@ static inline void __scrub_mark_bitmap(struct scrub_parity *sparity,
>  
>  	start -= sparity->logic_start;
>  	start = div64_u64_rem(start, sparity->stripe_len, &offset);
> -	offset /= sectorsize;
> +	do_div(offset, sectorsize);

I'll use the div_u64 helper instead, I don't want to reintroduce do_div
to fs/btrfs , for-next will be updated in a minute.
