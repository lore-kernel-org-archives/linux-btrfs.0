From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/4] Btrfs: Check if btrfs_next_leaf() returns error in btrfs_real_readdir()
Date: Wed, 13 Apr 2011 15:42:38 +0800
Message-ID: <4DA553EE.3040709@cn.fujitsu.com>
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
 fs/btrfs/inode.c |   28 ++++++++++------------------
 1 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 55a6a0b..b9f7f52 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4221,10 +4221,8 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	struct btrfs_key found_key;
 	struct btrfs_path *path;
 	int ret;
-	u32 nritems;
 	struct extent_buffer *leaf;
 	int slot;
-	int advance;
 	unsigned char d_type;
 	int over = 0;
 	u32 di_cur;
@@ -4267,27 +4265,19 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
-	advance = 0;
 
 	while (1) {
 		leaf = path->nodes[0];
-		nritems = btrfs_header_nritems(leaf);
 		slot = path->slots[0];
-		if (advance || slot >= nritems) {
-			if (slot >= nritems - 1) {
-				ret = btrfs_next_leaf(root, path);
-				if (ret)
-					break;
-				leaf = path->nodes[0];
-				nritems = btrfs_header_nritems(leaf);
-				slot = path->slots[0];
-			} else {
-				slot++;
-				path->slots[0]++;
-			}
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto err;
+			else if (ret > 0)
+				break;
+			continue;
 		}
 
-		advance = 1;
 		item = btrfs_item_nr(leaf, slot);
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
 
@@ -4296,7 +4286,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 		if (btrfs_key_type(&found_key) != key_type)
 			break;
 		if (found_key.offset < filp->f_pos)
-			continue;
+			goto next;
 
 		filp->f_pos = found_key.offset;
 
@@ -4349,6 +4339,8 @@ skip:
 			di_cur += di_len;
 			di = (struct btrfs_dir_item *)((char *)di + di_len);
 		}
+next:
+		path->slots[0]++;
 	}
 
 	/* Reached end of directory/root. Bump pos past the last item. */
-- 
1.7.3.1
