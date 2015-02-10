Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42012 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754963AbbBJK1Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:25 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQdtV000932
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:39 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: qgroup: fix a wrong parameter of no_quota.
Date: Tue, 10 Feb 2015 18:24:05 +0800
Message-ID: <1423563845-9103-4-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In function of __btrfs_mod_ref(), we are passing the no_quota=1
to process_func() anyway. It will make the numbers in qgroup be
wrong when deleting a subvolume. The data size in a deleted subvolume
will never be decressed from all related qgroups.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 652be74..f59809c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3056,6 +3056,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int i;
 	int level;
 	int ret = 0;
+	int no_quota = 0;
 	int (*process_func)(struct btrfs_trans_handle *, struct btrfs_root *,
 			    u64, u64, u64, u64, u64, u64, int);
 
@@ -3080,6 +3081,9 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	else
 		parent = 0;
 
+	if (!root->fs_info->quota_enabled || !is_fstree(ref_root))
+		no_quota = 1;
+
 	for (i = 0; i < nritems; i++) {
 		if (level == 0) {
 			btrfs_item_key_to_cpu(buf, &key, i);
@@ -3098,7 +3102,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			key.offset -= btrfs_file_extent_offset(buf, fi);
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, key.objectid,
-					   key.offset, 1);
+					   key.offset, no_quota);
 			if (ret)
 				goto fail;
 		} else {
@@ -3106,7 +3110,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			num_bytes = root->nodesize;
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, level - 1, 0,
-					   1);
+					   no_quota);
 			if (ret)
 				goto fail;
 		}
-- 
1.8.4.2

