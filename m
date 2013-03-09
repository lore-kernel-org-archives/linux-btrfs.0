Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52360 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3CIVHX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 16:07:23 -0500
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.72)
	(envelope-from <hugo@carfax.org.uk>)
	id 1UEQQC-0007mu-W5
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 20:31:13 +0000
Received: from [10.0.0.10] (helo=ruthven.carfax.org.uk)
	by ruthven.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1UEQQC-0003Hi-Ju
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 20:31:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] Change output of btrfs fi df to report new (or old) RAID names
Date: Sat,  9 Mar 2013 20:31:10 +0000
Message-Id: <1362861071-12589-5-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 cmds-filesystem.c |  135 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 114 insertions(+), 21 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 2210020..8ecc21a 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -39,24 +39,126 @@ static const char * const filesystem_cmd_group_usage[] = {
 };
 
 static const char * const cmd_df_usage[] = {
-	"btrfs filesystem df <path>",
+	"btrfs filesystem df [options] <path>",
 	"Show space usage information for a mount point",
+	"",
+	"-r      Use old-style RAID-n terminology",
 	NULL
 };
 
+#define RAID_NAMES_NEW 0
+#define RAID_NAMES_OLD 1
+
+static int write_raid_name(char* buffer, int size, u64 flags, int old_raid)
+{
+	int copies, stripes, parity;
+	int out;
+	int written = 0;
+
+	if (old_raid == RAID_NAMES_OLD) {
+		if (flags & BTRFS_BLOCK_GROUP_RAID0) {
+			return snprintf(buffer, size, "%s", "RAID0");
+		} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
+			return snprintf(buffer, size, "%s", "RAID1");
+		} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
+			return snprintf(buffer, size, "%s", "DUP");
+		} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
+			return snprintf(buffer, size, "%s", "RAID10");
+		} else if (flags & BTRFS_BLOCK_GROUP_RAID5) {
+			return snprintf(buffer, size, "%s", "RAID5");
+		} else if (flags & BTRFS_BLOCK_GROUP_RAID6) {
+			return snprintf(buffer, size, "%s", "RAID6");
+		}
+		return 0;
+	}
+
+	if (flags & (BTRFS_BLOCK_GROUP_RAID1
+				 | BTRFS_BLOCK_GROUP_RAID10
+				 | BTRFS_BLOCK_GROUP_DUP)) {
+		copies = 2;
+	} else {
+		copies = 1;
+	}
+
+	out = snprintf(buffer, size, "%dC", copies);
+	if (size < out)
+		return written + size;
+	written += out;
+	size -= out;
+
+	if (flags & BTRFS_BLOCK_GROUP_DUP) {
+		out = snprintf(buffer+written, size, "D");
+		if (size < out)
+			return written + size;
+		written += out;
+		size -= out;
+	}
+
+	if (flags & (BTRFS_BLOCK_GROUP_RAID0
+				 | BTRFS_BLOCK_GROUP_RAID10
+				 | BTRFS_BLOCK_GROUP_RAID5
+				 | BTRFS_BLOCK_GROUP_RAID6)) {
+		stripes = -1;
+	} else {
+		stripes = 0;
+	}
+
+	if (stripes == -1) {
+		out = snprintf(buffer+written, size, "mS");
+	} else if (stripes == 0) {
+		out = 0;
+	} else {
+		out = snprintf(buffer+written, size, "%dS", stripes);
+	}
+
+	if (size < out)
+		return written + size;
+	written += out;
+	size -= out;
+
+	if (flags & BTRFS_BLOCK_GROUP_RAID5) {
+		parity = 1;
+	} else if (flags & BTRFS_BLOCK_GROUP_RAID6) {
+		parity = 2;
+	} else {
+		parity = 0;
+	}
+
+	if (parity == 0) {
+		out = 0;
+	} else {
+		out = snprintf(buffer+written, size, "%dP", parity);
+	}
+
+	if (size < out)
+		return written + size;
+	written += out;
+	size -= out;
+
+	return written;
+}
+
 static int cmd_df(int argc, char **argv)
 {
 	struct btrfs_ioctl_space_args *sargs, *sargs_orig;
+	int path_start = 1;
 	u64 count = 0, i;
 	int ret;
 	int fd;
 	int e;
 	char *path;
+	int old_raid;
 
-	if (check_argc_exact(argc, 2))
+	old_raid = RAID_NAMES_NEW;
+	if (argc > 1 && (!strcmp(argv[1], "--raid") || !strcmp(argv[1], "-r"))) {
+		old_raid = RAID_NAMES_OLD;
+		path_start += 1;
+	}
+
+	if (check_argc_exact(argc, path_start+1))
 		usage(cmd_df_usage);
 
-	path = argv[1];
+	path = argv[path_start];
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
@@ -135,24 +237,15 @@ static int cmd_df(int argc, char **argv)
 			written += 8;
 		}
 
-		if (flags & BTRFS_BLOCK_GROUP_RAID0) {
-			snprintf(description+written, 8, "%s", ", RAID0");
-			written += 7;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
-			snprintf(description+written, 8, "%s", ", RAID1");
-			written += 7;
-		} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
-			snprintf(description+written, 6, "%s", ", DUP");
-			written += 5;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
-			snprintf(description+written, 9, "%s", ", RAID10");
-			written += 8;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID5) {
-			snprintf(description+written, 9, "%s", ", RAID5");
-			written += 7;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID6) {
-			snprintf(description+written, 9, "%s", ", RAID6");
-			written += 7;
+		if((flags & ~(BTRFS_BLOCK_GROUP_DATA
+					  | BTRFS_BLOCK_GROUP_SYSTEM
+					  | BTRFS_BLOCK_GROUP_METADATA)) != 0) {
+			snprintf(description+written, 3, ", ");
+			written += 2;
+			written += write_raid_name(description+written,
+									   sizeof(description)-written,
+									   flags,
+									   old_raid);
 		}
 
 		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
-- 
1.7.10.4

