Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:55206 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbeIEGJe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2018 02:09:34 -0400
Received: by mail-it0-f45.google.com with SMTP id f14-v6so7781555ita.4
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2018 18:41:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-9-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com> <20180830174225.2200-9-josef@toxicpanda.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Tue, 4 Sep 2018 18:41:48 -0700
Message-ID: <CANQeFDDJ2Fmi=8Vg7upcm7ih_tjeuXqWPEvyKwa9sF4H65U9HA@mail.gmail.com>
Subject: Re: [PATCH 08/35] btrfs: release metadata before running delayed refs
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 10:41 AM, Josef Bacik <josef@toxicpanda.com> wrote:
> We want to release the unused reservation we have since it refills the
> delayed refs reserve, which will make everything go smoother when
> running the delayed refs if we're short on our reservation.
>

Looks good.
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
liubo

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/transaction.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 99741254e27e..ebb0c0405598 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1915,6 +1915,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>                 return ret;
>         }
>
> +       btrfs_trans_release_metadata(trans);
> +       trans->block_rsv = NULL;
> +
>         /* make a pass through all the delayed refs we have so far
>          * any runnings procs may add more while we are here
>          */
> @@ -1924,9 +1927,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>                 return ret;
>         }
>
> -       btrfs_trans_release_metadata(trans);
> -       trans->block_rsv = NULL;
> -
>         cur_trans = trans->transaction;
>
>         /*
> --
> 2.14.3
>
