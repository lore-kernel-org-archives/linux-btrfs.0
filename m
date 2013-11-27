Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43112 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab3K0QGY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 11:06:24 -0500
Received: by mail-wg0-f48.google.com with SMTP id z12so6866408wgg.3
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 08:06:23 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix max dir item size calculation
Date: Wed, 27 Nov 2013 16:06:16 +0000
Message-Id: <1385568376-21059-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were accounting for sizeof(struct btrfs_item) twice, once
in the data_size variable and another time in the if statement
below.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/dir-item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c031ea3..9a89ceb 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -261,7 +261,7 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 	 * see if there is room in the item to insert this
 	 * name
 	 */
-	data_size = sizeof(*di) + name_len + sizeof(struct btrfs_item);
+	data_size = sizeof(*di) + name_len;
 	leaf = path->nodes[0];
 	slot = path->slots[0];
 	if (data_size + btrfs_item_size_nr(leaf, slot) +
-- 
1.7.9.5

