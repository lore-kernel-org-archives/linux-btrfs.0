Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33326 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3GXCbG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 22:31:06 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6O2V5bi018099
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jul 2013 10:31:05 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 3/3] Btrfs: add missing mounting options in btrfs_show_options()
Date: Wed, 24 Jul 2013 10:30:02 +0800
Message-Id: <1374633002-3414-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some options are missing in btrfs_show_options(), this patch
adds them.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
V1->V2: s/auto_recovery/recovery(Thanks to Stefan)
---
 fs/btrfs/super.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d82391d..2cc5b80 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -965,6 +965,20 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",inode_cache");
 	if (btrfs_test_opt(root, SKIP_BALANCE))
 		seq_puts(seq, ",skip_balance");
+	if (btrfs_test_opt(root, RECOVERY))
+		seq_puts(seq, ",recovery");
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+	if (btrfs_test_opt(root, CHECK_INTEGRITY_INCLUDING_EXTENT_DATA))
+		seq_puts(seq, ",check_int_data");
+	else if (btrfs_test_opt(root, CHECK_INTEGRITY))
+		seq_puts(seq, ",check_int");
+	if (info->check_integrity_print_mask)
+		seq_printf(seq, ",check_int_print_mask=%d",
+				info->check_integrity_print_mask);
+#endif
+	if (info->metadata_ratio)
+		seq_printf(seq, ",metadata_ratio=%d",
+				info->metadata_ratio);
 	if (btrfs_test_opt(root, PANIC_ON_FATAL_ERROR))
 		seq_puts(seq, ",fatal_errors=panic");
 	return 0;
-- 
1.8.0.1

