Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63051 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108AbcCYR0U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:20 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u2PHKiM0021138
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:20 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0089730.ppops.net with ESMTP id 21vva22whj-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:20 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/14] Btrfs: trace pinned extents
Date: Fri, 25 Mar 2016 13:25:54 -0400
Message-ID: <1458926760-17563-9-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pinned extents are an important metric to keep track of for enospc.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1673365..26f7a9d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6168,6 +6168,9 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 
+			trace_btrfs_space_reservation(root->fs_info, "pinned",
+						      cache->space_info->flags,
+						      num_bytes, 1);
 			set_extent_dirty(info->pinned_extents,
 					 bytenr, bytenr + num_bytes - 1,
 					 GFP_NOFS | __GFP_NOFAIL);
@@ -6242,6 +6245,8 @@ static int pin_down_extent(struct btrfs_root *root,
 	spin_unlock(&cache->lock);
 	spin_unlock(&cache->space_info->lock);
 
+	trace_btrfs_space_reservation(root->fs_info, "pinned",
+				      cache->space_info->flags, num_bytes, 1);
 	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
 			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
 	if (reserved)
@@ -6549,6 +6554,9 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end,
 		spin_lock(&cache->lock);
 		cache->pinned -= len;
 		space_info->bytes_pinned -= len;
+
+		trace_btrfs_space_reservation(fs_info, "pinned",
+					      space_info->flags, len, 0);
 		space_info->max_extent_size = 0;
 		percpu_counter_add(&space_info->total_bytes_pinned, -len);
 		if (cache->ro) {
-- 
2.5.0

