From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: run orphan cleanup on default fs root
Date: Tue, 26 Jan 2010 09:30:53 -0500
Message-ID: <20100126143052.GA2183@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch revert's commit

6c090a11e1c403b727a6a8eff0b97d5fb9e95cb5

since it introduces this problem where we can run orphan cleanup on a volume
that can have orphan entries re-added.  Instead of my original fix, Yan Zheng
pointed out that we can just revert my original fix and then run the orphan
cleanup in open_ctree after we look up the fs_root.  I have tested this with all
the tests that gave me problems and this patch fixes both problems.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c |    6 ++++++
 fs/btrfs/inode.c   |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 72c08fa..1ce093f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1937,6 +1937,12 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (!fs_info->fs_root)
 		goto fail_trans_kthread;
 
+	if (!(sb->s_flags & MS_RDONLY)) {
+		down_read(&fs_info->cleanup_work_sem);
+		btrfs_orphan_cleanup(fs_info->fs_root);
+		up_read(&fs_info->cleanup_work_sem);
+	}
+
 	return tree_root;
 
 fail_trans_kthread:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c7fbfaa..09a4d8e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3795,12 +3795,6 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root);
-		if (unlikely(root->clean_orphans) &&
-		    !(inode->i_sb->s_flags & MS_RDONLY)) {
-			down_read(&root->fs_info->cleanup_work_sem);
-			btrfs_orphan_cleanup(root);
-			up_read(&root->fs_info->cleanup_work_sem);
-		}
 		return inode;
 	}
 
-- 
1.5.4.3

