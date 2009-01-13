From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] Btrfs: cleanup xattr code
Date: Tue, 13 Jan 2009 08:48:57 -0500
Message-ID: <1231854537-3969-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

Andrew's review of the xattr code revealed some minor issues that this patch
addresses.  Just an error return fix, got rid of a useless statement and
commented one of the trickier parts of __btrfs_getxattr.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/xattr.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 7f332e2..b4fa5f4 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -45,9 +45,12 @@ ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
 	/* lookup the xattr by name */
 	di = btrfs_lookup_xattr(NULL, root, path, inode->i_ino, name,
 				strlen(name), 0);
-	if (!di || IS_ERR(di)) {
+	if (!di) {
 		ret = -ENODATA;
 		goto out;
+	} else if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		goto out;
 	}
 
 	leaf = path->nodes[0];
@@ -62,6 +65,14 @@ ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
 		ret = -ERANGE;
 		goto out;
 	}
+
+	/*
+	 * The way things are packed into the leaf is like this
+	 * |struct btrfs_dir_item|name|data|
+	 * where name is the xattr name, so security.foo, and data is the
+	 * content of the xattr.  data_ptr points to the location in memory
+	 * where the data starts in the in memory leaf
+	 */
 	data_ptr = (unsigned long)((char *)(di + 1) +
 				   btrfs_dir_name_len(leaf, di));
 	read_extent_buffer(leaf, buffer, data_ptr,
@@ -176,7 +187,6 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
-	ret = 0;
 	advance = 0;
 	while (1) {
 		leaf = path->nodes[0];
-- 
1.5.4.3

