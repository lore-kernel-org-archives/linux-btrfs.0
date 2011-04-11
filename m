From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: avoid taking the trans_mutex in btrfs_end_transaction
Date: Mon, 11 Apr 2011 16:41:12 -0400
Message-ID: <1302553891-sup-4908@think>
References: <1302551357-27538-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1302551357-27538-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-04-11 15:49:17 -0400:
> I've been working on making our O_DIRECT latency not suck and I noticed we were
> taking the trans_mutex in btrfs_end_transaction.  So to do this we convert
> num_writers and use_count to atomic_t's and just decrement them in
> btrfs_end_transaction.  I got rid of the put_transaction() in
> btrfs_end_transaction() since we will never free the transaction from
> btrfs_end_transaction().  Tested this with xfstests and everything went
> smoothly.  Thanks,

Hmmm, this is smart, there's no reason to take the lock here.  But
there's one little problem:

> @@ -466,19 +465,20 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>              wake_up_process(info->transaction_kthread);
>      }
>  
> -    if (lock)
> -        mutex_lock(&info->trans_mutex);
>      WARN_ON(cur_trans != info->running_transaction);
> -    WARN_ON(cur_trans->num_writers < 1);
> -    cur_trans->num_writers--;
> +    WARN_ON(atomic_read(&cur_trans->num_writers) < 1);
> +    atomic_dec(&cur_trans->num_writers);

We've just decremented num_writers, which could have been the only thing
preventing a commit from finishing.  The entire commit could finish at
any time after this line.

>  
>      smp_mb();
>      if (waitqueue_active(&cur_trans->writer_wait))
>          wake_up(&cur_trans->writer_wait);
> -    put_transaction(cur_trans);
> -    if (lock)
> -        mutex_unlock(&info->trans_mutex);
>  
> +    /*
> +     * A trans handle will never actually be putting the last reference of a
> +     * transaction, so just dec the use count to avoid taking the trans
> +     * mutex.
> +     */
> +    atomic_dec(&cur_trans->use_count);

Which could make this the last and final reference on
cur_trans->use_count.

There's no reason we need the lock in put_transaction, other than
manipulating the list of running transactions.  But I don't see any
reason we can't delete ourselves from the list when the commit is done,
which would let you keep a lock less put_transaction.

-chris
