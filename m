From: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch v2 2/4] Add an option to show ISO, binary or raw bytes counts using df.
Date: Thu, 21 Oct 2010 20:01:37 +0100
Message-ID: <20101021190202.961098322@carfax.org.uk>
References: <20101021190135.757086134@carfax.org.uk>
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Change btrfs filesystem df to allow the user to control the scales
used for sizes in the output.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c        |    6 +++---
 btrfs_cmds.c   |   42 ++++++++++++++++++++++++++++++++++++------
 man/btrfs.8.in |    8 ++++++++
 3 files changed, 47 insertions(+), 9 deletions(-)

Index: btrfs-progs-unstable/btrfs.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs.c	2010-10-20 19:12:18.000000000 +0100
+++ btrfs-progs-unstable/btrfs.c	2010-10-20 19:48:34.000000000 +0100
@@ -87,9 +87,9 @@
 		"Show the info of a btrfs filesystem. If no <uuid> or <label>\n"
 		"is passed, info of all the btrfs filesystem are shown."
 	},
-	{ do_df_filesystem, 1,
-	  "filesystem df", "<path>\n"
-		"Show space usage information for a mount point\n."
+	{ do_df_filesystem, -1,
+	  "filesystem df", "[options] <path>\n"
+		"Show space usage information for a mount point."
 	},
 	{ do_balance, 1,
 	  "filesystem balance", "<path>\n"
Index: btrfs-progs-unstable/btrfs_cmds.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs_cmds.c	2010-10-20 19:19:20.000000000 +0100
+++ btrfs-progs-unstable/btrfs_cmds.c	2010-10-20 19:58:48.000000000 +0100
@@ -14,7 +14,6 @@
  * Boston, MA 021110-1307, USA.
  */
 
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -28,6 +27,7 @@
 #include <limits.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
+#include <getopt.h>
 
 #undef ULONG_MAX
 
@@ -835,13 +835,45 @@
 	return 0;
 }
 
+const struct option df_options[] = {
+	{ "human-readable", 0, NULL, 'h' },
+	{ "si", 0, NULL, 'H' },
+	{ NULL, 0, NULL, 0 }
+};
+
 int do_df_filesystem(int nargs, char **argv)
 {
 	struct btrfs_ioctl_space_args *sargs;
 	u64 count = 0, i;
 	int ret;
 	int fd;
-	char *path = argv[1];
+	char *path;
+	int format = PRETTY_SIZE_RAW;
+
+	optind = 1;
+	while(1) {
+		int c = getopt_long(nargs, argv, "hH", df_options, NULL);
+		if (c < 0)
+			break;
+		switch(c) {
+		case 'h':
+			format = PRETTY_SIZE_BINARY;
+			break;
+		case 'H':
+			format = PRETTY_SIZE_ISO;
+			break;
+		default:
+			fprintf(stderr, "Invalid arguments for df\n");
+			free(argv);
+			return 1;
+		}
+	}
+	if (nargs - optind != 1) {
+		fprintf(stderr, "No path given for df\n");
+		free(argv);
+		return 1;
+	}
+	path = argv[optind];
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
@@ -914,10 +946,8 @@
 			written += 8;
 		}
 
-		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes,
-									PRETTY_SIZE_RAW);
-		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes,
-									PRETTY_SIZE_RAW);
+		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes, format);
+		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes, format);
 		printf("%s: total=%s, used=%s\n", description, total_bytes,
 		       used_bytes);
 	}
Index: btrfs-progs-unstable/man/btrfs.8.in
===================================================================
--- btrfs-progs-unstable.orig/man/btrfs.8.in	2010-10-20 19:23:36.000000000 +0100
+++ btrfs-progs-unstable/man/btrfs.8.in	2010-10-20 19:28:14.000000000 +0100
@@ -21,6 +21,8 @@
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
 .PP
+\fBbtrfs\fP \fBfilesystem df\fP\fI [options] <path>\fP
+.PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
 .PP
 \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
@@ -143,6 +145,12 @@
 passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 .TP
 
+\fBfilesystem df\fR [options] <path>\fR
+Show the amount of space used on this filesystem, in bytes. Options:
+-h, --human-readable Use powers of 2^10 (1024) to report sizes.
+-H, --si Use powers of 10^3 (1000) to report sizes, in SI multiples.
+.TP
+
 \fBdevice balance\fR \fI<path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- I spent most of my money on drink, women and fast cars. The ---   
                      rest I wasted.  -- James Hunt                      

