Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36959 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3CKURb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 16:17:31 -0400
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@gmail.com>,
        Harald Glatt <mail@hachre.de>, Roger Binns <rogerb@rogerbinns.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Diego Calleja <diegocg@gmail.com>, sam tygier <samtygier@yahoo.co.uk>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH v2 4/5] Change output of btrfs fi df to report new (or old) RAID names
Date: Mon, 11 Mar 2013 20:17:27 +0000
Message-Id: <1363033048-17481-5-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
References: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 cmds-filesystem.c |  173 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 152 insertions(+), 21 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 2210020..3150ff7 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -18,6 +18,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <getopt.h>
 #include <sys/ioctl.h>
 #include <errno.h>
 #include <uuid/uuid.h>
@@ -39,11 +40,129 @@ static const char * const filesystem_cmd_group_usage[] = {
 };
 
 static const char * const cmd_df_usage[] = {
-	"btrfs filesystem df <path>",
+	"btrfs filesystem df [options] <path>",
 	"Show space usage information for a mount point",
+	"",
+	"-r      Use old-style RAID-n terminology",
+	"-e      Explain new-style NcMsPp terminology",
 	NULL
 };
 
+static const char *cmd_df_short_options = "re";
+static const struct option cmd_df_options[] = {
+	{ "raid",    no_argument, NULL, 'r' },
+	{ "explain", no_argument, NULL, 'e' },
+	{ NULL, 0, NULL, 0 }
+};
+
+#define RAID_NAMES_NEW 0
+#define RAID_NAMES_OLD 1
+#define RAID_NAMES_LONG 2
+
+static int write_raid_name(char* buffer, int size, u64 flags, int raid_format)
+{
+	int copies, stripes, parity;
+	int out;
+	int written = 0;
+
+	if (raid_format == RAID_NAMES_OLD) {
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
+	if (raid_format == RAID_NAMES_LONG)
+		out = snprintf(buffer, size, "%d copies", copies);
+	else
+		out = snprintf(buffer, size, "%dc", copies);
+	if (size < out)
+		return written + size;
+	written += out;
+	size -= out;
+
+	if (flags & BTRFS_BLOCK_GROUP_DUP) {
+		if (raid_format == RAID_NAMES_LONG)
+			out = snprintf(buffer+written, size, " low redundancy");
+		else
+			out = snprintf(buffer+written, size, "d");
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
+		if (raid_format == RAID_NAMES_LONG)
+			out = snprintf(buffer+written, size, ", fit stripes");
+		else
+			out = snprintf(buffer+written, size, "Xs");
+	} else if (stripes == 0) {
+		out = 0;
+	} else {
+		if (raid_format == RAID_NAMES_LONG)
+			out = snprintf(buffer+written, size, ", %d stripes", stripes);
+		else
+			out = snprintf(buffer+written, size, "%ds", stripes);
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
+		if (raid_format == RAID_NAMES_LONG)
+			out = snprintf(buffer+written, size, ", %d parity", parity);
+		else
+			out = snprintf(buffer+written, size, "%dp", parity);
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
@@ -52,11 +171,32 @@ static int cmd_df(int argc, char **argv)
 	int fd;
 	int e;
 	char *path;
+	int raid_format = RAID_NAMES_NEW;
+
+	while (1) {
+		int option_index = 0;
+		int c = getopt_long(argc, argv,
+							cmd_df_short_options, cmd_df_options,
+							&option_index);
+		if (c == -1)
+			break;
 
-	if (check_argc_exact(argc, 2))
+		switch (c) {
+		case 'r':
+			raid_format = RAID_NAMES_OLD;
+			break;
+		case 'e':
+			raid_format = RAID_NAMES_LONG;
+			break;
+		default:
+			usage(cmd_df_usage);
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_df_usage);
 
-	path = argv[1];
+	path = argv[optind];
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
@@ -135,24 +275,15 @@ static int cmd_df(int argc, char **argv)
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
+		if ((flags & ~(BTRFS_BLOCK_GROUP_DATA
+					   | BTRFS_BLOCK_GROUP_SYSTEM
+					   | BTRFS_BLOCK_GROUP_METADATA)) != 0) {
+			snprintf(description+written, 3, ", ");
+			written += 2;
+			written += write_raid_name(description+written,
+									   sizeof(description)-written,
+									   flags,
+									   raid_format);
 		}
 
 		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
-- 
1.7.10.4

