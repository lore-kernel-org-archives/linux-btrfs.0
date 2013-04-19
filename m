Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:58308 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030743Ab3DSPlK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 11:41:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp1) (RZmta 31.27 OK)
	with ESMTP id X00382p3JElnXe for <linux-btrfs@vger.kernel.org>;
	Fri, 19 Apr 2013 17:41:06 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] Btrfs: introduce a tree for items that map UUIDs to something
Date: Fri, 19 Apr 2013 17:41:02 +0200
Message-Id: <8353e75097a4ffa82c8c25feac939cf1bd64dc2f.1366384796.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1366384796.git.sbehrens@giantdisaster.de>
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1366384796.git.sbehrens@giantdisaster.de>
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mapping UUIDs to subvolume IDs is an operation with a high effort
today. Today, the algorithm even has quadratic effort (based on the
number of existing subvolumes), which means, that it takes minutes
to send/receive a single subvolume if 10,000 subvolumes exist. But
even linear effort would be too much since it is a waste. And these
data structures to allow mapping UUIDs to subvolume IDs are created
every time a btrfs send/receive instance is started.

It is much more efficient to maintain a searchable persistent data
structure in the filesystem, one that is updated whenever a
subvolume/snapshot is created and deleted, and when the received
subvolume UUID is set by the btrfs-receive tool.

Therefore kernel code is added with this commit that is able to
maintain data structures in the filesystem that allow to quickly
search for a given UUID and to retrieve data that is assigned to
this UUID, like which subvolume ID is related to this UUID.

This commit adds a new tree to hold UUID-to-data mapping items. The
key of the items is the full UUID plus the key type BTRFS_UUID_KEY.
Multiple data blocks can be stored for a given UUID, a type/length/
value scheme is used.

Now follows the lengthy justification, why a new tree was added
instead of using the existing root tree:

The first approach was to not create another tree that holds UUID
items. Instead, the items should just go into the top root tree.
Unfortunately this confused the algorithm to assign the objectid
of subvolumes and snapshots. The reason is that
btrfs_find_free_objectid() calls btrfs_find_highest_objectid() for
the first created subvol or snapshot after mounting a filesystem,
and this function simply searches for the largest used objectid in
the root tree keys to pick the next objectid to assign. Of course,
the UUID keys have always been the ones with the highest offset
value, and the next assigned subvol ID was wastefully huge.

To use any other existing tree did not look proper. To apply a
workaround such as setting the objectid to zero in the UUID item
key and to implement collision handling would either add
limitations (in case of a btrfs_extend_item() approach to handle
the collisions) or a lot of complexity and source code (in case a
key would be looked up that is free of collisions). Adding new code
that introduces limitations is not good, and adding code that is
complex and lengthy for no good reason is also not good. That's the
justification why a completely new tree was introduced.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/Makefile    |   3 +-
 fs/btrfs/ctree.h     |  50 ++++++
 fs/btrfs/uuid-tree.c | 497 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 549 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 3932224..a550dfc 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -8,7 +8,8 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
-	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o
+	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
+	   uuid-tree.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 84be717..0439570 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -94,6 +94,9 @@ struct btrfs_ordered_sum;
 /* holds quota configuration and tracking */
 #define BTRFS_QUOTA_TREE_OBJECTID 8ULL
 
+/* for storing items that use the BTRFS_UUID_KEY */
+#define BTRFS_UUID_TREE_OBJECTID 9ULL
+
 /* orhpan objectid for tracking unlinked/truncated files */
 #define BTRFS_ORPHAN_OBJECTID -5ULL
 
@@ -953,6 +956,18 @@ struct btrfs_dev_replace_item {
 	__le64 num_uncorrectable_read_errors;
 } __attribute__ ((__packed__));
 
+/* for items that use the BTRFS_UUID_KEY */
+#define BTRFS_UUID_ITEM_TYPE_SUBVOL	0 /* for UUIDs assigned to subvols */
+#define BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL	1 /* for UUIDs assigned to
+						   * received subvols */
+
+/* a sequence of such items is stored under the BTRFS_UUID_KEY */
+struct btrfs_uuid_item {
+	__le64 type;	/* refer to BTRFS_UUID_ITEM_TYPE* defines above */
+	__le64 len;	/* number of following 64bit values */
+	__le64 subid[0];	/* sequence of subids */
+} __attribute__ ((__packed__));
+
 /* different types of block groups (and chunks) */
 #define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
 #define BTRFS_BLOCK_GROUP_SYSTEM	(1ULL << 1)
@@ -1889,6 +1904,17 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_DEV_REPLACE_KEY	250
 
 /*
+ * Stores items that allow to quickly map UUIDs to something else.
+ * These items are part of the filesystem UUID tree.
+ * The key is built like this:
+ * (UUID_upper_64_bits, BTRFS_UUID_KEY, UUID_lower_64_bits).
+ */
+#if BTRFS_UUID_SIZE != 16
+#error "UUID items require BTRFS_UUID_SIZE == 16!"
+#endif
+#define BTRFS_UUID_KEY	251
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
@@ -2946,6 +2972,12 @@ BTRFS_SETGET_FUNCS(dev_replace_cursor_left, struct btrfs_dev_replace_item,
 BTRFS_SETGET_FUNCS(dev_replace_cursor_right, struct btrfs_dev_replace_item,
 		   cursor_right, 64);
 
+/* btrfs_uuid_item */
+BTRFS_SETGET_FUNCS(uuid_type, struct btrfs_uuid_item, type, 64);
+BTRFS_SETGET_FUNCS(uuid_len, struct btrfs_uuid_item, len, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_uuid_type, struct btrfs_uuid_item, type, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_uuid_len, struct btrfs_uuid_item, len, 64);
+
 BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_src_devid,
 			 struct btrfs_dev_replace_item, src_devid, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_cont_reading_from_srcdev_mode,
@@ -3373,6 +3405,24 @@ void btrfs_check_and_init_root_item(struct btrfs_root_item *item);
 void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
 
+/* uuid-tree.c */
+int btrfs_lookup_uuid_subvol_item(struct btrfs_root *uuid_root, u8 *uuid,
+				  u64 *subvol_id);
+int btrfs_insert_uuid_subvol_item(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *uuid_root, u8 *uuid,
+				  u64 subvol_id);
+int btrfs_del_uuid_subvol_item(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *uuid_root, u8 *uuid,
+			       u64 subvol_id);
+int btrfs_lookup_uuid_received_subvol_item(struct btrfs_root *uuid_root,
+					   u8 *uuid, u64 *subvol_id);
+int btrfs_insert_uuid_received_subvol_item(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *uuid_root,
+					   u8 *uuid, u64 subvol_id);
+int btrfs_del_uuid_received_subvol_item(struct btrfs_trans_handle *trans,
+					struct btrfs_root *uuid_root, u8 *uuid,
+					u64 subvol_id);
+
 /* dir-item.c */
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 			  const char *name, int name_len);
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
new file mode 100644
index 0000000..bfc2502
--- /dev/null
+++ b/fs/btrfs/uuid-tree.c
@@ -0,0 +1,497 @@
+/*
+ * Copyright (C) STRATO AG 2013.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+#include <linux/uuid.h>
+#include "ctree.h"
+#include "transaction.h"
+#include "disk-io.h"
+#include "print-tree.h"
+
+
+/*
+ * One key is used to store a sequence of btrfs_uuid_item items.
+ * Each item in the sequence contains a type information and a sequence of
+ * ids (together with the information about the size of the sequence of ids).
+ * {[btrfs_uuid_item type0 {id0, id1, ..., idN}],
+ *  ...,
+ *  [btrfs_uuid_item typeZ {id0, id1, ..., idN}]}
+ *
+ * It is forbidden to put multiple items with the same type under the same key.
+ * Instead the sequence of ids is extended and used to store any additional
+ * ids for the same item type.
+ */
+
+static void btrfs_uuid_16xu8_to_2xu64(u8 *uuid, u64 *first64, u64 *second64)
+{
+	u64 val;
+	int i;
+	int j;
+
+	for (i = 0; i < 2; i++) {
+		val = 0;
+		for (j = 7; j >= 0; j--) {
+			/* in host byte order, resulting disk key is le */
+			val |= ((u64)*uuid) << (j * 8);
+			uuid++;
+		}
+		if (!i)
+			*first64 = val;
+		else
+			*second64 = val;
+	}
+}
+
+static struct btrfs_uuid_item *btrfs_match_uuid_item_type(
+		struct btrfs_path *path, u64 type)
+{
+	struct extent_buffer *eb;
+	int slot;
+	struct btrfs_uuid_item *ptr;
+	u32 item_size;
+
+	eb = path->nodes[0];
+	slot = path->slots[0];
+	ptr = btrfs_item_ptr(eb, slot, struct btrfs_uuid_item);
+	item_size = btrfs_item_size_nr(eb, slot);
+	do {
+		u64 sub_item_type;
+		u64 sub_item_len;
+
+		if (item_size < sizeof(*ptr)) {
+			pr_warn("btrfs: uuid item too short (%llu < %d)!\n",
+				(unsigned long long)item_size,
+				(int)sizeof(*ptr));
+			return NULL;
+		}
+		item_size -= sizeof(*ptr);
+		sub_item_type = btrfs_uuid_type(eb, ptr);
+		sub_item_len = btrfs_uuid_len(eb, ptr);
+		if (sub_item_len * 8 > item_size) {
+			pr_warn("btrfs: uuid item too short (%llu > %llu)!\n",
+				(unsigned long long)(sub_item_len * 8),
+				(unsigned long long)item_size);
+			return NULL;
+		}
+		if (sub_item_type == type)
+			return ptr;
+		item_size -= sub_item_len * 8;
+		ptr = 1 + (struct btrfs_uuid_item *)
+			(((char *)ptr) + (sub_item_len * 8));
+	} while (item_size);
+
+	return NULL;
+}
+
+static int btrfs_uuid_tree_lookup_prepare(struct btrfs_root *uuid_root,
+					  u8 *uuid, u64 type,
+					  struct btrfs_path **path,
+					  struct btrfs_uuid_item **ptr)
+{
+	int ret;
+	struct btrfs_key key;
+
+	WARN_ON_ONCE(!uuid_root);
+	if (!uuid_root) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	key.type = BTRFS_UUID_KEY;
+	btrfs_uuid_16xu8_to_2xu64(uuid, &key.objectid, &key.offset);
+
+	*path = btrfs_alloc_path();
+	if (!*path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = btrfs_search_slot(NULL, uuid_root, &key, *path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	*ptr = btrfs_match_uuid_item_type(*path, type);
+	if (!*ptr) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	return ret;
+}
+
+/* return -ENOENT for !found, < 0 for errors, or 0 if an item was found */
+static int btrfs_uuid_tree_lookup(struct btrfs_root *uuid_root, u8 *uuid,
+				  u64 type, u64 subid)
+{
+	int ret;
+	struct btrfs_path *path = NULL;
+	struct extent_buffer *eb;
+	struct btrfs_uuid_item *ptr;
+	u64 sub_item_len;
+	unsigned long offset;
+
+	ret = btrfs_uuid_tree_lookup_prepare(uuid_root, uuid, type, &path,
+					     &ptr);
+	if (ret < 0)
+		goto out;
+
+	eb = path->nodes[0];
+	sub_item_len = btrfs_uuid_len(eb, ptr);
+	WARN_ON_ONCE(sub_item_len == 0);
+	ret = -ENOENT;
+	ptr++;
+	offset = (unsigned long)ptr;
+	while (sub_item_len > 0) {
+		u64 data;
+
+		read_extent_buffer(eb, &data, offset, sizeof(data));
+		if (data == subid) {
+			ret = 0;
+			break;
+		}
+		offset += sizeof(data);
+		sub_item_len--;
+	}
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+/* return -ENOENT for !found, < 0 for errors, or 0 if an item was found */
+static int btrfs_uuid_tree_lookup_any(struct btrfs_root *uuid_root, u8 *uuid,
+				      u64 type, u64 *subid)
+{
+	int ret;
+	struct btrfs_path *path = NULL;
+	struct extent_buffer *eb;
+	struct btrfs_uuid_item *ptr;
+	u64 sub_item_len;
+
+	ret = btrfs_uuid_tree_lookup_prepare(uuid_root, uuid, type, &path,
+					     &ptr);
+	if (ret < 0)
+		goto out;
+
+	eb = path->nodes[0];
+	sub_item_len = btrfs_uuid_len(eb, ptr);
+	WARN_ON_ONCE(sub_item_len == 0);
+	if (sub_item_len > 0) {
+		/* return first stored id */
+		read_extent_buffer(eb, subid, (unsigned long)(ptr + 1),
+				   sizeof(*subid));
+		ret = 0;
+	} else {
+		ret = -ENOENT;
+	}
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+/* it is not checked very the entry to add already exists */
+static int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *uuid_root, u8 *uuid,
+			       u64 type, u64 subid)
+{
+	int ret;
+	struct btrfs_path *path = NULL;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	int slot;
+	struct btrfs_uuid_item *ptr;
+	u32 item_size;
+
+	WARN_ON_ONCE(!uuid_root);
+	if (!uuid_root) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	key.type = BTRFS_UUID_KEY;
+	btrfs_uuid_16xu8_to_2xu64(uuid, &key.objectid, &key.offset);
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = btrfs_insert_empty_item(trans, uuid_root, path, &key,
+				      sizeof(*ptr) + sizeof(subid));
+	if (ret == -EEXIST) {
+		ptr = btrfs_match_uuid_item_type(path, type);
+		if (ptr) {
+			/*
+			 * An item with that type already exists.
+			 * Extend the item and store the subid at the
+			 * location of the first id of this type.
+			 */
+			unsigned long start;
+			unsigned long move_dst;
+			unsigned long move_src;
+			unsigned long move_len;
+
+			btrfs_extend_item(uuid_root, path, sizeof(subid));
+			ptr = (struct btrfs_uuid_item *)
+				(((char *)ptr) - sizeof(subid));
+			eb = path->nodes[0];
+			slot = path->slots[0];
+			item_size = btrfs_item_size_nr(eb, slot);
+			WARN_ON(btrfs_uuid_len(eb, ptr) == 0);
+			btrfs_set_uuid_len(eb, ptr,
+					   btrfs_uuid_len(eb, ptr) + 1);
+			ptr++;
+			start = btrfs_item_ptr_offset(eb, slot);
+			move_dst = ((unsigned long)ptr) + sizeof(subid);
+			move_src = (unsigned long)ptr;
+			move_len = item_size - (move_dst - start);
+			memmove_extent_buffer(eb, move_dst, move_src, move_len);
+
+			goto write_subid;
+		} else {
+			btrfs_extend_item(uuid_root, path,
+					  sizeof(*ptr) + sizeof(subid));
+		}
+	} else if (ret < 0) {
+		pr_warn("btrfs: insert uuid-subvol item failed %d (0x%016llx, 0x%016llx) type %llu!\n",
+				ret, (unsigned long long)key.objectid,
+				(unsigned long long)key.offset,
+				(unsigned long long)type);
+		goto out;
+	}
+
+	/*
+	 * Add an item for the type for the first time. Either add it behind
+	 * items with different types, or write the very first item.
+	 */
+	eb = path->nodes[0];
+	slot = path->slots[0];
+	ptr = btrfs_item_ptr(eb, slot, struct btrfs_uuid_item);
+	item_size = btrfs_item_size_nr(eb, slot);
+	ptr = (struct btrfs_uuid_item *)
+		(((char *)ptr) + item_size - (sizeof(*ptr) + sizeof(subid)));
+	btrfs_set_uuid_type(eb, ptr, type);
+	btrfs_set_uuid_len(eb, ptr, 1);
+	ptr++;
+
+write_subid:
+	ret = 0;
+	write_extent_buffer(eb, &subid, (unsigned long)ptr, sizeof(subid));
+	btrfs_mark_buffer_dirty(eb);
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *uuid_root, u8 *uuid,
+			       u64 type, u64 subid)
+{
+	int ret;
+	struct btrfs_path *path = NULL;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	int slot;
+	struct btrfs_uuid_item *ptr_start;
+	unsigned long offset;
+	u32 item_size;
+	u64 id_index;
+	unsigned long start;
+	unsigned long move_dst;
+	unsigned long move_src;
+	unsigned long move_len;
+
+	WARN_ON_ONCE(!uuid_root);
+	if (!uuid_root) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	key.type = BTRFS_UUID_KEY;
+	btrfs_uuid_16xu8_to_2xu64(uuid, &key.objectid, &key.offset);
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = btrfs_search_slot(trans, uuid_root, &key, path, -1, 1);
+	if (ret < 0) {
+		pr_warn("btrfs: error %d while searching for uuid item!\n",
+			ret);
+		goto out;
+	}
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ptr_start = btrfs_match_uuid_item_type(path, type);
+	if (!ptr_start) {
+		/* case 1: no entry for that type is found */
+		ret = -ENOENT;
+		goto out;
+	}
+
+	eb = path->nodes[0];
+	slot = path->slots[0];
+	start = btrfs_item_ptr_offset(eb, slot);
+	item_size = btrfs_item_size_nr(eb, slot);
+	id_index = btrfs_uuid_len(eb, ptr_start);
+	offset = (unsigned long)(ptr_start + 1);
+	while (id_index > 0) {
+		u64 found_subid;
+
+		read_extent_buffer(eb, &found_subid, offset,
+				   sizeof(found_subid));
+		if (found_subid == subid)
+			break;
+		offset += sizeof(found_subid);
+		id_index--;
+	}
+
+	if (!id_index) {
+		/*
+		 * case 2: an entry for that type is found, but no match
+		 * for the id
+		 */
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (btrfs_uuid_len(eb, ptr_start) == 1) {
+		if (item_size == sizeof(*ptr_start) + sizeof(subid)) {
+			/*
+			 * case 3: no other types and ids are stored,
+			 * delete the full item
+			 */
+			ret = btrfs_del_item(trans, uuid_root, path);
+			goto out;
+		} else {
+			/*
+			 * case 4: No other ids for the particular type
+			 * are stored, but other types exist. Shrink the
+			 * item by the size of an id plus the size of the
+			 * item for that type.
+			 */
+			move_dst = (unsigned long)ptr_start;
+		}
+	} else {
+		/*
+		 * case 5: Other ids for that particular type are stored.
+		 * Shrink the item by the size of an id.
+		 */
+		move_dst = offset;
+		WARN_ON(btrfs_uuid_len(eb, ptr_start) == 0);
+		btrfs_set_uuid_len(eb, ptr_start,
+				   btrfs_uuid_len(eb, ptr_start) - 1);
+	}
+	move_src = offset + sizeof(subid);
+	move_len = item_size - (move_src - start);
+
+	memmove_extent_buffer(eb, move_dst, move_src, move_len);
+	btrfs_truncate_item(uuid_root, path, item_size - (move_src - move_dst),
+			    1);
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+int btrfs_lookup_uuid_subvol_item(struct btrfs_root *uuid_root, u8 *uuid,
+				  u64 *subvol_id)
+{
+	int ret;
+
+	ret = btrfs_uuid_tree_lookup_any(uuid_root, uuid,
+					 BTRFS_UUID_ITEM_TYPE_SUBVOL,
+					 subvol_id);
+	*subvol_id = le64_to_cpu(*subvol_id);
+	return ret;
+}
+
+int btrfs_insert_uuid_subvol_item(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *uuid_root, u8 *uuid,
+				  u64 subvol_id)
+{
+	int ret;
+
+	subvol_id = cpu_to_le64(subvol_id);
+	ret = btrfs_uuid_tree_lookup(uuid_root, uuid,
+				     BTRFS_UUID_ITEM_TYPE_SUBVOL, subvol_id);
+	if (ret == -ENOENT)
+		ret = btrfs_uuid_tree_add(trans, uuid_root, uuid,
+					  BTRFS_UUID_ITEM_TYPE_SUBVOL,
+					  subvol_id);
+	return ret;
+}
+
+int btrfs_del_uuid_subvol_item(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *uuid_root, u8 *uuid,
+			       u64 subvol_id)
+{
+	return btrfs_uuid_tree_rem(trans, uuid_root, uuid,
+				   BTRFS_UUID_ITEM_TYPE_SUBVOL, subvol_id);
+}
+
+int btrfs_lookup_uuid_received_subvol_item(struct btrfs_root *uuid_root,
+					   u8 *uuid, u64 *subvol_id)
+{
+	int ret;
+
+	ret = btrfs_uuid_tree_lookup_any(uuid_root, uuid,
+					 BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL,
+					 subvol_id);
+	*subvol_id = le64_to_cpu(*subvol_id);
+	return ret;
+}
+
+int btrfs_insert_uuid_received_subvol_item(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *uuid_root,
+					   u8 *uuid, u64 subvol_id)
+{
+	int ret;
+
+	subvol_id = cpu_to_le64(subvol_id);
+	ret = btrfs_uuid_tree_lookup(uuid_root, uuid,
+				     BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL,
+				     subvol_id);
+	if (ret == -ENOENT)
+		ret = btrfs_uuid_tree_add(trans, uuid_root, uuid,
+					  BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL,
+					  subvol_id);
+	return ret;
+}
+
+int btrfs_del_uuid_received_subvol_item(struct btrfs_trans_handle *trans,
+					struct btrfs_root *uuid_root, u8 *uuid,
+					u64 subvol_id)
+{
+	return btrfs_uuid_tree_rem(trans, uuid_root, uuid,
+				   BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL,
+				   subvol_id);
+}
-- 
1.8.2.1

