Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:44217 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab2EZK7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:50 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 02/15] Btrfs: bugfix in btrfs_find_parent_nodes
Date: Sat, 26 May 2012 12:59:36 +0200
Message-Id: <dadcaf78b51e239d93f5ec9aac736de99081ee74.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That one has been around since the addition of backref.c. Due to the way we
calculate our slot numbers, after adding inline refs we're missing one keyed
ref unless it's located at the beginning of a new leaf.

Reported-by: Alexander Block <ablock84@googlemail.com>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index b41d94a..c69a846 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -413,7 +413,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 	 * enumerate all inline refs
 	 */
 	leaf = path->nodes[0];
-	slot = path->slots[0] - 1;
+	slot = path->slots[0];
 
 	item_size = btrfs_item_size_nr(leaf, slot);
 	BUG_ON(item_size < sizeof(*ei));
@@ -661,8 +661,9 @@ again:
 		struct extent_buffer *leaf;
 		int slot;
 
+		path->slots[0]--;
 		leaf = path->nodes[0];
-		slot = path->slots[0] - 1;
+		slot = path->slots[0];
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid == bytenr &&
 		    key.type == BTRFS_EXTENT_ITEM_KEY) {
-- 
1.7.3.4

