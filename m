Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39021 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbcCUHV0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 03:21:26 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/6] btrfs-progs: remove duplicate function __is_subvol()
Date: Mon, 21 Mar 2016 15:21:02 +0800
Message-Id: <1458544865-16467-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>

The function test_issubvolume() provides the same check, and
has better logic.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/utils.c b/utils.c
index 046ddf8eef19..110a4badb764 100644
--- a/utils.c
+++ b/utils.c
@@ -1864,25 +1864,6 @@ int set_label(const char *btrfs_dev, const char *label)
 }
 
 /*
- * Unsafe subvolume check.
- *
- * This only checks ino == BTRFS_FIRST_FREE_OBJECTID, even it is not in a
- * btrfs mount point.
- * Must use together with other reliable method like btrfs ioctl.
- */
-static int __is_subvol(const char *path)
-{
-	struct stat st;
-	int ret;
-
-	ret = lstat(path, &st);
-	if (ret < 0)
-		return ret;
-
-	return st.st_ino == BTRFS_FIRST_FREE_OBJECTID;
-}
-
-/*
  * A not-so-good version fls64. No fascinating optimization since
  * no one except parse_size use it
  */
@@ -2002,7 +1983,7 @@ u64 parse_qgroupid(const char *p)
 
 path:
 	/* Path format like subv at 'my_subvol' is the fallback case */
-	ret = __is_subvol(p);
+	ret = test_issubvolume(p);
 	if (ret < 0 || !ret)
 		goto err;
 	fd = open(p, O_RDONLY);
-- 
2.7.0

