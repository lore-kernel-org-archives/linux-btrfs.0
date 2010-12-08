From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fixup return code for btrfs_del_orphan_item
Date: Wed,  8 Dec 2010 12:23:49 -0500
Message-ID: <1291829029-22189-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If the orphan item doesn't exist, we return 1, which doesn't make any sense to
the callers.  Instead return -ENOENT if we didn't find the item.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/orphan.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/orphan.c b/fs/btrfs/orphan.c
index 79cba5f..f8be250 100644
--- a/fs/btrfs/orphan.c
+++ b/fs/btrfs/orphan.c
@@ -56,8 +56,12 @@ int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret)
+	if (ret < 0)
 		goto out;
+	if (ret) {
+		ret = -ENOENT;
+		goto out;
+	}
 
 	ret = btrfs_del_item(trans, root, path);
 
-- 
1.6.6.1

