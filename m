Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:40451 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964820Ab3GCROn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 13:14:43 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp2) (RZmta 31.28 OK)
	with ESMTP id g07dc1p63CAmFE for <linux-btrfs@vger.kernel.org>;
	Wed, 3 Jul 2013 19:14:40 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7 2/8] Btrfs: support printing UUID tree elements
Date: Wed,  3 Jul 2013 19:14:33 +0200
Message-Id: <17a70bd23862b919982d7f03d9dcb784f2ab71ac.1372866277.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372866277.git.sbehrens@giantdisaster.de>
References: <cover.1372866277.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1372866277.git.sbehrens@giantdisaster.de>
References: <cover.1372866277.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit adds support to print UUID tree elements to print-tree.c.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/print-tree.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index dc0024f..b6b209c 100644
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
1.8.3.2

