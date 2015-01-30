Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29041 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760165AbbA3JXM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 04:23:12 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v5 6/9] vfs: Add sb_want_write() function to get vfsmount from a given sb.
Date: Fri, 30 Jan 2015 17:20:51 +0800
Message-ID: <1422609654-19519-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are sysfs interfaces in some fs, only btrfs yet, which will modify
on-disk data.
Unlike normal file operation routine we can use mnt_want_write_file() to
protect the operation, change through sysfs won't to be binded to any file
in the filesystem.

So introduce new sb_want_write() to do the protection agains a super
block, which acts much like mnt_want_write() but will return success if
the super block is read-write.

Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Signed-off-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v4:
  Newly introduced.
v5:
  Change name to sb_want_write() and receive sb and parameter.
---
 fs/namespace.c        | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/mount.h |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index cd1e968..79bc762 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1105,6 +1105,42 @@ struct vfsmount *mntget(struct vfsmount *mnt)
 }
 EXPORT_SYMBOL(mntget);
 
+/**
+ * sb_want_write - get write acess to a super block
+ * @sb: the superblock of the filesystem
+ *
+ * This tells the low-level filesystem that a write is about to be performed to
+ * it, and makes sure that the writes are allowed (superblock is read-write,
+ * filesystem is not frozen) before returning success.
+ * When the write operation is finished, sb_drop_write() must be called.
+ * This is much like mnt_want_write() as a refcount, but only needs
+ * the superblock to be read-write.
+ */
+int sb_want_write(struct super_block *sb)
+{
+	sb_start_write(sb);
+	if (sb->s_readonly_remount || sb->s_flags & MS_RDONLY) {
+		sb_end_write(sb);
+		return -EROFS;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(sb_want_write);
+
+/**
+ * sb_drop_write - give up write acess to a super block
+ * @sb: the superblock on which to give up write access
+ *
+ * Tells the low-level filesystem that we are done performing writes to it and
+ * also allows filesystem to be frozen again. Must be matched with
+ * sb_want_write() call above.
+ */
+void sb_drop_write(struct super_block *sb)
+{
+	sb_end_write(sb);
+}
+EXPORT_SYMBOL(sb_drop_write);
+
 struct vfsmount *mnt_clone_internal(struct path *path)
 {
 	struct mount *p;
diff --git a/include/linux/mount.h b/include/linux/mount.h
index c2c561d..abf4495 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -74,8 +74,10 @@ struct path;
 extern int mnt_want_write(struct vfsmount *mnt);
 extern int mnt_want_write_file(struct file *file);
 extern int mnt_clone_write(struct vfsmount *mnt);
+extern int sb_want_write(struct super_block *sb);
 extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mnt_drop_write_file(struct file *file);
+extern void sb_drop_write(struct super_block *sb);
 extern void mntput(struct vfsmount *mnt);
 extern struct vfsmount *mntget(struct vfsmount *mnt);
 extern struct vfsmount *mnt_clone_internal(struct path *path);
-- 
2.2.2

