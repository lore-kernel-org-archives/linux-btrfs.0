Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46317 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab3J1Rj3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 13:39:29 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so6843411wgg.4
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 10:39:28 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: log recovery, don't unlink inode always on error
Date: Mon, 28 Oct 2013 17:39:21 +0000
Message-Id: <1382981961-18260-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we get any error while doing a dir index/item lookup in the
log tree, we were always unlinking the corresponding inode in
the subvolume. It makes sense to unlink only if the lookup failed
to find the dir index/item, which corresponds to NULL or -ENOENT,
and not when other errors happen (like a transient -ENOMEM or -EIO).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/tree-log.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index d75303e..2990fa4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1832,7 +1832,7 @@ again:
 						     dir_key->offset,
 						     name, name_len, 0);
 		}
-		if (IS_ERR_OR_NULL(log_di)) {
+		if (!log_di || (IS_ERR(log_di) && PTR_ERR(log_di) == -ENOENT)) {
 			btrfs_dir_item_key_to_cpu(eb, di, &location);
 			btrfs_release_path(path);
 			btrfs_release_path(log_path);
@@ -1869,6 +1869,9 @@ again:
 				goto again;
 			ret = 0;
 			goto out;
+		} else if (IS_ERR(log_di)) {
+			kfree(name);
+			return PTR_ERR(log_di);
 		}
 		btrfs_release_path(log_path);
 		kfree(name);
-- 
1.7.9.5

