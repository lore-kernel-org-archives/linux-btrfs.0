Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4896 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751253AbaJHCSV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 22:18:21 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>
Subject: [PATCH] btrfs: Fix compile error when CONFIG_SECURITY is not set.
Date: Wed, 8 Oct 2014 10:19:08 +0800
Message-ID: <1412734748-28284-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix the following compile error when CONFIG_SECURITY is not set:

error: 'struct security_mnt_opts' has no member named 'num_mnt_opts'

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
This is the delta patch of the v2 patch.
---
 fs/btrfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1eb7858..6f64411 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1248,6 +1248,7 @@ static int setup_security_options(struct btrfs_fs_info *fs_info,
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_SECURITY
 	if (!fs_info->security_opts.num_mnt_opts) {
 		/* first time security setup, copy sec_opts to fs_info */
 		memcpy(&fs_info->security_opts, sec_opts, sizeof(*sec_opts));
@@ -1260,6 +1261,7 @@ static int setup_security_options(struct btrfs_fs_info *fs_info,
 		 */
 		security_free_mnt_opts(sec_opts);
 	}
+#endif
 	return ret;
 }
 
-- 
1.8.3.1

