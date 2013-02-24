Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:53885 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3BXTt5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Feb 2013 14:49:57 -0500
Received: by mail-we0-f178.google.com with SMTP id x48so2014516wey.9
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Feb 2013 11:49:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51249468.6010004@cn.fujitsu.com>
References: <51249468.6010004@cn.fujitsu.com>
Date: Sun, 24 Feb 2013 21:49:55 +0200
Message-ID: <CAOcd+r35uFwUsmRuLRR3eGkVcceP2QEimhrN7xxSnBzB-LWVyQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] Btrfs: fix the deadlock between the transaction
 start/attach and commit
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: miaox@cn.fujitsu.com
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,
can you please explain your solution a bit more.

On Wed, Feb 20, 2013 at 11:16 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> Now btrfs_commit_transaction() does this
>
> ret = btrfs_run_ordered_operations(root, 0)
>
> which async flushes all inodes on the ordered operations list, it introduced
> a deadlock that transaction-start task, transaction-commit task and the flush
> workers waited for each other.
> (See the following URL to get the detail
>  http://marc.info/?l=linux-btrfs&m=136070705732646&w=2)
>
> As we know, if ->in_commit is set, it means someone is committing the
> current transaction, we should not try to join it if we are not JOIN
> or JOIN_NOLOCK, wait is the best choice for it. In this way, we can avoid
> the above problem. In this way, there is another benefit: there is no new
> transaction handle to block the transaction which is on the way of commit,
> once we set ->in_commit.
>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/transaction.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index bc2f2d1..71b7e2e 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -51,6 +51,14 @@ static noinline void switch_commit_root(struct btrfs_root *root)
>         root->commit_root = btrfs_root_node(root);
>  }
>
> +static inline int can_join_transaction(struct btrfs_transaction *trans,
> +                                      int type)
> +{
> +       return !(trans->in_commit &&
> +                type != TRANS_JOIN &&
> +                type != TRANS_JOIN_NOLOCK);
> +}
> +
>  /*
>   * either allocate a new transaction or hop into the existing one
>   */
> @@ -86,6 +94,10 @@ loop:
>                         spin_unlock(&fs_info->trans_lock);
>                         return cur_trans->aborted;
>                 }
> +               if (!can_join_transaction(cur_trans, type)) {
> +                       spin_unlock(&fs_info->trans_lock);
> +                       return -EBUSY;
> +               }
>                 atomic_inc(&cur_trans->use_count);
>                 atomic_inc(&cur_trans->num_writers);
>                 cur_trans->num_joined++;
> @@ -360,8 +372,11 @@ again:
>
>         do {
>                 ret = join_transaction(root, type);
> -               if (ret == -EBUSY)
> +               if (ret == -EBUSY) {
>                         wait_current_trans(root);
> +                       if (unlikely(type == TRANS_ATTACH))
> +                               ret = -ENOENT;
> +               }

So I understand that instead of incrementing num_writes and joining
the current transaction, you do not join and wait for the current
transaction to unblock.

Which task in Josef's example
http://marc.info/?l=linux-btrfs&m=136070705732646&w=2
task 1, task 2 or task 3 is the one that will not join the
transaction, but instead wait?

Also, I think I don't fully understand Josef's example. What is
preventing from async flushing to complete?
Is task 3 waiting because trans_no_join is set?
Is task 3 the one that actually does the delalloc flush?

Thanks,
Alex.






>         } while (ret == -EBUSY);
>
>         if (ret < 0) {
> --
> 1.6.5.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
