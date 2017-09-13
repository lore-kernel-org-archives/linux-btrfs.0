Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36277 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdIMKpt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 06:45:49 -0400
Received: by mail-io0-f195.google.com with SMTP id n69so181636ioi.3
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 03:45:48 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1505284729-11844-1-git-send-email-peterh@synology.com>
References: <1505284729-11844-1-git-send-email-peterh@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 13 Sep 2017 11:45:47 +0100
Message-ID: <CAL3q7H5vc7T5LmO0uzgWsqO4Lv8xGYf1Nxd8eYrbgr4RYsm6MQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: incremental send, apply asynchronous page cache readahead
To: peterh <peterh@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 13, 2017 at 7:38 AM, peterh <peterh@synology.com> wrote:
> From: Kuanling Huang <peterh@synology.com>
>
> By analyzing the perf on btrfs send, we found it take large
> amount of cpu time on page_cache_sync_readahead. This effort
> can be reduced after switching to asynchronous one. Overall
> performance gain on HDD and SSD were 9 and 15 respectively if
> simply send a large file.

Besides what was pointed before, about saying what those 9 and 15 are,
the subject mentions incremental send, but there's nothing here that
is specific to incremental sends, as it applies to full send
operations as well, so please also change the subject.
>
> Signed-off-by: Kuanling Huang <peterh@synology.com>
> ---
>  fs/btrfs/send.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 63a6152..ac67ff6 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -4475,16 +4475,27 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
>         /* initial readahead */
>         memset(&sctx->ra, 0, sizeof(struct file_ra_state));
>         file_ra_state_init(&sctx->ra, inode->i_mapping);
> -       btrfs_force_ra(inode->i_mapping, &sctx->ra, NULL, index,
> -                      last_index - index + 1);
>
>         while (index <= last_index) {
>                 unsigned cur_len = min_t(unsigned, len,
>                                          PAGE_CACHE_SIZE - pg_offset);
> -               page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);

You based this patch on an old code base. Currently it is GFP_KERNEL
and not GFP_NOFS anymore.
Please update the patch.

> +               page = find_lock_page(inode->i_mapping, index);
>                 if (!page) {
> -                       ret = -ENOMEM;
> -                       break;
> +                       page_cache_sync_readahead(inode->i_mapping,
> +                               &sctx->ra, NULL, index,
> +                               last_index + 1 - index);
> +
> +                       page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
> +                       if (unlikely(!page)) {

Please avoid polluting the code with unlikely/likely macros (unless
there's really a significant performance win, which isn't the case
here I bet).


> +                               ret = -ENOMEM;
> +                               break;
> +                       }
> +               }
> +
> +               if (PageReadahead(page)) {
> +                       page_cache_async_readahead(inode->i_mapping,
> +                               &sctx->ra, NULL, page, index,
> +                               last_index + 1 - index);
>                 }
>
>                 if (!PageUptodate(page)) {
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
