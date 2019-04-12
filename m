Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328B7C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED72F20850
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 09:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfDLJFi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:05:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:43050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726678AbfDLJFh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 05:05:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 31A21AFD1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 09:05:36 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: dump-tree: Do simple bit flip check and continue if we can handle it
Date:   Fri, 12 Apr 2019 17:05:29 +0800
Message-Id: <20190412090530.29132-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190412090530.29132-1-wqu@suse.com>
References: <20190412090530.29132-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have quite some users reporting bit flips, despite the cause, we
still need to figure out if it's a bit flip manually.

Let's make dump-tree clever enough to handle at least item offset/size
bit flip by itself.

This is done by manually checking if there is single bit out of the
node size range.
If there is a bit flipped and after fix it passes regular item
size/offset check, then we manually use the corrected item offset/size
in the printing routine.

Before this patch, dump-tree will just skip all remaining items like:
  fs tree key (FS_TREE ROOT_ITEM 0)
  leaf 30572544 items 11 free space 15293 generation 6 owner FS_TREE
  leaf 30572544 flags 0x1(WRITTEN) backref revision 1
  fs uuid d547b94d-7372-4739-a2bb-076906aa1d12
  chunk uuid aceea146-a2fc-450c-9aa9-e0e82323641a
  	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
  		generation 3 transid 6 size 20 nbytes 16384
  		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
  		sequence 2 flags 0x0(none)
  		atime 1555057503.953957270 (2019-04-12 16:25:03)
  		ctime 1555057509.900560077 (2019-04-12 16:25:09)
  		mtime 1555057509.900560077 (2019-04-12 16:25:09)
  		otime 1555057483.0 (2019-04-12 16:24:43)
  	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
  		index 0 namelen 2 name: ..
  ERROR: leaf 30572544 slot 2 pointer invalid, offset 48844 size 35 leaf data limit 16283
  ERROR: skip remaining slots

While after this patch, it will mark the corrupted item and still output
the correct content, although with some stderr output:
  incorrect offsets 16111 48879
  incorrect offsets 16111 48879
  incorrect offsets 16111 48879
  fs tree key (FS_TREE ROOT_ITEM 0)
  leaf 30572544 items 11 free space 15293 generation 6 owner FS_TREE
  leaf 30572544 flags 0x1(WRITTEN) backref revision 1
  fs uuid d547b94d-7372-4739-a2bb-076906aa1d12
  chunk uuid aceea146-a2fc-450c-9aa9-e0e82323641a
  	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
  		generation 3 transid 6 size 20 nbytes 16384
  		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
  		sequence 2 flags 0x0(none)
  		atime 1555057503.953957270 (2019-04-12 16:25:03)
  		ctime 1555057509.900560077 (2019-04-12 16:25:09)
  		mtime 1555057509.900560077 (2019-04-12 16:25:09)
  		otime 1555057483.0 (2019-04-12 16:24:43)
  	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
  		index 0 namelen 2 name: ..
  !!!	item 2 key (256 DIR_ITEM 3846364860) itemoff 16076 (original: 48844) itemsize 35 (original: 35)
  		location key (258 INODE_ITEM 0) type FILE
  		transid 6 data_len 0 name_len 5
  		name: file2
  	item 3 key (256 DIR_ITEM 4128386376) itemoff 16041 itemsize 35
  		location key (257 INODE_ITEM 0) type FILE
  		transid 6 data_len 0 name_len 5
  		name: file1
  !!!	item 4 key (256 DIR_INDEX 2) itemoff 16006 (original: 16006) itemsize 35 (original: 65571)
  		location key (257 INODE_ITEM 0) type FILE
  		transid 6 data_len 0 name_len 5
  		name: file1
  <snip>
  	item 10 key (258 INODE_REF 256) itemoff 15568 itemsize 15
  		index 3 namelen 5 name: file2

The "!!!" is used to indicate the problem, and both original and
corrected item offset size will be outputted.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 print-tree.c | 100 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 81 insertions(+), 19 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index ab77463706c1..e88b3934dcf9 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -417,7 +417,8 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 	unsigned long end;
 	unsigned long ptr;
 	int type;
-	u32 item_size = btrfs_item_size_nr(eb, slot);
+	u32 item_size = btrfs_item_size_nr(eb, slot) &
+			(eb->fs_info->nodesize - 1);
 	u64 flags;
 	u64 offset;
 	char flags_str[32] = {0};
@@ -583,7 +584,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 	struct btrfs_key drop_key;
 
 	ri = btrfs_item_ptr(leaf, slot, struct btrfs_root_item);
-	len = btrfs_item_size_nr(leaf, slot);
+	len = btrfs_item_size_nr(leaf, slot) & (leaf->fs_info->nodesize - 1);
 
 	memset(&root_item, 0, sizeof(root_item));
 	read_extent_buffer(leaf, &root_item, (unsigned long)ri, len);
@@ -1184,6 +1185,51 @@ static void header_flags_to_str(u64 flags, char *ret)
 	}
 }
 
+static bool __is_valid_item_ptr(struct btrfs_fs_info *fs_info, u32 item_offset,
+				u32 item_size)
+{
+	u32 leaf_data_size = BTRFS_LEAF_DATA_SIZE(fs_info);
+
+	/* Item pointer must be inside the leaf */
+	return !(item_offset > leaf_data_size || item_offset + item_size
+		 > leaf_data_size);
+}
+
+static bool is_valid_item(struct extent_buffer *leaf, int slot)
+{
+	return __is_valid_item_ptr(leaf->fs_info,
+			btrfs_item_offset_nr(leaf, slot),
+			btrfs_item_size_nr(leaf, slot));
+}
+
+static bool is_bit_flipped(struct extent_buffer *leaf, int slot)
+{
+	u32 nodesize_mask = leaf->fs_info->nodesize - 1;
+	u32 item_offset = btrfs_item_offset_nr(leaf, slot);
+	u32 item_size = btrfs_item_size_nr(leaf, slot);
+
+	ASSERT(is_power_of_2(leaf->fs_info->nodesize));
+	/* Bit flip should only happen once */
+	if (is_power_of_2(item_offset & ~nodesize_mask) &&
+	    (item_size & ~nodesize_mask) == 0 &&
+	    __is_valid_item_ptr(leaf->fs_info, item_offset & nodesize_mask,
+				item_size))
+		return true;
+	if (is_power_of_2(item_size & ~nodesize_mask) &&
+	    (item_offset & ~nodesize_mask) == 0 &&
+	    __is_valid_item_ptr(leaf->fs_info, item_offset,
+				item_size & nodesize_mask))
+		return true;
+	return false;
+}
+
+static void *btrfs_item_safe_ptr(struct extent_buffer *leaf, int slot)
+{
+	return (void *)(btrfs_leaf_data(leaf) +
+			(btrfs_item_offset_nr(leaf, slot) &
+			 (leaf->fs_info->nodesize - 1)));
+}
+
 void btrfs_print_leaf(struct extent_buffer *eb)
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
@@ -1193,6 +1239,7 @@ void btrfs_print_leaf(struct extent_buffer *eb)
 	u32 leaf_data_size = BTRFS_LEAF_DATA_SIZE(fs_info);
 	u32 i;
 	u32 nr;
+	u32 nodesize_mask = fs_info->nodesize - 1;
 	u64 flags;
 	u8 backref_rev;
 
@@ -1213,6 +1260,7 @@ void btrfs_print_leaf(struct extent_buffer *eb)
 	fflush(stdout);
 
 	for (i = 0; i < nr; i++) {
+		bool bit_flip = false;
 		u32 item_size;
 		void *ptr;
 		u64 objectid;
@@ -1225,32 +1273,46 @@ void btrfs_print_leaf(struct extent_buffer *eb)
 		 * Only need to ensure all pointers are pointing range inside
 		 * the leaf, thus no segfault.
 		 */
-		if (btrfs_item_offset_nr(eb, i) > leaf_data_size ||
-		    btrfs_item_size_nr(eb, i) + btrfs_item_offset_nr(eb, i) >
-		    leaf_data_size) {
-			error(
+		if (!is_valid_item(eb, i)) {
+			if (is_bit_flipped(eb, i)) {
+				bit_flip = true;
+			} else {
+				error(
 "leaf %llu slot %u pointer invalid, offset %u size %u leaf data limit %u",
-			      btrfs_header_bytenr(eb), i,
-			      btrfs_item_offset_nr(eb, i),
-			      btrfs_item_size_nr(eb, i), leaf_data_size);
-			error("skip remaining slots");
-			break;
+				      btrfs_header_bytenr(eb), i,
+				      btrfs_item_offset_nr(eb, i),
+				      btrfs_item_size_nr(eb, i),
+				      leaf_data_size);
+				error("skip remaining slots");
+				break;
+			}
 		}
 		item = btrfs_item_nr(i);
-		item_size = btrfs_item_size(eb, item);
+		item_size = btrfs_item_size(eb, item) & nodesize_mask;
 		/* Untyped extraction of slot from btrfs_item_ptr */
-		ptr = btrfs_item_ptr(eb, i, void*);
+		ptr = btrfs_item_safe_ptr(eb, i);
 
 		btrfs_item_key(eb, &disk_key, i);
 		objectid = btrfs_disk_key_objectid(&disk_key);
 		type = btrfs_disk_key_type(&disk_key);
 		offset = btrfs_disk_key_offset(&disk_key);
 
-		printf("\titem %d ", i);
+		if (bit_flip)
+			printf("!!!\titem %d ", i);
+		else
+			printf("\titem %d ", i);
 		btrfs_print_key(&disk_key);
-		printf(" itemoff %d itemsize %d\n",
-			btrfs_item_offset(eb, item),
-			btrfs_item_size(eb, item));
+		if (bit_flip)
+			printf(
+		" itemoff %d (original: %d) itemsize %d (original: %d)\n",
+				btrfs_item_offset(eb, item) & nodesize_mask,
+				btrfs_item_offset(eb, item),
+				btrfs_item_size(eb, item) & nodesize_mask,
+				btrfs_item_size(eb, item));
+		else
+			printf(" itemoff %d itemsize %d\n",
+				btrfs_item_offset(eb, item),
+				btrfs_item_size(eb, item));
 
 		if (type == 0 && objectid == BTRFS_FREE_SPACE_OBJECTID)
 			print_free_space_header(eb, i);
@@ -1360,8 +1422,8 @@ void btrfs_print_leaf(struct extent_buffer *eb)
 			break;
 		case BTRFS_UUID_KEY_SUBVOL:
 		case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
-			print_uuid_item(eb, btrfs_item_ptr_offset(eb, i),
-					btrfs_item_size_nr(eb, i));
+			print_uuid_item(eb, btrfs_item_ptr_offset(eb, i) &
+					nodesize_mask, item_size);
 			break;
 		case BTRFS_STRING_ITEM_KEY: {
 			const char *str = eb->data + btrfs_item_ptr_offset(eb, i);
-- 
2.21.0

