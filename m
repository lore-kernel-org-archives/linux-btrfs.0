From: Hugo Mills <hugo@carfax.org.uk>
Subject: [patch v3 1/4] Update pretty-printer for different systems of counting multiples.
Date: Tue, 26 Oct 2010 13:23:45 +0100
Message-ID: <20101026122400.673790553@carfax.org.uk>
References: <20101026122344.934075672@carfax.org.uk>
Cc: Goffredo Baroncelli <kreijack@libero.it>,
	Frank Kingswood <frank@kingswood-consulting.co.uk>,
	Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Make the pretty-printer for data sizes capable of printing in ISO
(powers of 10^3), binary (powers of 2^10) or raw (a simple byte
count).

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs-show.c |    7 ++++---
 btrfs_cmds.c |   13 ++++++++-----
 mkfs.c       |    3 ++-
 utils.c      |   48 +++++++++++++++++++++++++++++++++---------------
 utils.h      |    7 ++++++-
 5 files changed, 53 insertions(+), 25 deletions(-)

Index: btrfs-progs-unstable/btrfs-show.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs-show.c	2010-10-09 15:39:09.000000000 +0100
+++ btrfs-progs-unstable/btrfs-show.c	2010-10-20 19:20:02.000000000 +0100
@@ -69,7 +69,8 @@
 	else
 		printf("Label: none ");
 
-	super_bytes_used = pretty_sizes(device->super_bytes_used);
+	super_bytes_used = pretty_sizes(device->super_bytes_used,
+									PRETTY_SIZE_RAW);
 
 	total = device->total_devs;
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
@@ -81,8 +82,8 @@
 		char *total_bytes;
 		char *bytes_used;
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		total_bytes = pretty_sizes(device->total_bytes);
-		bytes_used = pretty_sizes(device->bytes_used);
+		total_bytes = pretty_sizes(device->total_bytes, PRETTY_SIZE_RAW);
+		bytes_used = pretty_sizes(device->bytes_used, PRETTY_SIZE_RAW);
 		printf("\tdevid %4llu size %s used %s path %s\n",
 		       (unsigned long long)device->devid,
 		       total_bytes, bytes_used, device->name);
Index: btrfs-progs-unstable/btrfs_cmds.c
===================================================================
--- btrfs-progs-unstable.orig/btrfs_cmds.c	2010-10-09 15:39:09.000000000 +0100
+++ btrfs-progs-unstable/btrfs_cmds.c	2010-10-20 19:19:20.000000000 +0100
@@ -634,7 +634,8 @@
 	else
 		printf("Label: none ");
 
-	super_bytes_used = pretty_sizes(device->super_bytes_used);
+	super_bytes_used = pretty_sizes(device->super_bytes_used,
+									PRETTY_SIZE_RAW);
 
 	total = device->total_devs;
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
@@ -646,8 +647,8 @@
 		char *total_bytes;
 		char *bytes_used;
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		total_bytes = pretty_sizes(device->total_bytes);
-		bytes_used = pretty_sizes(device->bytes_used);
+		total_bytes = pretty_sizes(device->total_bytes, PRETTY_SIZE_RAW);
+		bytes_used = pretty_sizes(device->bytes_used, PRETTY_SIZE_RAW);
 		printf("\tdevid %4llu size %s used %s path %s\n",
 		       (unsigned long long)device->devid,
 		       total_bytes, bytes_used, device->name);
@@ -913,8 +914,10 @@
 			written += 8;
 		}
 
-		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
-		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
+		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes,
+									PRETTY_SIZE_RAW);
+		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes,
+									PRETTY_SIZE_RAW);
 		printf("%s: total=%s, used=%s\n", description, total_bytes,
 		       used_bytes);
 	}
Index: btrfs-progs-unstable/mkfs.c
===================================================================
--- btrfs-progs-unstable.orig/mkfs.c	2010-10-09 15:39:09.000000000 +0100
+++ btrfs-progs-unstable/mkfs.c	2010-10-17 19:35:08.000000000 +0100
@@ -524,7 +524,8 @@
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
 	    label, first_file, nodesize, leafsize, sectorsize,
-	    pretty_sizes(btrfs_super_total_bytes(&root->fs_info->super_copy)));
+		pretty_sizes(btrfs_super_total_bytes(&root->fs_info->super_copy),
+			PRETTY_SIZE_BINARY));
 
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	btrfs_commit_transaction(trans, root);
Index: btrfs-progs-unstable/utils.c
===================================================================
--- btrfs-progs-unstable.orig/utils.c	2010-10-09 15:39:09.000000000 +0100
+++ btrfs-progs-unstable/utils.c	2010-10-17 19:35:08.000000000 +0100
@@ -966,30 +966,48 @@
 	return ret;
 }
 
-static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
+static char *bin_size_strs[] = { "", "KiB", "MiB", "GiB", "TiB",
+			    "PiB", "EiB", "ZiB", "YiB"};
+static char *iso_size_strs[] = { "", "kB", "MB", "GB", "TB",
 			    "PB", "EB", "ZB", "YB"};
-char *pretty_sizes(u64 size)
+char *pretty_sizes(u64 size, int format)
 {
 	int num_divs = 0;
 	u64 last_size = size;
 	u64 fract_size = size;
 	float fraction;
 	char *pretty;
+	int divisor = 1024;
+	char** size_strs = bin_size_strs;
 
-	while(size > 0) {
-		fract_size = last_size;
-		last_size = size;
-		size /= 1024;
-		num_divs++;
+	if(format == PRETTY_SIZE_RAW) {
+		pretty = malloc(21);
+		sprintf(pretty, "%llu", size);
+	} else {
+		if(format == PRETTY_SIZE_ISO) {
+			divisor = 1000;
+			size_strs = iso_size_strs;
+		} else if(format == PRETTY_SIZE_BINARY) {
+			divisor = 1024;
+			size_strs = bin_size_strs;
+		}
+
+		while(size > 0) {
+			fract_size = last_size;
+			last_size = size;
+			size /= divisor;
+			num_divs++;
+		}
+		if (num_divs == 0)
+			num_divs = 1;
+		if (num_divs > ARRAY_SIZE(bin_size_strs))
+			return NULL;
+
+		fraction = (float)fract_size / divisor;
+		pretty = malloc(16);
+		sprintf(pretty, "%.2f%s", fraction, size_strs[num_divs-1]);
 	}
-	if (num_divs == 0)
-		num_divs = 1;
-	if (num_divs > ARRAY_SIZE(size_strs))
-		return NULL;
-
-	fraction = (float)fract_size / 1024;
-	pretty = malloc(16);
-	sprintf(pretty, "%.2f%s", fraction, size_strs[num_divs-1]);
+
 	return pretty;
 }
 
Index: btrfs-progs-unstable/utils.h
===================================================================
--- btrfs-progs-unstable.orig/utils.h	2010-10-09 15:39:09.000000000 +0100
+++ btrfs-progs-unstable/utils.h	2010-10-17 19:35:08.000000000 +0100
@@ -21,6 +21,11 @@
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
+/* Constants for pretty_size() format parameter */
+#define PRETTY_SIZE_RAW 0
+#define PRETTY_SIZE_ISO 1
+#define PRETTY_SIZE_BINARY 2
+
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize);
@@ -39,5 +44,5 @@
 int check_mounted(const char *devicename);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
-char *pretty_sizes(u64 size);
+char *pretty_sizes(u64 size, int format);
 #endif


