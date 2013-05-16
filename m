Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:25525 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab3EPOp7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 10:45:59 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp1) (RZmta 31.27 OK)
	with ESMTP id X07dfap4G8bU4v for <linux-btrfs@vger.kernel.org>;
	Thu, 16 May 2013 16:45:58 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/4] Btrfs-progs: add UUID tree lookup methods
Date: Thu, 16 May 2013 16:45:56 +0200
Message-Id: <850b602748927f8f79e5ed5d3ad8712838757ce1.1368713962.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368713962.git.sbehrens@giantdisaster.de>
References: <cover.1368713962.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368713962.git.sbehrens@giantdisaster.de>
References: <cover.1368713962.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit adds UUID tree lookup methods that make use of the search
ioctl. The code is based on the kernel code.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 Makefile    |   5 +-
 ctree.h     |   5 ++
 uuid-tree.c | 174 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 182 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 7d4faba..66eefb7 100644
--- a/Makefile
+++ b/Makefile
@@ -6,12 +6,13 @@ CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid6.o free-space-cache.o
+	  qgroup.o raid6.o free-space-cache.o uuid-tree.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o
-libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
+libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
+		   uuid-tree.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
 	       extent_io.h ioctl.h ctree.h
diff --git a/ctree.h b/ctree.h
index 0f14b41..e36cb17 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2355,4 +2355,9 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct btrfs_path *path,
 			u64 isize);
+
+/* uuid-tree.c */
+int btrfs_lookup_uuid_subvol_item(int fd, const u8 *uuid, u64 *subvol_id);
+int btrfs_lookup_uuid_received_subvol_item(int fd, const u8 *uuid,
+					   u64 *subvol_id);
 #endif
diff --git a/uuid-tree.c b/uuid-tree.c
new file mode 100644
index 0000000..fcd270e
--- /dev/null
+++ b/uuid-tree.c
@@ -0,0 +1,174 @@
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <uuid/uuid.h>
+#include <sys/ioctl.h>
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
+static void btrfs_uuid_to_key(const u8 *uuid, u64 *key_objectid,
+			      u64 *key_offset)
+{
+	*key_objectid = get_unaligned_le64(uuid);
+	*key_offset = get_unaligned_le64(uuid + sizeof(u64));
+}
+
+static struct btrfs_uuid_item *btrfs_match_uuid_item_type(
+		struct btrfs_uuid_item *ptr, u32 item_size, u16 type)
+{
+	do {
+		u16 sub_item_type;
+		u64 sub_item_len;
+
+		if (item_size < sizeof(*ptr)) {
+			fprintf(stderr,
+				"btrfs: uuid item too short (%lu < %d)!\n",
+				(unsigned long)item_size, (int)sizeof(*ptr));
+			return NULL;
+		}
+		item_size -= sizeof(*ptr);
+		sub_item_type = btrfs_stack_uuid_type(ptr);
+		sub_item_len = btrfs_stack_uuid_len(ptr);
+		if (sub_item_len * sizeof(u64) > item_size) {
+			fprintf(stderr,
+				"btrfs: uuid item too short (%llu > %lu)!\n",
+				(unsigned long long)
+				 (sub_item_len * sizeof(u64)),
+				(unsigned long)item_size);
+			return NULL;
+		}
+		if (sub_item_type == type)
+			return ptr;
+		item_size -= sub_item_len * sizeof(u64);
+		ptr = 1 + (struct btrfs_uuid_item *)
+			(((char *)ptr) + (sub_item_len * sizeof(u64)));
+	} while (item_size);
+
+	return NULL;
+}
+
+static int btrfs_uuid_tree_lookup_prepare(int fd, const u8 *uuid, u16 type,
+					  struct btrfs_ioctl_search_args
+					   *search_arg,
+					  struct btrfs_uuid_item **ptr)
+{
+	int ret;
+	u64 key_objectid = 0;
+	u64 key_offset;
+	struct btrfs_uuid_item *uuid_item;
+	struct btrfs_ioctl_search_header *search_header;
+	u32 item_size;
+
+	btrfs_uuid_to_key(uuid, &key_objectid, &key_offset);
+
+	memset(search_arg, 0, sizeof(*search_arg));
+	search_arg->key.tree_id = BTRFS_UUID_TREE_OBJECTID;
+	search_arg->key.min_objectid = key_objectid;
+	search_arg->key.max_objectid = key_objectid;
+	search_arg->key.min_type = BTRFS_UUID_KEY;
+	search_arg->key.max_type = BTRFS_UUID_KEY;
+	search_arg->key.min_offset = key_offset;
+	search_arg->key.max_offset = key_offset;
+	search_arg->key.max_transid = (u64)-1;
+	search_arg->key.nr_items = 1;
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, search_arg);
+	if (ret < 0) {
+		fprintf(stderr,
+			"ioctl(BTRFS_IOC_TREE_SEARCH, uuid, key %016llx, UUID_KEY, %016llx) ret=%d, error: %s\n",
+			(unsigned long long)key_objectid,
+			(unsigned long long)key_offset, ret, strerror(errno));
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (search_arg->key.nr_items < 1) {
+		ret = -ENOENT;
+		goto out;
+	}
+	search_header = (struct btrfs_ioctl_search_header *)(search_arg->buf);
+	uuid_item = (struct btrfs_uuid_item *)(search_header + 1);
+	item_size = search_header->len;
+
+	*ptr = btrfs_match_uuid_item_type(uuid_item, item_size, type);
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
+static int btrfs_uuid_tree_lookup_any(int fd, const u8 *uuid, u16 type,
+				      u64 *subid)
+{
+	int ret;
+	struct btrfs_ioctl_search_args search_arg;
+	struct btrfs_uuid_item *ptr;
+	u32 sub_item_len;
+
+	ret = btrfs_uuid_tree_lookup_prepare(fd, uuid, type, &search_arg, &ptr);
+	if (ret)
+		goto out;
+
+	sub_item_len = btrfs_stack_uuid_len(ptr);
+	if (sub_item_len > 0) {
+		/* return first stored id */
+		memcpy(subid, ptr + 1, sizeof(*subid));
+		*subid = le64_to_cpu(*subid);
+	} else {
+		ret = -ENOENT;
+	}
+
+out:
+	return ret;
+}
+
+int btrfs_lookup_uuid_subvol_item(int fd, const u8 *uuid, u64 *subvol_id)
+{
+	return btrfs_uuid_tree_lookup_any(fd, uuid, BTRFS_UUID_ITEM_TYPE_SUBVOL,
+					  subvol_id);
+}
+
+int btrfs_lookup_uuid_received_subvol_item(int fd, const u8 *uuid,
+					   u64 *subvol_id)
+{
+	return btrfs_uuid_tree_lookup_any(fd, uuid,
+					  BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL,
+					  subvol_id);
+}
-- 
1.8.2.3

