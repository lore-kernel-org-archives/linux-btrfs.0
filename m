Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33222 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751576AbdFGJpw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 05:45:52 -0400
Received: by mail-io0-f194.google.com with SMTP id m4so792526ioe.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Jun 2017 02:45:52 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20170607005844.2078-7-nefelim4ag@gmail.com>
References: <20170607005844.2078-1-nefelim4ag@gmail.com> <20170607005844.2078-7-nefelim4ag@gmail.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 7 Jun 2017 10:45:51 +0100
Message-ID: <CAL3q7H7m0XmLDYoox6QeuiwGw6sw-ftTp-TDgO+PdJBj-i39ig@mail.gmail.com>
Subject: Re: [PATCH 6/7] Btrfs: __tree_mod_log_insert decrease max compare count
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 7, 2017 at 1:58 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> In worst case code do 4 comparison,
> just add some new checks to switch check branch faster
> now in worst case code do 3 comparison

Some comments below.

>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/ctree.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index a3a75f1de..318379531 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -460,15 +460,17 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
>         while (*new) {
>                 cur = rb_entry(*new, struct tree_mod_elem, node);
>                 parent = *new;
> -               if (cur->logical < tm->logical)
> -                       new = &((*new)->rb_left);
> -               else if (cur->logical > tm->logical)
> -                       new = &((*new)->rb_right);
> -               else if (cur->seq < tm->seq)
> -                       new = &((*new)->rb_left);
> -               else if (cur->seq > tm->seq)
> -                       new = &((*new)->rb_right);
> -               else
> +               if (cur->logical != tm->logical) {
> +                       if (cur->logical < tm->logical)
> +                               new = &((*new)->rb_left);

So now when cur->logical is less then tm->logical, we do 2 comparisons
instead of 1.
Is this case much less common always? If it were it could be a good change.
What guarantees that this change will give better performance for
common workloads? What guarantees you the example I just gave isn't
typical for most/many common workloads?

And most importantly, did you actually do some benchmarks that justify
this change? Is this a hot code path that would benefit from such
changes?
(Since it's the tree mod log, seldom used, I really doubt it).

Same comments apply to all the other similar patches you have sent.

thanks

> +                       else
> +                               new = &((*new)->rb_right);
> +               } else if (cur->seq != tm->seq) {
> +                       if (cur->seq < tm->seq)
> +                               new = &((*new)->rb_left);
> +                       else
> +                               new = &((*new)->rb_right);
> +               } else
>                         return -EEXIST;
>         }
>
> --
> 2.13.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
