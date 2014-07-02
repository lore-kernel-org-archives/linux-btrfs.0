Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60465 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbaGBRVU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 13:21:20 -0400
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s62GvOOC012247
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Jul 2014 10:21:19 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1mv4g7ukg3-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 10:21:19 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix btrfs_print_leaf for skinny metadata
Date: Wed, 2 Jul 2014 10:20:48 -0700
Message-ID: <1404321648-26599-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We wouldn't actuall print the extent information if we had a skinny metadata
item, this fixes that.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/print-tree.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 6efd70d..9626b4a 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -54,7 +54,7 @@ static void print_extent_data_ref(struct extent_buffer *eb,
 	       btrfs_extent_data_ref_count(eb, ref));
 }
 
-static void print_extent_item(struct extent_buffer *eb, int slot)
+static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 {
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_inline_ref *iref;
@@ -63,7 +63,6 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 	struct btrfs_disk_key key;
 	unsigned long end;
 	unsigned long ptr;
-	int type;
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	u64 flags;
 	u64 offset;
@@ -88,7 +87,8 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 	       btrfs_extent_refs(eb, ei), btrfs_extent_generation(eb, ei),
 	       flags);
 
-	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+	if ((type == BTRFS_EXTENT_ITEM_KEY) &&
+	    flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		struct btrfs_tree_block_info *info;
 		info = (struct btrfs_tree_block_info *)(ei + 1);
 		btrfs_tree_block_key(eb, info, &key);
@@ -223,7 +223,8 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 				btrfs_disk_root_refs(l, ri));
 			break;
 		case BTRFS_EXTENT_ITEM_KEY:
-			print_extent_item(l, i);
+		case BTRFS_METADATA_ITEM_KEY:
+			print_extent_item(l, i, type);
 			break;
 		case BTRFS_TREE_BLOCK_REF_KEY:
 			printk(KERN_INFO "\t\ttree block backref\n");
-- 
2.0.0

