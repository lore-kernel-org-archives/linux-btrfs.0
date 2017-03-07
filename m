Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755457AbdCGOGD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 09:06:03 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4CF10AD51
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Mar 2017 13:47:39 +0000 (UTC)
Date: Tue, 7 Mar 2017 14:47:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs: Change s_flags instead of returning -EBUSY
Message-ID: <20170307134702.GS4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
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

(as we've discussed this off-list, I'll repeat some of the points here)

We can't get rid of the vfs_kern_mount sequence in mount_subvol as this
addresses a usecase [1].

I've tried to fix the parallel mount bug once [2] but the simple
solution to remove the -EBUSY check was not working correctly. The fix
you propose does not look correct to me either, as it is chaning the
ro/rw flags that are being passed to mount.

[1] https://git.kernel.org/linus/0723a0473fb48a1c93b113a28665b64ce5faf35a
[2] https://lkml.kernel.org/r/1461770076-13000-1-git-send-email-dsterba@suse.com

>  	mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name, newargs);

The race could happen between the two calls to kern mount, the state of
the ro/rw flags is not viewed consistently as they change. The
workaround that worked for me is to add a local mutex (patch below) that
protects just this section. But the solution is quite ugly and I haven't
sent it upstream for that reason.

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

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1284,6 +1284,7 @@ static struct dentry *mount_subvol(const
        struct vfsmount *mnt = NULL;
        char *newargs;
        int ret;
+       static DEFINE_MUTEX(subvol_lock);

        newargs = setup_root_args(data);
        if (!newargs) {
@@ -1291,6 +1292,24 @@ static struct dentry *mount_subvol(const
                goto out;
        }

+       /*
+        * Protect against racing mounts of subvolumes with different RO/RW
+        * flags.  The first vfs_kern_mount could fail with -EBUSY if the rw
+        * flags do not match with the first and the currently mounted
+        * subvolume.
+        *
+        * To resolve that, we adjust the rw flags and do remount. If another
+        * mounts goes through the same path and hits the window between the
+        * adjusted vfs_kern_mount and btrfs_remount, it will fail because of
+        * the ro/rw mismatch in btrfs_mount.
+        *
+        * If the mounts do not race and are serialized externally, everything
+        * works fine.  The function-local mutex enforces the serialization but
+        * is otherwise only an ugly workaround due to lack of better
+        * solutions.
+        */
+       mutex_lock(&subvol_lock);
+
        mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name, newargs);
        if (PTR_ERR_OR_ZERO(mnt) == -EBUSY) {
                if (flags & MS_RDONLY) {
@@ -1302,6 +1321,7 @@ static struct dentry *mount_subvol(const
                        if (IS_ERR(mnt)) {
                                root = ERR_CAST(mnt);
                                mnt = NULL;
+                               mutex_unlock(&subvol_lock);
                                goto out;
                        }

@@ -1310,10 +1330,13 @@ static struct dentry *mount_subvol(const
                        up_write(&mnt->mnt_sb->s_umount);
                        if (ret < 0) {
                                root = ERR_PTR(ret);
+                               mutex_unlock(&subvol_lock);
                                goto out;
                        }
                }
        }
+       mutex_unlock(&subvol_lock);
+
        if (IS_ERR(mnt)) {
                root = ERR_CAST(mnt);
                mnt = NULL;

