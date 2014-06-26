Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26696 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753169AbaFZC6d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 22:58:33 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5Q2wUHr027096
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 10:58:30 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 4/6] btrfs-progs: cleanup possible silent failure in btrfs-image
Date: Thu, 26 Jun 2014 10:53:04 +0800
Message-ID: <1403751186-31559-4-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the malloc above fails, the btrfs-image will exit directly
without any error messages.
Now just return the ENOMEM errno and let the caller prompt the
error message.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 2d482c3..e0aabfd 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2421,7 +2421,8 @@ static int update_disk_super_on_device(struct btrfs_fs_info *info,
 	buf = malloc(BTRFS_SUPER_INFO_SIZE);
 	if (!buf) {
 		ret = -ENOMEM;
-		exit(1);
+		close(fp);
+		return ret;
 	}
 
 	memcpy(buf, info->super_copy, BTRFS_SUPER_INFO_SIZE);
-- 
1.8.1.4

