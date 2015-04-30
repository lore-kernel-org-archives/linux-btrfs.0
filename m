Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbD3JHg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 05:07:36 -0400
From: xuw2015@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: George Wang <xuw2015@gmail.com>
Subject: [PATCH 3/3] btrfs: do not allow device path updated by the stale one
Date: Thu, 30 Apr 2015 17:07:25 +0800
Message-Id: <1430384845-9666-3-git-send-email-xuw2015@gmail.com>
In-Reply-To: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>
References: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: George Wang <xuw2015@gmail.com>

Use the btrfs_device->generation to identify which device(with same devid and
dev_uuid) is newer, and never allow the path updated by the stale one.
The btrfs_device->generation is corresponded with transaction id, which is
increased from old to new. Whether the fs_devices opened or not, stale device
can never get effective.

Signed-off-by: George Wang <xuw2015@gmail.com>
---
 fs/btrfs/disk-io.c | 3 +++
 fs/btrfs/volumes.c | 5 ++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 342d4fc..25faa53 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3508,6 +3508,9 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
+		/* update device generation according to disk super */
+		dev->generation = sb->generation;
+
 		btrfs_set_stack_device_generation(dev_item, 0);
 		btrfs_set_stack_device_type(dev_item, dev->type);
 		btrfs_set_stack_device_id(dev_item, dev->devid);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c8ece13..de6968d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -525,10 +525,9 @@ static noinline int device_list_add(const char *path,
 		 * tracking a problem where systems fail mount by subvolume id
 		 * when we reject replacement on a mounted FS.
 		 */
-		if (!fs_devices->opened && found_transid < device->generation) {
+		if (found_transid < device->generation) {
 			/*
-			 * That is if the FS is _not_ mounted and if you
-			 * are here, that means there is more than one
+			 * If you are here, that means there is more than one
 			 * disk with same uuid and devid.We keep the one
 			 * with larger generation number or the last-in if
 			 * generation are equal.
-- 
1.9.3

