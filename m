Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:30567 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934600AbeE3H1W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 03:27:22 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 21034AC00B9
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 16:27:17 +0900 (JST)
Received: from g01jpexchyt38.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 2FEAD6D6793
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 16:27:16 +0900 (JST)
Subject: [PATCH v2 2/2] btrfs-progs: ins: dump-tree: Print tree name for
 extent data/tree block backref
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <cover.1527655420.git.misono.tomohiro@jp.fujitsu.com>
 <f6cac4991b513c3c4b00781414d422b3f4c87f6e.1527655420.git.misono.tomohiro@jp.fujitsu.com>
Message-ID: <5f258c66-ffde-e7e0-4640-9e3465203c95@jp.fujitsu.com>
Date: Wed, 30 May 2018 16:25:50 +0900
MIME-Version: 1.0
In-Reply-To: <f6cac4991b513c3c4b00781414d422b3f4c87f6e.1527655420.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Print tree name instead of number to make output more readable.

Example:
[before]
   extent data backref root 5 objectid 257 offset 16384 count 1
   
   tree block backref root 18446744073709551607

[after]
   extent data backref root FS_TREE objectid 257 offset 16384 count 1
   
   tree block backref root DATA_RELOC_TREE

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 v1 -> v2
   - Update extent data backref too
   - Add output example

 print-tree.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 90173c2b..c5be5e6c 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -470,8 +470,9 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 		offset = btrfs_extent_inline_ref_offset(eb, iref);
 		switch (type) {
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			printf("\t\ttree block backref root %llu\n",
-			       (unsigned long long)offset);
+			printf("\t\ttree block backref root ");
+			print_objectid(stdout, offset, 0);
+			printf("\n");
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
 			printf("\t\tshared block backref parent %llu\n",
@@ -479,9 +480,10 @@ void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
-			printf("\t\textent data backref root %llu "
-			       "objectid %llu offset %lld count %u\n",
-			       (unsigned long long)btrfs_extent_data_ref_root(eb, dref),
+			printf("\t\textent data backref root ");
+			print_objectid(stdout,
+		(unsigned long long)btrfs_extent_data_ref_root(eb, dref), 0);
+			printf(" objectid %llu offset %lld count %u\n",
 			       (unsigned long long)btrfs_extent_data_ref_objectid(eb, dref),
 			       btrfs_extent_data_ref_offset(eb, dref),
 			       btrfs_extent_data_ref_count(eb, dref));
@@ -1018,9 +1020,10 @@ static void print_extent_data_ref(struct extent_buffer *eb, int slot)
 	struct btrfs_extent_data_ref *dref;
 
 	dref = btrfs_item_ptr(eb, slot, struct btrfs_extent_data_ref);
-	printf("\t\textent data backref root %llu "
-		"objectid %llu offset %llu count %u\n",
-		(unsigned long long)btrfs_extent_data_ref_root(eb, dref),
+	printf("\t\textent data backref root ");
+	print_objectid(stdout,
+		(unsigned long long)btrfs_extent_data_ref_root(eb, dref), 0);
+	printf(" objectid %llu offset %llu count %u\n",
 		(unsigned long long)btrfs_extent_data_ref_objectid(eb, dref),
 		(unsigned long long)btrfs_extent_data_ref_offset(eb, dref),
 		btrfs_extent_data_ref_count(eb, dref));
-- 
2.14.3

