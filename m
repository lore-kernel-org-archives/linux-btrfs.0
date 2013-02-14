Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932492Ab3BNTX6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 14:23:58 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1EJNwtk003590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 14:23:58 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r1EIU3nQ021948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 13:30:04 -0500
Message-ID: <511D2D2B.8040804@redhat.com>
Date: Thu, 14 Feb 2013 12:30:03 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite
 filesystem or partition table
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The core of this is shamelessly stolen from xfsprogs.

Use blkid to detect an existing filesystem or partition
table on any of the target devices.  If something is found,
require the '-f' option to overwrite it, hopefully avoiding
disaster due to mistyped devicenames, etc.

# mkfs.btrfs /dev/sda1

WARNING! - Btrfs v0.20-rc1-59-gd00279c-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

/dev/sda1 appears to contain an existing filesystem (xfs).
Use the -f option to force overwrite.
#

This does introduce a requirement on libblkid.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note: this depends on my earlier small series,
[PATCH 1/2] btrfs-progs: fix mkfs.btrfs -r option
[PATCH 2/2, RFC] btrfs-progs: overhaul mkfs.btrfs -r option

diff --git a/Makefile b/Makefile
index 4894903..bd0e8a6 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-LIBS=-luuid -lm
+LIBS=-luuid -lblkid -lm
 RESTORE_LIBS=-lz
 
 progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index c9f9e4f..9188201 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -6,6 +6,7 @@ mkfs.btrfs \- create a btrfs filesystem
 [ \fB\-A\fP\fI alloc-start\fP ]
 [ \fB\-b\fP\fI byte-count\fP ]
 [ \fB\-d\fP\fI data-profile\fP ]
+[ \fB\-f\fP\fI ]
 [ \fB\-l\fP\fI leafsize\fP ]
 [ \fB\-L\fP\fI label\fP ]
 [ \fB\-m\fP\fI metadata profile\fP ]
@@ -38,6 +39,11 @@ mkfs.btrfs uses all the available storage for the filesystem.
 Specify how the data must be spanned across the devices specified. Valid
 values are raid0, raid1, raid10 or single.
 .TP
+\fB\-f\fR
+Force overwrite when an existing filesystem is detected on the device.
+By default, mkfs.btrfs will not write to the device if it suspects that 
+there is a filesystem or partition table on the device already.
+.TP
 \fB\-l\fR, \fB\-\-leafsize \fIsize\fR
 Specify the leaf size, the least data item in which btrfs stores data. The
 default value is the page size.
diff --git a/mkfs.c b/mkfs.c
index 129fae8..207066c 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -39,6 +39,7 @@
 #include <linux/fs.h>
 #include <ctype.h>
 #include <attr/xattr.h>
+#include <blkid/blkid.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "volumes.h"
@@ -1162,6 +1163,86 @@ static int check_leaf_or_node_size(u32 size, u32 sectorsize)
 	return 0;
 }
 
+/*
+ * Check for existing filesystem or partition table on device.
+ * Returns:
+ *	 1 for existing fs or partition
+ *	 0 for nothing found
+ *	-1 for internal error
+ */
+static int
+check_overwrite(
+	char		*device)
+{
+	const char	*type;
+	blkid_probe	pr = NULL;
+	int		ret;
+	blkid_loff_t	size;
+
+	if (!device || !*device)
+		return 0;
+
+	ret = -1; /* will reset on success of all setup calls */
+
+	pr = blkid_new_probe_from_filename(device);
+	if (!pr)
+		goto out;
+
+	size = blkid_probe_get_size(pr);
+	if (size < 0)
+		goto out;
+
+	/* nothing to overwrite on a 0-length device */
+	if (size == 0) {
+		ret = 0;
+		goto out;
+	}
+
+	ret = blkid_probe_enable_partitions(pr, 1);
+	if (ret < 0)
+		goto out;
+
+	ret = blkid_do_fullprobe(pr);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Blkid returns 1 for nothing found and 0 when it finds a signature,
+	 * but we want the exact opposite, so reverse the return value here.
+	 *
+	 * In addition print some useful diagnostics about what actually is
+	 * on the device.
+	 */
+	if (ret) {
+		ret = 0;
+		goto out;
+	}
+
+	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
+		fprintf(stderr,
+			"%s appears to contain an existing "
+			"filesystem (%s).\n", device, type);
+	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
+		fprintf(stderr,
+			"%s appears to contain a partition "
+			"table (%s).\n", device, type);
+	} else {
+		fprintf(stderr,
+			"%s appears to contain something weird "
+			"according to blkid\n", device);
+	}
+	ret = 1;
+
+out:
+	if (pr)
+		blkid_free_probe(pr);
+	if (ret == -1)
+		fprintf(stderr,
+			"probe of %s failed, cannot detect "
+			  "existing filesystem.\n", device);
+	return ret;
+}
+
 int main(int ac, char **av)
 {
 	char *file;
@@ -1188,6 +1269,7 @@ int main(int ac, char **av)
 	int data_profile_opt = 0;
 	int metadata_profile_opt = 0;
 	int nodiscard = 0;
+	int force_overwrite = 0;
 
 	char *source_dir = NULL;
 	int source_dir_set = 0;
@@ -1198,7 +1280,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VMK", long_options,
+		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:r:VMK", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -1206,6 +1288,9 @@ int main(int ac, char **av)
 			case 'A':
 				alloc_start = parse_size(optarg);
 				break;
+			case 'f':
+				force_overwrite = 1;
+				break;
 			case 'd':
 				data_profile = parse_profile(optarg);
 				data_profile_opt = 1;
@@ -1272,6 +1357,13 @@ int main(int ac, char **av)
 	file = av[optind++];
 	ac--; /* used that arg */
 
+	if (!force_overwrite) {
+		if (check_overwrite(file)) {
+			fprintf(stderr, "Use the -f option to force overwrite.\n");
+			exit(1);
+		}
+	}
+
 	ret = check_mounted(file);
 	if (ret < 0) {
 		fprintf(stderr, "error checking %s mount status\n", file);
@@ -1375,6 +1467,13 @@ int main(int ac, char **av)
 		int old_mixed = mixed;
 
 		file = av[optind++];
+		if (!force_overwrite) {
+			if (check_overwrite(file)) {
+				fprintf(stderr, "Use the -f option to force overwrite.\n");
+				exit(1);
+			}
+		}
+
 		ret = check_mounted(file);
 		if (ret < 0) {
 			fprintf(stderr, "error checking %s mount status\n",


