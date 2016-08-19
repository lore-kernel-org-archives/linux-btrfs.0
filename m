Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28015 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753844AbcHSIOa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 04:14:30 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id F0C1942BC534
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 16:13:17 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4] btrfs-progs: print-tree: Print human readable inode flags
Date: Fri, 19 Aug 2016 16:13:07 +0800
Message-ID: <20160819081308.21348-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
References: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 9f9e11e..f33ddad 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -835,6 +835,33 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
 	}
 }
 
+/* Caller should ensure sizeof(*ret) >= 29 "NODATASUM|NODATACOW|READONLY" */
+static void inode_flags_to_str(u64 flags, char *ret)
+{
+	int empty = 1;
+
+	if (flags & BTRFS_INODE_NODATASUM) {
+		empty = 0;
+		strcpy(ret, "NODATASUM");
+	}
+	if (flags & BTRFS_INODE_NODATACOW) {
+		if (!empty) {
+			empty = 0;
+			strcat(ret, "|");
+		}
+		strcat(ret, "NODATACOW");
+	}
+	if (flags & BTRFS_INODE_READONLY) {
+		if (!empty) {
+			empty = 0;
+			strcat(ret, "|");
+		}
+		strcat(ret, "READONLY");
+	}
+	if (empty)
+		strcat(ret, "none");
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -884,10 +911,12 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 
 		switch (type) {
 		case BTRFS_INODE_ITEM_KEY:
+			memset(flags_str, 0, sizeof(flags_str));
 			ii = btrfs_item_ptr(l, i, struct btrfs_inode_item);
+			inode_flags_to_str(btrfs_inode_flags(l, ii), flags_str);
 			printf("\t\tinode generation %llu transid %llu size %llu nbytes %llu\n"
 			       "\t\tblock group %llu mode %o links %u uid %u gid %u\n"
-			       "\t\trdev %llu flags 0x%llx\n",
+			       "\t\trdev %llu flags 0x%llx(%s)\n",
 			       (unsigned long long)btrfs_inode_generation(l, ii),
 			       (unsigned long long)btrfs_inode_transid(l, ii),
 			       (unsigned long long)btrfs_inode_size(l, ii),
@@ -898,7 +927,8 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       btrfs_inode_uid(l, ii),
 			       btrfs_inode_gid(l, ii),
 			       (unsigned long long)btrfs_inode_rdev(l,ii),
-			       (unsigned long long)btrfs_inode_flags(l,ii));
+			       (unsigned long long)btrfs_inode_flags(l,ii),
+			       flags_str);
 			break;
 		case BTRFS_INODE_REF_KEY:
 			iref = btrfs_item_ptr(l, i, struct btrfs_inode_ref);
-- 
2.9.3



