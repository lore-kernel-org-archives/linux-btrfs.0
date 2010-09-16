From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix memory leak on free root
Date: Thu, 16 Sep 2010 11:23:46 +0800
Message-ID: <4C918DC2.7080701@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On free root, name field should be freed too.


Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c     |    1 +
 fs/btrfs/extent-tree.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 280de15..fe20248 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2335,6 +2335,7 @@ static int del_fs_roots(struct btrfs_fs_info *fs_info)
 		} else {
 			free_extent_buffer(gang[0]->node);
 			free_extent_buffer(gang[0]->commit_root);
+			kfree(gang[0]->name);
 			kfree(gang[0]);
 		}
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f631910..83c422c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6019,6 +6019,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	} else {
 		free_extent_buffer(root->node);
 		free_extent_buffer(root->commit_root);
+		kfree(root->name);
 		kfree(root);
 	}
 out:
-- 
1.6.2.5
