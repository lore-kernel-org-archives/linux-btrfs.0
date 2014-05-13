Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62849 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932281AbaEMJIX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 05:08:23 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4D98LOH025709
	for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 17:08:21 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: save us an unnecessary ioctl call
Date: Tue, 13 May 2014 17:05:05 +0800
Message-ID: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs device id start from 1, not 0.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 560c557..d480353 100644
--- a/utils.c
+++ b/utils.c
@@ -1765,7 +1765,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		goto out;
 	}
 
-	for (; i <= fi_args->max_id; ++i) {
+	for (i = 1; i <= fi_args->max_id; ++i) {
 		BUG_ON(ndevs >= fi_args->num_devices);
 		ret = get_device_info(fd, i, &di_args[ndevs]);
 		if (ret == -ENODEV)
-- 
1.8.2.1

