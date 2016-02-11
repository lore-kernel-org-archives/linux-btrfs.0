Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbcBKRXn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:23:43 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 11D67AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 17:23:42 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/6] btrfs: teach print_leaf about permanent item subtypes
Date: Thu, 11 Feb 2016 18:23:41 +0100
Message-Id: <585a3d0d238dfe42909cb58b0d05f644365fed14.1455209994.git.dsterba@suse.com>
In-Reply-To: <cover.1455209994.git.dsterba@suse.com>
References: <cover.1455209994.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/print-tree.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 647ab12fdf5d..7bd0bdfc9812 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -295,8 +295,16 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       btrfs_dev_extent_chunk_offset(l, dev_extent),
 			       btrfs_dev_extent_length(l, dev_extent));
 			break;
-		case BTRFS_DEV_STATS_KEY:
-			printk(KERN_INFO "\t\tdevice stats\n");
+		case BTRFS_PERSISTENT_ITEM_KEY:
+			printk(KERN_INFO "\t\tpersistent item objectid %llu offset %llu\n",
+					key.objectid, key.offset);
+			switch (key.objectid) {
+			case BTRFS_DEV_STATS_OBJECTID:
+				printk(KERN_INFO "\t\tdevice stats\n");
+				break;
+			default:
+				printk(KERN_INFO "\t\tunknown persistent item\n");
+			}
 			break;
 		case BTRFS_DEV_REPLACE_KEY:
 			printk(KERN_INFO "\t\tdev replace\n");
-- 
2.7.1

