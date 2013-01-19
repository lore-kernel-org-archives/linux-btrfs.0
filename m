Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo102.cox.net ([68.230.241.214]:41103 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3ASSGe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 13:06:34 -0500
Received: from eastrmimpo110 ([68.230.241.223]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130119180633.OZQC7113.eastrmfepo102.cox.net@eastrmimpo110>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 19 Jan 2013 13:06:33 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>, Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 6/6] Btrfs-progs: detect if the disk we are formatting is a ssd
Date: Sat, 19 Jan 2013 13:06:21 -0500
Message-Id: <1358618781-26629-7-git-send-email-gene@czarc.net>
In-Reply-To: <1358618781-26629-1-git-send-email-gene@czarc.net>
References: <1358618781-26629-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch rebased because of changes in mkfs.c but otherwise the same
as created by Josef Bacik

SSD's do not gain anything by having metadata DUP turned on.  The underlying
file system that is a part of all SSD's could easily map duplicate metadat
blocks into the same erase block which effectively eliminates the benefit of
duplicating the metadata on disk.  So detect if we are formatting a single
SSD drive and if we are do not use DUP.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 Makefile            |  2 +-
 man/mkfs.btrfs.8.in |  5 ++++-
 mkfs.c              | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 4894903..c7fd97d 100644
--- a/Makefile
+++ b/Makefile
@@ -67,7 +67,7 @@ btrfsck: $(objects) btrfsck.o
 	$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
 
 mkfs.btrfs: $(objects) mkfs.o
-	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
+	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS) -lblkid
 
 btrfs-debug-tree: $(objects) debug-tree.o
 	$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 72025ed..b7bcc1b 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -47,7 +47,10 @@ Specify a label for the filesystem.
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
index 8c291c9..b500ea0 100644
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
@@ -204,7 +205,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 data_profile,
 			      int data_profile_opt, u64 metadata_profile,
-			      int metadata_profile_opt, int mixed)
+			      int metadata_profile_opt, int mixed, int ssd)
 {
 	u64 num_devices = btrfs_super_num_devices(&root->fs_info->super_copy);
 	u64 allowed;
@@ -215,8 +216,12 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
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
@@ -1186,6 +1191,54 @@ static int check_leaf_or_node_size(u32 size, u32 sectorsize)
 	return 0;
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
+	if (!disk)
+		return 0;
+
+	devname = blkid_devno_to_devname(disk);
+	if (!devname)
+		return 0;
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
@@ -1212,6 +1265,7 @@ int main(int ac, char **av)
 	int data_profile_opt = 0;
 	int metadata_profile_opt = 0;
 	int nodiscard = 0;
+	int ssd = 0;
 
 	char *source_dir = NULL;
 	int source_dir_set = 0;
@@ -1331,6 +1385,9 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	}
+
+	ssd = is_ssd(file);
+
 	if (mixed) {
 		if (metadata_profile != data_profile) {
 			fprintf(stderr, "With mixed block groups data and metadata "
@@ -1416,7 +1473,7 @@ raid_groups:
 	if (!source_dir_set) {
 		ret = create_raid_groups(trans, root, data_profile,
 				 data_profile_opt, metadata_profile,
-				 metadata_profile_opt, mixed);
+				 metadata_profile_opt, mixed, ssd);
 		BUG_ON(ret);
 	}
 
-- 
1.8.1

