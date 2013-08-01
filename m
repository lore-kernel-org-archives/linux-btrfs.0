Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44351 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab3HAOFi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 10:05:38 -0400
Received: by mail-wg0-f43.google.com with SMTP id z12so1717879wgg.10
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Aug 2013 07:05:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369947496-27707-1-git-send-email-jbacik@fusionio.com>
References: <1369947496-27707-1-git-send-email-jbacik@fusionio.com>
Date: Thu, 1 Aug 2013 17:05:35 +0300
Message-ID: <CAOcd+r1mkZhaFNNBsu6G89zBKmtLTL5U72mBczFpukMNXckKXw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: stop all workers before cleaning up roots
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On Thu, May 30, 2013 at 11:58 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> Dave reported a panic because the extent_root->commit_root was NULL in the
> caching kthread.  That is because we just unset it in free_root_pointers, which
> is not the correct thing to do, we have to either wait for the caching kthread
> to complete or hold the extent_commit_sem lock so we know the thread has exited.
> This patch makes the kthreads all stop first and then we do our cleanup.  This
> should fix the race.  Thanks,
>
> Reported-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/disk-io.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 2b53afd..77cb566 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3547,13 +3547,13 @@ int close_ctree(struct btrfs_root *root)
>
>         btrfs_free_block_groups(fs_info);

do you think it would be safer to stop all workers first and make sure
they are stopped, then do btrfs_free_block_groups()? I see, for
example, that btrfs_free_block_groups() checks:
if (block_group->cached == BTRFS_CACHE_STARTED)
which could be perhaps racy with other people spawning caching_threads.

So maybe better to stop all threads (including cleaner and committer)
and then free everything?

>
> -       free_root_pointers(fs_info, 1);
> +       btrfs_stop_all_workers(fs_info);
>
>         del_fs_roots(fs_info);
>
> -       iput(fs_info->btree_inode);
> +       free_root_pointers(fs_info, 1);
>
> -       btrfs_stop_all_workers(fs_info);
> +       iput(fs_info->btree_inode);
>
>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>         if (btrfs_test_opt(root, CHECK_INTEGRITY))
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Alex.
