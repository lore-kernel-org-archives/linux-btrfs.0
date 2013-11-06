Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56118 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3KFXP5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/16] btrfs-progs: use strncpy in btrfs_scan_lblkid()
Date: Wed,  6 Nov 2013 17:15:42 -0600
Message-Id: <1383779755-18228-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use strncpy(... ,PATH_MAX) to be sure we don't overflow
the path[PATH_MAX] array.

Resolves-Coverity-CID: 1125941
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 utils.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/utils.c b/utils.c
index a7441c1..c11a7c2 100644
--- a/utils.c
+++ b/utils.c
@@ -1952,7 +1952,7 @@ int btrfs_scan_lblkid(int update_kernel)
 		if (!dev)
 			continue;
 		/* if we are here its definitly a btrfs disk*/
-		strcpy(path, blkid_dev_devname(dev));
+		strncpy(path, blkid_dev_devname(dev), PATH_MAX);
 		if (test_skip_this_disk(path))
 			continue;
 
-- 
1.7.1

