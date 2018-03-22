Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:34321 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbeCVJGf (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 22 Mar 2018 05:06:35 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: check/original: Remove unused variable first_key
Date: Thu, 22 Mar 2018 17:06:24 +0800
Message-Id: <20180322090624.13408-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This @first_key variable is introduced in f5c4c4f3b75b
("btrfsck: add code to rebuild extent records"), however it's not only
unused, but also used incorrectly.

It's calling btrfs_item_key_to_cpu() on an node extent buffer.

Anyway, just remove it.

Fixes: f5c4c4f3b75b ("btrfsck: add code to rebuild extent records")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/check/main.c b/check/main.c
index b476e07ba9e7..891a6d797756 100644
--- a/check/main.c
+++ b/check/main.c
@@ -6103,12 +6103,7 @@ static int run_next_block(struct btrfs_root *root,
 		}
 	} else {
 		int level;
-		struct btrfs_key first_key;
 
-		first_key.objectid = 0;
-
-		if (nritems > 0)
-			btrfs_item_key_to_cpu(buf, &first_key, 0);
 		level = btrfs_header_level(buf);
 		for (i = 0; i < nritems; i++) {
 			struct extent_record tmpl;
-- 
2.16.2

