Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:40334 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbeACLkb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jan 2018 06:40:31 -0500
Received: by mail-vk0-f65.google.com with SMTP id w75so694148vkd.7
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jan 2018 03:40:30 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20171228152804.4645-1-nefelim4ag@gmail.com>
References: <20171228152804.4645-1-nefelim4ag@gmail.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 3 Jan 2018 11:40:29 +0000
Message-ID: <CAL3q7H5dZ7P-8UaOEUQERKM9Oa=8WcPysqo=Vc5RQEPjiC858w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: replace raid56 stripe bubble sort with insert sort
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 28, 2017 at 3:28 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> Insert sort are generaly perform better then bubble sort,
> by have less iterations on avarage.
> That version also try place element to right position
> instead of raw swap.
>
> I'm not sure how many stripes per bio raid56,
> btrfs try to store (and try to sort).

If you don't know it, besides unlikely to be doing the best possible
thing here, you might actually make things worse or not offering any
benefit. IOW, you should know it for sure before submitting such
changes.

You should know if the number of elements to sort is big enough such
that an insertion sort is faster than a bubble sort, and more
importantly, measure it and mention it in the changelog.
As it is, you are showing lack of understanding of the code and
component you are touching, and leaving many open questions such as
how faster this is, why insertion sort and not a
quick/merge/heap/whatever sort, etc.

>
> So, that a bit shorter just in the name of a great justice.
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/volumes.c | 29 ++++++++++++-----------------
>  1 file changed, 12 insertions(+), 17 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 98bc2433a920..7195fc8c49b1 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5317,29 +5317,24 @@ static inline int parity_smaller(u64 a, u64 b)
>         return a > b;
>  }
>
> -/* Bubble-sort the stripe set to put the parity/syndrome stripes last */
> +/* Insertion-sort the stripe set to put the parity/syndrome stripes last */
>  static void sort_parity_stripes(struct btrfs_bio *bbio, int num_stripes)
>  {
>         struct btrfs_bio_stripe s;
> -       int i;
> +       int i, j;
>         u64 l;
> -       int again = 1;
>
> -       while (again) {
> -               again = 0;
> -               for (i = 0; i < num_stripes - 1; i++) {
> -                       if (parity_smaller(bbio->raid_map[i],
> -                                          bbio->raid_map[i+1])) {
> -                               s = bbio->stripes[i];
> -                               l = bbio->raid_map[i];
> -                               bbio->stripes[i] = bbio->stripes[i+1];
> -                               bbio->raid_map[i] = bbio->raid_map[i+1];
> -                               bbio->stripes[i+1] = s;
> -                               bbio->raid_map[i+1] = l;
> -
> -                               again = 1;
> -                       }
> +       for (i = 1; i < num_stripes; i++) {
> +               s = bbio->stripes[i];
> +               l = bbio->raid_map[i];
> +               for (j = i - 1; j >= 0; j--) {
> +                       if (!parity_smaller(bbio->raid_map[j], l))
> +                               break;
> +                       bbio->stripes[j+1]  = bbio->stripes[j];
> +                       bbio->raid_map[j+1] = bbio->raid_map[j];
>                 }
> +               bbio->stripes[j+1]  = s;
> +               bbio->raid_map[j+1] = l;
>         }
>  }
>
> --
> 2.15.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
