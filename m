From: hugo-lkml@carfax.org.uk
Subject: [patch 2/4] Add an option to show ISO, binary or raw bytes counts using df.
Date: Sun, 17 Oct 2010 19:26:45 +0100
Message-ID: <20101017182706.430006857@carfax.org.uk>
References: <20101017182643.297900488@carfax.org.uk>
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Change btrfs filesystem df to allow the user to control the scales
used for sizes in the output.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c      |    5 +++--
 btrfs_cmds.c |   37 ++++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 7 deletions(-)

Index: btrfs-progs-unstable/btrfs.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs.c	2010-10-17 18:43:57.000000000 +0100
+++ btrfs-progs-unstable/btrfs.c	2010-10-17 18:47:36.000000000 +0100
@@ -87,9 +87,10 @@
 		"Show the info of a btrfs filesystem. If no <uuid> or <label>\n"
 		"is passed, info of all the btrfs filesystem are shown."
 	},
-	{ do_df_filesystem, 1,
-	  "filesystem df", "<path>\n"
+	{ do_df_filesystem, -1,
+	  "filesystem df", "[-r|-b|-i] <path>\n"
 		"Show space usage information for a mount point\n."
+		"-r, -b, -i for raw (bytes), binary or ISO sizes."
 	},
 	{ do_balance, 1,
 	  "filesystem balance", "<path>\n"
Index: btrfs-progs-unstable/btrfs_cmds.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs_cmds.c	2010-10-17 18:43:57.000000000 +0100
+++ btrfs-progs-unstable/btrfs_cmds.c	2010-10-17 18:47:36.000000000 +0100
@@ -841,7 +841,36 @@
 	u64 count = 0, i;
 	int ret;
 	int fd;
-	char *path = argv[1];
+	char *path;
+	int format = PRETTY_SIZE_BINARY;
+
+	optind = 1;
+	while(1) {
+		int c = getopt(nargs, argv, "rbi");
+		if (c < 0)
+			break;
+		switch(c) {
+		case 'r':
+			format = PRETTY_SIZE_RAW;
+			break;
+		case 'b':
+			format = PRETTY_SIZE_BINARY;
+			break;
+		case 'i':
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
@@ -914,10 +943,8 @@
 			written += 8;
 		}
 
-		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes,
-									PRETTY_SIZE_BINARY);
-		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes,
-									PRETTY_SIZE_BINARY);
+		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes, format);
+		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes, format);
 		printf("%s: total=%s, used=%s\n", description, total_bytes,
 		       used_bytes);
 	}


