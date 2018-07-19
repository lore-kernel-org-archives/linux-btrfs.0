Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:46390 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731645AbeGSPzm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:55:42 -0400
Received: by mail-ua0-f194.google.com with SMTP id r18-v6so5401749ual.13
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 08:12:05 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180719145006.17532-17-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com> <20180719145006.17532-17-josef@toxicpanda.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 19 Jul 2018 16:12:04 +0100
Message-ID: <CAL3q7H7o2Lpg_VFX8EySamWyAjuZQTp9cwaQvfBMHSe_cnyxNQ@mail.gmail.com>
Subject: Re: [PATCH 17/22] btrfs: don't take the dio_sem in the fsync path
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 3:50 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> Since we've changed the fsync() path to always run ordered extents
> before doing the tree log we no longer need to take the dio_sem in the
> tree log path.  This gets rid of a lockdep splat that I was seeing with
> the AIO tests.

The dio_sem can be removed completely, it was added to synchronize
lockless dio writes with fsync to avoid races.
I.e., just removing it here in the tree-log makes it useless.

thanks!

>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/tree-log.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index f8220ec02036..aa06e1954b84 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -4439,7 +4439,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>
>         INIT_LIST_HEAD(&extents);
>
> -       down_write(&inode->dio_sem);
>         write_lock(&tree->lock);
>         test_gen = root->fs_info->last_trans_committed;
>         logged_start = start;
> @@ -4520,7 +4519,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>         }
>         WARN_ON(!list_empty(&extents));
>         write_unlock(&tree->lock);
> -       up_write(&inode->dio_sem);
>
>         btrfs_release_path(path);
>         if (!ret)
> --
> 2.14.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
