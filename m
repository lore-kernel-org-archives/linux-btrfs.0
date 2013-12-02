Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:37675 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3LBQYU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Dec 2013 11:24:20 -0500
Received: by mail-wg0-f51.google.com with SMTP id b13so9129543wgh.18
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Dec 2013 08:24:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386001014-8226-1-git-send-email-wangshilong1991@gmail.com>
References: <1386001014-8226-1-git-send-email-wangshilong1991@gmail.com>
Date: Tue, 3 Dec 2013 00:24:19 +0800
Message-ID: <CAP9B-QnEkX+jScXOV7Mgo3eK95nzWUBjPZcv_wPH70TRnwq9NQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix generation mismatch when scrubbing supers
From: Shilong Wang <wangshilong1991@gmail.com>
To: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
Cc: Wang Shilong <wangshilong1991@gmail.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Sebastian,

Would you please apply this patch in your test box and see if the
problem still exist.

Thanks,
Wang
2013/12/3 Wang Shilong <wangshilong1991@gmail.com>:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> We came a race condition when scrubbing superblocks, the story is:
>
> In commiting transaction, we will update last_trans_commited after
> writting superblocks. if a scrub start after writting superblocks
> and before last_trans_commited, generation mismatch happens!
>
> We fix it by protecting writting superblock and updating last_trans_commited
> with tree_log_mutex.
>
> Reported-by: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/scrub.c       | 11 +++++++----
>  fs/btrfs/transaction.c | 13 ++++++++++---
>  2 files changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 561e2f1..afa2f01 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2932,12 +2932,15 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>         atomic_inc(&fs_info->scrubs_running);
>         mutex_unlock(&fs_info->scrub_lock);
>
> +       /*
> +        * by holding tree_log_mutex while scrubbing supers
> +        * we can avoid generation mismatch. See comments in commiting
> +        * transaction when updating last_trans_commited.
> +        */
>         if (!is_dev_replace) {
> -               /*
> -                * by holding device list mutex, we can
> -                * kick off writing super in log tree sync.
> -                */
> +               mutex_lock(&fs_info->tree_log_mutex);
>                 ret = scrub_supers(sctx, dev);
> +               mutex_unlock(&fs_info->tree_log_mutex);
>         }
>         mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index c6a872a..052eb22 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1898,15 +1898,22 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>                 goto cleanup_transaction;
>         }
>
> +       btrfs_finish_extent_commit(trans, root);
> +
> +       /*
> +        * we must gurantee last_trans_commited update is protected by
> +        * tree_log_mutex with write_ctree_super together, otherwise,
> +        * scubbing super will come in before updating last_trans_commited
> +        * and we will get generation mismatch when scrubbing superblocks.
> +        */
> +       root->fs_info->last_trans_committed = cur_trans->transid;
> +
>         /*
>          * the super is written, we can safely allow the tree-loggers
>          * to go about their business
>          */
>         mutex_unlock(&root->fs_info->tree_log_mutex);
>
> -       btrfs_finish_extent_commit(trans, root);
> -
> -       root->fs_info->last_trans_committed = cur_trans->transid;
>         /*
>          * We needn't acquire the lock here because there is no other task
>          * which can change it.
> --
> 1.8.4
>
