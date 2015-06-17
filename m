Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35574 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbbFQJzS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 05:55:18 -0400
Received: by iesa3 with SMTP id a3so30266020ies.2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 02:55:17 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1434375680-4115-2-git-send-email-jeffm@suse.com>
Date: Wed, 17 Jun 2015 10:55:17 +0100
Message-ID: <CAL3q7H4ad9sYq0PcfYfiQ883eOFpEuwk5jJ+cpRDby+V_9ePKA@mail.gmail.com>
Subject: Re: [PATCH 2/7] btrfs: btrfs_issue_discard ensure offset/length are
 aligned to sector boundaries
From: Filipe David Manana <fdmanana@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1434375680-4115-2-git-send-email-jeffm@suse.com>

On Mon, Jun 15, 2015 at 2:41 PM,  <jeffm@suse.com> wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>
> It's possible, though unexpected, to pass unaligned offsets and lengths
> to btrfs_issue_discard.  We then shift the offset/length values to sector
> units.  If an unaligned offset has been passed, it will result in the
> entire sector being discarded, possibly losing data.  An unaligned
> length is safe but we'll end up returning an inaccurate number of
> discarded bytes.
>
> This patch aligns the offset to the 512B boundary, adjusts the length,
> and warns, since we shouldn't be discarding on an offset that isn't
> aligned with our sector size.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index da1145d..cf9cefd 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -1888,12 +1888,21 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
>                                u64 *discarded_bytes)
>  {
>         int ret = 0;
> +       u64 aligned_start = ALIGN(start, 1 << 9);
>
> -       *discarded_bytes = 0;
> -       ret = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_NOFS, 0);
> -       if (!ret)
> -               *discarded_bytes = len;
> +       if (WARN_ON(start != aligned_start)) {
> +               len -= aligned_start - start;
> +               len = round_down(len, 1 << 9);
> +               start = aligned_start;
> +       }
>
> +       *discarded_bytes = 0;
> +       if (len) {
> +               ret = blkdev_issue_discard(bdev, start >> 9, len >> 9,
> +                                          GFP_NOFS, 0);
> +               if (!ret)
> +                       *discarded_bytes = len;
> +       }
>         return ret;
>  }
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
