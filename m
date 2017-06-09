Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33435 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbdFISJr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 14:09:47 -0400
Received: by mail-pg0-f66.google.com with SMTP id a70so8310303pge.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jun 2017 11:09:47 -0700 (PDT)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard@netgear.com>
Subject: [PATCH] btrfs-progs: Fix an infinite loop in btrfs_next_bg
Date: Fri,  9 Jun 2017 11:09:35 -0700
Message-Id: <20170609180935.9554-1-jmaggard@netgear.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've run into a couple filesystems where btrfs-find-root would spin
indefinitely.

If the first cache extent start location is 0, we end up in an infinite
loop in btrfs_next_bg().  Fix it by checking for that situation, and
jumping to the next bg if necessary.

Fixes: e2e0dae9 (btrfs-progs: volume: Fix a bug causing btrfs-find-root to skip first chunk)
Signed-off-by: Justin Maggard <jmaggard@netgear.com>
---
 volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/volumes.c b/volumes.c
index b350e259..8c0c10ce 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1278,6 +1278,8 @@ int btrfs_next_bg(struct btrfs_mapping_tree *map_tree, u64 *logical,
 			*size = ce->size;
 			return 0;
 		}
+		if (!cur)
+			ce = next_cache_extent(ce);
 	}
 
 	return -ENOENT;
-- 
2.13.0

