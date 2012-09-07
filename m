Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab2IGPCU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Sep 2012 11:02:20 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id DA0E6A24CA
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2012 17:02:18 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: pretty print key in extent_item
Date: Fri,  7 Sep 2012 17:02:16 +0200
Message-Id: <1347030136-12392-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 print-tree.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 89fc5b4..7c615dd 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -205,11 +205,9 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		struct btrfs_tree_block_info *info;
 		info = (struct btrfs_tree_block_info *)(ei + 1);
 		btrfs_tree_block_key(eb, info, &key);
-		printf("\t\ttree block key (%llu %x %llu) level %d\n",
-		       (unsigned long long)btrfs_disk_key_objectid(&key),
-		       key.type,
-		       (unsigned long long)btrfs_disk_key_offset(&key),
-		       btrfs_tree_block_level(eb, info));
+		printf("\t\ttree block ");
+		btrfs_print_key(&key);
+		printf(" level %d\n", btrfs_tree_block_level(eb, info));
 		iref = (struct btrfs_extent_inline_ref *)(info + 1);
 	} else {
 		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
-- 
1.7.6.233.gd79bc

