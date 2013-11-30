Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47566 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3K3L2n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Nov 2013 06:28:43 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so8367947wgh.35
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Nov 2013 03:28:42 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix extent_map block_len after merging
Date: Sat, 30 Nov 2013 11:28:35 +0000
Message-Id: <1385810915-2826-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When merging an extent_map with its right neighbor, increment
its block_len with the neighbor's block_len.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent_map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index b60955d..996ad56b 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -255,7 +255,7 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 		merge = rb_entry(rb, struct extent_map, rb_node);
 	if (rb && mergable_maps(em, merge)) {
 		em->len += merge->len;
-		em->block_len += merge->len;
+		em->block_len += merge->block_len;
 		rb_erase(&merge->rb_node, &tree->map);
 		merge->in_tree = 0;
 		em->mod_len = (merge->mod_start + merge->mod_len) - em->mod_start;
-- 
1.7.9.5

