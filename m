Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51267 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763014Ab3DCTME (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2013 15:12:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B57BB9A040C
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2013 13:12:02 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id gwe9zA03vR0uqEKz (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 03 Apr 2013 13:12:00 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add a free space cache checker to fsck
Date: Wed, 3 Apr 2013 15:11:57 -0400
Message-ID: <1365016317-6467-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In trying to track down a weird tree log problem I wanted to make sure that the
free space cache was actually valid, which we currently have no way of doing.
So this patch adds a bunch of support for the free space cache code and then a
checker to fsck.  Basically we go through and if we can actually load the free
space cache then we will walk the extent tree and verify that the free space
cache exactly matches what is in the extent tree.  Hopefully this will always be
correct, the only time it wouldn't is if the extent tree is corrupt or we have
some sort of awful bug in the free space cache.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 Makefile           |    3 +-
 bitops.h           |  220 +++++++++++++
 cmds-check.c       |  209 +++++++++++++
 ctree.h            |   14 +
 extent-tree.c      |   12 +-
 extent_io.c        |   51 +++
 extent_io.h        |    4 +
 free-space-cache.c |  871 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 free-space-cache.h |   53 ++++
 9 files changed, 1434 insertions(+), 3 deletions(-)
 create mode 100644 bitops.h
 create mode 100644 free-space-cache.c
 create mode 100644 free-space-cache.h

diff --git a/Makefile b/Makefile
index 66d677c..a4f9374 100644
--- a/Makefile
+++ b/Makefile
@@ -6,7 +6,8 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
 	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
-	  send-stream.o send-utils.o qgroup.o raid6.o
+	  send-stream.o send-utils.o qgroup.o raid6.o free-space-cache.o
+
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/bitops.h b/bitops.h
new file mode 100644
index 0000000..323c571
--- /dev/null
+++ b/bitops.h
@@ -0,0 +1,220 @@
+#ifndef _PERF_LINUX_BITOPS_H_
+#define _PERF_LINUX_BITOPS_H_
+
+#include <linux/kernel.h>
+
+#define BITS_PER_BYTE           8
+#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+#define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
+#define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
+
+#define for_each_set_bit(bit, addr, size) \
+	for ((bit) = find_first_bit((addr), (size));		\
+	     (bit) < (size);					\
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+/* same as for_each_set_bit() but use bit as value to start with */
+#define for_each_set_bit_from(bit, addr, size) \
+	for ((bit) = find_next_bit((addr), (size), (bit));	\
+	     (bit) < (size);					\
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+static inline void set_bit(int nr, unsigned long *addr)
+{
+	addr[nr / BITS_PER_LONG] |= 1UL << (nr % BITS_PER_LONG);
+}
+
+static inline void clear_bit(int nr, unsigned long *addr)
+{
+	addr[nr / BITS_PER_LONG] &= ~(1UL << (nr % BITS_PER_LONG));
+}
+
+/**
+ * hweightN - returns the hamming weight of a N-bit word
+ * @x: the word to weigh
+ *
+ * The Hamming Weight of a number is the total number of bits set in it.
+ */
+
+static inline unsigned int hweight32(unsigned int w)
+{
+	unsigned int res = w - ((w >> 1) & 0x55555555);
+	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
+	res = (res + (res >> 4)) & 0x0F0F0F0F;
+	res = res + (res >> 8);
+	return (res + (res >> 16)) & 0x000000FF;
+}
+
+static inline unsigned long hweight64(__u64 w)
+{
+#if BITS_PER_LONG == 32
+	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
+#elif BITS_PER_LONG == 64
+	__u64 res = w - ((w >> 1) & 0x5555555555555555ul);
+	res = (res & 0x3333333333333333ul) + ((res >> 2) & 0x3333333333333333ul);
+	res = (res + (res >> 4)) & 0x0F0F0F0F0F0F0F0Ful;
+	res = res + (res >> 8);
+	res = res + (res >> 16);
+	return (res + (res >> 32)) & 0x00000000000000FFul;
+#endif
+}
+
+static inline unsigned long hweight_long(unsigned long w)
+{
+	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
+}
+
+#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
+
+/**
+ * __ffs - find first bit in word.
+ * @word: The word to search
+ *
+ * Undefined if no bit exists, so code should check against 0 first.
+ */
+static __always_inline unsigned long __ffs(unsigned long word)
+{
+	int num = 0;
+
+#if BITS_PER_LONG == 64
+	if ((word & 0xffffffff) == 0) {
+		num += 32;
+		word >>= 32;
+	}
+#endif
+	if ((word & 0xffff) == 0) {
+		num += 16;
+		word >>= 16;
+	}
+	if ((word & 0xff) == 0) {
+		num += 8;
+		word >>= 8;
+	}
+	if ((word & 0xf) == 0) {
+		num += 4;
+		word >>= 4;
+	}
+	if ((word & 0x3) == 0) {
+		num += 2;
+		word >>= 2;
+	}
+	if ((word & 0x1) == 0)
+		num += 1;
+	return num;
+}
+
+#define ffz(x) __ffs(~(x))
+
+/*
+ * Find the first set bit in a memory region.
+ */
+static inline unsigned long
+find_first_bit(const unsigned long *addr, unsigned long size)
+{
+	const unsigned long *p = addr;
+	unsigned long result = 0;
+	unsigned long tmp;
+
+	while (size & ~(BITS_PER_LONG-1)) {
+		if ((tmp = *(p++)))
+			goto found;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+
+	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
+	if (tmp == 0UL)		/* Are any bits set? */
+		return result + size;	/* Nope. */
+found:
+	return result + __ffs(tmp);
+}
+
+/*
+ * Find the next set bit in a memory region.
+ */
+static inline unsigned long
+find_next_bit(const unsigned long *addr, unsigned long size,
+	      unsigned long offset)
+{
+	const unsigned long *p = addr + BITOP_WORD(offset);
+	unsigned long result = offset & ~(BITS_PER_LONG-1);
+	unsigned long tmp;
+
+	if (offset >= size)
+		return size;
+	size -= result;
+	offset %= BITS_PER_LONG;
+	if (offset) {
+		tmp = *(p++);
+		tmp &= (~0UL << offset);
+		if (size < BITS_PER_LONG)
+			goto found_first;
+		if (tmp)
+			goto found_middle;
+		size -= BITS_PER_LONG;
+		result += BITS_PER_LONG;
+	}
+	while (size & ~(BITS_PER_LONG-1)) {
+		if ((tmp = *(p++)))
+			goto found_middle;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+	tmp = *p;
+
+found_first:
+	tmp &= (~0UL >> (BITS_PER_LONG - size));
+	if (tmp == 0UL)		/* Are any bits set? */
+		return result + size;	/* Nope. */
+found_middle:
+	return result + __ffs(tmp);
+}
+
+/*
+ * This implementation of find_{first,next}_zero_bit was stolen from
+ * Linus' asm-alpha/bitops.h.
+ */
+static inline unsigned long
+find_next_zero_bit(const unsigned long *addr, unsigned long size,
+		   unsigned long offset)
+{
+	const unsigned long *p = addr + BITOP_WORD(offset);
+	unsigned long result = offset & ~(BITS_PER_LONG-1);
+	unsigned long tmp;
+
+	if (offset >= size)
+		return size;
+	size -= result;
+	offset %= BITS_PER_LONG;
+	if (offset) {
+		tmp = *(p++);
+		tmp |= ~0UL >> (BITS_PER_LONG - offset);
+		if (size < BITS_PER_LONG)
+			goto found_first;
+		if (~tmp)
+			goto found_middle;
+		size -= BITS_PER_LONG;
+		result += BITS_PER_LONG;
+	}
+	while (size & ~(BITS_PER_LONG-1)) {
+		if (~(tmp = *(p++)))
+			goto found_middle;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+	tmp = *p;
+
+found_first:
+	tmp |= ~0UL << size;
+	if (tmp == ~0UL)	/* Are any bits zero? */
+		return result + size;	/* Nope. */
+found_middle:
+	return result + ffz(tmp);
+}
+#endif
diff --git a/cmds-check.c b/cmds-check.c
index be37dbe..04118ad 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -38,6 +38,7 @@
 #include "version.h"
 #include "utils.h"
 #include "commands.h"
+#include "free-space-cache.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
@@ -2787,6 +2788,209 @@ static int check_csums(struct btrfs_root *root)
 	return errors;
 }
 
+static int check_cache_range(struct btrfs_root *root,
+			     struct btrfs_block_group_cache *cache,
+			     u64 offset, u64 bytes)
+{
+	struct btrfs_free_space *entry;
+	u64 *logical;
+	u64 bytenr;
+	int stripe_len;
+	int i, nr, ret;
+
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		bytenr = btrfs_sb_offset(i);
+		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
+				       cache->key.objectid, bytenr, 0,
+				       &logical, &nr, &stripe_len);
+		if (ret)
+			return ret;
+
+		while (nr--) {
+			if (logical[nr] + stripe_len <= offset)
+				continue;
+			if (offset + bytes <= logical[nr])
+				continue;
+			if (logical[nr] == offset) {
+				if (stripe_len >= bytes) {
+					kfree(logical);
+					return 0;
+				}
+				bytes -= stripe_len;
+				offset += stripe_len;
+			} else if (logical[nr] < offset) {
+				if (logical[nr] + stripe_len >=
+				    offset + bytes) {
+					kfree(logical);
+					return 0;
+				}
+				bytes = (offset + bytes) -
+					(logical[nr] + stripe_len);
+				offset = logical[nr] + stripe_len;
+			} else {
+				/*
+				 * Could be tricky, the super may land in the
+				 * middle of the area we're checking.  First
+				 * check the easiest case, it's at the end.
+				 */
+				if (logical[nr] + stripe_len >=
+				    bytes + offset) {
+					bytes = logical[nr] - offset;
+					continue;
+				}
+
+				/* Check the left side */
+				ret = check_cache_range(root, cache,
+							offset,
+							logical[nr] - offset);
+				if (ret) {
+					kfree(logical);
+					return ret;
+				}
+
+				/* Now we continue with the right side */
+				bytes = (offset + bytes) -
+					(logical[nr] + stripe_len);
+				offset = logical[nr] + stripe_len;
+			}
+		}
+
+		kfree(logical);
+	}
+
+	entry = btrfs_find_free_space(cache->free_space_ctl, offset, bytes);
+	if (!entry) {
+		fprintf(stderr, "There is no free space entry for %Lu-%Lu\n",
+			offset, offset+bytes);
+		return -EINVAL;
+	}
+
+	if (entry->offset != offset) {
+		fprintf(stderr, "Wanted offset %Lu, found %Lu\n", offset,
+			entry->offset);
+		return -EINVAL;
+	}
+
+	if (entry->bytes != bytes) {
+		fprintf(stderr, "Wanted bytes %Lu, found %Lu for off %Lu\n",
+			bytes, entry->bytes, offset);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int verify_space_cache(struct btrfs_root *root,
+			      struct btrfs_block_group_cache *cache)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u64 last;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	root = root->fs_info->extent_root;
+
+	last = max_t(u64, cache->key.objectid, BTRFS_SUPER_INFO_OFFSET);
+
+	key.objectid = last;
+	key.offset = 0;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		return ret;
+	while (1) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				return ret;
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+		}
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.objectid >= cache->key.offset + cache->key.objectid)
+			break;
+		if (key.type != BTRFS_EXTENT_ITEM_KEY &&
+		    key.type != BTRFS_METADATA_ITEM_KEY) {
+			path->slots[0]++;
+			continue;
+		}
+
+		if (last == key.objectid) {
+			last = key.objectid + key.offset;
+			path->slots[0]++;
+			continue;
+		}
+
+		ret = check_cache_range(root, cache, last,
+					key.objectid - last);
+		if (ret)
+			break;
+		if (key.type == BTRFS_EXTENT_ITEM_KEY)
+			last = key.objectid + key.offset;
+		else
+			last = key.objectid + root->leafsize;
+		path->slots[0]++;
+	}
+
+	btrfs_free_path(path);
+
+	return ret;
+}
+
+static int check_space_cache(struct btrfs_root *root)
+{
+	struct btrfs_block_group_cache *cache;
+	u64 start = BTRFS_SUPER_INFO_OFFSET + BTRFS_SUPER_INFO_SIZE;
+	int ret;
+	int error = 0;
+
+	if (btrfs_super_generation(root->fs_info->super_copy) !=
+	    btrfs_super_cache_generation(root->fs_info->super_copy)) {
+		printf("cache and super generation don't match, space cache "
+		       "will be invalidated\n");
+		return 0;
+	}
+
+	while (1) {
+		cache = btrfs_lookup_first_block_group(root->fs_info, start);
+		if (!cache)
+			break;
+
+		start = cache->key.objectid + cache->key.offset;
+		if (!cache->free_space_ctl) {
+			if (btrfs_init_free_space_ctl(cache,
+						      root->leafsize)) {
+				ret = -ENOMEM;
+				break;
+			}
+		} else {
+			btrfs_remove_free_space_cache(cache);
+		}
+
+		ret = load_free_space_cache(root->fs_info, cache);
+		if (!ret)
+			continue;
+
+		ret = verify_space_cache(root, cache);
+		if (ret) {
+			fprintf(stderr, "cache appears valid but isnt %Lu\n",
+				cache->key.objectid);
+			error++;
+		}
+	}
+
+	return error ? -EINVAL : 0;
+}
+
 static int run_next_block(struct btrfs_root *root,
 			  struct block_info *bits,
 			  int bits_nr,
@@ -3862,6 +4066,11 @@ int cmd_check(int argc, char **argv)
 	if (ret)
 		fprintf(stderr, "Errors found in extent allocation tree\n");
 
+	fprintf(stderr, "checking free space cache\n");
+	ret = check_space_cache(root);
+	if (ret)
+		goto out;
+
 	fprintf(stderr, "checking fs roots\n");
 	ret = check_fs_roots(root, &root_cache);
 	if (ret)
diff --git a/ctree.h b/ctree.h
index 702de2c..67fa650 100644
--- a/ctree.h
+++ b/ctree.h
@@ -28,6 +28,7 @@
 
 struct btrfs_root;
 struct btrfs_trans_handle;
+struct btrfs_free_space_ctl;
 #define BTRFS_MAGIC 0x4D5F53665248425F /* ascii _BHRfS_M, no null */
 
 #define BTRFS_MAX_LEVEL 8
@@ -268,6 +269,15 @@ struct btrfs_chunk {
 	/* additional stripes go here */
 } __attribute__ ((__packed__));
 
+#define BTRFS_FREE_SPACE_EXTENT	1
+#define BTRFS_FREE_SPACE_BITMAP	2
+
+struct btrfs_free_space_entry {
+	__le64 offset;
+	__le64 bytes;
+	u8 type;
+} __attribute__ ((__packed__));
+
 struct btrfs_free_space_header {
 	struct btrfs_disk_key location;
 	__le64 generation;
@@ -866,6 +876,7 @@ struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
 	struct btrfs_space_info *space_info;
+	struct btrfs_free_space_ctl *free_space_ctl;
 	u64 pinned;
 	u64 flags;
 	int cached;
@@ -2055,6 +2066,9 @@ int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy);
 struct btrfs_block_group_cache *btrfs_lookup_block_group(struct
 							 btrfs_fs_info *info,
 							 u64 bytenr);
+struct btrfs_block_group_cache *btrfs_lookup_first_block_group(struct
+						       btrfs_fs_info *info,
+						       u64 bytenr);
 struct btrfs_block_group_cache *btrfs_find_block_group(struct btrfs_root *root,
 						 struct btrfs_block_group_cache
 						 *hint, u64 search_start,
diff --git a/extent-tree.c b/extent-tree.c
index 2e0524b..4ddf48c 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -26,6 +26,7 @@
 #include "transaction.h"
 #include "crc32c.h"
 #include "volumes.h"
+#include "free-space-cache.h"
 
 #define BLOCK_GROUP_DATA     EXTENT_WRITEBACK
 #define BLOCK_GROUP_METADATA EXTENT_UPTODATE
@@ -3176,6 +3177,7 @@ out:
 int btrfs_free_block_groups(struct btrfs_fs_info *info)
 {
 	struct btrfs_space_info *sinfo;
+	struct btrfs_block_group_cache *cache;
 	u64 start;
 	u64 end;
 	u64 ptr;
@@ -3187,8 +3189,14 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		if (ret)
 			break;
 		ret = get_state_private(&info->block_group_cache, start, &ptr);
-		if (!ret)
-			kfree((void *)(unsigned long)ptr);
+		if (!ret) {
+			cache = (struct btrfs_block_group_cache *)ptr;
+			if (cache->free_space_ctl) {
+				btrfs_remove_free_space_cache(cache);
+				kfree(cache->free_space_ctl);
+			}
+			kfree(cache);
+		}
 		clear_extent_bits(&info->block_group_cache, start,
 				  end, (unsigned int)-1, GFP_NOFS);
 	}
diff --git a/extent_io.c b/extent_io.c
index 78deb50..5093aeb 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -27,6 +27,8 @@
 #include "kerncompat.h"
 #include "extent_io.h"
 #include "list.h"
+#include "ctree.h"
+#include "volumes.h"
 
 u64 cache_soft_max = 1024 * 1024 * 256;
 u64 cache_hard_max = 1 * 1024 * 1024 * 1024;
@@ -696,6 +698,55 @@ out:
 	return ret;
 }
 
+int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
+			u64 bytes, int mirror)
+{
+	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_device *device;
+	u64 bytes_left = bytes;
+	u64 read_len;
+	u64 total_read = 0;
+	int ret;
+
+	while (bytes_left) {
+		read_len = bytes_left;
+		ret = btrfs_map_block(&info->mapping_tree, READ, offset,
+				      &read_len, &multi, mirror, NULL);
+		if (ret) {
+			fprintf(stderr, "Couldn't map the block %Lu\n",
+				offset);
+			return -EIO;
+		}
+		device = multi->stripes[0].dev;
+
+		read_len = min(bytes_left, read_len);
+		if (device->fd == 0) {
+			kfree(multi);
+			return -EIO;
+		}
+
+		ret = pread(device->fd, buf + total_read, read_len,
+			    multi->stripes[0].physical);
+		kfree(multi);
+		if (ret < 0) {
+			fprintf(stderr, "Error reading %Lu, %d\n", offset,
+				ret);
+			return ret;
+		}
+		if (ret != read_len) {
+			fprintf(stderr, "Short read for %Lu, read %d, "
+				"read_len %Lu\n", offset, ret, read_len);
+			return -EIO;
+		}
+
+		bytes_left -= read_len;
+		offset += read_len;
+		total_read += read_len;
+	}
+
+	return 0;
+}
+
 int set_extent_buffer_uptodate(struct extent_buffer *eb)
 {
 	eb->flags |= EXTENT_UPTODATE;
diff --git a/extent_io.h b/extent_io.h
index 63e9004..1c7999a 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -34,6 +34,8 @@
 #define EXTENT_CSUM (1 << 9)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 
+struct btrfs_fs_info;
+
 struct extent_io_tree {
 	struct cache_tree state;
 	struct cache_tree cache;
@@ -115,4 +117,6 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
 int set_extent_buffer_dirty(struct extent_buffer *eb);
 int clear_extent_buffer_dirty(struct extent_buffer *eb);
+int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
+			u64 bytes, int mirror);
 #endif
diff --git a/free-space-cache.c b/free-space-cache.c
new file mode 100644
index 0000000..66b5b85
--- /dev/null
+++ b/free-space-cache.c
@@ -0,0 +1,871 @@
+/*
+ * Copyright (C) 2008 Red Hat.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include "kerncompat.h"
+#include "ctree.h"
+#include "free-space-cache.h"
+#include "transaction.h"
+#include "disk-io.h"
+#include "extent_io.h"
+#include "crc32c.h"
+#include "bitops.h"
+
+#define CACHE_SECTORSIZE	4096
+#define BITS_PER_BITMAP		(CACHE_SECTORSIZE * 8)
+#define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
+
+static int link_free_space(struct btrfs_free_space_ctl *ctl,
+			   struct btrfs_free_space *info);
+static void unlink_free_space(struct btrfs_free_space_ctl *ctl,
+			      struct btrfs_free_space *info);
+static void merge_space_tree(struct btrfs_free_space_ctl *ctl);
+
+struct io_ctl {
+	void *cur, *orig;
+	void *buffer;
+	struct btrfs_root *root;
+	unsigned long size;
+	u64 total_size;
+	int index;
+	int num_pages;
+	unsigned check_crcs:1;
+};
+
+static int io_ctl_init(struct io_ctl *io_ctl, u64 size, u64 ino,
+		       struct btrfs_root *root)
+{
+	memset(io_ctl, 0, sizeof(struct io_ctl));
+	io_ctl->num_pages = (size + CACHE_SECTORSIZE - 1) / CACHE_SECTORSIZE;
+	io_ctl->buffer = kzalloc(size, GFP_NOFS);
+	if (!io_ctl->buffer)
+		return -ENOMEM;
+	io_ctl->total_size = size;
+	io_ctl->root = root;
+	if (ino != BTRFS_FREE_INO_OBJECTID)
+		io_ctl->check_crcs = 1;
+	return 0;
+}
+
+static void io_ctl_free(struct io_ctl *io_ctl)
+{
+	kfree(io_ctl->buffer);
+}
+
+static void io_ctl_unmap_page(struct io_ctl *io_ctl)
+{
+	if (io_ctl->cur) {
+		io_ctl->cur = NULL;
+		io_ctl->orig = NULL;
+	}
+}
+
+static void io_ctl_map_page(struct io_ctl *io_ctl, int clear)
+{
+	BUG_ON(io_ctl->index >= io_ctl->num_pages);
+	io_ctl->cur = io_ctl->buffer + (io_ctl->index++ * CACHE_SECTORSIZE);
+	io_ctl->orig = io_ctl->cur;
+	io_ctl->size = CACHE_SECTORSIZE;
+	if (clear)
+		memset(io_ctl->cur, 0, CACHE_SECTORSIZE);
+}
+
+static void io_ctl_drop_pages(struct io_ctl *io_ctl)
+{
+	io_ctl_unmap_page(io_ctl);
+}
+
+static int io_ctl_prepare_pages(struct io_ctl *io_ctl, struct btrfs_root *root,
+				struct btrfs_path *path, u64 ino)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key key;
+	u64 bytenr, len;
+	u64 total_read = 0;
+	int ret = 0;
+
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret) {
+		printf("Couldn't find file extent item for free space inode"
+		       " %Lu\n", ino);
+		btrfs_release_path(root, path);
+		return -EINVAL;
+	}
+
+	while (total_read < io_ctl->total_size) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret) {
+				ret = -EINVAL;
+				break;
+			}
+		}
+		leaf = path->nodes[0];
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.objectid != ino) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (key.type != BTRFS_EXTENT_DATA_KEY) {
+			ret = -EINVAL;
+			break;
+		}
+
+		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(path->nodes[0], fi) !=
+		    BTRFS_FILE_EXTENT_REG) {
+			printf("Not the file extent type we wanted\n");
+			ret = -EINVAL;
+			break;
+		}
+
+		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi) +
+			btrfs_file_extent_offset(leaf, fi);
+		len = btrfs_file_extent_num_bytes(leaf, fi);
+		ret = read_data_from_disk(root->fs_info,
+					  io_ctl->buffer + key.offset, bytenr,
+					  len, 0);
+		if (ret)
+			break;
+		total_read += len;
+		path->slots[0]++;
+	}
+
+	btrfs_release_path(root, path);
+	return ret;
+}
+
+static int io_ctl_check_generation(struct io_ctl *io_ctl, u64 generation)
+{
+	__le64 *gen;
+
+	/*
+	 * Skip the crc area.  If we don't check crcs then we just have a 64bit
+	 * chunk at the front of the first page.
+	 */
+	if (io_ctl->check_crcs) {
+		io_ctl->cur += sizeof(u32) * io_ctl->num_pages;
+		io_ctl->size -= sizeof(u64) +
+			(sizeof(u32) * io_ctl->num_pages);
+	} else {
+		io_ctl->cur += sizeof(u64);
+		io_ctl->size -= sizeof(u64) * 2;
+	}
+
+	gen = io_ctl->cur;
+	if (le64_to_cpu(*gen) != generation) {
+		printk("btrfs: space cache generation "
+		       "(%Lu) does not match inode (%Lu)\n", *gen,
+		       generation);
+		io_ctl_unmap_page(io_ctl);
+		return -EIO;
+	}
+	io_ctl->cur += sizeof(u64);
+	return 0;
+}
+
+static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
+{
+	u32 *tmp, val;
+	u32 crc = ~(u32)0;
+	unsigned offset = 0;
+
+	if (!io_ctl->check_crcs) {
+		io_ctl_map_page(io_ctl, 0);
+		return 0;
+	}
+
+	if (index == 0)
+		offset = sizeof(u32) * io_ctl->num_pages;
+
+	tmp = io_ctl->buffer;
+	tmp += index;
+	val = *tmp;
+
+	io_ctl_map_page(io_ctl, 0);
+	crc = crc32c(crc, io_ctl->orig + offset, CACHE_SECTORSIZE - offset);
+	btrfs_csum_final(crc, (char *)&crc);
+	if (val != crc) {
+		printk("btrfs: csum mismatch on free space cache\n");
+		io_ctl_unmap_page(io_ctl);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int io_ctl_read_entry(struct io_ctl *io_ctl,
+			    struct btrfs_free_space *entry, u8 *type)
+{
+	struct btrfs_free_space_entry *e;
+	int ret;
+
+	if (!io_ctl->cur) {
+		ret = io_ctl_check_crc(io_ctl, io_ctl->index);
+		if (ret)
+			return ret;
+	}
+
+	e = io_ctl->cur;
+	entry->offset = le64_to_cpu(e->offset);
+	entry->bytes = le64_to_cpu(e->bytes);
+	*type = e->type;
+	io_ctl->cur += sizeof(struct btrfs_free_space_entry);
+	io_ctl->size -= sizeof(struct btrfs_free_space_entry);
+
+	if (io_ctl->size >= sizeof(struct btrfs_free_space_entry))
+		return 0;
+
+	io_ctl_unmap_page(io_ctl);
+
+	return 0;
+}
+
+static int io_ctl_read_bitmap(struct io_ctl *io_ctl,
+			      struct btrfs_free_space *entry)
+{
+	int ret;
+
+	ret = io_ctl_check_crc(io_ctl, io_ctl->index);
+	if (ret)
+		return ret;
+
+	memcpy(entry->bitmap, io_ctl->cur, CACHE_SECTORSIZE);
+	io_ctl_unmap_page(io_ctl);
+
+	return 0;
+}
+
+
+int __load_free_space_cache(struct btrfs_root *root,
+			    struct btrfs_free_space_ctl *ctl,
+			    struct btrfs_path *path, u64 offset)
+{
+	struct btrfs_free_space_header *header;
+	struct btrfs_inode_item *inode_item;
+	struct extent_buffer *leaf;
+	struct io_ctl io_ctl;
+	struct btrfs_key key;
+	struct btrfs_key inode_location;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_free_space *e, *n;
+	struct list_head bitmaps;
+	u64 num_entries;
+	u64 num_bitmaps;
+	u64 generation;
+	u64 inode_size;
+	u8 type;
+	int ret = 0;
+
+	INIT_LIST_HEAD(&bitmaps);
+
+	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
+	key.offset = offset;
+	key.type = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		return 0;
+	} else if (ret > 0) {
+		btrfs_release_path(root, path);
+		return 0;
+	}
+
+	ret = -1;
+
+	leaf = path->nodes[0];
+	header = btrfs_item_ptr(leaf, path->slots[0],
+				struct btrfs_free_space_header);
+	num_entries = btrfs_free_space_entries(leaf, header);
+	num_bitmaps = btrfs_free_space_bitmaps(leaf, header);
+	generation = btrfs_free_space_generation(leaf, header);
+	btrfs_free_space_key(leaf, header, &disk_key);
+	btrfs_disk_key_to_cpu(&inode_location, &disk_key);
+	btrfs_release_path(root, path);
+
+	ret = btrfs_search_slot(NULL, root, &inode_location, path, 0, 0);
+	if (ret) {
+		printf("Couldn't find free space inode %d\n", ret);
+		return 0;
+	}
+
+	leaf = path->nodes[0];
+	inode_item = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_inode_item);
+	if (btrfs_inode_generation(leaf, inode_item) != generation) {
+		printf("free space inode generation (%llu) did not match "
+		       "free space cache generation (%llu)",
+		       (unsigned long long)btrfs_inode_generation(leaf,
+								  inode_item),
+		       (unsigned long long)generation);
+		btrfs_release_path(root, path);
+		return 0;
+	}
+
+	inode_size = btrfs_inode_size(leaf, inode_item);
+	btrfs_release_path(root, path);
+	if (inode_size == 0)
+		return 0;
+
+	if (!num_entries)
+		return 0;
+
+	ret = io_ctl_init(&io_ctl, inode_size, inode_location.objectid, root);
+	if (ret)
+		return ret;
+
+	ret = io_ctl_prepare_pages(&io_ctl, root, path,
+				   inode_location.objectid);
+	if (ret)
+		goto out;
+
+	ret = io_ctl_check_crc(&io_ctl, 0);
+	if (ret)
+		goto free_cache;
+
+	ret = io_ctl_check_generation(&io_ctl, generation);
+	if (ret)
+		goto free_cache;
+
+	while (num_entries) {
+		e = calloc(1, sizeof(*e));
+		if (!e)
+			goto free_cache;
+
+		ret = io_ctl_read_entry(&io_ctl, e, &type);
+		if (ret) {
+			free(e);
+			goto free_cache;
+		}
+
+		if (!e->bytes) {
+			free(e);
+			goto free_cache;
+		}
+
+		if (type == BTRFS_FREE_SPACE_EXTENT) {
+			ret = link_free_space(ctl, e);
+			if (ret) {
+				printf("Duplicate entries in free space cache, dumping");
+				free(e);
+				goto free_cache;
+			}
+		} else {
+			BUG_ON(!num_bitmaps);
+			num_bitmaps--;
+			e->bitmap = kzalloc(CACHE_SECTORSIZE, GFP_NOFS);
+			if (!e->bitmap) {
+				free(e);
+				goto free_cache;
+			}
+			ret = link_free_space(ctl, e);
+			ctl->total_bitmaps++;
+			if (ret) {
+				printf("Duplicate entries in free space cache, dumping");
+				free(e->bitmap);
+				free(e);
+				goto free_cache;
+			}
+			list_add_tail(&e->list, &bitmaps);
+		}
+
+		num_entries--;
+	}
+
+	io_ctl_unmap_page(&io_ctl);
+
+	/*
+	 * We add the bitmaps at the end of the entries in order that
+	 * the bitmap entries are added to the cache.
+	 */
+	list_for_each_entry_safe(e, n, &bitmaps, list) {
+		list_del_init(&e->list);
+		ret = io_ctl_read_bitmap(&io_ctl, e);
+		if (ret)
+			goto free_cache;
+	}
+
+	io_ctl_drop_pages(&io_ctl);
+	merge_space_tree(ctl);
+	ret = 1;
+out:
+	io_ctl_free(&io_ctl);
+	return ret;
+free_cache:
+	io_ctl_drop_pages(&io_ctl);
+	__btrfs_remove_free_space_cache(ctl);
+	goto out;
+}
+
+int load_free_space_cache(struct btrfs_fs_info *fs_info,
+			  struct btrfs_block_group_cache *block_group)
+{
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
+	struct btrfs_path *path;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return 0;
+
+	ret = __load_free_space_cache(fs_info->tree_root, ctl, path,
+				      block_group->key.objectid);
+	btrfs_free_path(path);
+
+	if (ret < 0) {
+		ret = 0;
+
+		printf("failed to load free space cache for block group %llu",
+			block_group->key.objectid);
+	}
+
+	return ret;
+}
+
+static inline unsigned long offset_to_bit(u64 bitmap_start, u32 unit,
+					  u64 offset)
+{
+	BUG_ON(offset < bitmap_start);
+	offset -= bitmap_start;
+	return (unsigned long)(offset / unit);
+}
+
+static inline unsigned long bytes_to_bits(u64 bytes, u32 unit)
+{
+	return (unsigned long)(bytes / unit);
+}
+
+static inline u64 offset_to_bitmap(struct btrfs_free_space_ctl *ctl,
+				   u64 offset)
+{
+	u64 bitmap_start;
+	u64 bytes_per_bitmap;
+
+	bytes_per_bitmap = BITS_PER_BITMAP * ctl->unit;
+	bitmap_start = offset - ctl->start;
+	bitmap_start = bitmap_start / bytes_per_bitmap;
+	bitmap_start *= bytes_per_bitmap;
+	bitmap_start += ctl->start;
+
+	return bitmap_start;
+}
+
+static int tree_insert_offset(struct rb_root *root, u64 offset,
+			      struct rb_node *node, int bitmap)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_free_space *info;
+
+	while (*p) {
+		parent = *p;
+		info = rb_entry(parent, struct btrfs_free_space, offset_index);
+
+		if (offset < info->offset) {
+			p = &(*p)->rb_left;
+		} else if (offset > info->offset) {
+			p = &(*p)->rb_right;
+		} else {
+			/*
+			 * we could have a bitmap entry and an extent entry
+			 * share the same offset.  If this is the case, we want
+			 * the extent entry to always be found first if we do a
+			 * linear search through the tree, since we want to have
+			 * the quickest allocation time, and allocating from an
+			 * extent is faster than allocating from a bitmap.  So
+			 * if we're inserting a bitmap and we find an entry at
+			 * this offset, we want to go right, or after this entry
+			 * logically.  If we are inserting an extent and we've
+			 * found a bitmap, we want to go left, or before
+			 * logically.
+			 */
+			if (bitmap) {
+				if (info->bitmap)
+					return -EEXIST;
+				p = &(*p)->rb_right;
+			} else {
+				if (!info->bitmap)
+					return -EEXIST;
+				p = &(*p)->rb_left;
+			}
+		}
+	}
+
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+
+	return 0;
+}
+
+/*
+ * searches the tree for the given offset.
+ *
+ * fuzzy - If this is set, then we are trying to make an allocation, and we just
+ * want a section that has at least bytes size and comes at or after the given
+ * offset.
+ */
+static struct btrfs_free_space *
+tree_search_offset(struct btrfs_free_space_ctl *ctl,
+		   u64 offset, int bitmap_only, int fuzzy)
+{
+	struct rb_node *n = ctl->free_space_offset.rb_node;
+	struct btrfs_free_space *entry, *prev = NULL;
+
+	/* find entry that is closest to the 'offset' */
+	while (1) {
+		if (!n) {
+			entry = NULL;
+			break;
+		}
+
+		entry = rb_entry(n, struct btrfs_free_space, offset_index);
+		prev = entry;
+
+		if (offset < entry->offset)
+			n = n->rb_left;
+		else if (offset > entry->offset)
+			n = n->rb_right;
+		else
+			break;
+	}
+
+	if (bitmap_only) {
+		if (!entry)
+			return NULL;
+		if (entry->bitmap)
+			return entry;
+
+		/*
+		 * bitmap entry and extent entry may share same offset,
+		 * in that case, bitmap entry comes after extent entry.
+		 */
+		n = rb_next(n);
+		if (!n)
+			return NULL;
+		entry = rb_entry(n, struct btrfs_free_space, offset_index);
+		if (entry->offset != offset)
+			return NULL;
+
+		WARN_ON(!entry->bitmap);
+		return entry;
+	} else if (entry) {
+		if (entry->bitmap) {
+			/*
+			 * if previous extent entry covers the offset,
+			 * we should return it instead of the bitmap entry
+			 */
+			n = rb_prev(&entry->offset_index);
+			if (n) {
+				prev = rb_entry(n, struct btrfs_free_space,
+						offset_index);
+				if (!prev->bitmap &&
+				    prev->offset + prev->bytes > offset)
+					entry = prev;
+			}
+		}
+		return entry;
+	}
+
+	if (!prev)
+		return NULL;
+
+	/* find last entry before the 'offset' */
+	entry = prev;
+	if (entry->offset > offset) {
+		n = rb_prev(&entry->offset_index);
+		if (n) {
+			entry = rb_entry(n, struct btrfs_free_space,
+					offset_index);
+			BUG_ON(entry->offset > offset);
+		} else {
+			if (fuzzy)
+				return entry;
+			else
+				return NULL;
+		}
+	}
+
+	if (entry->bitmap) {
+		n = rb_prev(&entry->offset_index);
+		if (n) {
+			prev = rb_entry(n, struct btrfs_free_space,
+					offset_index);
+			if (!prev->bitmap &&
+			    prev->offset + prev->bytes > offset)
+				return prev;
+		}
+		if (entry->offset + BITS_PER_BITMAP * ctl->unit > offset)
+			return entry;
+	} else if (entry->offset + entry->bytes > offset)
+		return entry;
+
+	if (!fuzzy)
+		return NULL;
+
+	while (1) {
+		if (entry->bitmap) {
+			if (entry->offset + BITS_PER_BITMAP *
+			    ctl->unit > offset)
+				break;
+		} else {
+			if (entry->offset + entry->bytes > offset)
+				break;
+		}
+
+		n = rb_next(&entry->offset_index);
+		if (!n)
+			return NULL;
+		entry = rb_entry(n, struct btrfs_free_space, offset_index);
+	}
+	return entry;
+}
+
+static void unlink_free_space(struct btrfs_free_space_ctl *ctl,
+			      struct btrfs_free_space *info)
+{
+	rb_erase(&info->offset_index, &ctl->free_space_offset);
+	ctl->free_extents--;
+	ctl->free_space -= info->bytes;
+}
+
+static int link_free_space(struct btrfs_free_space_ctl *ctl,
+			   struct btrfs_free_space *info)
+{
+	int ret = 0;
+
+	BUG_ON(!info->bitmap && !info->bytes);
+	ret = tree_insert_offset(&ctl->free_space_offset, info->offset,
+				 &info->offset_index, (info->bitmap != NULL));
+	if (ret)
+		return ret;
+
+	ctl->free_space += info->bytes;
+	ctl->free_extents++;
+	return ret;
+}
+
+static int search_bitmap(struct btrfs_free_space_ctl *ctl,
+			 struct btrfs_free_space *bitmap_info, u64 *offset,
+			 u64 *bytes)
+{
+	unsigned long found_bits = 0;
+	unsigned long bits, i;
+	unsigned long next_zero;
+
+	i = offset_to_bit(bitmap_info->offset, ctl->unit,
+			  max_t(u64, *offset, bitmap_info->offset));
+	bits = bytes_to_bits(*bytes, ctl->unit);
+
+	for_each_set_bit_from(i, bitmap_info->bitmap, BITS_PER_BITMAP) {
+		next_zero = find_next_zero_bit(bitmap_info->bitmap,
+					       BITS_PER_BITMAP, i);
+		if ((next_zero - i) >= bits) {
+			found_bits = next_zero - i;
+			break;
+		}
+		i = next_zero;
+	}
+
+	if (found_bits) {
+		*offset = (u64)(i * ctl->unit) + bitmap_info->offset;
+		*bytes = (u64)(found_bits) * ctl->unit;
+		return 0;
+	}
+
+	return -1;
+}
+
+struct btrfs_free_space *
+btrfs_find_free_space(struct btrfs_free_space_ctl *ctl, u64 offset, u64 bytes)
+{
+	return tree_search_offset(ctl, offset, 0, 0);
+}
+
+static void try_merge_free_space(struct btrfs_free_space_ctl *ctl,
+				struct btrfs_free_space *info)
+{
+	struct btrfs_free_space *left_info;
+	struct btrfs_free_space *right_info;
+	u64 offset = info->offset;
+	u64 bytes = info->bytes;
+
+	/*
+	 * first we want to see if there is free space adjacent to the range we
+	 * are adding, if there is remove that struct and add a new one to
+	 * cover the entire range
+	 */
+	right_info = tree_search_offset(ctl, offset + bytes, 0, 0);
+	if (right_info && rb_prev(&right_info->offset_index))
+		left_info = rb_entry(rb_prev(&right_info->offset_index),
+				     struct btrfs_free_space, offset_index);
+	else
+		left_info = tree_search_offset(ctl, offset - 1, 0, 0);
+
+	if (right_info && !right_info->bitmap) {
+		unlink_free_space(ctl, right_info);
+		info->bytes += right_info->bytes;
+		free(right_info);
+	}
+
+	if (left_info && !left_info->bitmap &&
+	    left_info->offset + left_info->bytes == offset) {
+		unlink_free_space(ctl, left_info);
+		info->offset = left_info->offset;
+		info->bytes += left_info->bytes;
+		free(left_info);
+	}
+}
+
+void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
+			   u64 bytes)
+{
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
+	struct btrfs_free_space *info;
+	struct rb_node *n;
+	int count = 0;
+
+	for (n = rb_first(&ctl->free_space_offset); n; n = rb_next(n)) {
+		info = rb_entry(n, struct btrfs_free_space, offset_index);
+		if (info->bytes >= bytes && !block_group->ro)
+			count++;
+		printk("entry offset %llu, bytes %llu, bitmap %s\n",
+		       (unsigned long long)info->offset,
+		       (unsigned long long)info->bytes,
+		       (info->bitmap) ? "yes" : "no");
+	}
+	printk("%d blocks of free space at or bigger than bytes is \n", count);
+}
+
+int btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group,
+			      int sectorsize)
+{
+	struct btrfs_free_space_ctl *ctl;
+
+	ctl = calloc(1, sizeof(*ctl));
+	if (!ctl)
+		return -ENOMEM;
+
+	ctl->unit = sectorsize;
+	ctl->start = block_group->key.objectid;
+	ctl->private = block_group;
+	block_group->free_space_ctl = ctl;
+
+	return 0;
+}
+
+void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl)
+{
+	struct btrfs_free_space *info;
+	struct rb_node *node;
+
+	while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
+		info = rb_entry(node, struct btrfs_free_space, offset_index);
+		unlink_free_space(ctl, info);
+		if (info->bitmap)
+			free(info->bitmap);
+		free(info);
+	}
+}
+
+void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
+{
+	__btrfs_remove_free_space_cache(block_group->free_space_ctl);
+}
+
+int btrfs_add_free_space(struct btrfs_free_space_ctl *ctl, u64 offset,
+			 u64 bytes)
+{
+	struct btrfs_free_space *info;
+	int ret = 0;
+
+	info = calloc(1, sizeof(*info));
+	if (!info)
+		return -ENOMEM;
+
+	info->offset = offset;
+	info->bytes = bytes;
+
+	try_merge_free_space(ctl, info);
+
+	ret = link_free_space(ctl, info);
+	if (ret)
+
+	if (ret) {
+		printk(KERN_CRIT "btrfs: unable to add free space :%d\n", ret);
+		BUG_ON(ret == -EEXIST);
+	}
+
+	return ret;
+}
+
+/*
+ * Merges all the free space cache and kills the bitmap entries since we just
+ * want to use the free space cache to verify it's correct, no reason to keep
+ * the bitmaps around to confuse things.
+ */
+static void merge_space_tree(struct btrfs_free_space_ctl *ctl)
+{
+	struct btrfs_free_space *e, *prev = NULL;
+	struct rb_node *n;
+	int ret;
+
+again:
+	prev = NULL;
+	for (n = rb_first(&ctl->free_space_offset); n; n = rb_next(n)) {
+		e = rb_entry(n, struct btrfs_free_space, offset_index);
+		if (e->bitmap) {
+			u64 offset = e->offset, bytes = ctl->unit;
+			u64 end;
+
+			end = e->offset + (u64)(BITS_PER_BITMAP * ctl->unit);
+
+			unlink_free_space(ctl, e);
+			while (!(search_bitmap(ctl, e, &offset, &bytes))) {
+				ret = btrfs_add_free_space(ctl, offset,
+							   bytes);
+				BUG_ON(ret);
+				offset += bytes;
+				if (offset >= end)
+					break;
+				bytes = ctl->unit;
+			}
+			free(e->bitmap);
+			free(e);
+			goto again;
+		}
+		if (!prev)
+			goto next;
+		if (prev->offset + prev->bytes == e->offset) {
+			unlink_free_space(ctl, prev);
+			unlink_free_space(ctl, e);
+			prev->bytes += e->bytes;
+			free(e);
+			link_free_space(ctl, prev);
+			goto again;
+		}
+next:
+		prev = e;
+	}
+}
diff --git a/free-space-cache.h b/free-space-cache.h
new file mode 100644
index 0000000..8f17972
--- /dev/null
+++ b/free-space-cache.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2009 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef __BTRFS_FREE_SPACE_CACHE
+#define __BTRFS_FREE_SPACE_CACHE
+
+struct btrfs_free_space {
+	struct rb_node offset_index;
+	u64 offset;
+	u64 bytes;
+	unsigned long *bitmap;
+	struct list_head list;
+};
+
+struct btrfs_free_space_ctl {
+	struct rb_root free_space_offset;
+	u64 free_space;
+	int extents_thresh;
+	int free_extents;
+	int total_bitmaps;
+	int unit;
+	u64 start;
+	void *private;
+};
+
+int load_free_space_cache(struct btrfs_fs_info *fs_info,
+			  struct btrfs_block_group_cache *block_group);
+
+void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl);
+void btrfs_remove_free_space_cache(struct btrfs_block_group_cache
+				     *block_group);
+void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
+			   u64 bytes);
+struct btrfs_free_space *
+btrfs_find_free_space(struct btrfs_free_space_ctl *ctl, u64 offset, u64 bytes);
+int btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group,
+			      int sectorsize);
+#endif
-- 
1.7.7.6

