Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35934 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbFQJxK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 05:53:10 -0400
Received: by iecrd14 with SMTP id rd14so30203228iec.3
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 02:53:09 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1434375680-4115-1-git-send-email-jeffm@suse.com>
Date: Wed, 17 Jun 2015 10:53:09 +0100
Message-ID: <CAL3q7H5d9kahx7HgZX+BaeSsoV2XUZF92cb7sGEDS5g60RF3qQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] btrfs: make btrfs_issue_discard return bytes discarded
From: Filipe David Manana <fdmanana@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1434375680-4115-1-git-send-email-jeffm@suse.com>

On Mon, Jun 15, 2015 at 2:41 PM,  <jeffm@suse.com> wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>
> Initially this will just be the length argument passed to it,
> but the following patches will adjust that to reflect re-alignment
> and skipped blocks.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0ec3acd..da1145d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -1884,10 +1884,17 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
>         return ret;
>  }
>
> -static int btrfs_issue_discard(struct block_device *bdev,
> -                               u64 start, u64 len)
> +static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
> +                              u64 *discarded_bytes)
>  {
> -       return blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_NOFS, 0);
> +       int ret = 0;
> +
> +       *discarded_bytes = 0;
> +       ret = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_NOFS, 0);
> +       if (!ret)
> +               *discarded_bytes = len;
> +
> +       return ret;
>  }
>
>  int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
> @@ -1908,14 +1915,16 @@ int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
>
>
>                 for (i = 0; i < bbio->num_stripes; i++, stripe++) {
> +                       u64 bytes;
>                         if (!stripe->dev->can_discard)
>                                 continue;
>
>                         ret = btrfs_issue_discard(stripe->dev->bdev,
>                                                   stripe->physical,
> -                                                 stripe->length);
> +                                                 stripe->length,
> +                                                 &bytes);
>                         if (!ret)
> -                               discarded_bytes += stripe->length;
> +                               discarded_bytes += bytes;
>                         else if (ret != -EOPNOTSUPP)
>                                 break; /* Logic errors or -ENOMEM, or -EIO but I don't know how that could happen JDM */
>
> --
> 2.4.3
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
