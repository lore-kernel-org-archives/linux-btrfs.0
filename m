Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737AbcG1LR3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 07:17:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3DC16ACAB
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 11:17:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: fi defrag: change default extent target size to 32 MiB
Date: Thu, 28 Jul 2016 13:17:09 +0200
Message-Id: <1469704629-25512-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel default is too low, 32 MiB is recommended and should give
better results.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 Documentation/btrfs-filesystem.asciidoc | 16 ++++++++++++----
 cmds-filesystem.c                       | 11 +++++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index 8fb15eacafc9..28e772466cfa 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -117,15 +117,23 @@ compression. See also section 'EXAMPLES'.
 -r::::
 defragment files recursively in given directories
 -f::::
-flush data for each file before going to the next file. This will limit the amount
-of dirty data to current file, otherwise the amount cumulates from several files
-and may increase system load.
+flush data for each file before going to the next file.
++
+This will limit the amount of dirty data to current file, otherwise the amount
+cumulates from several files and will increase system load. This can also lead
+to ENOSPC if there's too much dirty data to write and it's not possible to make
+the reservations for the new data (ie. how the COW design works).
++
 -s <start>[kKmMgGtTpPeE]::::
 defragmentation will start from the given offset, default is beginning of a file
 -l <len>[kKmMgGtTpPeE]::::
 defragment only up to 'len' bytes, default is the file size
 -t <size>[kKmMgGtTpPeE]::::
-target extent size, do not touch extents bigger than 'size'
+target extent size, do not touch extents bigger than 'size', default: 32 MiB
++
+The value is only advisory and the final size of the extents may differ,
+depending on the state of the free space and fragmentation or other internal
+logic. Reasonable values are from tens to hundreds of megabytes.
 
 *du* [options] <path> [<path>..]::
 Calculate disk usage of the target files using FIEMAP. For individual
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index ef1f550b51c0..6b381c582ea7 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -968,7 +968,7 @@ static const char * const cmd_filesystem_defrag_usage[] = {
 	"-f             flush data to disk immediately after defragmenting",
 	"-s start       defragment only from byte onward",
 	"-l len         defragment only up to len bytes",
-	"-t size        target extent size hint",
+	"-t size        target extent size hint (default: 32 MiB)",
 	NULL
 };
 
@@ -1029,7 +1029,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	int flush = 0;
 	u64 start = 0;
 	u64 len = (u64)-1;
-	u64 thresh = 0;
+	u64 thresh;
 	int i;
 	int recursive = 0;
 	int ret = 0;
@@ -1037,6 +1037,13 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	int compress_type = BTRFS_COMPRESS_NONE;
 	DIR *dirstream;
 
+	/*
+	 * Kernel has a different default (256K) that is supposed to be safe,
+	 * but it does not defragment very well. The 32M will likely lead to
+	 * better results and is independent of the kernel default.
+	 */
+	thresh = 32 * 1024 * 1024;
+
 	defrag_global_errors = 0;
 	defrag_global_verbose = 0;
 	defrag_global_errors = 0;
-- 
2.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
