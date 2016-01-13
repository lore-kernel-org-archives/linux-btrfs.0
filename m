Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327AbcAMMEW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 07:04:22 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id EA749AAB2
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jan 2016 12:04:19 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: fi usage: support mixed blockgroups
Date: Wed, 13 Jan 2016 13:04:14 +0100
Message-Id: <1452686654-801-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Properly account the duplicated block groups and global reserve.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-fi-usage.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 0299fcc1339b..33bf403af569 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -337,6 +337,7 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	u64 free_estimated = 0;
 	u64 free_min = 0;
 	int max_data_ratio = 1;
+	int mixed = 0;
 
 	sargs = load_space_info(fd, path);
 	if (!sargs) {
@@ -394,10 +395,9 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 			l_global_reserve_used = sargs->spaces[i].used_bytes;
 		}
 		if ((flags & (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA))
-			== (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA)) {
-			warning("MIXED blockgroups not handled");
+		    == (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA)) {
+			mixed = 1;
 		}
-
 		if (flags & BTRFS_BLOCK_GROUP_DATA) {
 			r_data_used += sargs->spaces[i].used_bytes * ratio;
 			r_data_chunks += sargs->spaces[i].total_bytes * ratio;
@@ -414,13 +414,20 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		}
 	}
 
-	r_total_chunks = r_data_chunks + r_metadata_chunks + r_system_chunks;
-	r_total_used = r_data_used + r_metadata_used + r_system_used;
+	r_total_chunks = r_data_chunks + r_system_chunks;
+	r_total_used = r_data_used + r_system_used;
+	if (!mixed) {
+		r_total_chunks += r_metadata_chunks;
+		r_total_used += r_metadata_used;
+	}
 	r_total_unused = r_total_size - r_total_chunks;
 
 	/* Raw / Logical = raid factor, >= 1 */
 	data_ratio = (double)r_data_chunks / l_data_chunks;
-	metadata_ratio = (double)r_metadata_chunks / l_metadata_chunks;
+	if (mixed)
+		metadata_ratio = data_ratio;
+	else
+		metadata_ratio = (double)r_metadata_chunks / l_metadata_chunks;
 
 #if 0
 	/* add the raid5/6 allocated space */
@@ -437,6 +444,13 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	 * In non-mixed case there's no difference.
 	 */
 	free_estimated = (r_data_chunks - r_data_used) / data_ratio;
+	/*
+	 * For mixed-bg the metadata are left out in calculations thus global
+	 * reserve would be lost. Part of it could be permanently allocated,
+	 * we have to subtract the used bytes so we don't go under zero free.
+	 */
+	if (mixed)
+		free_estimated -= l_global_reserve - l_global_reserve_used;
 	free_min = free_estimated;
 
 	/* Chop unallocatable space */
-- 
2.6.3

