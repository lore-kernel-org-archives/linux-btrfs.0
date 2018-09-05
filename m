Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:53201 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbeIEFSR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2018 01:18:17 -0400
Received: by mail-it0-f68.google.com with SMTP id h3-v6so7653085ita.2
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2018 17:50:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-3-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com> <20180830174225.2200-3-josef@toxicpanda.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Tue, 4 Sep 2018 17:50:40 -0700
Message-ID: <CANQeFDAdrxN=APx7+mPh_Hk4EpHtgo4VnRsbr4f1a0tiRrb8Ag@mail.gmail.com>
Subject: Re: [PATCH 02/35] btrfs: add cleanup_ref_head_accounting helper
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 10:41 AM, Josef Bacik <josef@toxicpanda.com> wrote:
> From: Josef Bacik <jbacik@fb.com>
>
> We were missing some quota cleanups in check_ref_cleanup, so break the
> ref head accounting cleanup into a helper and call that from both
> check_ref_cleanup and cleanup_ref_head.  This will hopefully ensure that
> we don't screw up accounting in the future for other things that we add.
>



Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
liubo
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 67 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 39 insertions(+), 28 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6799950fa057..4c9fd35bca07 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2461,6 +2461,41 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
>         return ret ? ret : 1;
>  }
>
> +static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
> +                                       struct btrfs_delayed_ref_head *head)
> +{
> +       struct btrfs_fs_info *fs_info = trans->fs_info;
> +       struct btrfs_delayed_ref_root *delayed_refs =
> +               &trans->transaction->delayed_refs;
> +
> +       if (head->total_ref_mod < 0) {
> +               struct btrfs_space_info *space_info;
> +               u64 flags;
> +
> +               if (head->is_data)
> +                       flags = BTRFS_BLOCK_GROUP_DATA;
> +               else if (head->is_system)
> +                       flags = BTRFS_BLOCK_GROUP_SYSTEM;
> +               else
> +                       flags = BTRFS_BLOCK_GROUP_METADATA;
> +               space_info = __find_space_info(fs_info, flags);
> +               ASSERT(space_info);
> +               percpu_counter_add_batch(&space_info->total_bytes_pinned,
> +                                  -head->num_bytes,
> +                                  BTRFS_TOTAL_BYTES_PINNED_BATCH);
> +
> +               if (head->is_data) {
> +                       spin_lock(&delayed_refs->lock);
> +                       delayed_refs->pending_csums -= head->num_bytes;
> +                       spin_unlock(&delayed_refs->lock);
> +               }
> +       }
> +
> +       /* Also free its reserved qgroup space */
> +       btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
> +                                     head->qgroup_reserved);
> +}
> +
>  static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>                             struct btrfs_delayed_ref_head *head)
>  {
> @@ -2496,31 +2531,6 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>         spin_unlock(&delayed_refs->lock);
>         spin_unlock(&head->lock);
>
> -       trace_run_delayed_ref_head(fs_info, head, 0);
> -
> -       if (head->total_ref_mod < 0) {
> -               struct btrfs_space_info *space_info;
> -               u64 flags;
> -
> -               if (head->is_data)
> -                       flags = BTRFS_BLOCK_GROUP_DATA;
> -               else if (head->is_system)
> -                       flags = BTRFS_BLOCK_GROUP_SYSTEM;
> -               else
> -                       flags = BTRFS_BLOCK_GROUP_METADATA;
> -               space_info = __find_space_info(fs_info, flags);
> -               ASSERT(space_info);
> -               percpu_counter_add_batch(&space_info->total_bytes_pinned,
> -                                  -head->num_bytes,
> -                                  BTRFS_TOTAL_BYTES_PINNED_BATCH);
> -
> -               if (head->is_data) {
> -                       spin_lock(&delayed_refs->lock);
> -                       delayed_refs->pending_csums -= head->num_bytes;
> -                       spin_unlock(&delayed_refs->lock);
> -               }
> -       }
> -
>         if (head->must_insert_reserved) {
>                 btrfs_pin_extent(fs_info, head->bytenr,
>                                  head->num_bytes, 1);
> @@ -2530,9 +2540,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>                 }
>         }
>
> -       /* Also free its reserved qgroup space */
> -       btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
> -                                     head->qgroup_reserved);
> +       cleanup_ref_head_accounting(trans, head);
> +
> +       trace_run_delayed_ref_head(fs_info, head, 0);
>         btrfs_delayed_ref_unlock(head);
>         btrfs_put_delayed_ref_head(head);
>         return 0;
> @@ -6991,6 +7001,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
>         if (head->must_insert_reserved)
>                 ret = 1;
>
> +       cleanup_ref_head_accounting(trans, head);
>         mutex_unlock(&head->mutex);
>         btrfs_put_delayed_ref_head(head);
>         return ret;
> --
> 2.14.3
>
