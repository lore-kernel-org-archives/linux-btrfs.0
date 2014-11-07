Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54000 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751160AbaKGCJQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 21:09:16 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sA7294Tm011250
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Nov 2014 10:09:04 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: remove BUG_ON on num of devices for btrfs fi show
Date: Fri, 7 Nov 2014 10:07:42 +0800
Message-ID: <1415326063-8838-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1415326063-8838-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following BUG_ON:
	BUG_ON(ndevs >= fi_args->num_devices)
is not needed, because it always fails with seed devices present.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 utils.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/utils.c b/utils.c
index f10c178..9bcc1a0 100644
--- a/utils.c
+++ b/utils.c
@@ -1889,7 +1889,6 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	i++;
 
 	for (; i <= fi_args->max_id; ++i) {
-		BUG_ON(ndevs >= fi_args->num_devices);
 		ret = get_device_info(fd, i, &di_args[ndevs]);
 		if (ret == -ENODEV)
 			continue;
-- 
1.8.1.4

