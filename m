Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49315 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915AbaFQOcW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 10:32:22 -0400
Message-ID: <53A0516D.5040607@oracle.com>
Date: Tue, 17 Jun 2014 22:32:13 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: clm@fb.com, Josef Bacik <jbacik@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: [PATCH 16/24] btrfs: return actual error on btrfs_init_sysfs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jie Liu <jeff.liu@oracle.com>

Return the actual error code if call kset_create_and_add() failed

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/btrfs/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index df39458..8f7dfa7 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -705,8 +705,8 @@ int btrfs_init_sysfs(void)
 	int ret;
 
 	btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);
-	if (!btrfs_kset)
-		return -ENOMEM;
+	if (IS_ERR(btrfs_kset))
+		return PTR_ERR(btrfs_kset);
 
 	ret = btrfs_init_debugfs();
 	if (ret)
-- 
1.8.3.2
