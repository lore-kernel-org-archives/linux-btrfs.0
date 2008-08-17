From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] rewrite btrfs_readdir()
Date: Sun, 17 Aug 2008 17:10:00 +0100
Message-ID: <1218989400.3184.315.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218979817.3184.296.camel@pmac.infradead.org>
	 <1218982640.3184.307.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218982640.3184.307.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2008-08-17 at 15:17 +0100, David Woodhouse wrote:
> Subject: [PATCH] Remove special cases for "." and ".."
> 
> We never get asked by the VFS to lookup either of them, and we can
> handle the readdir() case a lot more simply, too.

And a few other minor cleanups... some cosmetic, but note the WARN_ON().

From: David Woodhouse <David.Woodhouse@intel.com>
Date: Sun, 17 Aug 2008 17:08:36 +0100
Subject: [PATCH] Minor cleanup of btrfs_real_readdir()

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 inode.c |   42 +++++++++++++++++++++++++++---------------
 1 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/inode.c b/inode.c
index 411dfc4..187e1f8 100644
--- a/inode.c
+++ b/inode.c
@@ -1960,34 +1960,34 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 			return 0;
 		filp->f_pos = 1;
 	}
-
-	key.objectid = inode->i_ino;
-	path = btrfs_alloc_path();
-	path->reada = 2;
-
 	/* special case for .., just use the back ref */
 	if (filp->f_pos == 1) {
 		u64 pino = parent_ino(filp->f_path.dentry);
 		over = filldir(dirent, "..", 2,
 			       2, pino, DT_DIR);
 		if (over)
-			goto nopos;
+			return 0;
 		filp->f_pos = 2;
 	}
 
+	path = btrfs_alloc_path();
+	path->reada = 2;
+
 	btrfs_set_key_type(&key, key_type);
 	key.offset = filp->f_pos;
+	key.objectid = inode->i_ino;
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
 	advance = 0;
-	while(1) {
+
+	while (1) {
 		leaf = path->nodes[0];
 		nritems = btrfs_header_nritems(leaf);
 		slot = path->slots[0];
 		if (advance || slot >= nritems) {
-			if (slot >= nritems -1) {
+			if (slot >= nritems - 1) {
 				ret = btrfs_next_leaf(root, path);
 				if (ret)
 					break;
@@ -2011,19 +2011,23 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 			continue;
 
 		filp->f_pos = found_key.offset;
-		advance = 1;
+
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
 		di_cur = 0;
 		di_total = btrfs_item_size(leaf, item);
-		while(di_cur < di_total) {
+
+		while (di_cur < di_total) {
 			struct btrfs_key location;
 
 			name_len = btrfs_dir_name_len(leaf, di);
-			if (name_len < 32) {
+			if (name_len <= sizeof(tmp_name)) {
 				name_ptr = tmp_name;
 			} else {
 				name_ptr = kmalloc(name_len, GFP_NOFS);
-				BUG_ON(!name_ptr);
+				if (!name_ptr) {
+					ret = -ENOMEM;
+					goto err;
+				}
 			}
 			read_extent_buffer(leaf, name_ptr,
 					   (unsigned long)(di + 1), name_len);
@@ -2031,8 +2035,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 			d_type = btrfs_filetype_table[btrfs_dir_type(leaf, di)];
 			btrfs_dir_item_key_to_cpu(leaf, di, &location);
 			over = filldir(dirent, name_ptr, name_len,
-				       found_key.offset,
-				       location.objectid,
+				       found_key.offset, location.objectid,
 				       d_type);
 
 			if (name_ptr != tmp_name)
@@ -2040,12 +2043,21 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 			if (over)
 				goto nopos;
+
 			di_len = btrfs_dir_name_len(leaf, di) +
-				btrfs_dir_data_len(leaf, di) +sizeof(*di);
+				 btrfs_dir_data_len(leaf, di) + sizeof(*di);
 			di_cur += di_len;
 			di = (struct btrfs_dir_item *)((char *)di + di_len);
+
+			/* If there's more than one directory entry in each
+			   item, then the offset isn't unique. Seeking in 
+			   directories will be broken. Can this ever actually
+			   happen? */
+			WARN_ON(di_cur != di_total);
 		}
 	}
+
+	/* Reached end of directory/root. Bump pos past the last item. */
 	if (key_type == BTRFS_DIR_INDEX_KEY)
 		filp->f_pos = INT_LIMIT(typeof(filp->f_pos));
 	else
-- 
1.5.5.1



-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



