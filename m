Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:59777 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3FXSyG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 14:54:06 -0400
Received: by mail-we0-f180.google.com with SMTP id w56so8608643wes.11
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 11:54:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50D17662.6040800@cn.fujitsu.com>
References: <50D17662.6040800@cn.fujitsu.com>
Date: Mon, 24 Jun 2013 21:54:04 +0300
Message-ID: <CAOcd+r35WffjhuC4Zk+h4cnewP+PsbxjfBKdrd1qa9SrBFZzQw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: make delayed ref lock logic more readable
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: miaox@cn.fujitsu.com
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,
I believe the name of this patch is misleading. The significant
contribution of this patch IMO is the btrfs_release_ref_cluster(),
which is being called when btrfs_run_delayed_refs() aborts the
transaction. Without this fix, btrfs_destroy_delayed_refs() was
crashing when it was doing:
list_del_init(&head->cluster);

Because the head of the list was a local variable in some stack frame
that is long gone...

So I had weird kernel crashes like:
kernel: [  385.668132] kernel tried to execute NX-protected page -
exploit attempt? (uid: 0)
kernel: [  385.669583] BUG: unable to handle kernel paging request at
ffff8800487abd68

Thanks anyways for fixing this.

Alex.



On Wed, Dec 19, 2012 at 10:10 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> Locking and unlocking delayed ref mutex are in the different functions,
> and the name of lock functions is not uniform, so the readability is not
> so good, this patch optimizes the lock logic and makes it more readable.
>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/delayed-ref.c |  8 ++++++++
>  fs/btrfs/delayed-ref.h |  6 ++++++
>  fs/btrfs/extent-tree.c | 42 ++++++++++++++++++++++++------------------
>  3 files changed, 38 insertions(+), 18 deletions(-)
>
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 455894f..b7a0641 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -426,6 +426,14 @@ again:
>         return 1;
>  }
>
> +void btrfs_release_ref_cluster(struct list_head *cluster)
> +{
> +       struct list_head *pos, *q;
> +
> +       list_for_each_safe(pos, q, cluster)
> +               list_del_init(pos);
> +}
> +
>  /*
>   * helper function to update an extent delayed ref in the
>   * rbtree.  existing and update must both have the same
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index fe50392..7939149 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -211,8 +211,14 @@ struct btrfs_delayed_ref_head *
>  btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
>  int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
>                            struct btrfs_delayed_ref_head *head);
> +static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
> +{
> +       mutex_unlock(&head->mutex);
> +}
> +
>  int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
>                            struct list_head *cluster, u64 search_start);
> +void btrfs_release_ref_cluster(struct list_head *cluster);
>
>  int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
>                             struct btrfs_delayed_ref_root *delayed_refs,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index ae3c24a..b6ed965 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2143,7 +2143,6 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
>                                                       node->num_bytes);
>                         }
>                 }
> -               mutex_unlock(&head->mutex);
>                 return ret;
>         }
>
> @@ -2258,7 +2257,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>                          * process of being added. Don't run this ref yet.
>                          */
>                         list_del_init(&locked_ref->cluster);
> -                       mutex_unlock(&locked_ref->mutex);
> +                       btrfs_delayed_ref_unlock(locked_ref);
>                         locked_ref = NULL;
>                         delayed_refs->num_heads_ready++;
>                         spin_unlock(&delayed_refs->lock);
> @@ -2297,25 +2296,22 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>                                 btrfs_free_delayed_extent_op(extent_op);
>
>                                 if (ret) {
> -                                       list_del_init(&locked_ref->cluster);
> -                                       mutex_unlock(&locked_ref->mutex);
> -
> -                                       printk(KERN_DEBUG "btrfs: run_delayed_extent_op returned %d\n", ret);
> +                                       printk(KERN_DEBUG
> +                                              "btrfs: run_delayed_extent_op "
> +                                              "returned %d\n", ret);
>                                         spin_lock(&delayed_refs->lock);
> +                                       btrfs_delayed_ref_unlock(locked_ref);
>                                         return ret;
>                                 }
>
>                                 goto next;
>                         }
> -
> -                       list_del_init(&locked_ref->cluster);
> -                       locked_ref = NULL;
>                 }
>
>                 ref->in_tree = 0;
>                 rb_erase(&ref->rb_node, &delayed_refs->root);
>                 delayed_refs->num_entries--;
> -               if (locked_ref) {
> +               if (!btrfs_delayed_ref_is_head(ref)) {
>                         /*
>                          * when we play the delayed ref, also correct the
>                          * ref_mod on head
> @@ -2337,20 +2333,29 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>                 ret = run_one_delayed_ref(trans, root, ref, extent_op,
>                                           must_insert_reserved);
>
> -               btrfs_put_delayed_ref(ref);
>                 btrfs_free_delayed_extent_op(extent_op);
> -               count++;
> -
>                 if (ret) {
> -                       if (locked_ref) {
> -                               list_del_init(&locked_ref->cluster);
> -                               mutex_unlock(&locked_ref->mutex);
> -                       }
> -                       printk(KERN_DEBUG "btrfs: run_one_delayed_ref returned %d\n", ret);
> +                       btrfs_delayed_ref_unlock(locked_ref);
> +                       btrfs_put_delayed_ref(ref);
> +                       printk(KERN_DEBUG
> +                              "btrfs: run_one_delayed_ref returned %d\n", ret);
>                         spin_lock(&delayed_refs->lock);
>                         return ret;
>                 }
>
> +               /*
> +                * If this node is a head, that means all the refs in this head
> +                * have been dealt with, and we will pick the next head to deal
> +                * with, so we must unlock the head and drop it from the cluster
> +                * list before we release it.
> +                */
> +               if (btrfs_delayed_ref_is_head(ref)) {
> +                       list_del_init(&locked_ref->cluster);
> +                       btrfs_delayed_ref_unlock(locked_ref);
> +                       locked_ref = NULL;
> +               }
> +               btrfs_put_delayed_ref(ref);
> +               count++;
>  next:
>                 cond_resched();
>                 spin_lock(&delayed_refs->lock);
> @@ -2500,6 +2505,7 @@ again:
>
>                 ret = run_clustered_refs(trans, root, &cluster);
>                 if (ret < 0) {
> +                       btrfs_release_ref_cluster(&cluster);
>                         spin_unlock(&delayed_refs->lock);
>                         btrfs_abort_transaction(trans, root, ret);
>                         return ret;
> --
> 1.7.11.7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
