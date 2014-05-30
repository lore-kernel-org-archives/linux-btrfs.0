Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:55893 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030248AbaE3UFs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 16:05:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: [RFC 12/32] btrfs: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:36 +0200
Message-Id: <1401480116-1973111-13-git-send-email-arnd@arndb.de>
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs uses unsigned 64-bit seconds for inode timestamps, which will work
basically forever, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in btrfs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/file.c        | 6 +++---
 fs/btrfs/inode.c       | 4 ++--
 fs/btrfs/ioctl.c       | 4 ++--
 fs/btrfs/root-tree.c   | 2 +-
 fs/btrfs/transaction.c | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a58df83..3e16a4e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1693,16 +1693,16 @@ out:
 
 static void update_time_for_write(struct inode *inode)
 {
-	struct timespec now;
+	struct inode_time now;
 
 	if (IS_NOCMTIME(inode))
 		return;
 
 	now = current_fs_time(inode->i_sb);
-	if (!timespec_equal(&inode->i_mtime, &now))
+	if (!inode_time_equal(&inode->i_mtime, &now))
 		inode->i_mtime = now;
 
-	if (!timespec_equal(&inode->i_ctime, &now))
+	if (!inode_time_equal(&inode->i_ctime, &now))
 		inode->i_ctime = now;
 
 	if (IS_I_VERSION(inode))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2ac3036..d825387 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5440,7 +5440,7 @@ static int btrfs_dirty_inode(struct inode *inode)
  * This is a copy of file_update_time.  We need this so we can return error on
  * ENOSPC for updating the inode in the case of file write and mmap writes.
  */
-static int btrfs_update_time(struct inode *inode, struct timespec *now,
+static int btrfs_update_time(struct inode *inode, struct inode_time *now,
 			     int flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -8223,7 +8223,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct btrfs_root *dest = BTRFS_I(new_dir)->root;
 	struct inode *new_inode = new_dentry->d_inode;
 	struct inode *old_inode = old_dentry->d_inode;
-	struct timespec ctime = CURRENT_TIME;
+	struct inode_time ctime = CURRENT_TIME;
 	u64 index = 0;
 	u64 root_objectid;
 	int ret;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a313ab0..2de5f86 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -435,7 +435,7 @@ static noinline int create_subvol(struct inode *dir,
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *new_root;
 	struct btrfs_block_rsv block_rsv;
-	struct timespec cur_time = CURRENT_TIME;
+	struct inode_time cur_time = CURRENT_TIME;
 	struct inode *inode;
 	int ret;
 	int err;
@@ -4456,7 +4456,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_root_item *root_item = &root->root_item;
 	struct btrfs_trans_handle *trans;
-	struct timespec ct = CURRENT_TIME;
+	struct inode_time ct = CURRENT_TIME;
 	int ret = 0;
 	int received_uuid_changed;
 
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 38bb47e..344e89f 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -487,7 +487,7 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root)
 {
 	struct btrfs_root_item *item = &root->root_item;
-	struct timespec ct = CURRENT_TIME;
+	struct inode_time ct = CURRENT_TIME;
 
 	spin_lock(&root->root_item_lock);
 	btrfs_set_root_ctransid(item, trans->transid);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7579f6d..09dcc8a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1133,7 +1133,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	struct dentry *dentry;
 	struct extent_buffer *tmp;
 	struct extent_buffer *old;
-	struct timespec cur_time = CURRENT_TIME;
+	struct inode_time cur_time = CURRENT_TIME;
 	int ret = 0;
 	u64 to_reserve = 0;
 	u64 index = 0;
-- 
1.8.3.2

