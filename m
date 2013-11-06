Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56126 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/16] btrfs-progs: Check for open failure in btrfs_scan_lblkid()
Date: Wed,  6 Nov 2013 17:15:49 -0600
Message-Id: <1383779755-18228-11-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

open can fail, of course.

Resolves-Coverity-CID: 1125925
Resolves-Coverity-CID: 1125930
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 utils.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/utils.c b/utils.c
index d8ce153..8471148 100644
--- a/utils.c
+++ b/utils.c
@@ -1955,12 +1955,16 @@ int btrfs_scan_lblkid(int update_kernel)
 		dev = blkid_verify(cache, dev);
 		if (!dev)
 			continue;
-		/* if we are here its definitly a btrfs disk*/
+		/* if we are here its definitely a btrfs disk*/
 		strncpy(path, blkid_dev_devname(dev), PATH_MAX);
 		if (test_skip_this_disk(path))
 			continue;
 
 		fd = open(path, O_RDONLY);
+		if (fd < 0) {
+			printf("ERROR: could not open %s\n", path);
+			continue;
+		}
 		btrfs_scan_one_device(fd, path, &tmp_devices,
 				&num_devices, BTRFS_SUPER_INFO_OFFSET);
 		close(fd);
-- 
1.7.1

