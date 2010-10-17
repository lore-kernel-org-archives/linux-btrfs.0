From: hugo-lkml@carfax.org.uk
Subject: (unknown)
Date: Sun, 17 Oct 2010 19:18:50 +0100
Message-ID: <E1P7Xoo-0003B9-RH@vlad.carfax.org.uk>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>From hugo-lkml@carfax.org.uk Sun Oct 17 19:13:47 2010
Message-Id: <20101017181346.872364958@carfax.org.uk>
User-Agent: quilt/0.48-1
Date: Sun, 17 Oct 2010 19:13:25 +0100
From: hugo-lkml@carfax.org.uk
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch 4/4] Add an option to show ISO, binary or raw bytes counts using btrfs-show.
References: <20101017181321.592805312@carfax.org.uk>
Content-Disposition: inline; filename=btrfs-show-numbers

Change btrfs-show to allow the user to control the scales used for
sizes in the output.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs-show.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

Index: btrfs-progs-unstable/btrfs-show.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs-show.c	2010-10-17 19:00:34.000000000 +0100
+++ btrfs-progs-unstable/btrfs-show.c	2010-10-17 19:12:50.000000000 +0100
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
-									PRETTY_SIZE_BINARY);
+	super_bytes_used = pretty_sizes(device->super_bytes_used, format);
 
 	total = device->total_devs;
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
@@ -82,8 +81,8 @@
 		char *total_bytes;
 		char *bytes_used;
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		total_bytes = pretty_sizes(device->total_bytes, PRETTY_SIZE_BINARY);
-		bytes_used = pretty_sizes(device->bytes_used, PRETTY_SIZE_BINARY);
+		total_bytes = pretty_sizes(device->total_bytes,	format);
+		bytes_used = pretty_sizes(device->bytes_used, format);
 		printf("\tdevid %4llu size %s used %s path %s\n",
 		       (unsigned long long)device->devid,
 		       total_bytes, bytes_used, device->name);
@@ -99,7 +98,8 @@
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-show [search label or device]\n");
+	fprintf(stderr, "usage: btrfs-show [-i|-b|-r] [search label or device]\n");
+	fprintf(stderr, "Options:\n -i, -b, -r: Show sizes in ISO, binary or raw form respectively.\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -117,6 +117,7 @@
 	char *search = NULL;
 	int ret;
 	int option_index = 0;
+	int format = PRETTY_SIZE_BINARY;
 
 	while(1) {
 		int c;
@@ -125,6 +126,15 @@
 		if (c < 0)
 			break;
 		switch(c) {
+			case 'i':
+				format = PRETTY_SIZE_ISO;
+				break;
+			case 'b':
+				format = PRETTY_SIZE_BINARY;
+				break;
+			case 'r':
+				format = PRETTY_SIZE_RAW;
+				break;
 			default:
 				print_usage();
 		}
@@ -144,7 +154,7 @@
 					list);
 		if (search && uuid_search(fs_devices, search) == 0)
 			continue;
-		print_one_uuid(fs_devices);
+		print_one_uuid(fs_devices, format);
 	}
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	return 0;


