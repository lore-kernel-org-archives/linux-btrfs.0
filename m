Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38833 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbC1Lho (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Mar 2015 07:37:44 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <74abba0fe653d9ac27bfe4f14ae3e8f65b5b7317.1427539655.git.osandov@osandov.com>
References: <74abba0fe653d9ac27bfe4f14ae3e8f65b5b7317.1427539655.git.osandov@osandov.com>
Date: Sat, 28 Mar 2015 11:37:43 +0000
Message-ID: <CAL3q7H7oHbftmpnnMVt0EFWzS_etc--n2bRP9C0Vuzayr4CKgg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: unlock i_mutex after attempting to delete
 subvolume during send
From: Filipe David Manana <fdmanana@gmail.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 28, 2015 at 11:02 AM, Omar Sandoval <osandov@osandov.com> wrote:
> Whenever the check for a send in progress introduced in commit
> 521e0546c970 (btrfs: protect snapshots from deleting during send) is
> hit, we return without unlocking inode->i_mutex. This is easy to see
> with lockdep enabled:
>
> [  +0.000059] ================================================
> [  +0.000028] [ BUG: lock held when returning to user space! ]
> [  +0.000029] 4.0.0-rc5-00096-g3c435c1 #93 Not tainted
> [  +0.000026] ------------------------------------------------
> [  +0.000029] btrfs/211 is leaving the kernel with locks still held!
> [  +0.000029] 1 lock held by btrfs/211:
> [  +0.000023]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff8135b8df>] btrfs_ioctl_snap_destroy+0x2df/0x7a0
>
> Make sure we unlock it in the error path.
>
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks, should go to stable in my opinion.


> ---
>  fs/btrfs/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 74609b9..9fde01f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2403,7 +2403,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>                         "Attempt to delete subvolume %llu during send",
>                         dest->root_key.objectid);
>                 err = -EPERM;
> -               goto out_dput;
> +               goto out_unlock_inode;
>         }
>
>         d_invalidate(dentry);
> @@ -2498,6 +2498,7 @@ out_up_write:
>                                 root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
>                 spin_unlock(&dest->root_item_lock);
>         }
> +out_unlock_inode:
>         mutex_unlock(&inode->i_mutex);
>         if (!err) {
>                 shrink_dcache_sb(root->fs_info->sb);
> --
> 2.3.4
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
