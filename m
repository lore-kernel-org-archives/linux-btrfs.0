From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix compile warning from __btrfs_map_block
Date: Thu, 31 Mar 2011 08:10:00 -0400
Message-ID: <1301573269-sup-7700@think>
References: <4D944235.7020408@cn.fujitsu.com> <4D944D30.4050900@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D944D30.4050900@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from liubo's message of 2011-03-31 05:45:20 -0400:
> 
> While compile btrfs modules on 32bit box, I encounter the following:
> 
> WARNING: "__umoddi3" [fs/btrfs/btrfs.ko] undefined!
> 
> The WARNING comes from that __btrfs_map_block does not use do_div() for
> relative operations, this will cause problems on 32bit box, for values
> with "u64" type should use do_div() instead of a direct "%".

Which kernel tree was this against?  I had rebased the for-linus and
for-linus-unmerged branch to get rid of it.

Sorry for the confusion.

-chris

> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c |   23 +++++++++++++++--------
>  1 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 41afd50..7b23d0f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3076,16 +3076,19 @@ again:
>              multi->stripes[i].dev = map->stripes[stripe_index].dev;
>  
>              if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
> -                u64 stripes;
> -                int last_stripe = (stripe_nr_end - 1) %
> -                    map->num_stripes;
> +                u64 stripes = stripe_nr_end - 1;
> +                int last_stripe = do_div(stripes,
> +                    map->num_stripes);
>                  int j;
>  
>                  for (j = 0; j < map->num_stripes; j++) {
> -                    if ((stripe_nr_end - 1 - j) %
> -                          map->num_stripes == stripe_index)
> +                    stripes = stripe_nr_end - 1 - j;
> +
> +                    if (do_div(stripes, map->num_stripes) ==
> +                        stripe_index)
>                          break;
>                  }
> +
>                  stripes = stripe_nr_end - 1 - j;
>                  do_div(stripes, map->num_stripes);
>                  multi->stripes[i].length = map->stripe_len *
> @@ -3100,18 +3103,22 @@ again:
>                      multi->stripes[i].length -=
>                          stripe_end_offset;
>              } else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
> -                u64 stripes;
> +                u64 stripes = stripe_nr_end - 1;
>                  int j;
>                  int factor = map->num_stripes /
>                           map->sub_stripes;
> -                int last_stripe = (stripe_nr_end - 1) % factor;
> +                int last_stripe = do_div(stripes, factor);
> +
>                  last_stripe *= map->sub_stripes;
>  
>                  for (j = 0; j < factor; j++) {
> -                    if ((stripe_nr_end - 1 - j) % factor ==
> +                    stripes = stripe_nr_end - 1 - j;
> +
> +                    if (do_div(stripes, factor) ==
>                          stripe_index / map->sub_stripes)
>                          break;
>                  }
> +
>                  stripes = stripe_nr_end - 1 - j;
>                  do_div(stripes, factor);
>                  multi->stripes[i].length = map->stripe_len *
