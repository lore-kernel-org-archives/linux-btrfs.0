Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17031 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753873AbcHSIOb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 04:14:31 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id AA41742BC535
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 16:13:18 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4] btrfs-progs: print-tree: Print hex and human readable root flags
Date: Fri, 19 Aug 2016 16:13:08 +0800
Message-ID: <20160819081308.21348-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
References: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/print-tree.c b/print-tree.c
index f33ddad..81ab81f 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -496,18 +496,31 @@ static int count_bytes(void *buf, int len, char b)
 	return cnt;
 }
 
+/*
+ * Caller must ensure sizeof(*ret) >= 7 "RDONLY"
+ */
+static void root_flags_to_str(u64 flags, char *ret)
+{
+	if (flags & BTRFS_ROOT_SUBVOL_RDONLY)
+		strcat(ret, "RDONLY");
+	else
+		strcat(ret, "none");
+}
+
 static void print_root(struct extent_buffer *leaf, int slot)
 {
 	struct btrfs_root_item *ri;
 	struct btrfs_root_item root_item;
 	int len;
 	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
+	char flags_str[32] = {0};
 
 	ri = btrfs_item_ptr(leaf, slot, struct btrfs_root_item);
 	len = btrfs_item_size_nr(leaf, slot);
 
 	memset(&root_item, 0, sizeof(root_item));
 	read_extent_buffer(leaf, &root_item, (unsigned long)ri, len);
+	root_flags_to_str(btrfs_root_flags(&root_item), flags_str);
 
 	printf("\t\troot data bytenr %llu level %d dirid %llu refs %u gen %llu lastsnap %llu\n",
 		(unsigned long long)btrfs_root_bytenr(&root_item),
@@ -516,6 +529,8 @@ static void print_root(struct extent_buffer *leaf, int slot)
 		btrfs_root_refs(&root_item),
 		(unsigned long long)btrfs_root_generation(&root_item),
 		(unsigned long long)btrfs_root_last_snapshot(&root_item));
+	printf("\t\tflags 0x%llx(%s)\n", btrfs_root_flags(&root_item),
+	       flags_str);
 
 	if (root_item.generation == root_item.generation_v2) {
 		uuid_unparse(root_item.uuid, uuid_str);
-- 
2.9.3



