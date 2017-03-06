Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:32950 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753184AbdCFTZc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 14:25:32 -0500
Received: by mail-pg0-f51.google.com with SMTP id 25so69601293pgy.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Mar 2017 11:23:44 -0800 (PST)
Date: Mon, 6 Mar 2017 10:26:41 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs: Change s_flags instead of returning -EBUSY
Message-ID: <20170306182641.GB16893@vader.DHCP.thefacebook.com>
References: <20170304183322.32346-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170304183322.32346-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 04, 2017 at 12:33:22PM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> The problem is with parallel mounting multiple subvolumes rw when the
> root filesystem is marked as read-only such as a boot sequence
> using systemd. Not all subvolumes will be mounted because some of
> them will return -EBUSY.
> 
> Here is a sample execution time.
> Root filesystem is mounted read-only so s->s_flags are set to MS_RDONLY
> flags is the parameter passed and s_flags is the one recorded in sb.
> btrfs_mount is called via vfs_kern_mount().
> 
> Mount Thread 1				Mount Thread 2
> 
> btrfs_mount(flags & ~MS_RDONLY)
>  check (flags ^ s_flags) & MS_RDONLY
>  returns -EBUSY				btrfs_mount(flags & ~MS_RDONLY)
>  					check (flags ^ s_flags) & MS_RDONLY
> 					 returns -EBUSY
> btrfs_mount(flags | MS_RDONLY)
> btrfs_remount(flags & ~MS_RDONLY)
> s->s_flags &= ~MS_RDONLY
> 					btrfs_mount(flags | MS_RDONLY)
> 					check (flags ^ s_flags) & MS_RDONLY)
> 					 returns -EBUSY
> 					 mount FAILS
> 
> The -EBUSY was originally introduced in:
> 4b82d6e ("Btrfs: Add mount into directory support")
> as a copy of (then) get_sb_dev().
> 
> Later commit 0723a04 ("btrfs: allow mounting btrfs subvolumes
> with different ro/rw options") added the option of allowing
> subvolumes in rw/ro modes.
> 
> This fix is instead of toggling the flags in remount, we set
> s_flags &= MS_RDONLY when we see a conflict in s_flags and passed parameter
> flags and let mount continue as it is. This will allow the first mount attempt
> to succeed, and we can get rid of the re-kern_mount() and remount sequence
> altogether.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/super.c | 36 ++++++++++--------------------------
>  1 file changed, 10 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index e9ae93e..978b4a6 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -67,8 +67,6 @@
>  static const struct super_operations btrfs_super_ops;
>  static struct file_system_type btrfs_fs_type;
>  
> -static int btrfs_remount(struct super_block *sb, int *flags, char *data);
> -
>  const char *btrfs_decode_error(int errno)
>  {
>  	char *errstr = "unknown";
> @@ -1379,28 +1377,6 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
>  	}
>  
>  	mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name, newargs);
> -	if (PTR_ERR_OR_ZERO(mnt) == -EBUSY) {
> -		if (flags & MS_RDONLY) {
> -			mnt = vfs_kern_mount(&btrfs_fs_type, flags & ~MS_RDONLY,
> -					     device_name, newargs);
> -		} else {
> -			mnt = vfs_kern_mount(&btrfs_fs_type, flags | MS_RDONLY,
> -					     device_name, newargs);
> -			if (IS_ERR(mnt)) {
> -				root = ERR_CAST(mnt);
> -				mnt = NULL;
> -				goto out;
> -			}
> -
> -			down_write(&mnt->mnt_sb->s_umount);
> -			ret = btrfs_remount(mnt->mnt_sb, &flags, NULL);
> -			up_write(&mnt->mnt_sb->s_umount);
> -			if (ret < 0) {
> -				root = ERR_PTR(ret);
> -				goto out;
> -			}
> -		}
> -	}
>  	if (IS_ERR(mnt)) {
>  		root = ERR_CAST(mnt);
>  		mnt = NULL;
> @@ -1606,8 +1582,16 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  	if (s->s_root) {
>  		btrfs_close_devices(fs_devices);
>  		free_fs_info(fs_info);
> -		if ((flags ^ s->s_flags) & MS_RDONLY)
> -			error = -EBUSY;
> +		/* If s_flags is MS_RDONLY and flags is rw (~MS_RDONLY)

Blech, keep that gross comment style under net/.

> +		 * we need to reset s_flags so that sb can be writable
> +		 * since we can be called from mount_subvol().
> +		 * The vfsmount manages to preserve the ro/rw flags
> +		 * of the root/orignal mount.
> +		 * In case of vice-versa, s_flags is already does not
> +		 * have MS_RDONLY set, so don't bother.
> +		 */
> +		if ((s->s_flags & MS_RDONLY) && !(flags & MS_RDONLY))
> +			s->s_flags &= ~MS_RDONLY;

Hm, this doesn't seem right. btrfs_remount() does a bunch of other
important checks (e.g., BTRFS_FS_STATE_ERROR) that you're throwing away
by doing it this way.

>  	} else {
>  		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
>  		btrfs_sb(s)->bdev_holder = fs_type;
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
