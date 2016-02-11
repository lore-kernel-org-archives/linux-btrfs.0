Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbcBKRXq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:23:46 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 55528AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 17:23:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/6] btrfs: teach print_leaf about temporary item subtypes
Date: Thu, 11 Feb 2016 18:23:45 +0100
Message-Id: <9f07e1d76eaeeddedcf9651395b4a8f870df31f0.1455209994.git.dsterba@suse.com>
In-Reply-To: <cover.1455209994.git.dsterba@suse.com>
References: <cover.1455209994.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/print-tree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 7bd0bdfc9812..147dc6ca5de1 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -306,6 +306,17 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 				printk(KERN_INFO "\t\tunknown persistent item\n");
 			}
 			break;
+		case BTRFS_TEMPORARY_ITEM_KEY:
+			printk(KERN_INFO "\t\ttemporary item objectid %llu offset %llu\n",
+					key.objectid, key.offset);
+			switch (key.objectid) {
+			case BTRFS_BALANCE_OBJECTID:
+				printk(KERN_INFO "\t\tbalance status\n");
+				break;
+			default:
+				printk(KERN_INFO "\t\tunknown temporary item\n");
+			}
+			break;
 		case BTRFS_DEV_REPLACE_KEY:
 			printk(KERN_INFO "\t\tdev replace\n");
 			break;
-- 
2.7.1

