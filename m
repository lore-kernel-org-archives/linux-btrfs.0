Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36724 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab2EaK1B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 06:27:01 -0400
Message-ID: <4FC74707.5030804@cn.fujitsu.com>
Date: Thu, 31 May 2012 18:25:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 1/2] Revert "[PATCH] vfs: switch ->show_devname() to struct
 dentry *"
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit d861c630e99febe5ce6055290085556c5b714b06

It is done to fix the wrong mount information of btrfs in /proc.
Btrfs is an interesting filesystem that can be made by several disks, and
we can remove any disk from the filesystem. But now if we remove the disk
that is specified at mount, the mount information in /proc(such as mounts/
mountinfo and so on) is not updated. And this wrong information will make
us can not add that special disk back to the filesystem again. I will fix
this problem by implement the show_devname() interface for btrfs, and in
order to check the disk which is specified when doing mount is removed or not,
I want pass vfsmount object into this function.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/nfs/super.c      |    6 +++---
 fs/proc_namespace.c |    6 +++---
 include/linux/fs.h  |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 4ac7fca..c286233 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -280,7 +280,7 @@ static match_table_t nfs_vers_tokens = {
 static void nfs_umount_begin(struct super_block *);
 static int  nfs_statfs(struct dentry *, struct kstatfs *);
 static int  nfs_show_options(struct seq_file *, struct dentry *);
-static int  nfs_show_devname(struct seq_file *, struct dentry *);
+static int  nfs_show_devname(struct seq_file *, struct vfsmount *);
 static int  nfs_show_path(struct seq_file *, struct dentry *);
 static int  nfs_show_stats(struct seq_file *, struct dentry *);
 static struct dentry *nfs_fs_mount(struct file_system_type *,
@@ -805,14 +805,14 @@ static void show_implementation_id(struct seq_file *m, struct nfs_server *nfss)
 }
 #endif
 
-static int nfs_show_devname(struct seq_file *m, struct dentry *root)
+static int nfs_show_devname(struct seq_file *m, struct vfsmount *mnt)
 {
 	char *page = (char *) __get_free_page(GFP_KERNEL);
 	char *devname, *dummy;
 	int err = 0;
 	if (!page)
 		return -ENOMEM;
-	devname = nfs_path(&dummy, root, page, PAGE_SIZE);
+	devname = nfs_path(&dummy, mnt->mnt_root, page, PAGE_SIZE);
 	if (IS_ERR(devname))
 		err = PTR_ERR(devname);
 	else
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 1241285..9ddcce1 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -97,7 +97,7 @@ static int show_vfsmnt(struct seq_file *m, struct vfsmount *mnt)
 	struct super_block *sb = mnt_path.dentry->d_sb;
 
 	if (sb->s_op->show_devname) {
-		err = sb->s_op->show_devname(m, mnt_path.dentry);
+		err = sb->s_op->show_devname(m, mnt);
 		if (err)
 			goto out;
 	} else {
@@ -164,7 +164,7 @@ static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
 	show_type(m, sb);
 	seq_putc(m, ' ');
 	if (sb->s_op->show_devname)
-		err = sb->s_op->show_devname(m, mnt->mnt_root);
+		err = sb->s_op->show_devname(m, mnt);
 	else
 		mangle(m, r->mnt_devname ? r->mnt_devname : "none");
 	if (err)
@@ -190,7 +190,7 @@ static int show_vfsstat(struct seq_file *m, struct vfsmount *mnt)
 	/* device */
 	if (sb->s_op->show_devname) {
 		seq_puts(m, "device ");
-		err = sb->s_op->show_devname(m, mnt_path.dentry);
+		err = sb->s_op->show_devname(m, mnt);
 	} else {
 		if (r->mnt_devname) {
 			seq_puts(m, "device ");
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 25c40b9..b39e678 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1699,7 +1699,7 @@ struct super_operations {
 	void (*umount_begin) (struct super_block *);
 
 	int (*show_options)(struct seq_file *, struct dentry *);
-	int (*show_devname)(struct seq_file *, struct dentry *);
+	int (*show_devname)(struct seq_file *, struct vfsmount *);
 	int (*show_path)(struct seq_file *, struct dentry *);
 	int (*show_stats)(struct seq_file *, struct dentry *);
 #ifdef CONFIG_QUOTA
-- 
1.7.6.5
