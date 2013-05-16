Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:30056 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab3EPOpK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 10:45:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp3) (RZmta 31.27 OK)
	with ESMTP id p05175p4G8aXN8 for <linux-btrfs@vger.kernel.org>;
	Thu, 16 May 2013 16:45:07 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/8] Btrfs: support printing UUID tree elements
Date: Thu, 16 May 2013 16:45:01 +0200
Message-Id: <b66d7834d86aee33bcb67dc50417cc30401d1895.1368713300.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368713300.git.sbehrens@giantdisaster.de>
References: <cover.1368713300.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368713300.git.sbehrens@giantdisaster.de>
References: <cover.1368713300.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit adds support to print UUID tree elements to print-tree.c.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/print-tree.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index dc0024f..c27f08b 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -155,6 +155,81 @@ static void print_extent_ref_v0(struct extent_buffer *eb, int slot)
 }
 #endif
 
+static void print_uuid_item(struct extent_buffer *l,
+			    struct btrfs_uuid_item *ptr,
+			    u32 item_size)
+{
+	do {
+		u16 sub_item_type;
+		u64 sub_item_len;
+		u64 subvol_id;
+		unsigned long offset;
+
+		if (item_size < sizeof(*ptr)) {
+			printk(KERN_INFO
+			       "btrfs: uuid item too short (%lu < %d)!\n",
+			       (unsigned long)item_size, (int)sizeof(*ptr));
+			return;
+		}
+		sub_item_type = btrfs_uuid_type(l, ptr);
+		sub_item_len = btrfs_uuid_len(l, ptr);
+		ptr++;
+		item_size -= sizeof(*ptr);
+
+		if (sub_item_len * sizeof(u64) > item_size) {
+			printk(KERN_INFO
+			       "btrfs: uuid item too short (%llu > %lu)!\n",
+			       (unsigned long long)(sub_item_len * sizeof(u64)),
+			       (unsigned long)item_size);
+			return;
+		}
+
+		offset = (unsigned long)ptr;
+		ptr = (struct btrfs_uuid_item *)
+			(((char *)ptr) + sub_item_len * sizeof(u64));
+		item_size -= sub_item_len * sizeof(u64);
+		switch (sub_item_type) {
+		case BTRFS_UUID_ITEM_TYPE_SUBVOL:
+			while (sub_item_len) {
+				read_extent_buffer(l, &subvol_id, offset,
+						   sizeof(u64));
+				printk(KERN_INFO "\t\tsubvol_id %llu\n",
+				       (unsigned long long)
+					le64_to_cpu(subvol_id));
+				sub_item_len--;
+				offset += sizeof(u64);
+			}
+			break;
+		case BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL:
+			while (sub_item_len) {
+				read_extent_buffer(l, &subvol_id, offset,
+						   sizeof(u64));
+				printk(KERN_INFO
+				       "\t\treceived_subvol_id %llu\n",
+				       (unsigned long long)
+					le64_to_cpu(subvol_id));
+				sub_item_len--;
+				offset += sizeof(u64);
+			}
+			break;
+		default:
+			printk(KERN_INFO "\t\tunknown type=%llu, len=8*%llu\n",
+			       (unsigned long long)sub_item_type,
+			       (unsigned long long)sub_item_len);
+			while (sub_item_len) {
+				read_extent_buffer(l, &subvol_id, offset,
+						   sizeof(u64));
+				printk(KERN_INFO "\t\tid %llu\n",
+				       (unsigned long long)
+					le64_to_cpu(subvol_id));
+				sub_item_len--;
+				offset += sizeof(u64);
+			}
+			break;
+		}
+	} while (item_size);
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -168,6 +243,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_extent_data_ref *dref;
 	struct btrfs_shared_data_ref *sref;
 	struct btrfs_dev_extent *dev_extent;
+	struct btrfs_uuid_item *uuid_item;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 
@@ -301,6 +377,11 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
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
1.8.2.3

