Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48903 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab3A2KGy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 05:06:54 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0TA6qvV020489
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 18:06:52 +0800
Message-ID: <51079F65.5050700@cn.fujitsu.com>
Date: Tue, 29 Jan 2013 18:07:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2 05/10] Btrfs: protect fs_info->alloc_start
References: <51079D72.7000301@cn.fujitsu.com>
In-Reply-To: <51079D72.7000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_info->alloc_start is a 64bits variant, can be accessed by
multi-task, but it is not protected strictly, it can be changed
while we are accessing it. On 32bit machine, we will get wrong
value because we access it by two instructions.(In fact, it is
also possible that the same problem happens on the 64bit machine,
because the compiler may split the 64bit operation into two 32bit
operation.)

For example:
Assuming -> alloc_start is 0x0000 0000 0001 0000 at the beginning,
then we remount and set ->alloc_start to 0x0000 0100 0000 0000.
	Task0 			Task1
				load high 32 bits
	set high 32 bits
	set low 32 bits
				load low 32 bits

Task1 will get 0.

This patch fixes this problem by using two locks to protect it
	fs_info->chunk_mutex
	sb->s_umount
On the read side, we just need get one of these two locks, and on
the write side, we must lock all of them.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- modify the changelog and make it more clear and stringency.
---
 fs/btrfs/ctree.h | 10 ++++++++++
 fs/btrfs/super.c |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3e672916..201be7d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1295,6 +1295,16 @@ struct btrfs_fs_info {
 	 * so it is also safe.
 	 */
 	u64 max_inline;
+	/*
+	 * Protected by ->chunk_mutex and sb->s_umount.
+	 *
+	 * The reason that we use two lock to protect it is because only
+	 * remount and mount operations can change it and these two operations
+	 * are under sb->s_umount, but the read side (chunk allocation) can not
+	 * acquire sb->s_umount or the deadlock would happen. So we use two
+	 * locks to protect it. On the write side, we must acquire two locks,
+	 * and on the read side, we just need acquire one of them.
+	 */
 	u64 alloc_start;
 	struct btrfs_transaction *running_transaction;
 	wait_queue_head_t transaction_throttle;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d8982e9..c96f132 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -519,7 +519,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_alloc_start:
 			num = match_strdup(&args[0]);
 			if (num) {
+				mutex_lock(&info->chunk_mutex);
 				info->alloc_start = memparse(num, NULL);
+				mutex_unlock(&info->chunk_mutex);
 				kfree(num);
 				printk(KERN_INFO
 					"btrfs: allocations start at %llu\n",
@@ -1289,7 +1291,9 @@ restore:
 	fs_info->mount_opt = old_opts;
 	fs_info->compress_type = old_compress_type;
 	fs_info->max_inline = old_max_inline;
+	mutex_lock(&fs_info->chunk_mutex);
 	fs_info->alloc_start = old_alloc_start;
+	mutex_unlock(&fs_info->chunk_mutex);
 	btrfs_resize_thread_pool(fs_info,
 		old_thread_pool_size, fs_info->thread_pool_size);
 	fs_info->metadata_ratio = old_metadata_ratio;
-- 
1.7.11.7

