Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53942 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1425206AbcBRGUv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 01:20:51 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id AF0B34010CFD
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 14:20:21 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/8] btrfs-progs: dedup: Add enable command for dedup command group
Date: Thu, 18 Feb 2016 14:18:14 +0800
Message-Id: <1455776300-11234-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1455776300-11234-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1455776300-11234-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add enable subcommand for dedup commmand group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedup.asciidoc | 101 ++++++++++++++++++++++++++-
 cmds-dedup.c                       | 138 +++++++++++++++++++++++++++++++++++++
 ioctl.h                            |   2 +
 3 files changed, 240 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-dedup.asciidoc b/Documentation/btrfs-dedup.asciidoc
index 917977b..43d2fb7 100644
--- a/Documentation/btrfs-dedup.asciidoc
+++ b/Documentation/btrfs-dedup.asciidoc
@@ -21,7 +21,106 @@ use with caution.
 
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
+Supported backends are 'ondisk' and 'inmemory'.
+If not specified, default value is 'inmemory'.
++
+Refer to *BACKENDS* sector for more information.
+
+-b|--blocksize <BLOCKSIZE>::::
+Specify dedup block size.
+Supported values are power of 2 from '16K' to '8M'.
+Default value is '128K'.
++
+Refer to *BLOCKSIZE* sector for more information.
+
+-a|--hash-algorithm <HASH>::::
+Specify hash algorithm.
+Only 'sha256' is supported yet.
+
+-l|--limit-hash <LIMIT>::::
+Specify maximum number of hashes stored in memory.
+Only works for 'inmemory' backend.
+Conflicts with '-m' option.
++
+Only positive values are valid.
+Default value is '32K'.
+
+-m|--limit-memory <LIMIT>::::
+Specify maximum memory used for hashes.
+Only works for 'inmemory' backend.
+Conflicts with '-l' option.
++
+Only positive values are valid.
+No default value.
+
+WARNING: Too large value for '-l' or '-m' will easily trigger OOM.
+Please use with caution according to system memory or use 'ondisk' backend
+if memory usage is critical.
+
+BACKENDS
+--------
+Btrfs in-band de-duplication support two different backends with their own
+features.
+
+In-memory backend::
+This backend provides backward-compatibility, and more fine-tuning options.
+But hash pool is non-persistent and may exhaust kernel memory if not setup
+properly.
++
+This backend can be used on old btrfs(without '-O dedup' mkfs option).
+When used on old btrfs, this backend needs to be enabled manually after mount.
++
+Designed for fast hash search speed, in-memory backend will keep all dedup
+hashes in memory. (Although overall performance is still much the same with
+'ondisk' backend)
++
+And only keeps limited number of hash in memory to avoid exhausting memory.
+Hashes over the limit will be dropped following Last-Recent-Use behavior.
+So this backend has a consistent overhead for given limit but can\'t ensure
+any all duplicated blocks will be de-duplicated.
++
+After umount and mount, in-memory backend need to refill its hash pool.
+
+On-disk backend::
+This backend provides persistent hash pool, with more smart memory management
+for hash pool.
+But it\'s not backward-compatible, meaning it must be used with '-O dedup' mkfs
+option and older kernel can\'t mount it read-write.
++
+Designed for de-duplication rate, hash pool is stored as B+ tree on disk.
+Although this behavior may cause extra disk IO for hash search under extreme
+high memory pressure,
+under most case the overall performance should be on par with 'inmemory'
+backend.
++
+After umount and mount, on-disk backend still has its hash on disk, no need to
+refill its dedup hash pool.
+
+DEDUP BLOCK SIZE
+----------------
+In-band de-duplication is done at dedup block size.
+Any data smaller than dedup block size won\'t go through in-band
+de-duplication.
+
+And dedup block size affects dedup rate and fragmentation heavily.
+
+Smaller block size will cause more fragments, but higher dedup rate.
+
+Larger block size will cause less fragments, but lower dedup rate.
+
+In-band de-duplication rate is highly related to the workload pattern.
+So it\'s highly recommended to align dedup block size to the workload
+block size to make full use of de-duplication.
+
+And dedup block size larger than 128K will cause compression unavailable, as
+compression only support maximum extent size of 128K.
 
 EXIT STATUS
 -----------
diff --git a/cmds-dedup.c b/cmds-dedup.c
index 800df34..1da416f 100644
--- a/cmds-dedup.c
+++ b/cmds-dedup.c
@@ -19,6 +19,7 @@
 #include <getopt.h>
 #include <unistd.h>
 #include <sys/ioctl.h>
+#include <sys/ioctl.h>
 
 #include "ctree.h"
 #include "ioctl.h"
@@ -36,8 +37,145 @@ static const char * const dedup_cmd_group_usage[] = {
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
+	"           default value is 128K",
+	"-a|--hash-algorithm <HASH>",
+	"           specify hash algorithm",
+	"           only 'sha256' is supported yet",
+	"-l|--limit-hash <LIMIT>",
+	"           specify maximum number of hashes stored in memory",
+	"           only for 'inmemory' backend",
+	"           default value is 32K if using 'inmemory' backend",
+	"-m|--limit-mem <LIMIT>",
+	"           specify maximum memory used for hashes",
+	"           only for 'inmemory' backend",
+	"           only one of '-m' and '-l' is allowed",
+	NULL
+};
+
+static int cmd_dedup_enable(int argc, char **argv)
+{
+	int ret;
+	int fd;
+	char *path;
+	u64 blocksize = BTRFS_DEDUP_BLOCKSIZE_DEFAULT;
+	u16 hash_type = BTRFS_DEDUP_HASH_SHA256;
+	u16 backend = BTRFS_DEDUP_BACKEND_INMEMORY;
+	u64 limit_nr = 0;
+	u64 limit_mem = 0;
+	struct btrfs_ioctl_dedup_args dargs;
+	DIR *dirstream;
+
+	while (1) {
+		int c;
+		static const struct option long_options[] = {
+			{ "storage-backend", required_argument, NULL, 's'},
+			{ "blocksize", required_argument, NULL, 'b'},
+			{ "hash-algorithm", required_argument, NULL, 'a'},
+			{ "limit-hash", required_argument, NULL, 'l'},
+			{ "limit-memory", required_argument, NULL, 'm'},
+			{ NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "s:b:a:l:m:", long_options, NULL);
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
+			limit_nr = parse_size(optarg);
+			break;
+		case 'm':
+			limit_mem = parse_size(optarg);
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
+	    blocksize < BTRFS_DEDUP_BLOCKSIZE_MIN) {
+		error("invalid dedup blocksize: %llu, not in range [%u,%u] or power of 2",
+		      blocksize, BTRFS_DEDUP_BLOCKSIZE_MIN,
+		      BTRFS_DEDUP_BLOCKSIZE_MAX);
+		return 1;
+	}
+	if ((limit_nr || limit_mem) && backend == BTRFS_DEDUP_BACKEND_ONDISK) {
+		error("limit is only valid for 'inmemory' backend");
+		return 1;
+	}
+	if (limit_nr && limit_mem) {
+		error("limit-memory and limit-hash can't be given at the same time");
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
+	dargs.limit_nr = limit_nr;
+	dargs.limit_mem = limit_mem;
+	dargs.backend = backend;
+
+	ret = ioctl(fd, BTRFS_IOC_DEDUP_CTL, &dargs);
+	if (ret < 0) {
+		char *error_message = NULL;
+		/* Special case, provide better error message */
+		if (backend == BTRFS_DEDUP_BACKEND_ONDISK &&
+		    errno == -EOPNOTSUPP)
+			error_message = "Need 'dedup' mkfs feature to enable ondisk backend";
+		error("failed to enable inband deduplication: %s",
+		      error_message ? error_message : strerror(errno));
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
index b19d4e6..4de92d5 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -724,6 +724,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_DEDUP_CTL	_IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				      struct btrfs_ioctl_dedup_args)
 #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
                                   struct btrfs_ioctl_feature_flags)
 #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
-- 
2.7.1



