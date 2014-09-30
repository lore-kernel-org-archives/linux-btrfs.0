Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55551 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846AbaI3VEb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 17:04:31 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8UL4RY0020091
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 14:04:30 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pqrywjg51-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 14:04:29 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add shift_items to btrfs-corrupt-block
Date: Tue, 30 Sep 2014 17:02:26 -0400
Message-ID: <1412110946-8598-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user had a corrupted fs where his items where shifted oddly.  This adds the
functionality I needed to btrfs-corrupt-block in order to reproduce this
corruption in order to make fsck fix this sort of problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-corrupt-block.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 474d48f..22390b5 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -303,6 +303,7 @@ enum btrfs_file_extent_field {
 
 enum btrfs_metadata_block_field {
 	BTRFS_METADATA_BLOCK_GENERATION,
+	BTRFS_METADATA_BLOCK_SHIFT_ITEMS,
 	BTRFS_METADATA_BLOCK_BAD,
 };
 
@@ -332,6 +333,8 @@ convert_metadata_block_field(char *field)
 {
 	if (!strncmp(field, "generation", FIELD_BUF_LEN))
 		return BTRFS_METADATA_BLOCK_GENERATION;
+	if (!strncmp(field, "shift_items", FIELD_BUF_LEN))
+		return BTRFS_METADATA_BLOCK_SHIFT_ITEMS;
 	return BTRFS_METADATA_BLOCK_BAD;
 }
 
@@ -538,6 +541,26 @@ out:
 	return ret;
 }
 
+static void shift_items(struct btrfs_root *root, struct extent_buffer *eb)
+{
+	int nritems = btrfs_header_nritems(eb);
+	int shift_space = btrfs_leaf_free_space(root, eb) / 2;
+	int slot = nritems / 2;
+	int i = 0;
+	unsigned int data_end = btrfs_item_offset_nr(eb, nritems - 1);
+
+	/* Shift the item data up to and including slot back by shift space */
+	memmove_extent_buffer(eb, data_end - shift_space, data_end,
+			      btrfs_item_offset_nr(eb, slot - 1) - data_end);
+
+	/* Now update the item pointers. */
+	for (i = nritems - 1; i >= slot; i--) {
+		u32 offset = btrfs_item_offset_nr(eb, i);
+		offset -= shift_space;
+		btrfs_set_item_offset(eb, btrfs_item_nr(i), offset);
+	}
+}
+
 static int corrupt_metadata_block(struct btrfs_root *root, u64 block,
 				  char *field)
 {
@@ -608,6 +631,9 @@ static int corrupt_metadata_block(struct btrfs_root *root, u64 block,
 		bogus = generate_u64(orig);
 		btrfs_set_header_generation(eb, bogus);
 		break;
+	case BTRFS_METADATA_BLOCK_SHIFT_ITEMS:
+		shift_items(root, path->nodes[level]);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
1.8.3.1

