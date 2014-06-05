Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11405 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409AbaFECH4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 22:07:56 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5527rf4016987
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Jun 2014 10:07:53 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: replace EINVAL with EOPNOTSUPP for dev_replace raid56
Date: Thu, 5 Jun 2014 10:02:51 +0800
Message-ID: <1401933772-23447-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To return EOPNOTSUPP is more user friendly than to return EINVAL,
and then user-space tool will show that the dev_replace operation
for raid56 is not currently supported rather than showing that
there is an invalid argument.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9f22905..2af6e66 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -313,7 +313,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 
 	if (btrfs_fs_incompat(fs_info, RAID56)) {
 		btrfs_warn(fs_info, "dev_replace cannot yet handle RAID5/RAID6");
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	switch (args->start.cont_reading_from_srcdev_mode) {
-- 
1.8.1.4

