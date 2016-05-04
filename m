Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:35493 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbcEDJtY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 05:49:24 -0400
Received: by mail-ig0-f193.google.com with SMTP id jn6so2386938igb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 02:49:24 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160504011009.GB15597@hungrycats.org>
References: <20160504011009.GB15597@hungrycats.org>
Date: Wed, 4 May 2016 10:49:23 +0100
Message-ID: <CAL3q7H6CL5ZFuAfLU0W501w58w=9iG5yg5ODM+-7MT4aA7kiRw@mail.gmail.com>
Subject: Re: [PATCH, maybe WRONG] btrfs: don't let btrfs_recover_relocation
 get stuck waiting for cleaner_kthread to delete a snapshot
From: Filipe Manana <fdmanana@gmail.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 4, 2016 at 2:10 AM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> This is one way to fix a long hang during mounts.  There's probably a
> better way, but this is the one I've used to get my filesystems up
> and running.
>
> We start the cleaner kthread first because the transaction kthread wants
> to wake up the cleaner kthread.  We start the transaction kthread next
> because everything in btrfs wants transactions.  We do reloc recovery
> once the transaction kthread is running.  This means that the cleaner
> kthread could already be running when reloc recovery happens (e.g. if a
> snapshot delete was started before a crash).
>
> Reloc recovery does not play well with the cleaner kthread, so a mutex
> was added in commit 5f3164813b90f7dbcb5c3ab9006906222ce471b7 "Btrfs:
> fix race between balance recovery and root deletion" to prevent both
> from running at the same time.
>
> The cleaner kthread could already be holding the mutex by the time we
> get to btrfs_recover_relocation, and if it is, the mount will be blocked
> until at least one snapshot is deleted (possibly more if the mount process
> doesn't get the lock right away).  During this time (which could be an
> arbitrarily long time on a large/slow filesystem), the mount process is
> stuck and the filesystem is unnecessarily inaccessible.
>
> Fix this by locking cleaner_mutex before we start the cleaner_kthread,
> and unlocking it when we have finished with it in the mount function.
> This allows the mount to proceed to completion before resuming snapshot
> deletion.  I'm not sure about the error cases, and the asymmetrical
> pthread_mutex_lock/unlocks are just ugly.  Other than that, this patch
> works.
>
> An alternative (and possibly better) solution would be to add an extra
> check in btrfs_need_cleaner_sleep() for a flag that would be set at the
> end of mounting.  This should keep cleaner_kthread sleeping until just
> before mount is finished.


Looks valid and good to me.
The alternative solution you describe would unnecessarily be more
complex without any benefit.
I prefer what you did, it's correct and simple. Just 2 comments below.

>
>
> ---
>  fs/btrfs/disk-io.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 07c1ad6..af5ea1d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2927,6 +2927,10 @@ retry_root_backup:
>                         "too many missing devices, writeable mount should not be allowed\n");
>         }
>
> +       /* Hold the cleaner_mutex thread here so that we don't block
> +        * on btrfs_recover_relocation later on.  cleaner_kthread
> +        * blocks on us instead. */

Nitpick, the style for comments with multiple lines is:

/*
 * bla bla bla
 * bla bla bla
 */

I would also had "for too long" after the "... we don't block", just
to make it more clear that we don't
block forever, but rather for a potentially long time.

> +       mutex_lock(&fs_info->cleaner_mutex);
>         fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
>                                                "btrfs-cleaner");
>         if (IS_ERR(fs_info->cleaner_kthread))
> @@ -2986,9 +2990,8 @@ retry_root_backup:
>                 if (ret)
>                         goto fail_qgroup;
>
> -               mutex_lock(&fs_info->cleaner_mutex);
> +               /* We grabbed this mutex before we created the cleaner_kthread */
>                 ret = btrfs_recover_relocation(tree_root);
> -               mutex_unlock(&fs_info->cleaner_mutex);
>                 if (ret < 0) {
>                         printk(KERN_WARNING
>                                "BTRFS: failed to recover relocation\n");
> @@ -2996,6 +2999,7 @@ retry_root_backup:
>                         goto fail_qgroup;
>                 }
>         }
> +       mutex_unlock(&fs_info->cleaner_mutex);

After this point we have one more goto after an error to read the fs
root that jumps to the label fail_qgroup, which ends up unlocking
again the cleaner_mutex.
You can track whether it needs to be unlocked or not through a local
bool variable for e.g.

thanks

>
>         location.objectid = BTRFS_FS_TREE_OBJECTID;
>         location.type = BTRFS_ROOT_ITEM_KEY;
> @@ -3079,6 +3083,7 @@ fail_cleaner:
>         filemap_write_and_wait(fs_info->btree_inode->i_mapping);
>
>  fail_sysfs:
> +       mutex_unlock(&fs_info->cleaner_mutex);
>         btrfs_sysfs_remove_one(fs_info);
>
>  fail_block_groups:
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
