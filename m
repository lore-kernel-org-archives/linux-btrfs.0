From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/3] Introduce btrfs_iget helper
Date: Tue, 12 Aug 2008 14:46:40 +0100
Message-ID: <1218548800.2977.178.camel@pmac.infradead.org>
References: <200806290505.31641.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200806290505.31641.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Balaji Rao <balajirrao@gmail.com>

This patch introduces a btrfs_iget helper to be used in NFS support.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 ctree.h |    2 ++
 inode.c |   55 +++++++++++++++++++++++++++++++++++++------------------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/ctree.h b/ctree.h
index c88f1e1..411d576 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1698,6 +1698,8 @@ struct inode *btrfs_iget_locked(struct super_block *s, u64 objectid,
 				struct btrfs_root *root);
 struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
 			    u64 root_objectid);
+struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
+			 struct btrfs_root *root, int *is_new);
 int btrfs_commit_write(struct file *file, struct page *page,
 		       unsigned from, unsigned to);
 struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
diff --git a/inode.c b/inode.c
index a26d365..5344526 100644
--- a/inode.c
+++ b/inode.c
@@ -1881,6 +1881,33 @@ struct inode *btrfs_iget_locked(struct super_block *s, u64 objectid,
 	return inode;
 }
 
+/* Get an inode object given its location and corresponding root.
+ * Returns in *is_new if the inode was read from disk
+ */
+struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
+			 struct btrfs_root *root, int *is_new)
+{
+	struct inode *inode;
+
+	inode = btrfs_iget_locked(s, location->objectid, root);
+	if (!inode)
+		return ERR_PTR(-EACCES);
+
+	if (inode->i_state & I_NEW) {
+		BTRFS_I(inode)->root = root;
+		memcpy(&BTRFS_I(inode)->location, location, sizeof(*location));
+		btrfs_read_locked_inode(inode);
+		unlock_new_inode(inode);
+		if (is_new)
+			*is_new = 1;
+	} else {
+		if (is_new)
+			*is_new = 0;
+	}
+
+	return inode;
+}
+
 static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 				   struct nameidata *nd)
 {
@@ -1889,7 +1916,7 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 	struct btrfs_root *root = bi->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
-	int ret, do_orphan = 0;
+	int ret, new, do_orphan = 0;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1907,23 +1934,15 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 			return ERR_PTR(ret);
 		if (ret > 0)
 			return ERR_PTR(-ENOENT);
-
-		inode = btrfs_iget_locked(dir->i_sb, location.objectid,
-					  sub_root);
-		if (!inode)
-			return ERR_PTR(-EACCES);
-		if (inode->i_state & I_NEW) {
-			/* the inode and parent dir are two different roots */
-			if (sub_root != root) {
-				igrab(inode);
-				sub_root->inode = inode;
-				do_orphan = 1;
-			}
-			BTRFS_I(inode)->root = sub_root;
-			memcpy(&BTRFS_I(inode)->location, &location,
-			       sizeof(location));
-			btrfs_read_locked_inode(inode);
-			unlock_new_inode(inode);
+		inode = btrfs_iget(dir->i_sb, &location, sub_root, &new);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
+
+		/* the inode and parent dir are two different roots */
+		if (new && root != sub_root) {
+			igrab(inode);
+			sub_root->inode = inode;
+			do_orphan = 1;
 		}
 	}
 
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



