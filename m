Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38251 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751157AbdGMNo7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 09:44:59 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 041BEACA4
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 13:44:58 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: drop newlines from strings when using btrfs_* helpers
Date: Thu, 13 Jul 2017 15:43:44 +0200
Message-Id: <20170713134344.6612-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helpers append "\n" so we can keep the actual strings shorter. The
extra newline will print an empty line.  Some messages have been
slightly modified to be more consistent with the rest (lowercase first
letter).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c      | 2 +-
 fs/btrfs/free-space-cache.c | 2 +-
 fs/btrfs/inode.c            | 2 +-
 fs/btrfs/qgroup.c           | 2 +-
 fs/btrfs/scrub.c            | 3 +--
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7aafb9043281..cb20390a101d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6836,7 +6836,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 		if (ret) {
 			const char *errstr = btrfs_decode_error(ret);
 			btrfs_warn(fs_info,
-				   "Discard failed while removing blockgroup: errno=%d %s\n",
+			   "discard failed while removing blockgroup: errno=%d %s",
 				   ret, errstr);
 		}
 	}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c5e6180cdb8c..cdc9f4015ec3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -709,7 +709,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 
 	if (!BTRFS_I(inode)->generation) {
 		btrfs_info(fs_info,
-			   "The free space cache file (%llu) is invalid. skip it\n",
+			   "the free space cache file (%llu) is invalid, skip it",
 			   offset);
 		return 0;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 89d37439b329..6b3b7152cb6c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8022,7 +8022,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
 
 	btrfs_debug(BTRFS_I(inode)->root->fs_info,
-		    "Repair DIO Read Error: submitting new dio read[%#x] to this_mirror=%d, in_validation=%d\n",
+		    "repair DIO read error: submitting new dio read[%#x] to this_mirror=%d, in_validation=%d",
 		    read_mode, failrec->this_mirror, failrec->in_validation);
 
 	ret = submit_dio_repair_bio(inode, bio, failrec->this_mirror);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index acb48983be26..ddc37c537058 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2646,7 +2646,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
 		btrfs_err(fs_info,
-			  "fail to start transaction for status update: %d\n",
+			  "fail to start transaction for status update: %d",
 			  err);
 		goto done;
 	}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0cebeb5eb5d0..18fa99782ad0 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3869,8 +3869,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			ro_set = 0;
 		} else {
 			btrfs_warn(fs_info,
-				   "failed setting block group ro, ret=%d\n",
-				   ret);
+				   "failed setting block group ro: %d", ret);
 			btrfs_put_block_group(cache);
 			break;
 		}
-- 
2.13.0

