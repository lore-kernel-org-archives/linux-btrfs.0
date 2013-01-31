Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:33919 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754082Ab3AaAGj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:06:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/11] btrfs: don't try to notify udev about missing devices
Date: Wed, 30 Jan 2013 18:55:02 -0600
Message-Id: <1359593702-53056-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we remove a missing device, bdev is null, and if we
send that off to btrfs_kobject_uevent we'll panic.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/volumes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 09c63ac..bdd6962 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1556,7 +1556,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	ret = 0;
 
 	/* Notify udev that device has changed */
-	btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
+	if (bdev)
+		btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
 
 error_brelse:
 	brelse(bh);
-- 
1.7.1

