Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:56461 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3HZRr0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 13:47:26 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 538FF9A04FA
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 11:47:26 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id saCfL6ppMBP53snR (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 11:47:25 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: adjust the fs_devices->missing count on unmount
Date: Mon, 26 Aug 2013 13:47:23 -0400
Message-ID: <1377539243-5515-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed that if I tried to mount a file system with -o degraded after having
done it once already we would fail to mount.  This is because the
fs_devices->missing count was getting bumped everytime we mounted, but not
getting reset whenever we unmounted.  To fix this we just drop the missing count
as we're closing devices to make sure this doesn't happen.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/volumes.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 74614e3..f42e412 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -673,6 +673,8 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 
 		if (device->can_discard)
 			fs_devices->num_can_discard--;
+		if (device->missing)
+			fs_devices->missing_devices--;
 
 		new_device = btrfs_alloc_device(NULL, &device->devid,
 						device->uuid);
-- 
1.7.7.6

