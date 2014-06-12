Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58509 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932111AbaFLHLf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 03:11:35 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5C7BS3j007982
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 15:11:28 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/2] btrfs-progs: Add human readable flags output string for extent flags.
Date: Thu, 12 Jun 2014 15:12:31 +0800
Message-ID: <1402557152-5495-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfs-debug-tree outputs extent flags as numbers,
which makes it hard to understand and need to check the source to
understand the meaning.

This patch will convert numberic flags output to human readable strings.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changlog:
v2: none
---
 print-tree.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 7263b09..7f831ad 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -242,6 +242,25 @@ static void print_file_extent_item(struct extent_buffer *eb,
 	       btrfs_file_extent_compression(eb, fi));
 }
 
+/* Caller should ensure sizeof(*ret) >= 16("DATA|TREE_BLOCK") */
+static void extent_flags_to_str(u64 flags, char *ret)
+{
+	int empty = 1;
+
+	if (flags & BTRFS_EXTENT_FLAG_DATA) {
+		empty = 0;
+		strcpy(ret, "DATA");
+	}
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+		if (!empty) {
+			empty = 0;
+			strcat(ret, "|");
+		}
+		strcat(ret, "TREE_BLOCK");
+	}
+	return;
+}
+
 static void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 {
 	struct btrfs_extent_item *ei;
@@ -255,6 +274,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	u64 flags;
 	u64 offset;
+	char flags_str[32] = {0};
 
 	if (item_size < sizeof(*ei)) {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
@@ -271,11 +291,12 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 
 	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
 	flags = btrfs_extent_flags(eb, ei);
+	extent_flags_to_str(flags, flags_str);
 
-	printf("\t\textent refs %llu gen %llu flags %llu\n",
+	printf("\t\textent refs %llu gen %llu flags %s\n",
 	       (unsigned long long)btrfs_extent_refs(eb, ei),
 	       (unsigned long long)btrfs_extent_generation(eb, ei),
-	       (unsigned long long)flags);
+	       flags_str);
 
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK && !metadata) {
 		struct btrfs_tree_block_info *info;
-- 
2.0.0

