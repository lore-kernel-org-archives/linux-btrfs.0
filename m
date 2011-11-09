From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 1/4] Btrfs: add optional integrity check code
Date: Wed,  9 Nov 2011 16:17:58 +0100
Message-ID: <a5a8213f8a772486586a479062517ebd53636ce3.1320850526.git.sbehrens@giantdisaster.de>
References: <cover.1320849129.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1320849129.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

The two files added in this patch contain all the code that is
required to implement the integrity checks.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c | 2763 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/check-integrity.h |   36 +
 2 files changed, 2799 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
new file mode 100644
index 0000000..5bbceba
--- /dev/null
+++ b/fs/btrfs/check-integrity.c
@@ -0,0 +1,2763 @@
+/*
+ * Copyright (C) STRATO AG 2011.  All rights reserved.
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
+/*
+ * This module can be used to catch cases when the btrfs kernel
+ * code executes write requests to the disk that bring the file
+ * system in an inconsistent state. In such a state, a power-loss
+ * or kernel panic event would cause that the data on disk is
+ * lost or at least damaged.
+ *
+ * Code is added that examines all block write requests during
+ * runtime (including writes of the super block). Three rules
+ * are verified and an error is printed on violation of the
+ * rules:
+ * 1. It is not allowed to write a disk block which is
+ *    currently referenced by the super block (either directly
+ *    or indirectly).
+ * 2. When a super block is written, it is verified that all
+ *    referenced (directly or indirectly) blocks fulfill the
+ *    following requirements:
+ *    2a. All referenced blocks have either been present when
+ *        the file system was mounted, (i.e., they have been
+ *        referenced by the super block) or they have been
+ *        written since then and the write completion callback
+ *        was called.
+ *    2b. All referenced blocks need to have a generation
+ *        number which is equal to the parent's number.
+ *
+ * One issue that was found using this module was that the log
+ * tree on disk became temporarily corrupted because disk blocks
+ * that had been in use for the log tree had been freed and
+ * reused too early, while being referenced by the written super
+ * block.
+ *
+ * The search term in the kernel log that can be used to filter
+ * on the existence of detected integrity issues is
+ * "btrfs: attempt".
+ *
+ * The integrity check is enabled via mount options. These
+ * mount options are only supported if the integrity check
+ * tool is compiled by defining BTRFS_FS_CHECK_INTEGRITY.
+ *
+ * Example #1, apply integrity checks to all metadata:
+ * mount /dev/sdb1 /mnt -o check_int
+ *
+ * Example #2, apply integrity checks to all metadata and
+ * to data extents:
+ * mount /dev/sdb1 /mnt -o check_int_data
+ *
+ * Example #3, apply integrity checks to all metadata and dump
+ * the tree that the super block references to kernel messages
+ * each time after a super block was written:
+ * mount /dev/sdb1 /mnt -o check_int,check_int_print_mask=263
+ *
+ * If the integrity check tool is included and activated in
+ * the mount options, plenty of kernel memory is used, and
+ * plenty of additional CPU cycles are spent. Enabling this
+ * functionality is not intended for normal use. In most
+ * cases, unless you are a btrfs developer who needs to verify
+ * the integrity of (super)-block write requests, do not
+ * enable the config option BTRFS_FS_CHECK_INTEGRITY to
+ * include and compile the integrity check tool.
+ */
+
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/buffer_head.h>
+#include <linux/mutex.h>
+#include <linux/crc32c.h>
+#include <linux/genhd.h>
+#include "ctree.h"
+#include "disk-io.h"
+#include "transaction.h"
+#include "extent_io.h"
+#include "disk-io.h"
+#include "volumes.h"
+#include "print-tree.h"
+#include "locking.h"
+#include "check-integrity.h"
+
+#define BTRFSIC_BLOCK_HASHTABLE_SIZE 0x10000
+#define BTRFSIC_BLOCK_LINK_HASHTABLE_SIZE 0x10000
+#define BTRFSIC_DEV2STATE_HASHTABLE_SIZE 0x100
+#define BTRFSIC_BLOCK_MAGIC_NUMBER 0x14491051
+#define BTRFSIC_BLOCK_LINK_MAGIC_NUMBER 0x11070807
+#define BTRFSIC_DEV2STATE_MAGIC_NUMBER 0x20111530
+#define BTRFSIC_BLOCK_STACK_FRAME_MAGIC_NUMBER 20111300
+#define BTRFSIC_TREE_DUMP_MAX_INDENT_LEVEL (200 - 6)	/* in characters,
+							 * excluding " [...]" */
+#define BTRFSIC_BLOCK_SIZE PAGE_SIZE
+
+#define BTRFSIC_GENERATION_UNKNOWN ((u64) -1)
+
+/*
+ * The definition of the bitmask fields for the print_mask.
+ * They are specified with the mount option check_integrity_print_mask.
+ */
+#define BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE			0x00000001
+#define BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION		0x00000002
+#define BTRFSIC_PRINT_MASK_TREE_AFTER_SB_WRITE			0x00000004
+#define BTRFSIC_PRINT_MASK_TREE_BEFORE_SB_WRITE			0x00000008
+#define BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH			0x00000010
+#define BTRFSIC_PRINT_MASK_END_IO_BIO_BH			0x00000020
+#define BTRFSIC_PRINT_MASK_VERBOSE				0x00000040
+#define BTRFSIC_PRINT_MASK_VERY_VERBOSE				0x00000080
+#define BTRFSIC_PRINT_MASK_INITIAL_TREE				0x00000100
+#define BTRFSIC_PRINT_MASK_INITIAL_ALL_TREES			0x00000200
+#define BTRFSIC_PRINT_MASK_INITIAL_DATABASE			0x00000400
+#define BTRFSIC_PRINT_MASK_NUM_COPIES				0x00000800
+#define BTRFSIC_PRINT_MASK_TREE_WITH_ALL_MIRRORS		0x00001000
+
+struct btrfsic_state;
+
+struct btrfsic_block {
+	u32 magic_num;		/* only used for debug purposes */
+	unsigned int is_metadata:1;	/* if it is meta-data, not data-data */
+	unsigned int is_superblock:1;	/* if it is one of the superblocks */
+	unsigned int is_iodone:1;	/* if is done by lower subsystem */
+	unsigned int iodone_w_error:1;	/* error was indicated to endio */
+	unsigned int never_written:1;	/* block was added because it was
+					 * referenced, not because it was
+					 * written */
+	unsigned int mirror_num:2;	/* large enough to hold
+					 * BTRFS_SUPER_MIRROR_MAX */
+	struct block_device *bdev;
+	u64 dev_bytenr;		/* key, physical byte num on disk */
+	u64 logical_bytenr;	/* logical byte num on disk */
+	u64 generation;
+	struct btrfs_disk_key disk_key;	/* extra info to print in case of
+					 * issues, will not always be correct */
+	struct list_head collision_resolving_node;	/* list node */
+	struct list_head all_blocks_node;	/* list node */
+
+	/* the following two lists contain block_link items */
+	struct list_head ref_to_list;	/* list */
+	struct list_head ref_from_list;	/* list */
+	struct btrfsic_block *next_in_same_bio;
+	void *orig_bio_bh_private;
+	union {
+		bio_end_io_t *bio;
+		bh_end_io_t *bh;
+	} orig_bio_bh_end_io;
+};
+
+/*
+ * Elements of this type are allocated dynamically and required because
+ * each block object can refer to and can be ref from multiple blocks.
+ * The key to lookup them in the hashtable is the dev_bytenr of
+ * the block ref to plus the one from the block refered from.
+ * The fact that they are searchable via a hashtable and that a
+ * ref_cnt is maintained is not required for the btrfs integrity
+ * check algorithm itself, it is only used to make the output more
+ * beautiful in case that an error is detected (an error is defined
+ * as a write operation to a block while that block is still referenced).
+ */
+struct btrfsic_block_link {
+	u32 magic_num;		/* only used for debug purposes */
+	u32 ref_cnt;
+	struct list_head node_ref_to;	/* list node */
+	struct list_head node_ref_from;	/* list node */
+	struct list_head collision_resolving_node;	/* list node */
+	struct btrfsic_block *block_ref_to;
+	struct btrfsic_block *block_ref_from;
+	u64 parent_generation;
+};
+
+struct btrfsic_dev2state {
+	u32 magic_num;		/* only used for debug purposes */
+	struct block_device *bdev;
+	struct btrfsic_state *state;
+	struct list_head collision_resolving_node;	/* list node */
+};
+
+struct btrfsic_block_hashtable {
+	struct list_head table[BTRFSIC_BLOCK_HASHTABLE_SIZE];
+};
+
+struct btrfsic_block_link_hashtable {
+	struct list_head table[BTRFSIC_BLOCK_LINK_HASHTABLE_SIZE];
+};
+
+struct btrfsic_dev2state_hashtable {
+	struct list_head table[BTRFSIC_DEV2STATE_HASHTABLE_SIZE];
+};
+
+struct btrfsic_block_data_ctx {
+	u64 start;		/* virtual bytenr */
+	u64 dev_bytenr;		/* physical bytenr on device */
+	u32 len;
+	struct block_device *bdev;
+	char *data;
+	struct buffer_head *bh;	/* do not use if set to NULL */
+};
+
+/* This structure is used to implement recursion without occupying
+ * any stack space, refer to btrfsic_process_metablock() */
+struct btrfsic_stack_frame {
+	u32 magic;
+	u32 nr;
+	int error;
+	int i;
+	int limit_nesting;
+	int num_copies;
+	int mirror_num;
+	struct btrfsic_block *block;
+	struct btrfsic_block_data_ctx *block_ctx;
+	struct btrfsic_block *next_block;
+	struct btrfsic_block_data_ctx next_block_ctx;
+	struct btrfs_header *hdr;
+	struct btrfsic_stack_frame *prev;
+};
+
+/* Some state per mounted filesystem */
+struct btrfsic_state {
+	u32 print_mask;
+	int include_extent_data;
+	int csum_size;
+	struct list_head all_blocks_list;
+	struct btrfsic_block_hashtable block_hashtable;
+	struct btrfsic_block_link_hashtable block_link_hashtable;
+	struct btrfs_root *root;
+	u64 max_superblock_generation;
+	struct btrfsic_block *latest_superblock;
+};
+
+static void btrfsic_block_init(struct btrfsic_block *b);
+static struct btrfsic_block *btrfsic_block_alloc(void);
+static void btrfsic_block_free(struct btrfsic_block *b);
+static void btrfsic_block_link_init(struct btrfsic_block_link *n);
+static struct btrfsic_block_link *btrfsic_block_link_alloc(void);
+static void btrfsic_block_link_free(struct btrfsic_block_link *n);
+static void btrfsic_dev2state_init(struct btrfsic_dev2state *d2s);
+static struct btrfsic_dev2state *btrfsic_dev2state_alloc(void);
+static void btrfsic_dev2state_free(struct btrfsic_dev2state *d2s);
+static void btrfsic_block_hashtable_init(struct btrfsic_block_hashtable *h);
+static void btrfsic_block_hashtable_add(struct btrfsic_block *b,
+					struct btrfsic_block_hashtable *h);
+static void btrfsic_block_hashtable_remove(struct btrfsic_block *b);
+static struct btrfsic_block *btrfsic_block_hashtable_lookup(
+		struct block_device *bdev,
+		u64 dev_bytenr,
+		struct btrfsic_block_hashtable *h);
+static void btrfsic_block_link_hashtable_init(
+		struct btrfsic_block_link_hashtable *h);
+static void btrfsic_block_link_hashtable_add(
+		struct btrfsic_block_link *l,
+		struct btrfsic_block_link_hashtable *h);
+static void btrfsic_block_link_hashtable_remove(struct btrfsic_block_link *l);
+static struct btrfsic_block_link *btrfsic_block_link_hashtable_lookup(
+		struct block_device *bdev_ref_to,
+		u64 dev_bytenr_ref_to,
+		struct block_device *bdev_ref_from,
+		u64 dev_bytenr_ref_from,
+		struct btrfsic_block_link_hashtable *h);
+static void btrfsic_dev2state_hashtable_init(
+		struct btrfsic_dev2state_hashtable *h);
+static void btrfsic_dev2state_hashtable_add(
+		struct btrfsic_dev2state *d2s,
+		struct btrfsic_dev2state_hashtable *h);
+static void btrfsic_dev2state_hashtable_remove(struct btrfsic_dev2state *d2s);
+static struct btrfsic_dev2state *btrfsic_dev2state_hashtable_lookup(
+		struct block_device *bdev,
+		struct btrfsic_dev2state_hashtable *h);
+static struct btrfsic_stack_frame *btrfsic_stack_frame_alloc(void);
+static void btrfsic_stack_frame_free(struct btrfsic_stack_frame *sf);
+static int btrfsic_process_superblock(struct btrfsic_state *state,
+				      struct btrfs_fs_devices *fs_devices);
+static int btrfsic_process_metablock(struct btrfsic_state *state,
+				     struct btrfsic_block *block,
+				     struct btrfsic_block_data_ctx *block_ctx,
+				     struct btrfs_header *hdr,
+				     int limit_nesting, int force_iodone_flag);
+static int btrfsic_create_link_to_next_block(struct btrfsic_state *state,
+					     struct btrfsic_block *block,
+					     struct btrfsic_block_data_ctx
+					     *block_ctx, u64 next_bytenr,
+					     int limit_nesting,
+					     struct btrfsic_block_data_ctx
+					     *next_block_ctx,
+					     struct btrfsic_block **next_blockp,
+					     int force_iodone_flag,
+					     int *num_copiesp, int *mirror_nump,
+					     struct btrfs_disk_key *disk_key,
+					     u64 parent_generation);
+static int btrfsic_handle_extent_data(struct btrfsic_state *state,
+				      struct btrfsic_block *block,
+				      struct btrfsic_block_data_ctx *block_ctx,
+				      u32 item_offset, int force_iodone_flag);
+static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
+			     struct btrfsic_block_data_ctx *block_ctx_out,
+			     int mirror_num);
+static int btrfsic_map_superblock(struct btrfsic_state *state, u64 bytenr,
+				  u32 len, struct block_device *bdev,
+				  struct btrfsic_block_data_ctx *block_ctx_out);
+static void btrfsic_release_block_ctx(struct btrfsic_block_data_ctx *block_ctx);
+static int btrfsic_read_block(struct btrfsic_state *state,
+			      struct btrfsic_block_data_ctx *block_ctx);
+static void btrfsic_dump_database(struct btrfsic_state *state);
+static int btrfsic_test_for_metadata(struct btrfsic_state *state,
+				     const u8 *data, unsigned int size);
+static void btrfsic_process_written_block(struct btrfsic_state *state,
+					  struct block_device *bdev,
+					  u64 dev_bytenr, u8 *mapped_data,
+					  unsigned int len, struct bio *bio,
+					  int *bio_is_patched,
+					  struct buffer_head *bh);
+static int btrfsic_process_written_superblock(struct btrfsic_state *state,
+					      struct btrfsic_block *const block,
+					      struct btrfs_super_block *const
+					      super_hdr);
+static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status);
+static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate);
+static int btrfsic_is_block_ref_by_superblock(const struct btrfsic_state *state,
+					      const struct btrfsic_block *block,
+					      int recursion_level);
+static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
+					struct btrfsic_block *const block,
+					int recursion_level);
+static void btrfsic_print_add_link(const struct btrfsic_state *state,
+				   const struct btrfsic_block_link *l);
+static void btrfsic_print_rem_link(const struct btrfsic_state *state,
+				   const struct btrfsic_block_link *l);
+static char btrfsic_get_block_type(const struct btrfsic_state *state,
+				   const struct btrfsic_block *block);
+static void btrfsic_dump_tree(const struct btrfsic_state *state);
+static void btrfsic_dump_tree_sub(const struct btrfsic_state *state,
+				  const struct btrfsic_block *block,
+				  int indent_level);
+static struct btrfsic_block_link *btrfsic_block_link_lookup_or_add(
+		struct btrfsic_state *state,
+		struct btrfsic_block_data_ctx *next_block_ctx,
+		struct btrfsic_block *next_block,
+		struct btrfsic_block *from_block,
+		u64 parent_generation);
+static struct btrfsic_block *btrfsic_block_lookup_or_add(
+		struct btrfsic_state *state,
+		struct btrfsic_block_data_ctx *block_ctx,
+		const char *additional_string,
+		int is_metadata,
+		int is_iodone,
+		int never_written,
+		int mirror_num,
+		int *was_created);
+static int btrfsic_process_superblock_dev_mirror(struct btrfsic_state *state,
+						 struct btrfs_device *device,
+						 int superblock_mirror_num,
+						 struct btrfs_super_block
+						 *selected_super);
+static struct btrfsic_state *btrfsic_dev2state_lookup(
+		struct block_device *bdev);
+
+static struct mutex btrfsic_mutex;
+static int btrfsic_is_initialized;
+static struct btrfsic_dev2state_hashtable btrfsic_dev2state_hashtable;
+
+static void btrfsic_block_init(struct btrfsic_block *b)
+{
+	b->magic_num = BTRFSIC_BLOCK_MAGIC_NUMBER;
+	b->dev_bytenr = 0;
+	b->logical_bytenr = 0;
+	b->generation = BTRFSIC_GENERATION_UNKNOWN;
+	b->disk_key.objectid = 0;
+	b->disk_key.type = 0;
+	b->disk_key.offset = 0;
+	b->is_metadata = 0;
+	b->is_superblock = 0;
+	b->is_iodone = 0;
+	b->iodone_w_error = 0;
+	b->never_written = 0;
+	b->mirror_num = 0;
+	b->next_in_same_bio = NULL;
+	b->orig_bio_bh_private = NULL;
+	b->orig_bio_bh_end_io.bio = NULL;
+	INIT_LIST_HEAD(&b->collision_resolving_node);
+	INIT_LIST_HEAD(&b->all_blocks_node);
+	INIT_LIST_HEAD(&b->ref_to_list);
+	INIT_LIST_HEAD(&b->ref_from_list);
+}
+
+static struct btrfsic_block *btrfsic_block_alloc(void)
+{
+	struct btrfsic_block *b;
+
+	b = kzalloc(sizeof(*b), GFP_NOFS);
+	if (NULL != b)
+		btrfsic_block_init(b);
+
+	return b;
+}
+
+static void btrfsic_block_free(struct btrfsic_block *b)
+{
+	BUG_ON(!(NULL == b || BTRFSIC_BLOCK_MAGIC_NUMBER == b->magic_num));
+	kfree(b);
+}
+
+static void btrfsic_block_link_init(struct btrfsic_block_link *l)
+{
+	l->magic_num = BTRFSIC_BLOCK_LINK_MAGIC_NUMBER;
+	l->ref_cnt = 1;
+	INIT_LIST_HEAD(&l->node_ref_to);
+	INIT_LIST_HEAD(&l->node_ref_from);
+	INIT_LIST_HEAD(&l->collision_resolving_node);
+	l->block_ref_to = NULL;
+	l->block_ref_from = NULL;
+}
+
+static struct btrfsic_block_link *btrfsic_block_link_alloc(void)
+{
+	struct btrfsic_block_link *l;
+
+	l = kzalloc(sizeof(*l), GFP_NOFS);
+	if (NULL != l)
+		btrfsic_block_link_init(l);
+
+	return l;
+}
+
+static void btrfsic_block_link_free(struct btrfsic_block_link *l)
+{
+	BUG_ON(!(NULL == l || BTRFSIC_BLOCK_LINK_MAGIC_NUMBER == l->magic_num));
+	kfree(l);
+}
+
+static void btrfsic_dev2state_init(struct btrfsic_dev2state *d2s)
+{
+	d2s->magic_num = BTRFSIC_DEV2STATE_MAGIC_NUMBER;
+	d2s->bdev = NULL;
+	d2s->state = NULL;
+	INIT_LIST_HEAD(&d2s->collision_resolving_node);
+}
+
+static struct btrfsic_dev2state *btrfsic_dev2state_alloc(void)
+{
+	struct btrfsic_dev2state *d2s;
+
+	d2s = kzalloc(sizeof(*d2s), GFP_NOFS);
+	if (NULL != d2s)
+		btrfsic_dev2state_init(d2s);
+
+	return d2s;
+}
+
+static void btrfsic_dev2state_free(struct btrfsic_dev2state *d2s)
+{
+	BUG_ON(!(NULL == d2s ||
+		 BTRFSIC_DEV2STATE_MAGIC_NUMBER == d2s->magic_num));
+	kfree(d2s);
+}
+
+static void btrfsic_block_hashtable_init(struct btrfsic_block_hashtable *h)
+{
+	int i;
+
+	for (i = 0; i < BTRFSIC_BLOCK_HASHTABLE_SIZE; i++)
+		INIT_LIST_HEAD(h->table + i);
+}
+
+static void btrfsic_block_hashtable_add(struct btrfsic_block *b,
+					struct btrfsic_block_hashtable *h)
+{
+	const unsigned int hashval =
+	    (((unsigned int) b->dev_bytenr) &
+	     (BTRFSIC_BLOCK_HASHTABLE_SIZE - 1));
+
+	list_add(&b->collision_resolving_node, h->table + hashval);
+}
+
+static void btrfsic_block_hashtable_remove(struct btrfsic_block *b)
+{
+	list_del(&b->collision_resolving_node);
+}
+
+static struct btrfsic_block *btrfsic_block_hashtable_lookup(
+		struct block_device *bdev,
+		u64 dev_bytenr,
+		struct btrfsic_block_hashtable *h)
+{
+	const unsigned int hashval =
+	    (((unsigned int) dev_bytenr) &
+	     (BTRFSIC_BLOCK_HASHTABLE_SIZE - 1));
+	struct list_head *elem;
+
+	list_for_each(elem, h->table + hashval) {
+		struct btrfsic_block *const b =
+		    list_entry(elem, struct btrfsic_block,
+			       collision_resolving_node);
+
+		if (b->bdev == bdev && b->dev_bytenr == dev_bytenr)
+			return b;
+	}
+
+	return NULL;
+}
+
+static void btrfsic_block_link_hashtable_init(
+		struct btrfsic_block_link_hashtable *h)
+{
+	int i;
+
+	for (i = 0; i < BTRFSIC_BLOCK_LINK_HASHTABLE_SIZE; i++)
+		INIT_LIST_HEAD(h->table + i);
+}
+
+static void btrfsic_block_link_hashtable_add(
+		struct btrfsic_block_link *l,
+		struct btrfsic_block_link_hashtable *h)
+{
+	const unsigned int hashval =
+	    (((unsigned int)
+	      l->block_ref_to->dev_bytenr) ^ ((unsigned int)
+					      l->block_ref_from->dev_bytenr)) &
+	    (BTRFSIC_BLOCK_LINK_HASHTABLE_SIZE - 1);
+
+	BUG_ON(NULL == l->block_ref_to);
+	BUG_ON(NULL == l->block_ref_from);
+	list_add(&l->collision_resolving_node, h->table + hashval);
+}
+
+static void btrfsic_block_link_hashtable_remove(struct btrfsic_block_link *l)
+{
+	list_del(&l->collision_resolving_node);
+}
+
+static struct btrfsic_block_link *btrfsic_block_link_hashtable_lookup(
+		struct block_device *bdev_ref_to,
+		u64 dev_bytenr_ref_to,
+		struct block_device *bdev_ref_from,
+		u64 dev_bytenr_ref_from,
+		struct btrfsic_block_link_hashtable *h)
+{
+	const unsigned int hashval =
+	    (((unsigned int) dev_bytenr_ref_to) ^
+	     ((unsigned int) dev_bytenr_ref_from)) &
+	    (BTRFSIC_BLOCK_LINK_HASHTABLE_SIZE - 1);
+	struct list_head *elem;
+
+	list_for_each(elem, h->table + hashval) {
+		struct btrfsic_block_link *const l =
+		    list_entry(elem, struct btrfsic_block_link,
+			       collision_resolving_node);
+
+		BUG_ON(NULL == l->block_ref_to);
+		BUG_ON(NULL == l->block_ref_from);
+		if (l->block_ref_to->bdev == bdev_ref_to &&
+		    l->block_ref_to->dev_bytenr == dev_bytenr_ref_to &&
+		    l->block_ref_from->bdev == bdev_ref_from &&
+		    l->block_ref_from->dev_bytenr == dev_bytenr_ref_from)
+			return l;
+	}
+
+	return NULL;
+}
+
+static void btrfsic_dev2state_hashtable_init(
+		struct btrfsic_dev2state_hashtable *h)
+{
+	int i;
+
+	for (i = 0; i < BTRFSIC_DEV2STATE_HASHTABLE_SIZE; i++)
+		INIT_LIST_HEAD(h->table + i);
+}
+
+static void btrfsic_dev2state_hashtable_add(
+		struct btrfsic_dev2state *d2s,
+		struct btrfsic_dev2state_hashtable *h)
+{
+	const unsigned int hashval =
+	    (((unsigned int) ((uintptr_t) d2s->bdev)) &
+	     (BTRFSIC_DEV2STATE_HASHTABLE_SIZE - 1));
+
+	list_add(&d2s->collision_resolving_node, h->table + hashval);
+}
+
+static void btrfsic_dev2state_hashtable_remove(struct btrfsic_dev2state *d2s)
+{
+	list_del(&d2s->collision_resolving_node);
+}
+
+static struct btrfsic_dev2state *btrfsic_dev2state_hashtable_lookup(
+		struct block_device *bdev,
+		struct btrfsic_dev2state_hashtable *h)
+{
+	const unsigned int hashval =
+	    (((unsigned int) ((uintptr_t) bdev)) &
+	     (BTRFSIC_DEV2STATE_HASHTABLE_SIZE - 1));
+	struct list_head *elem;
+
+	list_for_each(elem, h->table + hashval) {
+		struct btrfsic_dev2state *const d2s =
+		    list_entry(elem, struct btrfsic_dev2state,
+			       collision_resolving_node);
+
+		if (d2s->bdev == bdev)
+			return d2s;
+	}
+
+	return NULL;
+}
+
+static int btrfsic_process_superblock(struct btrfsic_state *state,
+				      struct btrfs_fs_devices *fs_devices)
+{
+	int ret;
+	struct btrfs_super_block *selected_super;
+	struct list_head *dev_head = &fs_devices->devices;
+	struct btrfs_device *device;
+	int pass;
+
+	BUG_ON(NULL == state);
+	selected_super = kmalloc(sizeof(*selected_super), GFP_NOFS);
+	if (NULL == selected_super) {
+		printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
+		return -1;
+	}
+
+	list_for_each_entry(device, dev_head, dev_list) {
+		int i;
+
+		if (!device->bdev || !device->name)
+			continue;
+
+		for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+			ret = btrfsic_process_superblock_dev_mirror(
+					state, device, i, selected_super);
+			if (0 != ret && 0 == i) {
+				kfree(selected_super);
+				return ret;
+			}
+		}
+	}
+
+	if (NULL == state->latest_superblock) {
+		printk(KERN_INFO "btrfsic: no superblock found!\n");
+		kfree(selected_super);
+		return -1;
+	}
+
+	state->csum_size = btrfs_super_csum_size(selected_super);
+
+	for (pass = 0; pass < 3; pass++) {
+		int num_copies;
+		int mirror_num;
+		u64 next_bytenr;
+
+		switch (pass) {
+		case 0:
+			next_bytenr = btrfs_super_root(selected_super);
+			if (state->print_mask &
+			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
+				printk(KERN_INFO "root@%llu\n", next_bytenr);
+			break;
+		case 1:
+			next_bytenr = btrfs_super_chunk_root(selected_super);
+			if (state->print_mask &
+			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
+				printk(KERN_INFO "chunk@%llu\n", next_bytenr);
+			break;
+		case 2:
+			next_bytenr = btrfs_super_log_root(selected_super);
+			if (0 == next_bytenr)
+				continue;
+			if (state->print_mask &
+			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
+				printk(KERN_INFO "log@%llu\n", next_bytenr);
+			break;
+		}
+
+		num_copies =
+		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
+				     next_bytenr, PAGE_SIZE);
+		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
+			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
+			       next_bytenr, num_copies);
+
+		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
+			struct btrfsic_block *next_block;
+			struct btrfsic_block_data_ctx tmp_next_block_ctx;
+			struct btrfsic_block_link *l;
+			struct btrfs_header *hdr;
+
+			ret = btrfsic_map_block(state, next_bytenr, PAGE_SIZE,
+						&tmp_next_block_ctx,
+						mirror_num);
+			if (ret) {
+				printk(KERN_INFO "btrfsic:"
+				       " btrfsic_map_block(root @%llu,"
+				       " mirror %d) failed!\n",
+				       next_bytenr, mirror_num);
+				kfree(selected_super);
+				return -1;
+			}
+
+			next_block = btrfsic_block_hashtable_lookup(
+					tmp_next_block_ctx.bdev,
+					tmp_next_block_ctx.dev_bytenr,
+					&state->block_hashtable);
+			BUG_ON(NULL == next_block);
+
+			l = btrfsic_block_link_hashtable_lookup(
+					tmp_next_block_ctx.bdev,
+					tmp_next_block_ctx.dev_bytenr,
+					state->latest_superblock->bdev,
+					state->latest_superblock->dev_bytenr,
+					&state->block_link_hashtable);
+			BUG_ON(NULL == l);
+
+			ret = btrfsic_read_block(state, &tmp_next_block_ctx);
+			if (ret < BTRFSIC_BLOCK_SIZE) {
+				printk(KERN_INFO
+				       "btrfsic: read @logical %llu failed!\n",
+				       tmp_next_block_ctx.start);
+				btrfsic_release_block_ctx(&tmp_next_block_ctx);
+				kfree(selected_super);
+				return -1;
+			}
+
+			hdr = (struct btrfs_header *) tmp_next_block_ctx.data;
+			ret = btrfsic_process_metablock(state,
+							next_block,
+							&tmp_next_block_ctx,
+							hdr,
+							BTRFS_MAX_LEVEL + 3, 1);
+			btrfsic_release_block_ctx(&tmp_next_block_ctx);
+		}
+	}
+
+	kfree(selected_super);
+	return ret;
+}
+
+static int btrfsic_process_superblock_dev_mirror(
+		struct btrfsic_state *state,
+		struct btrfs_device *device,
+		int superblock_mirror_num,
+		struct btrfs_super_block *selected_super)
+{
+	struct btrfs_super_block *super_tmp;
+	u64 dev_bytenr;
+	struct buffer_head *bh;
+	struct btrfsic_block *superblock_tmp;
+	int pass;
+	struct block_device *const superblock_bdev = device->bdev;
+
+	/* super block bytenr is always the unmapped device bytenr */
+	dev_bytenr = btrfs_sb_offset(superblock_mirror_num);
+	bh = __bread(superblock_bdev, dev_bytenr / 4096, 4096);
+	if (NULL == bh)
+		return -1;
+	super_tmp = (struct btrfs_super_block *)
+	    (bh->b_data + (dev_bytenr & 4095));
+
+	if (btrfs_super_bytenr(super_tmp) != dev_bytenr ||
+	    strncmp((char *) (&(super_tmp->magic)), BTRFS_MAGIC,
+		    sizeof(super_tmp->magic)) ||
+	    memcmp(device->uuid, super_tmp->dev_item.uuid, BTRFS_UUID_SIZE)) {
+		brelse(bh);
+		return 0;
+	}
+
+	superblock_tmp =
+	    btrfsic_block_hashtable_lookup(superblock_bdev,
+					   dev_bytenr,
+					   &state->block_hashtable);
+	if (NULL == superblock_tmp) {
+		superblock_tmp = btrfsic_block_alloc();
+		if (NULL == superblock_tmp) {
+			printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
+			brelse(bh);
+			return -1;
+		}
+		/* for superblock, only the dev_bytenr makes sense */
+		superblock_tmp->bdev = superblock_bdev;
+		superblock_tmp->dev_bytenr = dev_bytenr;
+		superblock_tmp->logical_bytenr = dev_bytenr;
+		superblock_tmp->generation = btrfs_super_generation(super_tmp);
+		superblock_tmp->is_metadata = 1;
+		superblock_tmp->is_superblock = 1;
+		superblock_tmp->is_iodone = 1;
+		superblock_tmp->never_written = 0;
+		superblock_tmp->mirror_num = 1 + superblock_mirror_num;
+		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
+			printk(KERN_INFO "New initial S-block (bdev %p, %s)"
+			       " @%llu (%s/%llu/%d)\n",
+			       superblock_bdev, device->name, dev_bytenr,
+			       superblock_bdev->bd_disk->disk_name,
+			       dev_bytenr, superblock_mirror_num);
+		list_add(&superblock_tmp->all_blocks_node,
+			 &state->all_blocks_list);
+		btrfsic_block_hashtable_add(superblock_tmp,
+					    &state->block_hashtable);
+	}
+
+	/* select the one with the highest generation field */
+	if (btrfs_super_generation(super_tmp) >
+	    state->max_superblock_generation ||
+	    0 == state->max_superblock_generation) {
+		memcpy(selected_super, super_tmp, sizeof(*selected_super));
+		state->max_superblock_generation =
+		    btrfs_super_generation(super_tmp);
+		state->latest_superblock = superblock_tmp;
+	}
+
+	for (pass = 0; pass < 3; pass++) {
+		u64 next_bytenr;
+		int num_copies;
+		int mirror_num;
+		const char *additional_string = NULL;
+		struct btrfs_disk_key tmp_disk_key;
+
+		tmp_disk_key.type = BTRFS_ROOT_ITEM_KEY;
+		tmp_disk_key.offset = 0;
+		switch (pass) {
+		case 0:
+			tmp_disk_key.objectid =
+			    cpu_to_le64(BTRFS_ROOT_TREE_OBJECTID);
+			additional_string = "initial root ";
+			next_bytenr = btrfs_super_root(super_tmp);
+			break;
+		case 1:
+			tmp_disk_key.objectid =
+			    cpu_to_le64(BTRFS_CHUNK_TREE_OBJECTID);
+			additional_string = "initial chunk ";
+			next_bytenr = btrfs_super_chunk_root(super_tmp);
+			break;
+		case 2:
+			tmp_disk_key.objectid =
+			    cpu_to_le64(BTRFS_TREE_LOG_OBJECTID);
+			additional_string = "initial log ";
+			next_bytenr = btrfs_super_log_root(super_tmp);
+			if (0 == next_bytenr)
+				continue;
+			break;
+		}
+
+		num_copies =
+		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
+				     next_bytenr, PAGE_SIZE);
+		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
+			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
+			       next_bytenr, num_copies);
+		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
+			struct btrfsic_block *next_block;
+			struct btrfsic_block_data_ctx tmp_next_block_ctx;
+			struct btrfsic_block_link *l;
+
+			if (btrfsic_map_block(state, next_bytenr, PAGE_SIZE,
+					      &tmp_next_block_ctx,
+					      mirror_num)) {
+				printk(KERN_INFO "btrfsic: btrfsic_map_block("
+				       "bytenr @%llu, mirror %d) failed!\n",
+				       next_bytenr, mirror_num);
+				brelse(bh);
+				return -1;
+			}
+
+			next_block = btrfsic_block_lookup_or_add(
+					state, &tmp_next_block_ctx,
+					additional_string, 1, 1, 0,
+					mirror_num, NULL);
+			if (NULL == next_block) {
+				btrfsic_release_block_ctx(&tmp_next_block_ctx);
+				brelse(bh);
+				return -1;
+			}
+
+			next_block->disk_key = tmp_disk_key;
+			next_block->generation = BTRFSIC_GENERATION_UNKNOWN;
+			l = btrfsic_block_link_lookup_or_add(
+					state, &tmp_next_block_ctx,
+					next_block, superblock_tmp,
+					BTRFSIC_GENERATION_UNKNOWN);
+			btrfsic_release_block_ctx(&tmp_next_block_ctx);
+			if (NULL == l) {
+				brelse(bh);
+				return -1;
+			}
+		}
+	}
+	if (state->print_mask & BTRFSIC_PRINT_MASK_INITIAL_ALL_TREES)
+		btrfsic_dump_tree_sub(state, superblock_tmp, 0);
+
+	brelse(bh);
+	return 0;
+}
+
+static struct btrfsic_stack_frame *btrfsic_stack_frame_alloc(void)
+{
+	struct btrfsic_stack_frame *sf;
+
+	sf = kzalloc(sizeof(*sf), GFP_NOFS);
+	if (NULL == sf)
+		printk(KERN_INFO "btrfsic: alloc memory failed!\n");
+	else
+		sf->magic = BTRFSIC_BLOCK_STACK_FRAME_MAGIC_NUMBER;
+	return sf;
+}
+
+static void btrfsic_stack_frame_free(struct btrfsic_stack_frame *sf)
+{
+	BUG_ON(!(NULL == sf ||
+		 BTRFSIC_BLOCK_STACK_FRAME_MAGIC_NUMBER == sf->magic));
+	kfree(sf);
+}
+
+static int btrfsic_process_metablock(
+		struct btrfsic_state *state,
+		struct btrfsic_block *const first_block,
+		struct btrfsic_block_data_ctx *const first_block_ctx,
+		struct btrfs_header *const first_hdr,
+		int first_limit_nesting, int force_iodone_flag)
+{
+	struct btrfsic_stack_frame initial_stack_frame = { 0 };
+	struct btrfsic_stack_frame *sf;
+	struct btrfsic_stack_frame *next_stack;
+
+	sf = &initial_stack_frame;
+	sf->error = 0;
+	sf->i = -1;
+	sf->limit_nesting = first_limit_nesting;
+	sf->block = first_block;
+	sf->block_ctx = first_block_ctx;
+	sf->next_block = NULL;
+	sf->hdr = first_hdr;
+	sf->prev = NULL;
+
+ continue_with_new_stack_frame:
+	sf->block->generation = le64_to_cpu(sf->hdr->generation);
+	if (0 == sf->hdr->level) {
+		struct btrfs_leaf *const leafhdr =
+		    (struct btrfs_leaf *) sf->hdr;
+
+		if (-1 == sf->i) {
+			sf->nr = le32_to_cpu(leafhdr->header.nritems);
+
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+				printk(KERN_INFO
+				       "leaf %llu items %d generation %llu"
+				       " owner %llu\n",
+				       sf->block_ctx->start, sf->nr,
+				       le64_to_cpu(leafhdr->header.generation),
+				       le64_to_cpu(leafhdr->header.owner));
+		}
+
+ continue_with_current_leaf_stack_frame:
+		if (0 == sf->num_copies || sf->mirror_num > sf->num_copies) {
+			sf->i++;
+			sf->num_copies = 0;
+		}
+
+		if (sf->i < sf->nr) {
+			struct btrfs_item *disk_item = leafhdr->items + sf->i;
+			struct btrfs_disk_key *disk_key = &disk_item->key;
+			u8 type;
+			const u32 item_offset = le32_to_cpu(disk_item->offset);
+
+			type = disk_key->type;
+
+			if (BTRFS_ROOT_ITEM_KEY == type) {
+				const struct btrfs_root_item *const root_item =
+				    (struct btrfs_root_item *)
+				    (sf->block_ctx->data +
+				     offsetof(struct btrfs_leaf, items) +
+				     item_offset);
+				const u64 next_bytenr =
+				    le64_to_cpu(root_item->bytenr);
+
+				sf->error =
+				    btrfsic_create_link_to_next_block(
+						state,
+						sf->block,
+						sf->block_ctx,
+						next_bytenr,
+						sf->limit_nesting,
+						&sf->next_block_ctx,
+						&sf->next_block,
+						force_iodone_flag,
+						&sf->num_copies,
+						&sf->mirror_num,
+						disk_key,
+						le64_to_cpu(root_item->
+						generation));
+				if (sf->error)
+					goto one_stack_frame_backwards;
+
+				if (NULL != sf->next_block) {
+					struct btrfs_header *const next_hdr =
+					    (struct btrfs_header *)
+					    sf->next_block_ctx.data;
+
+					next_stack =
+					    btrfsic_stack_frame_alloc();
+					if (NULL == next_stack) {
+						btrfsic_release_block_ctx(
+								&sf->
+								next_block_ctx);
+						goto one_stack_frame_backwards;
+					}
+
+					next_stack->i = -1;
+					next_stack->block = sf->next_block;
+					next_stack->block_ctx =
+					    &sf->next_block_ctx;
+					next_stack->next_block = NULL;
+					next_stack->hdr = next_hdr;
+					next_stack->limit_nesting =
+					    sf->limit_nesting - 1;
+					next_stack->prev = sf;
+					sf = next_stack;
+					goto continue_with_new_stack_frame;
+				}
+			} else if (BTRFS_EXTENT_DATA_KEY == type &&
+				   state->include_extent_data) {
+				sf->error = btrfsic_handle_extent_data(
+						state,
+						sf->block,
+						sf->block_ctx,
+						item_offset,
+						force_iodone_flag);
+				if (sf->error)
+					goto one_stack_frame_backwards;
+			}
+
+			goto continue_with_current_leaf_stack_frame;
+		}
+	} else {
+		struct btrfs_node *const nodehdr =
+		    (struct btrfs_node *) sf->hdr;
+
+		if (-1 == sf->i) {
+			sf->nr = le32_to_cpu(nodehdr->header.nritems);
+
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+				printk(KERN_INFO "node %llu level %d items %d"
+				       " generation %llu owner %llu\n",
+				       sf->block_ctx->start,
+				       nodehdr->header.level, sf->nr,
+				       le64_to_cpu(nodehdr->header.generation),
+				       le64_to_cpu(nodehdr->header.owner));
+		}
+
+ continue_with_current_node_stack_frame:
+		if (0 == sf->num_copies || sf->mirror_num > sf->num_copies) {
+			sf->i++;
+			sf->num_copies = 0;
+		}
+
+		if (sf->i < sf->nr) {
+			struct btrfs_key_ptr *disk_key_ptr =
+			    nodehdr->ptrs + sf->i;
+			const u64 next_bytenr =
+			    le64_to_cpu(disk_key_ptr->blockptr);
+
+			sf->error = btrfsic_create_link_to_next_block(
+					state,
+					sf->block,
+					sf->block_ctx,
+					next_bytenr,
+					sf->limit_nesting,
+					&sf->next_block_ctx,
+					&sf->next_block,
+					force_iodone_flag,
+					&sf->num_copies,
+					&sf->mirror_num,
+					&disk_key_ptr->key,
+					le64_to_cpu(disk_key_ptr->generation));
+			if (sf->error)
+				goto one_stack_frame_backwards;
+
+			if (NULL != sf->next_block) {
+				struct btrfs_header *const next_hdr =
+				    (struct btrfs_header *)
+				    sf->next_block_ctx.data;
+
+				next_stack = btrfsic_stack_frame_alloc();
+				if (NULL == next_stack)
+					goto one_stack_frame_backwards;
+
+				next_stack->i = -1;
+				next_stack->block = sf->next_block;
+				next_stack->block_ctx = &sf->next_block_ctx;
+				next_stack->next_block = NULL;
+				next_stack->hdr = next_hdr;
+				next_stack->limit_nesting =
+				    sf->limit_nesting - 1;
+				next_stack->prev = sf;
+				sf = next_stack;
+				goto continue_with_new_stack_frame;
+			}
+
+			goto continue_with_current_node_stack_frame;
+		}
+	}
+
+ one_stack_frame_backwards:
+	if (NULL != sf->prev) {
+		struct btrfsic_stack_frame *const prev = sf->prev;
+
+		/* the one for the initial block is freed in the caller */
+		btrfsic_release_block_ctx(sf->block_ctx);
+
+		if (sf->error) {
+			prev->error = sf->error;
+			btrfsic_stack_frame_free(sf);
+			sf = prev;
+			goto one_stack_frame_backwards;
+		}
+
+		btrfsic_stack_frame_free(sf);
+		sf = prev;
+		goto continue_with_new_stack_frame;
+	} else
+		BUG_ON(&initial_stack_frame != sf);
+
+	return sf->error;
+}
+
+static int btrfsic_create_link_to_next_block(
+		struct btrfsic_state *state,
+		struct btrfsic_block *block,
+		struct btrfsic_block_data_ctx *block_ctx,
+		u64 next_bytenr,
+		int limit_nesting,
+		struct btrfsic_block_data_ctx *next_block_ctx,
+		struct btrfsic_block **next_blockp,
+		int force_iodone_flag,
+		int *num_copiesp, int *mirror_nump,
+		struct btrfs_disk_key *disk_key,
+		u64 parent_generation)
+{
+	struct btrfsic_block *next_block = NULL;
+	int ret;
+	struct btrfsic_block_link *l;
+	int did_alloc_block_link;
+	int block_was_created;
+
+	*next_blockp = NULL;
+	if (0 == *num_copiesp) {
+		*num_copiesp =
+		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
+				     next_bytenr, PAGE_SIZE);
+		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
+			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
+			       next_bytenr, *num_copiesp);
+		*mirror_nump = 1;
+	}
+
+	if (*mirror_nump > *num_copiesp)
+		return 0;
+
+	if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+		printk(KERN_INFO
+		       "btrfsic_create_link_to_next_block(mirror_num=%d)\n",
+		       *mirror_nump);
+	ret = btrfsic_map_block(state, next_bytenr,
+				BTRFSIC_BLOCK_SIZE,
+				next_block_ctx, *mirror_nump);
+	if (ret) {
+		printk(KERN_INFO
+		       "btrfsic: btrfsic_map_block(@%llu, mirror=%d) failed!\n",
+		       next_bytenr, *mirror_nump);
+		btrfsic_release_block_ctx(next_block_ctx);
+		*next_blockp = NULL;
+		return -1;
+	}
+
+	next_block = btrfsic_block_lookup_or_add(state,
+						 next_block_ctx, "referenced ",
+						 1, force_iodone_flag,
+						 !force_iodone_flag,
+						 *mirror_nump,
+						 &block_was_created);
+	if (NULL == next_block) {
+		btrfsic_release_block_ctx(next_block_ctx);
+		*next_blockp = NULL;
+		return -1;
+	}
+	if (block_was_created) {
+		l = NULL;
+		next_block->generation = BTRFSIC_GENERATION_UNKNOWN;
+	} else {
+		if (next_block->logical_bytenr != next_bytenr &&
+		    !(!next_block->is_metadata &&
+		      0 == next_block->logical_bytenr)) {
+			printk(KERN_INFO
+			       "Referenced block @%llu (%s/%llu/%d)"
+			       " found in hash table, %c,"
+			       " bytenr mismatch (!= stored %llu).\n",
+			       next_bytenr,
+			       next_block_ctx->bdev->bd_disk->disk_name,
+			       next_block_ctx->dev_bytenr, *mirror_nump,
+			       btrfsic_get_block_type(state, next_block),
+			       next_block->logical_bytenr);
+		} else if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			printk(KERN_INFO
+			       "Referenced block @%llu (%s/%llu/%d)"
+			       " found in hash table, %c.\n",
+			       next_bytenr,
+			       next_block_ctx->bdev->bd_disk->disk_name,
+			       next_block_ctx->dev_bytenr, *mirror_nump,
+			       btrfsic_get_block_type(state, next_block));
+		next_block->logical_bytenr = next_bytenr;
+
+		next_block->mirror_num = *mirror_nump;
+		l = btrfsic_block_link_hashtable_lookup(
+				next_block_ctx->bdev,
+				next_block_ctx->dev_bytenr,
+				block_ctx->bdev,
+				block_ctx->dev_bytenr,
+				&state->block_link_hashtable);
+	}
+
+	next_block->disk_key = *disk_key;
+	if (NULL == l) {
+		l = btrfsic_block_link_alloc();
+		if (NULL == l) {
+			printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
+			btrfsic_release_block_ctx(next_block_ctx);
+			*next_blockp = NULL;
+			return -1;
+		}
+
+		did_alloc_block_link = 1;
+		l->block_ref_to = next_block;
+		l->block_ref_from = block;
+		l->ref_cnt = 1;
+		l->parent_generation = parent_generation;
+
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			btrfsic_print_add_link(state, l);
+
+		list_add(&l->node_ref_to, &block->ref_to_list);
+		list_add(&l->node_ref_from, &next_block->ref_from_list);
+
+		btrfsic_block_link_hashtable_add(l,
+						 &state->block_link_hashtable);
+	} else {
+		did_alloc_block_link = 0;
+		if (0 == limit_nesting) {
+			l->ref_cnt++;
+			l->parent_generation = parent_generation;
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+				btrfsic_print_add_link(state, l);
+		}
+	}
+
+	if (limit_nesting > 0 && did_alloc_block_link) {
+		ret = btrfsic_read_block(state, next_block_ctx);
+		if (ret < BTRFSIC_BLOCK_SIZE) {
+			printk(KERN_INFO
+			       "btrfsic: read block @logical %llu failed!\n",
+			       next_bytenr);
+			btrfsic_release_block_ctx(next_block_ctx);
+			*next_blockp = NULL;
+			return -1;
+		}
+
+		*next_blockp = next_block;
+	} else {
+		*next_blockp = NULL;
+	}
+	(*mirror_nump)++;
+
+	return 0;
+}
+
+static int btrfsic_handle_extent_data(
+		struct btrfsic_state *state,
+		struct btrfsic_block *block,
+		struct btrfsic_block_data_ctx *block_ctx,
+		u32 item_offset, int force_iodone_flag)
+{
+	int ret;
+	struct btrfs_file_extent_item *file_extent_item =
+	    (struct btrfs_file_extent_item *) (block_ctx->data +
+					       offsetof(struct btrfs_leaf,
+							items) + item_offset);
+	u64 next_bytenr =
+	    le64_to_cpu(file_extent_item->disk_bytenr) +
+	    le64_to_cpu(file_extent_item->offset);
+	u64 num_bytes = le64_to_cpu(file_extent_item->num_bytes);
+	u64 generation = le64_to_cpu(file_extent_item->generation);
+	struct btrfsic_block_link *l;
+
+	if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
+		printk(KERN_INFO "extent_data: type %u, disk_bytenr = %llu,"
+		       " offset = %llu, num_bytes = %llu\n",
+		       file_extent_item->type,
+		       le64_to_cpu(file_extent_item->disk_bytenr),
+		       le64_to_cpu(file_extent_item->offset),
+		       le64_to_cpu(file_extent_item->num_bytes));
+	if (BTRFS_FILE_EXTENT_REG != file_extent_item->type ||
+	    ((u64) 0) == le64_to_cpu(file_extent_item->disk_bytenr))
+		return 0;
+	while (num_bytes > 0) {
+		u32 chunk_len;
+		int num_copies;
+		int mirror_num;
+
+		if (num_bytes > BTRFSIC_BLOCK_SIZE)
+			chunk_len = BTRFSIC_BLOCK_SIZE;
+		else
+			chunk_len = num_bytes;
+
+		num_copies =
+		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
+				     next_bytenr, PAGE_SIZE);
+		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
+			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
+			       next_bytenr, num_copies);
+		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
+			struct btrfsic_block_data_ctx next_block_ctx;
+			struct btrfsic_block *next_block;
+			int block_was_created;
+
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+				printk(KERN_INFO "btrfsic_handle_extent_data("
+				       "mirror_num=%d)\n", mirror_num);
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
+				printk(KERN_INFO
+				       "\tdisk_bytenr = %llu, num_bytes %u\n",
+				       next_bytenr, chunk_len);
+			ret = btrfsic_map_block(state, next_bytenr,
+						chunk_len, &next_block_ctx,
+						mirror_num);
+			if (ret) {
+				printk(KERN_INFO
+				       "btrfsic: btrfsic_map_block(@%llu,"
+				       " mirror=%d) failed!\n",
+				       next_bytenr, mirror_num);
+				return -1;
+			}
+
+			next_block = btrfsic_block_lookup_or_add(
+					state,
+					&next_block_ctx,
+					"referenced ",
+					0,
+					force_iodone_flag,
+					!force_iodone_flag,
+					mirror_num,
+					&block_was_created);
+			if (NULL == next_block) {
+				printk(KERN_INFO
+				       "btrfsic: error, kmalloc failed!\n");
+				btrfsic_release_block_ctx(&next_block_ctx);
+				return -1;
+			}
+			if (!block_was_created) {
+				if (next_block->logical_bytenr != next_bytenr &&
+				    !(!next_block->is_metadata &&
+				      0 == next_block->logical_bytenr)) {
+					printk(KERN_INFO
+					       "Referenced block"
+					       " @%llu (%s/%llu/%d)"
+					       " found in hash table, D,"
+					       " bytenr mismatch"
+					       " (!= stored %llu).\n",
+					       next_bytenr,
+					       next_block_ctx.bdev->
+					       bd_disk->disk_name,
+					       next_block_ctx.dev_bytenr,
+					       mirror_num,
+					       next_block->logical_bytenr);
+				}
+				next_block->logical_bytenr = next_bytenr;
+				next_block->mirror_num = mirror_num;
+			}
+
+			l = btrfsic_block_link_lookup_or_add(state,
+							     &next_block_ctx,
+							     next_block, block,
+							     generation);
+			btrfsic_release_block_ctx(&next_block_ctx);
+			if (NULL == l)
+				return -1;
+		}
+
+		next_bytenr += chunk_len;
+		num_bytes -= chunk_len;
+	}
+
+	return 0;
+}
+
+static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
+			     struct btrfsic_block_data_ctx *block_ctx_out,
+			     int mirror_num)
+{
+	int ret;
+	u64 length;
+	struct btrfs_bio *multi = NULL;
+	struct btrfs_device *device;
+
+	length = len;
+	ret = btrfs_map_block(&state->root->fs_info->mapping_tree, READ,
+			      bytenr, &length, &multi, mirror_num);
+
+	device = multi->stripes[0].dev;
+	block_ctx_out->bdev = device->bdev;
+	block_ctx_out->dev_bytenr = multi->stripes[0].physical;
+	block_ctx_out->start = bytenr;
+	block_ctx_out->len = len;
+	block_ctx_out->data = NULL;
+	block_ctx_out->bh = NULL;
+
+	if (0 == ret)
+		kfree(multi);
+
+	return ret;
+}
+
+static int btrfsic_map_superblock(struct btrfsic_state *state, u64 bytenr,
+				  u32 len, struct block_device *bdev,
+				  struct btrfsic_block_data_ctx *block_ctx_out)
+{
+	block_ctx_out->bdev = bdev;
+	block_ctx_out->dev_bytenr = bytenr;
+	block_ctx_out->start = bytenr;
+	block_ctx_out->len = len;
+	block_ctx_out->data = NULL;
+	block_ctx_out->bh = NULL;
+
+	return 0;
+}
+
+static void btrfsic_release_block_ctx(struct btrfsic_block_data_ctx *block_ctx)
+{
+	if (NULL != block_ctx->bh) {
+		brelse(block_ctx->bh);
+		block_ctx->bh = NULL;
+	}
+}
+
+static int btrfsic_read_block(struct btrfsic_state *state,
+			      struct btrfsic_block_data_ctx *block_ctx)
+{
+	block_ctx->bh = NULL;
+	if (block_ctx->dev_bytenr & 4095) {
+		printk(KERN_INFO
+		       "btrfsic: read_block() with unaligned bytenr %llu\n",
+		       block_ctx->dev_bytenr);
+		return -1;
+	}
+	if (block_ctx->len > 4096) {
+		printk(KERN_INFO
+		       "btrfsic: read_block() with too huge size %d\n",
+		       block_ctx->len);
+		return -1;
+	}
+
+	block_ctx->bh = __bread(block_ctx->bdev,
+				block_ctx->dev_bytenr >> 12, 4096);
+	if (NULL == block_ctx->bh)
+		return -1;
+	block_ctx->data = block_ctx->bh->b_data;
+
+	return block_ctx->len;
+}
+
+static void btrfsic_dump_database(struct btrfsic_state *state)
+{
+	struct list_head *elem_all;
+
+	BUG_ON(NULL == state);
+
+	printk(KERN_INFO "all_blocks_list:\n");
+	list_for_each(elem_all, &state->all_blocks_list) {
+		const struct btrfsic_block *const b_all =
+		    list_entry(elem_all, struct btrfsic_block,
+			       all_blocks_node);
+		struct list_head *elem_ref_to;
+		struct list_head *elem_ref_from;
+
+		printk(KERN_INFO "%c-block @%llu (%s/%llu/%d)\n",
+		       btrfsic_get_block_type(state, b_all),
+		       b_all->logical_bytenr,
+		       b_all->bdev->bd_disk->disk_name,
+		       b_all->dev_bytenr, b_all->mirror_num);
+
+		list_for_each(elem_ref_to, &b_all->ref_to_list) {
+			const struct btrfsic_block_link *const l =
+			    list_entry(elem_ref_to,
+				       struct btrfsic_block_link,
+				       node_ref_to);
+
+			printk(KERN_INFO " %c @%llu (%s/%llu/%d)"
+			       " refers %u* to"
+			       " %c @%llu (%s/%llu/%d)\n",
+			       btrfsic_get_block_type(state, b_all),
+			       b_all->logical_bytenr,
+			       b_all->bdev->bd_disk->disk_name,
+			       b_all->dev_bytenr,
+			       b_all->mirror_num,
+			       l->ref_cnt,
+			       btrfsic_get_block_type(state, l->block_ref_to),
+			       l->block_ref_to->logical_bytenr,
+			       l->block_ref_to->bdev->bd_disk->disk_name,
+			       l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->mirror_num);
+		}
+
+		list_for_each(elem_ref_from, &b_all->ref_from_list) {
+			const struct btrfsic_block_link *const l =
+			    list_entry(elem_ref_from,
+				       struct btrfsic_block_link,
+				       node_ref_from);
+
+			printk(KERN_INFO " %c @%llu (%s/%llu/%d)"
+			       " is ref %u* from"
+			       " %c @%llu (%s/%llu/%d)\n",
+			       btrfsic_get_block_type(state, b_all),
+			       b_all->logical_bytenr,
+			       b_all->bdev->bd_disk->disk_name,
+			       b_all->dev_bytenr,
+			       b_all->mirror_num,
+			       l->ref_cnt,
+			       btrfsic_get_block_type(state, l->block_ref_from),
+			       l->block_ref_from->logical_bytenr,
+			       l->block_ref_from->bdev->bd_disk->disk_name,
+			       l->block_ref_from->dev_bytenr,
+			       l->block_ref_from->mirror_num);
+		}
+
+		printk(KERN_INFO "\n");
+	}
+}
+
+/*
+ * Test whether the disk block contains a tree block (leaf or node)
+ * (note that this test fails for the super block)
+ */
+static int btrfsic_test_for_metadata(struct btrfsic_state *state,
+				     const u8 *data, unsigned int size)
+{
+	struct btrfs_header *h;
+	u8 csum[BTRFS_CSUM_SIZE];
+	u32 crc = ~(u32) 0;
+	int fail = 0;
+	int crc_fail = 0;
+
+	h = (struct btrfs_header *) data;
+
+	if (memcmp(h->fsid, state->root->fs_info->fsid, BTRFS_UUID_SIZE))
+		fail++;
+
+	crc = crc32c(crc, data + BTRFS_CSUM_SIZE, PAGE_SIZE - BTRFS_CSUM_SIZE);
+	btrfs_csum_final(crc, csum);
+	if (memcmp(csum, h->csum, state->csum_size))
+		crc_fail++;
+
+	return fail || crc_fail;
+}
+
+static void btrfsic_process_written_block(struct btrfsic_state *state,
+					  struct block_device *bdev,
+					  u64 dev_bytenr,
+					  u8 *mapped_data, unsigned int len,
+					  struct bio *bio,
+					  int *bio_is_patched,
+					  struct buffer_head *bh)
+{
+	int is_metadata;
+	struct btrfsic_block *block;
+	struct btrfsic_block_data_ctx block_ctx;
+	int ret;
+
+	WARN_ON(len > PAGE_SIZE);
+	is_metadata = (0 == btrfsic_test_for_metadata(state, mapped_data, len));
+	if (NULL != bio_is_patched)
+		*bio_is_patched = 0;
+
+	block = btrfsic_block_hashtable_lookup(bdev, dev_bytenr,
+					       &state->block_hashtable);
+	if (NULL != block) {
+		u64 bytenr;
+		struct list_head *elem_ref_to;
+		struct list_head *tmp_ref_to;
+
+		if (block->is_superblock) {
+			bytenr = le64_to_cpu(((struct btrfs_super_block *)
+					      mapped_data)->bytenr);
+			is_metadata = 1;
+			if (state->print_mask &
+			    BTRFSIC_PRINT_MASK_TREE_BEFORE_SB_WRITE) {
+				printk(KERN_INFO
+				       "[before new superblock is written]:\n");
+				btrfsic_dump_tree_sub(state, block, 0);
+			}
+		}
+		if (is_metadata) {
+			if (!block->is_superblock)
+				bytenr = le64_to_cpu(((struct btrfs_header *)
+						      mapped_data)->bytenr);
+			if (block->logical_bytenr != bytenr) {
+				printk(KERN_INFO
+				       "Written block @%llu (%s/%llu/%d)"
+				       " found in hash table, %c,"
+				       " bytenr mismatch"
+				       " (!= stored %llu).\n",
+				       bytenr,
+				       bdev->bd_disk->disk_name,
+				       dev_bytenr,
+				       block->mirror_num,
+				       btrfsic_get_block_type(state, block),
+				       block->logical_bytenr);
+				block->logical_bytenr = bytenr;
+			} else if (state->print_mask &
+				   BTRFSIC_PRINT_MASK_VERBOSE)
+				printk(KERN_INFO
+				       "Written block @%llu (%s/%llu/%d)"
+				       " found in hash table, %c.\n",
+				       bytenr,
+				       bdev->bd_disk->disk_name,
+				       dev_bytenr,
+				       block->mirror_num,
+				       btrfsic_get_block_type(state, block));
+		} else {
+			bytenr = block->logical_bytenr;
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+				printk(KERN_INFO
+				       "Written block @%llu (%s/%llu/%d)"
+				       " found in hash table, %c.\n",
+				       bytenr,
+				       bdev->bd_disk->disk_name,
+				       dev_bytenr,
+				       block->mirror_num,
+				       btrfsic_get_block_type(state, block));
+		}
+
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			printk(KERN_INFO
+			       "ref_to_list: %cE, ref_from_list: %cE\n",
+			       list_empty(&block->ref_to_list) ? ' ' : '!',
+			       list_empty(&block->ref_from_list) ? ' ' : '!');
+		if (btrfsic_is_block_ref_by_superblock(state, block, 0)) {
+			printk(KERN_INFO "btrfs: attempt to overwrite %c-block"
+			       " @%llu (%s/%llu/%d), old(gen=%llu,"
+			       " objectid=%llu, type=%d, offset=%llu),"
+			       " new(gen=%llu),"
+			       " which is referenced by most recent superblock"
+			       " (superblockgen=%llu)!\n",
+			       btrfsic_get_block_type(state, block),
+			       bytenr, bdev->bd_disk->disk_name,
+			       dev_bytenr, block->mirror_num,
+			       block->generation,
+			       le64_to_cpu(block->disk_key.objectid),
+			       block->disk_key.type,
+			       le64_to_cpu(block->disk_key.offset),
+			       le64_to_cpu(((struct btrfs_header *)
+					    mapped_data)->generation),
+			       state->max_superblock_generation);
+			btrfsic_dump_tree(state);
+		}
+
+		if (!block->is_iodone && !block->never_written) {
+			printk(KERN_INFO "btrfs: attempt to overwrite %c-block"
+			       " @%llu (%s/%llu/%d), oldgen=%llu, newgen=%llu,"
+			       " which is not yet iodone!\n",
+			       btrfsic_get_block_type(state, block),
+			       bytenr, bdev->bd_disk->disk_name,
+			       dev_bytenr, block->mirror_num,
+			       block->generation,
+			       le64_to_cpu(((struct btrfs_header *)
+					    mapped_data)->generation));
+			/* it would not be safe to go on */
+			btrfsic_dump_tree(state);
+			return;
+		}
+
+		/*
+		 * Clear all references of this block. Do not free
+		 * the block itself even if is not referenced anymore
+		 * because it still carries valueable information
+		 * like whether it was ever written and IO completed.
+		 */
+		list_for_each_safe(elem_ref_to, tmp_ref_to,
+				   &block->ref_to_list) {
+			struct btrfsic_block_link *const l =
+			    list_entry(elem_ref_to,
+				       struct btrfsic_block_link,
+				       node_ref_to);
+
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+				btrfsic_print_rem_link(state, l);
+			l->ref_cnt--;
+			if (0 == l->ref_cnt) {
+				list_del(&l->node_ref_to);
+				list_del(&l->node_ref_from);
+				btrfsic_block_link_hashtable_remove(l);
+				btrfsic_block_link_free(l);
+			}
+		}
+
+		if (block->is_superblock)
+			ret = btrfsic_map_superblock(state, bytenr, len,
+						     bdev, &block_ctx);
+		else
+			ret = btrfsic_map_block(state, bytenr, len,
+						&block_ctx, 0);
+		if (ret) {
+			printk(KERN_INFO
+			       "btrfsic: btrfsic_map_block(root @%llu)"
+			       " failed!\n", bytenr);
+			return;
+		}
+		block_ctx.data = mapped_data;
+		/* the following is required in case of writes to mirrors,
+		 * use the same that was used for the lookup */
+		block_ctx.bdev = bdev;
+		block_ctx.dev_bytenr = dev_bytenr;
+
+		if (is_metadata || state->include_extent_data) {
+			block->never_written = 0;
+			block->iodone_w_error = 0;
+			if (NULL != bio) {
+				block->is_iodone = 0;
+				BUG_ON(NULL == bio_is_patched);
+				if (!*bio_is_patched) {
+					block->orig_bio_bh_private =
+					    bio->bi_private;
+					block->orig_bio_bh_end_io.bio =
+					    bio->bi_end_io;
+					block->next_in_same_bio = NULL;
+					bio->bi_private = block;
+					bio->bi_end_io = btrfsic_bio_end_io;
+					*bio_is_patched = 1;
+				} else {
+					struct btrfsic_block *chained_block =
+					    (struct btrfsic_block *)
+					    bio->bi_private;
+
+					BUG_ON(NULL == chained_block);
+					block->orig_bio_bh_private =
+					    chained_block->orig_bio_bh_private;
+					block->orig_bio_bh_end_io.bio =
+					    chained_block->orig_bio_bh_end_io.
+					    bio;
+					block->next_in_same_bio = chained_block;
+					bio->bi_private = block;
+				}
+			} else if (NULL != bh) {
+				block->is_iodone = 0;
+				block->orig_bio_bh_private = bh->b_private;
+				block->orig_bio_bh_end_io.bh = bh->b_end_io;
+				block->next_in_same_bio = NULL;
+				bh->b_private = block;
+				bh->b_end_io = btrfsic_bh_end_io;
+			} else {
+				block->is_iodone = 1;
+				block->orig_bio_bh_private = NULL;
+				block->orig_bio_bh_end_io.bio = NULL;
+				block->next_in_same_bio = NULL;
+			}
+		}
+
+		if (is_metadata) {
+			block->logical_bytenr = bytenr;
+			block->is_metadata = 1;
+			if (block->is_superblock) {
+				ret = btrfsic_process_written_superblock(
+						state,
+						block,
+						(struct btrfs_super_block *)
+						mapped_data);
+				if (state->print_mask &
+				    BTRFSIC_PRINT_MASK_TREE_AFTER_SB_WRITE) {
+					printk(KERN_INFO
+					"[after new superblock is written]:\n");
+					btrfsic_dump_tree_sub(state, block, 0);
+				}
+			} else {
+				block->mirror_num = 0;	/* unknown */
+				ret = btrfsic_process_metablock(
+						state,
+						block,
+						&block_ctx,
+						(struct btrfs_header *)
+						block_ctx.data,
+						0, 0);
+			}
+			if (ret)
+				printk(KERN_INFO
+				       "btrfsic: btrfsic_process_metablock"
+				       "(root @%llu) failed!\n", dev_bytenr);
+		} else {
+			block->is_metadata = 0;
+			block->mirror_num = 0;	/* unknown */
+			block->generation = BTRFSIC_GENERATION_UNKNOWN;
+			if (!state->include_extent_data
+			    && list_empty(&block->ref_from_list)) {
+				/*
+				 * disk block is overwritten with extent
+				 * data (not meta data) and we are configured
+				 * to not include extent data: take the
+				 * chance and free the block's memory
+				 */
+				btrfsic_block_hashtable_remove(block);
+				list_del(&block->all_blocks_node);
+				btrfsic_block_free(block);
+			}
+		}
+		btrfsic_release_block_ctx(&block_ctx);
+	} else {
+		/* block has not been found in hash table */
+		u64 bytenr;
+
+		if (!is_metadata) {
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+				printk(KERN_INFO "Written block (%s/%llu/?)"
+				       " !found in hash table, D.\n",
+				       bdev->bd_disk->disk_name, dev_bytenr);
+			if (!state->include_extent_data)
+				return;	/* ignore that written D block */
+
+			/* this is getting ugly for the
+			 * include_extent_data case... */
+			bytenr = 0;	/* unknown */
+			block_ctx.start = bytenr;
+			block_ctx.len = len;
+			block_ctx.bh = NULL;
+		} else {
+			bytenr = le64_to_cpu(((struct btrfs_header *)
+					      mapped_data)->bytenr);
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+				printk(KERN_INFO
+				       "Written block @%llu (%s/%llu/?)"
+				       " !found in hash table, M.\n",
+				       bytenr, bdev->bd_disk->disk_name,
+				       dev_bytenr);
+
+			ret = btrfsic_map_block(state, bytenr, len, &block_ctx,
+						0);
+			if (ret) {
+				printk(KERN_INFO
+				       "btrfsic: btrfsic_map_block(root @%llu)"
+				       " failed!\n", dev_bytenr);
+				return;
+			}
+		}
+		block_ctx.data = mapped_data;
+		/* the following is required in case of writes to mirrors,
+		 * use the same that was used for the lookup */
+		block_ctx.bdev = bdev;
+		block_ctx.dev_bytenr = dev_bytenr;
+
+		block = btrfsic_block_alloc();
+		if (NULL == block) {
+			printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
+			btrfsic_release_block_ctx(&block_ctx);
+			return;
+		}
+		block->bdev = bdev;
+		block->dev_bytenr = dev_bytenr;
+		block->logical_bytenr = bytenr;
+		block->is_metadata = is_metadata;
+		block->never_written = 0;
+		block->iodone_w_error = 0;
+		block->mirror_num = 0;	/* unknown */
+		if (NULL != bio) {
+			block->is_iodone = 0;
+			BUG_ON(NULL == bio_is_patched);
+			if (!*bio_is_patched) {
+				block->orig_bio_bh_private = bio->bi_private;
+				block->orig_bio_bh_end_io.bio = bio->bi_end_io;
+				block->next_in_same_bio = NULL;
+				bio->bi_private = block;
+				bio->bi_end_io = btrfsic_bio_end_io;
+				*bio_is_patched = 1;
+			} else {
+				struct btrfsic_block *chained_block =
+				    (struct btrfsic_block *)
+				    bio->bi_private;
+
+				BUG_ON(NULL == chained_block);
+				block->orig_bio_bh_private =
+				    chained_block->orig_bio_bh_private;
+				block->orig_bio_bh_end_io.bio =
+				    chained_block->orig_bio_bh_end_io.bio;
+				block->next_in_same_bio = chained_block;
+				bio->bi_private = block;
+			}
+		} else if (NULL != bh) {
+			block->is_iodone = 0;
+			block->orig_bio_bh_private = bh->b_private;
+			block->orig_bio_bh_end_io.bh = bh->b_end_io;
+			block->next_in_same_bio = NULL;
+			bh->b_private = block;
+			bh->b_end_io = btrfsic_bh_end_io;
+		} else {
+			block->is_iodone = 1;
+			block->orig_bio_bh_private = NULL;
+			block->orig_bio_bh_end_io.bio = NULL;
+			block->next_in_same_bio = NULL;
+		}
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			printk(KERN_INFO
+			       "New written %c-block @%llu (%s/%llu/%d)\n",
+			       is_metadata ? 'M' : 'D',
+			       block->logical_bytenr,
+			       block->bdev->bd_disk->disk_name,
+			       block->dev_bytenr, block->mirror_num);
+		list_add(&block->all_blocks_node, &state->all_blocks_list);
+		btrfsic_block_hashtable_add(block, &state->block_hashtable);
+
+		if (is_metadata) {
+			ret = btrfsic_process_metablock(state, block,
+							&block_ctx,
+							(struct btrfs_header *)
+							block_ctx.data, 0, 0);
+			if (ret)
+				printk(KERN_INFO
+				       "btrfsic: process_metablock(root @%llu)"
+				       " failed!\n", dev_bytenr);
+		}
+		btrfsic_release_block_ctx(&block_ctx);
+	}
+}
+
+static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
+{
+	struct btrfsic_block *block = (struct btrfsic_block *) bp->bi_private;
+	int iodone_w_error;
+	const struct btrfsic_state *state;
+
+	/* mutex is not held! This is not save if IO is not yet completed
+	 * on umount */
+	state = btrfsic_dev2state_lookup(bp->bi_bdev);
+	iodone_w_error = 0;
+	if (bio_error_status)
+		iodone_w_error = 1;
+
+	BUG_ON(NULL == block);
+	bp->bi_private = block->orig_bio_bh_private;
+	bp->bi_end_io = block->orig_bio_bh_end_io.bio;
+
+	do {
+		/* this usually doesn't work because the completion is
+		 * called with a different bp->bi_bdev (that partition
+		 * table translation issue, I guess...), then state
+		 * is NULL and you won't get this printk */
+		if (state &&
+		    (state->print_mask & BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
+			printk(KERN_INFO
+			       "bio_end_io(err=%d) for %c @%llu (%s/%llu/%d)\n",
+			       bio_error_status,
+			       btrfsic_get_block_type(state, block),
+			       block->logical_bytenr,
+			       block->bdev->bd_disk->disk_name,
+			       block->dev_bytenr, block->mirror_num);
+		block->is_iodone = 1;
+		block->iodone_w_error = iodone_w_error;
+		block = block->next_in_same_bio;
+	} while (NULL != block);
+
+	bp->bi_end_io(bp, bio_error_status);
+}
+
+static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate)
+{
+	struct btrfsic_block *block = (struct btrfsic_block *) bh->b_private;
+	int iodone_w_error = !uptodate;
+	const struct btrfsic_state *state;
+
+	BUG_ON(NULL == block);
+	/* mutex is not held! This is not save if IO is not yet completed
+	 * on umount */
+	state = btrfsic_dev2state_lookup(block->bdev);
+	if (state && (state->print_mask & BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
+		printk(KERN_INFO
+		       "bh_end_io(error=%d) for %c @%llu (%s/%llu/%d)\n",
+		       iodone_w_error,
+		       btrfsic_get_block_type(state, block),
+		       block->logical_bytenr,
+		       block->bdev->bd_disk->disk_name,
+		       block->dev_bytenr, block->mirror_num);
+
+	block->is_iodone = 1;
+	block->iodone_w_error = iodone_w_error;
+
+	bh->b_private = block->orig_bio_bh_private;
+	bh->b_end_io = block->orig_bio_bh_end_io.bh;
+	bh->b_end_io(bh, uptodate);
+}
+
+static int btrfsic_process_written_superblock(
+		struct btrfsic_state *state,
+		struct btrfsic_block *const superblock,
+		struct btrfs_super_block *const super_hdr)
+{
+	int pass;
+
+	superblock->generation = btrfs_super_generation(super_hdr);
+	if (!(superblock->generation > state->max_superblock_generation ||
+	      0 == state->max_superblock_generation)) {
+		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
+			printk(KERN_INFO
+			       "btrfsic: superblock @%llu (%s/%llu/%d)"
+			       " with old gen %llu <= %llu\n",
+			       superblock->logical_bytenr,
+			       superblock->bdev->bd_disk->disk_name,
+			       superblock->dev_bytenr,
+			       superblock->mirror_num,
+			       btrfs_super_generation(super_hdr),
+			       state->max_superblock_generation);
+	} else {
+		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
+			printk(KERN_INFO
+			       "btrfsic: got new superblock @%llu (%s/%llu/%d)"
+			       " with new gen %llu > %llu\n",
+			       superblock->logical_bytenr,
+			       superblock->bdev->bd_disk->disk_name,
+			       superblock->dev_bytenr,
+			       superblock->mirror_num,
+			       btrfs_super_generation(super_hdr),
+			       state->max_superblock_generation);
+
+		state->max_superblock_generation =
+		    btrfs_super_generation(super_hdr);
+		state->latest_superblock = superblock;
+	}
+
+	for (pass = 0; pass < 3; pass++) {
+		int ret;
+		u64 next_bytenr;
+		struct btrfsic_block *next_block;
+		struct btrfsic_block_data_ctx tmp_next_block_ctx;
+		struct btrfsic_block_link *l;
+		int num_copies;
+		int mirror_num;
+		const char *additional_string = NULL;
+		struct btrfs_disk_key tmp_disk_key;
+
+		tmp_disk_key.type = BTRFS_ROOT_ITEM_KEY;
+		tmp_disk_key.offset = 0;
+
+		switch (pass) {
+		case 0:
+			tmp_disk_key.objectid =
+			    cpu_to_le64(BTRFS_ROOT_TREE_OBJECTID);
+			additional_string = "root ";
+			next_bytenr = btrfs_super_root(super_hdr);
+			if (state->print_mask &
+			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
+				printk(KERN_INFO "root@%llu\n", next_bytenr);
+			break;
+		case 1:
+			tmp_disk_key.objectid =
+			    cpu_to_le64(BTRFS_CHUNK_TREE_OBJECTID);
+			additional_string = "chunk ";
+			next_bytenr = btrfs_super_chunk_root(super_hdr);
+			if (state->print_mask &
+			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
+				printk(KERN_INFO "chunk@%llu\n", next_bytenr);
+			break;
+		case 2:
+			tmp_disk_key.objectid =
+			    cpu_to_le64(BTRFS_TREE_LOG_OBJECTID);
+			additional_string = "log ";
+			next_bytenr = btrfs_super_log_root(super_hdr);
+			if (0 == next_bytenr)
+				continue;
+			if (state->print_mask &
+			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
+				printk(KERN_INFO "log@%llu\n", next_bytenr);
+			break;
+		}
+
+		num_copies =
+		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
+				     next_bytenr, PAGE_SIZE);
+		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
+			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
+			       next_bytenr, num_copies);
+		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
+			int was_created;
+
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+				printk(KERN_INFO
+				       "btrfsic_process_written_superblock("
+				       "mirror_num=%d)\n", mirror_num);
+			ret = btrfsic_map_block(state, next_bytenr, PAGE_SIZE,
+						&tmp_next_block_ctx,
+						mirror_num);
+			if (ret) {
+				printk(KERN_INFO
+				       "btrfsic: btrfsic_map_block(@%llu,"
+				       " mirror=%d) failed!\n",
+				       next_bytenr, mirror_num);
+				return -1;
+			}
+
+			next_block = btrfsic_block_lookup_or_add(
+					state,
+					&tmp_next_block_ctx,
+					additional_string,
+					1, 0, 1,
+					mirror_num,
+					&was_created);
+			if (NULL == next_block) {
+				printk(KERN_INFO
+				       "btrfsic: error, kmalloc failed!\n");
+				btrfsic_release_block_ctx(&tmp_next_block_ctx);
+				return -1;
+			}
+
+			next_block->disk_key = tmp_disk_key;
+			if (was_created)
+				next_block->generation =
+				    BTRFSIC_GENERATION_UNKNOWN;
+			l = btrfsic_block_link_lookup_or_add(
+					state,
+					&tmp_next_block_ctx,
+					next_block,
+					superblock,
+					BTRFSIC_GENERATION_UNKNOWN);
+			btrfsic_release_block_ctx(&tmp_next_block_ctx);
+			if (NULL == l)
+				return -1;
+		}
+	}
+
+	if (-1 == btrfsic_check_all_ref_blocks(state, superblock, 0)) {
+		WARN_ON(1);
+		btrfsic_dump_tree(state);
+	}
+
+	return 0;
+}
+
+static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
+					struct btrfsic_block *const block,
+					int recursion_level)
+{
+	struct list_head *elem_ref_to;
+	int ret = 0;
+
+	if (recursion_level >= 3 + BTRFS_MAX_LEVEL) {
+		/*
+		 * Note that this situation can happen and does not
+		 * indicate an error in regular cases. It happens
+		 * when disk blocks are freed and later reused.
+		 * The check-integrity module is not aware of any
+		 * block free operations, it just recognizes block
+		 * write operations. Therefore it keeps the linkage
+		 * information for a block until a block is
+		 * rewritten. This can temporarily cause incorrect
+		 * and even circular linkage informations. This
+		 * causes no harm unless such blocks are referenced
+		 * by the most recent super block.
+		 */
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			printk(KERN_INFO
+			       "btrfsic: abort cyclic linkage (case 1).\n");
+
+		return ret;
+	}
+
+	/*
+	 * This algorithm is recursive because the amount of used stack
+	 * space is very small and the max recursion depth is limited.
+	 */
+	list_for_each(elem_ref_to, &block->ref_to_list) {
+		const struct btrfsic_block_link *const l =
+		    list_entry(elem_ref_to, struct btrfsic_block_link,
+			       node_ref_to);
+
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			printk(KERN_INFO
+			       "rl=%d, %c @%llu (%s/%llu/%d)"
+			       " %u* refers to %c @%llu (%s/%llu/%d)\n",
+			       recursion_level,
+			       btrfsic_get_block_type(state, block),
+			       block->logical_bytenr,
+			       block->bdev->bd_disk->disk_name,
+			       block->dev_bytenr,
+			       block->mirror_num,
+			       l->ref_cnt,
+			       btrfsic_get_block_type(state, l->block_ref_to),
+			       l->block_ref_to->logical_bytenr,
+			       l->block_ref_to->bdev->bd_disk->disk_name,
+			       l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->mirror_num);
+		if (l->block_ref_to->never_written) {
+			printk(KERN_INFO "btrfs: attempt to write superblock"
+			       " which references block %c @%llu (%s/%llu/%d)"
+			       " which is never written!\n",
+			       btrfsic_get_block_type(state, l->block_ref_to),
+			       l->block_ref_to->logical_bytenr,
+			       l->block_ref_to->bdev->bd_disk->disk_name,
+			       l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->mirror_num);
+			ret = -1;
+		} else if (!l->block_ref_to->is_iodone) {
+			printk(KERN_INFO "btrfs: attempt to write superblock"
+			       " which references block %c @%llu (%s/%llu/%d)"
+			       " which is not yet iodone!\n",
+			       btrfsic_get_block_type(state, l->block_ref_to),
+			       l->block_ref_to->logical_bytenr,
+			       l->block_ref_to->bdev->bd_disk->disk_name,
+			       l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->mirror_num);
+			ret = -1;
+		} else if (l->parent_generation !=
+			   l->block_ref_to->generation &&
+			   BTRFSIC_GENERATION_UNKNOWN !=
+			   l->parent_generation &&
+			   BTRFSIC_GENERATION_UNKNOWN !=
+			   l->block_ref_to->generation) {
+			printk(KERN_INFO "btrfs: attempt to write superblock"
+			       " which references block %c @%llu (%s/%llu/%d)"
+			       " with generation %llu !="
+			       " parent generation %llu!\n",
+			       btrfsic_get_block_type(state, l->block_ref_to),
+			       l->block_ref_to->logical_bytenr,
+			       l->block_ref_to->bdev->bd_disk->disk_name,
+			       l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->mirror_num,
+			       l->block_ref_to->generation,
+			       l->parent_generation);
+			ret = -1;
+		} else if (-1 == btrfsic_check_all_ref_blocks(state,
+							      l->block_ref_to,
+							      recursion_level +
+							      1)) {
+			ret = -1;
+		}
+	}
+
+	return ret;
+}
+
+static int btrfsic_is_block_ref_by_superblock(
+		const struct btrfsic_state *state,
+		const struct btrfsic_block *block,
+		int recursion_level)
+{
+	struct list_head *elem_ref_from;
+
+	if (recursion_level >= 3 + BTRFS_MAX_LEVEL) {
+		/* refer to comment at "abort cyclic linkage (case 1)" */
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			printk(KERN_INFO
+			       "btrfsic: abort cyclic linkage (case 2).\n");
+
+		return 0;
+	}
+
+	/*
+	 * This algorithm is recursive because the amount of used stack space
+	 * is very small and the max recursion depth is limited.
+	 */
+	list_for_each(elem_ref_from, &block->ref_from_list) {
+		const struct btrfsic_block_link *const l =
+		    list_entry(elem_ref_from, struct btrfsic_block_link,
+			       node_ref_from);
+
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			printk(KERN_INFO
+			       "rl=%d, %c @%llu (%s/%llu/%d)"
+			       " is ref %u* from %c @%llu (%s/%llu/%d)\n",
+			       recursion_level,
+			       btrfsic_get_block_type(state, block),
+			       block->logical_bytenr,
+			       block->bdev->bd_disk->disk_name,
+			       block->dev_bytenr,
+			       block->mirror_num,
+			       l->ref_cnt,
+			       btrfsic_get_block_type(state, l->block_ref_from),
+			       l->block_ref_from->logical_bytenr,
+			       l->block_ref_from->bdev->bd_disk->disk_name,
+			       l->block_ref_from->dev_bytenr,
+			       l->block_ref_from->mirror_num);
+		if (l->block_ref_from->is_superblock &&
+		    state->latest_superblock->dev_bytenr ==
+		    l->block_ref_from->dev_bytenr &&
+		    state->latest_superblock->bdev == l->block_ref_from->bdev)
+			return 1;
+		else if (btrfsic_is_block_ref_by_superblock(state,
+							    l->block_ref_from,
+							    recursion_level +
+							    1))
+			return 1;
+	}
+
+	return 0;
+}
+
+static void btrfsic_print_add_link(const struct btrfsic_state *state,
+				   const struct btrfsic_block_link *l)
+{
+	printk(KERN_INFO
+	       "Add %u* link from %c @%llu (%s/%llu/%d)"
+	       " to %c @%llu (%s/%llu/%d).\n",
+	       l->ref_cnt,
+	       btrfsic_get_block_type(state, l->block_ref_from),
+	       l->block_ref_from->logical_bytenr,
+	       l->block_ref_from->bdev->bd_disk->disk_name,
+	       l->block_ref_from->dev_bytenr,
+	       l->block_ref_from->mirror_num,
+	       btrfsic_get_block_type(state, l->block_ref_to),
+	       l->block_ref_to->logical_bytenr,
+	       l->block_ref_to->bdev->bd_disk->disk_name,
+	       l->block_ref_to->dev_bytenr, l->block_ref_to->mirror_num);
+}
+
+static void btrfsic_print_rem_link(const struct btrfsic_state *state,
+				   const struct btrfsic_block_link *l)
+{
+	printk(KERN_INFO
+	       "Rem %u* link from %c @%llu (%s/%llu/%d)"
+	       " to %c @%llu (%s/%llu/%d).\n",
+	       l->ref_cnt,
+	       btrfsic_get_block_type(state, l->block_ref_from),
+	       l->block_ref_from->logical_bytenr,
+	       l->block_ref_from->bdev->bd_disk->disk_name,
+	       l->block_ref_from->dev_bytenr,
+	       l->block_ref_from->mirror_num,
+	       btrfsic_get_block_type(state, l->block_ref_to),
+	       l->block_ref_to->logical_bytenr,
+	       l->block_ref_to->bdev->bd_disk->disk_name,
+	       l->block_ref_to->dev_bytenr, l->block_ref_to->mirror_num);
+}
+
+static char btrfsic_get_block_type(const struct btrfsic_state *state,
+				   const struct btrfsic_block *block)
+{
+	if (block->is_superblock &&
+	    state->latest_superblock->dev_bytenr == block->dev_bytenr &&
+	    state->latest_superblock->bdev == block->bdev)
+		return 'S';
+	else if (block->is_superblock)
+		return 's';
+	else if (block->is_metadata)
+		return 'M';
+	else
+		return 'D';
+}
+
+static void btrfsic_dump_tree(const struct btrfsic_state *state)
+{
+	btrfsic_dump_tree_sub(state, state->latest_superblock, 0);
+}
+
+static void btrfsic_dump_tree_sub(const struct btrfsic_state *state,
+				  const struct btrfsic_block *block,
+				  int indent_level)
+{
+	struct list_head *elem_ref_to;
+	int indent_add;
+	static char buf[80];
+	int cursor_position;
+
+	/*
+	 * This algorithm is recursive because the amount of used stack space
+	 * is very small and the max recursion depth is limited.
+	 */
+	indent_add = sprintf(buf, "%c-%llu(%s/%llu/%d)",
+			     btrfsic_get_block_type(state, block),
+			     block->logical_bytenr,
+			     block->bdev->bd_disk->disk_name,
+			     block->dev_bytenr, block->mirror_num);
+	if (indent_level + indent_add > BTRFSIC_TREE_DUMP_MAX_INDENT_LEVEL) {
+		printk("[...]\n");
+		return;
+	}
+	printk(buf);
+	indent_level += indent_add;
+	if (list_empty(&block->ref_to_list)) {
+		printk("\n");
+		return;
+	}
+	if (block->mirror_num > 1 &&
+	    !(state->print_mask & BTRFSIC_PRINT_MASK_TREE_WITH_ALL_MIRRORS)) {
+		printk(" [...]\n");
+		return;
+	}
+
+	cursor_position = indent_level;
+	list_for_each(elem_ref_to, &block->ref_to_list) {
+		const struct btrfsic_block_link *const l =
+		    list_entry(elem_ref_to, struct btrfsic_block_link,
+			       node_ref_to);
+
+		while (cursor_position < indent_level) {
+			printk(" ");
+			cursor_position++;
+		}
+		if (l->ref_cnt > 1)
+			indent_add = sprintf(buf, " %d*--> ", l->ref_cnt);
+		else
+			indent_add = sprintf(buf, " --> ");
+		if (indent_level + indent_add >
+		    BTRFSIC_TREE_DUMP_MAX_INDENT_LEVEL) {
+			printk("[...]\n");
+			cursor_position = 0;
+			continue;
+		}
+
+		printk(buf);
+
+		btrfsic_dump_tree_sub(state, l->block_ref_to,
+				      indent_level + indent_add);
+		cursor_position = 0;
+	}
+}
+
+static struct btrfsic_block_link *btrfsic_block_link_lookup_or_add(
+		struct btrfsic_state *state,
+		struct btrfsic_block_data_ctx *next_block_ctx,
+		struct btrfsic_block *next_block,
+		struct btrfsic_block *from_block,
+		u64 parent_generation)
+{
+	struct btrfsic_block_link *l;
+
+	l = btrfsic_block_link_hashtable_lookup(next_block_ctx->bdev,
+						next_block_ctx->dev_bytenr,
+						from_block->bdev,
+						from_block->dev_bytenr,
+						&state->block_link_hashtable);
+	if (NULL == l) {
+		l = btrfsic_block_link_alloc();
+		if (NULL == l) {
+			printk(KERN_INFO
+			       "btrfsic: error, kmalloc" " failed!\n");
+			return NULL;
+		}
+
+		l->block_ref_to = next_block;
+		l->block_ref_from = from_block;
+		l->ref_cnt = 1;
+		l->parent_generation = parent_generation;
+
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			btrfsic_print_add_link(state, l);
+
+		list_add(&l->node_ref_to, &from_block->ref_to_list);
+		list_add(&l->node_ref_from, &next_block->ref_from_list);
+
+		btrfsic_block_link_hashtable_add(l,
+						 &state->block_link_hashtable);
+	} else {
+		l->ref_cnt++;
+		l->parent_generation = parent_generation;
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			btrfsic_print_add_link(state, l);
+	}
+
+	return l;
+}
+
+static struct btrfsic_block *btrfsic_block_lookup_or_add(
+		struct btrfsic_state *state,
+		struct btrfsic_block_data_ctx *block_ctx,
+		const char *additional_string,
+		int is_metadata,
+		int is_iodone,
+		int never_written,
+		int mirror_num,
+		int *was_created)
+{
+	struct btrfsic_block *block;
+
+	block = btrfsic_block_hashtable_lookup(block_ctx->bdev,
+					       block_ctx->dev_bytenr,
+					       &state->block_hashtable);
+	if (NULL == block) {
+		block = btrfsic_block_alloc();
+		if (NULL == block) {
+			printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
+			return NULL;
+		}
+		block->bdev = block_ctx->bdev;
+		block->dev_bytenr = block_ctx->dev_bytenr;
+		block->logical_bytenr = block_ctx->start;
+		block->is_metadata = is_metadata;
+		block->is_iodone = is_iodone;
+		block->never_written = never_written;
+		block->mirror_num = mirror_num;
+		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+			printk(KERN_INFO
+			       "New %s%c-block @%llu (%s/%llu/%d)\n",
+			       additional_string,
+			       btrfsic_get_block_type(state, block),
+			       block->logical_bytenr,
+			       block->bdev->bd_disk->disk_name,
+			       block->dev_bytenr, mirror_num);
+		list_add(&block->all_blocks_node, &state->all_blocks_list);
+		btrfsic_block_hashtable_add(block, &state->block_hashtable);
+		if (NULL != was_created)
+			*was_created = 1;
+	} else {
+		if (NULL != was_created)
+			*was_created = 0;
+	}
+
+	return block;
+}
+
+static struct btrfsic_state *btrfsic_dev2state_lookup(struct block_device *bdev)
+{
+	struct btrfsic_dev2state *d2s;
+
+	d2s = btrfsic_dev2state_hashtable_lookup(bdev,
+						 &btrfsic_dev2state_hashtable);
+	if (NULL != d2s)
+		return d2s->state;
+	else
+		return NULL;
+}
+
+int btrfsic_submit_bh(int rw, struct buffer_head *bh)
+{
+	struct btrfsic_state *state;
+
+	if (!btrfsic_is_initialized)
+		return submit_bh(rw, bh);
+
+	mutex_lock(&btrfsic_mutex);
+	/* since btrfsic_submit_bh() might also be called before
+	 * btrfsic_mount(), this might return NULL */
+	state = btrfsic_dev2state_lookup(bh->b_bdev);
+
+	/* Only called to write the superblock (incl. FLUSH/FUA) */
+	if (NULL != state && (rw & WRITE) && bh->b_size > 0) {
+		u64 dev_bytenr;
+
+		dev_bytenr = 4096 * bh->b_blocknr;
+		if (state->print_mask & BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
+			printk(KERN_INFO
+			       "submit_bh(rw=0x%x, blocknr=%lu (bytenr %llu),"
+			       " size=%lu, data=%p, bdev=%p)\n",
+			       rw, bh->b_blocknr, dev_bytenr, bh->b_size,
+			       bh->b_data, bh->b_bdev);
+		btrfsic_process_written_block(state, bh->b_bdev, dev_bytenr,
+					      bh->b_data, bh->b_size, NULL,
+					      NULL, bh);
+	}
+	mutex_unlock(&btrfsic_mutex);
+	return submit_bh(rw, bh);
+}
+
+void btrfsic_submit_bio(int rw, struct bio *bio)
+{
+	struct btrfsic_state *state;
+
+	if (!btrfsic_is_initialized) {
+		submit_bio(rw, bio);
+		return;
+	}
+
+	mutex_lock(&btrfsic_mutex);
+	/* since btrfsic_submit_bio() is also called before
+	 * btrfsic_mount(), this might return NULL */
+	state = btrfsic_dev2state_lookup(bio->bi_bdev);
+	if (NULL != state && (rw & WRITE) && NULL != bio->bi_io_vec) {
+		unsigned int i;
+		u64 dev_bytenr;
+		int bio_is_patched;
+
+		dev_bytenr = 512 * bio->bi_sector;
+		bio_is_patched = 0;
+		if (state->print_mask & BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
+			printk(KERN_INFO
+			       "submit_bio(rw=0x%x, bi_vcnt=%u,"
+			       " bi_sector=%lu (bytenr %llu), bi_bdev=%p)\n",
+			       rw, bio->bi_vcnt, bio->bi_sector, dev_bytenr,
+			       bio->bi_bdev);
+
+		for (i = 0; i < bio->bi_vcnt; i++) {
+			u8 *mapped_data;
+
+			mapped_data = kmap(bio->bi_io_vec[i].bv_page);
+			if ((BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
+			     BTRFSIC_PRINT_MASK_VERBOSE) ==
+			    (state->print_mask &
+			     (BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
+			      BTRFSIC_PRINT_MASK_VERBOSE)))
+				printk(KERN_INFO
+				       "#%u: page=%p, mapped=%p, len=%u,"
+				       " offset=%u\n",
+				       i, bio->bi_io_vec[i].bv_page,
+				       mapped_data,
+				       bio->bi_io_vec[i].bv_len,
+				       bio->bi_io_vec[i].bv_offset);
+			btrfsic_process_written_block(state, bio->bi_bdev,
+						      dev_bytenr, mapped_data,
+						      bio->bi_io_vec[i].bv_len,
+						      bio, &bio_is_patched,
+						      NULL);
+			kunmap(bio->bi_io_vec[i].bv_page);
+			dev_bytenr += bio->bi_io_vec[i].bv_len;
+		}
+	}
+	mutex_unlock(&btrfsic_mutex);
+
+	submit_bio(rw, bio);
+}
+
+int btrfsic_mount(struct btrfs_root *root,
+		  struct btrfs_fs_devices *fs_devices,
+		  int including_extent_data, u32 print_mask)
+{
+	int ret;
+	struct btrfsic_state *state;
+	struct list_head *dev_head = &fs_devices->devices;
+	struct btrfs_device *device;
+
+	state = kzalloc(sizeof(*state), GFP_NOFS);
+	if (NULL == state) {
+		printk(KERN_INFO "btrfs check-integrity: kmalloc() failed!\n");
+		return -1;
+	}
+
+	if (!btrfsic_is_initialized) {
+		mutex_init(&btrfsic_mutex);
+		btrfsic_dev2state_hashtable_init(&btrfsic_dev2state_hashtable);
+		btrfsic_is_initialized = 1;
+	}
+	mutex_lock(&btrfsic_mutex);
+	state->root = root;
+	state->print_mask = print_mask;
+	state->include_extent_data = including_extent_data;
+	state->csum_size = 0;
+	INIT_LIST_HEAD(&state->all_blocks_list);
+	btrfsic_block_hashtable_init(&state->block_hashtable);
+	btrfsic_block_link_hashtable_init(&state->block_link_hashtable);
+	state->max_superblock_generation = 0;
+	state->latest_superblock = NULL;
+
+	list_for_each_entry(device, dev_head, dev_list) {
+		struct btrfsic_dev2state *d2s;
+
+		if (!device->bdev || !device->name)
+			continue;
+
+		d2s = btrfsic_dev2state_alloc();
+		if (NULL == d2s) {
+			printk(KERN_INFO
+			       "btrfs check-integrity: kmalloc() failed!\n");
+			mutex_unlock(&btrfsic_mutex);
+			return -1;
+		}
+		d2s->bdev = device->bdev;
+		d2s->state = state;
+		btrfsic_dev2state_hashtable_add(d2s,
+						&btrfsic_dev2state_hashtable);
+	}
+
+	ret = btrfsic_process_superblock(state, fs_devices);
+	if (0 != ret) {
+		mutex_unlock(&btrfsic_mutex);
+		btrfsic_unmount(root, fs_devices);
+		return ret;
+	}
+
+	if (state->print_mask & BTRFSIC_PRINT_MASK_INITIAL_DATABASE)
+		btrfsic_dump_database(state);
+	if (state->print_mask & BTRFSIC_PRINT_MASK_INITIAL_TREE)
+		btrfsic_dump_tree(state);
+
+	mutex_unlock(&btrfsic_mutex);
+	return 0;
+}
+
+void btrfsic_unmount(struct btrfs_root *root,
+		     struct btrfs_fs_devices *fs_devices)
+{
+	struct list_head *elem_all;
+	struct list_head *tmp_all;
+	struct btrfsic_state *state;
+	struct list_head *dev_head = &fs_devices->devices;
+	struct btrfs_device *device;
+
+	if (!btrfsic_is_initialized)
+		return;
+
+	mutex_lock(&btrfsic_mutex);
+
+	state = NULL;
+	list_for_each_entry(device, dev_head, dev_list) {
+		struct btrfsic_dev2state *d2s;
+
+		if (!device->bdev || !device->name)
+			continue;
+
+		d2s = btrfsic_dev2state_hashtable_lookup(
+				device->bdev,
+				&btrfsic_dev2state_hashtable);
+		if (NULL != d2s) {
+			state = d2s->state;
+			btrfsic_dev2state_hashtable_remove(d2s);
+			btrfsic_dev2state_free(d2s);
+		}
+	}
+
+	if (NULL == state) {
+		printk(KERN_INFO
+		       "btrfsic: error, cannot find state information"
+		       " on umount!\n");
+		mutex_unlock(&btrfsic_mutex);
+		return;
+	}
+
+	/*
+	 * Don't care about keeping the lists' state up to date,
+	 * just free all memory that was allocated dynamically.
+	 * Free the blocks and the block_links.
+	 */
+	list_for_each_safe(elem_all, tmp_all, &state->all_blocks_list) {
+		struct btrfsic_block *const b_all =
+		    list_entry(elem_all, struct btrfsic_block,
+			       all_blocks_node);
+		struct list_head *elem_ref_to;
+		struct list_head *tmp_ref_to;
+
+		list_for_each_safe(elem_ref_to, tmp_ref_to,
+				   &b_all->ref_to_list) {
+			struct btrfsic_block_link *const l =
+			    list_entry(elem_ref_to,
+				       struct btrfsic_block_link,
+				       node_ref_to);
+
+			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
+				btrfsic_print_rem_link(state, l);
+
+			l->ref_cnt--;
+			if (0 == l->ref_cnt)
+				btrfsic_block_link_free(l);
+		}
+
+		if (b_all->is_iodone)
+			btrfsic_block_free(b_all);
+		else
+			printk(KERN_INFO "btrfs: attempt to free %c-block"
+			       " @%llu (%s/%llu/%d) on umount which is"
+			       " not yet iodone!\n",
+			       btrfsic_get_block_type(state, b_all),
+			       b_all->logical_bytenr,
+			       b_all->bdev->bd_disk->disk_name,
+			       b_all->dev_bytenr, b_all->mirror_num);
+	}
+
+	mutex_unlock(&btrfsic_mutex);
+
+	kfree(state);
+}
diff --git a/fs/btrfs/check-integrity.h b/fs/btrfs/check-integrity.h
new file mode 100644
index 0000000..8b59175
--- /dev/null
+++ b/fs/btrfs/check-integrity.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) STRATO AG 2011.  All rights reserved.
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
+#if !defined(__BTRFS_CHECK_INTEGRITY__)
+#define __BTRFS_CHECK_INTEGRITY__
+
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+int btrfsic_submit_bh(int rw, struct buffer_head *bh);
+void btrfsic_submit_bio(int rw, struct bio *bio);
+#else
+#define btrfsic_submit_bh submit_bh
+#define btrfsic_submit_bio submit_bio
+#endif
+
+int btrfsic_mount(struct btrfs_root *root,
+		  struct btrfs_fs_devices *fs_devices,
+		  int including_extent_data, u32 print_mask);
+void btrfsic_unmount(struct btrfs_root *root,
+		     struct btrfs_fs_devices *fs_devices);
+
+#endif
-- 
1.7.3.4

