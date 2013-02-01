Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:58470 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab3BAUKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 15:10:18 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id aA5D7WgT5zC3eD8X (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 01 Feb 2013 13:10:17 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: handle errors reading fs roots
Date: Fri, 1 Feb 2013 15:17:07 -0500
Message-ID: <1359749827-12656-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user had a problem where btrfsck would bail out because it was finding
extents for a snapshot that had been deleted but not entirely cleaned up.
We can handle this case fine, we just need to report an error properly.
This patch allowed btrfsck to continue and eventually fix his file system.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfsck.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index a851008..ff2d7b5 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -1772,6 +1772,10 @@ static int check_fs_roots(struct btrfs_root *root,
 		    fs_root_objectid(key.objectid)) {
 			tmp_root = btrfs_read_fs_root_no_cache(root->fs_info,
 							       &key);
+			if (IS_ERR(tmp_root)) {
+				err = 1;
+				goto next;
+			}
 			ret = check_fs_root(tmp_root, root_cache, &wc);
 			if (ret)
 				err = 1;
@@ -1781,6 +1785,7 @@ static int check_fs_roots(struct btrfs_root *root,
 			process_root_ref(leaf, path.slots[0], &key,
 					 root_cache);
 		}
+next:
 		path.slots[0]++;
 	}
 	btrfs_release_path(tree_root, &path);
@@ -1940,7 +1945,8 @@ static int check_owner_ref(struct btrfs_root *root,
 	key.offset = (u64)-1;
 
 	ref_root = btrfs_read_fs_root(root->fs_info, &key);
-	BUG_ON(IS_ERR(ref_root));
+	if (IS_ERR(ref_root))
+		return 1;
 
 	level = btrfs_header_level(buf);
 	if (level == 0)
-- 
1.7.7.6

