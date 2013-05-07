Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57832 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3EGAlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 20:41:09 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 03B789A068F
	for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2013 18:41:09 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1363101208-30184-1-git-send-email-dsterba@suse.cz>
CC: "alex.btrfs@zadarastorage.com" <alex.btrfs@zadarastorage.com>,
        David Sterba <dsterba@suse.cz>
References: <1363101208-30184-1-git-send-email-dsterba@suse.cz>
Message-ID: <20130507004106.5844.39433@localhost.localdomain>
Subject: Re: [PATCH v3] btrfs: clean snapshots one by one
Date: Mon, 6 May 2013 20:41:06 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-03-12 11:13:28)
> Each time pick one dead root from the list and let the caller know if
> it's needed to continue. This should improve responsiveness during
> umount and balance which at some point waits for cleaning all currently
> queued dead roots.
> 
> A new dead root is added to the end of the list, so the snapshots
> disappear in the order of deletion.
> 
> The snapshot cleaning work is now done only from the cleaner thread and the
> others wake it if needed.


> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 988b860..4de2351 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1690,15 +1690,19 @@ static int cleaner_kthread(void *arg)
>         struct btrfs_root *root = arg;
>  
>         do {
> +               int again = 0;
> +
>                 if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
> +                   down_read_trylock(&root->fs_info->sb->s_umount) &&
>                     mutex_trylock(&root->fs_info->cleaner_mutex)) {
>                         btrfs_run_delayed_iputs(root);
> -                       btrfs_clean_old_snapshots(root);
> +                       again = btrfs_clean_one_deleted_snapshot(root);
>                         mutex_unlock(&root->fs_info->cleaner_mutex);
>                         btrfs_run_defrag_inodes(root->fs_info);
> +                       up_read(&root->fs_info->sb->s_umount);

Can we use just the cleaner mutex for this?  We're deadlocking during
068 with autodefrag on because the cleaner is holding s_umount while
autodefrag is trying to bump the writer count.

If unmount takes the cleaner mutex once it should wait long enough for
the cleaner to stop.

-chris

