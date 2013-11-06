Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56129 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/16] btrfs-progs: check btrfs_scan_one_device in btrfs_scan_lblkid()
Date: Wed,  6 Nov 2013 17:15:52 -0600
Message-Id: <1383779755-18228-14-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even if it's "definitely" btrfs at this point,
btrfs_scan_one_device could fail for other reasons.

Check the return value, warn if it fails, and skip
the device register.

Resolves-Coverity-CID: 1125925
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 utils.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/utils.c b/utils.c
index 8471148..ecacc29 100644
--- a/utils.c
+++ b/utils.c
@@ -1937,6 +1937,7 @@ int test_skip_this_disk(char *path)
 int btrfs_scan_lblkid(int update_kernel)
 {
 	int fd = -1;
+	int ret;
 	u64 num_devices;
 	struct btrfs_fs_devices *tmp_devices;
 	blkid_dev_iterate iter = NULL;
@@ -1965,8 +1966,14 @@ int btrfs_scan_lblkid(int update_kernel)
 			printf("ERROR: could not open %s\n", path);
 			continue;
 		}
-		btrfs_scan_one_device(fd, path, &tmp_devices,
+		ret = btrfs_scan_one_device(fd, path, &tmp_devices,
 				&num_devices, BTRFS_SUPER_INFO_OFFSET);
+		if (ret) {
+			printf("ERROR: could not scan %s\n", path);
+			close (fd);
+			continue;
+		}
+
 		close(fd);
 		if (update_kernel)
 			btrfs_register_one_device(path);
-- 
1.7.1

