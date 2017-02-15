Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34403 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdBOPv5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 10:51:57 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 8/7] btrfs: ulist: rename ulist_fini to ulist_release
Date: Wed, 15 Feb 2017 16:51:19 +0100
Message-Id: <20170215155119.19983-1-dsterba@suse.com>
In-Reply-To: <cover.1486995885.git.dsterba@suse.com>
References: <cover.1486995885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change the name so it matches the naming we already use eg. for
btrfs_path.

Suggested-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c |  8 ++++----
 fs/btrfs/ulist.c  | 10 +++++-----
 fs/btrfs/ulist.h  |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 052f1410dc14..5d53e948a28d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2834,7 +2834,7 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
 	if (ret < 0)
 		goto cleanup;
 
-	ulist_fini(&changeset.range_changed);
+	ulist_release(&changeset.range_changed);
 	return ret;
 
 cleanup:
@@ -2844,7 +2844,7 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, unode->val,
 				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL,
 				 GFP_NOFS);
-	ulist_fini(&changeset.range_changed);
+	ulist_release(&changeset.range_changed);
 	return ret;
 }
 
@@ -2871,7 +2871,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
 	trace_btrfs_qgroup_release_data(inode, start, len,
 					changeset.bytes_changed, trace_op);
 out:
-	ulist_fini(&changeset.range_changed);
+	ulist_release(&changeset.range_changed);
 	return ret;
 }
 
@@ -2986,5 +2986,5 @@ void btrfs_qgroup_check_reserved_leak(struct inode *inode)
 				changeset.bytes_changed);
 
 	}
-	ulist_fini(&changeset.range_changed);
+	ulist_release(&changeset.range_changed);
 }
diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 5deee56434fc..d8edf164f81c 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -52,13 +52,13 @@ void ulist_init(struct ulist *ulist)
 }
 
 /**
- * ulist_fini - free up additionally allocated memory for the ulist
+ * ulist_release - free up additionally allocated memory for the ulist
  * @ulist:	the ulist from which to free the additional memory
  *
  * This is useful in cases where the base 'struct ulist' has been statically
  * allocated.
  */
-void ulist_fini(struct ulist *ulist)
+void ulist_release(struct ulist *ulist)
 {
 	struct ulist_node *node;
 	struct ulist_node *next;
@@ -79,7 +79,7 @@ void ulist_fini(struct ulist *ulist)
  */
 void ulist_reinit(struct ulist *ulist)
 {
-	ulist_fini(ulist);
+	ulist_release(ulist);
 	ulist_init(ulist);
 }
 
@@ -105,13 +105,13 @@ struct ulist *ulist_alloc(gfp_t gfp_mask)
  * ulist_free - free dynamically allocated ulist
  * @ulist:	ulist to free
  *
- * It is not necessary to call ulist_fini before.
+ * It is not necessary to call ulist_release before.
  */
 void ulist_free(struct ulist *ulist)
 {
 	if (!ulist)
 		return;
-	ulist_fini(ulist);
+	ulist_release(ulist);
 	kfree(ulist);
 }
 
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 1a4130443d7e..53c913632733 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -44,7 +44,7 @@ struct ulist {
 };
 
 void ulist_init(struct ulist *ulist);
-void ulist_fini(struct ulist *ulist);
+void ulist_release(struct ulist *ulist);
 void ulist_reinit(struct ulist *ulist);
 struct ulist *ulist_alloc(gfp_t gfp_mask);
 void ulist_free(struct ulist *ulist);
-- 
2.10.1

