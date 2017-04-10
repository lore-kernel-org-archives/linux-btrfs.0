Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36633 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbdDJMun (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 08:50:43 -0400
Subject: Re: [PATCH] btrfs: scrub: use do_div() for 64-by-32 division
To: Adam Borowski <kilobyte@angband.pl>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Fabio Estevam <festevam@gmail.com>
References: <CAOMZO5B9J15qvrsjOb-e5gk47gA=+2p2yLNLhswG+H3S0L7LXg@mail.gmail.com>
 <20170408210737.5456-1-kilobyte@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7179b0c7-0951-b5f3-6835-2f005ea743e1@gmail.com>
Date: Mon, 10 Apr 2017 08:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <20170408210737.5456-1-kilobyte@angband.pl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-08 17:07, Adam Borowski wrote:
> Unbreaks ARM and possibly other 32-bit architectures.
>
> Fixes: 7d0ef8b4d: Btrfs: update scrub_parity to use u64 stripe_len
> Reported-by: Icenowy Zheng <icenowy@aosc.io>
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
> You'd probably want to squash this with Liu's commit, to be nice to future
> bisects.
>
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
>  	nsectors = (int)len / sectorsize;
>
>  	if (offset + nsectors <= sparity->nsectors) {
>
Also fixes things on:
32-bit MIPS (eb and el variants)
32-bit SPARC
32-bit PPC

You can add my Tested-by if you want.
