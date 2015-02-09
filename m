Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7671 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760850AbbBIUDp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:45 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 10/16] Btrfs-progs: only build space info's for the main flags
Date: Mon, 9 Feb 2015 15:03:13 -0500
Message-ID: <1423512199-16552-11-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hitting enospc problems with a really corrupt fs uncovered the fact that we
match any flag in a block group when creating space info's.  This is a problem
if we have a raid level set, we'll end up with only one space info that covers
metadata and data because they share a raid level.  We don't want this, we want
to separate out the data and metadata space infos, so mask off the raid level
and only use the main flags.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 extent-tree.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 1785e22..d42c572 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1789,11 +1789,11 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 						  u64 flags)
 {
-	struct list_head *head = &info->space_info;
-	struct list_head *cur;
 	struct btrfs_space_info *found;
-	list_for_each(cur, head) {
-		found = list_entry(cur, struct btrfs_space_info, list);
+
+	flags &= BTRFS_BLOCK_GROUP_TYPE_MASK;
+
+	list_for_each_entry(found, &info->space_info, list) {
 		if (found->flags & flags)
 			return found;
 	}
@@ -1825,7 +1825,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 		return -ENOMEM;
 
 	list_add(&found->list, &info->space_info);
-	found->flags = flags;
+	found->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
 	found->total_bytes = total_bytes;
 	found->bytes_used = bytes_used;
 	found->bytes_pinned = 0;
-- 
1.8.3.1

