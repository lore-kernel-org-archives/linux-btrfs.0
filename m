Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:37195 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932282AbeD0IsZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 04:48:25 -0400
Received: by mail-vk0-f65.google.com with SMTP id m144-v6so635100vke.4
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 01:48:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180426192351.473-1-jeffm@suse.com>
References: <20180426192351.473-1-jeffm@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 27 Apr 2018 09:48:24 +0100
Message-ID: <CAL3q7H6hJxE383ZkV4JhTr44_i5tQCtU4nPGGxeOb+_Y2mDzxQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2018 at 8:23 PM,  <jeffm@suse.com> wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>
> Commit d2c609b834d6 (Btrfs: fix qgroup rescan worker initialization)
> fixed the issue with BTRFS_IOC_QUOTA_RESCAN_WAIT being racy, but
> ended up reintroducing the hang-on-unmount bug that the commit it
> intended to fix addressed.
>
> The race this time is between qgroup_rescan_init setting
> ->qgroup_rescan_running = true and the worker starting.  There are
> many scenarios where we initialize the worker and never start it.  The
> completion btrfs_ioctl_quota_rescan_wait waits for will never come.
> This can happen even without involving error handling, since mounting
> the file system read-only returns between initializing the worker and
> queueing it.
>
> The right place to do it is when we're queuing the worker.  The flag
> really just means that btrfs_ioctl_quota_rescan_wait should wait for
> a completion.
>
> This patch introduces a new helper, queue_rescan_worker, that handles
> the ->qgroup_rescan_running flag, including any races with umount.
>
> While we're at it, ->qgroup_rescan_running is protected only by the
> ->qgroup_rescan_mutex.  btrfs_ioctl_quota_rescan_wait doesn't need
> to take the spinlock too.
>
> Fixes: d2c609b834d6 (Btrfs: fix qgroup rescan worker initialization)

The commit id and subjects don't match:

commit d2c609b834d62f1e91f1635a27dca29f7806d3d6
Author: Jeff Mahoney <jeffm@suse.com>
Date:   Mon Aug 15 12:10:33 2016 -0400

    btrfs: properly track when rescan worker is running


> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/ctree.h  |  1 +
>  fs/btrfs/qgroup.c | 40 ++++++++++++++++++++++++++++------------
>  2 files changed, 29 insertions(+), 12 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index da308774b8a4..dbba615f4d0f 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1045,6 +1045,7 @@ struct btrfs_fs_info {
>         struct btrfs_workqueue *qgroup_rescan_workers;
>         struct completion qgroup_rescan_completion;
>         struct btrfs_work qgroup_rescan_work;
> +       /* qgroup rescan worker is running or queued to run */
>         bool qgroup_rescan_running;     /* protected by qgroup_rescan_lock */
>
>         /* filesystem state */
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index aa259d6986e1..be491b6c020a 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2072,6 +2072,30 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
>         return ret;
>  }
>
> +static void queue_rescan_worker(struct btrfs_fs_info *fs_info)
> +{
> +       mutex_lock(&fs_info->qgroup_rescan_lock);
> +       if (btrfs_fs_closing(fs_info)) {
> +               mutex_unlock(&fs_info->qgroup_rescan_lock);
> +               return;
> +       }
> +       if (WARN_ON(fs_info->qgroup_rescan_running)) {
> +               btrfs_warn(fs_info, "rescan worker already queued");
> +               mutex_unlock(&fs_info->qgroup_rescan_lock);
> +               return;
> +       }
> +
> +       /*
> +        * Being queued is enough for btrfs_qgroup_wait_for_completion
> +        * to need to wait.
> +        */
> +       fs_info->qgroup_rescan_running = true;
> +       mutex_unlock(&fs_info->qgroup_rescan_lock);
> +
> +       btrfs_queue_work(fs_info->qgroup_rescan_workers,
> +                        &fs_info->qgroup_rescan_work);
> +}
> +
>  /*
>   * called from commit_transaction. Writes all changed qgroups to disk.
>   */
> @@ -2123,8 +2147,7 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
>                 ret = qgroup_rescan_init(fs_info, 0, 1);
>                 if (!ret) {
>                         qgroup_rescan_zero_tracking(fs_info);
> -                       btrfs_queue_work(fs_info->qgroup_rescan_workers,
> -                                        &fs_info->qgroup_rescan_work);
> +                       queue_rescan_worker(fs_info);
>                 }
>                 ret = 0;
>         }
> @@ -2713,7 +2736,6 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
>                 sizeof(fs_info->qgroup_rescan_progress));
>         fs_info->qgroup_rescan_progress.objectid = progress_objectid;
>         init_completion(&fs_info->qgroup_rescan_completion);
> -       fs_info->qgroup_rescan_running = true;
>
>         spin_unlock(&fs_info->qgroup_lock);
>         mutex_unlock(&fs_info->qgroup_rescan_lock);
> @@ -2785,9 +2807,7 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
>
>         qgroup_rescan_zero_tracking(fs_info);
>
> -       btrfs_queue_work(fs_info->qgroup_rescan_workers,
> -                        &fs_info->qgroup_rescan_work);
> -
> +       queue_rescan_worker(fs_info);
>         return 0;
>  }
>
> @@ -2798,9 +2818,7 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
>         int ret = 0;
>
>         mutex_lock(&fs_info->qgroup_rescan_lock);
> -       spin_lock(&fs_info->qgroup_lock);
>         running = fs_info->qgroup_rescan_running;
> -       spin_unlock(&fs_info->qgroup_lock);
>         mutex_unlock(&fs_info->qgroup_rescan_lock);
>
>         if (!running)
> @@ -2819,12 +2837,10 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
>   * this is only called from open_ctree where we're still single threaded, thus
>   * locking is omitted here.
>   */
> -void
> -btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
> +void btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
>  {
>         if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
> -               btrfs_queue_work(fs_info->qgroup_rescan_workers,
> -                                &fs_info->qgroup_rescan_work);
> +               queue_rescan_worker(fs_info);
>  }
>
>  /*
> --
> 2.12.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
