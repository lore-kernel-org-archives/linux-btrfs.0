Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34403 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751982AbdEHHiP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 03:38:15 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: print-tree: Add leaf flags and backref revision output
Date: Mon, 8 May 2017 15:38:10 +0800
Message-ID: <20170508073810.2811-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs header has a u64 member flags, whose lowest 56 bits are for header
flags like WRITTEN and RELOC.
And its highest 8 bits are for backref revision.

Manually checking btrfs_header_flags() will be a pain, so add such leaf
flags and backref revision output for print-tree.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/print-tree.c b/print-tree.c
index 5af80e87..823b87c1 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -938,13 +938,35 @@ static void print_dev_stats(struct extent_buffer *eb,
 	}
 }
 
+/* Caller must ensure sizeof(*ret) >= 14 "WRITTEN|RELOC" */
+static void header_flags_to_str(u64 flags, char *ret)
+{
+	int empty = 1;
+
+	if (flags & BTRFS_HEADER_FLAG_WRITTEN) {
+		empty = 0;
+		strcpy(ret, "WRITTEN");
+	}
+	if (flags & BTRFS_HEADER_FLAG_RELOC) {
+		if (!empty)
+			strcat(ret, "|");
+		strcat(ret, "RELOC");
+	}
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 {
 	struct btrfs_item *item;
 	struct btrfs_disk_key disk_key;
+	char flags_str[128];
 	u32 i;
 	u32 nr;
+	u64 flags;
+	u8 backref_rev;
 
+	flags = btrfs_header_flags(eb) & ~BTRFS_BACKREF_REV_MASK;
+	backref_rev = btrfs_header_flags(eb) >> BTRFS_BACKREF_REV_SHIFT;
+	header_flags_to_str(flags, flags_str);
 	nr = btrfs_header_nritems(eb);
 
 	printf("leaf %llu items %d free space %d generation %llu owner %llu\n",
@@ -952,6 +974,8 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 		btrfs_leaf_free_space(root, eb),
 		(unsigned long long)btrfs_header_generation(eb),
 		(unsigned long long)btrfs_header_owner(eb));
+	printf("leaf %llu flags 0x%llx(%s) backref revision %d\n",
+		btrfs_header_bytenr(eb), flags, flags_str, backref_rev);
 	print_uuids(eb);
 	fflush(stdout);
 
-- 
2.12.2



