Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54022 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751259AbdCPBuR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 21:50:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id EE06448A2975
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Mar 2017 09:50:01 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v10 2/5] btrfs-progs: dedupe: Add enable command for dedupe command group
Date: Thu, 16 Mar 2017 09:49:53 +0800
Message-ID: <20170316014956.19916-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170316014956.19916-1-quwenruo@cn.fujitsu.com>
References: <20170316014956.19916-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add enable subcommand for dedupe commmand group.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedupe-inband.asciidoc | 114 ++++++++++++++-
 btrfs-completion                           |   6 +-
 cmds-dedupe-ib.c                           | 225 +++++++++++++++++++++++++++++
 ioctl.h                                    |   2 +
 4 files changed, 345 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-dedupe-inband.asciidoc b/Documentation/btrfs-dedupe-inband.asciidoc
index 9ee2bc75..82f970a6 100644
--- a/Documentation/btrfs-dedupe-inband.asciidoc
+++ b/Documentation/btrfs-dedupe-inband.asciidoc
@@ -22,7 +22,119 @@ use with caution.
 
 SUBCOMMAND
 ----------
-Nothing yet
+*enable* [options] <path>::
+Enable in-band de-duplication for a filesystem.
++
+`Options`
++
+-f|--force::::
+Force 'enable' command to be exected.
+Will skip memory limit check and allow 'enable' to be executed even in-band
+de-duplication is already enabled.
++
+NOTE: If re-enable dedupe with '-f' option, any unspecified parameter will be
+reset to its default value.
+
+-s|--storage-backend <BACKEND>::::
+Specify de-duplication hash storage backend.
+Only 'inmemory' backend is supported yet.
+If not specified, default value is 'inmemory'.
++
+Refer to *BACKENDS* sector for more information.
+
+-b|--blocksize <BLOCKSIZE>::::
+Specify dedupe block size.
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
+Only value larger than or equal to '1024' is valid.
+No default value.
++
+NOTE: Memory limit will be rounded down to kernel internal hash size,
+so the memory limit shown in 'btrfs dedupe status' may be different
+from the <LIMIT>.
+
+WARNING: Too large value for '-l' or '-m' will easily trigger OOM.
+Please use with caution according to system memory.
+
+NOTE: In-band de-duplication is not compactible with compression yet.
+And compression has higher priority than in-band de-duplication, means if
+compression and de-duplication is enabled at the same time, only compression
+will work.
+
+BACKENDS
+--------
+Btrfs in-band de-duplication will support different storage backends, with
+different use case and features.
+
+In-memory backend::
+This backend provides backward-compatibility, and more fine-tuning options.
+But hash pool is non-persistent and may exhaust kernel memory if not setup
+properly.
++
+This backend can be used on old btrfs(without '-O dedupe' mkfs option).
+When used on old btrfs, this backend needs to be enabled manually after mount.
++
+Designed for fast hash search speed, in-memory backend will keep all dedupe
+hashes in memory. (Although overall performance is still much the same with
+'ondisk' backend if all 'ondisk' hash can be cached in memory)
++
+And only keeps limited number of hash in memory to avoid exhausting memory.
+Hashes over the limit will be dropped following Last-Recent-Use behavior.
+So this backend has a consistent overhead for given limit but can\'t ensure
+all duplicated blocks will be de-duplicated.
++
+After umount and mount, in-memory backend need to refill its hash pool.
+
+On-disk backend::
+This backend provides persistent hash pool, with more smart memory management
+for hash pool.
+But it\'s not backward-compatible, meaning it must be used with '-O dedupe' mkfs
+option and older kernel can\'t mount it read-write.
++
+Designed for de-duplication rate, hash pool is stored as btrfs B+ tree on disk.
+This behavior may cause extra disk IO for hash search under high memory
+pressure.
++
+After umount and mount, on-disk backend still has its hash on disk, no need to
+refill its dedupe hash pool.
+
+Currently, only 'inmemory' backend is supported in btrfs-progs.
+
+DEDUPE BLOCK SIZE
+----------------
+In-band de-duplication is done at dedupe block size.
+Any data smaller than dedupe block size won\'t go through in-band
+de-duplication.
+
+And dedupe block size affects dedupe rate and fragmentation heavily.
+
+Smaller block size will cause more fragments, but higher dedupe rate.
+
+Larger block size will cause less fragments, but lower dedupe rate.
+
+In-band de-duplication rate is highly related to the workload pattern.
+So it\'s highly recommended to align dedupe block size to the workload
+block size to make full use of de-duplication.
 
 EXIT STATUS
 -----------
diff --git a/btrfs-completion b/btrfs-completion
index 3ede77b6..50f7ea2b 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -29,7 +29,7 @@ _btrfs()
 
 	local cmd=${words[1]}
 
-    commands='subvolume filesystem balance device scrub check rescue restore inspect-internal property send receive quota qgroup replace help version'
+    commands='subvolume filesystem balance device scrub check rescue restore inspect-internal property send receive quota qgroup dedupe replace help version'
     commands_subvolume='create delete list snapshot find-new get-default set-default show sync'
     commands_filesystem='defragment sync resize show df label usage'
     commands_balance='start pause cancel resume status'
@@ -40,6 +40,7 @@ _btrfs()
     commands_property='get set list'
     commands_quota='enable disable rescan'
     commands_qgroup='assign remove create destroy show limit'
+    commands_dedupe='enable'
     commands_replace='start status cancel'
 
 	if [[ "$cur" == -* && $cword -le 3 && "$cmd" != "help" ]]; then
@@ -94,6 +95,9 @@ _btrfs()
             qgroup)
                 opts="$commands_qgroup"
                 ;;
+            dedupe)
+                opts="$commands_dedupe"
+                ;;
             replace)
                 opts="$commands_replace"
                 ;;
diff --git a/cmds-dedupe-ib.c b/cmds-dedupe-ib.c
index f4d31386..cc9928aa 100644
--- a/cmds-dedupe-ib.c
+++ b/cmds-dedupe-ib.c
@@ -19,11 +19,13 @@
 #include <getopt.h>
 #include <unistd.h>
 #include <sys/ioctl.h>
+#include <sys/sysinfo.h>
 
 #include "ctree.h"
 #include "ioctl.h"
 
 #include "commands.h"
+#include "help.h"
 #include "utils.h"
 #include "kerncompat.h"
 #include "dedupe-ib.h"
@@ -36,8 +38,231 @@ static const char * const dedupe_ib_cmd_group_usage[] = {
 static const char dedupe_ib_cmd_group_info[] =
 "manage inband(write time) de-duplication";
 
+static const char * const cmd_dedupe_ib_enable_usage[] = {
+	"btrfs dedupe-inband enable [options] <path>",
+	"Enable in-band(write time) de-duplication of a btrfs.",
+	"",
+	"-s|--storage-backend <BACKEND>",
+	"           specify dedupe hash storage backend",
+	"           supported backend: 'inmemory'",
+	"-b|--blocksize <BLOCKSIZE>",
+	"           specify dedupe block size",
+	"           default value is 128K",
+	"-a|--hash-algorithm <HASH>",
+	"           specify hash algorithm",
+	"           only 'sha256' is supported yet",
+	"-l|--limit-hash <LIMIT>",
+	"           specify maximum number of hashes stored in memory",
+	"           only for 'inmemory' backend",
+	"           positive value is valid, default value is 32K",
+	"-m|--limit-mem <LIMIT>",
+	"           specify maximum memory used for hashes",
+	"           only for 'inmemory' backend",
+	"           value larger than or equal to 1024 is valid, no default",
+	"           only one of '-m' and '-l' is allowed",
+	"-f|--force",
+	"           force enable command to be executed",
+	"           will skip some memory limit check",
+	"           also without this flag enable command is not allowed to be",
+	"           executed if dedupe is already enabled",
+	"           note: unspecified parameter will be reset to default value",
+	NULL
+};
+
+
+#define report_fatal_parameter(dargs, old, member, type, err_val, fmt)	\
+if (dargs->member != old->member && dargs->member == (type)(err_val)) {	\
+	error("unsupported dedupe "#member": %"#fmt"", old->member);	\
+	return;								\
+}
+
+#define report_option_parameter(dargs, old, member, type, err_val, fmt)	\
+if (dargs->member != old->member && dargs->member == (type)(err_val))	\
+	warning("unsupported optional "#member": %"#fmt", continue",	\
+		old->member);
+static void report_parameter_error(struct btrfs_ioctl_dedupe_args *dargs,
+				   struct btrfs_ioctl_dedupe_args *old)
+{
+	if (dargs->flags == (u8)-1) {
+		if (dargs->status == 1 &&
+		    old->cmd == BTRFS_DEDUPE_CTL_ENABLE &&
+		    !(old->flags & BTRFS_DEDUPE_FLAG_FORCE)) {
+			error("can't re-enable dedupe without --force");
+			return;
+		}
+		report_option_parameter(dargs, old, flags, u8, -1, x);
+	}
+	report_fatal_parameter(dargs, old, cmd, u16, -1, u);
+	report_fatal_parameter(dargs, old, blocksize, u64, -1, llu);
+	report_fatal_parameter(dargs, old, backend, u16, -1, u);
+	report_fatal_parameter(dargs, old, hash_algo, u16, -1, u);
+	if (dargs->limit_nr == 0 && dargs->limit_mem == 0)
+		error("unsupported dedupe limit combination: nr: %llu, mem: %llu",
+				old->limit_nr, old->limit_mem);
+	return;
+}
+
+static int cmd_dedupe_ib_enable(int argc, char **argv)
+{
+	int ret;
+	int fd = -1;
+	char *path;
+	u64 blocksize = BTRFS_DEDUPE_BLOCKSIZE_DEFAULT;
+	u16 hash_algo = BTRFS_DEDUPE_HASH_SHA256;
+	u16 backend = BTRFS_DEDUPE_BACKEND_INMEMORY;
+	u64 limit_nr = 0;
+	u64 limit_mem = 0;
+	u64 sys_mem = 0;
+	int force = 0;
+	struct btrfs_ioctl_dedupe_args dargs;
+	struct btrfs_ioctl_dedupe_args backup;
+	struct sysinfo info;
+	DIR *dirstream = NULL;
+
+	while (1) {
+		int c;
+		static const struct option long_options[] = {
+			{ "storage-backend", required_argument, NULL, 's'},
+			{ "blocksize", required_argument, NULL, 'b'},
+			{ "hash-algorithm", required_argument, NULL, 'a'},
+			{ "limit-hash", required_argument, NULL, 'l'},
+			{ "limit-memory", required_argument, NULL, 'm'},
+			{ "force", required_argument, NULL, 'f'},
+			{ NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "s:b:a:l:m:", long_options, NULL);
+		if (c < 0)
+			break;
+		switch (c) {
+		case 's':
+			if (!strcasecmp("inmemory", optarg))
+				backend = BTRFS_DEDUPE_BACKEND_INMEMORY;
+			else {
+				error("unsupported dedupe backend: %s", optarg);
+				exit(1);
+			}
+			break;
+		case 'b':
+			blocksize = parse_size(optarg);
+			break;
+		case 'a':
+			if (strcmp("sha256", optarg)) {
+				error("unsupported dedupe hash algorithm: %s",
+				      optarg);
+				return 1;
+			}
+			break;
+		case 'l':
+			limit_nr = parse_size(optarg);
+			if (limit_nr == 0) {
+				error("limit should be larger than 0");
+				return 1;
+			}
+			break;
+		case 'm':
+			limit_mem = parse_size(optarg);
+			/*
+			 * Make sure at least one hash is allocated
+			 * 1024 should be good enough though.
+			 */
+			if (limit_mem < 1024) {
+				error("memory limit should be larger than or equal to 1024");
+				return 1;
+			}
+			break;
+		case 'f':
+			force = 1;
+			break;
+		default:
+			usage(cmd_dedupe_ib_enable_usage);
+			return 1;
+		}
+	}
+
+	path = argv[optind];
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_dedupe_ib_enable_usage);
+
+	/* Validation check */
+	if (!is_power_of_2(blocksize) ||
+	    blocksize > BTRFS_DEDUPE_BLOCKSIZE_MAX ||
+	    blocksize < BTRFS_DEDUPE_BLOCKSIZE_MIN) {
+		error("invalid dedupe blocksize: %llu, not in range [%u,%u] or power of 2",
+		      blocksize, BTRFS_DEDUPE_BLOCKSIZE_MIN,
+		      BTRFS_DEDUPE_BLOCKSIZE_MAX);
+		return 1;
+	}
+	if ((limit_nr || limit_mem) && backend != BTRFS_DEDUPE_BACKEND_INMEMORY) {
+		error("limit is only valid for 'inmemory' backend");
+		return 1;
+	}
+	if (limit_nr && limit_mem) {
+		error("limit-memory and limit-hash can't be given at the same time");
+		return 1;
+	}
+
+	ret = sysinfo(&info);
+	if (ret < 0)
+		warning("failed to determine system total ram size: %s",
+			strerror(errno));
+	else
+		sys_mem = info.totalram;
+
+	/*
+	 * TODO: Add check for limit_nr against current system
+	 * memory to avoid wrongly set limit.
+	 */
+	if (!force && limit_mem && sys_mem && sys_mem < limit_mem * 4) {
+		dargs.limit_mem = limit_mem;
+		goto mem_check;
+	}
+
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		error("failed to open file or directory: %s", path);
+		return 1;
+	}
+	memset(&dargs, -1, sizeof(dargs));
+	dargs.cmd = BTRFS_DEDUPE_CTL_ENABLE;
+	dargs.blocksize = blocksize;
+	dargs.hash_algo = hash_algo;
+	dargs.limit_nr = limit_nr;
+	dargs.limit_mem = limit_mem;
+	dargs.backend = backend;
+	if (force)
+		dargs.flags |= BTRFS_DEDUPE_FLAG_FORCE;
+	else
+		dargs.flags = 0;
+
+	memcpy(&backup, &dargs, sizeof(dargs));
+	ret = ioctl(fd, BTRFS_IOC_DEDUPE_CTL, &dargs);
+	if (ret < 0) {
+		error("failed to enable inband deduplication: %s",
+		      strerror(errno));
+		report_parameter_error(&dargs, &backup);
+		ret = 1;
+		goto out;
+	}
+	ret = 0;
+mem_check:
+	if (!force && dargs.limit_mem > sys_mem / 4) {
+		ret = 1;
+		error("memory limit %llu is too large compared to system memory: %llu",
+		      limit_mem, sys_mem);
+		error("recommened memory limit is no more than %llu",
+		      sys_mem / 4);
+		error("use --force option if you know what you are doing");
+	}
+out:
+	close_file_or_dir(fd, dirstream);
+	return ret;
+}
+
 const struct cmd_group dedupe_ib_cmd_group = {
 	dedupe_ib_cmd_group_usage, dedupe_ib_cmd_group_info, {
+		{ "enable", cmd_dedupe_ib_enable, cmd_dedupe_ib_enable_usage,
+		  NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
diff --git a/ioctl.h b/ioctl.h
index 8268c035..b2500b24 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -856,6 +856,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				    struct btrfs_ioctl_dev_replace_args)
 #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
 					 struct btrfs_ioctl_same_args)
+#define BTRFS_IOC_DEDUPE_CTL	_IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				      struct btrfs_ioctl_dedupe_args)
 #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
                                   struct btrfs_ioctl_feature_flags)
 #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
-- 
2.12.0



