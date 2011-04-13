From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/4] Btrfs: Check if btrfs_next_leaf() returns error in btrfs_listxattr()
Date: Wed, 13 Apr 2011 15:42:16 +0800
Message-ID: <4DA553D8.1060504@cn.fujitsu.com>
References: <4DA553C9.2040807@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA553C9.2040807@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_next_leaf() can return -errno, and we should propagate
it to userspace.

This also simplifies how we walk the btree path.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/xattr.c |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index e5d22f2..07b9bc3 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -180,11 +180,10 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
-	int ret = 0, slot, advance;
+	int ret = 0, slot;
 	size_t total_size = 0, size_left = size;
 	unsigned long name_ptr;
 	size_t name_len;
-	u32 nritems;
 
 	/*
 	 * ok we want all objects associated with this id.
@@ -204,34 +203,24 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
-	advance = 0;
+
 	while (1) {
 		leaf = path->nodes[0];
-		nritems = btrfs_header_nritems(leaf);
 		slot = path->slots[0];
 
 		/* this is where we start walking through the path */
-		if (advance || slot >= nritems) {
+		if (slot >= btrfs_header_nritems(leaf)) {
 			/*
 			 * if we've reached the last slot in this leaf we need
 			 * to go to the next leaf and reset everything
 			 */
-			if (slot >= nritems-1) {
-				ret = btrfs_next_leaf(root, path);
-				if (ret)
-					break;
-				leaf = path->nodes[0];
-				nritems = btrfs_header_nritems(leaf);
-				slot = path->slots[0];
-			} else {
-				/*
-				 * just walking through the slots on this leaf
-				 */
-				slot++;
-				path->slots[0]++;
-			}
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto err;
+			else if (ret > 0)
+				break;
+			continue;
 		}
-		advance = 1;
 
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
 
@@ -250,7 +239,7 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 
 		/* we are just looking for how big our buffer needs to be */
 		if (!size)
-			continue;
+			goto next;
 
 		if (!buffer || (name_len + 1) > size_left) {
 			ret = -ERANGE;
@@ -263,6 +252,8 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 
 		size_left -= name_len + 1;
 		buffer += name_len + 1;
+next:
+		path->slots[0]++;
 	}
 	ret = total_size;
 
-- 
1.7.3.1
