Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbaD2QDF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 12:03:05 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D5367AC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:03:04 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 14/14] btrfs-progs: move global reserve to overall summary
Date: Tue, 29 Apr 2014 18:03:03 +0200
Message-Id: <79ac9baac3701d9515d44b6a3724bca6be0d7842.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It looks confusing among the chunks, it is not in fact a chunk type.

Sample:
Overall:
    Device size:                  35.00GiB
    Device allocated:              8.07GiB
    Device unallocated:           26.93GiB
    Used:                          1.12MiB
    Free (Estimated):             17.57GiB      (Max: 30.98GiB, min: 17.52GiB)
    Data to device ratio:             50 %
    Global reserve:               16.00MiB      (used: 0.00B)
...

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-fi-disk_usage.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index d0b061ec7eb0..d8222d4d094d 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -319,6 +319,8 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	u64 total_free;		/* logical space un-used */
 	double K;
 	u64 raid5_used, raid6_used;
+	u64 global_reserve;
+	u64 global_reserve_used;
 
 	sargs = load_space_info(fd, path);
 	if (!sargs) {
@@ -341,6 +343,8 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	total_chunks = 0;
 	total_used = 0;
 	total_free = 0;
+	global_reserve = 0;
+	global_reserve_used = 0;
 
 	for (i = 0; i < sargs->total_spaces; i++) {
 		float ratio = 1;
@@ -366,6 +370,11 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		else
 			ratio = 1;
 
+		if (flags & BTRFS_SPACE_INFO_GLOBAL_RSV) {
+			global_reserve = sargs->spaces[i].total_bytes;
+			global_reserve_used = sargs->spaces[i].used_bytes;
+		}
+
 		allocated = sargs->spaces[i].total_bytes * ratio;
 
 		total_chunks += allocated;
@@ -404,6 +413,9 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		pretty_size_mode((total_disk-total_chunks) / 2 + total_free, mode));
 	printf("    Data to device ratio:\t%*.0f %%\n",
 		width - 2, K * 100);
+	printf("    Global reserve:\t\t%*s\t(used: %s)\n", width,
+		pretty_size_mode(global_reserve, mode),
+		pretty_size_mode(global_reserve_used, mode));
 
 exit:
 
@@ -553,8 +565,11 @@ static void _cmd_filesystem_usage_tabular(int mode,
 	/* header */
 	for (i = 0; i < sargs->total_spaces; i++) {
 		const char *description;
-
 		u64 flags = sargs->spaces[i].flags;
+
+		if (flags & BTRFS_SPACE_INFO_GLOBAL_RSV)
+			continue;
+
 		description = group_type_str(flags);
 
 		table_printf(matrix, 1+i, 0, "<%s", description);
@@ -715,8 +730,11 @@ static void _cmd_filesystem_usage_linear(int mode,
 	for (i = 0; i < sargs->total_spaces; i++) {
 		const char *description;
 		const char *r_mode;
-
 		u64 flags = sargs->spaces[i].flags;
+
+		if (flags & BTRFS_SPACE_INFO_GLOBAL_RSV)
+			continue;
+
 		description= group_type_str(flags);
 		r_mode = group_profile_str(flags);
 
-- 
1.9.0

