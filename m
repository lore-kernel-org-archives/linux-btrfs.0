Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58509 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932128AbaFLHLg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 03:11:36 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5C7BTRW007986
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 15:11:29 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/2] btrfs-progs: Add human readable flags output for chunk/block group type.
Date: Thu, 12 Jun 2014 15:12:32 +0800
Message-ID: <1402557152-5495-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1402557152-5495-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1402557152-5495-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfs-debug-tree output chunk/block group type as numbers,
which makes it hard to understand and need to check the source to
understand the meaning.

This patch will convert numberic type output to human readable strings.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changlog:
v2: allow mixed chunk.
---
 print-tree.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 54 insertions(+), 5 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 7f831ad..6cf59ca 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -160,15 +160,60 @@ static int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *ite
 	return 0;
 }
 
+/* Caller should ensure sizeof(*ret)>=21 "DATA|METADATA|RAID10" */
+static void bg_flags_to_str(u64 flags, char *ret)
+{
+	int empty = 1;
+
+	if (flags & BTRFS_BLOCK_GROUP_DATA) {
+		empty = 0;
+		strcpy(ret, "DATA");
+	}
+	if (flags & BTRFS_BLOCK_GROUP_METADATA) {
+		if (!empty)
+			strcat(ret, "|");
+		strcat(ret, "METADATA");
+	}
+	if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+		if (!empty)
+			strcat(ret, "|");
+		strcat(ret, "SYSTEM");
+	}
+	switch (flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	case BTRFS_BLOCK_GROUP_RAID0:
+		strcat(ret, "|RAID0");
+		break;
+	case BTRFS_BLOCK_GROUP_RAID1:
+		strcat(ret, "|RAID1");
+		break;
+	case BTRFS_BLOCK_GROUP_DUP:
+		strcat(ret, "|DUP");
+		break;
+	case BTRFS_BLOCK_GROUP_RAID10:
+		strcat(ret, "|RAID10");
+		break;
+	case BTRFS_BLOCK_GROUP_RAID5:
+		strcat(ret, "|RAID5");
+		break;
+	case BTRFS_BLOCK_GROUP_RAID6:
+		strcat(ret, "|RAID6");
+		break;
+	default:
+		break;
+	}
+}
+
 static void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
-	printf("\t\tchunk length %llu owner %llu type %llu num_stripes %d\n",
+	char chunk_flags_str[32] = {0};
+
+	bg_flags_to_str(btrfs_chunk_type(eb, chunk), chunk_flags_str);
+	printf("\t\tchunk length %llu owner %llu type %s num_stripes %d\n",
 	       (unsigned long long)btrfs_chunk_length(eb, chunk),
 	       (unsigned long long)btrfs_chunk_owner(eb, chunk),
-	       (unsigned long long)btrfs_chunk_type(eb, chunk),
-	       num_stripes);
+	       chunk_flags_str, num_stripes);
 	for (i = 0 ; i < num_stripes ; i++) {
 		printf("\t\t\tstripe %d devid %llu offset %llu\n", i,
 		      (unsigned long long)btrfs_stripe_devid_nr(eb, chunk, i),
@@ -744,6 +789,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	u32 nr = btrfs_header_nritems(l);
 	u64 objectid;
 	u32 type;
+	char bg_flags_str[32];
 
 	printf("leaf %llu items %d free space %d generation %llu owner %llu\n",
 		(unsigned long long)btrfs_header_bytenr(l), nr,
@@ -858,10 +904,13 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 					    struct btrfs_block_group_item);
 			read_extent_buffer(l, &bg_item, (unsigned long)bi,
 					   sizeof(bg_item));
-			printf("\t\tblock group used %llu chunk_objectid %llu flags %llu\n",
+			memset(bg_flags_str, 0, sizeof(bg_flags_str));
+			bg_flags_to_str(btrfs_block_group_flags(&bg_item),
+					bg_flags_str);
+			printf("\t\tblock group used %llu chunk_objectid %llu flags %s\n",
 			       (unsigned long long)btrfs_block_group_used(&bg_item),
 			       (unsigned long long)btrfs_block_group_chunk_objectid(&bg_item),
-			       (unsigned long long)btrfs_block_group_flags(&bg_item));
+			       bg_flags_str);
 			break;
 		case BTRFS_CHUNK_ITEM_KEY:
 			print_chunk(l, btrfs_item_ptr(l, i, struct btrfs_chunk));
-- 
2.0.0

