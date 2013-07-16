Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:53013 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717Ab3GPOyv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 10:54:51 -0400
Received: by mail-wi0-f169.google.com with SMTP id c10so4271247wiw.4
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jul 2013 07:54:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373906586-3271-1-git-send-email-jbacik@fusionio.com>
References: <1373906586-3271-1-git-send-email-jbacik@fusionio.com>
Date: Tue, 16 Jul 2013 17:54:50 +0300
Message-ID: <CAOcd+r3=v-5oBkJ8G=tRF66MBxkw4x=UJ=BS9pKfNYO2hL8Z+g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix lock leak when resuming snapshot deletion
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, Liran Strugano <liran@zadarastorage.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 15, 2013 at 7:43 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> We aren't setting path->locks[level] when we resume a snapshot deletion which
> means we won't unlock the buffer when we free the path.  This causes deadlocks
> if we happen to re-allocate the block before we've evicted the extent buffer
> from cache.  Thanks,
>
> Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/extent-tree.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 8c204e1..997a5dd 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7555,6 +7555,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>                 while (1) {
>                         btrfs_tree_lock(path->nodes[level]);
>                         btrfs_set_lock_blocking(path->nodes[level]);
> +                       path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
>
>                         ret = btrfs_lookup_extent_info(trans, root,
>                                                 path->nodes[level]->start,
> @@ -7570,6 +7571,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>                                 break;
>
>                         btrfs_tree_unlock(path->nodes[level]);
> +                       path->locks[level] = 0;
>                         WARN_ON(wc->refs[level] != 1);
>                         level--;
>                 }
> --
> 1.7.7.6
>
> --

Tested-by: Liran Strugano <liran@zadarastorage.com>

> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
