Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:61853 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751073AbdKFIFD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 03:05:03 -0500
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] btrfs/volumes: Improve unlocking of a mutex in
 __btrfs_balance()
Message-ID: <d7bcebed-b68f-6137-24df-9332ef1de802@users.sourceforge.net>
Date: Mon, 6 Nov 2017 09:04:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 5 Nov 2017 22:03:22 +0100

* Adjust jump targets so that a call of the function "mutex_unlock"
  can be better reused for error cases at the end of this function.

* Replace three calls by goto statements.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/btrfs/volumes.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ea8b20839ac0..3bc430623849 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3497,7 +3497,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		if (ret) {
 			/* btrfs_shrink_device never returns ret > 0 */
 			WARN_ON(ret > 0);
-			goto error;
+			goto free_path;
 		}
 
 		trans = btrfs_start_transaction(dev_root, 0);
@@ -3507,7 +3507,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		 "resize: unable to start transaction after shrinking device %s (error %d), old size %llu, new size %llu",
 					  rcu_str_deref(device->name), ret,
 					  old_size, old_size - size_to_free);
-			goto error;
+			goto free_path;
 		}
 
 		ret = btrfs_grow_device(trans, device, old_size);
@@ -3519,7 +3519,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		 "resize: unable to grow device after shrinking device %s (error %d), old size %llu, new size %llu",
 					  rcu_str_deref(device->name), ret,
 					  old_size, old_size - size_to_free);
-			goto error;
+			goto free_path;
 		}
 
 		btrfs_end_transaction(trans);
@@ -3529,7 +3529,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
-		goto error;
+		goto free_path;
 	}
 
 	/* zero out stat counters */
@@ -3554,15 +3554,13 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		if ((!counting && atomic_read(&fs_info->balance_pause_req)) ||
 		    atomic_read(&fs_info->balance_cancel_req)) {
 			ret = -ECANCELED;
-			goto error;
+			goto free_path;
 		}
 
 		mutex_lock(&fs_info->delete_unused_bgs_mutex);
 		ret = btrfs_search_slot(NULL, chunk_root, &key, path, 0, 0);
-		if (ret < 0) {
-			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
-			goto error;
-		}
+		if (ret < 0)
+			goto unlock;
 
 		/*
 		 * this shouldn't happen, it means the last relocate
@@ -3645,25 +3643,23 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		    !chunk_reserved && !bytes_used) {
 			trans = btrfs_start_transaction(chunk_root, 0);
 			if (IS_ERR(trans)) {
-				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 				ret = PTR_ERR(trans);
-				goto error;
+				goto unlock;
 			}
 
 			ret = btrfs_force_chunk_alloc(trans, fs_info,
 						      BTRFS_BLOCK_GROUP_DATA);
 			btrfs_end_transaction(trans);
-			if (ret < 0) {
-				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
-				goto error;
-			}
+			if (ret < 0)
+				goto unlock;
+
 			chunk_reserved = 1;
 		}
 
 		ret = btrfs_relocate_chunk(fs_info, found_key.offset);
 		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 		if (ret && ret != -ENOSPC)
-			goto error;
+			goto free_path;
 		if (ret == -ENOSPC) {
 			enospc_errors++;
 		} else {
@@ -3682,7 +3678,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		counting = false;
 		goto again;
 	}
-error:
+free_path:
 	btrfs_free_path(path);
 	if (enospc_errors) {
 		btrfs_info(fs_info, "%d enospc errors during balance",
@@ -3692,6 +3688,10 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	}
 
 	return ret;
+
+unlock:
+	mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+	goto free_path;
 }
 
 /**
-- 
2.15.0

