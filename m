Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:46464 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdGOLAK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Jul 2017 07:00:10 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] btrfs: Refactor count handling in btrfs_unpin_free_ino()
Date: Sat, 15 Jul 2017 13:00:02 +0200
Message-Id: <1500116402-17103-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With gcc 4.1.2:

    fs/btrfs/inode-map.c: In function ‘btrfs_unpin_free_ino’:
    fs/btrfs/inode-map.c:254: warning: ‘count’ may be used uninitialized in this function

While this warning is a false-positive, it can easily be killed by
refactoring the code.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Please review. Compile-tested only.
---
 fs/btrfs/inode-map.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index d02019747d001d7b..5d98ac9a2a665bd4 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -257,8 +257,6 @@ void btrfs_unpin_free_ino(struct btrfs_root *root)
 		return;
 
 	while (1) {
-		bool add_to_ctl = true;
-
 		spin_lock(rbroot_lock);
 		n = rb_first(rbroot);
 		if (!n) {
@@ -270,15 +268,14 @@ void btrfs_unpin_free_ino(struct btrfs_root *root)
 		BUG_ON(info->bitmap); /* Logic error */
 
 		if (info->offset > root->ino_cache_progress)
-			add_to_ctl = false;
-		else if (info->offset + info->bytes > root->ino_cache_progress)
-			count = root->ino_cache_progress - info->offset + 1;
+			count = 0;
 		else
-			count = info->bytes;
+			count = min(root->ino_cache_progress - info->offset + 1,
+				    info->bytes);
 
 		rb_erase(&info->offset_index, rbroot);
 		spin_unlock(rbroot_lock);
-		if (add_to_ctl)
+		if (count)
 			__btrfs_add_free_space(root->fs_info, ctl,
 					       info->offset, count);
 		kmem_cache_free(btrfs_free_space_cachep, info);
-- 
2.7.4

