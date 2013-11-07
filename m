Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32156 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab3KGCfK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 21:35:10 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: sandeen@redhat.com
Subject: [PATCH] btrfs-progs: use strncpy in btrfs_scan_lblkid()
Date: Thu,  7 Nov 2013 10:43:40 +0800
Message-Id: <1383792220-24436-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1383779755-18228-4-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-4-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

Use strncpy(... ,PATH_MAX) to be sure we don't overflow
the path[PATH_MAX] array.

Resolves-Coverity-CID: 1125941
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index 753169b..ebd10e5 100644
--- a/utils.c
+++ b/utils.c
@@ -1981,8 +1981,8 @@ int btrfs_scan_lblkid(int update_kernel)
 		dev = blkid_verify(cache, dev);
 		if (!dev)
 			continue;
-		/* if we are here its definitly a btrfs disk*/
-		strcpy(path, blkid_dev_devname(dev));
+		/* if we are here its definitely a btrfs disk*/
+		strncpy(path, blkid_dev_devname(dev), PATH_MAX);
 		if (test_skip_this_disk(path))
 			continue;
 
-- 
1.7.1

