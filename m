Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:41614 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab2GWRRH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 13:17:07 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id DTAizbQobGpAGOPh (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2012 11:17:06 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: detect if the disk we are formatting is a ssd V2
Date: Mon, 23 Jul 2012 13:22:05 -0400
Message-ID: <1343064125-4023-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

SSD's do not gain anything by having metadata DUP turned on.  The underlying
file system that is a part of all SSD's could easily map duplicate metadat
blocks into the same erase block which effectively eliminates the benefit of
duplicating the metadata on disk.  So detect if we are formatting a single
SSD drive and if we are do not use DUP.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: add explanation to man page and print a message if we default to single
metadata in the case of an SSD.
 Makefile            |    2 +-
 man/mkfs.btrfs.8.in |    5 +++-
 mkfs.c              |   58 ++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 9694444..d827216 100644
--- a/Makefile
+++ b/Makefile
@@ -65,7 +65,7 @@ btrfsck: $(objects) btrfsck.o
 	$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
 
 mkfs.btrfs: $(objects) mkfs.o
-	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS) -lblkid
 
 btrfs-debug-tree: $(objects) debug-tree.o
 	$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index fc2e1d2..dfa7996 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -46,7 +46,10 @@ Specify a label for the filesystem.
 .TP
 \fB\-m\fR, \fB\-\-metadata \fIprofile\fR
 Specify how metadata must be spanned across the devices specified. Valid
-values are raid0, raid1, raid10 or single.
+values are raid0, raid1, raid10, single or dup.  Single device will have dup
+set by default except in the case of SSDs which will default to single.  This is
+because SSDs can remap blocks internally so duplicate blocks could end up in the
+same erase block which negates the benefits of doing metadata duplication.
 .TP
 \fB\-M\fR, \fB\-\-mixed\fR
 Mix data and metadata chunks together for more efficient space 
diff --git a/mkfs.c b/mkfs.c
index dff5eb8..8816db8 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -37,6 +37,7 @@
 #include <linux/fs.h>
 #include <ctype.h>
 #include <attr/xattr.h>
+#include <blkid/blkid.h>
 #include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -234,7 +235,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 data_profile,
 			      int data_profile_opt, u64 metadata_profile,
-			      int metadata_profile_opt, int mixed)
+			      int metadata_profile_opt, int mixed, int ssd)
 {
 	u64 num_devices = btrfs_super_num_devices(&root->fs_info->super_copy);
 	u64 allowed;
@@ -245,8 +246,12 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 	 * For mixed groups defaults are single/single.
 	 */
 	if (!metadata_profile_opt && !mixed) {
+		if (num_devices == 1 && ssd)
+			printf("Detected a SSD, turning off metadata "
+			       "duplication.  Mkfs with -m dup if you want to "
+			       "force metadata duplication.\n");
 		metadata_profile = (num_devices > 1) ?
-			BTRFS_BLOCK_GROUP_RAID1 : BTRFS_BLOCK_GROUP_DUP;
+			BTRFS_BLOCK_GROUP_RAID1 : (ssd) ? 0: BTRFS_BLOCK_GROUP_DUP;
 	}
 	if (!data_profile_opt && !mixed) {
 		data_profile = (num_devices > 1) ?
@@ -1201,6 +1206,49 @@ static int zero_output_file(int out_fd, u64 size, u32 sectorsize)
 	return ret;
 }
 
+static int is_ssd(const char *file)
+{
+	char *devname;
+	blkid_probe probe;
+	char *dev;
+	char path[PATH_MAX];
+	dev_t disk;
+	int fd;
+	char rotational;
+
+	probe = blkid_new_probe_from_filename(file);
+	if (!probe)
+		return 0;
+
+	/*
+	 * We want to use blkid_devno_to_wholedisk() but it's broken for some
+	 * reason on F17 at least so we'll do this trickery
+	 */
+	disk = blkid_probe_get_wholedisk_devno(probe);
+	devname = blkid_devno_to_devname(disk);
+
+	dev = strrchr(devname, '/');
+	dev++;
+
+	snprintf(path, PATH_MAX, "/sys/block/%s/queue/rotational", dev);
+
+	free(devname);
+	blkid_free_probe(probe);
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		return 0;
+	}
+
+	if (read(fd, &rotational, sizeof(char)) < sizeof(char)) {
+		close(fd);
+		return 0;
+	}
+	close(fd);
+
+	return !atoi((const char *)&rotational);
+}
+
 int main(int ac, char **av)
 {
 	char *file;
@@ -1227,6 +1275,7 @@ int main(int ac, char **av)
 	int data_profile_opt = 0;
 	int metadata_profile_opt = 0;
 	int nodiscard = 0;
+	int ssd = 0;
 
 	char *source_dir = NULL;
 	int source_dir_set = 0;
@@ -1352,6 +1401,9 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	}
+
+	ssd = is_ssd(file);
+
 	if (mixed) {
 		if (metadata_profile != data_profile) {
 			fprintf(stderr, "With mixed block groups data and metadata "
@@ -1438,7 +1490,7 @@ raid_groups:
 	if (!source_dir_set) {
 		ret = create_raid_groups(trans, root, data_profile,
 				 data_profile_opt, metadata_profile,
-				 metadata_profile_opt, mixed);
+				 metadata_profile_opt, mixed, ssd);
 		BUG_ON(ret);
 	}
 
-- 
1.7.7.6

