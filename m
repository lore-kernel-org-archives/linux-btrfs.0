Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11033 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab3KVKq5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 05:46:57 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rAMAksR0002184
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 18:46:55 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: don't clear the default compression type
Date: Fri, 22 Nov 2013 18:47:59 +0800
Message-Id: <1385117279-32009-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We met a oops caused by the wrong compression type:
[  556.512356] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  556.512370] IP: [<ffffffff811dbaa0>] __list_del_entry+0x1/0x98
[SNIP]
[  556.512490]  [<ffffffff811dbb44>] ? list_del+0xd/0x2b
[  556.512539]  [<ffffffffa05dd5ce>] find_workspace+0x97/0x175 [btrfs]
[  556.512546]  [<ffffffff813c14b5>] ? _raw_spin_lock+0xe/0x10
[  556.512576]  [<ffffffffa05de276>] btrfs_compress_pages+0x2d/0xa2 [btrfs]
[  556.512601]  [<ffffffffa05af060>] compress_file_range.constprop.54+0x1f2/0x4e8 [btrfs]
[  556.512627]  [<ffffffffa05af388>] async_cow_start+0x32/0x4d [btrfs]
[  556.512655]  [<ffffffffa05cc7a1>] worker_loop+0x144/0x4c3 [btrfs]
[  556.512661]  [<ffffffff81059404>] ? finish_task_switch+0x80/0xb8
[  556.512689]  [<ffffffffa05cc65d>] ? btrfs_queue_worker+0x244/0x244 [btrfs]
[  556.512695]  [<ffffffff8104fa4e>] kthread+0x8d/0x95
[  556.512699]  [<ffffffff81050000>] ? bit_waitqueue+0x34/0x7d
[  556.512704]  [<ffffffff8104f9c1>] ? __kthread_parkme+0x65/0x65
[  556.512709]  [<ffffffff813c7eec>] ret_from_fork+0x7c/0xb0
[  556.512713]  [<ffffffff8104f9c1>] ? __kthread_parkme+0x65/0x65

Steps to reproduce:
 # mkfs.btrfs -f <dev>
 # mount -o nodatacow <dev> <mnt>
 # touch <mnt>/<file>
 # chattr =c <mnt>/<file>
 # dd if=/dev/zero of=<mnt>/<file> bs=1M count=10

It is because we cleared the default compression type when setting the
nodatacow. In fact, we needn't do it because we have used COMPRESS flag to
indicate if we need compressed the file data or not, needn't use the
variant -- compress_type -- in btrfs_info to do the same thing, and just
use it to hold the default compression type. Or we would get a wrong compress
type for a file whose own compress flag is set but the compress flag of its
filesystem is not set.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fb62c45..fd05d7a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -432,7 +432,6 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			} else {
 				printk(KERN_INFO "btrfs: setting nodatacow\n");
 			}
-			info->compress_type = BTRFS_COMPRESS_NONE;
 			btrfs_clear_opt(info->mount_opt, COMPRESS);
 			btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
 			btrfs_set_opt(info->mount_opt, NODATACOW);
@@ -461,7 +460,6 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
-				info->compress_type = BTRFS_COMPRESS_NONE;
 				btrfs_clear_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
 				compress_force = false;
@@ -474,9 +472,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
 				pr_info("btrfs: force %s compression\n",
 					compress_type);
-			} else
+			} else if (btrfs_test_opt(root, COMPRESS)) {
 				pr_info("btrfs: use %s compression\n",
 					compress_type);
+			}
 			break;
 		case Opt_ssd:
 			printk(KERN_INFO "btrfs: use ssd allocation scheme\n");
-- 
1.8.3.1

