Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24620 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751573AbcI1IaO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 04:30:14 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2] btrfs-progs: raid56: Add support for raid5 to calculate any stripe
Date: Wed, 28 Sep 2016 16:30:03 +0800
Message-Id: <20160928083004.17860-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a new function raid5_gen_result() to calculate raid5 parity or
recover data stripe.

Since now that raid6.c handles both raid5 and raid6, rename it to
raid56.c.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile.in         |  2 +-
 disk-io.h           |  3 ++-
 raid6.c => raid56.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 volumes.c           | 36 +++++++++++++++---------------------
 4 files changed, 63 insertions(+), 23 deletions(-)
 rename raid6.c => raid56.c (71%)

diff --git a/Makefile.in b/Makefile.in
index 20b740a..0ae2cd5 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -90,7 +90,7 @@ CHECKER_FLAGS := -include $(check_defs) -D__CHECKER__ \
 objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid6.o free-space-cache.o kernel-lib/list_sort.o props.o \
+	  qgroup.o raid56.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
diff --git a/disk-io.h b/disk-io.h
index 1080fc1..9fc7e92 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -190,7 +190,8 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 int write_and_map_eb(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		     struct extent_buffer *eb);
 
-/* raid6.c */
+/* raid56.c */
 void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
+int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);
 
 #endif
diff --git a/raid6.c b/raid56.c
similarity index 71%
rename from raid6.c
rename to raid56.c
index 833df5f..2953d61 100644
--- a/raid6.c
+++ b/raid56.c
@@ -26,6 +26,7 @@
 #include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"
+#include "utils.h"
 
 /*
  * This is the C data type to use
@@ -107,3 +108,47 @@ void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 }
 
+static void xor_range(void *src, void *dst, size_t size)
+{
+	while (size) {
+		*(unsigned long *) dst ^= *(unsigned long *) src;
+		src += sizeof(unsigned long);
+		dst += sizeof(unsigned long);
+		size -= sizeof(unsigned long);
+	}
+}
+
+/*
+ * Generate desired data/parity for RAID5
+ *
+ * @nr_devs:	Total number of devices, including parity
+ * @stripe_len:	Stripe length
+ * @data:	Data, with special layout:
+ * 		data[0]:	 Data stripe 0
+ * 		data[nr_devs-2]: Last data stripe
+ * 		data[nr_devs-1]: RAID5 parity
+ * @dest:	To generate which data. should follow above data layout
+ */
+int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data)
+{
+	int i;
+	char *buf = data[dest];
+
+	if (dest >= nr_devs || nr_devs < 2) {
+		error("invalid parameter for %s", __func__);
+		return -EINVAL;
+	}
+	/* Quich hack, 2 devs RAID5 is just RAID1, no need to calculate */
+	if (nr_devs == 2) {
+		memcpy(data[dest], data[1 - dest], stripe_len);
+		return 0;
+	}
+	/* Just in case */
+	memset(buf, 0, stripe_len);
+	for (i = 0; i < nr_devs; i++) {
+		if (i == dest)
+			continue;
+		xor_range(data[i], buf, stripe_len);
+	}
+	return 0;
+}
diff --git a/volumes.c b/volumes.c
index da79751..718e67c 100644
--- a/volumes.c
+++ b/volumes.c
@@ -2108,12 +2108,14 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 {
 	struct extent_buffer **ebs, *p_eb = NULL, *q_eb = NULL;
 	int i;
-	int j;
 	int ret;
 	int alloc_size = eb->len;
+	void **pointers;
 
-	ebs = kmalloc(sizeof(*ebs) * multi->num_stripes, GFP_NOFS);
-	BUG_ON(!ebs);
+	ebs = malloc(sizeof(*ebs) * multi->num_stripes);
+	pointers = malloc(sizeof(void *) * multi->num_stripes);
+	if (!ebs || !pointers)
+		return -ENOMEM;
 
 	if (stripe_len > alloc_size)
 		alloc_size = stripe_len;
@@ -2143,12 +2145,6 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			q_eb = new_eb;
 	}
 	if (q_eb) {
-		void **pointers;
-
-		pointers = kmalloc(sizeof(*pointers) * multi->num_stripes,
-				   GFP_NOFS);
-		BUG_ON(!pointers);
-
 		ebs[multi->num_stripes - 2] = p_eb;
 		ebs[multi->num_stripes - 1] = q_eb;
 
@@ -2159,17 +2155,14 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 		kfree(pointers);
 	} else {
 		ebs[multi->num_stripes - 1] = p_eb;
-		memcpy(p_eb->data, ebs[0]->data, stripe_len);
-		for (j = 1; j < multi->num_stripes - 1; j++) {
-			for (i = 0; i < stripe_len; i += sizeof(u64)) {
-				u64 p_eb_data;
-				u64 ebs_data;
-
-				p_eb_data = get_unaligned_64(p_eb->data + i);
-				ebs_data = get_unaligned_64(ebs[j]->data + i);
-				p_eb_data ^= ebs_data;
-				put_unaligned_64(p_eb_data, p_eb->data + i);
-			}
+		for (i = 0; i < multi->num_stripes; i++)
+			pointers[i] = ebs[i]->data;
+		ret = raid5_gen_result(multi->num_stripes, stripe_len,
+				multi->num_stripes - 1, pointers);
+		if (ret < 0) {
+			free(ebs);
+			free(pointers);
+			return ret;
 		}
 	}
 
@@ -2180,7 +2173,8 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			kfree(ebs[i]);
 	}
 
-	kfree(ebs);
+	free(ebs);
+	free(pointers);
 
 	return 0;
 }
-- 
2.10.0



