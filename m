Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54660 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab3HXSvW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 14:51:22 -0400
Received: by mail-wg0-f46.google.com with SMTP id k13so1520190wgh.1
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Aug 2013 11:51:21 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix memory leak of uuid_root in free_fs_info
Date: Sat, 24 Aug 2013 19:51:06 +0100
Message-Id: <1377370266-31989-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c90be01..742dea1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3460,6 +3460,7 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->dev_root);
 	kfree(fs_info->csum_root);
 	kfree(fs_info->quota_root);
+	kfree(fs_info->uuid_root);
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
 	kfree(fs_info);
-- 
1.7.9.5

