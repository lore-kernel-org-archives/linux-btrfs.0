Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:57394 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaECUEO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 May 2014 16:04:14 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so5874253wes.18
        for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 13:04:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394150467-5990-1-git-send-email-jbacik@fb.com>
References: <1394150467-5990-1-git-send-email-jbacik@fb.com>
Date: Sat, 3 May 2014 23:04:12 +0300
Message-ID: <CAOcd+r1Mkjo-wEAKJsRiLUdn53w0qnOyMaLWVchSekffG1q+=A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock with nested trans handles
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fb.com>, zab@redhat.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
this problem could not happen when find_free_extent() was receiving a
transaction handle (which was changed in "Btrfs: avoid starting a
transaction in the write path"), correct? Because it would have used
the passed transaction handle to do the chunk allocation, and thus
would not need to do join_transaction/end_transaction leading to
recursive run_delayed_refs call.

Alex.


On Fri, Mar 7, 2014 at 3:01 AM, Josef Bacik <jbacik@fb.com> wrote:
> Zach found this deadlock that would happen like this
>
> btrfs_end_transaction <- reduce trans->use_count to 0
>   btrfs_run_delayed_refs
>     btrfs_cow_block
>       find_free_extent
>         btrfs_start_transaction <- increase trans->use_count to 1
>           allocate chunk
>         btrfs_end_transaction <- decrease trans->use_count to 0
>           btrfs_run_delayed_refs
>             lock tree block we are cowing above ^^
>
> We need to only decrease trans->use_count if it is above 1, otherwise leave it
> alone.  This will make nested trans be the only ones who decrease their added
> ref, and will let us get rid of the trans->use_count++ hack if we have to commit
> the transaction.  Thanks,
>
> cc: stable@vger.kernel.org
> Reported-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/transaction.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 34cd831..b05bf58 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -683,7 +683,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>         int lock = (trans->type != TRANS_JOIN_NOLOCK);
>         int err = 0;
>
> -       if (--trans->use_count) {
> +       if (trans->use_count > 1) {
> +               trans->use_count--;
>                 trans->block_rsv = trans->orig_rsv;
>                 return 0;
>         }
> @@ -731,17 +732,10 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>         }
>
>         if (lock && ACCESS_ONCE(cur_trans->state) == TRANS_STATE_BLOCKED) {
> -               if (throttle) {
> -                       /*
> -                        * We may race with somebody else here so end up having
> -                        * to call end_transaction on ourselves again, so inc
> -                        * our use_count.
> -                        */
> -                       trans->use_count++;
> +               if (throttle)
>                         return btrfs_commit_transaction(trans, root);
> -               } else {
> +               else
>                         wake_up_process(info->transaction_kthread);
> -               }
>         }
>
>         if (trans->type & __TRANS_FREEZABLE)
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
