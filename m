Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:43847 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbeACLeJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jan 2018 06:34:09 -0500
Received: by mail-vk0-f66.google.com with SMTP id k132so679103vke.10
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jan 2018 03:34:08 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180103080729.20804-1-anand.jain@oracle.com>
References: <20180103080729.20804-1-anand.jain@oracle.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 3 Jan 2018 11:34:07 +0000
Message-ID: <CAL3q7H7DG_J3zgKurZB+ba7GxiW4_EUTh2i_3a54iRecruNixA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: not a disk error if the bio_add_page fails
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 3, 2018 at 8:07 AM, Anand Jain <anand.jain@oracle.com> wrote:
> bio_add_page() can fail for logical reasons as from the bio_add_page()
> comments:- 'This will only fail if either
> bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.' Don't inc the
> write error statistics for this. And set -EINVAL instead of -EIO.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/scrub.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index d766c73eb29a..8c1508a41f90 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -4618,15 +4618,15 @@ static int write_page_nocow(struct scrub_ctx *sctx,
>         bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
>         ret = bio_add_page(bio, page, PAGE_SIZE, 0);
>         if (ret != PAGE_SIZE) {
> -leave_with_eio:
>                 bio_put(bio);
> +               return -EINVAL;
> +       }
> +
> +       if (btrfsic_submit_bio_wait(bio)) {
>                 btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
>                 return -EIO;
>         }

You are now introducing a leak of the bio. Missing bio_put(bio) before
returning.

>
> -       if (btrfsic_submit_bio_wait(bio))
> -               goto leave_with_eio;
> -
>         bio_put(bio);
>         return 0;
>  }
> --
> 2.15.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
