Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:58759 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934329Ab3BTT5W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 14:57:22 -0500
Received: by mail-ob0-f177.google.com with SMTP id wc18so7974034obb.22
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 11:57:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361369423-2208-1-git-send-email-bo.li.liu@oracle.com>
References: <1361369423-2208-1-git-send-email-bo.li.liu@oracle.com>
Date: Wed, 20 Feb 2013 13:57:22 -0600
Message-ID: <CAKcLGm8Fq6Vh8kEwCKD9t5caf=_pmpPPjdu7bPNgSixqe1vHhQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix cleaner thread not working with inode cache option
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 20, 2013 at 8:10 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> Right now inode cache inode is treated as the same as space cache
> inode, ie. keep inode in memory till putting super.
>
> But this leads to an awkward situation.
>
> If we're going to delete a snapshot/subvolume, btrfs will not
> actually delete it and return free space, but will add it to dead
> roots list until the last inode on this snap/subvol being destroyed.
> Then we'll fetch deleted roots and cleanup them via cleaner thread.
>
> So here is the problem, if we enable inode cache option, each
> snap/subvol has a cached inode which is used to store inode allcation
> information.  And this cache inode will be kept in memory, as the above
> said.  So with inode cache, snap/subvol can only be added into
> dead roots list during freeing roots stage in umount, so that we can
> ONLY get space back after another remount(we cleanup dead roots on mount).
>
> But the real thing is we'll no more use the snap/subvol if we mark it
> deleted, so we can safely iput its cache inode when we delete snap/subvol.
>
> Another thing is that we need to change the rules of droping inode, we
> don't keep snap/subvol's cache inode in memory till end so that we can
> add snap/subvol into dead roots list in time.
>
> Reported-by: Mitch Harder <mitch.harder@sabayonlinux.org>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/inode.c |    3 ++-
>  fs/btrfs/ioctl.c |    6 ++++++
>  2 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ca7ace7..d9984fa 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7230,8 +7230,9 @@ int btrfs_drop_inode(struct inode *inode)
>  {
>         struct btrfs_root *root = BTRFS_I(inode)->root;
>
> +       /* the snap/subvol tree is on deleting */
>         if (btrfs_root_refs(&root->root_item) == 0 &&
> -           !btrfs_is_free_space_inode(inode))
> +           root != root->fs_info->tree_root)
>                 return 1;
>         else
>                 return generic_drop_inode(inode);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a31cd93..375f31f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2171,6 +2171,12 @@ out_unlock:
>                 shrink_dcache_sb(root->fs_info->sb);
>                 btrfs_invalidate_inodes(dest);
>                 d_delete(dentry);
> +
> +               /* the last ref */
> +               if (dest->cache_inode) {
> +                       iput(dest->cache_inode);
> +                       dest->cache_inode = NULL;
> +               }
>         }
>  out_dput:
>         dput(dentry);
> --
> 1.7.7.6
>

Thanks, I tested this patch, and it fixes the issues I was seeing.
