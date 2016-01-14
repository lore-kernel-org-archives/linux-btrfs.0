Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31538 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752160AbcANGAR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 01:00:17 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 2EA7B41896E5
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 13:59:52 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 2/8] btrfs-progs: dedup: Add enable command for dedup command group
Date: Thu, 14 Jan 2016 13:57:44 +0800
Message-ID: <1452751070-2460-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452751070-2460-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452751070-2460-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add enable subcommand for dedup commmand group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedup.asciidoc |  62 ++++++++++++++++++-
 cmds-dedup.c                       | 120 +++++++++++++++++++++++++++++++++++++
 ioctl.h                            |   2 +
 kerncompat.h                       |   5 ++
 4 files changed, 188 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-dedup.asciidoc b/Documentation/btrfs-dedup.asciidoc
index 354313f..652f22d 100644
--- a/Documentation/btrfs-dedup.asciidoc
+++ b/Documentation/btrfs-dedup.asciidoc
@@ -19,7 +19,67 @@ use with caution.
 
 SUBCOMMAND
 ----------
-Nothing yet
+*enable* [options] <path>::
+Enable in-band de-duplication for a filesystem.
++
+`Options`
++
+-s|--storage-backend <BACKEND>::::
+Specify de-duplication hash storage backend.
+Supported backends are 'ondisk' and 'inmemory'
+If not specified, default value is 'inmemory'.
++
+Refer to *BACKENDS* sector for more information.
+
+-b|--blocksize <BLOCKSIZE>::::
+Specify dedup block size.
+Supported values are power of 2 from '16K' to '128K'.
+Default value is the larger of page size and '32K'.
++
+Refer to *BLOCKSIZE* sector for more information.
+
+-a|--hash-algorithm <HASH>::::
+Specify hash algorithm.
+Only 'sha256' is supported yet.
+
+-l|--limit <LIMIT>::::
+Specify limit of hash number.
+Only works for 'inmemory' backend.
+If *LIMIT* is zero, there will be no limit at all. Use with caution as it can
+use up all the memory for dedup hash.
+Default value is 4096 if using 'inmemory' backend.
+
+BACKENDS
+--------
+Btrfs in-band de-duplication support two different backends with their own
+features.
+
+In-memory backend::
+Designed for speed, in-memory backend will keep all dedup hash into memory.
+And it has a limit of number of hash kept in-memory.
+Hashes over the limit will be dropped following last recent use behavior.
+So this backend has a consistent overhead for given limit but can't ensure
+any all duplicated data will be de-duplicated.
++
+After umount and mount, in-memory backend need to refill its hash table.
+
+On-disk backend::
+Designed for de-duplication rate, on-disk backend will keep dedup hash on disk.
+This behavior may cause extra disk IO for de-duplication, but will have a much
+higher dedup rate.
++
+After umount and mount, on-disk backend still has its hash on disk, no need to
+refill its dedup hash table.
+
+BLOCKSIZE
+---------
+Block in-band de-duplication is done at block size unit.
+Any data smaller than dedup block size won't go through the dedup backends.
+
+Smaller block size will cause more fragments and lower performance, but a
+higher dedup rate.
+Larger block size will cause less fragments and higher performance, but a
+lower dedup rate.
 
 EXIT STATUS
 -----------
diff --git a/cmds-dedup.c b/cmds-dedup.c
index 800df34..e116f4c 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -36,8 +36,128 @@ static const char * const dedup_cmd_group_usage[] = {
 static const char dedup_cmd_group_info[] =
 "manage inband(write time) de-duplication";
 
+static const char * const cmd_dedup_enable_usage[] = {
+	"btrfs dedup enable [options] <path>",
+	"Enable in-band(write time) de-duplication of a btrfs.",
+	"",
+	"-s|--storage-backend <BACKEND>",
+	"           specify dedup hash storage backend",
+	"           supported backend: 'ondisk', 'inmemory'",
+	"           inmemory is the default backend",
+	"-b|--blocksize <BLOCKSIZE>",
+	"           specify dedup block size",
+	"           default value is the larger of page size and 16K",
+	"-a|--hash-algorithm <HASH>",
+	"           specify hash algorithm",
+	"           only 'sha256' is supported yet",
+	"-l|--limit <LIMIT>",
+	"           specify limit of hash number",
+	"           only for 'inmemory' backend",
+	"           default value is 4096 if using 'inmemory' backend",
+	NULL
+};
+
+static int cmd_dedup_enable(int argc, char **argv)
+{
+	int ret;
+	int fd;
+	char *path;
+	int pagesize = sysconf(_SC_PAGESIZE);
+	u64 blocksize = max(pagesize, BTRFS_DEDUP_BLOCKSIZE_DEFAULT);
+	u16 hash_type = BTRFS_DEDUP_HASH_SHA256;
+	u16 backend = BTRFS_DEDUP_BACKEND_INMEMORY;
+	u64 limit = 0;
+	struct btrfs_ioctl_dedup_args dargs;
+	DIR *dirstream;
+
+	while (1) {
+		int c;
+		static const struct option long_options[] = {
+			{ "storage-backend", required_argument, NULL, 's'},
+			{ "blocksize", required_argument, NULL, 'b'},
+			{ "hash-algorithm", required_argument, NULL, 'a'},
+			{ "limit", required_argument, NULL, 'l'},
+			{ NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "s:b:a:l:", long_options, NULL);
+		if (c < 0)
+			break;
+		switch (c) {
+		case 's':
+			if (!strcmp("ondisk", optarg))
+				backend = BTRFS_DEDUP_BACKEND_ONDISK;
+			else if (!strcmp("inmemory", optarg))
+				backend = BTRFS_DEDUP_BACKEND_INMEMORY;
+			else {
+				error("unsupported dedup backend: %s", optarg);
+				exit(1);
+			}
+			break;
+		case 'b':
+			blocksize = parse_size(optarg);
+			break;
+		case 'a':
+			if (strcmp("sha256", optarg)) {
+				error("unsupported dedup hash algorithm: %s",
+				      optarg);
+				return 1;
+			}
+			break;
+		case 'l':
+			limit = parse_size(optarg);
+			break;
+		}
+	}
+
+	path = argv[optind];
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_dedup_enable_usage);
+
+	/* Validation check */
+	if (!is_power_of_2(blocksize) ||
+	    blocksize > BTRFS_DEDUP_BLOCKSIZE_MAX ||
+	    blocksize < BTRFS_DEDUP_BLOCKSIZE_MIN ||
+	    blocksize < pagesize) {
+		error("invalid dedup blocksize: %llu, not in range [%llu,%llu] nor power of 2",
+		      blocksize, max(pagesize, BTRFS_DEDUP_BLOCKSIZE_MIN),
+		      BTRFS_DEDUP_BLOCKSIZE_MAX);
+		return 1;
+	}
+	if (limit && backend == BTRFS_DEDUP_BACKEND_ONDISK) {
+		error("limit is only valid for 'inmemory' backend");
+		return 1;
+	}
+
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		error("failed to open file or directory: %s", path);
+		return 1;
+	}
+	memset(&dargs, 0, sizeof(dargs));
+	dargs.cmd = BTRFS_DEDUP_CTL_ENABLE;
+	dargs.blocksize = blocksize;
+	dargs.hash_type = hash_type;
+	dargs.limit_nr = limit;
+	dargs.backend = backend;
+
+	ret = ioctl(fd, BTRFS_IOC_DEDUP_CTL, &dargs);
+	if (ret < 0) {
+		error("failed to enable inband deduplication: %s",
+		      strerror(errno));
+		ret = 1;
+		goto out;
+	}
+	ret = 0;
+
+out:
+	close_file_or_dir(fd, dirstream);
+	return ret;
+}
+
 const struct cmd_group dedup_cmd_group = {
 	dedup_cmd_group_usage, dedup_cmd_group_info, {
+		{ "enable", cmd_dedup_enable, cmd_dedup_enable_usage, NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
diff --git a/ioctl.h b/ioctl.h
index 7c9221d..6bff671 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -698,6 +698,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_DEDUP_CTL	_IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				      struct btrfs_ioctl_dedup_args)
 #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
                                   struct btrfs_ioctl_feature_flags)
 #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
diff --git a/kerncompat.h b/kerncompat.h
index 7c627ba..db1d77b 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -310,6 +310,11 @@ static inline long IS_ERR(const void *ptr)
 #define __bitwise
 #endif
 
+static inline int is_power_of_2(unsigned long n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
 typedef u16 __bitwise __le16;
 typedef u16 __bitwise __be16;
 typedef u32 __bitwise __le32;
-- 
2.7.0



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
