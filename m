Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61879 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761823AbbA2CZ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 21:25:59 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function to get vfsmount from a given sb.
Date: Thu, 29 Jan 2015 10:24:39 +0800
Message-ID: <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are sysfs interfaces in some fs, only btrfs yet, which will modify
on-disk data.
Unlike normal file operation routine we can use mnt_want_write_file() to
protect the operation, change through sysfs won't to be binded to any file
in the filesystem.
So we can only extract the first vfsmount of a superblock and pass it to
mnt_want_write() to do the protection.

Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/namespace.c        | 25 +++++++++++++++++++++++++
 include/linux/mount.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index cd1e968..5a16a62 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1105,6 +1105,31 @@ struct vfsmount *mntget(struct vfsmount *mnt)
 }
 EXPORT_SYMBOL(mntget);
 
+/*
+ * get a vfsmount from a given sb
+ *
+ * This is especially used for case where change fs' sysfs interface
+ * will lead to a write, e.g. Change label through sysfs in btrfs.
+ * So vfs can get a vfsmount and then use mnt_want_write() to protect.
+ */
+struct vfsmount *get_vfsmount_sb(struct super_block *sb)
+{
+	struct vfsmount *ret_vfs = NULL;
+	struct mount *mnt;
+	int ret = 0;
+
+	lock_mount_hash();
+	if (list_empty(&sb->s_mounts))
+		goto out;
+	mnt = list_entry(sb->s_mounts.next, struct mount, mnt_instance);
+	ret_vfs = &mnt->mnt;
+	ret_vfs = mntget(ret_vfs);
+out:
+	unlock_mount_hash();
+	return ret_vfs;
+}
+EXPORT_SYMBOL(get_vfsmount_sb);
+
 struct vfsmount *mnt_clone_internal(struct path *path)
 {
 	struct mount *p;
diff --git a/include/linux/mount.h b/include/linux/mount.h
index c2c561d..cf1b0f5 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -79,6 +79,7 @@ extern void mnt_drop_write_file(struct file *file);
 extern void mntput(struct vfsmount *mnt);
 extern struct vfsmount *mntget(struct vfsmount *mnt);
 extern struct vfsmount *mnt_clone_internal(struct path *path);
+extern struct vfsmount *get_vfsmount_sb(struct super_block *sb);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
 
 struct path;
-- 
2.2.2

