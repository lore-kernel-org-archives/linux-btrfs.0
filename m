From: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch v3 4/4] Add an option to show ISO, binary or raw bytes counts using btrfs-show.
Date: Tue, 26 Oct 2010 13:23:48 +0100
Message-ID: <20101026122401.372798693@carfax.org.uk>
References: <20101026122344.934075672@carfax.org.uk>
Cc: Goffredo Baroncelli <kreijack@libero.it>,
	Frank Kingswood <frank@kingswood-consulting.co.uk>,
	Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Change btrfs-show to allow the user to control the scales used for
sizes in the output.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs-show.c        |   27 +++++++++++++++++++--------
 man/btrfs-show.8.in |   10 ++++++++--
 2 files changed, 27 insertions(+), 10 deletions(-)

Index: btrfs-progs-unstable/btrfs-show.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs-show.c	2010-10-26 12:56:54.179226836 +0100
+++ btrfs-progs-unstable/btrfs-show.c	2010-10-26 13:05:48.626702902 +0100
@@ -52,7 +52,7 @@
 	return 0;
 }
 
-static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
+static void print_one_uuid(struct btrfs_fs_devices *fs_devices, int format)
 {
 	char uuidbuf[37];
 	struct list_head *cur;
@@ -69,8 +69,7 @@
 	else
 		printf("Label: none ");
 
-	super_bytes_used = pretty_sizes(device->super_bytes_used,
-									PRETTY_SIZE_RAW);
+	super_bytes_used = pretty_sizes(device->super_bytes_used, format);
 
 	total = device->total_devs;
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
@@ -82,8 +81,8 @@
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
@@ -99,13 +98,18 @@
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-show [search label or device]\n");
+	fprintf(stderr, "usage: btrfs-show [options] [search label or device]\n");
+	fprintf(stderr, "Options:\n");
+	fprintf(stderr, "\t-h, --human-readable\tShow sizes in powers of 2^10.\n");
+	fprintf(stderr, "\t-s, --si\t\tShow sizes in powers of 10^3 (SI multiples).\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
 
 static struct option long_options[] = {
 	/* { "byte-count", 1, NULL, 'b' }, */
+	{ "human-readable", 0, NULL, 'h' },
+	{ "si", 0, NULL, 'H' },
 	{ 0, 0, 0, 0}
 };
 
@@ -117,14 +121,21 @@
 	char *search = NULL;
 	int ret;
 	int option_index = 0;
+	int format = PRETTY_SIZE_RAW;
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "", long_options,
+		c = getopt_long(ac, av, "hH", long_options,
 				&option_index);
 		if (c < 0)
 			break;
 		switch(c) {
+			case 'H':
+				format = PRETTY_SIZE_ISO;
+				break;
+			case 'h':
+				format = PRETTY_SIZE_BINARY;
+				break;
 			default:
 				print_usage();
 		}
@@ -144,7 +155,7 @@
 					list);
 		if (search && uuid_search(fs_devices, search) == 0)
 			continue;
-		print_one_uuid(fs_devices);
+		print_one_uuid(fs_devices, format);
 	}
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	return 0;
Index: btrfs-progs-unstable/man/btrfs-show.8.in
===================================================================
--- btrfs-progs-unstable.orig/man/btrfs-show.8.in	2010-10-26 12:56:54.189226427 +0100
+++ btrfs-progs-unstable/man/btrfs-show.8.in	2010-10-26 13:06:51.074147050 +0100
@@ -2,13 +2,19 @@
 .SH NAME
 btrfs-show \- scan the /dev directory for btrfs partitions and print results.
 .SH SYNOPSIS
-.B btrfs-show
+.B btrfs-show [-h|-H|--human-readable|--si]
 .SH DESCRIPTION
 .B btrfs-show
 is used to scan the /dev directory for btrfs partitions and display brief
 information such as lable, uuid, etc of each btrfs partition.
 .SH OPTIONS
-none
+.TP
+\fB\-h\fR, \fB\-\-human\-readable\fR
+Show values in multiples of 2^10.
+.TP
+\fB\-H\fR, \fB\-\-si\fR
+Show values in multiples of 10^3 (SI multiples).
+
 .SH AVAILABILITY
 .B btrfs-show
 is part of btrfs-progs. Btrfs is currently under heavy development,


