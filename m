Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:41878 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030732Ab3DSPlK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 11:41:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp4) (RZmta 31.27 OK)
	with ESMTP id 6049b1p3JEl7LW for <linux-btrfs@vger.kernel.org>;
	Fri, 19 Apr 2013 17:41:06 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] Btrfs: support printing UUID tree elements
Date: Fri, 19 Apr 2013 17:41:03 +0200
Message-Id: <85b4a097a36353848383d0ac0339cb644a1cf2bb.1366384796.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1366384796.git.sbehrens@giantdisaster.de>
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1366384796.git.sbehrens@giantdisaster.de>
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit adds support to print UUID tree elements to print-tree.c.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/print-tree.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index dc0024f..6e204ee 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -155,6 +155,73 @@ static void print_extent_ref_v0(struct extent_buffer *eb, int slot)
 }
 #endif
 
+static void print_uuid_item(struct extent_buffer *l,
+			    struct btrfs_uuid_item *ptr,
+			    u64 item_size)
+{
+	do {
+		u64 sub_item_type;
+		u64 sub_item_len;
+		u64 subvol_id;
+
+		if (item_size < sizeof(*ptr)) {
+			printk(KERN_INFO "btrfs: uuid item too short!\n");
+			return;
+		}
+		sub_item_type = btrfs_uuid_type(l, ptr);
+		sub_item_len = btrfs_uuid_len(l, ptr);
+		ptr++;
+		item_size -= sizeof(*ptr);
+		if (sub_item_len * 8 > item_size) {
+			printk(KERN_INFO "btrfs: uuid item too short (2)!\n");
+			return;
+		}
+
+		item_size -= sub_item_len * 8;
+		switch (sub_item_type) {
+		case BTRFS_UUID_ITEM_TYPE_SUBVOL:
+			while (sub_item_len) {
+				read_extent_buffer(l, &subvol_id,
+						   (unsigned long)ptr, 8);
+				printk(KERN_INFO "\t\tsubvol_id %llu\n",
+				       (unsigned long long)
+					le64_to_cpu(subvol_id));
+				sub_item_len--;
+				ptr = (struct btrfs_uuid_item *)
+					(((char *)ptr) + 8);
+			}
+			break;
+		case BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL:
+			while (sub_item_len) {
+				read_extent_buffer(l, &subvol_id,
+						   (unsigned long)ptr, 8);
+				printk(KERN_INFO "\t\treceived_subvol_id %llu\n",
+				       (unsigned long long)
+					le64_to_cpu(subvol_id));
+				sub_item_len--;
+				ptr = (struct btrfs_uuid_item *)
+					(((char *)ptr) + 8);
+			}
+			break;
+		default:
+			printk(KERN_INFO "\t\tunknown type=%llu, len=8*%llu\n",
+			       (unsigned long long)sub_item_type,
+			       (unsigned long long)sub_item_len);
+			while (sub_item_len) {
+				read_extent_buffer(l, &subvol_id,
+						   (unsigned long)ptr, 8);
+				printk(KERN_INFO "\t\tid %llu\n",
+				       (unsigned long long)
+					le64_to_cpu(subvol_id));
+				sub_item_len--;
+				ptr = (struct btrfs_uuid_item *)
+					(((char *)ptr) + 8);
+			}
+			break;
+		}
+	} while (item_size);
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -168,6 +235,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_extent_data_ref *dref;
 	struct btrfs_shared_data_ref *sref;
 	struct btrfs_dev_extent *dev_extent;
+	struct btrfs_uuid_item *uuid_item;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 
@@ -301,6 +369,11 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_DEV_REPLACE_KEY:
 			printk(KERN_INFO "\t\tdev replace\n");
 			break;
+		case BTRFS_UUID_KEY:
+			uuid_item = btrfs_item_ptr(l, i,
+						   struct btrfs_uuid_item);
+			print_uuid_item(l, uuid_item, btrfs_item_size_nr(l, i));
+			break;
 		};
 	}
 }
-- 
1.8.2.1

