Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36159 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755235AbbB0I0l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:26:41 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8Pmo7019918
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:25:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/7] btrfs-progs: Allow btrfs-debug-tree to print human readable qgroup status flag.
Date: Fri, 27 Feb 2015 16:26:34 +0800
Message-ID: <1425025599-30048-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now btrfs-debug-tree can print qgroup status flag as ON|INCONSISTENT
instead of 0x5.

BTW, this patch helped us to find a bug that INCONSISTENT flag is never
cleared in kernel.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 30adc1a..41891fc 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -203,6 +203,20 @@ static void bg_flags_to_str(u64 flags, char *ret)
 	}
 }
 
+/* Caller should ensure sizeof(*ret)>= 26 "OFF|SCANNING|INCONSISTENT" */
+static void qg_flags_to_str(u64 flags, char *ret)
+{
+	if (flags & BTRFS_QGROUP_STATUS_FLAG_ON)
+		strcpy(ret, "ON");
+	else
+		strcpy(ret, "OFF");
+
+	if (flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN)
+		strcat(ret, "|SCANNING");
+	if (flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT)
+		strcat(ret, "|INCONSISTENT");
+}
+
 void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
@@ -801,7 +815,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	u32 nr = btrfs_header_nritems(l);
 	u64 objectid;
 	u32 type;
-	char bg_flags_str[32];
+	char flags_str[32];
 
 	printf("leaf %llu items %d free space %d generation %llu owner %llu\n",
 		(unsigned long long)btrfs_header_bytenr(l), nr,
@@ -920,13 +934,13 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 					    struct btrfs_block_group_item);
 			read_extent_buffer(l, &bg_item, (unsigned long)bi,
 					   sizeof(bg_item));
-			memset(bg_flags_str, 0, sizeof(bg_flags_str));
+			memset(flags_str, 0, sizeof(flags_str));
 			bg_flags_to_str(btrfs_block_group_flags(&bg_item),
-					bg_flags_str);
+					flags_str);
 			printf("\t\tblock group used %llu chunk_objectid %llu flags %s\n",
 			       (unsigned long long)btrfs_block_group_used(&bg_item),
 			       (unsigned long long)btrfs_block_group_chunk_objectid(&bg_item),
-			       bg_flags_str);
+			       flags_str);
 			break;
 		case BTRFS_CHUNK_ITEM_KEY:
 			print_chunk(l, btrfs_item_ptr(l, i, struct btrfs_chunk));
@@ -953,14 +967,16 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_QGROUP_STATUS_KEY:
 			qg_status = btrfs_item_ptr(l, i,
 					struct btrfs_qgroup_status_item);
-			printf("\t\tversion %llu generation %llu flags %#llx "
+			memset(flags_str, 0, sizeof(flags_str));
+			qg_flags_to_str(btrfs_qgroup_status_flags(l, qg_status),
+					flags_str);
+			printf("\t\tversion %llu generation %llu flags %s "
 				"scan %lld\n",
 				(unsigned long long)
 				btrfs_qgroup_status_version(l, qg_status),
 				(unsigned long long)
 				btrfs_qgroup_status_generation(l, qg_status),
-				(unsigned long long)
-				btrfs_qgroup_status_flags(l, qg_status),
+				flags_str,
 				(unsigned long long)
 				btrfs_qgroup_status_scan(l, qg_status));
 			break;
-- 
2.3.0

