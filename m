From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH] update mkfs for the new space balancing code
Date: Fri, 26 Sep 2008 00:58:21 +0800
Message-ID: <48DBC32D.1010603@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

The new space balancing code needs a subvol to store the
temporary inode for data extent relocation.

Regards
Yan Zheng

---
diff -r 35eb00b579c4 mkfs.c
--- a/mkfs.c	Tue Sep 23 12:29:10 2008 -0400
+++ b/mkfs.c	Thu Sep 25 21:50:51 2008 +0800
@@ -229,6 +229,32 @@
 					    (allowed & data_profile));
 		BUG_ON(ret);
 	}
+	return 0;
+}
+
+static int create_data_reloc_tree(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root)
+{
+	struct btrfs_key location;
+	struct btrfs_root_item root_item;
+	struct extent_buffer *tmp;
+	u64 objectid = BTRFS_DATA_RELOC_TREE_OBJECTID;
+	int ret;
+
+	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
+	BUG_ON(ret);
+
+	memcpy(&root_item, &root->root_item, sizeof(root_item));
+	btrfs_set_root_bytenr(&root_item, tmp->start);
+	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
+	free_extent_buffer(tmp);
+
+	location.objectid = objectid;
+	location.type = BTRFS_ROOT_ITEM_KEY;
+	location.offset = trans->transid;
+	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
+				&location, &root_item);
+	BUG_ON(ret);
 	return 0;
 }
 
@@ -459,6 +485,9 @@
 				 metadata_profile);
 	BUG_ON(ret);
 
+	ret = create_data_reloc_tree(trans, root);
+	BUG_ON(ret);
+
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
 	    label, first_file, nodesize, leafsize, sectorsize,
