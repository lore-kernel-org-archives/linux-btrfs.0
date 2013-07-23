Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61734 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab3GWFXV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 01:23:21 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6N5NJbX004353
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 13:23:19 +0800
Message-ID: <51EE130A.7020101@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 13:22:18 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs: add missing mounting options in btrfs_show_options()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some options are missing in btrfs_show_options(), this patch
adds them.

Signed-off-by: Wang Shilong<wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie<miaox@cn.fujitsu.com>
---
  fs/btrfs/super.c | 14 ++++++++++++++
  1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d82391d..fa57418 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -965,6 +965,20 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
  		seq_puts(seq, ",inode_cache");
  	if (btrfs_test_opt(root, SKIP_BALANCE))
  		seq_puts(seq, ",skip_balance");
+	if (btrfs_test_opt(root, RECOVERY))
+		seq_puts(seq, ",auto_recovery");
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
-- 1.8.0.1

