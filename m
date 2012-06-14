Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:31897 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab2FNRQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 13:16:39 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] Btrfs: remove obsolete btrfs_next_leaf call from __resolve_indirect_ref
Date: Thu, 14 Jun 2012 19:16:34 +0200
Message-Id: <1339694198-13388-3-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1339694198-13388-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When resolving indirect refs, we used to call btrfs_next_leaf in case we
didn't find an exact match. While we should find exact matches most of the
time, in case we don't, we must continue searching. Treating those matches
differently depending on the level we're searching doesn't make sense.

Even worse, we might end up searching for a key larger than the largest, in
which case there is no next_leaf and subsequent jobs would fail. This commit
drops the bogous lines.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 3f75895..579131d 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -294,16 +294,8 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	if (level == 0) {
-		if (ret == 1 && path->slots[0] >= btrfs_header_nritems(eb)) {
-			ret = btrfs_next_leaf(root, path);
-			if (ret)
-				goto out;
-			eb = path->nodes[0];
-		}
-
+	if (level == 0)
 		btrfs_item_key_to_cpu(eb, &key, path->slots[0]);
-	}
 
 	ret = add_all_parents(root, path, parents, level, &key,
 				ref->wanted_disk_byte, extent_item_pos);
-- 
1.7.3.4

