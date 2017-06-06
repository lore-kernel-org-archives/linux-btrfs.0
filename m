Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15100 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751524AbdFFJzU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 05:55:20 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 2/9] btrfs: Check name_len with boundary in verify dir_item
Date: Tue, 6 Jun 2017 17:57:01 +0800
Message-ID: <20170606095708.494-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Origin 'verify_dir_item' verifies name_len of dir_item with fixed values
but no item boundary.
If corrupted name_len was not bigger than the fixed value, for example 255,
the function will think the dir_item is fine. And then reading beyond
boundary will cause crash.

Example:
	1. Corrupt one dir_item name_len to be 255.
        2. Run 'ls -lar /mnt/test/ > /dev/null'
dmesg:
[   48.451449] BTRFS info (device vdb1): disk space caching is enabled
[   48.451453] BTRFS info (device vdb1): has skinny extents
[   48.489420] general protection fault: 0000 [#1] SMP
[   48.489571] Modules linked in: ext4 jbd2 mbcache btrfs xor raid6_pq
[   48.489716] CPU: 1 PID: 2710 Comm: ls Not tainted 4.10.0-rc1 #5
[   48.489853] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-20170228_101828-anatol 04/01/2014
[   48.490008] task: ffff880035df1bc0 task.stack: ffffc90004800000
[   48.490008] RIP: 0010:read_extent_buffer+0xd2/0x190 [btrfs]
[   48.490008] RSP: 0018:ffffc90004803d98 EFLAGS: 00010202
[   48.490008] RAX: 000000000000001b RBX: 000000000000001b RCX: 0000000000000000
[   48.490008] RDX: ffff880079dbf36c RSI: 0005080000000000 RDI: ffff880079dbf368
[   48.490008] RBP: ffffc90004803dc8 R08: ffff880078e8cc48 R09: ffff880000000000
[   48.490008] R10: 0000160000000000 R11: 0000000000001000 R12: ffff880079dbf288
[   48.490008] R13: ffff880078e8ca88 R14: 0000000000000003 R15: ffffc90004803e20
[   48.490008] FS:  00007fef50c60800(0000) GS:ffff88007d400000(0000) knlGS:0000000000000000
[   48.490008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   48.490008] CR2: 000055f335ac2ff8 CR3: 000000007356d000 CR4: 00000000001406e0
[   48.490008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   48.490008] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   48.490008] Call Trace:
[   48.490008]  btrfs_real_readdir+0x3b7/0x4a0 [btrfs]
[   48.490008]  iterate_dir+0x181/0x1b0
[   48.490008]  SyS_getdents+0xa7/0x150
[   48.490008]  ? fillonedir+0x150/0x150
[   48.490008]  entry_SYSCALL_64_fastpath+0x18/0xad
[   48.490008] RIP: 0033:0x7fef5032546b
[   48.490008] RSP: 002b:00007ffeafcdb830 EFLAGS: 00000206 ORIG_RAX: 000000000000004e
[   48.490008] RAX: ffffffffffffffda RBX: 00007fef5061db38 RCX: 00007fef5032546b
[   48.490008] RDX: 0000000000008000 RSI: 000055f335abaff0 RDI: 0000000000000003
[   48.490008] RBP: 00007fef5061dae0 R08: 00007fef5061db48 R09: 0000000000000000
[   48.490008] R10: 000055f335abafc0 R11: 0000000000000206 R12: 00007fef5061db38
[   48.490008] R13: 0000000000008040 R14: 00007fef5061db38 R15: 000000000000270e
[   48.490008] Code: 48 29 c3 74 5f 4c 89 d8 4c 89 d6 48 29 c8 48 39 d8 48 0f 47 c3 49 03 30 48 c1 fe 06 48 c1 e6 0c 4c 01 ce 48 01 ce 83 f8 08 72 b3 <48> 8b 0e 49 83 c0 08 48 89 0a 89 c1 48 8b 7c 0e f8 48 89 7c 0a
[   48.490008] RIP: read_extent_buffer+0xd2/0x190 [btrfs] RSP: ffffc90004803d98
[   48.499455] ---[ end trace 321920d8e8339505 ]---

Solve it by adding a parameter @slot and check name_len with item boundary
by calling 'btrfs_is_name_len_valid'.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h    |  2 +-
 fs/btrfs/dir-item.c | 10 +++++++++-
 fs/btrfs/inode.c    |  2 +-
 fs/btrfs/tree-log.c |  4 ++--
 fs/btrfs/xattr.c    |  2 +-
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 776b16ec7a47..98a69c58fe57 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3031,7 +3031,7 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 					  const char *name, u16 name_len,
 					  int mod);
 int verify_dir_item(struct btrfs_fs_info *fs_info,
-		    struct extent_buffer *leaf,
+		    struct extent_buffer *leaf, int slot,
 		    struct btrfs_dir_item *dir_item);
 struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 						 struct btrfs_path *path,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index b54c920c8412..806b9fe0178a 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -395,7 +395,7 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 
 	leaf = path->nodes[0];
 	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
-	if (verify_dir_item(fs_info, leaf, dir_item))
+	if (verify_dir_item(fs_info, leaf, path->slots[0], dir_item))
 		return NULL;
 
 	total_len = btrfs_item_size_nr(leaf, path->slots[0]);
@@ -453,9 +453,11 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 
 int verify_dir_item(struct btrfs_fs_info *fs_info,
 		    struct extent_buffer *leaf,
+		    int slot,
 		    struct btrfs_dir_item *dir_item)
 {
 	u16 namelen = BTRFS_NAME_LEN;
+	int ret;
 	u8 type = btrfs_dir_type(leaf, dir_item);
 
 	if (type >= BTRFS_FT_MAX) {
@@ -472,6 +474,12 @@ int verify_dir_item(struct btrfs_fs_info *fs_info,
 		return 1;
 	}
 
+	namelen = btrfs_dir_name_len(leaf, dir_item);
+	ret = btrfs_is_name_len_valid(leaf, slot,
+				      (unsigned long)(dir_item + 1), namelen);
+	if (!ret)
+		return 1;
+
 	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
 	if ((btrfs_dir_data_len(leaf, dir_item) +
 	     btrfs_dir_name_len(leaf, dir_item)) >
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe9306faf..df948569c393 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5934,7 +5934,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		ctx->pos = found_key.offset;
 
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
-		if (verify_dir_item(fs_info, leaf, di))
+		if (verify_dir_item(fs_info, leaf, slot, di))
 			goto next;
 
 		name_len = btrfs_dir_name_len(leaf, di);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ccfe9fe7754a..1930f28edcdd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1841,7 +1841,7 @@ static noinline int replay_one_dir_item(struct btrfs_trans_handle *trans,
 	ptr_end = ptr + item_size;
 	while (ptr < ptr_end) {
 		di = (struct btrfs_dir_item *)ptr;
-		if (verify_dir_item(fs_info, eb, di))
+		if (verify_dir_item(fs_info, eb, slot, di))
 			return -EIO;
 		name_len = btrfs_dir_name_len(eb, di);
 		ret = replay_one_name(trans, root, path, eb, di, key);
@@ -2017,7 +2017,7 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 	ptr_end = ptr + item_size;
 	while (ptr < ptr_end) {
 		di = (struct btrfs_dir_item *)ptr;
-		if (verify_dir_item(fs_info, eb, di)) {
+		if (verify_dir_item(fs_info, eb, slot, di)) {
 			ret = -EIO;
 			goto out;
 		}
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index b3cbf80c5acf..2c7e53f9ff1b 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -336,7 +336,7 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 			u32 this_len = sizeof(*di) + name_len + data_len;
 			unsigned long name_ptr = (unsigned long)(di + 1);
 
-			if (verify_dir_item(fs_info, leaf, di)) {
+			if (verify_dir_item(fs_info, leaf, slot, di)) {
 				ret = -EIO;
 				goto err;
 			}
-- 
2.13.0



