From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 4/4] Btrfs: fix a bug on overcommit stuff
Date: Thu, 16 Feb 2012 18:34:39 +0800
Message-ID: <1329388479-31341-4-git-send-email-liubo2009@cn.fujitsu.com>
References: <1329388479-31341-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1329388479-31341-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

When overcommitting, we should check the sum of pinned space and
bytes for delayed item.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 283af7a..e4a67c9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3611,12 +3611,15 @@ static int may_commit_transaction(struct btrfs_root *root,
 	if (space_info != delayed_rsv->space_info)
 		return -ENOSPC;
 
+	spin_lock(&space_info->lock);
 	spin_lock(&delayed_rsv->lock);
-	if (delayed_rsv->size < bytes) {
+	if (space_info->bytes_pinned + delayed_rsv->size < bytes) {
 		spin_unlock(&delayed_rsv->lock);
+		spin_unlock(&space_info->lock);
 		return -ENOSPC;
 	}
 	spin_unlock(&delayed_rsv->lock);
+	spin_unlock(&space_info->lock);
 
 commit:
 	trans = btrfs_join_transaction(root);
-- 
1.6.5.2

