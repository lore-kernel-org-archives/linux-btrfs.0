Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbcDKSIM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 14:08:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5CA22ABB4
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 18:08:10 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: reuse existing variable in scrub_stripe, reduce stack usage
Date: Mon, 11 Apr 2016 20:04:35 +0200
Message-Id: <355ef15a6eafc0cafd49b049d7173040adb44f61.1460397148.git.dsterba@suse.com>
In-Reply-To: <cover.1460397148.git.dsterba@suse.com>
References: <cover.1460397148.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The key variable occupies 17 bytes, the key_start is used once, we can
simply reuse existing 'key' for that purpose. As the key is not a simple
type, compiler doest not do it on itself.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 39dbdcbf4d13..07db452e4a15 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3070,7 +3070,6 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	int slot;
 	u64 nstripes;
 	struct extent_buffer *l;
-	struct btrfs_key key;
 	u64 physical;
 	u64 logical;
 	u64 logic_end;
@@ -3079,7 +3078,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	int mirror_num;
 	struct reada_control *reada1;
 	struct reada_control *reada2;
-	struct btrfs_key key_start;
+	struct btrfs_key key;
 	struct btrfs_key key_end;
 	u64 increment = map->stripe_len;
 	u64 offset;
@@ -3158,21 +3157,21 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	scrub_blocked_if_needed(fs_info);
 
 	/* FIXME it might be better to start readahead at commit root */
-	key_start.objectid = logical;
-	key_start.type = BTRFS_EXTENT_ITEM_KEY;
-	key_start.offset = (u64)0;
+	key.objectid = logical;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = (u64)0;
 	key_end.objectid = logic_end;
 	key_end.type = BTRFS_METADATA_ITEM_KEY;
 	key_end.offset = (u64)-1;
-	reada1 = btrfs_reada_add(root, &key_start, &key_end);
+	reada1 = btrfs_reada_add(root, &key, &key_end);
 
-	key_start.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
-	key_start.type = BTRFS_EXTENT_CSUM_KEY;
-	key_start.offset = logical;
+	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
+	key.type = BTRFS_EXTENT_CSUM_KEY;
+	key.offset = logical;
 	key_end.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
 	key_end.type = BTRFS_EXTENT_CSUM_KEY;
 	key_end.offset = logic_end;
-	reada2 = btrfs_reada_add(csum_root, &key_start, &key_end);
+	reada2 = btrfs_reada_add(csum_root, &key, &key_end);
 
 	if (!IS_ERR(reada1))
 		btrfs_reada_wait(reada1);
-- 
2.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
