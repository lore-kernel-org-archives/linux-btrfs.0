Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3275 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752075AbcIUDQ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:16:29 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH v2 08/14] btrfs-progs: check: introduce function to check inode item
Date: Wed, 21 Sep 2016 11:15:58 +0800
Message-Id: <20160921031604.23334-9-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce a new function check_inode_item() to check INODE_ITEM and
related ITEMs that have the same inode id.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 168 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 168 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 0afbf96..5e3ecac 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3858,6 +3858,11 @@ out:
 #define FILE_EXTENT_ERROR	(1<<7)	/* bad file extent */
 #define ODD_CSUM_ITEM		(1<<8)	/* CSUM_ITEM ERROR */
 #define CSUM_ITEM_MISSING	(1<<9)	/* CSUM_ITEM not found */
+#define LINK_COUNT_ERROR	(1<<10)	/* INODE_ITEM nlink count error */
+#define NBYTES_ERROR		(1<<11)	/* INODE_ITEM nbytes count error */
+#define ISIZE_ERROR		(1<<12)	/* INODE_ITEM size count error */
+#define ORPHAN_ITEM		(1<<13) /* INODE_ITEM no reference */
+#define LAST_ITEM		(1<<15)	/* Complete this tree traversal */
 
 /*
  * Find DIR_ITEM/DIR_INDEX for the given key and check it with the specified
@@ -4513,6 +4518,169 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 	return err;
 }
 
+/*
+ * Check INODE_ITEM and related ITEMs(the same inode id)
+ * 1. check link count
+ * 2. check inode ref/extref
+ * 3. check dir item/index
+ *
+ * @ext_ref:	the EXTENDED_IREF feature
+ *
+ * Return 0 if no error occurred.
+ * Return >0 for error or hit the traversal is done(by error bitmap)
+ */
+static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
+			    unsigned int ext_ref)
+{
+	struct extent_buffer *node;
+	struct btrfs_inode_item *ii;
+	struct btrfs_key key;
+	u64 inode_id;
+	u32 mode;
+	u64 nlink;
+	u64 nbytes;
+	u64 isize;
+	u64 size = 0;
+	u64 refs = 0;
+	u64 extent_end = 0;
+	u64 extent_size = 0;
+	unsigned int dir;
+	unsigned int nodatasum;
+	int slot;
+	int ret;
+	int err = 0;
+
+	node = path->nodes[0];
+	slot = path->slots[0];
+
+	btrfs_item_key_to_cpu(node, &key, slot);
+	inode_id = key.objectid;
+
+	if (inode_id == BTRFS_ORPHAN_OBJECTID) {
+		ret = btrfs_next_item(root, path);
+		if (ret > 0)
+			err |= LAST_ITEM;
+		return err;
+	}
+
+	ii = btrfs_item_ptr(node, slot, struct btrfs_inode_item);
+	isize = btrfs_inode_size(node, ii);
+	nbytes = btrfs_inode_nbytes(node, ii);
+	mode = btrfs_inode_mode(node, ii);
+	dir = imode_to_type(mode) == BTRFS_FT_DIR;
+	nlink = btrfs_inode_nlink(node, ii);
+	nodatasum = btrfs_inode_flags(node, ii) & BTRFS_INODE_NODATASUM;
+
+	while (1) {
+		ret = btrfs_next_item(root, path);
+		if (ret < 0) {
+			/* out will fill 'err' rusing current statistics */
+			goto out;
+		} else if (ret > 0) {
+			err |= LAST_ITEM;
+			goto out;
+		}
+
+		node = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(node, &key, slot);
+		if (key.objectid != inode_id)
+			goto out;
+
+		switch (key.type) {
+		case BTRFS_INODE_REF_KEY:
+			ret = check_inode_ref(root, &key, node, slot, &refs,
+					      mode);
+			err |= ret;
+			break;
+		case BTRFS_INODE_EXTREF_KEY:
+			if (key.type == BTRFS_INODE_EXTREF_KEY && !ext_ref)
+				warning("root %llu EXTREF[%llu %llu] isn't supported",
+					root->objectid, key.objectid,
+					key.offset);
+			ret = check_inode_extref(root, &key, node, slot, &refs,
+						 mode);
+			err |= ret;
+			break;
+		case BTRFS_DIR_ITEM_KEY:
+		case BTRFS_DIR_INDEX_KEY:
+			if (!dir) {
+				warning("root %llu INODE[%llu] mode %u shouldn't have DIR_INDEX[%llu %llu]",
+					root->objectid,	inode_id,
+					imode_to_type(mode), key.objectid,
+					key.offset);
+			}
+			ret = check_dir_item(root, &key, node, slot, &size,
+					     ext_ref);
+			err |= ret;
+			break;
+		case BTRFS_EXTENT_DATA_KEY:
+			if (dir) {
+				warning("root %llu DIR INODE[%llu] shouldn't EXTENT_DATA[%llu %llu]",
+					root->objectid, inode_id, key.objectid,
+					key.offset);
+			}
+			ret = check_file_extent(root, &key, node, slot,
+						nodatasum, &extent_size,
+						&extent_end);
+			err |= ret;
+			break;
+		case BTRFS_XATTR_ITEM_KEY:
+			break;
+		default:
+			error("ITEM[%llu %u %llu] UNKNOWN TYPE",
+			      key.objectid, key.type, key.offset);
+		}
+	}
+
+out:
+	/* verify INODE_ITEM nlink/isize/nbytes */
+	if (dir) {
+		if (nlink != 1) {
+			err |= LINK_COUNT_ERROR;
+			error("root %llu DIR INODE[%llu] shouldn't have more than one link(%llu)",
+			      root->objectid, inode_id, nlink);
+		}
+
+		/*
+		 * Just a warning, as dir inode nbytes is just an
+		 * instructive value.
+		 */
+		if (!IS_ALIGNED(nbytes, root->nodesize)) {
+			warning("root %llu DIR INODE[%llu] nbytes should be aligned to %u",
+				root->objectid, inode_id, root->nodesize);
+		}
+
+		if (isize != size) {
+			err |= ISIZE_ERROR;
+			error("root %llu DIR INODE [%llu] size(%llu) not equal to %llu",
+			      root->objectid, inode_id, isize, size);
+		}
+	} else {
+		if (nlink != refs) {
+			err |= LINK_COUNT_ERROR;
+			error("root %llu INODE[%llu] nlink(%llu) not equal to inode_refs(%llu)",
+			      root->objectid, inode_id, nlink, refs);
+		} else if (!nlink) {
+			err |= ORPHAN_ITEM;
+		}
+
+		if (!nbytes && !no_holes && extent_end < isize) {
+			err |= NBYTES_ERROR;
+			error("root %llu INODE[%llu] size (%llu) should have a file extent hole",
+			      root->objectid, inode_id, isize);
+		}
+
+		if (nbytes != extent_size) {
+			err |= NBYTES_ERROR;
+			error("root %llu INODE[%llu] nbytes(%llu) not equal to extent_size(%llu)",
+			      root->objectid, inode_id, nbytes, extent_size);
+		}
+	}
+
+	return err;
+}
+
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
 	struct list_head *cur = rec->backrefs.next;
-- 
2.10.0



