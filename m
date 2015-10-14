Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57036 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbbJNRkC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 13:40:02 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 14 Oct 2015 23:10:00 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 57F021258018
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 23:09:42 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9EHdsmo3867038
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 23:09:54 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9EHdrkc000704
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 23:09:54 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.com,
        chandan@mykolab.com
Subject: [PATCH V2] Btrfs-progs: Do not force mixed block group creation unless '-M' option is specified
Date: Wed, 14 Oct 2015 23:09:37 +0530
Message-Id: <1444844377-19776-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When creating small Btrfs filesystem instances (i.e. filesystem size <= 1GiB),
mkfs.btrfs fails if both sectorsize and nodesize are specified on the command
line and sectorsize != nodesize, since mixed block groups involves both data
and metadata blocks sharing the same block group. This is an incorrect behavior
when '-M' option isn't specified on the command line.

This commit makes optional the creation of mixed block groups i.e. Mixed block
groups are created only when -M option is specified on the command line.

Since we now allow small filesystem instances with sectorsize != nodesize to
be created, we can end up in the following situation,

[root@localhost ~]# mkfs.btrfs -f -n 65536 /dev/loop0
btrfs-progs v3.19-rc2-405-g976307c
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (512.00MiB) ...
Label:              (null)
UUID:               49fab72e-0c8b-466b-a3ca-d1bfe56475f0
Node size:          65536
Sector size:        4096
Filesystem size:    512.00MiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP              40.00MiB
  System:           DUP              12.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   512.00MiB  /dev/loop0
[root@localhost ~]# mount /dev/loop0 /mnt/
mount: mount /dev/loop0 on /mnt failed: No space left on device

The ENOSPC occurs during the creation of the UUID tree. This is because of
things like large metadata block size, DUP mode used for metadata and global
reservation consuming space. Also, large nodesize does not make sense on small
filesystems, hence this should not be an issue.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
v1->v2:
1. Move the fix to prevent creation of filesystem with 'mixed bgs' and having
   differing sectorsize and nodesize to another patch.
2. Add a NOTES section to Documentation/mkfs.btrfs.asciidoc to document a
   side-effect of this patch.
   
 Documentation/mkfs.btrfs.asciidoc | 35 ++++++++++++++++++++++++++++++++++-
 cmds-device.c                     |  3 +--
 cmds-replace.c                    |  3 +--
 mkfs.c                            | 20 +++++++-------------
 utils.c                           |  5 +----
 utils.h                           |  2 +-
 6 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index a9aa3cb..5789762 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -133,9 +133,42 @@ UNIT
 As default the unit is the byte, however it is possible to append a suffix
 to the arguments like 'k' for KBytes, 'm' for MBytes...
 
+NOTES
+-----
+Since mixed block group creation is optional, we allow small
+filesystem instances with differing values for sectorsize and nodesize
+to be created and could end up in the following situation,
+
+  [root@localhost ~]# mkfs.btrfs -f -n 65536 /dev/loop0
+  btrfs-progs v3.19-rc2-405-g976307c
+  See http://btrfs.wiki.kernel.org for more information.
+
+  Performing full device TRIM (512.00MiB) ...
+  Label:              (null)
+  UUID:               49fab72e-0c8b-466b-a3ca-d1bfe56475f0
+  Node size:          65536
+  Sector size:        4096
+  Filesystem size:    512.00MiB
+  Block group profiles:
+    Data:             single            8.00MiB
+    Metadata:         DUP              40.00MiB
+    System:           DUP              12.00MiB
+  SSD detected:       no
+  Incompat features:  extref, skinny-metadata
+  Number of devices:  1
+  Devices:
+    ID        SIZE  PATH
+     1   512.00MiB  /dev/loop0
+  [root@localhost ~]# mount /dev/loop0 /mnt/
+  mount: mount /dev/loop0 on /mnt failed: No space left on device
+
+The ENOSPC occurs during the creation of the UUID tree. This is
+because of things like large metadata block size, DUP mode used for
+metadata and global reservation consuming space.
+
 AVAILABILITY
 ------------
-*btrfs* is part of btrfs-progs.
+*mkfs.btrfs* is part of btrfs-progs.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 
diff --git a/cmds-device.c b/cmds-device.c
index 5f2b952..1b601cf 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -92,7 +92,6 @@ static int cmd_device_add(int argc, char **argv)
 		struct btrfs_ioctl_vol_args ioctl_args;
 		int	devfd, res;
 		u64 dev_block_count = 0;
-		int mixed = 0;
 		char *path;
 
 		res = test_dev_for_mkfs(argv[i], force);
@@ -109,7 +108,7 @@ static int cmd_device_add(int argc, char **argv)
 		}
 
 		res = btrfs_prepare_device(devfd, argv[i], 1, &dev_block_count,
-					   0, &mixed, discard);
+					   0, discard);
 		close(devfd);
 		if (res) {
 			ret++;
diff --git a/cmds-replace.c b/cmds-replace.c
index 9ab8438..e944457 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -140,7 +140,6 @@ static int cmd_replace_start(int argc, char **argv)
 	int force_using_targetdev = 0;
 	u64 dstdev_block_count;
 	int do_not_background = 0;
-	int mixed = 0;
 	DIR *dirstream = NULL;
 	u64 srcdev_size;
 	u64 dstdev_size;
@@ -281,7 +280,7 @@ static int cmd_replace_start(int argc, char **argv)
 	strncpy((char *)start_args.start.tgtdev_name, dstdev,
 		BTRFS_DEVICE_PATH_NAME_MAX);
 	ret = btrfs_prepare_device(fddstdev, dstdev, 1, &dstdev_block_count, 0,
-				 &mixed, 0);
+				0);
 	if (ret)
 		goto leave_with_error;
 
diff --git a/mkfs.c b/mkfs.c
index a5802f7..dc70a9a 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -152,7 +152,7 @@ err:
 }
 
 static int make_root_dir(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		int mixed, struct mkfs_allocation *allocation)
+		struct mkfs_allocation *allocation)
 {
 	struct btrfs_key location;
 	int ret;
@@ -1440,8 +1440,6 @@ int main(int ac, char **av)
 				break;
 			case 'b':
 				block_count = parse_size(optarg);
-				if (block_count <= BTRFS_MKFS_SMALL_VOLUME_SIZE)
-					mixed = 1;
 				zero_end = 0;
 				break;
 			case 'V':
@@ -1491,7 +1489,7 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	}
-	
+
 	while (dev_cnt-- > 0) {
 		file = av[optind++];
 		if (is_block_device(file) == 1)
@@ -1505,10 +1503,9 @@ int main(int ac, char **av)
 	file = av[optind++];
 	ssd = is_ssd(file);
 
-	if (is_vol_small(file) || mixed) {
+	if (mixed) {
 		if (verbose)
-			printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
-		mixed = 1;
+			printf("Forcing mixed metadata/data groups\n");
 	}
 
 	/*
@@ -1604,7 +1601,7 @@ int main(int ac, char **av)
 			exit(1);
 		}
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
-					   block_count, &mixed, discard);
+					   block_count, discard);
 		if (ret) {
 			close(fd);
 			exit(1);
@@ -1704,7 +1701,7 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
-	ret = make_root_dir(trans, root, mixed, &allocation);
+	ret = make_root_dir(trans, root, &allocation);
 	if (ret) {
 		fprintf(stderr, "failed to setup the root directory\n");
 		exit(1);
@@ -1725,8 +1722,6 @@ int main(int ac, char **av)
 		goto raid_groups;
 
 	while (dev_cnt-- > 0) {
-		int old_mixed = mixed;
-
 		file = av[optind++];
 
 		/*
@@ -1749,12 +1744,11 @@ int main(int ac, char **av)
 			continue;
 		}
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
-					   block_count, &mixed, discard);
+					   block_count, discard);
 		if (ret) {
 			close(fd);
 			exit(1);
 		}
-		mixed = old_mixed;
 
 		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
 					sectorsize, sectorsize, sectorsize);
diff --git a/utils.c b/utils.c
index f1e3248..269b510 100644
--- a/utils.c
+++ b/utils.c
@@ -847,7 +847,7 @@ out:
 }
 
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-			   u64 max_block_count, int *mixed, int discard)
+			   u64 max_block_count, int discard)
 {
 	u64 block_count;
 	struct stat st;
@@ -867,9 +867,6 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	if (max_block_count)
 		block_count = min(block_count, max_block_count);
 
-	if (block_count < BTRFS_MKFS_SMALL_VOLUME_SIZE && !(*mixed))
-		*mixed = 1;
-
 	if (discard) {
 		/*
 		 * We intentionally ignore errors from the discard ioctl.  It
diff --git a/utils.h b/utils.h
index 192f3d1..2e8293d 100644
--- a/utils.h
+++ b/utils.h
@@ -120,7 +120,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-			 u64 max_block_count, int *mixed, int discard);
+			 u64 max_block_count, int discard);
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
-- 
2.1.0

