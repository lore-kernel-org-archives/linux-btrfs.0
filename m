Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:43544 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752151AbdKOPEn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 10:04:43 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] btrfs: ref-verify: Remove unused parameter from walk_up_tree() to kill warning
Date: Wed, 15 Nov 2017 16:04:40 +0100
Message-Id: <1510758280-6986-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With gcc-4.1.2:

    fs/btrfs/ref-verify.c: In function ‘btrfs_build_ref_tree’:
    fs/btrfs/ref-verify.c:1017: warning: ‘root’ is used uninitialized in this function

The variable is indeed passed uninitialized, but it is never used by the
callee.  However, not all versions of gcc are smart enough to notice.

Hence remove the unused parameter from walk_up_tree() to silence the
compiler warning.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/ref-verify.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index 34878699d363e641..171f3cce30e6badc 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -606,8 +606,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 }
 
 /* Walk up to the next node that needs to be processed */
-static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
-			int *level)
+static int walk_up_tree(struct btrfs_path *path, int *level)
 {
 	int l;
 
@@ -984,7 +983,6 @@ void btrfs_free_ref_tree_range(struct btrfs_fs_info *fs_info, u64 start,
 int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_path *path;
-	struct btrfs_root *root;
 	struct extent_buffer *eb;
 	u64 bytenr = 0, num_bytes = 0;
 	int ret, level;
@@ -1014,7 +1012,7 @@ int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info)
 				     &bytenr, &num_bytes);
 		if (ret)
 			break;
-		ret = walk_up_tree(root, path, &level);
+		ret = walk_up_tree(path, &level);
 		if (ret < 0)
 			break;
 		if (ret > 0) {
-- 
2.7.4

