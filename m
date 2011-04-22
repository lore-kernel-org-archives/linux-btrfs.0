From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix missing mutex_unlock in btrfs_del_dir_entries_in_log()
Date: Fri, 22 Apr 2011 18:05:40 +0900
Message-ID: <201104220905.AA00017@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It is necessary to unlock mutex_lock before it return an error when
btrfs_alloc_path() fails.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/tree-log.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c50271a..f997ec0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2209,8 +2209,10 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 
 	log = root->log_root;
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
 
 	di = btrfs_lookup_dir_item(trans, log, path, dir->i_ino,
 				   name, name_len, -1);
@@ -2271,6 +2273,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	}
 fail:
 	btrfs_free_path(path);
+out_unlock:
 	mutex_unlock(&BTRFS_I(dir)->log_mutex);
 	if (ret == -ENOSPC) {
 		root->fs_info->last_trans_log_full_commit = trans->transid;

