Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34070 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbFAQ4o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 12:56:44 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <d901ccc6dbbc8db40962b4b8e4d391a684e88335.1432975901.git.osandov@osandov.com>
References: <d901ccc6dbbc8db40962b4b8e4d391a684e88335.1432975901.git.osandov@osandov.com>
Date: Mon, 1 Jun 2015 17:56:43 +0100
Message-ID: <CAL3q7H6PvooaNWpKCTFgAxc=R0pT1XiwSQvJiYVXiV4iuJHXRA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: don't invalidate root dentry when subvolume
 deletion fails
From: Filipe David Manana <fdmanana@gmail.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Markus Schauler <mschauler@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 30, 2015 at 9:59 AM, Omar Sandoval <osandov@osandov.com> wrote:
> Since commit bafc9b754f75 ("vfs: More precise tests in d_invalidate"),
> mounted subvolumes can be deleted because d_invalidate() won't fail.
> However, we run into problems when we attempt to delete the default
> subvolume while it is mounted as the root filesystem:
>
>         # btrfs subvol list /
>         ID 257 gen 306 top level 5 path rootvol
>         ID 267 gen 334 top level 5 path snap1
>         # btrfs subvol get-default /
>         ID 267 gen 334 top level 5 path snap1
>         # btrfs inspect-internal rootid /
>         267
>         # mount -o subvol=/ /dev/vda1 /mnt
>         # btrfs subvol del /mnt/snap1
>         Delete subvolume (no-commit): '/mnt/snap1'
>         ERROR: cannot delete '/mnt/snap1' - Operation not permitted
>         # findmnt /
>         findmnt: can't read /proc/mounts: No such file or directory
>         # ls /proc
>         #
>
> Markus reported that this same scenario simply led to a kernel oops.
>
> This happens because in btrfs_ioctl_snap_destroy(), we call
> d_invalidate() before we check may_destroy_subvol(), which means that we
> detach the submounts and drop the dentry before erroring out. Instead,
> we should only invalidate the dentry once we know that we're going
> through with the deletion.
>
> Cc: <stable@vger.kernel.org>
> Fixes: bafc9b754f75 ("vfs: More precise tests in d_invalidate")
> Reported-by: Markus Schauler <mschauler@gmail.com>
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
> The other fix for preventing all mounted subvolumes from being deleted
> would preclude this, but it sounded like we were leaning towards
> enforcing that in userspace once subvolume info becomes available in
> /proc/mounts, so this should be fixed separately.
>
>  fs/btrfs/ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 1c22c6518504..8edb8544088b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2413,14 +2413,14 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>                 goto out_unlock_inode;
>         }
>
> -       d_invalidate(dentry);
> -
>         down_write(&root->fs_info->subvol_sem);
>
>         err = may_destroy_subvol(dest);
>         if (err)
>                 goto out_up_write;
>
> +       d_invalidate(dentry);
> +

Any reason why not calling d_invalidate() only if the call
btrfs_unlink_subvol() succeeds? Not seeing a reason why we should
invalidate before doing the actual deletion successfully (before that
metadata reservation can fail or failure to start/join a transaction,
etc).

Also, would you consider making an xfstest for this?

thanks


>         btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
>         /*
>          * One for dir inode, two for dir entries, two for root
> --
> 2.4.2
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
