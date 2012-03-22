From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 1/2] vfs: add an interface to do some preparation for
 umount
Date: Thu, 22 Mar 2012 11:13:15 +0800
Message-ID: <4F6A98CB.1070308@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Some file systems can do some works in the background by kthreads, we'd
better stop those works before we umount the file system, or it is easy to
introduce some problems. So we add an interface that is used to do some
preparation for umount.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/namespace.c     |    2 ++
 include/linux/fs.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e608199..f5c1cce 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1173,6 +1173,8 @@ static int do_umount(struct mount *mnt, int flags)
 	}
 	br_write_unlock(vfsmount_lock);
 	up_write(&namespace_sem);
+	if (!retval && sb->s_op->umount_prepare)
+		sb->s_op->umount_prepare(sb);
 	release_mounts(&umount_list);
 	return retval;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 69cd5bb..6b9657c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1686,6 +1686,7 @@ struct super_operations {
 	int (*statfs) (struct dentry *, struct kstatfs *);
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*umount_begin) (struct super_block *);
+	void (*umount_prepare) (struct super_block *);
 
 	int (*show_options)(struct seq_file *, struct dentry *);
 	int (*show_devname)(struct seq_file *, struct dentry *);
-- 
1.7.6.5
