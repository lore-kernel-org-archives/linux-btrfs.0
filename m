Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34180 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbbF3IUD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 04:20:03 -0400
Received: by iebmu5 with SMTP id mu5so7212139ieb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 01:20:02 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1434531598-8607-1-git-send-email-bo.li.liu@oracle.com>
References: <1434531598-8607-1-git-send-email-bo.li.liu@oracle.com>
Date: Tue, 30 Jun 2015 09:20:02 +0100
Message-ID: <CAL3q7H4J+gYknRsmycK9zFcMNzxavY9m2CQgX9uwiFV=gA74Aw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: fix hang when failing to submit bio of directIO
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 9:59 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> The hang is uncoverd by generic/019.
>
> btrfs_endio_direct_write() skips the "finish_ordered_fn" part when it hits
> an error, thus those added ordered extents will never get processed, which
> block processes that waiting for them via btrfs_start_ordered_extent().
>
> This fixes the above, and meanwhile finish_ordered_fn will do the space
> accounting work.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/inode.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8bb0136..7bf150a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7855,8 +7855,6 @@ static void btrfs_endio_direct_write(struct bio *bio, int err)
>         struct bio *dio_bio;
>         int ret;
>
> -       if (err)
> -               goto out_done;
>  again:
>         ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
>                                                    &ordered_offset,
> @@ -7879,7 +7877,6 @@ out_test:
>                 ordered = NULL;
>                 goto again;
>         }
> -out_done:
>         dio_bio = dip->dio_bio;
>
>         kfree(dip);
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
