Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:59725 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab3GILpc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 07:45:32 -0400
Received: by mail-we0-f180.google.com with SMTP id w56so4680629wes.11
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jul 2013 04:45:31 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: add missing path release
Date: Tue,  9 Jul 2013 12:45:23 +0100
Message-Id: <1373370323-23169-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before repeating the search in extent-tree.c:lookup_inline_extent_backref(),
release the current path.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 extent-tree.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/extent-tree.c b/extent-tree.c
index f597e16..ba357de 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1064,6 +1064,7 @@ again:
 		if (ret) {
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			key.offset = num_bytes;
+			btrfs_release_path(root, path);
 			goto again;
 		}
 	}
-- 
1.7.9.5

