Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:50887 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbeIEGMm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2018 02:12:42 -0400
Received: by mail-it0-f67.google.com with SMTP id j81-v6so7809276ite.0
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2018 18:44:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-21-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com> <20180830174225.2200-21-josef@toxicpanda.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Tue, 4 Sep 2018 18:44:55 -0700
Message-ID: <CANQeFDCKfRi17E20RfbGHoa8ZSN5QvEdE7BS07qHKQYfofZi5Q@mail.gmail.com>
Subject: Re: [PATCH 20/35] btrfs: reset max_extent_size on clear in a bitmap
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 10:42 AM, Josef Bacik <josef@toxicpanda.com> wrote:
> From: Josef Bacik <jbacik@fb.com>
>
> We need to clear the max_extent_size when we clear bits from a bitmap
> since it could have been from the range that contains the
> max_extent_size.
>

Looks OK.
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
liubo

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/free-space-cache.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 53521027dd78..7faca05e61ea 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1683,6 +1683,8 @@ static inline void __bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
>         bitmap_clear(info->bitmap, start, count);
>
>         info->bytes -= bytes;
> +       if (info->max_extent_size > ctl->unit)
> +               info->max_extent_size = 0;
>  }
>
>  static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
> --
> 2.14.3
>
