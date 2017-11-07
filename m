Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:51602 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756509AbdKGN6O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Nov 2017 08:58:14 -0500
Received: by mail-io0-f196.google.com with SMTP id b186so2179740iof.8
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Nov 2017 05:58:14 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20171106182402.11500-1-dsterba@suse.com>
References: <20171106182402.11500-1-dsterba@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Tue, 7 Nov 2017 13:58:12 +0000
Message-ID: <CAL3q7H6n8sxOjE8tRBmCMFSjF=F9_B1dNkaGj0FD3UO5=95u+w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: switch uuid tree semaphore to mutex
To: David Sterba <dsterba@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 6, 2017 at 6:24 PM, David Sterba <dsterba@suse.com> wrote:
> The uuid_tree_rescan_sem is used as a mutex (initialized with value 1
> and with at most one active user), no reason to obscure that as a
> semaphore.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h   |  6 +++++-
>  fs/btrfs/disk-io.c |  6 +++---
>  fs/btrfs/super.c   |  4 ++--
>  fs/btrfs/volumes.c | 12 ++++++------
>  4 files changed, 16 insertions(+), 12 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index cab2f3607040..a643ff0fa0f0 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1073,7 +1073,11 @@ struct btrfs_fs_info {
>         struct percpu_counter bio_counter;
>         wait_queue_head_t replace_wait;
>
> -       struct semaphore uuid_tree_rescan_sem;
> +       /*
> +        * Protect updating of uuid_tree, can be used to wait for the task
> +        * completion
> +        */
> +       struct mutex uuid_tree_mutex;
>
>         /* Used to reclaim the metadata space in the background. */
>         struct work_struct async_reclaim_work;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 53c9145a56e9..8330226234f2 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2542,10 +2542,10 @@ int open_ctree(struct super_block *sb,
>         mutex_init(&fs_info->cleaner_mutex);
>         mutex_init(&fs_info->volume_mutex);
>         mutex_init(&fs_info->ro_block_group_mutex);
> +       mutex_init(&fs_info->uuid_tree_mutex);
>         init_rwsem(&fs_info->commit_root_sem);
>         init_rwsem(&fs_info->cleanup_work_sem);
>         init_rwsem(&fs_info->subvol_sem);
> -       sema_init(&fs_info->uuid_tree_rescan_sem, 1);
>
>         btrfs_init_dev_replace_locks(fs_info);
>         btrfs_init_qgroup(fs_info);
> @@ -3696,9 +3696,9 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>         btrfs_qgroup_wait_for_completion(fs_info, false);
>
>         /* wait for the uuid_scan task to finish */
> -       down(&fs_info->uuid_tree_rescan_sem);
> +       mutex_lock(&fs_info->uuid_tree_mutex);
>         /* avoid complains from lockdep et al., set sem back to initial state */

This comment should go away too.

> -       up(&fs_info->uuid_tree_rescan_sem);
> +       mutex_unlock(&fs_info->uuid_tree_mutex);
>
>         /* pause restriper - we want to resume on mount */
>         btrfs_pause_balance(fs_info);
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 713f899bae81..5d0686c18bad 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1777,9 +1777,9 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>                 cancel_work_sync(&fs_info->async_reclaim_work);
>
>                 /* wait for the uuid_scan task to finish */
> -               down(&fs_info->uuid_tree_rescan_sem);
> +               mutex_lock(&fs_info->uuid_tree_mutex);
>                 /* avoid complains from lockdep et al. */
> -               up(&fs_info->uuid_tree_rescan_sem);
> +               mutex_unlock(&fs_info->uuid_tree_mutex);
>
>                 sb->s_flags |= MS_RDONLY;
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1b43f762906f..b2949232ba52 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4202,7 +4202,7 @@ static int btrfs_uuid_scan_kthread(void *data)
>                 btrfs_warn(fs_info, "btrfs_uuid_scan_kthread failed %d", ret);
>         else
>                 set_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags);
> -       up(&fs_info->uuid_tree_rescan_sem);
> +       mutex_unlock(&fs_info->uuid_tree_mutex);
>         return 0;
>  }
>
> @@ -4264,7 +4264,7 @@ static int btrfs_uuid_rescan_kthread(void *data)
>         ret = btrfs_uuid_tree_iterate(fs_info, btrfs_check_uuid_tree_entry);
>         if (ret < 0) {
>                 btrfs_warn(fs_info, "iterating uuid_tree failed %d", ret);
> -               up(&fs_info->uuid_tree_rescan_sem);
> +               mutex_unlock(&fs_info->uuid_tree_mutex);
>                 return ret;
>         }
>         return btrfs_uuid_scan_kthread(data);
> @@ -4301,12 +4301,12 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
>         if (ret)
>                 return ret;
>
> -       down(&fs_info->uuid_tree_rescan_sem);
> +       mutex_lock(&fs_info->uuid_tree_mutex);
>         task = kthread_run(btrfs_uuid_scan_kthread, fs_info, "btrfs-uuid");
>         if (IS_ERR(task)) {
>                 /* fs_info->update_uuid_tree_gen remains 0 in all error case */
>                 btrfs_warn(fs_info, "failed to start uuid_scan task");
> -               up(&fs_info->uuid_tree_rescan_sem);
> +               mutex_unlock(&fs_info->uuid_tree_mutex);
>                 return PTR_ERR(task);
>         }
>
> @@ -4317,12 +4317,12 @@ int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info)
>  {
>         struct task_struct *task;
>
> -       down(&fs_info->uuid_tree_rescan_sem);
> +       mutex_lock(&fs_info->uuid_tree_mutex);
>         task = kthread_run(btrfs_uuid_rescan_kthread, fs_info, "btrfs-uuid");
>         if (IS_ERR(task)) {
>                 /* fs_info->update_uuid_tree_gen remains 0 in all error case */
>                 btrfs_warn(fs_info, "failed to start uuid_rescan task");
> -               up(&fs_info->uuid_tree_rescan_sem);
> +               mutex_unlock(&fs_info->uuid_tree_mutex);
>                 return PTR_ERR(task);
>         }
>
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
