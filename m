From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH] Null terminate strings passed in from userspace
Date: Mon, 30 Jun 2008 15:44:38 -0700
Message-ID: <20080630224438.GD28100@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The 'char name[BTRFS_PATH_NAME_MAX]' member of struct btrfs_ioctl_vol_args
is passed directly to strlen() after being copied from user. I haven't
verified this, but in theory a userspace program could pass in an
unterminated string and cause a kernel crash as strlen walks off the end of
the array.

This patch terminates the ->name string in all btrfs ioctl functions which
currently use a 'struct btrfs_ioctl_vol_args'. Since the string is now
properly terminated, it's length will never be longer than
BTRFS_PATH_NAME_MAX so that error check has been removed.

By the way, it might be better overall to just have the ioctl pass an
unterminated string + length structure but I didn't bother with that since
it'd change the kernel/user interface.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>

diff -r 3f0eee804974 -r be405df89141 ioctl.c
--- a/ioctl.c	Thu Jun 26 10:34:20 2008 -0400
+++ b/ioctl.c	Mon Jun 30 15:37:34 2008 -0700
@@ -301,11 +301,9 @@
 		ret = -EFAULT;
 		goto out;
 	}
+
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
-	if (namelen > BTRFS_VOL_NAME_MAX) {
-		ret = -EINVAL;
-		goto out;
-	}
 
 	mutex_lock(&root->fs_info->alloc_mutex);
 	mutex_lock(&root->fs_info->chunk_mutex);
@@ -405,11 +403,8 @@
 		goto out;
 	}
 
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
-	if (namelen > BTRFS_VOL_NAME_MAX) {
-		ret = -EINVAL;
-		goto out;
-	}
 	if (strchr(vol_args->name, '/')) {
 		ret = -EINVAL;
 		goto out;
@@ -480,6 +475,7 @@
 		ret = -EFAULT;
 		goto out;
 	}
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	ret = btrfs_init_new_device(root, vol_args->name);
 
 out:
@@ -501,6 +497,7 @@
 		ret = -EFAULT;
 		goto out;
 	}
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	ret = btrfs_rm_device(root, vol_args->name);
 
 out:

