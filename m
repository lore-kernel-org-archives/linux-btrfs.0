Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:37957 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3FZPQp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 11:16:45 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp4) (RZmta 31.28 OK)
	with ESMTP id 60128dp5PJm5Eh for <linux-btrfs@vger.kernel.org>;
	Wed, 26 Jun 2013 17:16:42 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v6 1/8] Btrfs: introduce a tree for items that map UUIDs to something
Date: Wed, 26 Jun 2013 17:16:35 +0200
Message-Id: <dcc3cedb7e15d11570aab0350113bc47eebc262b.1372250828.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372250828.git.sbehrens@giantdisaster.de>
References: <cover.1372250828.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372250828.git.sbehrens@giantdisaster.de>
References: <cover.1372250828.git.sbehrens@giantdisaster.de>
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
 fs/btrfs/ctree.h     |  30 ++++++
 fs/btrfs/uuid-tree.c | 281 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 313 insertions(+), 1 deletion(-)

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
index 76e4983..ef7aa16 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -91,6 +91,9 @@ struct btrfs_ordered_sum;
 /* holds quota configuration and tracking */
 #define BTRFS_QUOTA_TREE_OBJECTID 8ULL
 
+/* for storing items that use the BTRFS_UUID_KEY* types */
+#define BTRFS_UUID_TREE_OBJECTID 9ULL
+
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
@@ -1922,6 +1925,19 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_DEV_REPLACE_KEY	250
 
 /*
+ * Stores items that allow to quickly map UUIDs to something else.
+ * These items are part of the filesystem UUID tree.
+ * The key is built like this:
+ * (UUID_upper_64_bits, BTRFS_UUID_KEY*, UUID_lower_64_bits).
+ */
+#if BTRFS_UUID_SIZE != 16
+#error "UUID items require BTRFS_UUID_SIZE == 16!"
+#endif
+#define BTRFS_UUID_KEY_SUBVOL	251	/* for UUIDs assigned to subvols */
+#define BTRFS_UUID_KEY_RECEIVED_SUBVOL	252	/* for UUIDs assigned to
+						 * received subvols */
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
@@ -3414,6 +3430,20 @@ void btrfs_check_and_init_root_item(struct btrfs_root_item *item);
 void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
 
+/* uuid-tree.c */
+int btrfs_insert_uuid_subvol_item(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *uuid_root, u8 *uuid,
+				  u64 subvol_id);
+int btrfs_del_uuid_subvol_item(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *uuid_root, u8 *uuid,
+			       u64 subvol_id);
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
index 0000000..94bf8b1
--- /dev/null
+++ b/fs/btrfs/uuid-tree.c
@@ -0,0 +1,281 @@
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
+#include <asm/unaligned.h>
+#include "ctree.h"
+#include "transaction.h"
+#include "disk-io.h"
+#include "print-tree.h"
+
+
+static void btrfs_uuid_to_key(u8 *uuid, u8 type, struct btrfs_key *key)
+{
+	key->type = type;
+	key->objectid = get_unaligned_le64(uuid);
+	key->offset = get_unaligned_le64(uuid + sizeof(u64));
+}
+
+/* return -ENOENT for !found, < 0 for errors, or 0 if an item was found */
+static int btrfs_uuid_tree_lookup(struct btrfs_root *uuid_root, u8 *uuid,
+				  u8 type, u64 subid)
+{
+	int ret;
+	struct btrfs_path *path = NULL;
+	struct extent_buffer *eb;
+	int slot;
+	u32 item_size;
+	unsigned long offset;
+	struct btrfs_key key;
+
+	if (!uuid_root) {
+		WARN_ON_ONCE(1);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	btrfs_uuid_to_key(uuid, type, &key);
+	ret = btrfs_search_slot(NULL, uuid_root, &key, path, 0, 0);
+	if (ret < 0) {
+		goto out;
+	} else if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	eb = path->nodes[0];
+	slot = path->slots[0];
+	item_size = btrfs_item_size_nr(eb, slot);
+	offset = btrfs_item_ptr_offset(eb, slot);
+	ret = -ENOENT;
+
+	if (!IS_ALIGNED(item_size, sizeof(u64))) {
+		pr_warn("btrfs: uuid item with illegal size %lu!\n",
+			(unsigned long)item_size);
+		goto out;
+	}
+	while (item_size) {
+		u64 data;
+
+		read_extent_buffer(eb, &data, offset, sizeof(data));
+		data = le64_to_cpu(data);
+		if (data == subid) {
+			ret = 0;
+			break;
+		}
+		offset += sizeof(data);
+		item_size -= sizeof(data);
+	}
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+/* it is not checked whether the entry to add already exists */
+static int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *uuid_root, u8 *uuid,
+			       u8 type, u64 subid)
+{
+	int ret;
+	struct btrfs_path *path = NULL;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	int slot;
+	unsigned long offset;
+
+	if (!uuid_root) {
+		WARN_ON_ONCE(1);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	btrfs_uuid_to_key(uuid, type, &key);
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = btrfs_insert_empty_item(trans, uuid_root, path, &key,
+				      sizeof(subid));
+	if (ret >= 0) {
+		/* Add an item for the type for the first time */
+		eb = path->nodes[0];
+		slot = path->slots[0];
+		offset = btrfs_item_ptr_offset(eb, slot);
+	} else if (ret == -EEXIST) {
+		/*
+		 * An item with that type already exists.
+		 * Extend the item and store the new subid at the end.
+		 */
+		btrfs_extend_item(uuid_root, path, sizeof(subid));
+		eb = path->nodes[0];
+		slot = path->slots[0];
+		offset = btrfs_item_ptr_offset(eb, slot);
+		offset += btrfs_item_size_nr(eb, slot) - sizeof(subid);
+	} else if (ret < 0) {
+		pr_warn("btrfs: insert uuid item failed %d (0x%016llx, 0x%016llx) type %u!\n",
+			ret, (unsigned long long)key.objectid,
+			(unsigned long long)key.offset, type);
+		goto out;
+	}
+
+	ret = 0;
+	subid = cpu_to_le64(subid);
+	write_extent_buffer(eb, &subid, offset, sizeof(subid));
+	btrfs_mark_buffer_dirty(eb);
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *uuid_root, u8 *uuid, u8 type,
+			       u64 subid)
+{
+	int ret;
+	struct btrfs_path *path = NULL;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	int slot;
+	unsigned long offset;
+	u32 item_size;
+	unsigned long move_dst;
+	unsigned long move_src;
+	unsigned long move_len;
+
+	if (!uuid_root) {
+		WARN_ON_ONCE(1);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	btrfs_uuid_to_key(uuid, type, &key);
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
+	eb = path->nodes[0];
+	slot = path->slots[0];
+	offset = btrfs_item_ptr_offset(eb, slot);
+	item_size = btrfs_item_size_nr(eb, slot);
+	if (!IS_ALIGNED(item_size, sizeof(u64))) {
+		pr_warn("btrfs: uuid item with illegal size %lu!\n",
+			(unsigned long)item_size);
+		ret = -ENOENT;
+		goto out;
+	}
+	while (item_size) {
+		u64 read_subid;
+
+		read_extent_buffer(eb, &read_subid, offset, sizeof(read_subid));
+		read_subid = le64_to_cpu(read_subid);
+		if (read_subid == subid)
+			break;
+		offset += sizeof(read_subid);
+		item_size -= sizeof(read_subid);
+	}
+
+	if (!item_size) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	item_size = btrfs_item_size_nr(eb, slot);
+	if (item_size == sizeof(subid)) {
+		ret = btrfs_del_item(trans, uuid_root, path);
+		goto out;
+	}
+
+	move_dst = offset;
+	move_src = offset + sizeof(subid);
+	move_len = item_size - (move_src - btrfs_item_ptr_offset(eb, slot));
+	memmove_extent_buffer(eb, move_dst, move_src, move_len);
+	btrfs_truncate_item(uuid_root, path, item_size - sizeof(subid), 1);
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+int btrfs_insert_uuid_subvol_item(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *uuid_root, u8 *uuid,
+				  u64 subvol_id)
+{
+	int ret;
+
+	ret = btrfs_uuid_tree_lookup(uuid_root, uuid,
+				     BTRFS_UUID_KEY_SUBVOL, subvol_id);
+	if (ret == -ENOENT)
+		ret = btrfs_uuid_tree_add(trans, uuid_root, uuid,
+					  BTRFS_UUID_KEY_SUBVOL, subvol_id);
+	return ret;
+}
+
+int btrfs_del_uuid_subvol_item(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *uuid_root, u8 *uuid,
+			       u64 subvol_id)
+{
+	return btrfs_uuid_tree_rem(trans, uuid_root, uuid,
+				   BTRFS_UUID_KEY_SUBVOL, subvol_id);
+}
+
+int btrfs_insert_uuid_received_subvol_item(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *uuid_root,
+					   u8 *uuid, u64 subvol_id)
+{
+	int ret;
+
+	ret = btrfs_uuid_tree_lookup(uuid_root, uuid,
+				     BTRFS_UUID_KEY_RECEIVED_SUBVOL, subvol_id);
+	if (ret == -ENOENT)
+		ret = btrfs_uuid_tree_add(trans, uuid_root, uuid,
+					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
+					  subvol_id);
+	return ret;
+}
+
+int btrfs_del_uuid_received_subvol_item(struct btrfs_trans_handle *trans,
+					struct btrfs_root *uuid_root, u8 *uuid,
+					u64 subvol_id)
+{
+	return btrfs_uuid_tree_rem(trans, uuid_root, uuid,
+				   BTRFS_UUID_KEY_RECEIVED_SUBVOL, subvol_id);
+}
-- 
1.8.3

