From: hugo-lkml@carfax.org.uk
Subject: (unknown)
Date: Sun, 17 Oct 2010 19:18:49 +0100
Message-ID: <E1P7Xon-0003B3-MC@vlad.carfax.org.uk>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>From hugo-lkml@carfax.org.uk Sun Oct 17 19:13:46 2010
Message-Id: <20101017181346.642118997@carfax.org.uk>
User-Agent: quilt/0.48-1
Date: Sun, 17 Oct 2010 19:13:24 +0100
From: hugo-lkml@carfax.org.uk
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch 3/4] Add an option to show ISO, binary or raw bytes counts using show.
References: <20101017181321.592805312@carfax.org.uk>
Content-Disposition: inline; filename=show-numbers

Change btrfs filesystem show to allow the user to control the scales
used for sizes in the output.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c      |    5 +++--
 btrfs_cmds.c |   42 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 38 insertions(+), 9 deletions(-)

Index: btrfs-progs-unstable/btrfs.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs.c	2010-10-17 18:47:36.000000000 +0100
+++ btrfs-progs-unstable/btrfs.c	2010-10-17 18:48:38.000000000 +0100
@@ -83,9 +83,10 @@
 		"will occupe all available space on the device."
 	},
 	{ do_show_filesystem, 999,
-	  "filesystem show", "[<uuid>|<label>]\n"
+	  "filesystem show", "[-r|-b|-i] [<uuid>|<label>]\n"
 		"Show the info of a btrfs filesystem. If no <uuid> or <label>\n"
-		"is passed, info of all the btrfs filesystem are shown."
+		"is passed, info of all the btrfs filesystem are shown.\n"
+		"-r, -b, -i for raw (bytes), binary or ISO sizes."
 	},
 	{ do_df_filesystem, -1,
 	  "filesystem df", "[-r|-b|-i] <path>\n"
Index: btrfs-progs-unstable/btrfs_cmds.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs_cmds.c	2010-10-17 18:47:36.000000000 +0100
+++ btrfs-progs-unstable/btrfs_cmds.c	2010-10-17 18:48:38.000000000 +0100
@@ -617,7 +617,7 @@
 	return 0;
 }
 
-static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
+static void print_one_uuid(struct btrfs_fs_devices *fs_devices, int format)
 {
 	char uuidbuf[37];
 	struct list_head *cur;
@@ -634,8 +634,7 @@
 	else
 		printf("Label: none ");
 
-	super_bytes_used = pretty_sizes(device->super_bytes_used,
-									PRETTY_SIZE_BINARY);
+	super_bytes_used = pretty_sizes(device->super_bytes_used, format);
 
 	total = device->total_devs;
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
@@ -647,8 +646,8 @@
 		char *total_bytes;
 		char *bytes_used;
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		total_bytes = pretty_sizes(device->total_bytes, PRETTY_SIZE_BINARY);
-		bytes_used = pretty_sizes(device->bytes_used, PRETTY_SIZE_BINARY);
+		total_bytes = pretty_sizes(device->total_bytes, format);
+		bytes_used = pretty_sizes(device->bytes_used, format);
 		printf("\tdevid %4llu size %s used %s path %s\n",
 		       (unsigned long long)device->devid,
 		       total_bytes, bytes_used, device->name);
@@ -667,8 +666,37 @@
 	struct list_head *all_uuids;
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
-	char *search = argv[1];
+	char *search;
 	int ret;
+	int format = PRETTY_SIZE_BINARY;
+
+	optind = 1;
+	while(1) {
+		int c = getopt(argc, argv, "rbi");
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
+			fprintf(stderr, "Invalid arguments for show\n");
+			free(argv);
+			return 1;
+		}
+	}
+	if (argc - optind > 1) {
+		fprintf(stderr, "Too many arguments for show\n");
+		free(argv);
+		return 1;
+	}
+	search = argv[optind];
 
 	ret = btrfs_scan_one_dir("/dev", 0);
 	if (ret){
@@ -682,7 +710,7 @@
 					list);
 		if (search && uuid_search(fs_devices, search) == 0)
 			continue;
-		print_one_uuid(fs_devices);
+		print_one_uuid(fs_devices, format);
 	}
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	return 0;


