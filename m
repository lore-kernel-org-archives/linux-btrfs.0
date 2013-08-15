Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:36092 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab3HOPL3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Aug 2013 11:11:29 -0400
Received: from pizpot.store ([192.168.43.236])
 by josoe.store (RZmta 31.40 OK) with ESMTP id p04750p7FEfDLr
 for <linux-btrfs@vger.kernel.org>;
 Thu, 15 Aug 2013 17:11:24 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v8 2/8] Btrfs: support printing UUID tree elements
Date: Thu, 15 Aug 2013 17:11:18 +0200
Message-Id: <02fce9d487b6df1de4812e62e8708774afb1e121.1376575048.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1376575048.git.sbehrens@giantdisaster.de>
References: <cover.1376575048.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1376575048.git.sbehrens@giantdisaster.de>
References: <cover.1376575048.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit adds support to print UUID tree elements to print-tree.c.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/print-tree.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index fe7bf4a..32022f3 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -155,6 +155,25 @@ static void print_extent_ref_v0(struct extent_buffer *eb, int slot)
 }
 #endif
 
+static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
+			    u32 item_size)
+{
+	if (!IS_ALIGNED(item_size, sizeof(u64))) {
+		pr_warn("btrfs: uuid item with illegal size %lu!\n",
+			(unsigned long)item_size);
+		return;
+	}
+	while (item_size) {
+		__le64 subvol_id;
+
+		read_extent_buffer(l, &subvol_id, offset, sizeof(subvol_id));
+		printk(KERN_INFO "\t\tsubvol_id %llu\n",
+		       (unsigned long long)le64_to_cpu(subvol_id));
+		item_size -= sizeof(u64);
+		offset += sizeof(u64);
+	}
+}
+
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
 	int i;
@@ -301,6 +320,11 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_DEV_REPLACE_KEY:
 			printk(KERN_INFO "\t\tdev replace\n");
 			break;
+		case BTRFS_UUID_KEY_SUBVOL:
+		case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
+			print_uuid_item(l, btrfs_item_ptr_offset(l, i),
+					btrfs_item_size_nr(l, i));
+			break;
 		};
 	}
 }
-- 
1.8.3.4

