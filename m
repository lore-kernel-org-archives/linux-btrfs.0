From: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch v3 3/4] Add an option to show ISO, binary or raw bytes counts using show.
Date: Tue, 26 Oct 2010 13:23:47 +0100
Message-ID: <20101026122401.145167429@carfax.org.uk>
References: <20101026122344.934075672@carfax.org.uk>
Cc: Goffredo Baroncelli <kreijack@libero.it>,
	Frank Kingswood <frank@kingswood-consulting.co.uk>,
	Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Change btrfs filesystem show to allow the user to control the scales
used for sizes in the output.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c        |    2 +-
 btrfs_cmds.c   |   45 ++++++++++++++++++++++++++++++++++++++-------
 man/btrfs.8.in |   15 ++++++++++-----
 3 files changed, 49 insertions(+), 13 deletions(-)

Index: btrfs-progs-unstable/btrfs.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs.c	2010-10-26 13:01:43.000000000 +0100
+++ btrfs-progs-unstable/btrfs.c	2010-10-26 13:02:40.814489740 +0100
@@ -83,7 +83,7 @@
 		"will occupe all available space on the device."
 	},
 	{ do_show_filesystem, 999,
-	  "filesystem show", "[<uuid>|<label>]\n"
+	  "filesystem show", "[-h|--human-readable|-H|--si] [<uuid>|<label>]\n"
 		"Show the info of a btrfs filesystem. If no <uuid> or <label>\n"
 		"is passed, info of all the btrfs filesystem are shown."
 	},
Index: btrfs-progs-unstable/btrfs_cmds.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs_cmds.c	2010-10-26 13:00:39.000000000 +0100
+++ btrfs-progs-unstable/btrfs_cmds.c	2010-10-26 13:02:40.834488902 +0100
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
-									PRETTY_SIZE_RAW);
+	super_bytes_used = pretty_sizes(device->super_bytes_used, format);
 
 	total = device->total_devs;
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
@@ -647,8 +646,8 @@
 		char *total_bytes;
 		char *bytes_used;
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		total_bytes = pretty_sizes(device->total_bytes, PRETTY_SIZE_RAW);
-		bytes_used = pretty_sizes(device->bytes_used, PRETTY_SIZE_RAW);
+		total_bytes = pretty_sizes(device->total_bytes, format);
+		bytes_used = pretty_sizes(device->bytes_used, format);
 		printf("\tdevid %4llu size %s used %s path %s\n",
 		       (unsigned long long)device->devid,
 		       total_bytes, bytes_used, device->name);
@@ -662,13 +661,45 @@
 	printf("\n");
 }
 
+const struct option show_options[] = {
+	{ "human-readable", 0, NULL, 'h' },
+	{ "si", 0, NULL, 'H' },
+	{ NULL, 0, NULL, 0 }
+};
+
 int do_show_filesystem(int argc, char **argv)
 {
 	struct list_head *all_uuids;
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
-	char *search = argv[1];
+	char *search;
 	int ret;
+	int format = PRETTY_SIZE_RAW;
+
+	optind = 1;
+	while(1) {
+		int c = getopt_long(argc, argv, "hH", show_options, NULL);
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
@@ -682,7 +713,7 @@
 					list);
 		if (search && uuid_search(fs_devices, search) == 0)
 			continue;
-		print_one_uuid(fs_devices);
+		print_one_uuid(fs_devices, format);
 	}
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	return 0;
Index: btrfs-progs-unstable/man/btrfs.8.in
===================================================================
--- btrfs-progs-unstable.orig/man/btrfs.8.in	2010-10-26 13:01:27.000000000 +0100
+++ btrfs-progs-unstable/man/btrfs.8.in	2010-10-26 13:03:43.941854637 +0100
@@ -23,6 +23,8 @@
 .PP
 \fBbtrfs\fP \fBfilesystem df\fP\fI [-h|-H|--human-readable|--si] <path>\fP
 .PP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [-h|--human-readable|-H|--si] [<uuid>|<label>]\fP
+.PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
 .PP
 \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
@@ -140,16 +142,19 @@
 partition after reducing the size of the filesystem.
 .TP
 
-\fBfilesystem show\fR [<uuid>|<label>]\fR
-Show the btrfs filesystem with some additional info. If no UUID or label is
-passed, \fBbtrfs\fR show info of all the btrfs filesystem.
-.TP
-
 \fBfilesystem df\fR [-h|-H|--human-readable|--si] <path>\fR
 Show the amount of space used on this filesystem, in bytes. Options:
 -h, --human-readable Use powers of 2^10 (1024) to report sizes.
 -H, --si Use powers of 10^3 (1000) to report sizes, in SI multiples.
 .TP
+
+\fBfilesystem show\fR [-h|-H|--human-readable|--si] [<uuid>|<label>]\fR
+Show the usage of each device in the btrfs filesystem with the given
+uuid or label, or all filesystems if no uuid or label is provided.
+Options:
+-h, --human-readable Use powers of 2^10 (1024) to report sizes.
+-H, --si Use powers of 10^3 (1000) to report sizes, in SI multiples.
+.TP
 
 \fBdevice balance\fR \fI<path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR


