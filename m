Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7418 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750937AbaFJIwG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jun 2014 04:52:06 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH] btrfs: When devices with same dev uuid occurs, only add the one with largest generation.
Date: Tue, 10 Jun 2014 16:53:07 +0800
Message-ID: <1402390387-28730-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since btrfs currently use dulicated dev uuid when doing device replace,
the following problem will happen:

1) mount with device A missing using degraded mode.
2) replace device A with device B.
3) device A reappears.
4) umount btrfs fs.
5) mount btrfs fs.

After step 5), btrfs will still use device A even device B has a larger
generation.

The patch will judge generation when difference device with same dev
uuid.
And the patch should be applied after Anand's patch:
https://patchwork.kernel.org/patch/4309651/

Cc: Anand Jain <Anand.Jain@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0a5017a..07f0cf7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -508,7 +508,8 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-	} else if (!device->name || strcmp(device->name->str, path)) {
+	} else if (!device->name || (strcmp(device->name->str, path) &&
+		   found_transid > device->generation)) {
 		/*
 		 * When FS is already mounted.
 		 * 1. If you are here and if the device->name is NULL that means
-- 
2.0.0

