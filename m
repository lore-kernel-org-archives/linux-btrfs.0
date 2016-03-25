Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34102 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038AbcCYR0O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:14 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u2PHKiC8024623
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:13 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 21w972051p-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:13 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/14] Btrfs: warn_on for unaccounted spaces
Date: Fri, 25 Mar 2016 13:25:51 -0400
Message-ID: <1458926760-17563-6-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These were hidden behind enospc_debug, which isn't helpful as they indicate
actual bugs, unlike the rest of the enospc_debug stuff which is really debug
information.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 157a0b6..90ac821 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9633,13 +9633,15 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		space_info = list_entry(info->space_info.next,
 					struct btrfs_space_info,
 					list);
-		if (btrfs_test_opt(info->tree_root, ENOSPC_DEBUG)) {
-			if (WARN_ON(space_info->bytes_pinned > 0 ||
+
+		/*
+		 * Do not hide this behind enospc_debug, this is actually
+		 * important and indicates a real bug if this happens.
+		 */
+		if (WARN_ON(space_info->bytes_pinned > 0 ||
 			    space_info->bytes_reserved > 0 ||
-			    space_info->bytes_may_use > 0)) {
-				dump_space_info(space_info, 0, 0);
-			}
-		}
+			    space_info->bytes_may_use > 0))
+			dump_space_info(space_info, 0, 0);
 		list_del(&space_info->list);
 		for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 			struct kobject *kobj;
-- 
2.5.0

