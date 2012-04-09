From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use i_version instead of our own sequence
Date: Mon,  9 Apr 2012 11:53:14 -0400
Message-ID: <1333986794-6525-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We've been keeping around the inode sequence number in hopes that somebody
would use it, but nobody uses it and people actually use i_version which
serves the same purpose, so use i_version where we used the incore inode's
sequence number and that way the sequence is updated properly across the
board, and not just in file write.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h   |    3 ---
 fs/btrfs/delayed-inode.c |    4 ++--
 fs/btrfs/file.c          |    1 -
 fs/btrfs/inode.c         |    5 ++---
 fs/btrfs/super.c         |    2 +-
 5 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 9b9b15f..3771b85 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -83,9 +83,6 @@ struct btrfs_inode {
 	 */
 	u64 generation;
 
-	/* sequence number for NFS changes */
-	u64 sequence;
-
 	/*
 	 * transid of the trans_handle that last modified this inode
 	 */
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 03e3748..bcd40c7 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1706,7 +1706,7 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_nbytes(inode_item, inode_get_bytes(inode));
 	btrfs_set_stack_inode_generation(inode_item,
 					 BTRFS_I(inode)->generation);
-	btrfs_set_stack_inode_sequence(inode_item, BTRFS_I(inode)->sequence);
+	btrfs_set_stack_inode_sequence(inode_item, inode->i_version);
 	btrfs_set_stack_inode_transid(inode_item, trans->transid);
 	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
 	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
@@ -1754,7 +1754,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	set_nlink(inode, btrfs_stack_inode_nlink(inode_item));
 	inode_set_bytes(inode, btrfs_stack_inode_nbytes(inode_item));
 	BTRFS_I(inode)->generation = btrfs_stack_inode_generation(inode_item);
-	BTRFS_I(inode)->sequence = btrfs_stack_inode_sequence(inode_item);
+	inode->i_version = btrfs_stack_inode_sequence(inode_item);
 	inode->i_rdev = 0;
 	*rdev = btrfs_stack_inode_rdev(inode_item);
 	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 431b565..f0da02b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1404,7 +1404,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		mutex_unlock(&inode->i_mutex);
 		goto out;
 	}
-	BTRFS_I(inode)->sequence++;
 
 	start_pos = round_down(pos, root->sectorsize);
 	if (start_pos > i_size_read(inode)) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7a084fb..7d3dd2f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2510,7 +2510,7 @@ static void btrfs_read_locked_inode(struct inode *inode)
 
 	inode_set_bytes(inode, btrfs_inode_nbytes(leaf, inode_item));
 	BTRFS_I(inode)->generation = btrfs_inode_generation(leaf, inode_item);
-	BTRFS_I(inode)->sequence = btrfs_inode_sequence(leaf, inode_item);
+	inode->i_version = btrfs_inode_sequence(leaf, inode_item);
 	inode->i_generation = BTRFS_I(inode)->generation;
 	inode->i_rdev = 0;
 	rdev = btrfs_inode_rdev(leaf, inode_item);
@@ -2594,7 +2594,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 
 	btrfs_set_inode_nbytes(leaf, item, inode_get_bytes(inode));
 	btrfs_set_inode_generation(leaf, item, BTRFS_I(inode)->generation);
-	btrfs_set_inode_sequence(leaf, item, BTRFS_I(inode)->sequence);
+	btrfs_set_inode_sequence(leaf, item, inode->i_version);
 	btrfs_set_inode_transid(leaf, item, trans->transid);
 	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
 	btrfs_set_inode_flags(leaf, item, BTRFS_I(inode)->flags);
@@ -6884,7 +6884,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->root = NULL;
 	ei->space_info = NULL;
 	ei->generation = 0;
-	ei->sequence = 0;
 	ei->last_trans = 0;
 	ei->last_sub_trans = 0;
 	ei->logged_trans = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 54e7ee9..ee1bb31 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -770,7 +770,7 @@ static int btrfs_fill_super(struct super_block *sb,
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
-
+	sb->s_flags |= MS_I_VERSION;
 	err = open_ctree(sb, fs_devices, (char *)data);
 	if (err) {
 		printk("btrfs: open_ctree failed\n");
-- 
1.7.5.2

