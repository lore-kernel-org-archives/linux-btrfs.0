Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42243 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756099AbaGaD3p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 23:29:45 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6V3TgNP008712
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 11:29:42 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: fix improper return value check for is_existing_blk_or_reg_file
Date: Thu, 31 Jul 2014 11:23:44 +0800
Message-ID: <1406777024-7647-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1406777024-7647-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1406777024-7647-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function @is_existing_blk_or_reg_file has a return value of -errno,
which indicate the @stat call fails with non-ENOENT errors.
In this condition, we should not continue the following work.

But -errno evaluates to true and will let the following work go.
So we should judge more accurately whether the return value of
@is_existing_blk_or_reg_file is > 0 or not to decide our behavior.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 utils.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/utils.c b/utils.c
index 11250d9..1472e09 100644
--- a/utils.c
+++ b/utils.c
@@ -1595,22 +1595,29 @@ int get_label(const char *btrfs_dev, char *label)
 {
 	int ret;
 
-	if (is_existing_blk_or_reg_file(btrfs_dev))
-		ret = get_label_unmounted(btrfs_dev, label);
-	else
+	ret = is_existing_blk_or_reg_file(btrfs_dev);
+	if (!ret)
 		ret = get_label_mounted(btrfs_dev, label);
+	else if (ret > 0)
+		ret = get_label_unmounted(btrfs_dev, label);
 
 	return ret;
 }
 
 int set_label(const char *btrfs_dev, const char *label)
 {
+	int ret;
+
 	if (check_label(label))
 		return -1;
 
-	return is_existing_blk_or_reg_file(btrfs_dev) ?
-		set_label_unmounted(btrfs_dev, label) :
-		set_label_mounted(btrfs_dev, label);
+	ret = is_existing_blk_or_reg_file(btrfs_dev);
+	if (!ret)
+		ret = set_label_mounted(btrfs_dev, label);
+	else if (ret > 0)
+		ret = set_label_unmounted(btrfs_dev, label);
+
+	return ret;
 }
 
 int btrfs_scan_block_devices(int run_ioctl)
-- 
1.8.1.4

