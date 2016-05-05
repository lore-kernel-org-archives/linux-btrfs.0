Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:35917 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbcEEJMd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 May 2016 05:12:33 -0400
Received: by mail-ig0-f196.google.com with SMTP id c3so1312125igl.3
        for <linux-btrfs@vger.kernel.org>; Thu, 05 May 2016 02:12:32 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1462422229-23797-1-git-send-email-ce3g8jdj@umail.furryterror.org>
References: <1462422229-23797-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Date: Thu, 5 May 2016 10:12:32 +0100
Message-ID: <CAL3q7H6t85yJhztBrCMp=YF9Th6Eh369kZsKh9dwXHS-3isaog@mail.gmail.com>
Subject: Re: [PATCH] btrfs: don't force mounts to wait for cleaner_kthread to
 delete one or more subvolumes
From: Filipe Manana <fdmanana@gmail.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 5, 2016 at 5:23 AM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> During a mount, we start the cleaner kthread first because the transaction
> kthread wants to wake up the cleaner kthread.  We start the transaction
> kthread next because everything in btrfs wants transactions.  We do reloc
> recovery in the thread that was doing the original mount call once the
> transaction kthread is running.  This means that the cleaner kthread
> could already be running when reloc recovery happens (e.g. if a snapshot
> delete was started before a crash).
>
> Relocation does not play well with the cleaner kthread, so a mutex was
> added in commit 5f3164813b90f7dbcb5c3ab9006906222ce471b7 "Btrfs: fix
> race between balance recovery and root deletion" to prevent both from
> being active at the same time.
>
> If the cleaner kthread is already holding the mutex by the time we get
> to btrfs_recover_relocation, the mount will be blocked until at least
> one deleted subvolume is cleaned (possibly more if the mount process
> doesn't get the lock right away).  During this time (which could be an
> arbitrarily long time on a large/slow filesystem), the mount process is
> stuck and the filesystem is unnecessarily inaccessible.
>
> Fix this by locking cleaner_mutex before we start cleaner_kthread, and
> unlocking the mutex after mount no longer requires it.  This ensures
> that the mounting process will not be blocked by the cleaner kthread.
> The cleaner kthread is already prepared for mutex contention and will
> just go to sleep until the mutex is available.

You miss your Signed-off-by: .... tag (git format-patch or git commit
with -s add it automatically).
Once you get that, you can add my Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/disk-io.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index d8d68af..7c8f435 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2509,6 +2509,7 @@ int open_ctree(struct super_block *sb,
>         int num_backups_tried = 0;
>         int backup_index = 0;
>         int max_active;
> +       bool cleaner_mutex_locked = false;
>
>         tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
>         chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
> @@ -2988,6 +2989,13 @@ retry_root_backup:
>                 goto fail_sysfs;
>         }
>
> +       /*
> +        * Hold the cleaner_mutex thread here so that we don't block
> +        * for a long time on btrfs_recover_relocation.  cleaner_kthread
> +        * will wait for us to finish mounting the filesystem.
> +        */
> +       mutex_lock(&fs_info->cleaner_mutex);
> +       cleaner_mutex_locked = true;
>         fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
>                                                "btrfs-cleaner");
>         if (IS_ERR(fs_info->cleaner_kthread))
> @@ -3046,10 +3054,8 @@ retry_root_backup:
>                 ret = btrfs_cleanup_fs_roots(fs_info);
>                 if (ret)
>                         goto fail_qgroup;
> -
> -               mutex_lock(&fs_info->cleaner_mutex);
> +               /* We locked cleaner_mutex before creating cleaner_kthread. */
>                 ret = btrfs_recover_relocation(tree_root);
> -               mutex_unlock(&fs_info->cleaner_mutex);
>                 if (ret < 0) {
>                         printk(KERN_WARNING
>                                "BTRFS: failed to recover relocation\n");
> @@ -3057,6 +3063,8 @@ retry_root_backup:
>                         goto fail_qgroup;
>                 }
>         }
> +       mutex_unlock(&fs_info->cleaner_mutex);
> +       cleaner_mutex_locked = false;
>
>         location.objectid = BTRFS_FS_TREE_OBJECTID;
>         location.type = BTRFS_ROOT_ITEM_KEY;
> @@ -3164,6 +3172,10 @@ fail_cleaner:
>         filemap_write_and_wait(fs_info->btree_inode->i_mapping);
>
>  fail_sysfs:
> +       if (cleaner_mutex_locked) {
> +               mutex_unlock(&fs_info->cleaner_mutex);
> +               cleaner_mutex_locked = false;
> +       }
>         btrfs_sysfs_remove_mounted(fs_info);
>
>  fail_fsdev_sysfs:
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
