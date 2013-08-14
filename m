Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48809 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061Ab3HNCAm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 22:00:42 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so7029028wgg.4
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 19:00:40 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/2] Btrfs: don't miss inode ref items in BTRFS_IOC_INO_LOOKUP
Date: Wed, 14 Aug 2013 03:00:21 +0100
Message-Id: <1376445621-18561-3-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1376445621-18561-1-git-send-email-fdmanana@gmail.com>
References: <1376445621-18561-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the inode ref key was not found and the current leaf slot
was 0 (first item in the leaf) the code would always return
-ENOENT. This was not correct because the desired inode ref
item might be the last item in the previous leaf.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3f2a8c1..e8f295c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1998,19 +1998,21 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;
+		else if (ret > 0) {
+			ret = btrfs_previous_item(root, path, dirid,
+						  BTRFS_INODE_REF_KEY);
+			if (ret < 0)
+				goto out;
+			else if (ret > 0) {
+				ret = -ENOENT;
+				goto out;
+			}
+		}
 
 		l = path->nodes[0];
 		slot = path->slots[0];
-		if (ret > 0 && slot > 0)
-			slot--;
 		btrfs_item_key_to_cpu(l, &key, slot);
 
-		if (ret > 0 && (key.objectid != dirid ||
-				key.type != BTRFS_INODE_REF_KEY)) {
-			ret = -ENOENT;
-			goto out;
-		}
-
 		iref = btrfs_item_ptr(l, slot, struct btrfs_inode_ref);
 		len = btrfs_inode_ref_name_len(l, iref);
 		ptr -= len + 1;
-- 
1.7.9.5

