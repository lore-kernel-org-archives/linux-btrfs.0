From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Sun, 17 Aug 2008 15:17:20 +0100
Message-ID: <1218982640.3184.307.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218979817.3184.296.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218979817.3184.296.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2008-08-17 at 14:30 +0100, David Woodhouse wrote:
> I think we should just remove that code completely -- and remove the
> similar code from btrfs_real_readdir() while we're at it -- just use
> parent_ino(filp->f_path.dentry) instead. In _that_ case, we know the
> dcache is connected.

>From 6a3710b961c61fef038cca1722176b171697b3da Mon Sep 17 00:00:00 2001
From: David Woodhouse <David.Woodhouse@intel.com>
Date: Sun, 17 Aug 2008 15:14:48 +0100
Subject: [PATCH] Remove special cases for "." and ".."

We never get asked by the VFS to lookup either of them, and we can
handle the readdir() case a lot more simply, too.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 inode.c |   52 ++--------------------------------------------------
 1 files changed, 2 insertions(+), 50 deletions(-)

diff --git a/inode.c b/inode.c
index fe6d4ae..411dfc4 100644
--- a/inode.c
+++ b/inode.c
@@ -1742,42 +1742,9 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	int ret = 0;
 
-	if (namelen == 1 && strcmp(name, ".") == 0) {
-		location->objectid = dir->i_ino;
-		location->type = BTRFS_INODE_ITEM_KEY;
-		location->offset = 0;
-		return 0;
-	}
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
-	if (namelen == 2 && strcmp(name, "..") == 0) {
-		struct btrfs_key key;
-		struct extent_buffer *leaf;
-		int slot;
-
-		key.objectid = dir->i_ino;
-		key.offset = (u64)-1;
-		btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
-		if (ret < 0 || path->slots[0] == 0)
-			goto out_err;
-		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-		BUG_ON(ret == 0);
-		ret = 0;
-		leaf = path->nodes[0];
-		slot = path->slots[0] - 1;
-
-		btrfs_item_key_to_cpu(leaf, &key, slot);
-		if (key.objectid != dir->i_ino ||
-		    key.type != BTRFS_INODE_REF_KEY) {
-			goto out_err;
-		}
-		location->objectid = key.offset;
-		location->type = BTRFS_INODE_ITEM_KEY;
-		location->offset = 0;
-		goto out;
-	}
-
 	di = btrfs_lookup_dir_item(NULL, root, path, dir->i_ino, name,
 				    namelen, 0);
 	if (IS_ERR(di))
@@ -2000,29 +1967,14 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 	/* special case for .., just use the back ref */
 	if (filp->f_pos == 1) {
-		btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
-		key.offset = (u64)-1;
-		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-		if (ret < 0 || path->slots[0] == 0) {
-			btrfs_release_path(root, path);
-			goto read_dir_items;
-		}
-		BUG_ON(ret == 0);
-		leaf = path->nodes[0];
-		slot = path->slots[0] - 1;
-		btrfs_item_key_to_cpu(leaf, &found_key, slot);
-		btrfs_release_path(root, path);
-		if (found_key.objectid != key.objectid ||
-		    found_key.type != BTRFS_INODE_REF_KEY)
-			goto read_dir_items;
+		u64 pino = parent_ino(filp->f_path.dentry);
 		over = filldir(dirent, "..", 2,
-			       2, found_key.offset, DT_DIR);
+			       2, pino, DT_DIR);
 		if (over)
 			goto nopos;
 		filp->f_pos = 2;
 	}
 
-read_dir_items:
 	btrfs_set_key_type(&key, key_type);
 	key.offset = filp->f_pos;
 
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



