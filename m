Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20403 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337AbaAWXqq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 18:46:46 -0500
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s0NNiwmd028679
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 15:46:45 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0a-00082601.pphosted.com with ESMTP id 1hk8de12bm-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 15:46:45 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix qgroup rescan to work with skinny metadata V2
Date: Thu, 23 Jan 2014 18:46:42 -0500
Message-ID: <1390520802-17483-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Could have sworn I fixed this before but apparently not.  This makes us pass
btrfs/022 with skinny metadata enabled.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: use && instead of ||

 fs/btrfs/qgroup.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d22e0a1..472302a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1897,9 +1897,17 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
 	for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
+		u64 num_bytes;
+
 		btrfs_item_key_to_cpu(scratch_leaf, &found, slot);
-		if (found.type != BTRFS_EXTENT_ITEM_KEY)
+		if (found.type != BTRFS_EXTENT_ITEM_KEY &&
+		    found.type != BTRFS_METADATA_ITEM_KEY)
 			continue;
+		if (found.type == BTRFS_METADATA_ITEM_KEY)
+			num_bytes = fs_info->extent_root->leafsize;
+		else
+			num_bytes = found.offset;
+
 		ret = btrfs_find_all_roots(trans, fs_info, found.objectid,
 					   tree_mod_seq_elem.seq, &roots);
 		if (ret < 0)
@@ -1944,12 +1952,12 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 			struct btrfs_qgroup_list *glist;
 
 			qg = (struct btrfs_qgroup *)(uintptr_t) unode->aux;
-			qg->rfer += found.offset;
-			qg->rfer_cmpr += found.offset;
+			qg->rfer += num_bytes;
+			qg->rfer_cmpr += num_bytes;
 			WARN_ON(qg->tag >= seq);
 			if (qg->refcnt - seq == roots->nnodes) {
-				qg->excl += found.offset;
-				qg->excl_cmpr += found.offset;
+				qg->excl += num_bytes;
+				qg->excl_cmpr += num_bytes;
 			}
 			qgroup_dirty(fs_info, qg);
 
-- 
1.8.3.1

