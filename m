Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19281 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751163AbdBXGGb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Feb 2017 01:06:31 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
CC: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 1/9] btrfs-progs: Introduce kernel sizes to cleanup large intermediate number
Date: Fri, 24 Feb 2017 13:52:24 +0800
Message-ID: <20170224055232.4140-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
References: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Large numbers like (1024 * 1024 * 1024) may cost reader/reviewer to
waste one second to convert to 1G.

Introduce kernel include/linux/sizes.h to replace any intermediate
number larger than 4096 (not including 4096) to SZ_*.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 btrfs-map-logical.c |  2 +-
 cmds-fi-usage.c     |  2 +-
 cmds-filesystem.c   |  2 +-
 cmds-inspect.c      |  6 +++---
 cmds-scrub.c        |  2 +-
 cmds-send.c         |  2 +-
 ctree.c             |  7 ++++---
 ctree.h             |  6 ++++--
 disk-io.c           |  2 +-
 disk-io.h           |  5 +++--
 extent-tree.c       | 15 +++++++--------
 free-space-cache.c  |  2 +-
 kernel-lib/sizes.h  | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 send.h              |  2 +-
 utils.c             |  8 ++++----
 utils.h             |  9 +++++----
 volumes.c           | 20 ++++++++++----------
 volumes.h           |  2 +-
 18 files changed, 96 insertions(+), 45 deletions(-)
 create mode 100644 kernel-lib/sizes.h

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index e49a735e..bcbf2d90 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -30,7 +30,7 @@
 #include "list.h"
 #include "utils.h"
 
-#define BUFFER_SIZE (64 * 1024)
+#define BUFFER_SIZE SZ_64K
 
 /* we write the mirror info to stdout unless they are dumping the data
  * to stdout
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 88e346ad..394de0c2 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -301,7 +301,7 @@ static void get_raid56_used(int fd, struct chunk_info *chunks, int chunkcount,
 	}
 }
 
-#define	MIN_UNALOCATED_THRESH	(16 * 1024 * 1024)
+#define	MIN_UNALOCATED_THRESH	SZ_16M
 static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		int chunkcount, struct device_info *devinfo, int devcount,
 		char *path, unsigned unit_mode)
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index e7d31364..7174891a 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1030,7 +1030,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	 * better results and is independent of the kernel default. We have to
 	 * use the v2 defrag ioctl.
 	 */
-	thresh = 32 * 1024 * 1024;
+	thresh = SZ_32M;
 
 	defrag_global_errors = 0;
 	defrag_global_verbose = 0;
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 5e58a284..ac3da618 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -173,7 +173,7 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_inspect_logical_resolve_usage);
 
-	size = min(size, (u64)64 * 1024);
+	size = min(size, (u64)SZ_64K);
 	inodes = malloc(size);
 	if (!inodes)
 		return 1;
@@ -486,7 +486,7 @@ static void adjust_dev_min_size(struct list_head *extents,
 		 * chunk tree, so often this can lead to the need of allocating
 		 * a new system chunk too, which has a maximum size of 32Mb.
 		 */
-		*min_size += 32 * 1024 * 1024;
+		*min_size += SZ_32M;
 	}
 }
 
@@ -500,7 +500,7 @@ static int print_min_dev_size(int fd, u64 devid)
 	 * possibility of deprecating/removing it has been discussed, so we
 	 * ignore it here.
 	 */
-	u64 min_size = 1 * 1024 * 1024ull;
+	u64 min_size = SZ_1M;
 	struct btrfs_ioctl_search_args args;
 	struct btrfs_ioctl_search_key *sk = &args.key;
 	u64 last_pos = (u64)-1;
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 2cf7f308..292a5dfd 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -467,7 +467,7 @@ static struct scrub_file_record **scrub_read_file(int fd, int report_errors)
 {
 	int avail = 0;
 	int old_avail = 0;
-	char l[16 * 1024];
+	char l[SZ_16K];
 	int state = 0;
 	int curr = -1;
 	int i = 0;
diff --git a/cmds-send.c b/cmds-send.c
index cec11e6b..6c0a3dc3 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -44,7 +44,7 @@
 #include "send.h"
 #include "send-utils.h"
 
-#define SEND_BUFFER_SIZE	(64 * 1024)
+#define SEND_BUFFER_SIZE	SZ_64K
 
 /*
  * Default is 1 for historical reasons, changing may break scripts that expect
diff --git a/ctree.c b/ctree.c
index d07ec7d9..e3d687fb 100644
--- a/ctree.c
+++ b/ctree.c
@@ -21,6 +21,7 @@
 #include "print-tree.h"
 #include "repair.h"
 #include "internal.h"
+#include "sizes.h"
 
 static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level);
@@ -368,7 +369,7 @@ int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	search_start = buf->start & ~((u64)(1024 * 1024 * 1024) - 1);
+	search_start = buf->start & ~((u64)SZ_1G - 1);
 	ret = __btrfs_cow_block(trans, root, buf, parent,
 				 parent_slot, cow_ret, search_start, 0);
 	return ret;
@@ -1026,9 +1027,9 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 			nread += blocksize;
 		}
 		nscan++;
-		if (path->reada < 2 && (nread > (256 * 1024) || nscan > 32))
+		if (path->reada < 2 && (nread > SZ_256K || nscan > 32))
 			break;
-		if(nread > (1024 * 1024) || nscan > 128)
+		if(nread > SZ_1M || nscan > 128)
 			break;
 
 		if (search < lowest_read)
diff --git a/ctree.h b/ctree.h
index 0c34ae20..401257f4 100644
--- a/ctree.h
+++ b/ctree.h
@@ -26,6 +26,7 @@
 #include "extent-cache.h"
 #include "extent_io.h"
 #include "ioctl.h"
+#include "sizes.h"
 #else
 #include <btrfs/list.h>
 #include <btrfs/kerncompat.h>
@@ -33,6 +34,7 @@
 #include <btrfs/extent-cache.h>
 #include <btrfs/extent_io.h>
 #include <btrfs/ioctl.h>
+#include <linux/sizes.h>
 #endif /* BTRFS_FLAT_INCLUDES */
 
 struct btrfs_root;
@@ -601,7 +603,7 @@ struct btrfs_extent_item_v0 {
 
 #define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r) >> 4) - \
 					sizeof(struct btrfs_item))
-#define BTRFS_MAX_EXTENT_SIZE		(128 * 1024 * 1024)
+#define BTRFS_MAX_EXTENT_SIZE		SZ_128M
 
 #define BTRFS_EXTENT_FLAG_DATA		(1ULL << 0)
 #define BTRFS_EXTENT_FLAG_TREE_BLOCK	(1ULL << 1)
@@ -952,7 +954,7 @@ struct btrfs_csum_item {
  *  - the first 64k blank is useful for some boot loader/manager
  *  - the first 1M could be scratched by buggy partitioner or somesuch
  */
-#define BTRFS_BLOCK_RESERVED_1M_FOR_SUPER	((u64)1024 * 1024)
+#define BTRFS_BLOCK_RESERVED_1M_FOR_SUPER	((u64)SZ_1M)
 
 /* tag for the radix tree of block groups in ram */
 #define BTRFS_BLOCK_GROUP_DATA		(1ULL << 0)
diff --git a/disk-io.c b/disk-io.c
index 2a94d4fc..318128cc 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -207,7 +207,7 @@ void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			     bytenr, &length, &multi, 0, NULL)) {
 		device = multi->stripes[0].dev;
 		device->total_ios++;
-		blocksize = min(blocksize, (u32)(64 * 1024));
+		blocksize = min(blocksize, (u32)SZ_64K);
 		readahead(device->fd, multi->stripes[0].physical, blocksize);
 	}
 
diff --git a/disk-io.h b/disk-io.h
index 1c8387e7..c4afea3f 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -21,8 +21,9 @@
 
 #include "kerncompat.h"
 #include "ctree.h"
+#include "sizes.h"
 
-#define BTRFS_SUPER_INFO_OFFSET (64 * 1024)
+#define BTRFS_SUPER_INFO_OFFSET SZ_64K
 #define BTRFS_SUPER_INFO_SIZE 4096
 
 #define BTRFS_SUPER_MIRROR_MAX	 3
@@ -99,7 +100,7 @@ enum btrfs_read_sb_flags {
 
 static inline u64 btrfs_sb_offset(int mirror)
 {
-	u64 start = 16 * 1024;
+	u64 start = SZ_16K;
 	if (mirror)
 		return start << (BTRFS_SUPER_MIRROR_SHIFT * mirror);
 	return BTRFS_SUPER_INFO_OFFSET;
diff --git a/extent-tree.c b/extent-tree.c
index b2847ff9..3635395c 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2691,7 +2691,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 		}
 		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				     num_bytes + 2 * 1024 * 1024, data);
+				     num_bytes + SZ_2M, data);
 		BUG_ON(ret);
 	}
 
@@ -2908,8 +2908,8 @@ static void noinline reada_walk_down(struct btrfs_root *root,
 
 	for (i = slot; i < nritems && skipped < 32; i++) {
 		bytenr = btrfs_node_blockptr(node, i);
-		if (last && ((bytenr > last && bytenr - last > 32 * 1024) ||
-			     (last > bytenr && last - bytenr > 32 * 1024))) {
+		if (last && ((bytenr > last && bytenr - last > SZ_32K) ||
+			     (last > bytenr && last - bytenr > SZ_32K))) {
 			skipped++;
 			continue;
 		}
@@ -3413,19 +3413,18 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 			group_type = BTRFS_BLOCK_GROUP_SYSTEM;
 			group_size /= 4;
 			group_size &= ~(group_align - 1);
-			group_size = max_t(u64, group_size, 8 * 1024 * 1024);
-			group_size = min_t(u64, group_size, 32 * 1024 * 1024);
+			group_size = max_t(u64, group_size, SZ_8M);
+			group_size = min_t(u64, group_size, SZ_32M);
 		} else {
 			group_size &= ~(group_align - 1);
 			if (total_data >= total_metadata * 2) {
 				group_type = BTRFS_BLOCK_GROUP_METADATA;
-				group_size = min_t(u64, group_size,
-						   1ULL * 1024 * 1024 * 1024);
+				group_size = min_t(u64, group_size, SZ_1G);
 				total_metadata += group_size;
 			} else {
 				group_type = BTRFS_BLOCK_GROUP_DATA;
 				group_size = min_t(u64, group_size,
-						   5ULL * 1024 * 1024 * 1024);
+						   5ULL * SZ_1G);
 				total_data += group_size;
 			}
 			if ((total_bytes - cur_start) * 4 < group_size * 5)
diff --git a/free-space-cache.c b/free-space-cache.c
index 286b185e..a4196eb1 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -33,7 +33,7 @@
  * filesystem
  */
 #define BITS_PER_BITMAP(sectorsize)		((sectorsize) * 8)
-#define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
+#define MAX_CACHE_BYTES_PER_GIG	SZ_32K
 
 static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info);
diff --git a/kernel-lib/sizes.h b/kernel-lib/sizes.h
new file mode 100644
index 00000000..ce3e8150
--- /dev/null
+++ b/kernel-lib/sizes.h
@@ -0,0 +1,47 @@
+/*
+ * include/linux/sizes.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __LINUX_SIZES_H__
+#define __LINUX_SIZES_H__
+
+#define SZ_1				0x00000001
+#define SZ_2				0x00000002
+#define SZ_4				0x00000004
+#define SZ_8				0x00000008
+#define SZ_16				0x00000010
+#define SZ_32				0x00000020
+#define SZ_64				0x00000040
+#define SZ_128				0x00000080
+#define SZ_256				0x00000100
+#define SZ_512				0x00000200
+
+#define SZ_1K				0x00000400
+#define SZ_2K				0x00000800
+#define SZ_4K				0x00001000
+#define SZ_8K				0x00002000
+#define SZ_16K				0x00004000
+#define SZ_32K				0x00008000
+#define SZ_64K				0x00010000
+#define SZ_128K				0x00020000
+#define SZ_256K				0x00040000
+#define SZ_512K				0x00080000
+
+#define SZ_1M				0x00100000
+#define SZ_2M				0x00200000
+#define SZ_4M				0x00400000
+#define SZ_8M				0x00800000
+#define SZ_16M				0x01000000
+#define SZ_32M				0x02000000
+#define SZ_64M				0x04000000
+#define SZ_128M				0x08000000
+#define SZ_256M				0x10000000
+#define SZ_512M				0x20000000
+
+#define SZ_1G				0x40000000
+#define SZ_2G				0x80000000
+
+#endif /* __LINUX_SIZES_H__ */
diff --git a/send.h b/send.h
index ae9aa029..fe613cbb 100644
--- a/send.h
+++ b/send.h
@@ -29,7 +29,7 @@ extern "C" {
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
 #define BTRFS_SEND_STREAM_VERSION 1
 
-#define BTRFS_SEND_BUF_SIZE (1024 * 64)
+#define BTRFS_SEND_BUF_SIZE SZ_64K
 #define BTRFS_SEND_READ_SIZE (1024 * 48)
 
 enum btrfs_tlv_type {
diff --git a/utils.c b/utils.c
index 5a481976..a8cb28d4 100644
--- a/utils.c
+++ b/utils.c
@@ -132,7 +132,7 @@ static int discard_blocks(int fd, u64 start, u64 len)
 {
 	while (len > 0) {
 		/* 1G granularity */
-		u64 chunk_size = min_t(u64, len, 1*1024*1024*1024);
+		u64 chunk_size = min_t(u64, len, SZ_1G);
 		int ret;
 
 		ret = discard_range(fd, start, chunk_size);
@@ -540,7 +540,7 @@ static int insert_temp_chunk_item(int fd, struct extent_buffer *buf,
 	chunk = btrfs_item_ptr(buf, *slot, struct btrfs_chunk);
 	btrfs_set_chunk_length(buf, chunk, len);
 	btrfs_set_chunk_owner(buf, chunk, BTRFS_EXTENT_TREE_OBJECTID);
-	btrfs_set_chunk_stripe_len(buf, chunk, 64 * 1024);
+	btrfs_set_chunk_stripe_len(buf, chunk, BTRFS_STRIPE_LEN);
 	btrfs_set_chunk_type(buf, chunk, type);
 	btrfs_set_chunk_io_align(buf, chunk, cfg->sectorsize);
 	btrfs_set_chunk_io_width(buf, chunk, cfg->sectorsize);
@@ -1333,7 +1333,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	chunk = btrfs_item_ptr(buf, nritems, struct btrfs_chunk);
 	btrfs_set_chunk_length(buf, chunk, BTRFS_MKFS_SYSTEM_GROUP_SIZE);
 	btrfs_set_chunk_owner(buf, chunk, BTRFS_EXTENT_TREE_OBJECTID);
-	btrfs_set_chunk_stripe_len(buf, chunk, 64 * 1024);
+	btrfs_set_chunk_stripe_len(buf, chunk, BTRFS_STRIPE_LEN);
 	btrfs_set_chunk_type(buf, chunk, BTRFS_BLOCK_GROUP_SYSTEM);
 	btrfs_set_chunk_io_align(buf, chunk, cfg->sectorsize);
 	btrfs_set_chunk_io_width(buf, chunk, cfg->sectorsize);
@@ -1682,7 +1682,7 @@ static int zero_blocks(int fd, off_t start, size_t len)
 	return ret;
 }
 
-#define ZERO_DEV_BYTES (2 * 1024 * 1024)
+#define ZERO_DEV_BYTES SZ_2M
 
 /* don't write outside the device by clamping the region to the device size */
 static int zero_dev_clamped(int fd, off_t start, ssize_t len, u64 dev_size)
diff --git a/utils.h b/utils.h
index 3d30bd12..5b899680 100644
--- a/utils.h
+++ b/utils.h
@@ -25,10 +25,11 @@
 #include <stdarg.h>
 #include "internal.h"
 #include "btrfs-list.h"
+#include "sizes.h"
 
-#define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
-#define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
-#define BTRFS_MKFS_DEFAULT_NODE_SIZE 16384
+#define BTRFS_MKFS_SYSTEM_GROUP_SIZE SZ_4M
+#define BTRFS_MKFS_SMALL_VOLUME_SIZE SZ_1G
+#define BTRFS_MKFS_DEFAULT_NODE_SIZE SZ_16K
 #define BTRFS_MKFS_DEFAULT_FEATURES 				\
 		(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF		\
 		| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
@@ -46,7 +47,7 @@
 	| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA		\
 	| BTRFS_FEATURE_INCOMPAT_NO_HOLES)
 
-#define BTRFS_CONVERT_META_GROUP_SIZE (32 * 1024 * 1024)
+#define BTRFS_CONVERT_META_GROUP_SIZE SZ_32M
 
 #define BTRFS_FEATURE_LIST_ALL		(1ULL << 63)
 
diff --git a/volumes.c b/volumes.c
index a0a85edd..d87fd70e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -319,7 +319,7 @@ static int find_free_dev_extent_start(struct btrfs_trans_handle *trans,
 	 * used by the boot loader (grub for example), so we make sure to start
 	 * at an offset of at least 1MB.
 	 */
-	min_search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
+	min_search_start = max(root->fs_info->alloc_start, (u64)SZ_1M);
 	search_start = max(search_start, min_search_start);
 
 	path = btrfs_alloc_path();
@@ -843,8 +843,8 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	struct list_head *dev_list = &info->fs_devices->devices;
 	struct list_head *cur;
 	struct map_lookup *map;
-	int min_stripe_size = 1 * 1024 * 1024;
-	u64 calc_size = 8 * 1024 * 1024;
+	int min_stripe_size = SZ_1M;
+	u64 calc_size = SZ_8M;
 	u64 min_free;
 	u64 max_chunk_size = 4 * calc_size;
 	u64 avail = 0;
@@ -870,19 +870,19 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		    BTRFS_BLOCK_GROUP_RAID10 |
 		    BTRFS_BLOCK_GROUP_DUP)) {
 		if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
-			calc_size = 8 * 1024 * 1024;
+			calc_size = SZ_8M;
 			max_chunk_size = calc_size * 2;
-			min_stripe_size = 1 * 1024 * 1024;
+			min_stripe_size = SZ_1M;
 			max_stripes = BTRFS_MAX_DEVS_SYS_CHUNK;
 		} else if (type & BTRFS_BLOCK_GROUP_DATA) {
-			calc_size = 1024 * 1024 * 1024;
+			calc_size = SZ_1G;
 			max_chunk_size = 10 * calc_size;
-			min_stripe_size = 64 * 1024 * 1024;
+			min_stripe_size = SZ_64M;
 			max_stripes = BTRFS_MAX_DEVS(chunk_root);
 		} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
-			calc_size = 1024 * 1024 * 1024;
+			calc_size = SZ_1G;
 			max_chunk_size = 4 * calc_size;
-			min_stripe_size = 32 * 1024 * 1024;
+			min_stripe_size = SZ_32M;
 			max_stripes = BTRFS_MAX_DEVS(chunk_root);
 		}
 	}
@@ -1108,7 +1108,7 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	struct list_head *dev_list = &info->fs_devices->devices;
 	struct list_head *cur;
 	struct map_lookup *map;
-	u64 calc_size = 8 * 1024 * 1024;
+	u64 calc_size = SZ_8M;
 	int num_stripes = 1;
 	int sub_stripes = 0;
 	int ret;
diff --git a/volumes.h b/volumes.h
index ee7d56ab..18978a8d 100644
--- a/volumes.h
+++ b/volumes.h
@@ -22,7 +22,7 @@
 #include "kerncompat.h"
 #include "ctree.h"
 
-#define BTRFS_STRIPE_LEN	(64 * 1024)
+#define BTRFS_STRIPE_LEN	SZ_64K
 
 struct btrfs_device {
 	struct list_head dev_list;
-- 
2.11.1



