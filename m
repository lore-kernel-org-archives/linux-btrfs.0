Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:48221 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807AbaDINh7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 09:37:59 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so2492703wes.30
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Apr 2014 06:37:58 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: check if items are ordered when a leaf is marked dirty
Date: Wed,  9 Apr 2014 15:37:06 +0100
Message-Id: <1397054226-17950-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To ease finding bugs during development related to modifying btree leaves
in such a way that it makes its items not sorted by key anymore. Since this
is an expensive check, it's only enabled if CONFIG_BTRFS_FS_CHECK_INTEGRITY
is set, which isn't meant to be enabled for regular users.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/disk-io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d9698fd..8bf6628 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3695,6 +3695,12 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 		__percpu_counter_add(&root->fs_info->dirty_metadata_bytes,
 				     buf->len,
 				     root->fs_info->dirty_metadata_batch);
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+	if (btrfs_header_level(buf) == 0 && check_leaf(root, buf)) {
+		btrfs_print_leaf(root, buf);
+		ASSERT(0);
+	}
+#endif
 }
 
 static void __btrfs_btree_balance_dirty(struct btrfs_root *root,
-- 
1.9.1

