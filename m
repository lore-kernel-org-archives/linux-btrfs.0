Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61269 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3IISy6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Sep 2013 14:54:58 -0400
Received: by mail-wg0-f46.google.com with SMTP id k14so5570209wgh.13
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Sep 2013 11:54:57 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: don't ignore return value from cache_save_setup()
Date: Mon,  9 Sep 2013 19:54:38 +0100
Message-Id: <1378752878-32748-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent-tree.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 249cdb1..64efa83 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3284,6 +3284,8 @@ again:
 		err = cache_save_setup(cache, trans, path);
 		last = cache->key.objectid + cache->key.offset;
 		btrfs_put_block_group(cache);
+		if (err)
+			goto out;
 	}
 
 	while (1) {
-- 
1.7.9.5

