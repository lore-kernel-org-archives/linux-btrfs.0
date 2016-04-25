Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58591 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932143AbcDYN66 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 09:58:58 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u3PDuHRb009065
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 06:58:57 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0089730.ppops.net with ESMTP id 22hjbk8spn-4
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 06:58:57 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: use root when checking need_async_flush
Date: Mon, 25 Apr 2016 09:58:18 -0400
Message-ID: <1461592698-30772-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of doing fs_info->fs_root in need_async_flush, which may not be set
during recovery when mounting, just pass the root itself in, which makes more
sense as thats what btrfs_calc_reclaim_metadata_size takes.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f23f426..e760cf7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4872,7 +4872,7 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_root *root,
 }
 
 static inline int need_do_async_reclaim(struct btrfs_space_info *space_info,
-					struct btrfs_fs_info *fs_info, u64 used)
+					struct btrfs_root *root, u64 used)
 {
 	u64 thresh = div_factor_fine(space_info->total_bytes, 98);
 
@@ -4880,11 +4880,12 @@ static inline int need_do_async_reclaim(struct btrfs_space_info *space_info,
 	if ((space_info->bytes_used + space_info->bytes_reserved) >= thresh)
 		return 0;
 
-	if (!btrfs_calc_reclaim_metadata_size(fs_info->fs_root, space_info))
+	if (!btrfs_calc_reclaim_metadata_size(root, space_info))
 		return 0;
 
-	return (used >= thresh && !btrfs_fs_closing(fs_info) &&
-		!test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state));
+	return (used >= thresh && !btrfs_fs_closing(root->fs_info) &&
+		!test_bit(BTRFS_FS_STATE_REMOUNTING,
+			  &root->fs_info->fs_state));
 }
 
 static void wake_all_tickets(struct list_head *head)
@@ -5129,7 +5130,7 @@ static int __reserve_metadata_bytes(struct btrfs_root *root,
 		 * the async reclaim as we will panic.
 		 */
 		if (!root->fs_info->log_root_recovering &&
-		    need_do_async_reclaim(space_info, root->fs_info, used) &&
+		    need_do_async_reclaim(space_info, root, used) &&
 		    !work_busy(&root->fs_info->async_reclaim_work)) {
 			trace_btrfs_trigger_flush(root->fs_info,
 						  space_info->flags,
-- 
2.5.0

