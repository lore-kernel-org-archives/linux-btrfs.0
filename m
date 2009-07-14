From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: A start at RAID[56] support.
Date: Tue, 14 Jul 2009 17:15:46 +0100
Message-ID: <1247588146.19180.1016.camel@macbook.infradead.org>
References: <1247323186.17045.15.camel@macbook.infradead.org>
	 <1247323241.17045.16.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247323241.17045.16.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-07-11 at 15:40 +0100, David Woodhouse wrote:
> On Sat, 2009-07-11 at 15:39 +0100, David Woodhouse wrote:
> > This is a preliminary attempt to add RAID5 and RAID6 support.
> 
> Matching btrfs-progs patch...

And this makes it actually write the P and Q stripes...

These patches at git://,
http://git.infradead.org/users/dwmw2/btrfs-progs-raid56.git

I can now make a 4-disk RAID6 file system, copy some stuff to it, then
kick out two of the disks and use it in degraded mode, and everything
seems to work fine.

diff --git a/Makefile b/Makefile
index 8097b5a..2d8d349 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@ CFLAGS = -g -Werror -Os
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o
+	  volumes.o utils.o raid6.o
 
 #
 CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
diff --git a/disk-io.c b/disk-io.c
index addebe1..c33c31b 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -138,7 +138,7 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 	dev_nr = 0;
 	length = blocksize;
 	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
-			      bytenr, &length, &multi, 0);
+			      bytenr, &length, &multi, 0, NULL);
 	BUG_ON(ret);
 	device = multi->stripes[0].dev;
 	device->total_ios++;
@@ -196,7 +196,8 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	length = blocksize;
 	while (1) {
 		ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
-				      eb->start, &length, &multi, mirror_num);
+				      eb->start, &length, &multi, mirror_num,
+				      NULL);
 		BUG_ON(ret);
 		device = multi->stripes[0].dev;
 		eb->fd = device->fd;
@@ -224,12 +225,93 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	return NULL;
 }
 
+static int write_raid56_with_parity(struct extent_buffer *eb,
+				    struct btrfs_multi_bio *multi,
+				    u64 stripe_len, u64 *raid_map)
+{
+	struct extent_buffer *ebs[multi->num_stripes], *p_eb = NULL, *q_eb = NULL;
+	u64 start_ofs, end_ofs;
+	int i, j;
+	int ret;
+
+	start_ofs = eb->start % stripe_len;
+	end_ofs = start_ofs + eb->len;
+	BUG_ON(end_ofs > stripe_len);
+
+	j = 0;
+	for (i = 0; i < multi->num_stripes; i++) {
+		struct extent_buffer *new_eb;
+		if (start_ofs) {
+			multi->stripes[i].physical += start_ofs;
+			if (raid_map[i] != (u64)-1 && raid_map[i] != (u64)-2)
+				raid_map[i] += start_ofs;
+		}
+		if (raid_map[i] == eb->start) {
+			eb->dev_bytenr = multi->stripes[i].physical;
+			eb->fd = multi->stripes[i].dev->fd;
+			multi->stripes[i].dev->total_ios++;
+			ebs[j++] = eb;
+			continue;
+		}
+		new_eb = kmalloc(sizeof(*eb) + eb->len, GFP_NOFS);
+		BUG_ON(!new_eb);
+		new_eb->dev_bytenr = multi->stripes[i].physical;
+		new_eb->fd = multi->stripes[i].dev->fd;
+		multi->stripes[i].dev->total_ios++;
+		new_eb->len = eb->len;
+		if (raid_map[i] == (u64)-1) {
+			p_eb = new_eb;
+		} else if (raid_map[i] == (u64)-2) {
+			q_eb = new_eb;
+		} else {
+			ret = read_extent_from_disk(new_eb);
+			BUG_ON(ret);
+			ebs[j++] = new_eb;
+		}
+	}
+	ebs[j++] = p_eb;
+	if (q_eb) {
+		void *pointers[multi->num_stripes];
+
+		ebs[j++] = q_eb;
+
+		for (i = 0; i < multi->num_stripes; i++)
+			pointers[i] = ebs[i]->data;
+
+		raid6_gen_syndrome(multi->num_stripes, eb->len, pointers);
+
+		ret = write_extent_to_disk(q_eb);
+		BUG_ON(ret);
+	} else {
+		memcpy(p_eb->data, ebs[0]->data, eb->len);
+		for (j = 1; j < multi->num_stripes - 1; j++) {
+			for (i = 0; i < eb->len; i += sizeof(unsigned long)) {
+				*(unsigned long *)(p_eb->data + i) ^=
+					*(unsigned long *)(ebs[j]->data + i);
+			}
+		}
+	}
+
+	ret = write_extent_to_disk(p_eb);
+	BUG_ON(ret);
+
+	ret = write_extent_to_disk(eb);
+	BUG_ON(ret);
+
+	for (i = 0; i < multi->num_stripes; i++)
+		if (ebs[i] != eb)
+			kfree(ebs[i]);
+		
+	return 0;
+}
+
 int write_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		     struct extent_buffer *eb)
 {
 	int ret;
 	int dev_nr;
 	u64 length;
+	u64 *raid_map = NULL;
 	struct btrfs_multi_bio *multi = NULL;
 
 	if (check_tree_block(root, eb))
@@ -243,9 +325,12 @@ int write_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	dev_nr = 0;
 	length = eb->len;
 	ret = btrfs_map_block(&root->fs_info->mapping_tree, WRITE,
-			      eb->start, &length, &multi, 0);
+			      eb->start, &length, &multi, 0, &raid_map);
 
-	while(dev_nr < multi->num_stripes) {
+	if (raid_map) {
+		ret = write_raid56_with_parity(eb, multi, length, raid_map);
+		BUG_ON(ret);
+	} else while (dev_nr < multi->num_stripes) {
 		BUG_ON(ret);
 		eb->fd = multi->stripes[dev_nr].dev->fd;
 		eb->dev_bytenr = multi->stripes[dev_nr].physical;
diff --git a/disk-io.h b/disk-io.h
index 49e5692..546649f 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -76,3 +76,6 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		    int verify);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 #endif
+
+/* raid6.c */
+void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
diff --git a/raid6.c b/raid6.c
new file mode 100644
index 0000000..2ba9d90
--- /dev/null
+++ b/raid6.c
@@ -0,0 +1,105 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright 2002-2004 H. Peter Anvin - All Rights Reserved
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
+ *   (at your option) any later version; incorporated herein by reference.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * raid6int1.c
+ *
+ * 1-way unrolled portable integer math RAID-6 instruction set
+ *
+ * This file was postprocessed using unroll.pl and then ported to userspace
+ */
+#include <stdint.h>
+#include <unistd.h>
+/*
+ * This is the C data type to use
+ */
+
+/* Change this from BITS_PER_LONG if there is something better... */
+#if BITS_PER_LONG == 64
+# define NBYTES(x) ((x) * 0x0101010101010101UL)
+# define NSIZE  8
+# define NSHIFT 3
+typedef uint64_t unative_t;
+#else
+# define NBYTES(x) ((x) * 0x01010101U)
+# define NSIZE  4
+# define NSHIFT 2
+typedef uint32_t unative_t;
+#endif
+
+#ifdef __GNUC__
+#define __attribute_const__ __attribute__((const))
+#else
+#define __attribute_const__
+#endif
+
+
+
+/*
+ * These sub-operations are separate inlines since they can sometimes be
+ * specially optimized using architecture-specific hacks.
+ */
+
+/*
+ * The SHLBYTE() operation shifts each byte left by 1, *not*
+ * rolling over into the next byte
+ */
+static inline __attribute_const__ unative_t SHLBYTE(unative_t v)
+{
+	unative_t vv;
+
+	vv = (v << 1) & NBYTES(0xfe);
+	return vv;
+}
+
+/*
+ * The MASK() operation returns 0xFF in any byte for which the high
+ * bit is 1, 0x00 for any byte for which the high bit is 0.
+ */
+static inline __attribute_const__ unative_t MASK(unative_t v)
+{
+	unative_t vv;
+
+	vv = v & NBYTES(0x80);
+	vv = (vv << 1) - (vv >> 7); /* Overflow on the top bit is OK */
+	return vv;
+}
+
+
+void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs)
+{
+	uint8_t **dptr = (uint8_t **)ptrs;
+	uint8_t *p, *q;
+	int d, z, z0;
+
+	unative_t wd0, wq0, wp0, w10, w20;
+
+	z0 = disks - 3;		/* Highest data disk */
+	p = dptr[z0+1];		/* XOR parity */
+	q = dptr[z0+2];		/* RS syndrome */
+
+	for ( d = 0 ; d < bytes ; d += NSIZE*1 ) {
+		wq0 = wp0 = *(unative_t *)&dptr[z0][d+0*NSIZE];
+		for ( z = z0-1 ; z >= 0 ; z-- ) {
+			wd0 = *(unative_t *)&dptr[z][d+0*NSIZE];
+			wp0 ^= wd0;
+			w20 = MASK(wq0);
+			w10 = SHLBYTE(wq0);
+			w20 &= NBYTES(0x1d);
+			w10 ^= w20;
+			wq0 = w10 ^ wd0;
+		}
+		*(unative_t *)&p[d+NSIZE*0] = wp0;
+		*(unative_t *)&q[d+NSIZE*0] = wq0;
+	}
+}
+
diff --git a/volumes.c b/volumes.c
index 90090b0..f146750 100644
--- a/volumes.c
+++ b/volumes.c
@@ -62,6 +62,12 @@ static inline int nr_data_stripes(struct map_lookup *map)
 	return map->num_stripes - nr_parity_stripes(map);
 }
 
+
+#define RAID5_P_STRIPE ((u64)-1)
+#define RAID6_Q_STRIPE ((u64)-2)
+
+#define is_parity_stripe(x) ( ((x) == RAID5_P_STRIPE) || ((x) == RAID6_Q_STRIPE) )
+
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
@@ -988,13 +994,15 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 
 int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		    u64 logical, u64 *length,
-		    struct btrfs_multi_bio **multi_ret, int mirror_num)
+		    struct btrfs_multi_bio **multi_ret, int mirror_num,
+		    u64 **raid_map_ret)
 {
 	struct cache_extent *ce;
 	struct map_lookup *map;
 	u64 offset;
 	u64 stripe_offset;
 	u64 stripe_nr;
+	u64 *raid_map = NULL;
 	int stripes_allocated = 8;
 	int stripes_required = 1;
 	int stripe_index;
@@ -1026,10 +1034,24 @@ again:
 			stripes_required = map->sub_stripes;
 		}
 	}
+	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)
+	    && multi_ret && ((rw & WRITE) || mirror_num > 1) && raid_map_ret) {
+		    /* RAID[56] write or recovery. Return all stripes */
+		    stripes_required = map->num_stripes;
+
+		    /* Only allocate the map if we've already got a large enough multi_ret */
+		    if (stripes_allocated >= stripes_required) {
+			    raid_map = kmalloc(sizeof(u64) * map->num_stripes, GFP_NOFS);
+			    if (!raid_map) {
+				    kfree(multi);
+				    return -ENOMEM;
+			    }
+		    }
+	}
+
 	/* if our multi bio struct is too small, back off and try again */
-	if (multi_ret && rw == WRITE &&
-	    stripes_allocated < stripes_required) {
-		stripes_allocated = map->num_stripes;
+	if (multi_ret && stripes_allocated < stripes_required) {
+		stripes_allocated = stripes_required;
 		kfree(multi);
 		goto again;
 	}
@@ -1094,17 +1116,39 @@ again:
 		stripe_index = stripe_nr % nr_data_stripes(map);
 		stripe_nr = stripe_nr / nr_data_stripes(map);
 
-		/*
-		 * Mirror #0 or #1 means the original data block.
-		 * Mirror #2 is RAID5 parity block.
-		 * Mirror #3 is RAID6 Q block.
-		 */
-		if (mirror_num > 1)
-			stripe_index = nr_data_stripes(map) + mirror_num - 2;
+		if (raid_map) {
+			int i, rot;
+			u64 tmp;
+
+			/* Work out the disk rotation on this stripe-set */
+			rot = stripe_nr % map->num_stripes;
+
+			/* Fill in the logical address of each stripe */
+			tmp = stripe_nr * nr_data_stripes(map);
+			for (i = 0; i < nr_data_stripes(map); i++)
+				raid_map[(i+rot) % map->num_stripes] =
+					ce->start + (tmp + i) * map->stripe_len;
 
-		/* We distribute the parity blocks across stripes */
-		stripe_index = (stripe_nr + stripe_index) & map->num_stripes;
+			raid_map[(i+rot) % map->num_stripes] = RAID5_P_STRIPE;
+			if (map->type & BTRFS_BLOCK_GROUP_RAID6)
+				raid_map[(i+rot+1) % map->num_stripes] = RAID6_Q_STRIPE;
 
+			*length = map->stripe_len;
+			stripe_index = 0;
+			stripe_offset = 0;
+			multi->num_stripes = map->num_stripes;
+		} else {
+			/*
+			 * Mirror #0 or #1 means the original data block.
+			 * Mirror #2 is RAID5 parity block.
+			 * Mirror #3 is RAID6 Q block.
+			 */
+			if (mirror_num > 1)
+				stripe_index = nr_data_stripes(map) + mirror_num - 2;
+
+			/* We distribute the parity blocks across stripes */
+			stripe_index = (stripe_nr + stripe_index) & map->num_stripes;
+		}
 	} else {
 		/*
 		 * after this do_div call, stripe_nr is the number of stripes
@@ -1124,6 +1168,8 @@ again:
 		stripe_index++;
 	}
 	*multi_ret = multi;
+	if (raid_map_ret)
+		*raid_map_ret = raid_map;
 out:
 	return 0;
 }
diff --git a/volumes.h b/volumes.h
index bb78751..1e993db 100644
--- a/volumes.h
+++ b/volumes.h
@@ -98,7 +98,8 @@ int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 			   u64 num_bytes, u64 *start);
 int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		    u64 logical, u64 *length,
-		    struct btrfs_multi_bio **multi_ret, int mirror_num);
+		    struct btrfs_multi_bio **multi_ret, int mirror_num,
+		    u64 **raid_map);
 int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len);

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

