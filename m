From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Wed, 23 Mar 2011 09:27:45 +0800
Message-ID: <4D894C91.5040302@cn.fujitsu.com>
References: <4D8324DE.4010400@cn.fujitsu.com>	<20110322113310.50eaceb2.kitayama@cl.bb4u.ne.jp>	<4D8813A5.1040604@cn.fujitsu.com>	<20110322125051.222ccc5b.kitayama@cl.bb4u.ne.jp>	<4D8873EC.1040702@cn.fujitsu.com> <20110322223324.ff6ee42a.kitayama@cl.bb4u.ne.jp>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020806060701070704080009"
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110322223324.ff6ee42a.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020806060701070704080009
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

Hi, Kitayama-san

I'm sorry, I sent a intermediate version to you, The attached file is the correct one.

Thanks


On tue, 22 Mar 2011 22:33:24 +0900, Itaru Kitayama wrote:
> Hi Miao,
> 
> On Tue, 22 Mar 2011 18:03:24 +0800
> Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
>> The V5 patch is attached, could you test it for me? I have run Chris stress test, dbench benchmark
>> on my machine, it work well. I want to check if the above bug still exists or not.
>>
>> Thanks
>> Miao
> 
> Here's the boot log (The V5 patch is on top of the btrfs-unstable next-rc branch):
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
> IP: [<ffffffff81075c12>] __lock_acquire+0x98/0xda6
> PGD 7074c067 PUD 75b6d067 PMD 0 
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
> CPU 0 
> Modules linked in: mptspi mptscsih mptbase scsi_transport_spi
> 
> Pid: 1, comm: init Not tainted 2.6.36-xie+ #120 440BX Desktop Reference Platform/VMware Virtual Platform
> RIP: 0010:[<ffffffff81075c12>]  [<ffffffff81075c12>] __lock_acquire+0x98/0xda6
> RSP: 0018:ffff88007ceafb58  EFLAGS: 00010097
> RAX: 0000000000000046 RBX: ffff88007ceb0050 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000c8
> RBP: ffff88007ceafc18 R08: 0000000000000002 R09: 0000000000000000
> R10: 0000000000000000 R11: ffff88007ceafd48 R12: ffff88007ceb0050
> R13: 00000000000000c8 R14: 0000000000000002 R15: 0000000000000000
> FS:  00007f1fe74e7720(0000) GS:ffff880004e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000000000c8 CR3: 0000000070486000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process init (pid: 1, threadinfo ffff88007ceae000, task ffff88007ceb0050)
> Stack:
>  0000000000000002 0000000000000001 ffff88007ceafb78 ffffffff810bdd5d
> <0> ffff880000000000 ffffffff00000000 ffff88007ceafbc8 0000000000000046
> <0> ffff88007ceafba8 ffff88007ceb0050 ffffffff81067dcd 0000000000000001
> Call Trace:
>  [<ffffffff810bdd5d>] ? time_hardirqs_off+0x2e/0x36
>  [<ffffffff81067dcd>] ? local_clock+0x2a/0x3b
>  [<ffffffff8121294b>] ? btrfs_get_delayed_items+0x37/0xb6
>  [<ffffffff81076a3d>] lock_acquire+0x11d/0x143
>  [<ffffffff8121294b>] ? btrfs_get_delayed_items+0x37/0xb6
>  [<ffffffff8121294b>] ? btrfs_get_delayed_items+0x37/0xb6
>  [<ffffffff814c62b1>] __mutex_lock_common+0x5a/0x444
>  [<ffffffff8121294b>] ? btrfs_get_delayed_items+0x37/0xb6
>  [<ffffffff8110ba5f>] ? virt_to_head_page+0xe/0x31
>  [<ffffffff8110dbbc>] ? cache_alloc_debugcheck_after+0x176/0x1cd
>  [<ffffffff814c6750>] mutex_lock_nested+0x39/0x3e
>  [<ffffffff8121294b>] btrfs_get_delayed_items+0x37/0xb6
>  [<ffffffff811d7e01>] btrfs_real_readdir+0x170/0x52c
>  [<ffffffff8112b739>] ? vfs_readdir+0x56/0xb6
>  [<ffffffff8112b559>] ? filldir+0x0/0xd0
>  [<ffffffff810bdfc0>] ? trace_preempt_on+0x24/0x26
>  [<ffffffff814cb4e8>] ? sub_preempt_count+0xa3/0xb6
>  [<ffffffff814c6645>] ? __mutex_lock_common+0x3ee/0x444
>  [<ffffffff8112b739>] ? vfs_readdir+0x56/0xb6
>  [<ffffffff8111e435>] ? rcu_read_unlock+0x0/0x4b
>  [<ffffffff8112b559>] ? filldir+0x0/0xd0
>  [<ffffffff8112b559>] ? filldir+0x0/0xd0
>  [<ffffffff8112b75c>] vfs_readdir+0x79/0xb6
>  [<ffffffff8112b8e9>] sys_getdents+0x85/0xd8
>  [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b
> Code: 58 e2 8b 01 00 be b3 0a 00 00 0f 85 c4 0c 00 00 e9 4d 0c 00 00 83 fe 07 76 11 e8 7e 55 1f 00 48 c7 c7 55 85 78 81 e9 78 0c 00 00 <49> 8 
> RIP  [<ffffffff81075c12>] __lock_acquire+0x98/0xda6
>  RSP <ffff88007ceafb58>
> CR2: 00000000000000c8
> ---[ end trace 87f215b3568d553d ]---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--------------020806060701070704080009
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="0001-btrfs-implement-delayed-inode-items-operation-v5.patch"
Content-Disposition: attachment;
 filename*0="0001-btrfs-implement-delayed-inode-items-operation-v5.patch"

>From f97b0811b193914a90b6cc20d25492387a369464 Mon Sep 17 00:00:00 2001
From: Miao Xie <miaox@cn.fujitsu.com>
Date: Tue, 15 Feb 2011 16:20:15 +0800
Subject: [PATCH] btrfs: implement delayed inode items operation - v5

Changelog V4 -> V5:
- Fix the race on adding the delayed node to the inode, which is reported by
  Chris Mason, and fix advice is also from him.
- Fix deadlock between readdir() and memory fault, which is reported by
  Itaru Kitayama.

Changelog V3 -> V4:
- Fix nested lock, which is reported by Itaru Kitayama, by updating space cache
  inode in time.

Changelog V2 -> V3:
- Fix the race between the delayed worker and the task which does delayed items
  balance, which is reported by Tsutomu Itoh.
- Modify the patch address David Sterba's comment.
- Fix the bug of the cpu recursion spinlock, reported by Chris Mason

Changelog V1 -> V2:
- break up the global rb-tree, use a list to manage the delayed nodes,
  which is created for every directory and file, and used to manage the
  delayed directory name index items and the delayed inode item.
- introduce a worker to deal with the delayed nodes.

Compare with Ext3/4, the performance of file creation and deletion on btrfs
is very poor. the reason is that btrfs must do a lot of b+ tree insertions,
such as inode item, directory name item, directory name index and so on.

If we can do some delayed b+ tree insertion or deletion, we can improve the
performance, so we made this patch which implemented delayed directory name
index insertion/deletion and delayed inode update.

Implementation:
- introduce a delayed root object into the filesystem, that use two lists to
  manage the delayed nodes which are created for every file/directory.
  One is used to manage all the delayed nodes that have delayed items. And the
  other is used to manage the delayed nodes which is waiting to be dealt with
  by the work thread.
- Every delayed node has two rb-tree, one is used to manage the directory name
  index which is going to be inserted into b+ tree, and the other is used to
  manage the directory name index which is going to be deleted from b+ tree.
- introduce a worker to deal with the delayed operation. This worker is used
  to deal with the works of the delayed directory name index items insertion
  and deletion and the delayed inode update.
  When the delayed items is beyond the lower limit, we create works for some
  delayed nodes and insert them into the work queue of the worker, and then
  go back.
  When the delayed items is beyond the upper bound, we create works for all
  the delayed nodes that haven't been dealt with, and insert them into the work
  queue of the worker, and then wait for that the untreated items is below some
  threshold value.
- When we want to insert a directory name index into b+ tree, we just add the
  information into the delayed inserting rb-tree.
  And then we check the number of the delayed items and do delayed items
  balance. (The balance policy is above.)
- When we want to delete a directory name index from the b+ tree, we search it
  in the inserting rb-tree at first. If we look it up, just drop it. If not,
  add the key of it into the delayed deleting rb-tree.
  Similar to the delayed inserting rb-tree, we also check the number of the
  delayed items and do delayed items balance.
  (The same to inserting manipulation)
- When we want to update the metadata of some inode, we cached the data of the
  inode into the delayed node. the worker will flush it into the b+ tree after
  dealing with the delayed insertion and deletion.
- We will move the delayed node to the tail of the list after we access the
  delayed node, By this way, we can cache more delayed items and merge more
  inode updates.
- If we want to commit transaction, we will deal with all the delayed node.
- the delayed node will be freed when we free the btrfs inode.
- Before we log the inode items, we commit all the directory name index items
  and the delayed inode update.

I did a quick test by the benchmark tool[1] and found we can improve the
performance of file creation by ~15%, and file deletion by ~20%.

Before applying this patch:
Create files:
	Total files: 50000
	Total time: 1.096108
	Average time: 0.000022
Delete files:
	Total files: 50000
	Total time: 1.510403
	Average time: 0.000030

After applying this patch:
Create files:
	Total files: 50000
	Total time: 0.932899
	Average time: 0.000019
Delete files:
	Total files: 50000
	Total time: 1.215732
	Average time: 0.000024

[1] http://marc.info/?l=linux-btrfs&m=128212635122920&q=p3

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/Makefile        |    2 +-
 fs/btrfs/btrfs_inode.h   |    5 +
 fs/btrfs/ctree.c         |   14 +-
 fs/btrfs/ctree.h         |   24 +-
 fs/btrfs/delayed-inode.c | 1665 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/delayed-inode.h |  142 ++++
 fs/btrfs/dir-item.c      |   32 +-
 fs/btrfs/disk-io.c       |   49 ++-
 fs/btrfs/disk-io.h       |    1 +
 fs/btrfs/extent-tree.c   |   18 +-
 fs/btrfs/inode.c         |  113 +++-
 fs/btrfs/ioctl.c         |    2 +-
 fs/btrfs/super.c         |   10 +-
 fs/btrfs/transaction.c   |   43 ++-
 fs/btrfs/transaction.h   |    2 +
 fs/btrfs/tree-log.c      |    7 +
 16 files changed, 2040 insertions(+), 89 deletions(-)
 create mode 100644 fs/btrfs/delayed-inode.c
 create mode 100644 fs/btrfs/delayed-inode.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 31610ea..a8411c2 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -7,4 +7,4 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o lzo.o \
-	   compression.o delayed-ref.o relocation.o
+	   compression.o delayed-ref.o relocation.o delayed-inode.o
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ccc991c..ef3baa8 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -22,6 +22,7 @@
 #include "extent_map.h"
 #include "extent_io.h"
 #include "ordered-data.h"
+#include "delayed-inode.h"
 
 /* in memory btrfs inode */
 struct btrfs_inode {
@@ -159,9 +160,13 @@ struct btrfs_inode {
 	 */
 	unsigned force_compress:4;
 
+	struct btrfs_delayed_node *delayed_node;
+
 	struct inode vfs_inode;
 };
 
+extern unsigned char btrfs_filetype_table[];
+
 static inline struct btrfs_inode *BTRFS_I(struct inode *inode)
 {
 	return container_of(inode, struct btrfs_inode, vfs_inode);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b5baff0..6e3e4c3 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -38,11 +38,6 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *src_buf);
 static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int level, int slot);
-static int setup_items_for_insert(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, struct btrfs_path *path,
-			struct btrfs_key *cpu_key, u32 *data_size,
-			u32 total_data, u32 total_size, int nr);
-
 
 struct btrfs_path *btrfs_alloc_path(void)
 {
@@ -3688,11 +3683,10 @@ out:
  * to save stack depth by doing the bulk of the work in a function
  * that doesn't call btrfs_search_slot
  */
-static noinline_for_stack int
-setup_items_for_insert(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, struct btrfs_path *path,
-		      struct btrfs_key *cpu_key, u32 *data_size,
-		      u32 total_data, u32 total_size, int nr)
+int setup_items_for_insert(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root, struct btrfs_path *path,
+			   struct btrfs_key *cpu_key, u32 *data_size,
+			   u32 total_data, u32 total_size, int nr)
 {
 	struct btrfs_item *item;
 	int i;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 28188a7..bafca2e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -859,6 +859,7 @@ struct btrfs_block_group_cache {
 struct reloc_control;
 struct btrfs_device;
 struct btrfs_fs_devices;
+struct btrfs_delayed_root;
 struct btrfs_fs_info {
 	u8 fsid[BTRFS_FSID_SIZE];
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
@@ -885,7 +886,10 @@ struct btrfs_fs_info {
 	/* logical->physical extent mapping */
 	struct btrfs_mapping_tree mapping_tree;
 
-	/* block reservation for extent, checksum and root tree */
+	/*
+	 * block reservation for extent, checksum, root tree and
+	 * delayed dir index item
+	 */
 	struct btrfs_block_rsv global_block_rsv;
 	/* block reservation for delay allocation */
 	struct btrfs_block_rsv delalloc_block_rsv;
@@ -1012,6 +1016,7 @@ struct btrfs_fs_info {
 	 * for the sys_munmap function call path
 	 */
 	struct btrfs_workers fixup_workers;
+	struct btrfs_workers delayed_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
 	int thread_pool_size;
@@ -1069,6 +1074,8 @@ struct btrfs_fs_info {
 
 	/* filesystem state */
 	u64 fs_state;
+
+	struct btrfs_delayed_root *delayed_root;
 };
 
 /*
@@ -2086,6 +2093,13 @@ static inline bool btrfs_mixed_space_info(struct btrfs_space_info *space_info)
 }
 
 /* extent-tree.c */
+static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
+						 int num_items)
+{
+	return (root->leafsize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
+		3 * num_items;
+}
+
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, unsigned long count);
@@ -2277,6 +2291,8 @@ void btrfs_release_path(struct btrfs_root *root, struct btrfs_path *p);
 struct btrfs_path *btrfs_alloc_path(void);
 void btrfs_free_path(struct btrfs_path *p);
 void btrfs_set_path_blocking(struct btrfs_path *p);
+void btrfs_clear_path_blocking(struct btrfs_path *p,
+			       struct extent_buffer *held);
 void btrfs_unlock_up_safe(struct btrfs_path *p, int level);
 
 int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -2288,6 +2304,10 @@ static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
 	return btrfs_del_items(trans, root, path, path->slots[0], 1);
 }
 
+int setup_items_for_insert(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root, struct btrfs_path *path,
+			   struct btrfs_key *cpu_key, u32 *data_size,
+			   u32 total_data, u32 total_size, int nr);
 int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, void *data, u32 data_size);
 int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
@@ -2349,7 +2369,7 @@ int btrfs_set_root_node(struct btrfs_root_item *item,
 /* dir-item.c */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, const char *name,
-			  int name_len, u64 dir,
+			  int name_len, struct inode *dir,
 			  struct btrfs_key *location, u8 type, u64 index);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
new file mode 100644
index 0000000..3b1d3d0
--- /dev/null
+++ b/fs/btrfs/delayed-inode.c
@@ -0,0 +1,1665 @@
+/*
+ * Copyright (C) 2011 Fujitsu.  All rights reserved.
+ * Written by Miao Xie <miaox@cn.fujitsu.com>
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
+#include <linux/slab.h>
+#include "delayed-inode.h"
+#include "disk-io.h"
+#include "transaction.h"
+
+#define BTRFS_DELAYED_WRITEBACK		400
+#define BTRFS_DELAYED_BACKGROUND	100
+
+static struct kmem_cache *delayed_node_cache;
+
+int __init btrfs_delayed_inode_init(void)
+{
+	delayed_node_cache = kmem_cache_create("delayed_node",
+					sizeof(struct btrfs_delayed_node),
+					0,
+					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					NULL);
+	if (!delayed_node_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void btrfs_delayed_inode_exit(void)
+{
+	if (delayed_node_cache)
+		kmem_cache_destroy(delayed_node_cache);
+}
+
+static inline void btrfs_init_delayed_node(
+				struct btrfs_delayed_node *delayed_node,
+				u64 root_id, u64 inode_id)
+{
+	delayed_node->root_id = root_id;
+	delayed_node->inode_id = inode_id;
+	atomic_set(&delayed_node->refs, 0);
+	delayed_node->count = 0;
+	delayed_node->in_list = 0;
+	delayed_node->inode_dirty = 0;
+	delayed_node->ins_root = RB_ROOT;
+	delayed_node->del_root = RB_ROOT;
+	mutex_init(&delayed_node->mutex);
+	delayed_node->index_cnt = 0;
+	INIT_LIST_HEAD(&delayed_node->n_list);
+	INIT_LIST_HEAD(&delayed_node->p_list);
+	delayed_node->bytes_reserved = 0;
+	delayed_node->block_rsv = NULL;
+}
+
+static inline int btrfs_is_continuous_delayed_item(
+					struct btrfs_delayed_item *item1,
+					struct btrfs_delayed_item *item2)
+{
+	if (item1->key.type == BTRFS_DIR_INDEX_KEY &&
+	    item1->key.objectid == item2->key.objectid &&
+	    item1->key.type == item2->key.type &&
+	    item1->key.offset + 1 == item2->key.offset)
+		return 1;
+	return 0;
+}
+
+static inline struct btrfs_delayed_root *btrfs_get_delayed_root(
+							struct btrfs_root *root)
+{
+	return root->fs_info->delayed_root;
+}
+
+static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
+							struct inode *inode)
+{
+	struct btrfs_delayed_node *node;
+	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
+	struct btrfs_root *root = btrfs_inode->root;
+
+again:
+	node = ACCESS_ONCE(btrfs_inode->delayed_node);
+	if (node) {
+		if (atomic_inc_not_zero(&node->refs));	/* can be accessed */
+			return node;
+		printk("racing on node access!\n");
+	}
+
+	node = kmem_cache_alloc(delayed_node_cache, GFP_NOFS);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+	btrfs_init_delayed_node(node, root->objectid, inode->i_ino);
+
+	node->delayed_root = btrfs_get_delayed_root(root);
+	atomic_inc(&node->refs);	/* cached in the btrfs inode */
+	atomic_inc(&node->refs);	/* can be accessed */
+
+	if (cmpxchg(&BTRFS_I(inode)->delayed_node, NULL, node)) {
+		kmem_cache_free(delayed_node_cache, node);
+		printk("racing on new node insertion!\n");
+		goto again;
+	}
+
+	return node;
+}
+
+/*
+ * Call it when holding delayed_node->mutex
+ *
+ * If mod = 1, add this node into the prepared list.
+ */
+static void btrfs_queue_delayed_node(struct btrfs_delayed_root *root,
+				     struct btrfs_delayed_node *node,
+				     int mod)
+{
+	spin_lock(&root->lock);
+	if (node->in_list) {
+		if (!list_empty(&node->p_list))
+			list_move_tail(&node->p_list, &root->prepare_list);
+		else if (mod)
+			list_add_tail(&node->p_list, &root->prepare_list);
+	} else {
+		list_add_tail(&node->n_list, &root->node_list);
+		list_add_tail(&node->p_list, &root->prepare_list);
+		atomic_inc(&node->refs);	/* inserted into list */
+		root->nodes++;
+		node->in_list = 1;
+	}
+	spin_unlock(&root->lock);
+}
+
+/* Call it when holding delayed_node->mutex */
+static void btrfs_dequeue_delayed_node(struct btrfs_delayed_root *root,
+				       struct btrfs_delayed_node *node)
+{
+	spin_lock(&root->lock);
+	if (node->in_list) {
+		root->nodes--;
+		atomic_dec(&node->refs);	/* not in the list */
+		list_del_init(&node->n_list);
+		if (!list_empty(&node->p_list))
+			list_del_init(&node->p_list);
+		node->in_list = 0;
+	}
+	spin_unlock(&root->lock);
+}
+
+struct btrfs_delayed_node *btrfs_first_delayed_node(
+			struct btrfs_delayed_root *delayed_root)
+{
+	struct list_head *p;
+	struct btrfs_delayed_node *node = NULL;
+
+	spin_lock(&delayed_root->lock);
+	if (list_empty(&delayed_root->node_list))
+		goto out;
+
+	p = delayed_root->node_list.next;
+	node = list_entry(p, struct btrfs_delayed_node, n_list);
+	atomic_inc(&node->refs);
+out:
+	spin_unlock(&delayed_root->lock);
+
+	return node;
+}
+
+struct btrfs_delayed_node *btrfs_next_delayed_node(
+						struct btrfs_delayed_node *node)
+{
+	struct btrfs_delayed_root *delayed_root = node->delayed_root;
+	struct list_head *p;
+	struct btrfs_delayed_node *next = NULL;
+
+	spin_lock(&delayed_root->lock);
+	if (!node->in_list) {	/* not in the list */
+		if (list_empty(&delayed_root->node_list))
+			goto out;
+		p = delayed_root->node_list.next;
+	} else if (list_is_last(&node->n_list, &delayed_root->node_list))
+		goto out;
+	else
+		p = node->n_list.next;
+
+	next = list_entry(p, struct btrfs_delayed_node, n_list);
+	atomic_inc(&next->refs);
+out:
+	spin_unlock(&delayed_root->lock);
+
+	return next;
+}
+
+static void __btrfs_release_delayed_node(
+				struct btrfs_delayed_node *delayed_node,
+				int mod)
+{
+	struct btrfs_delayed_root *delayed_root;
+
+	if (!delayed_node)
+		return;
+
+	delayed_root = delayed_node->delayed_root;
+
+	mutex_lock(&delayed_node->mutex);
+	if (delayed_node->count)
+		btrfs_queue_delayed_node(delayed_root, delayed_node, mod);
+	else
+		btrfs_dequeue_delayed_node(delayed_root, delayed_node);
+	mutex_unlock(&delayed_node->mutex);
+
+	if (atomic_dec_and_test(&delayed_node->refs))
+		kmem_cache_free(delayed_node_cache, delayed_node);
+}
+
+static inline void btrfs_release_delayed_node(struct btrfs_delayed_node *node)
+{
+	__btrfs_release_delayed_node(node, 0);
+}
+
+struct btrfs_delayed_node *btrfs_first_prepared_delayed_node(
+					struct btrfs_delayed_root *delayed_root)
+{
+	struct list_head *p;
+	struct btrfs_delayed_node *node = NULL;
+
+	spin_lock(&delayed_root->lock);
+	if (list_empty(&delayed_root->prepare_list))
+		goto out;
+
+	p = delayed_root->prepare_list.next;
+	list_del_init(p);
+	node = list_entry(p, struct btrfs_delayed_node, p_list);
+	atomic_inc(&node->refs);
+out:
+	spin_unlock(&delayed_root->lock);
+
+	return node;
+}
+
+static inline void btrfs_release_prepared_delayed_node(
+					struct btrfs_delayed_node *node)
+{
+	__btrfs_release_delayed_node(node, 1);
+}
+
+struct btrfs_delayed_item *btrfs_alloc_delayed_item(u32 data_len)
+{
+	struct btrfs_delayed_item *item;
+	item = kmalloc(sizeof(*item) + data_len, GFP_NOFS);
+	if (item) {
+		item->data_len = data_len;
+		item->ins_or_del = 0;
+		item->bytes_reserved = 0;
+		item->block_rsv = NULL;
+		item->delayed_node = NULL;
+		atomic_set(&item->refs, 1);
+	}
+	return item;
+}
+
+/*
+ * __btrfs_lookup_delayed_item - look up the delayed item by key
+ * @delayed_node: pointer to the delayed node
+ * @key:	  the key to look up
+ * @prev:	  used to store the prev item if the right item isn't found
+ * @next:	  used to store the next item if the right item isn't found
+ *
+ * Note: if we don't find the right item, we will return the prev item and
+ * the next item.
+ */
+static struct btrfs_delayed_item *__btrfs_lookup_delayed_item(
+				struct rb_root *root,
+				struct btrfs_key *key,
+				struct btrfs_delayed_item **prev,
+				struct btrfs_delayed_item **next)
+{
+	struct rb_node *node, *prev_node = NULL;
+	struct btrfs_delayed_item *delayed_item = NULL;
+	int ret = 0;
+
+	node = root->rb_node;
+
+	while (node) {
+		delayed_item = rb_entry(node, struct btrfs_delayed_item,
+					rb_node);
+		prev_node = node;
+		ret = btrfs_comp_cpu_keys(&delayed_item->key, key);
+		if (ret < 0)
+			node = node->rb_right;
+		else if (ret > 0)
+			node = node->rb_left;
+		else
+			return delayed_item;
+	}
+
+	if (prev) {
+		if (!prev_node)
+			*prev = NULL;
+		else if (ret < 0)
+			*prev = delayed_item;
+		else if ((node = rb_prev(prev_node)) != NULL) {
+			*prev = rb_entry(node, struct btrfs_delayed_item,
+					 rb_node);
+		} else
+			*prev = NULL;
+	}
+
+	if (next) {
+		if (!prev_node)
+			*next = NULL;
+		else if (ret > 0)
+			*next = delayed_item;
+		else if ((node = rb_next(prev_node)) != NULL) {
+			*next = rb_entry(node, struct btrfs_delayed_item,
+					 rb_node);
+		} else
+			*next = NULL;
+	}
+	return NULL;
+}
+
+struct btrfs_delayed_item *__btrfs_lookup_delayed_insertion_item(
+					struct btrfs_delayed_node *delayed_node,
+					struct btrfs_key *key)
+{
+	struct btrfs_delayed_item *item;
+
+	item = __btrfs_lookup_delayed_item(&delayed_node->ins_root, key,
+					   NULL, NULL);
+	return item;
+}
+
+struct btrfs_delayed_item *__btrfs_lookup_delayed_deletion_item(
+					struct btrfs_delayed_node *delayed_node,
+					struct btrfs_key *key)
+{
+	struct btrfs_delayed_item *item;
+
+	item = __btrfs_lookup_delayed_item(&delayed_node->del_root, key,
+					   NULL, NULL);
+	return item;
+}
+
+struct btrfs_delayed_item *__btrfs_search_delayed_insertion_item(
+					struct btrfs_delayed_node *delayed_node,
+					struct btrfs_key *key)
+{
+	struct btrfs_delayed_item *item, *next;
+
+	item = __btrfs_lookup_delayed_item(&delayed_node->ins_root, key,
+					   NULL, &next);
+	if (!item)
+		item = next;
+
+	return item;
+}
+
+struct btrfs_delayed_item *__btrfs_search_delayed_deletion_item(
+					struct btrfs_delayed_node *delayed_node,
+					struct btrfs_key *key)
+{
+	struct btrfs_delayed_item *item, *next;
+
+	item = __btrfs_lookup_delayed_item(&delayed_node->del_root, key,
+					   NULL, &next);
+	if (!item)
+		item = next;
+
+	return item;
+}
+
+static int __btrfs_add_delayed_item(struct btrfs_delayed_node *delayed_node,
+				    struct btrfs_delayed_item *ins,
+				    int action)
+{
+	struct rb_node **p, *node;
+	struct rb_node *parent_node = NULL;
+	struct rb_root *root;
+	struct btrfs_delayed_item *item;
+	int cmp;
+
+	if (action == BTRFS_DELAYED_INSERTION_ITEM)
+		root = &delayed_node->ins_root;
+	else if (action == BTRFS_DELAYED_DELETION_ITEM)
+		root = &delayed_node->del_root;
+	else
+		BUG();
+	p = &root->rb_node;
+	node = &ins->rb_node;
+
+	while (*p) {
+		parent_node = *p;
+		item = rb_entry(parent_node, struct btrfs_delayed_item,
+				 rb_node);
+
+		cmp = btrfs_comp_cpu_keys(&item->key, &ins->key);
+		if (cmp < 0)
+			p = &(*p)->rb_right;
+		else if (cmp > 0)
+			p = &(*p)->rb_left;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(node, parent_node, p);
+	rb_insert_color(node, root);
+	ins->delayed_node = delayed_node;
+	ins->ins_or_del = action;
+
+	if (ins->key.type == BTRFS_DIR_INDEX_KEY &&
+	    action == BTRFS_DELAYED_INSERTION_ITEM &&
+	    ins->key.offset >= delayed_node->index_cnt)
+			delayed_node->index_cnt = ins->key.offset + 1;
+
+	delayed_node->count++;
+	atomic_inc(&delayed_node->delayed_root->items);
+	return 0;
+}
+
+static int __btrfs_add_delayed_insertion_item(struct btrfs_delayed_node *node,
+					      struct btrfs_delayed_item *item)
+{
+	return __btrfs_add_delayed_item(node, item,
+					BTRFS_DELAYED_INSERTION_ITEM);
+}
+
+static int __btrfs_add_delayed_deletion_item(struct btrfs_delayed_node *node,
+					     struct btrfs_delayed_item *item)
+{
+	return __btrfs_add_delayed_item(node, item,
+					BTRFS_DELAYED_DELETION_ITEM);
+}
+
+static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
+{
+	struct rb_root *root;
+	struct btrfs_delayed_root *delayed_root;
+
+	delayed_root = delayed_item->delayed_node->delayed_root;
+
+	BUG_ON(!delayed_root);
+	BUG_ON(delayed_item->ins_or_del != BTRFS_DELAYED_DELETION_ITEM &&
+	       delayed_item->ins_or_del != BTRFS_DELAYED_INSERTION_ITEM);
+
+	if (delayed_item->ins_or_del == BTRFS_DELAYED_INSERTION_ITEM)
+		root = &delayed_item->delayed_node->ins_root;
+	else
+		root = &delayed_item->delayed_node->del_root;
+
+	rb_erase(&delayed_item->rb_node, root);
+	delayed_item->delayed_node->count--;
+	atomic_dec(&delayed_root->items);
+	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND &&
+	    waitqueue_active(&delayed_root->wait))
+		wake_up(&delayed_root->wait);
+}
+
+static void btrfs_release_delayed_item(struct btrfs_delayed_item *item)
+{
+	if (item) {
+		__btrfs_remove_delayed_item(item);
+		if (atomic_dec_and_test(&item->refs))
+			kfree(item);
+	}
+}
+
+struct btrfs_delayed_item *__btrfs_first_delayed_insertion_item(
+					struct btrfs_delayed_node *delayed_node)
+{
+	struct rb_node *p;
+	struct btrfs_delayed_item *item = NULL;
+
+	p = rb_first(&delayed_node->ins_root);
+	if (p)
+		item = rb_entry(p, struct btrfs_delayed_item, rb_node);
+
+	return item;
+}
+
+struct btrfs_delayed_item *__btrfs_first_delayed_deletion_item(
+					struct btrfs_delayed_node *delayed_node)
+{
+	struct rb_node *p;
+	struct btrfs_delayed_item *item = NULL;
+
+	p = rb_first(&delayed_node->del_root);
+	if (p)
+		item = rb_entry(p, struct btrfs_delayed_item, rb_node);
+
+	return item;
+}
+
+struct btrfs_delayed_item *__btrfs_next_delayed_item(
+						struct btrfs_delayed_item *item)
+{
+	struct rb_node *p;
+	struct btrfs_delayed_item *next = NULL;
+
+	p = rb_next(&item->rb_node);
+	if (p)
+		next = rb_entry(p, struct btrfs_delayed_item, rb_node);
+
+	return next;
+}
+
+static inline struct btrfs_delayed_node *btrfs_get_delayed_node(
+							struct inode *inode)
+{
+	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
+	struct btrfs_delayed_node *delayed_node;
+
+	delayed_node = btrfs_inode->delayed_node;
+	if (delayed_node)
+		atomic_inc(&delayed_node->refs);
+
+	return delayed_node;
+}
+
+static inline struct btrfs_root *btrfs_get_fs_root(struct btrfs_root *root,
+						   u64 root_id)
+{
+	struct btrfs_key root_key;
+
+	if (root->objectid == root_id)
+		return root;
+
+	root_key.objectid = root_id;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root_key.offset = (u64)-1;
+	return btrfs_read_fs_root_no_name(root->fs_info, &root_key);
+}
+
+static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
+					       struct btrfs_root *root,
+					       struct btrfs_delayed_item *item)
+{
+	struct btrfs_block_rsv *src_rsv;
+	struct btrfs_block_rsv *dst_rsv;
+	u64 num_bytes;
+	int ret;
+
+	if (!trans->bytes_reserved)
+		return 0;
+
+	src_rsv = trans->block_rsv;
+	dst_rsv = &root->fs_info->global_block_rsv;
+
+	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
+	if (!ret) {
+		item->bytes_reserved = num_bytes;
+		item->block_rsv = dst_rsv;
+	}
+
+	return ret;
+}
+
+static void btrfs_delayed_item_release_metadata(struct btrfs_root *root,
+						struct btrfs_delayed_item *item)
+{
+	if (!item->bytes_reserved)
+		return;
+
+	btrfs_block_rsv_release(root, item->block_rsv,
+				item->bytes_reserved);
+}
+
+static int btrfs_delayed_inode_reserve_metadata(
+					struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
+					struct btrfs_delayed_node *node)
+{
+	struct btrfs_block_rsv *src_rsv;
+	struct btrfs_block_rsv *dst_rsv;
+	u64 num_bytes;
+	int ret;
+
+	if (!trans->bytes_reserved)
+		return 0;
+
+	src_rsv = trans->block_rsv;
+	dst_rsv = &root->fs_info->global_block_rsv;
+
+	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
+	if (!ret) {
+		node->bytes_reserved = num_bytes;
+		node->block_rsv = dst_rsv;
+	}
+
+	return ret;
+}
+
+static void btrfs_delayed_inode_release_metadata(struct btrfs_root *root,
+						struct btrfs_delayed_node *node)
+{
+	if (!node->bytes_reserved)
+		return;
+
+	btrfs_block_rsv_release(root, node->block_rsv,
+				node->bytes_reserved);
+	node->bytes_reserved = 0;
+}
+
+/*
+ * This helper will insert some continuous items into the same leaf according
+ * to the free space of the leaf.
+ */
+static int btrfs_batch_insert_items(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct btrfs_path *path,
+				struct btrfs_delayed_item *item)
+{
+	struct btrfs_delayed_item *curr, *next;
+	int free_space;
+	int total_data_size = 0, total_size = 0;
+	struct extent_buffer *leaf;
+	char *data_ptr;
+	struct btrfs_key *keys;
+	u32 *data_size;
+	struct list_head head;
+	int slot;
+	int nitems;
+	int i;
+	int ret = 0;
+
+	BUG_ON(!path->nodes[0]);
+
+	leaf = path->nodes[0];
+	free_space = btrfs_leaf_free_space(root, leaf);
+	INIT_LIST_HEAD(&head);
+
+	next = item;
+
+	/*
+	 * count the number of the continuous items that we can insert in batch
+	 */
+	while (total_size + next->data_len + sizeof(struct btrfs_item) <=
+	       free_space) {
+		total_data_size += next->data_len;
+		total_size += next->data_len + sizeof(struct btrfs_item);
+		list_add_tail(&next->tree_list, &head);
+		nitems++;
+
+		curr = next;
+		next = __btrfs_next_delayed_item(curr);
+		if (!next)
+			break;
+
+		if (!btrfs_is_continuous_delayed_item(curr, next))
+			break;
+	}
+
+	if (!nitems) {
+		ret = 0;
+		goto out;
+	}
+
+	/*
+	 * we need allocate some memory space, but it might cause the task
+	 * to sleep, so we set all locked nodes in the path to blocking locks
+	 * first.
+	 */
+	btrfs_set_path_blocking(path);
+
+	keys = kmalloc(sizeof(struct btrfs_key) * nitems, GFP_NOFS);
+	if (!keys) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	data_size = kmalloc(sizeof(u32) * nitems, GFP_NOFS);
+	if (!data_size) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	/* get keys of all the delayed items */
+	i = 0;
+	list_for_each_entry(next, &head, tree_list) {
+		keys[i] = next->key;
+		data_size[i] = next->data_len;
+		i++;
+	}
+
+	/* reset all the locked nodes in the patch to spinning locks. */
+	btrfs_clear_path_blocking(path, NULL);
+
+	/* insert the keys of the items */
+	ret = setup_items_for_insert(trans, root, path, keys, data_size,
+				     total_data_size, total_size, nitems);
+	if (ret)
+		goto error;
+
+	/* insert the dir index items */
+	slot = path->slots[0];
+	list_for_each_entry_safe(curr, next, &head, tree_list) {
+		data_ptr = btrfs_item_ptr(leaf, slot, char);
+		write_extent_buffer(leaf, &curr->data,
+				    (unsigned long)data_ptr,
+				    curr->data_len);
+		slot++;
+
+		btrfs_delayed_item_release_metadata(root, curr);
+
+		list_del(&curr->tree_list);
+		btrfs_release_delayed_item(curr);
+	}
+
+error:
+	kfree(data_size);
+	kfree(keys);
+out:
+	return ret;
+}
+
+/*
+ * This helper can just do simple insertion that needn't extend item for new
+ * data, such as directory name index insertion, inode insertion.
+ */
+static int btrfs_insert_delayed_item(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     struct btrfs_path *path,
+				     struct btrfs_delayed_item *delayed_item)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_item *item;
+	char *ptr;
+	int ret;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &delayed_item->key,
+				      delayed_item->data_len);
+	if (ret < 0 && ret != -EEXIST)
+		return ret;
+
+	leaf = path->nodes[0];
+
+	item = btrfs_item_nr(leaf, path->slots[0]);
+	ptr = btrfs_item_ptr(leaf, path->slots[0], char);
+
+	write_extent_buffer(leaf, delayed_item->data, (unsigned long)ptr,
+			    delayed_item->data_len);
+	btrfs_mark_buffer_dirty(leaf);
+
+	btrfs_delayed_item_release_metadata(root, delayed_item);
+	return 0;
+}
+
+/*
+ * we insert an item first, then if there are some continuous items, we try
+ * to insert those items into the same leaf.
+ */
+static int btrfs_insert_delayed_items(struct btrfs_trans_handle *trans,
+				      struct btrfs_path *path,
+				      struct btrfs_root *root,
+				      struct btrfs_delayed_node *node)
+{
+	struct btrfs_delayed_item *curr, *prev;
+	int ret = 0;
+
+do_again:
+	mutex_lock(&node->mutex);
+	curr = __btrfs_first_delayed_insertion_item(node);
+	if (!curr)
+		goto insert_end;
+
+	ret = btrfs_insert_delayed_item(trans, root, path, curr);
+	if (ret < 0) {
+		btrfs_release_path(root, path);
+		goto insert_end;
+	}
+
+	prev = curr;
+	curr = __btrfs_next_delayed_item(prev);
+	if (curr && btrfs_is_continuous_delayed_item(prev, curr)) {
+		/* insert the continuous items into the same leaf */
+		path->slots[0]++;
+		btrfs_batch_insert_items(trans, root, path, curr);
+	}
+	btrfs_release_delayed_item(prev);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+	btrfs_release_path(root, path);
+	mutex_unlock(&node->mutex);
+	goto do_again;
+
+insert_end:
+	mutex_unlock(&node->mutex);
+	return ret;
+}
+
+static int btrfs_batch_delete_items(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct btrfs_path *path,
+				    struct btrfs_delayed_item *item)
+{
+	struct btrfs_delayed_item *curr, *next;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	struct list_head head;
+	int nitems, i, last_item;
+	int ret = 0;
+
+	BUG_ON(!path->nodes[0]);
+
+	leaf = path->nodes[0];
+
+	i = path->slots[0];
+	last_item = btrfs_header_nritems(leaf) - 1;
+	if (i > last_item)
+		return -ENOENT;	/* FIXME: Is errno suitable? */
+
+	next = item;
+	INIT_LIST_HEAD(&head);
+	btrfs_item_key_to_cpu(leaf, &key, i);
+	nitems = 0;
+	/*
+	 * count the number of the dir index items that we can delete in batch
+	 */
+	while (btrfs_comp_cpu_keys(&next->key, &key) == 0) {
+		list_add_tail(&next->tree_list, &head);
+		nitems++;
+
+		curr = next;
+		next = __btrfs_next_delayed_item(curr);
+		if (!next)
+			break;
+
+		if (!btrfs_is_continuous_delayed_item(curr, next))
+			break;
+
+		i++;
+		if (i > last_item)
+			break;
+		btrfs_item_key_to_cpu(leaf, &key, i);
+	}
+
+	if (!nitems)
+		return 0;
+
+	ret = btrfs_del_items(trans, root, path, path->slots[0], nitems);
+	if (ret)
+		goto out;
+
+	list_for_each_entry_safe(curr, next, &head, tree_list) {
+		btrfs_delayed_item_release_metadata(root, curr);
+		list_del(&curr->tree_list);
+		btrfs_release_delayed_item(curr);
+	}
+
+out:
+	return ret;
+}
+
+static int btrfs_delete_delayed_items(struct btrfs_trans_handle *trans,
+				      struct btrfs_path *path,
+				      struct btrfs_root *root,
+				      struct btrfs_delayed_node *node)
+{
+	struct btrfs_delayed_item *curr, *prev;
+	int ret = 0;
+
+do_again:
+	mutex_lock(&node->mutex);
+	curr = __btrfs_first_delayed_deletion_item(node);
+	if (!curr)
+		goto delete_fail;
+
+	ret = btrfs_search_slot(trans, root, &curr->key, path, -1, 1);
+	if (ret < 0)
+		goto delete_fail;
+	else if (ret > 0) {
+		/*
+		 * can't find the item which the node points to, so this node
+		 * is invalid, just drop it.
+		 */
+		prev = curr;
+		curr = __btrfs_next_delayed_item(prev);
+		btrfs_release_delayed_item(prev);
+		ret = 0;
+		btrfs_release_path(root, path);
+		if (curr)
+			goto do_again;
+		else
+			goto delete_fail;
+	}
+
+	btrfs_batch_delete_items(trans, root, path, curr);
+	btrfs_release_path(root, path);
+	mutex_unlock(&node->mutex);
+	goto do_again;
+
+delete_fail:
+	btrfs_release_path(root, path);
+	mutex_unlock(&node->mutex);
+	return ret;
+}
+
+static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
+{
+	if (delayed_node && delayed_node->inode_dirty) {
+		BUG_ON(!delayed_node->delayed_root);
+		delayed_node->inode_dirty = 0;
+		delayed_node->count--;
+		atomic_dec(&delayed_node->delayed_root->items);
+		if (atomic_read(&delayed_node->delayed_root->items) <
+		    BTRFS_DELAYED_BACKGROUND &&
+		    waitqueue_active(&delayed_node->delayed_root->wait))
+			wake_up(&delayed_node->delayed_root->wait);
+	}
+}
+
+static int btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct btrfs_path *path,
+				      struct btrfs_delayed_node *node)
+{
+	struct btrfs_key key;
+	struct btrfs_inode_item *inode_item;
+	struct extent_buffer *leaf;
+	int ret;
+
+	mutex_lock(&node->mutex);
+	if (!node->inode_dirty) {
+		mutex_unlock(&node->mutex);
+		return 0;
+	}
+
+	key.objectid = node->inode_id;
+	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
+	key.offset = 0;
+	ret = btrfs_lookup_inode(trans, root, path, &key, 1);
+	if (ret > 0) {
+		btrfs_release_path(root, path);
+		mutex_unlock(&node->mutex);
+		return -ENOENT;
+	} else if (ret < 0) {
+		mutex_unlock(&node->mutex);
+		return ret;
+	}
+
+	btrfs_unlock_up_safe(path, 1);
+	leaf = path->nodes[0];
+	inode_item = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_inode_item);
+	write_extent_buffer(leaf, &node->inode_item, (unsigned long)inode_item,
+			    sizeof(struct btrfs_inode_item));
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(root, path);
+
+	btrfs_delayed_inode_release_metadata(root, node);
+	btrfs_release_delayed_inode(node);
+	mutex_unlock(&node->mutex);
+
+	return 0;
+}
+
+/* Called when committing the transaction. */
+int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root)
+{
+	struct btrfs_delayed_root *delayed_root;
+	struct btrfs_delayed_node *curr_node, *prev_node;
+	struct btrfs_path *path;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->leave_spinning = 1;
+
+	delayed_root = btrfs_get_delayed_root(root);
+
+	curr_node = btrfs_first_delayed_node(delayed_root);
+	while (curr_node) {
+		/*
+		 * check root, if root is not the one which the delayed item
+		 * wants to be inserted to, we get the right root.
+		 */
+		if (root->objectid != curr_node->root_id) {
+			root = btrfs_get_fs_root(root, curr_node->root_id);
+			BUG_ON(IS_ERR_OR_NULL(root));
+		}
+
+		ret = btrfs_insert_delayed_items(trans, path, root,
+						 curr_node);
+		if (!ret)
+			ret = btrfs_delete_delayed_items(trans, path, root,
+							 curr_node);
+		if (!ret)
+			ret = btrfs_update_delayed_inode(trans, root, path,
+							 curr_node);
+		if (ret) {
+			btrfs_release_delayed_node(curr_node);
+			break;
+		}
+
+		prev_node = curr_node;
+		curr_node = btrfs_next_delayed_node(curr_node);
+		btrfs_release_delayed_node(prev_node);
+	}
+
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
+					      struct btrfs_root *root,
+					      struct btrfs_delayed_node *node)
+{
+	struct btrfs_path *path;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->leave_spinning = 1;
+
+	ret = btrfs_insert_delayed_items(trans, path, root, node);
+	if (!ret)
+		ret = btrfs_delete_delayed_items(trans, path, root, node);
+	if (!ret)
+		ret = btrfs_update_delayed_inode(trans, root, path, node);
+	btrfs_free_path(path);
+
+	return ret;
+}
+
+int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     struct inode *inode)
+{
+	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
+	int ret;
+
+	if (!delayed_node)
+		return 0;
+
+	mutex_lock(&delayed_node->mutex);
+	if (!delayed_node->count) {
+		mutex_unlock(&delayed_node->mutex);
+		btrfs_release_delayed_node(delayed_node);
+		return 0;
+	}
+	mutex_unlock(&delayed_node->mutex);
+
+	ret = __btrfs_commit_inode_delayed_items(trans, root, delayed_node);
+	btrfs_release_delayed_node(delayed_node);
+	return ret;
+}
+
+int btrfs_remove_delayed_node(struct inode *inode)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_delayed_node *delayed_node;
+	int ret;
+
+	delayed_node = ACCESS_ONCE(BTRFS_I(inode)->delayed_node);
+	if (!delayed_node)
+		return 0;
+
+	mutex_lock(&delayed_node->mutex);
+	if (!delayed_node->count) {
+		mutex_unlock(&delayed_node->mutex);
+		btrfs_release_delayed_node(delayed_node);
+		BTRFS_I(inode)->delayed_node = NULL;
+		return 0;
+	}
+	mutex_unlock(&delayed_node->mutex);
+
+	trans = btrfs_join_transaction(root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = __btrfs_commit_inode_delayed_items(trans, root, delayed_node);
+	if (ret)
+		goto out;
+
+	BUG_ON(delayed_node->count);
+
+	BTRFS_I(inode)->delayed_node = NULL;
+	btrfs_release_delayed_node(delayed_node);
+out:
+	btrfs_end_transaction_dmeta(trans, root);
+
+	return ret;
+}
+
+struct btrfs_async_delayed_node {
+	struct btrfs_root *root;
+	struct btrfs_delayed_node *delayed_node;
+	struct btrfs_work work;
+};
+
+static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
+{
+	struct btrfs_async_delayed_node *async_node;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	struct btrfs_delayed_node *delayed_node = NULL;
+	struct btrfs_root *root;
+	unsigned long nr = 0;
+	int need_requeue = 0;
+	int ret;
+
+	async_node = container_of(work, struct btrfs_async_delayed_node, work);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		goto out;
+	path->leave_spinning = 1;
+
+	root = async_node->root;
+	BUG_ON(!root);
+
+	trans = btrfs_join_transaction(root, 0);
+	if (IS_ERR(trans))
+		goto free_path;
+
+	delayed_node = async_node->delayed_node;
+
+	root = btrfs_get_fs_root(async_node->root, delayed_node->root_id);
+	BUG_ON(IS_ERR_OR_NULL(root));
+
+	ret = btrfs_insert_delayed_items(trans, path, root, delayed_node);
+	if (!ret)
+		ret = btrfs_delete_delayed_items(trans, path, root,
+						 delayed_node);
+
+	if (!ret)
+		btrfs_update_delayed_inode(trans, root, path, delayed_node);
+
+	/*
+	 * Maybe new delayed items have been inserted, so we need requeue
+	 * the work. Besides that, we must dequeue the empty delayed nodes
+	 * to avoid the race between delayed items balance and the worker.
+	 * The race like this:
+	 * 	Task1				Worker thread
+	 * 					count == 0, needn't requeue
+	 * 					  also needn't insert the
+	 * 					  delayed node into prepare
+	 * 					  list again.
+	 * 	add lots of delayed items
+	 * 	queue the delayed node
+	 * 	  already in the list,
+	 * 	  and not in the prepare
+	 * 	  list, it means the delayed
+	 * 	  node is being dealt with
+	 * 	  by the worker.
+	 * 	do delayed items balance
+	 * 	  the delayed node is being
+	 * 	  dealt with by the worker
+	 * 	  now, just wait.
+	 * 	  				the worker goto idle.
+	 * Task1 will sleep until the transaction is commited.
+	 */
+	mutex_lock(&delayed_node->mutex);
+	if (delayed_node->count)
+		need_requeue = 1;
+	else
+		btrfs_dequeue_delayed_node(delayed_node->delayed_root,
+					   delayed_node);
+	mutex_unlock(&delayed_node->mutex);
+
+	nr = trans->blocks_used;
+
+	btrfs_end_transaction_dmeta(trans, root);
+	__btrfs_btree_balance_dirty(root, nr);
+free_path:
+	btrfs_free_path(path);
+out:
+	if (need_requeue)
+		btrfs_requeue_work(&async_node->work);
+	else {
+		btrfs_release_prepared_delayed_node(delayed_node);
+		kfree(async_node);
+	}
+}
+
+static int btrfs_wq_run_delayed_node(struct btrfs_delayed_root *delayed_root,
+				     struct btrfs_root *root, int all)
+{
+	struct btrfs_async_delayed_node *async_node;
+	struct btrfs_delayed_node *curr;
+	int count = 0;
+
+again:
+	curr = btrfs_first_prepared_delayed_node(delayed_root);
+	if (!curr)
+		return 0;
+
+	async_node = kmalloc(sizeof(*async_node), GFP_NOFS);
+	if (!async_node) {
+		btrfs_release_prepared_delayed_node(curr);
+		return -ENOMEM;
+	}
+
+	async_node->root = root;
+	async_node->delayed_node = curr;
+
+	async_node->work.func = btrfs_async_run_delayed_node_done;
+	async_node->work.flags = 0;
+
+	btrfs_queue_worker(&root->fs_info->delayed_workers, &async_node->work);
+	count++;
+
+	if (all || count < 4)
+		goto again;
+
+	return 0;
+}
+
+void btrfs_balance_delayed_items(struct btrfs_root *root)
+{
+	struct btrfs_delayed_root *delayed_root;
+
+	delayed_root = btrfs_get_delayed_root(root);
+
+	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND)
+		return;
+
+	if (atomic_read(&delayed_root->items) >= BTRFS_DELAYED_WRITEBACK) {
+		int ret;
+		ret = btrfs_wq_run_delayed_node(delayed_root, root, 1);
+		if (ret)
+			return;
+
+		wait_event_interruptible_timeout(
+				delayed_root->wait,
+				(atomic_read(&delayed_root->items) <
+				 BTRFS_DELAYED_BACKGROUND),
+				HZ);
+		return;
+	}
+
+	btrfs_wq_run_delayed_node(delayed_root, root, 0);
+}
+
+int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root, const char *name,
+				   int name_len, struct inode *dir,
+				   struct btrfs_disk_key *disk_key, u8 type,
+				   u64 index)
+{
+	struct btrfs_delayed_node *delayed_node;
+	struct btrfs_delayed_item *delayed_item;
+	struct btrfs_dir_item *dir_item;
+	int ret;
+
+	delayed_node = btrfs_get_or_create_delayed_node(dir);
+	if (IS_ERR(delayed_node))
+		return PTR_ERR(delayed_node);
+
+	delayed_item = btrfs_alloc_delayed_item(sizeof(*dir_item) + name_len);
+	if (!delayed_item) {
+		ret = -ENOMEM;
+		goto release_node;
+	}
+
+	ret = btrfs_delayed_item_reserve_metadata(trans, root, delayed_item);
+	/*
+	 * we have reserved enough space when we start a new transaction,
+	 * so reserving metadata failure is impossible
+	 */
+	BUG_ON(ret);
+
+	delayed_item->key.objectid = dir->i_ino;
+	btrfs_set_key_type(&delayed_item->key, BTRFS_DIR_INDEX_KEY);
+	delayed_item->key.offset = index;
+
+	dir_item = (struct btrfs_dir_item *)delayed_item->data;
+	dir_item->location = *disk_key;
+	dir_item->transid = cpu_to_le64(trans->transid);
+	dir_item->data_len = 0;
+	dir_item->name_len = cpu_to_le16(name_len);
+	dir_item->type = type;
+	memcpy((char *)(dir_item + 1), name, name_len);
+
+	mutex_lock(&delayed_node->mutex);
+	ret = __btrfs_add_delayed_insertion_item(delayed_node, delayed_item);
+	if (unlikely(ret)) {
+		printk(KERN_ERR "err add delayed dir index item(name: %s) into "
+				"the insertion tree of the delayed node"
+				"(root id: %llu, inode id: %llu, errno: %d)\n",
+				name,
+				(unsigned long long)delayed_node->root_id,
+				(unsigned long long)delayed_node->inode_id,
+				ret);
+		BUG();
+	}
+	mutex_unlock(&delayed_node->mutex);
+
+release_node:
+	btrfs_release_delayed_node(delayed_node);
+	return ret;
+}
+
+static int btrfs_delete_delayed_insertion_item(struct btrfs_root *root,
+					       struct btrfs_delayed_node *node,
+					       struct btrfs_key *key)
+{
+	struct btrfs_delayed_item *item;
+
+	mutex_lock(&node->mutex);
+	item = __btrfs_lookup_delayed_insertion_item(node, key);
+	if (!item) {
+		mutex_unlock(&node->mutex);
+		return 1;
+	}
+
+	btrfs_delayed_item_release_metadata(root, item);
+	btrfs_release_delayed_item(item);
+	mutex_unlock(&node->mutex);
+	return 0;
+}
+
+int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root, struct inode *dir,
+				   u64 index)
+{
+	struct btrfs_delayed_node *node;
+	struct btrfs_delayed_item *item;
+	struct btrfs_key item_key;
+	int ret;
+
+	node = btrfs_get_or_create_delayed_node(dir);
+	if (IS_ERR(node))
+		return PTR_ERR(node);
+
+	item_key.objectid = dir->i_ino;
+	btrfs_set_key_type(&item_key, BTRFS_DIR_INDEX_KEY);
+	item_key.offset = index;
+
+	ret = btrfs_delete_delayed_insertion_item(root, node, &item_key);
+	if (!ret)
+		goto end;
+
+	item = btrfs_alloc_delayed_item(0);
+	if (!item) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	item->key = item_key;
+
+	ret = btrfs_delayed_item_reserve_metadata(trans, root, item);
+	/*
+	 * we have reserved enough space when we start a new transaction,
+	 * so reserving metadata failure is impossible.
+	 */
+	BUG_ON(ret);
+
+	mutex_lock(&node->mutex);
+	ret = __btrfs_add_delayed_deletion_item(node, item);
+	if (unlikely(ret)) {
+		printk(KERN_ERR "err add delayed dir index item(index: %llu) "
+				"into the deletion tree of the delayed node"
+				"(root id: %llu, inode id: %llu, errno: %d)\n",
+				(unsigned long long)index,
+				(unsigned long long)node->root_id,
+				(unsigned long long)node->inode_id,
+				ret);
+		BUG();
+	}
+	mutex_unlock(&node->mutex);
+end:
+	btrfs_release_delayed_node(node);
+	return ret;
+}
+
+int btrfs_inode_delayed_dir_index_count(struct inode *inode)
+{
+	struct btrfs_delayed_node *delayed_node = BTRFS_I(inode)->delayed_node;
+	int ret = 0;
+
+	if (!delayed_node)
+		return -ENOENT;
+
+	/*
+	 * Since we have held i_mutex of this directory, it is impossible that
+	 * a new directory index is added into the delayed node and index_cnt
+	 * is updated now. So we needn't lock the delayed node.
+	 */
+	if (!delayed_node->index_cnt)
+		return -EINVAL;
+
+	BTRFS_I(inode)->index_cnt = delayed_node->index_cnt;
+	return ret;
+}
+
+void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
+			     struct list_head *del_list)
+{
+	struct btrfs_delayed_node *delayed_node;
+	struct btrfs_delayed_item *item;
+
+	delayed_node = btrfs_get_delayed_node(inode);
+	if (!delayed_node)
+		return;
+
+	mutex_lock(&delayed_node->mutex);
+	item = __btrfs_first_delayed_insertion_item(delayed_node);
+	while (item) {
+		atomic_inc(&item->refs);
+		list_add_tail(&item->readdir_list, ins_list);
+		item = __btrfs_next_delayed_item(item);
+	}
+
+	item = __btrfs_first_delayed_deletion_item(delayed_node);
+	while (item) {
+		atomic_inc(&item->refs);
+		list_add_tail(&item->readdir_list, del_list);
+		item = __btrfs_next_delayed_item(item);
+	}
+	mutex_unlock(&delayed_node->mutex);
+	/*
+	 * This delayed node is still cached in the btrfs inode, so refs
+	 * must be > 1 now, and we needn't check it is going to be freed
+	 * or not.
+	 *
+	 * Besides that, this function is used to read dir, we do not
+	 * insert/delete delayed items in this period. So we also needn't
+	 * requeue or dequeue this delayed node.
+	 */
+	atomic_dec(&delayed_node->refs);
+}
+
+void btrfs_put_delayed_items(struct list_head *ins_list,
+			     struct list_head *del_list)
+{
+	struct btrfs_delayed_item *curr, *next;
+
+	list_for_each_entry_safe(curr, next, ins_list, readdir_list) {
+		list_del(&curr->readdir_list);
+		if (atomic_dec_and_test(&curr->refs))
+			kfree(curr);
+	}
+
+	list_for_each_entry_safe(curr, next, del_list, readdir_list) {
+		list_del(&curr->readdir_list);
+		if (atomic_dec_and_test(&curr->refs))
+			kfree(curr);
+	}
+}
+
+int btrfs_should_delete_dir_index(struct list_head *del_list,
+				  u64 index)
+{
+	struct btrfs_delayed_item *curr, *next;
+	int ret;
+
+	if (list_empty(del_list))
+		return 0;
+
+	list_for_each_entry_safe(curr, next, del_list, readdir_list) {
+		if (curr->key.offset > index)
+			break;
+
+		list_del(&curr->readdir_list);
+		ret = (curr->key.offset == index);
+
+		if (atomic_dec_and_test(&curr->refs))
+			kfree(curr);
+
+		if (ret)
+			return 1;
+		else
+			continue;
+	}
+	return 0;
+}
+
+/*
+ * btrfs_readdir_delayed_dir_index - read dir info stored in the delayed tree
+ *
+ */
+int btrfs_readdir_delayed_dir_index(struct file *filp, void *dirent,
+				    filldir_t filldir,
+				    struct list_head *ins_list)
+{
+	struct btrfs_dir_item *di;
+	struct btrfs_delayed_item *curr, *next;
+	struct btrfs_key location;
+	char *name;
+	int name_len;
+	int over = 0;
+	unsigned char d_type;
+
+	if (list_empty(ins_list))
+		return 0;
+
+	/*
+	 * Changing the data of the delayed item is impossible. So
+	 * we needn't lock them. And we have held i_mutex of the
+	 * directory, nobody can delete any directory indexes now.
+	 */
+	list_for_each_entry_safe(curr, next, ins_list, readdir_list) {
+		list_del(&curr->readdir_list);
+
+		if (curr->key.offset < filp->f_pos) {
+			if (atomic_dec_and_test(&curr->refs))
+				kfree(curr);
+			continue;
+		}
+
+		filp->f_pos = curr->key.offset;
+
+		di = (struct btrfs_dir_item *)curr->data;
+		name = (char *)(di + 1);
+		name_len = le16_to_cpu(di->name_len);
+
+		d_type = btrfs_filetype_table[di->type];
+		btrfs_disk_key_to_cpu(&location, &di->location);
+
+		over = filldir(dirent, name, name_len, curr->key.offset,
+			       location.objectid, d_type);
+
+		if (atomic_dec_and_test(&curr->refs))
+			kfree(curr);
+
+		if (over)
+			return 1;
+	}
+	return 0;
+}
+
+BTRFS_SETGET_STACK_FUNCS(stack_inode_generation, struct btrfs_inode_item,
+			 generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence, struct btrfs_inode_item,
+			 sequence, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_transid, struct btrfs_inode_item,
+			 transid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_size, struct btrfs_inode_item, size, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_nbytes, struct btrfs_inode_item,
+			 nbytes, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_block_group, struct btrfs_inode_item,
+			 block_group, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_nlink, struct btrfs_inode_item, nlink, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_uid, struct btrfs_inode_item, uid, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_gid, struct btrfs_inode_item, gid, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_mode, struct btrfs_inode_item, mode, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_rdev, struct btrfs_inode_item, rdev, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_flags, struct btrfs_inode_item, flags, 64);
+
+BTRFS_SETGET_STACK_FUNCS(stack_timespec_sec, struct btrfs_timespec, sec, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_timespec_nsec, struct btrfs_timespec, nsec, 32);
+
+static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
+				  struct btrfs_inode_item *inode_item,
+				  struct inode *inode)
+{
+	btrfs_set_stack_inode_uid(inode_item, inode->i_uid);
+	btrfs_set_stack_inode_gid(inode_item, inode->i_gid);
+	btrfs_set_stack_inode_size(inode_item, BTRFS_I(inode)->disk_i_size);
+	btrfs_set_stack_inode_mode(inode_item, inode->i_mode);
+	btrfs_set_stack_inode_nlink(inode_item, inode->i_nlink);
+	btrfs_set_stack_inode_nbytes(inode_item, inode_get_bytes(inode));
+	btrfs_set_stack_inode_generation(inode_item,
+					 BTRFS_I(inode)->generation);
+	btrfs_set_stack_inode_sequence(inode_item, BTRFS_I(inode)->sequence);
+	btrfs_set_stack_inode_transid(inode_item, trans->transid);
+	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
+	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
+	btrfs_set_stack_inode_block_group(inode_item,
+					  BTRFS_I(inode)->block_group);
+
+	btrfs_set_stack_timespec_sec(btrfs_inode_atime(inode_item),
+				     inode->i_atime.tv_sec);
+	btrfs_set_stack_timespec_nsec(btrfs_inode_atime(inode_item),
+				      inode->i_atime.tv_nsec);
+
+	btrfs_set_stack_timespec_sec(btrfs_inode_mtime(inode_item),
+				     inode->i_mtime.tv_sec);
+	btrfs_set_stack_timespec_nsec(btrfs_inode_mtime(inode_item),
+				      inode->i_mtime.tv_nsec);
+
+	btrfs_set_stack_timespec_sec(btrfs_inode_ctime(inode_item),
+				     inode->i_ctime.tv_sec);
+	btrfs_set_stack_timespec_nsec(btrfs_inode_ctime(inode_item),
+				      inode->i_ctime.tv_nsec);
+}
+
+int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, struct inode *inode)
+{
+	struct btrfs_delayed_node *delayed_node;
+	int ret;
+
+	delayed_node = btrfs_get_or_create_delayed_node(inode);
+	if (IS_ERR(delayed_node))
+		return PTR_ERR(delayed_node);
+
+	mutex_lock(&delayed_node->mutex);
+	if (delayed_node->inode_dirty) {
+		fill_stack_inode_item(trans, &delayed_node->inode_item, inode);
+		goto release_node;
+	}
+
+	ret = btrfs_delayed_inode_reserve_metadata(trans, root, delayed_node);
+	/*
+	 * we must reserve enough space when we start a new transaction,
+	 * so reserving metadata failure is impossible
+	 */
+	BUG_ON(ret);
+
+	fill_stack_inode_item(trans, &delayed_node->inode_item, inode);
+	delayed_node->inode_dirty = 1;
+	delayed_node->count++;
+	atomic_inc(&delayed_node->delayed_root->items);
+release_node:
+	mutex_unlock(&delayed_node->mutex);
+	btrfs_release_delayed_node(delayed_node);
+	return ret;
+}
+
+int btrfs_kill_delayed_inode_items(struct btrfs_trans_handle *trans,
+				   struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_delayed_node *delayed_node;
+	struct btrfs_delayed_item *curr_item, *prev_item;
+
+	delayed_node = btrfs_get_delayed_node(inode);
+	if (!delayed_node)
+		return 0;
+
+	mutex_lock(&delayed_node->mutex);
+	curr_item = __btrfs_first_delayed_insertion_item(delayed_node);
+	while (curr_item) {
+		btrfs_delayed_item_release_metadata(root, curr_item);
+		prev_item = curr_item;
+		curr_item = __btrfs_next_delayed_item(prev_item);
+		btrfs_release_delayed_item(prev_item);
+	}
+
+	curr_item = __btrfs_first_delayed_deletion_item(delayed_node);
+	while (curr_item) {
+		btrfs_delayed_item_release_metadata(root, curr_item);
+		prev_item = curr_item;
+		curr_item = __btrfs_next_delayed_item(prev_item);
+		btrfs_release_delayed_item(prev_item);
+	}
+
+	if (delayed_node->inode_dirty) {
+		btrfs_delayed_inode_release_metadata(root, delayed_node);
+		btrfs_release_delayed_inode(delayed_node);
+	}
+	mutex_unlock(&delayed_node->mutex);
+
+	btrfs_release_delayed_node(delayed_node);
+
+	return 0;
+}
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
new file mode 100644
index 0000000..4c91ed0
--- /dev/null
+++ b/fs/btrfs/delayed-inode.h
@@ -0,0 +1,142 @@
+/*
+ * Copyright (C) 2011 Fujitsu.  All rights reserved.
+ * Written by Miao Xie <miaox@cn.fujitsu.com>
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
+#ifndef __DELAYED_TREE_OPERATION_H
+#define __DELAYED_TREE_OPERATION_H
+
+#include <linux/rbtree.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <asm/atomic.h>
+
+#include "ctree.h"
+
+/* types of the delayed item */
+#define BTRFS_DELAYED_INSERTION_ITEM	1
+#define BTRFS_DELAYED_DELETION_ITEM	2
+
+struct btrfs_delayed_root {
+	spinlock_t lock;
+	struct list_head node_list;
+	/*
+	 * Used for delayed nodes which is waiting to be dealt with by the
+	 * worker. If the delayed node is inserted into the work queue, we
+	 * drop it from this list.
+	 */
+	struct list_head prepare_list;
+	atomic_t items;		/* for delayed items */
+	int nodes;		/* for delayed nodes */
+	wait_queue_head_t wait;
+};
+
+struct btrfs_delayed_node {
+	u64 root_id;
+	u64 inode_id;
+	u64 bytes_reserved;
+	struct btrfs_block_rsv *block_rsv;
+	struct btrfs_delayed_root *delayed_root;
+	/* Used to add the node into the delayed root's node list. */
+	struct list_head n_list;
+	/*
+	 * Used to add the node into the prepare list, the nodes in this list
+	 * is waiting to be dealt with by the async worker.
+	 */
+	struct list_head p_list;
+	struct rb_root ins_root;
+	struct rb_root del_root;
+	struct mutex mutex;
+	struct btrfs_inode_item inode_item;
+	atomic_t refs;
+	u64 index_cnt;
+	bool in_list;
+	bool inode_dirty;
+	int count;
+};
+
+struct btrfs_delayed_item {
+	struct rb_node rb_node;
+	struct btrfs_key key;
+	struct list_head tree_list;	/* used for batch insert/delete items */
+	struct list_head readdir_list;	/* used for readdir items */
+	u64 bytes_reserved;
+	struct btrfs_block_rsv *block_rsv;
+	struct btrfs_delayed_node *delayed_node;
+	atomic_t refs;
+	int ins_or_del;
+	u32 data_len;
+	char data[0];
+};
+
+static inline void btrfs_init_delayed_root(
+				struct btrfs_delayed_root *delayed_root)
+{
+	atomic_set(&delayed_root->items, 0);
+	delayed_root->nodes = 0;
+	spin_lock_init(&delayed_root->lock);
+	init_waitqueue_head(&delayed_root->wait);
+	INIT_LIST_HEAD(&delayed_root->node_list);
+	INIT_LIST_HEAD(&delayed_root->prepare_list);
+}
+
+int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root, const char *name,
+				   int name_len, struct inode *dir,
+				   struct btrfs_disk_key *disk_key, u8 type,
+				   u64 index);
+
+int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root, struct inode *dir,
+				   u64 index);
+
+int btrfs_inode_delayed_dir_index_count(struct inode *inode);
+
+int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root);
+
+void btrfs_balance_delayed_items(struct btrfs_root *root);
+
+int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     struct inode *inode);
+/* Used for evicting the inode. */
+int btrfs_remove_delayed_node(struct inode *inode);
+int btrfs_kill_delayed_inode_items(struct btrfs_trans_handle *trans,
+				   struct inode *inode);
+
+
+int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, struct inode *inode);
+
+/* Used for readdir() */
+void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
+			     struct list_head *del_list);
+void btrfs_put_delayed_items(struct list_head *ins_list,
+			     struct list_head *del_list);
+int btrfs_should_delete_dir_index(struct list_head *del_list,
+				  u64 index);
+int btrfs_readdir_delayed_dir_index(struct file *filp, void *dirent,
+				    filldir_t filldir,
+				    struct list_head *ins_list);
+
+/* for init */
+int __init btrfs_delayed_inode_init(void);
+void btrfs_delayed_inode_exit(void);
+#endif
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index f0cad5a..696c793 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -124,8 +124,9 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
  * to use for the second index (if one is created).
  */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
-			  *root, const char *name, int name_len, u64 dir,
-			  struct btrfs_key *location, u8 type, u64 index)
+			  *root, const char *name, int name_len,
+			  struct inode *dir, struct btrfs_key *location,
+			  u8 type, u64 index)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -137,13 +138,17 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	struct btrfs_disk_key disk_key;
 	u32 data_size;
 
-	key.objectid = dir;
+	key.objectid = dir->i_ino;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
 	key.offset = btrfs_name_hash(name, name_len);
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->leave_spinning = 1;
 
+	btrfs_cpu_key_to_disk(&disk_key, location);
+
 	data_size = sizeof(*dir_item) + name_len;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
 					name, name_len);
@@ -155,7 +160,6 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	}
 
 	leaf = path->nodes[0];
-	btrfs_cpu_key_to_disk(&disk_key, location);
 	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
 	btrfs_set_dir_type(leaf, dir_item, type);
 	btrfs_set_dir_data_len(leaf, dir_item, 0);
@@ -174,24 +178,8 @@ second_insert:
 	}
 	btrfs_release_path(root, path);
 
-	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
-	key.offset = index;
-	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
-					name, name_len);
-	if (IS_ERR(dir_item)) {
-		ret2 = PTR_ERR(dir_item);
-		goto out;
-	}
-	leaf = path->nodes[0];
-	btrfs_cpu_key_to_disk(&disk_key, location);
-	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
-	btrfs_set_dir_type(leaf, dir_item, type);
-	btrfs_set_dir_data_len(leaf, dir_item, 0);
-	btrfs_set_dir_name_len(leaf, dir_item, name_len);
-	btrfs_set_dir_transid(leaf, dir_item, trans->transid);
-	name_ptr = (unsigned long)(dir_item + 1);
-	write_extent_buffer(leaf, name, name_ptr, name_len);
-	btrfs_mark_buffer_dirty(leaf);
+	ret2 = btrfs_insert_delayed_dir_index(trans, root, name, name_len, dir,
+					      &disk_key, type, index);
 out:
 	btrfs_free_path(path);
 	if (ret)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e1ea3e..d01a741 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1676,6 +1676,13 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	INIT_LIST_HEAD(&fs_info->ordered_extents);
 	spin_lock_init(&fs_info->ordered_extent_lock);
+	fs_info->delayed_root = kmalloc(sizeof(struct btrfs_delayed_root),
+					GFP_NOFS);
+	if (!fs_info->delayed_root) {
+		err = -ENOMEM;
+		goto fail_iput;
+	}
+	btrfs_init_delayed_root(fs_info->delayed_root);
 
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
@@ -1743,7 +1750,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	bh = btrfs_read_dev_super(fs_devices->latest_bdev);
 	if (!bh) {
 		err = -EINVAL;
-		goto fail_iput;
+		goto fail_alloc;
 	}
 
 	memcpy(&fs_info->super_copy, bh->b_data, sizeof(fs_info->super_copy));
@@ -1755,7 +1762,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	disk_super = &fs_info->super_copy;
 	if (!btrfs_super_root(disk_super))
-		goto fail_iput;
+		goto fail_alloc;
 
 	/* check FS state, whether FS is broken. */
 	fs_info->fs_state |= btrfs_super_flags(disk_super);
@@ -1765,7 +1772,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	ret = btrfs_parse_options(tree_root, options);
 	if (ret) {
 		err = ret;
-		goto fail_iput;
+		goto fail_alloc;
 	}
 
 	features = btrfs_super_incompat_flags(disk_super) &
@@ -1775,7 +1782,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		       "unsupported optional features (%Lx).\n",
 		       (unsigned long long)features);
 		err = -EINVAL;
-		goto fail_iput;
+		goto fail_alloc;
 	}
 
 	features = btrfs_super_incompat_flags(disk_super);
@@ -1791,7 +1798,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		       "unsupported option features (%Lx).\n",
 		       (unsigned long long)features);
 		err = -EINVAL;
-		goto fail_iput;
+		goto fail_alloc;
 	}
 
 	btrfs_init_workers(&fs_info->generic_worker,
@@ -1838,6 +1845,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 			   &fs_info->generic_worker);
 	btrfs_init_workers(&fs_info->endio_freespace_worker, "freespace-write",
 			   1, &fs_info->generic_worker);
+	btrfs_init_workers(&fs_info->delayed_workers, "delayed-meta",
+			   fs_info->thread_pool_size,
+			   &fs_info->generic_worker);
 
 	/*
 	 * endios are largely parallel and should have a very
@@ -1859,6 +1869,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	btrfs_start_workers(&fs_info->endio_meta_write_workers, 1);
 	btrfs_start_workers(&fs_info->endio_write_workers, 1);
 	btrfs_start_workers(&fs_info->endio_freespace_worker, 1);
+	btrfs_start_workers(&fs_info->delayed_workers, 1);
 
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
@@ -2104,6 +2115,9 @@ fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->endio_write_workers);
 	btrfs_stop_workers(&fs_info->endio_freespace_worker);
 	btrfs_stop_workers(&fs_info->submit_workers);
+	btrfs_stop_workers(&fs_info->delayed_workers);
+fail_alloc:
+	kfree(fs_info->delayed_root);
 fail_iput:
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	iput(fs_info->btree_inode);
@@ -2551,6 +2565,7 @@ int close_ctree(struct btrfs_root *root)
 	del_fs_roots(fs_info);
 
 	iput(fs_info->btree_inode);
+	kfree(fs_info->delayed_root);
 
 	btrfs_stop_workers(&fs_info->generic_worker);
 	btrfs_stop_workers(&fs_info->fixup_workers);
@@ -2562,6 +2577,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->endio_write_workers);
 	btrfs_stop_workers(&fs_info->endio_freespace_worker);
 	btrfs_stop_workers(&fs_info->submit_workers);
+	btrfs_stop_workers(&fs_info->delayed_workers);
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
@@ -2638,6 +2654,29 @@ void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
 	if (current->flags & PF_MEMALLOC)
 		return;
 
+	btrfs_balance_delayed_items(root);
+
+	num_dirty = root->fs_info->dirty_metadata_bytes;
+
+	if (num_dirty > thresh) {
+		balance_dirty_pages_ratelimited_nr(
+				   root->fs_info->btree_inode->i_mapping, 1);
+	}
+	return;
+}
+
+void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
+{
+	/*
+	 * looks as though older kernels can get into trouble with
+	 * this code, they end up stuck in balance_dirty_pages forever
+	 */
+	u64 num_dirty;
+	unsigned long thresh = 32 * 1024 * 1024;
+
+	if (current->flags & PF_MEMALLOC)
+		return;
+
 	num_dirty = root->fs_info->dirty_metadata_bytes;
 
 	if (num_dirty > thresh) {
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 07b20dc..aca35af 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -71,6 +71,7 @@ int btrfs_insert_dev_radix(struct btrfs_root *root,
 			   u64 block_start,
 			   u64 num_blocks);
 void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
+void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
 int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 void btrfs_mark_buffer_dirty_nonblocking(struct extent_buffer *buf);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 100e409..aed763f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3897,12 +3897,6 @@ static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 	WARN_ON(fs_info->chunk_block_rsv.reserved > 0);
 }
 
-static u64 calc_trans_metadata_size(struct btrfs_root *root, int num_items)
-{
-	return (root->leafsize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
-		3 * num_items;
-}
-
 int btrfs_trans_reserve_metadata(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 int num_items)
@@ -3913,7 +3907,7 @@ int btrfs_trans_reserve_metadata(struct btrfs_trans_handle *trans,
 	if (num_items == 0 || root->fs_info->chunk_root == root)
 		return 0;
 
-	num_bytes = calc_trans_metadata_size(root, num_items);
+	num_bytes = btrfs_calc_trans_metadata_size(root, num_items);
 	ret = btrfs_block_rsv_add(trans, root, &root->fs_info->trans_block_rsv,
 				  num_bytes);
 	if (!ret) {
@@ -3952,14 +3946,14 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 	 * If all of the metadata space is used, we can commit
 	 * transaction and use space it freed.
 	 */
-	u64 num_bytes = calc_trans_metadata_size(root, 4);
+	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 4);
 	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
 }
 
 void btrfs_orphan_release_metadata(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 num_bytes = calc_trans_metadata_size(root, 4);
+	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 4);
 	btrfs_block_rsv_release(root, root->orphan_block_rsv, num_bytes);
 }
 
@@ -3973,7 +3967,7 @@ int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
 	 * two for root back/forward refs, two for directory entries
 	 * and one for root of the snapshot.
 	 */
-	u64 num_bytes = calc_trans_metadata_size(root, 5);
+	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
 	dst_rsv->space_info = src_rsv->space_info;
 	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
 }
@@ -4000,7 +3994,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	nr_extents = atomic_read(&BTRFS_I(inode)->outstanding_extents) + 1;
 	if (nr_extents > BTRFS_I(inode)->reserved_extents) {
 		nr_extents -= BTRFS_I(inode)->reserved_extents;
-		to_reserve = calc_trans_metadata_size(root, nr_extents);
+		to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents);
 	} else {
 		nr_extents = 0;
 		to_reserve = 0;
@@ -4047,7 +4041,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 
 	to_free = calc_csum_metadata_size(inode, num_bytes);
 	if (nr_extents > 0)
-		to_free += calc_trans_metadata_size(root, nr_extents);
+		to_free += btrfs_calc_trans_metadata_size(root, nr_extents);
 
 	btrfs_block_rsv_release(root, &root->fs_info->delalloc_block_rsv,
 				to_free);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7027953..bc9669f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2603,11 +2603,26 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	int ret;
 
+	/*
+	 * If root is tree root, it means this inode is used to
+	 * store free space information. And these inodes are updated
+	 * when committing the transaction, so they needn't delaye to
+	 * be updated, or deadlock will occured.
+	 */
+	if (likely(root != root->fs_info->tree_root)) {
+		ret = btrfs_delayed_update_inode(trans, root, inode);
+		if (!ret)
+			btrfs_set_inode_last_trans(trans, inode);
+		return ret;
+	}
+
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	path->leave_spinning = 1;
-	ret = btrfs_lookup_inode(trans, root, path,
-				 &BTRFS_I(inode)->location, 1);
+	ret = btrfs_lookup_inode(trans, root, path, &BTRFS_I(inode)->location,
+				 1);
 	if (ret) {
 		if (ret > 0)
 			ret = -ENOENT;
@@ -2617,7 +2632,7 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	btrfs_unlock_up_safe(path, 1);
 	leaf = path->nodes[0];
 	inode_item = btrfs_item_ptr(leaf, path->slots[0],
-				  struct btrfs_inode_item);
+				    struct btrfs_inode_item);
 
 	fill_inode_item(trans, leaf, inode_item, inode);
 	btrfs_mark_buffer_dirty(leaf);
@@ -2628,7 +2643,6 @@ failed:
 	return ret;
 }
 
-
 /*
  * unlink helper that gets used here in inode.c and in the tree logging
  * recovery code.  It remove a link in a directory with a given name, and
@@ -2680,18 +2694,9 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	}
 
-	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
-					 index, name, name_len, -1);
-	if (IS_ERR(di)) {
-		ret = PTR_ERR(di);
-		goto err;
-	}
-	if (!di) {
-		ret = -ENOENT;
+	ret = btrfs_delete_delayed_dir_index(trans, root, dir, index);
+	if (ret)
 		goto err;
-	}
-	ret = btrfs_delete_one_dir_name(trans, root, path, di);
-	btrfs_release_path(root, path);
 
 	ret = btrfs_del_inode_ref_in_log(trans, root, name, name_len,
 					 inode, dir->i_ino);
@@ -2867,6 +2872,14 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	index = btrfs_inode_ref_index(path->nodes[0], ref);
 	btrfs_release_path(root, path);
 
+	/*
+	 * This is a commit root search, if we can lookup inode item and other
+	 * relative items in the commit root, it means the transaction of
+	 * dir/file creation has been committed, and the dir index item that we
+	 * delay to insert has also been inserted into the commit root. So
+	 * we needn't worry about the delayed insertion of the dir index item
+	 * here.
+	 */
 	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino, index,
 				dentry->d_name.name, dentry->d_name.len, 0);
 	if (IS_ERR(di)) {
@@ -2972,24 +2985,16 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		btrfs_release_path(root, path);
 		index = key.offset;
 	}
+	btrfs_release_path(root, path);
 
-	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
-					 index, name, name_len, -1);
-	BUG_ON(!di || IS_ERR(di));
-
-	leaf = path->nodes[0];
-	btrfs_dir_item_key_to_cpu(leaf, di, &key);
-	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY || key.objectid != objectid);
-	ret = btrfs_delete_one_dir_name(trans, root, path, di);
+	ret = btrfs_delete_delayed_dir_index(trans, root, dir, index);
 	BUG_ON(ret);
-	btrfs_release_path(root, path);
 
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
 
-	btrfs_free_path(path);
 	return 0;
 }
 
@@ -3249,6 +3254,15 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	if (root->ref_cows || root == root->fs_info->tree_root)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
 
+	/*
+	 * This function is also used to drop the items in the log tree before
+	 * we relog the inode, so if root != BTRFS_I(inode)->root, it means
+	 * it is used to drop the loged items. So we shouldn't kill the delayed
+	 * items.
+	 */
+	if (min_type == 0 && root == BTRFS_I(inode)->root)
+		btrfs_kill_delayed_inode_items(trans, inode);
+
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 	path->reada = -1;
@@ -4182,7 +4196,7 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 }
 
-static unsigned char btrfs_filetype_table[] = {
+unsigned char btrfs_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
@@ -4196,6 +4210,8 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_path *path;
+	struct list_head ins_list;
+	struct list_head del_list;
 	int ret;
 	u32 nritems;
 	struct extent_buffer *leaf;
@@ -4210,6 +4226,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	char tmp_name[32];
 	char *name_ptr;
 	int name_len;
+	int is_curr = 0;	/* filp->f_pos points to the current index? */
 
 	/* FIXME, use a real flag for deciding about the key type */
 	if (root->fs_info->tree_root == root)
@@ -4234,8 +4251,16 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 		filp->f_pos = 2;
 	}
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->reada = 2;
 
+	if (key_type == BTRFS_DIR_INDEX_KEY) {
+		INIT_LIST_HEAD(&ins_list);
+		INIT_LIST_HEAD(&del_list);
+		btrfs_get_delayed_items(inode, &ins_list, &del_list);
+	}
+
 	btrfs_set_key_type(&key, key_type);
 	key.offset = filp->f_pos;
 	key.objectid = inode->i_ino;
@@ -4273,8 +4298,13 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 			break;
 		if (found_key.offset < filp->f_pos)
 			continue;
+		if (key_type == BTRFS_DIR_INDEX_KEY &&
+		    btrfs_should_delete_dir_index(&del_list,
+						  found_key.offset))
+			continue;
 
 		filp->f_pos = found_key.offset;
+		is_curr = 1;
 
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
 		di_cur = 0;
@@ -4324,6 +4354,15 @@ skip:
 		}
 	}
 
+	if (key_type == BTRFS_DIR_INDEX_KEY) {
+		if (is_curr)
+			filp->f_pos++;
+		ret = btrfs_readdir_delayed_dir_index(filp, dirent, filldir,
+						      &ins_list);
+		if (ret)
+			goto nopos;
+	}
+
 	/* Reached end of directory/root. Bump pos past the last item. */
 	if (key_type == BTRFS_DIR_INDEX_KEY)
 		/*
@@ -4336,6 +4375,8 @@ skip:
 nopos:
 	ret = 0;
 err:
+	if (key_type == BTRFS_DIR_INDEX_KEY)
+		btrfs_put_delayed_items(&ins_list, &del_list);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -4413,6 +4454,8 @@ void btrfs_dirty_inode(struct inode *inode)
 		}
 	}
 	btrfs_end_transaction(trans, root);
+	if (BTRFS_I(inode)->delayed_node)
+		btrfs_balance_delayed_items(root);
 }
 
 /*
@@ -4481,9 +4524,12 @@ int btrfs_set_inode_index(struct inode *dir, u64 *index)
 	int ret = 0;
 
 	if (BTRFS_I(dir)->index_cnt == (u64)-1) {
-		ret = btrfs_set_inode_index_count(dir);
-		if (ret)
-			return ret;
+		ret = btrfs_inode_delayed_dir_index_count(dir);
+		if (ret) {
+			ret = btrfs_set_inode_index_count(dir);
+			if (ret)
+				return ret;
+		}
 	}
 
 	*index = BTRFS_I(dir)->index_cnt;
@@ -4641,7 +4687,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 
 	if (ret == 0) {
 		ret = btrfs_insert_dir_item(trans, root, name, name_len,
-					    parent_inode->i_ino, &key,
+					    parent_inode, &key,
 					    btrfs_inode_type(inode), index);
 		BUG_ON(ret);
 
@@ -6642,6 +6688,8 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->dummy_inode = 0;
 	ei->force_compress = BTRFS_COMPRESS_NONE;
 
+	ei->delayed_node = NULL;
+
 	inode = &ei->vfs_inode;
 	extent_map_tree_init(&ei->extent_tree, GFP_NOFS);
 	extent_io_tree_init(&ei->io_tree, &inode->i_data, GFP_NOFS);
@@ -6660,6 +6708,7 @@ void btrfs_destroy_inode(struct inode *inode)
 {
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
 
 	WARN_ON(!list_empty(&inode->i_dentry));
 	WARN_ON(inode->i_data.nrpages);
@@ -6725,6 +6774,8 @@ void btrfs_destroy_inode(struct inode *inode)
 	inode_tree_del(inode);
 	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 free:
+	ret = btrfs_remove_delayed_node(inode);
+	BUG_ON(ret);
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5fdb2ab..b200e07 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -333,7 +333,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	BUG_ON(ret);
 
 	ret = btrfs_insert_dir_item(trans, root,
-				    name, namelen, dir->i_ino, &key,
+				    name, namelen, dir, &key,
 				    BTRFS_FT_DIR, index);
 	if (ret)
 		goto fail;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index db0a827..593ce8a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -40,6 +40,7 @@
 #include <linux/magic.h>
 #include <linux/slab.h>
 #include "compat.h"
+#include "delayed-inode.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -1163,10 +1164,14 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_extent_io;
 
-	err = btrfs_interface_init();
+	err = btrfs_delayed_inode_init();
 	if (err)
 		goto free_extent_map;
 
+	err = btrfs_interface_init();
+	if (err)
+		goto free_delayed_inode;
+
 	err = register_filesystem(&btrfs_fs_type);
 	if (err)
 		goto unregister_ioctl;
@@ -1176,6 +1181,8 @@ static int __init init_btrfs_fs(void)
 
 unregister_ioctl:
 	btrfs_interface_exit();
+free_delayed_inode:
+	btrfs_delayed_inode_exit();
 free_extent_map:
 	extent_map_exit();
 free_extent_io:
@@ -1192,6 +1199,7 @@ free_sysfs:
 static void __exit exit_btrfs_fs(void)
 {
 	btrfs_destroy_cachep();
+	btrfs_delayed_inode_exit();
 	extent_map_exit();
 	extent_io_exit();
 	btrfs_interface_exit();
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3d73c8d..8f0ca33 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -478,19 +478,40 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root)
 {
-	return __btrfs_end_transaction(trans, root, 0, 1);
+	int ret;
+
+	ret = __btrfs_end_transaction(trans, root, 0, 1);
+	if (ret)
+		return ret;
+	return 0;
 }
 
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root)
 {
-	return __btrfs_end_transaction(trans, root, 1, 1);
+	int ret;
+
+	ret = __btrfs_end_transaction(trans, root, 1, 1);
+	if (ret)
+		return ret;
+	return 0;
 }
 
 int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root)
 {
-	return __btrfs_end_transaction(trans, root, 0, 0);
+	int ret;
+
+	ret = __btrfs_end_transaction(trans, root, 0, 0);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+int btrfs_end_transaction_dmeta(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root)
+{
+	return __btrfs_end_transaction(trans, root, 1, 1);
 }
 
 /*
@@ -958,7 +979,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 	ret = btrfs_insert_dir_item(trans, parent_root,
 				dentry->d_name.name, dentry->d_name.len,
-				parent_inode->i_ino, &key,
+				parent_inode, &key,
 				BTRFS_FT_DIR, index);
 	BUG_ON(ret);
 
@@ -1027,6 +1048,14 @@ static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
 	int ret;
 
 	list_for_each_entry(pending, head, list) {
+		/*
+		 * We must deal with the delayed items before creating
+		 * snapshots, or we will create a snapthot with inconsistent
+		 * information.
+		*/
+		ret = btrfs_run_delayed_items(trans, fs_info->fs_root);
+		BUG_ON(ret);
+
 		ret = create_pending_snapshot(trans, fs_info, pending);
 		BUG_ON(ret);
 	}
@@ -1279,6 +1308,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 		}
 
+		ret = btrfs_run_delayed_items(trans, root);
+		BUG_ON(ret);
+
 		/*
 		 * rename don't use btrfs_join_transaction, so, once we
 		 * set the transaction to blocked above, we aren't going
@@ -1305,6 +1337,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = create_pending_snapshots(trans, root->fs_info);
 	BUG_ON(ret);
 
+	ret = btrfs_run_delayed_items(trans, root);
+	BUG_ON(ret);
+
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 	BUG_ON(ret);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 229a594..a4a441f 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -115,6 +115,8 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 				   int wait_for_unblock);
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root);
+int btrfs_end_transaction_dmeta(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root);
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root);
 void btrfs_throttle(struct btrfs_root *root);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a4bbb85..e8a2e95 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2775,6 +2775,13 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		max_key.type = (u8)-1;
 	max_key.offset = (u64)-1;
 
+	ret = btrfs_commit_inode_delayed_items(trans, root, inode);
+	if (ret) {
+		btrfs_free_path(path);
+		btrfs_free_path(dst_path);
+		return ret;
+	}
+
 	mutex_lock(&BTRFS_I(inode)->log_mutex);
 
 	/*
-- 
1.7.3.1


--------------020806060701070704080009--
