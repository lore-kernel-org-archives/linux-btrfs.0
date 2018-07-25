Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:13780 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728620AbeGYJ1k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 05:27:40 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 5882EAC0155
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 17:17:01 +0900 (JST)
Received: from g01jpexchyt33.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 8864B46E90E
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 17:17:00 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 3/3] btrfs-progs: ins: logical-resolve: Add v2 ioctl support
Date: Wed, 25 Jul 2018 17:20:18 +0900
Message-ID: <8dddcd251f0a081f5f3af7a174c55d2703b7bceb.1532501096.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1532501096.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1532501096.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add --ignore-offset option to logical-resolve command
to show how BTRFS_IOC_LOGICAL_INO_V2 ioctl works
(return every ref to the extent of given logical address).

Documentation is also updated to make meaning more clear.
See below example for more detailed explanation.

[Example]
$ mkfs.btrfs -f $DEV
$ mount $DEV /mnt

$ dd if=/dev/urandom of=/mnt/file bs=4k count=100
$ sync
// split above extent
$ dd if=/dev/urandom of=/mnt/file bs=4k seek=10 count=1 conv=notrunc
$ sync

$ filefrag -v /mnt/file
Filesystem type is: 9123683e
File size of /mnt/file is 409600 (100 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       9:       3392..      3401:     10:
   1:       10..      10:       3328..      3328:      1:       3402:
   2:       11..      99:       3403..      3491:     89:       3329: last,eof
/mnt/file: 3 extents found

// Actually extent 0 and 2 point to the same extent (with different offset):
$ btrfs inspect-internal dump-tree $DEV | \
    grep -A 2 "$((3392*4096) EXTENT_ITEM"
  item 2 key (13893632 EXTENT_ITEM 409600) itemoff 16153 itemsize 53
          refs 2 gen 7 flags DATA
          extent data backref root FS_TREE objectid 257 offset 0 count 2

$ btrfs inspect-internal dump-tree $DEV | \
    grep -A 4 "257 EXTENT_ITEM"
        item 7 key (257 EXTENT_DATA 0) itemoff 15733 itemsize 53
                generation 7 type 1 (regular)
                extent data disk byte 13893632 nr 409600
                extent data offset 0 nr 40960 ram 409600
                extent compression 0 (none)
        item 8 key (257 EXTENT_DATA 40960) itemoff 15680 itemsize 53
                generation 8 type 1 (regular)
                extent data disk byte 13631488 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 9 key (257 EXTENT_DATA 45056) itemoff 15627 itemsize 53
                generation 7 type 1 (regular)
                extent data disk byte 13893632 nr 409600
                extent data offset 45056 nr 364544 ram 409600
                extent compression 0 (none)

// v1 ioctl only returns the refs pointing given address block
$ btrfs inspect-internal logical-resolve -P $((3392*4096)) /mnt
inode 257 offset 0 root 5
$ btrfs inspect-internal logical-resolve -P $((3403*4096)) /mnt
inode 257 offset 45056 root 5

// v2 ioctl returns all refs pointing at least one block of given extent
$ btrfs inspect-internal logical-resolve -P --ignore-offset \
  $((3392*4096)) /mnt
inode 257 offset 0 root 5
inode 257 offset 45056 root 5

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 v1 -> v2
   - add explnation
   - add build assert
   - use long option istead of -i

 Documentation/btrfs-inspect-internal.asciidoc | 15 +++++++++++---
 cmds-inspect.c                                | 29 ++++++++++++++++++++++++---
 ioctl.h                                       | 11 +++++++++-
 libbtrfsutil/btrfs.h                          | 10 ++++++++-
 4 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index e2db6466..5f80323e 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -112,19 +112,28 @@ at 'path', ie. all hardlinks
 -v::::
 verbose mode, print count of returned paths and ioctl() return value
 
-*logical-resolve* [-Pv] [-s <bufsize>] <logical> <path>::
+*logical-resolve* [options] <logical> <path>::
 (needs root privileges)
 +
-resolve paths to all files at given 'logical' address in the linear filesystem space
+get all inode information whose extents containing the given 'logical'
+address blcok and then resolve each filesystem path
 +
 `Options`
 +
 -P::::
-skip the path resolving and print the inodes instead
+skip the path resolving and print the inode number, owner's subvolume id
+and offset in the extent
 -v::::
 verbose mode, print count of returned paths and all ioctl() return values
 -s <bufsize>::::
 set internal buffer for storing the file names to 'bufsize', default is 4096, maximum 64k
+--ignore-offset::::
+return all inode information which points to the extent
+containing the given logical address block regardless of offset.
+i.e. with this option, all files which includes at least one block of
+the extent will be shown, even if given logical address block is not
+included
+This requires version 2 ioctl support (BTRFS_IOC_LOGICAL_INO_V2, since 4.15)
 
 *min-dev-size* [options] <path>::
 (needs root privileges)
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 21aa2903..c261e773 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -124,13 +124,20 @@ static int cmd_inspect_inode_resolve(int argc, char **argv)
 }
 
 static const char * const cmd_inspect_logical_resolve_usage[] = {
-	"btrfs inspect-internal logical-resolve [-Pv] [-s bufsize] <logical> <path>",
+	"btrfs inspect-internal logical-resolve [options] <logical> <path>",
 	"Get file system paths for the given logical address",
 	"-P          skip the path resolving and print the inodes instead",
 	"-v          verbose mode",
 	"-s bufsize  set inode container's size. This is used to increase inode",
 	"            container's size in case it is not enough to read all the ",
 	"            resolved results. The max value one can set is 64k",
+	"--ignore-offset",
+	"            return all inode information which points to the extent",
+	"            containing the given logical address block regardless of",
+	"            offset. i.e. with this option, all files which includes",
+	"            at least one block of the extent will be shown, even if",
+	"            given logical address block is not included",
+	"            (requires version 2 ioctl support)",
 	NULL
 };
 
@@ -143,7 +150,9 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 	int getpath = 1;
 	int bytes_left;
 	u64 rootid;
+	int ignore_offset = 0;
 	struct btrfs_ioctl_logical_ino_args loi;
+	unsigned long ioctl_num = BTRFS_IOC_LOGICAL_INO;
 	struct btrfs_data_container *inodes;
 	u64 size = 4096;
 	char full_path[PATH_MAX];
@@ -153,7 +162,13 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 
 	optind = 0;
 	while (1) {
-		int c = getopt(argc, argv, "Pvs:");
+		int c;
+		static const struct option long_options[] = {
+			{ "ignore-offset", no_argument, NULL, 'i' },
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "Pvs:", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -167,6 +182,9 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 		case 's':
 			size = arg_strtou64(optarg);
 			break;
+		case 'i':
+			ignore_offset = 1;
+			break;
 		default:
 			usage(cmd_inspect_logical_resolve_usage);
 		}
@@ -214,13 +232,18 @@ printf("cannot resolve path when subvolume is mounted directly. try -P option\n"
 	loi.size = size;
 	loi.inodes = ptr_to_u64(inodes);
 
+	if (ignore_offset) {
+		loi.flags = BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
+		ioctl_num = BTRFS_IOC_LOGICAL_INO_V2;
+	}
+
 	fd = btrfs_open_dir(argv[optind + 1], &dirstream, 1);
 	if (fd < 0) {
 		ret = 12;
 		goto out;
 	}
 
-	ret = ioctl(fd, BTRFS_IOC_LOGICAL_INO, &loi);
+	ret = ioctl(fd, ioctl_num, &loi);
 	if (ret < 0) {
 		error("logical ino ioctl: %m");
 		goto out;
diff --git a/ioctl.h b/ioctl.h
index 709e996f..2d6f5d1a 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -491,10 +491,17 @@ BUILD_ASSERT(sizeof(struct btrfs_ioctl_ino_path_args) == 56);
 struct btrfs_ioctl_logical_ino_args {
 	__u64				logical;	/* in */
 	__u64				size;		/* in */
-	__u64				reserved[4];
+	__u64				reserved[3];	/* must be 0 for now */
+	__u64				flags;		/* in, v2 only */
 	/* struct btrfs_data_container	*inodes;	out   */
 	__u64				inodes;
 };
+BUILD_ASSERT(offsetof(struct btrfs_ioctl_logical_ino_args, flags) == 40);
+/*
+ * Return every ref to the extent, not just those containing logical block.
+ * Requires logical == extent bytenr.
+ */
+#define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
 
 enum btrfs_dev_stat_values {
 	/* disk I/O failure stats */
@@ -828,6 +835,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
                                   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
+					struct btrfs_ioctl_logical_ino_args)
 #ifdef __cplusplus
 }
 #endif
diff --git a/libbtrfsutil/btrfs.h b/libbtrfsutil/btrfs.h
index c293f6bf..b4debba7 100644
--- a/libbtrfsutil/btrfs.h
+++ b/libbtrfsutil/btrfs.h
@@ -609,10 +609,16 @@ struct btrfs_ioctl_ino_path_args {
 struct btrfs_ioctl_logical_ino_args {
 	__u64				logical;	/* in */
 	__u64				size;		/* in */
-	__u64				reserved[4];
+	__u64				reserved[3];	/* must be 0 for now */
+	__u64				flags;		/* in, v2 only */
 	/* struct btrfs_data_container	*inodes;	out   */
 	__u64				inodes;
 };
+/*
+ * Return every ref to the extent, not just those containing logical block.
+ * Requires logical == extent bytenr.
+ */
+#define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
 
 enum btrfs_dev_stat_values {
 	/* disk I/O failure stats */
@@ -836,5 +842,7 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
+					struct btrfs_ioctl_logical_ino_args)
 
 #endif /* _LINUX_BTRFS_H */
-- 
2.14.4


