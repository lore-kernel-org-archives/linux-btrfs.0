Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:57385 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab3FZPSB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 11:18:01 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp3) (RZmta 31.28 OK)
	with ESMTP id p031a8p5PKS1cP for <linux-btrfs@vger.kernel.org>;
	Wed, 26 Jun 2013 17:17:59 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 2/5] Btrfs-progs: add UUID tree lookup methods
Date: Wed, 26 Jun 2013 17:17:56 +0200
Message-Id: <95ac526992b0bff417a0dff9aa7f6624a560e714.1372252739.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372252739.git.sbehrens@giantdisaster.de>
References: <cover.1372252739.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372252739.git.sbehrens@giantdisaster.de>
References: <cover.1372252739.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit adds UUID tree lookup methods that make use of the search
ioctl. The code is based on the kernel code.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 Makefile    |   5 +--
 ctree.h     |   5 +++
 uuid-tree.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 398ef52..511ba6d 100644
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
index f959573..e4bca8f 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2346,4 +2346,9 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
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
index 0000000..3a4c48e
--- /dev/null
+++ b/uuid-tree.c
@@ -0,0 +1,104 @@
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
+static void btrfs_uuid_to_key(const u8 *uuid, u64 *key_objectid,
+			      u64 *key_offset)
+{
+	*key_objectid = get_unaligned_le64(uuid);
+	*key_offset = get_unaligned_le64(uuid + sizeof(u64));
+}
+
+
+/* return -ENOENT for !found, < 0 for errors, or 0 if an item was found */
+static int btrfs_uuid_tree_lookup_any(int fd, const u8 *uuid, u8 type,
+				      u64 *subid)
+{
+	int ret;
+	u64 key_objectid = 0;
+	u64 key_offset;
+	struct btrfs_ioctl_search_args search_arg;
+	struct btrfs_ioctl_search_header *search_header;
+	u32 item_size;
+
+	btrfs_uuid_to_key(uuid, &key_objectid, &key_offset);
+
+	memset(&search_arg, 0, sizeof(search_arg));
+	search_arg.key.tree_id = BTRFS_UUID_TREE_OBJECTID;
+	search_arg.key.min_objectid = key_objectid;
+	search_arg.key.max_objectid = key_objectid;
+	search_arg.key.min_type = type;
+	search_arg.key.max_type = type;
+	search_arg.key.min_offset = key_offset;
+	search_arg.key.max_offset = key_offset;
+	search_arg.key.max_transid = (u64)-1;
+	search_arg.key.nr_items = 1;
+	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search_arg);
+	if (ret < 0) {
+		fprintf(stderr,
+			"ioctl(BTRFS_IOC_TREE_SEARCH, uuid, key %016llx, UUID_KEY, %016llx) ret=%d, error: %s\n",
+			(unsigned long long)key_objectid,
+			(unsigned long long)key_offset, ret, strerror(errno));
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (search_arg.key.nr_items < 1) {
+		ret = -ENOENT;
+		goto out;
+	}
+	search_header = (struct btrfs_ioctl_search_header *)(search_arg.buf);
+	item_size = search_header->len;
+	if ((item_size & (sizeof(u64) - 1)) || item_size == 0) {
+		printf("btrfs: uuid item with illegal size %lu!\n",
+		       (unsigned long)item_size);
+		ret = -ENOENT;
+		goto out;
+	} else {
+		ret = 0;
+	}
+
+	/* return first stored id */
+	memcpy(subid, search_header + 1, sizeof(*subid));
+	*subid = le64_to_cpu(*subid);
+
+out:
+	return ret;
+}
+
+int btrfs_lookup_uuid_subvol_item(int fd, const u8 *uuid, u64 *subvol_id)
+{
+	return btrfs_uuid_tree_lookup_any(fd, uuid, BTRFS_UUID_KEY_SUBVOL,
+					  subvol_id);
+}
+
+int btrfs_lookup_uuid_received_subvol_item(int fd, const u8 *uuid,
+					   u64 *subvol_id)
+{
+	return btrfs_uuid_tree_lookup_any(fd, uuid,
+					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
+					  subvol_id);
+}
-- 
1.8.3

