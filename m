Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:34731 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab3GPNih (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 09:38:37 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp3) (RZmta 31.28 OK)
	with ESMTP id p07dd7p6FHCw7E for <linux-btrfs@vger.kernel.org>;
	Tue, 16 Jul 2013 15:38:33 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: Print key type in decimal everywhere
Date: Tue, 16 Jul 2013 15:38:33 +0200
Message-Id: <1373981913-24659-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is confusing, sometimes the key type is printed in hex (without
a leading "0x" which makes things even more complicated), sometimes
in decimal...
Change it to be in decimal everywhere.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/print-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index b6b209c..32022f3 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -95,7 +95,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		struct btrfs_tree_block_info *info;
 		info = (struct btrfs_tree_block_info *)(ei + 1);
 		btrfs_tree_block_key(eb, info, &key);
-		printk(KERN_INFO "\t\ttree block key (%llu %x %llu) "
+		printk(KERN_INFO "\t\ttree block key (%llu %u %llu) "
 		       "level %d\n",
 		       (unsigned long long)btrfs_disk_key_objectid(&key),
 		       key.type,
@@ -202,7 +202,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		item = btrfs_item_nr(l, i);
 		btrfs_item_key_to_cpu(l, &key, i);
 		type = btrfs_key_type(&key);
-		printk(KERN_INFO "\titem %d key (%llu %x %llu) itemoff %d "
+		printk(KERN_INFO "\titem %d key (%llu %u %llu) itemoff %d "
 		       "itemsize %d\n",
 			i,
 			(unsigned long long)key.objectid, type,
-- 
1.8.3.2

