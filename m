Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59118 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754059AbaI2Qjv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 12:39:51 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8TGT2VS023012
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Sep 2014 09:39:50 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1ppxqg1ux8-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Sep 2014 09:39:50 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: add root to dirty list when fixing bad keys
Date: Mon, 29 Sep 2014 12:39:46 -0400
Message-ID: <1412008786-3023-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a WARN_ON() when trying to run btrfsck --repair on his fs with
bad key ordering.  This was because the root that was broken wasn't part of the
transaction yet.  We do this open coded thing in a few other places in fsck, so
just make it a helper function and make sure all the places that need to call it
do call it.  With this patch he was able to run repair without it dying.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index d479361..4c01330 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -243,6 +243,17 @@ struct bad_item {
 
 static void reset_cached_block_groups(struct btrfs_fs_info *fs_info);
 
+static void record_root_in_trans(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root)
+{
+	if (root->last_trans != trans->transid) {
+		root->track_dirty = 1;
+		root->last_trans = trans->transid;
+		root->commit_root = root->node;
+		extent_buffer_get(root->node);
+	}
+}
+
 static u8 imode_to_type(u32 imode)
 {
 #define S_SHIFT 12
@@ -2429,6 +2440,8 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 	if (IS_ERR(root))
 		return -EIO;
 
+	record_root_in_trans(trans, root);
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -EIO;
@@ -4667,12 +4680,7 @@ static int repair_ref(struct btrfs_trans_handle *trans,
 	 * Have to make sure that this root gets updated when we commit the
 	 * transaction
 	 */
-	root->track_dirty = 1;
-	if (root->last_trans != trans->transid) {
-		root->last_trans = trans->transid;
-		root->commit_root = root->node;
-		extent_buffer_get(root->node);
-	}
+	record_root_in_trans(trans, root);
 
 	/*
 	 * Ok we have the key of the file extent we want to fix, now we can cow
@@ -6352,12 +6360,7 @@ reinit_data_reloc:
 		fprintf(stderr, "Error reading data reloc tree\n");
 		return PTR_ERR(root);
 	}
-	root->track_dirty = 1;
-	if (root->last_trans != trans->transid) {
-		root->last_trans = trans->transid;
-		root->commit_root = root->node;
-		extent_buffer_get(root->node);
-	}
+	record_root_in_trans(trans, root);
 	ret = btrfs_fsck_reinit_root(trans, root, 0);
 	if (ret)
 		goto out;
-- 
1.8.3.1

