From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] btrfs: fix locking issues in find_parent_nodes()
Date: Thu, 01 Mar 2012 14:43:51 +0800
Message-ID: <4F4F1AA7.3040407@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

- We might unlock head->mutex while it was not locked
- We might leave the function without unlocking delayed_refs->lock

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/backref.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 98f6bf10..0436c12 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -583,7 +583,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct btrfs_key info_key = { 0 };
 	struct btrfs_delayed_ref_root *delayed_refs = NULL;
-	struct btrfs_delayed_ref_head *head = NULL;
+	struct btrfs_delayed_ref_head *head;
 	int info_level = 0;
 	int ret;
 	struct list_head prefs_delayed;
@@ -607,6 +607,8 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	 * at a specified point in time
 	 */
 again:
+	head = NULL;
+
 	ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
@@ -635,8 +637,10 @@ again:
 			goto again;
 		}
 		ret = __add_delayed_refs(head, seq, &info_key, &prefs_delayed);
-		if (ret)
+		if (ret) {
+			spin_unlock(&delayed_refs->lock);
 			goto out;
+		}
 	}
 	spin_unlock(&delayed_refs->lock);
 
-- 
1.7.3.1

